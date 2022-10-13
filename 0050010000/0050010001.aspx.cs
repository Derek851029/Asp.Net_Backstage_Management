using Newtonsoft.Json;
using System;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using log4net;

public partial class _0050010001 : System.Web.UI.Page
{
    //static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetWorkLogs()
    {
        var workLogList = WorkLogs.Search();
        return JsonConvert.SerializeObject(workLogList);
    }

    [WebMethod(EnableSession = true)]
    public static string bindSelect_ListCase()
    {
        var caseList = Case_List.Search("","","");
        return JsonConvert.SerializeObject(caseList);
    }


    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Work_Log(string Log_ID)
    {
        string Sqlstr = @"SELECT TOP 1 SYSID, Create_Time, Create_ID, Create_Agent, Update_Time
                            , Update_ID, Update_Agent, Work_Log FROM Work_Log Where SYSID=@Log_ID ";
        var a = DBTool.Query<WorkLogs>(Sqlstr, new { Log_ID = Log_ID }).ToList();
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    /// <summary>
    /// 新增(0)或編輯(1)工作日誌
    /// </summary>
    /// <param name="Flag">0:新增 1:修改</param>
    /// <param name="work_log">工作日誌</param>
    /// <param name="log_id">工作日誌資料編號</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Add_Or_Edit_WorkLog(int Flag = 0,int caseListID = 0, string work_log = "", string log_id = "") 
    {
        string status = "new";
        string sqlCommand = @"Insert Into Work_Log (Create_ID, Create_Agent,caseListID, Work_Log) 
                                Values(@Agent_ID, @Agent_Name,@caseListID, @work_Log)";
        var workLogObject = new Input_WorkLog
        {
            Agent_ID = HttpContext.Current.Session["UserID"].ToString(),
            Agent_Name = HttpContext.Current.Session["UserIDNAME"].ToString(),
            caseListID = caseListID,
            work_log = work_log,
            log_id = log_id
        };
        try
        {
            if (Flag == 1)
            {
                status = "update";
                sqlCommand = @"Update Work_Log 
                                Set Work_Log=@work_Log
                                    , Update_Time=Getdate() 
                                    , caseListID=@caseListID
                                    , Update_ID=@Agent_ID, Update_Agent=@Agent_Name Where SYSID=@log_id ";
            }
            DBTool.Query(sqlCommand, workLogObject);
            return JsonConvert.SerializeObject(new { status = status });
        }
        catch (Exception err)
        {
            return JsonConvert.SerializeObject(new { status = "程式發生錯誤  err=" + err });
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetPartnerList(string s_date, string e_date, string log)
    {
        DateTime Date;
        string sqlstr = @" Select SYSID, Create_Time, Create_ID, Create_Agent, Update_Time
            , Update_ID, Update_Agent, Work_Log FROM Work_Log ORDER BY Create_Time DESC";

        if (!String.IsNullOrEmpty(s_date))
        {
            if (!DateTime.TryParse(s_date, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "開始日期格式錯誤 (yyyy/MM/dd)" });
            }
            else
                sqlstr += " AND CONVERT(varchar(100), Create_Time, 23) >= @s_date ";
        }
        if (!String.IsNullOrEmpty(e_date))
        {
            if (!DateTime.TryParse(e_date, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "結束日期格式錯誤 (yyyy/MM/dd)" });
            }
            else
                sqlstr += " AND CONVERT(varchar(100), Create_Time, 23) <= @e_date ";
        }
        if (log != "")
        {
            sqlstr += " AND Work_Log Like '%'+@log+'%' ";
        }
        sqlstr += " Order by Create_Time desc ";

        var a = DBTool.Query<WorkLogs>(sqlstr, new
        {
            s_date = s_date,
            e_date = e_date,
            log = log,
        }).ToList().Select(p => new
        {
            SYSID = Value(p.SYSID),
            Create_Time = Check_Date(p.Create_Time.ToString("yyyy/MM/dd HH:mm")),
            Create_ID = Value(p.Create_ID),
            Create_Agent = Value(p.Create_Agent),
            Update_Time = Check_Date(p.Update_Time.ToString("yyyy/MM/dd HH:mm")),
            Update_ID = Value(p.Update_ID),
            Update_Agent = Value(p.Update_Agent),
            Work_Log = Value(p.Work_Log),
        });
        return JsonConvert.SerializeObject(a);
    }

    public static void Check()
    {
        string Check = JASON.Check_ID("0050010001.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string URL(string Case_ID)
    {
        //Check();
        //PID = PID.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(Case_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error + "_1" });
        }

        string str_url = "../0030010097.aspx?seqno=" + Case_ID;         //打開0060010000 並放入同PID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)] 
    public static string URL2(string Case_ID)
    {
        //Check();
        //PID = PID.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(Case_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error + "_1" });
        }

        string str_url = "../0030010099.aspx?seqno=" + Case_ID;         //打開0060010000 並放入同PID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }

    public static string Value(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
        }
        return value;
    }
    public static string Check_Date(string value)        // 當值為null時跳過  非 null 時改時間格式
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = DateTime.Parse(value).ToString("yyyy/MM/dd HH:mm");
        }
        return value;
    }
    public static string Value3(string value, string value2)        // 當value值為""  非 value=value2
    {
        if (string.IsNullOrEmpty(value))
        {
            value = value2.Trim();
        }
        else
            value = value.Trim();
        return value;
    }
    public static string Test(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
            if (value == "1900/01/01 12:00")
            {
                value = "";
            }
        }
        return value;
    }

    public class Input_WorkLog
    {
        public string Agent_ID { get; set; }
        public string Agent_Name { get; set; }
        public int caseListID { get; set; }
        public string work_log { get; set; }
        public string log_id { get; set; }
    }

    public class T_0050010001
    {
        public string PID { get; set; }
        public string BUSINESSNAME { get; set; }
        public string BUSINESSID { get; set; }
        public string ID { get; set; }
        public string BUS_CREATE_DATE { get; set; }
        public string APPNAME { get; set; }
        public string APP_SUBTITLE { get; set; }
        public string APP_MTEL { get; set; }
        public string APP_SUBTITLE_2 { get; set; }
        public string APP_EMAIL_2 { get; set; }
        public string REGISTER_ADDR { get; set; }
        public string CONTACT_ADDR { get; set; }
        public string APP_FTEL { get; set; }
        public string INVOICENAME { get; set; }
        public string Inads { get; set; }
        public string Mail_Type { get; set; }
        public string OE_Number { get; set; }
        public string SalseAgent { get; set; }
        public string Salse { get; set; }
        public string Salse_TEL { get; set; }
        public string SID { get; set; }
        public string Serial_Number { get; set; }
        public string License_Host { get; set; }
        public string Licence_Name { get; set; }
        public string LAC { get; set; }
        public string Our_Reference { get; set; }
        public string Your_Reference { get; set; }
        public string Auth_File_ID { get; set; }
        public string FL { get; set; }
        public string Group_Name_ID { get; set; }
        public string SED { get; set; }
        public string Warranty_Date { get; set; }
        public string Warr_Time { get; set; }
        public string Protect_Date { get; set; }
        public string Prot_Time { get; set; }
        public string Receipt_Date { get; set; }
        public string Receipt_PS { get; set; }
        public string Close_Out_Date { get; set; }
        public string Close_Out_PS { get; set; }
        public string Account_PS { get; set; }
        public string Information_PS { get; set; }
        public string SetupDate { get; set; }
        public string Del_Flag { get; set; }
        public string UpdateDate { get; set; }
        //0628 子公司
        public string PNumber { get; set; }
        public string Name { get; set; }
        public string Contac_ADDR { get; set; }

        public string Case_ID { get; set; }
        public string SetupTime { get; set; }
        public string Caller_ID { get; set; }
        public string Creat_Agent { get; set; }
        public string ADDR { get; set; }
        public string Telecomm_ID { get; set; }
        public string APP_EMAIL { get; set; }
        public string SERVICEITEM { get; set; }
        public string APPNAME_2 { get; set; }
        public string ID_2 { get; set; }
        public string APP_MTEL_2 { get; set; }
        public string ADDR_2 { get; set; }
        public string HardWare_2 { get; set; }
        public string SoftwareLoad_2 { get; set; }
        public string Urgency { get; set; }
        public string OnSpotTime { get; set; }
        public string OpinionType { get; set; }
        public string ReplyType { get; set; }
        public string OpinionContent { get; set; }
        public string Handle_Agent { get; set; }
        public string PS { get; set; }
        public string Reply { get; set; }
        public string UploadTime { get; set; }
        public string ReachTime { get; set; }
        public string FinishTime { get; set; }
        public string Agent_ID { get; set; }
        public string Type { get; set; }
        public string Type_Value { get; set; }
        public string C_ID2 { get; set; }
        public string Agent_Company { get; set; }
    }
}
