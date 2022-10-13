using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Windows.Forms;
using log4net;
using log4net.Config;


public partial class _0020010007 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected string Back = "";
    protected string str_type;
    protected string title = "瀏覽";

    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        if (!IsPostBack)
        {
            Session["Case_ID"] = Request.Params["seqno"];
            string Case_ID = Request.Params["seqno"];
            if (string.IsNullOrEmpty(Case_ID))
            {
                Response.Redirect("0020010006.aspx");
            }
            else
            {
                // 進入檢查 明細 或 修改 狀態
                _0030010001_LaborTemplate(Case_ID);
                // 進入檢查 明細 或 修改 狀態
            }
        }
    }

    // ======= 檢查欄位 =======

    protected void Btn_Back_Click(object sender, EventArgs e)
    {
        Response.Redirect("0020010006.aspx");
    }

    protected void Btn_Del_Click(object sender, EventArgs e)
    {
        Check();
        Back = Request.Form["Back"];
        string back_txt = "";

        List<XXS> check_value = new List<XXS>();
        check_value.Add(new XXS { URL_ID = Back, MiniLen = 1, MaxLen = 100, Alert_Name = "退單原因", URL_Type = "txt" });
        JavaScriptSerializer Serializer = new JavaScriptSerializer();
        string outputJson = Serializer.Serialize(check_value);
        back_txt = JASON.Check_XSS(outputJson);
        if (back_txt != "")
        {
            RegisterStartupScript(back_txt);
            return;
        };

        string Case_ID_value = (string)(Session["Case_ID"]);
        string UserID = (string)(Session["UserID"]);
        string UserIDNAME = (string)(Session["UserIDNAME"]);
        ClassTemplate template = new ClassTemplate()
        {
            Case_ID = Case_ID_value,
            Type = "退單",
            Type_Value = "5",  //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
            Chargeback = Back,
            Close_ID = UserID,
            Close_Name = UserIDNAME,
            Close_Time = DateTime.Now
        };

        string sqlstr = @"UPDATE [dbo].[LaborTemplate] SET " +
            "Type=@Type, " +
            "Type_Value=@Type_Value, " +
            "Chargeback=@Chargeback, " +
            "Close_ID=@Close_ID, " +
            "Close_Name=@Close_Name, " +
            "Close_Time=@Close_Time " +
            "WHERE Case_ID=@Case_ID";

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, template);

        //=============  EMMA =============
        // 1. 勞工需求單（審核）     
        // 2. 員工派工管理（瀏覽）  
        // 3. 個人派工及結案管理（瀏覽）
        // 4. 勞工需求單（瀏覽） 結案，退單
        string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
        string EMMA = URL + "CheckLogin.aspx?seqno=" + Case_ID_value + "&page=4&login=";

        sqlstr = @"SELECT Cust_Name, ServiceName, Agent_Mail, UserID FROM LaborTemplate WHERE Case_ID=@Case_ID";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { Case_ID = Case_ID_value });
        if (list.Count() > 0)
        {
            string sql = @"INSERT INTO [dbo].[tblAssign] " +
                "( [AssignNo], [E_MAIL], [ConnURL] ) " +
                "VALUES ( @AssignNo, @E_MAIL, @ConnURL )";
            foreach (var q in list)
            {
                ClassTemplate emma = new ClassTemplate()
                {
                    AssignNo = "【退單通知】【" + q.Cust_Name + "：" + q.ServiceName + "】",   // "審核"  "派工"  "接單"  "暫結案"  "結案"
                    ConnURL = EMMA + JASON.Encryption(q.UserID),
                    E_MAIL = q.Agent_Mail
                };
                using (IDbConnection db = DBTool.GetConn())
                    db.Execute(sql, emma);
            }
        }
        //=============  EMMA =============

        Response.Redirect("0020010006.aspx");
    }

    protected void Btn_Update_Click(object sender, EventArgs e)
    {
        Check();
        Back = Request.Form["Back"];
        string UserID = (string)(Session["UserID"]);
        string UserIDNAME = (string)(Session["UserIDNAME"]);
        string Agent_Team = (string)(Session["Agent_Team"]);
        string Case_ID_value = (string)(Session["Case_ID"]);

        ClassTemplate template = new ClassTemplate()
        {
            Case_ID = Case_ID_value,
            Type = "尚未派工",
            Type_Value = "2",  //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
            Allow_ID = UserID,
            Allow_Name = UserIDNAME,
            Allow_Time = DateTime.Now
        };

        string sqlstr = @"UPDATE [dbo].[LaborTemplate] SET " +
            "Type=@Type, " +
            "Type_Value=@Type_Value, " +
            "Allow_ID=@Allow_ID, " +
            "Allow_Name=@Allow_Name, " +
            "Allow_Time=@Allow_Time " +
            "WHERE Case_ID=@Case_ID";

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, template);

        //=============  EMMA =============
        string case_id = Case_ID_value;
        string page = "2";  // 1.  需求單審核    2.   員工派工管理  3.  個人派工及結案管理
        string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
        string EMMA = URL + "CheckLogin.aspx?seqno=" + case_id + "&page=" + page + "&login=";
        sqlstr = "SELECT TOP 1 Cust_Name, ServiceName, Create_Team FROM LaborTemplate WHERE Case_ID=@Case_ID";
        var a = DBTool.Query<ClassTemplate>(sqlstr, new { Case_ID = Case_ID_value });
        if (a.Count() > 0)
        {
            ClassTemplate v = a.First();
            sqlstr = @"SELECT * FROM Master_DATA WHERE Agent_Team=@Agent_Team AND Agent_LV = '15' ";
            var list = DBTool.Query<EMMA>(sqlstr, new { Agent_Team = v.Create_Team });
            if (list.Count() > 0)
            {
                string sql = @"INSERT INTO tblAssign ( AssignNo, E_MAIL, ConnURL ) VALUES ( @AssignNo, @E_MAIL, @ConnURL )";
                foreach (var q in list)
                {
                    ClassTemplate emma = new ClassTemplate()
                    {
                        AssignNo = "【派工通知】【" + v.Cust_Name + "：" + v.ServiceName + "】",    // "審核"  "派工"  "接單"  "暫結案"  "結案"
                        ConnURL = EMMA + JASON.Encryption(q.UserID),
                        E_MAIL = q.E_Mail
                    };
                    using (IDbConnection db = DBTool.GetConn())
                        db.Execute(sql, emma);
                }
            }
        }
        //=============  EMMA =============

        Response.Redirect("0020010006.aspx");
    }

    // ========= 帶入資料 ===========
    private void _0030010001_LaborTemplate(string Case_ID)
    {
        Check();
        string sql_txt = @"SELECT TOP 1 SYS_ID FROM LaborTemplate WHERE Case_ID=@Case_ID";
        var chk = DBTool.Query<ClassTemplate>(sql_txt, new { Case_ID = Case_ID });
        if (!chk.Any())
        {
            Response.Redirect("0020010006.aspx");
        };

        ClassTemplate schedule = ClassScheduleRepository._0030010001_View_Case_ID(Case_ID);
        #region 對應資料

        //hid_seqno.Value = schedule.SYS_ID.ToString();
        hid_seqno.Value = schedule.Case_ID;
        str_sysid.Text = schedule.Case_ID;
        str_name.Text = schedule.Create_Name;

        DropService.Text = schedule.Service;
        string service = schedule.Service;
        if (service == "接送")
        {
            Hospital_Table_1.Style.Add("display", "none");
        }
        else if (service == "教育訓練")
        {
            PathTable.Style.Add("display", "none");
            Hospital_Table_1.Style.Add("display", "none");
        }
        else if (service == "醫療")
        {
        }
        else
        {
            PathTable.Style.Add("display", "none");
            PathStartTable.Style.Add("display", "none");
            Hospital_Table_1.Style.Add("display", "none");
        }

        DropServiceName.Text = schedule.ServiceName;
        Time_01.Text = schedule.Time_01.ToString("yyyy/MM/dd HH:mm");
        Time_02.Text = schedule.Time_02.ToString("yyyy/MM/dd HH:mm");
        Labor_Team.Text = schedule.Labor_Team;
        Cust_Name.Text = schedule.Cust_Name;
        Select_Labor.Text = schedule.Labor_CName;
        label_labor_id.Text = schedule.Labor_ID;
        label_Labor_PID.Text = schedule.Labor_PID;
        label_Labor_RID.Text = schedule.Labor_RID;
        label_Labor_EID.Text = schedule.Labor_EID;
        Labor_Country.Text = schedule.Labor_Country;
        Labor_Language.Text = schedule.Labor_Language;
        Labor_Phone.Text = schedule.Labor_Phone;
        Labor_Address.Text = schedule.Labor_Address;
        Labor_Address2.Text = schedule.Labor_Address2;
        Location.Text = schedule.Location;
        LocationStart.Text = schedule.LocationStart;
        LocationEnd.Text = schedule.LocationEnd;
        txt_CarSeat.Text = schedule.CarSeat;
        ContactName.Text = schedule.ContactName;
        ContactPhone.Text = schedule.ContactPhone;
        ContactPhone2.Text = schedule.ContactPhone2;
        ContactPhone3.Text = schedule.ContactPhone3;
        Contact_TEL.Text = schedule.Contact_TEL;
        Contact_Co_TEL.Text = schedule.Contact_Co_TEL;
        DropHospitalName.Text = schedule.Hospital;
        HospitalClass.Text = schedule.HospitalClass;
        Question.Text = schedule.Question;
        Chargeback.Text = schedule.Chargeback;

        Btn_Update.Style.Add("display", "none");
        Btn_Del.Style.Add("display", "none");
        Back_Table_1.Style.Add("display", "none");
        Back_Table_2.Style.Add("display", "none");
        //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單

        switch (schedule.Type_Value)
        {
            case "0":
                str_type = "取消";
                title = "取消";
                break;
            case "1":
                str_type = "尚未審核";
                title = "尚未審核";
                Btn_Update.Style.Add("display", "");
                Btn_Del.Style.Add("display", "");
                Back_Table_1.Style.Add("display", "");
                break;
            case "2":
                str_type = "尚未派工";
                title = "已審核";
                break;
            case "3":
                str_type = "尚未結案";
                title = "已審核";
                break;
            case "4":
                str_type = "已經結案";
                title = "已審核";
                break;
            case "5":
                str_type = "退單";
                title = "已被退單";
                Back_Table_2.Style.Add("display", "");
                break;
        }
        #endregion
    }

    private void RegisterStartupScript(string msg)
    {
        if (ScriptManager.GetCurrent(this.Page) == null)
        {
            Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "buttonStartup", "alert('" + msg + "');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "buttonStartupBySM", "alert('" + msg + "');", true);
        }
    }

    public static void Check()
    {
        string Check = JASON.Check_ID("0020010006.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }
}