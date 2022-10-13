using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using log4net.Config;

public partial class _0040010001 : System.Web.UI.Page
{
    protected string str_time;
    protected string str_day;
    protected string str_type;
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        if (!string.IsNullOrEmpty(Request.Params["date"]))
        {
            str_day = Request.Params["date"];
            str_type = Request.Params["type"];
        }
        else
        {
            str_day = DateTime.Now.ToString("yyyy-MM-dd");
            str_type = "2";
        }

        switch (Request.Params["str_time"])
        {
            case "1":
                str_time = "1";
                break;
            case "2":
                str_time = "2";
                break;
            default:
                str_time = "0";
                break;
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0040010001.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }


    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end, string time)
    {
        Check();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        return JsonConvert.SerializeObject(ClassScheduleRepository._0040010001_GetClassGroup(start, end, Agent_Team, Agent_LV, time), Formatting.Indented);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date, string Type, string str_time)
    {
        Check();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Create_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        var a = ClassScheduleRepository._0040010001_ClassScheduleList(date, Type, Create_Team, Agent_LV, str_time)
            .Select(p => new
            {
                SYSID = p.SYSID,
                SYS_ID = p.SYS_ID,
                Case_ID = p.Case_ID,// 需求單編號
                Type = p.Type,// 狀態
                Type_Value = p.Type_Value,// 狀態編號
                ServiceName = p.ServiceName,// 服務內容
                Labor_CName = p.Labor_CName,// 勞工姓名
                Labor_ID = p.Labor_ID,// 勞工編號
                Question = p.Question, // 狀況說明
                Cust_Name = p.Cust_Name,// 填單人員姓名
                Create_Name = p.Create_Name,// 填單人員編號
                Time_01 = p.Time_01.ToString("MM/dd HH:mm"), //填單日期
            });

        return JsonConvert.SerializeObject(a);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Close_Flag(string SYS_ID, string MNo, string ServiceName, string Cust_Name, string Create_Name)
    {
        Check();
        string ID = HttpContext.Current.Session["UserID"].ToString();
        string NAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string login = "";
        string mail = "";
        string back = "";
        try
        {
            string sqlstr = @"SELECT SYSID, CNo FROM CASEDetail WHERE MNo=@MNo AND FinalUpdateDate is NULL";
            var cno_list = DBTool.Query<ClassTemplate>(sqlstr, new { MNo = MNo });
            if (cno_list.Any())
            {
                back += "【派工單】案件尚未完成\n";
                foreach (var var in cno_list)
                {
                    back += "【" + var.CNo + "】\n";
                }
                return JsonConvert.SerializeObject(new { status = back += "案件狀態須為【暫結案】。" });
            }
            else
            {
                ClassTemplate update = new ClassTemplate()
                {
                    MNo = MNo,
                    Type = "已經結案",
                    Type_Value = "4",  //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
                    Close_ID = ID,
                    Close_Name = NAME,
                    Close_Time = DateTime.Now,
                    Answer = "【快速結案功能】"
                };

                sqlstr = @"UPDATE LaborTemplate SET " +
                    "Type=@Type, " +
                    "Type_Value=@Type_Value, " +
                    "Close_ID=@Close_ID, " +
                    "Close_Name=@Close_Name, " +
                    "Close_Time=@Close_Time, " +
                    "Answer=@Answer " +
                    "WHERE MNo=@MNo";

                using (IDbConnection db = DBTool.GetConn())
                {
                    db.Execute(sqlstr, update);
                    db.Close();
                }
                //=============  EMMA =============       
                sqlstr = @"SELECT TOP 1 UserID, Agent_Mail FROM LaborTemplate WHERE MNo=@MNo AND Agent_Mail != '' ";
                var list = DBTool.Query<ClassTemplate>(sqlstr, new { MNo = MNo });
                if (list.Any())
                {
                    ClassTemplate schedule = list.First();
                    login = schedule.UserID;
                    mail = schedule.Agent_Mail;

                    string page = "4";  // 1.  需求單審核    2.   員工派工管理  3.  個人派工及結案管理
                    string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
                    string EMMA = URL + "CheckLogin.aspx?seqno=" + MNo + "&page=" + page + "&login=" + JASON.Encryption(login);
                    string AssignNo = "【結案通知】【" + Cust_Name + "：" + ServiceName + "】【填單人員：" + Create_Name + "】";
                    ClassTemplate emma = new ClassTemplate()
                    {
                        AssignNo = HttpUtility.HtmlEncode(AssignNo),  // "審核"  "派工"  "接單"  "暫結案"  "結案"
                        E_MAIL = mail,
                        ConnURL = EMMA
                    };
                    sqlstr = @"INSERT INTO tblAssign (AssignNo ,E_MAIL ,ConnURL) VALUES(@AssignNo ,@E_MAIL ,@ConnURL)";
                    using (IDbConnection db = DBTool.GetConn())
                    {
                        db.Execute(sqlstr, emma);
                        db.Close();
                    }
                }
                else
                {
                    logger.Info("ERROR：人員【" + ID + "】快速結案發送 EMMA 時，該需求單【" + MNo + "】 Agent_Mail 與 UserID 為 NULL。");
                }
                //=============  EMMA =============

                return JsonConvert.SerializeObject(new { status = "【快速結案】已完成。" });
            }
        }
        catch (Exception err)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
    }
}