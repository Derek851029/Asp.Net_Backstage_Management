using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Windows.Forms;
using log4net;
using log4net.Config;

public partial class _0020010008 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected string str_title;
    protected string str_type;
    protected string Answer3;
    protected string seqno;

    protected void Page_Load(object sender, EventArgs e)
    {
        //Time = DateTime.Now.ToString("yyyy/MM/dd HH:mm");
        string Agent_Phone = (string)(Session["Agent_Phone"]);
        string Agent_Name = (string)(Session["UserIDNAME"]);

        if (!IsPostBack)
        {
            //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
            //Btn_Report.Style.Add("display", "none");
            //Btn_A.Style.Add("display", "none");
            Btn_B.Style.Add("display", "none");
            Btn_C.Style.Add("display", "none");
            Tr1.Style.Add("display", "none");
            Tr2.Style.Add("display", "none");
            Tr3.Style.Add("display", "none");
            Tr4.Style.Add("display", "none");
            Answer3_Table.Style.Add("display", "none");
            Torna_Table.Style.Add("display", "none");

            seqno = Request.Params["seqno"];
            if (string.IsNullOrEmpty(seqno))
            {
                Response.Redirect("0020010005.aspx");
            }
            else
            {
                //===== 先呼叫子單資訊 =====
                CNo(seqno);
            }
        }
    }

    protected void Btn_Back_Click(object sender, EventArgs e)
    {
        Response.Redirect("0020010005.aspx");
    }

    protected void Btn_Report_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Report/Report_001.aspx?seqno=" + Request.Params["seqno"]);
    }
    //=============== 到點 按鈕 ===============

    protected void Btn_A_Click_(object sender, EventArgs e)
    {
        string Agent_Name = (string)(Session["UserIDNAME"]);
        string Agent_ID = (string)(Session["UserID"]);

        ClassTemplate update = new ClassTemplate()
        {
            str_time = DateTime.Now.ToString("yyyy/MM/dd HH:mm"),
            Agent_Name = Agent_Name,
            Agent_ID = Agent_ID,
            CNo = Request.Params["seqno"],
            Type = "已到點",
            Type_Value = "3"  //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
        };

        logger.Info("Agent_Name = " + update.Agent_Name + " , Agent_ID = " + update.Agent_ID + " , str_time = " + update.str_time + " , CNo = " + update.CNo);
        string sqlstr = @"UPDATE [dbo].[CASEDetail]
                          SET Type=@Type, Type_Value=@Type_Value, UpdateDate =@str_time, UpdateUser = @Agent_Name, UpdateUserID = @Agent_ID
                          WHERE CNo=@CNo";

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);
        Response.Redirect("0020010005.aspx");
    }

    //=============== 完成 按鈕 ===============

    protected void Btn_B_Click(object sender, EventArgs e)
    {
        string Agent_Name = (string)(Session["UserIDNAME"]);
        string Agent_ID = (string)(Session["UserID"]);

        ClassTemplate update = new ClassTemplate()
        {
            str_time = DateTime.Now.ToString("yyyy/MM/dd HH:mm"),
            Agent_Name = Agent_Name,
            Agent_ID = Agent_ID,
            CNo = Request.Params["seqno"],
            Type = "已完成",
            Type_Value = "4"  //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
        };

        logger.Info("Agent_Name = " + update.Agent_Name + " , Agent_ID = " + update.Agent_ID + " , str_time = " + update.str_time + " , CNo = " + update.CNo);
        string sqlstr = @"UPDATE [dbo].[CASEDetail]
                          SET Type=@Type, Type_Value=@Type_Value, LastUpdateDate =@str_time, LastUpdateUser = @Agent_Name, LastUpdateID = @Agent_ID
                          WHERE CNo=@CNo";

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);
        Response.Redirect("0020010005.aspx");
    }

    //=============== 結案 按鈕 ===============

    protected void Btn_C_Click(object sender, EventArgs e)
    {
        string Agent_Name = (string)(Session["UserIDNAME"]);
        string Agent_ID = (string)(Session["UserID"]);
        Answer3 = Request.Form["Answer3"];

        if (string.IsNullOrEmpty(Answer3))
        {
            RegisterStartupScript("請填寫暫結案說明");
            return;
        }

        ClassTemplate update = new ClassTemplate()
        {
            Torna = Torna.SelectedItem.Value,
            str_time = DateTime.Now.ToString("yyyy/MM/dd HH:mm"),
            Agent_Name = Agent_Name,
            Agent_ID = Agent_ID,
            CNo = Request.Params["seqno"],
            Answer2 = Answer3,
            Type = "暫結案",
            Type_Value = "5"  //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
        };

        //logger.Info("Agent_Name = " + update.Agent_Name + " , Agent_ID = " + update.Agent_ID + " , str_time = " + update.str_time + " , CNo = " + update.CNo);
        string sqlstr = @"UPDATE [dbo].[CASEDetail]
                          SET Type=@Type, Type_Value=@Type_Value, FinalUpdateDate =@str_time, FinalUpdateUser = @Agent_Name, FinalUpdateID = @Agent_ID, Answer2 = @Answer2, DEPT_Status = @Torna
                          WHERE CNo=@CNo";

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);

        //=============  EMMA =============

        string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
        string login = "";
        string mail = "";
        sqlstr = @"SELECT a.[Create_ID], b.[Agent_Mail],[USERID] FROM [Faremma].[dbo].[CASEDetail] as a, " +
            "[Faremma].[dbo].[DispatchSystem] as b " +
            "WHERE b.Agent_ID !='' AND a.Create_ID = B.Agent_ID AND a.CNo = @CNo";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { CNo = Request.Params["seqno"] });
        if (list.Any())
        {
            ClassTemplate schedule = list.First();
            login = schedule.UserID;
            mail = schedule.Agent_Mail;
        }

        string page = "2";  // 1.  需求單審核    2.   員工派工管理  3.  個人派工及結案管理
        string EMMA = URL + "CheckLogin.aspx?seqno=" + str_sysid.Text + "&page=" + page + "&login=" + JASON.Encryption(login);

        ClassTemplate emma = new ClassTemplate()
        {
            AssignNo = "【暫結案通知】【" + Cust_Name.Text + "：" + DropServiceName.Text + "】【被派人員：" + drop_Name.Text + "】",  // "審核"  "派工"  "接單"  "暫結案"  "結案"
            E_MAIL = mail,
            ConnURL = EMMA
        };
        sqlstr = @"INSERT INTO tblAssign (AssignNo ,E_MAIL ,ConnURL) " +
                          "VALUES(@AssignNo ,@E_MAIL ,@ConnURL)";
        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, emma);

        //=============  EMMA =============

        Response.Redirect("0020010005.aspx");
    }

    // ========= 帶入子單資料 ===========
    private void CNo(string seqno)
    {
        string sql_txt = @"SELECT TOP 1 SYSID FROM CASEDetail WHERE CNo=@CNo";
        var chk = DBTool.Query<ClassTemplate>(sql_txt, new { CNo = seqno });
        if (!chk.Any())
        {
            Response.Redirect("0020010005.aspx");
        };

        ClassTemplate schedule = ClassScheduleRepository._0020010008_LaborTemplate(seqno);
        #region 對應資料

        string MNo = schedule.MNo;          // 母單SYSID
        str_cno.Text = schedule.CNo;
        Time_03.Text = schedule.StartTime.ToString("yyyy/MM/dd HH:mm");
        Time_04.Text = schedule.EndTime.ToString("yyyy/MM/dd HH:mm");
        Danger.Text = schedule.Danger;
        OverTime.Text = schedule.OverTime.ToString("yyyy/MM/dd HH:mm");
        drop_company.Text = schedule.Agent_Company;
        drop_Team.Text = schedule.Agent_Team;
        drop_Name.Text = schedule.Agent_Name;
        CarAgent_Team.Text = schedule.CarAgent_Team;
        CarAgent_Name.Text = schedule.CarAgent_Name;
        CarNameList.Text = schedule.CarName;
        CarNumberList.Text = schedule.CarNumber;
        Answer2.Text = schedule.Answer;
        hid_type.Value = schedule.Type_Value;
        Label1.Text = schedule.Answer2;
        if (schedule.DEPT_Status == "1")
        {
            Label2.Text = "回診";
        }
        else
        {
            Label2.Text = "不回診";
        }

        switch (schedule.Type_Value)
        {
            case "1":
                //Btn_A.Style.Add("display", "");
                ClassTemplate update = new ClassTemplate()
                {
                    OpenDate = DateTime.Now,
                    OpenUser = (string)(Session["UserIDNAME"]),
                    OpenUserID = (string)(Session["UserID"]),
                    CNo = schedule.CNo,
                    Type = "處理中",
                    Type_Value = "2"  //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
                };
                string sqlstr = @"UPDATE [dbo].[CASEDetail] " +
                          "SET Type=@Type,Type_Value=@Type_Value,OpenDate=@OpenDate,OpenUser=@OpenUser,OpenUserID=@OpenUserID " +
                          "WHERE CNo=@CNo";
                using (IDbConnection db = DBTool.GetConn())
                    db.Execute(sqlstr, update);
                break;
            case "2":
                //Btn_A.Style.Add("display", "");
                break;
            case "3":
                Btn_B.Style.Add("display", "");
                break;
            case "4":
                if (schedule.Service == "醫療")
                {
                    Torna_Table.Style.Add("display", "");
                }
                Answer3_Table.Style.Add("display", "");
                Btn_C.Style.Add("display", "");
                break;
            case "5":
                Tr1.Style.Add("display", "");
                //Btn_Report.Style.Add("display", "");
                if (schedule.Service == "醫療")
                {
                    Tr2.Style.Add("display", "");
                }
                break;
        }

        if (schedule.Service == "接送")
        {
            Tr3.Style.Add("display", "");
            Tr4.Style.Add("display", "");
        }
        else if (schedule.Service == "教育訓練")
        {
            Tr3.Style.Add("display", "");
            Tr4.Style.Add("display", "");
        }
        else if (schedule.Service == "醫療")
        {
            Tr3.Style.Add("display", "");
            Tr4.Style.Add("display", "");
        }
        #endregion
        _0030010001_LaborTemplate(MNo);
    }

    private void _0030010001_LaborTemplate(string MNo)
    {
        ClassTemplate schedule = ClassScheduleRepository._0030010001_View_Case_ID(Case_ID);
        #region 對應資料

        hid_seqno.Value = schedule.MNo;                              // 子單SYSID
        str_sysid.Text = schedule.MNo;                                    // 母單編號
        str_name.Text = schedule.Create_Name;                   // 母單填單人
        str_Create_Team.Text = schedule.Create_Team;       // 母單填單人部門
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
        DropHospitalName.Text = schedule.Hospital;
        HospitalClass.Text = schedule.HospitalClass;
        Question.Text = schedule.Question;
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

    //============= 帶入【多選派工單】資訊 =============
    [WebMethod(EnableSession = true)]
    public static string CNo_List(string CNo)
    {
        string str_service = "";
        string str_type = "";
        string str_time = "";
        string str_agent_name = "";
        string sqlstr = @"SELECT TOP 1 * FROM View_Service WHERE CNo = @CNo";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { CNo = CNo });
        if (list.Any())
        {
            ClassTemplate schedule = list.First();
            str_time = schedule.StartTime.ToString("yyyyMMdd");
            str_service = schedule.ServiceName;
            str_type = schedule.Type;
            str_agent_name = schedule.Agent_Name;
        }
        sqlstr = @"SELECT * FROM View_Service WHERE " +
            "CONVERT(varchar, StartTime, 112) = @StartTime AND " +
            "ServiceName = @ServiceName AND " +
            "Type = @Type AND " +
            "Agent_Name = @Agent_Name AND " +
            "Type_Value != '4' ";

        var a = DBTool.Query<ClassTemplate>(sqlstr, new
        {
            StartTime = str_time,
            ServiceName = str_service,
            Type = str_type,
            Agent_Name = str_agent_name
        }).ToList().Select(p => new
        {
            SYSID = p.SYSID,
            CNo = p.CNo,
            StartTime = p.StartTime.ToString("MM/dd" + " " + "HH" + ":" + "mm"),
            Type = p.Type,
            ServiceName = p.ServiceName,
            Cust_Name = p.Cust_Name,
            Labor_CName = p.Labor_CName,
            Question = p.Question,
            Agent_Name = p.Agent_Name
        });

        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 【Btn_A_Click】 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Btn_A_Click(string Agent_Name, string Agent_ID, string CNo, string[] Array)
    {
        ClassTemplate update = new ClassTemplate()
        {
            str_time = DateTime.Now.ToString("yyyy/MM/dd HH:mm"),
            Agent_Name = Agent_Name,
            Agent_ID = Agent_ID,
            CNo = CNo,
            Type = "已到點",
            Type_Value = "3"  //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
        };

        string sqlstr = @"UPDATE CASEDetail SET " +
            "Type=@Type, " +
            "Type_Value=@Type_Value, " +
            "UpdateDate =@str_time, " +
            "UpdateUser = @Agent_Name, " +
            "UpdateUserID = @Agent_ID " +
            "WHERE CNo=@CNo";

        if (Array.Length != 0)
        {
            sqlstr += " OR SYSID IN ( ";
            for (int i = 0; i < Array.Length; i++)
            {
                sqlstr += "'" + Array[i] + "',";
            }
            sqlstr = sqlstr.Substring(0, sqlstr.Length - 1);
            sqlstr += " ) ";
        }

        logger.Info(sqlstr);

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    public string Case_ID { get; set; }
}