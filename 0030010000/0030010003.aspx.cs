using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using log4net.Config;

public partial class _0030010003 : System.Web.UI.Page
{
    protected string str_time;
    protected string str_view;
    protected string str_day;
    protected string str_type;
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        logger.Info("0030010000/0030010003.aspx Page_Load");
        Check();
        Session["view"] = Request.Params["view"];

        if (!string.IsNullOrEmpty(Request.Params["date"]))
        {
            str_day = Request.Params["date"];
            str_type = Request.Params["type"];
        }
        else
        {
            str_day = DateTime.Now.ToString("yyyy-MM-dd");
            str_type = "未到點";
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end, string time)
    {
        //Check();
        logger.Info("GetClassGroup");
        try
        {
            string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
            string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
            string Agent_Company = HttpContext.Current.Session["Agent_Company"].ToString(); //部門
            string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();               //職位
            string view = HttpContext.Current.Session["view"].ToString(); 

            if (Agent_Company == "Engineer" && Agent_Team != "Manager" && Agent_Team != "Leader")//    && view !="1"
            {
                string sqlstr = @"select Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Type_Value as value, " +
                " CONVERT(varchar(100), SetupTime, 111) as start " +
                " FROM CaseData where Agent_ID = @Agent_ID " +
                " GROUP by Type_Value,Type,CONVERT(varchar(100), SetupTime, 111) ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

                var a = DBTool.Query<T_0030010003>(sqlstr, new      //行事曆案件整理
                {
                    startDate = start,
                    ednDate = end,
                    Agent_Team = Agent_Team,
                    Agent_ID = Agent_ID
                });
                var b = a.ToList().Select(p => new
                {
                    title = p.title,
                    type = p.type,
                    value = p.value,
                    start = p.start.ToString("yyyy-MM-dd"),
                    id = p.id
                });
                return JsonConvert.SerializeObject(b);            //  6/8 PM1600 之前的版本
            }
            else if (view == "1" && Agent_Company == "Engineer" && (Agent_Team != "Manager" || Agent_Team != "Leader"))
            {
                string sqlstr = @"select Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Type_Value as value, " +
                " CONVERT(varchar(100), SetupTime, 111) as start " +
                " FROM CaseData where Agent_ID = @Agent_ID " +
                " GROUP by Type_Value,Type,CONVERT(varchar(100), SetupTime, 111) ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

                var a = DBTool.Query<T_0030010003>(sqlstr, new      //行事曆案件整理
                {
                    startDate = start,
                    ednDate = end,
                    Agent_Team = Agent_Team,
                    Agent_ID = Agent_ID
                });
                var b = a.ToList().Select(p => new
                {
                    title = p.title,
                    type = p.type,
                    value = p.value,
                    start = p.start.ToString("yyyy-MM-dd"),
                    id = p.id
                });
                return JsonConvert.SerializeObject(b); 
            }
            else
            {
                string sqlstr = @"select Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Type_Value as value, " +
                " CONVERT(varchar(100), SetupTime, 111) as start " +
                " FROM CaseData " +
                " GROUP by Type_Value,Type,CONVERT(varchar(100), SetupTime, 111) ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

                var a = DBTool.Query<T_0030010003>(sqlstr, new      //行事曆案件整理
                {
                    startDate = start,
                    ednDate = end,
                    Agent_Team = Agent_Team,
                    Agent_ID = Agent_ID
                });

                var b = a.ToList().Select(p => new
                {
                    title = p.title,
                    type = p.type,
                    value = p.value,
                    start = p.start.ToString("yyyy-MM-dd"),
                    id = p.id
                });
                return JsonConvert.SerializeObject(b);
            }
        }
        catch (Exception er)
        {
            logger.Info("讀取003.aspx失敗 " + er);
        }
        return JsonConvert.SerializeObject("Error");            //  6/8 PM1600 之前的版本
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Team_Check() 
    {
        string status = "";
        string Agent_Company = HttpContext.Current.Session["Agent_Company"].ToString(); //部門
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();               //職位
        if (Agent_Company == "Engineer" && (Agent_Team == "Manager" || Agent_Team == "Leader"))
            status = "leader";
        return JsonConvert.SerializeObject(new { status = status });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date, string Type)       //案件列表程式
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Company = HttpContext.Current.Session["Agent_Company"].ToString(); //部門
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();               //職位
        string view = HttpContext.Current.Session["view"].ToString();

        if (Agent_Company == "Engineer" && Agent_Team != "Manager" && Agent_Team != "Leader" )
        {
            string sqlstr2 = @" select  *,  " +
        " CONVERT(varchar(100), SetupTime, 111) From CaseData " +
        " WHERE Type = @Type AND CONVERT(varchar(100), SetupTime, 111) = @date and Agent_ID = @Agent_ID";      //    AND date = @date

            var a = DBTool.Query<T_0030010003_2>(sqlstr2, new
                 {
                     date = date,
                     //ednDate = end,        //不知道end該改啥 暫用date頂替
                     Type = Type,
                     Agent_Team = Agent_Team,
                     Agent_ID = Agent_ID
                 });
            var b = a.ToList().Select(p => new
            {
                SetupTime = p.SetupTime.ToString("MM/dd HH:mm"),
                UploadTime = p.UploadTime.ToString("MM/dd HH:mm"),
                Case_ID = p.Case_ID,
                C_ID2 = Value3(p.C_ID2, p.Case_ID),
                BUSINESSNAME = p.BUSINESSNAME,
                Urgency = p.Urgency,
                OpinionType = p.OpinionType,
                Handle_Agent = p.Handle_Agent,
                Type = p.Type,
            });
            return JsonConvert.SerializeObject(b);
        }
        else if (view == "1" && Agent_Company == "Engineer" && (Agent_Team != "Manager" || Agent_Team != "Leader")) 
        {
            string sqlstr2 = @" select  *,  " +
    " CONVERT(varchar(100), SetupTime, 111) From CaseData " +
    " WHERE Type = @Type AND CONVERT(varchar(100), SetupTime, 111) = @date and Agent_ID = @Agent_ID";      //    AND date = @date

            var a = DBTool.Query<T_0030010003_2>(sqlstr2, new
            {
                date = date,
                //ednDate = end,        //不知道end該改啥 暫用date頂替
                Type = Type,
                Agent_Team = Agent_Team,
                Agent_ID = Agent_ID
            });
            var b = a.ToList().Select(p => new
            {
                SetupTime = p.SetupTime.ToString("MM/dd HH:mm"),
                UploadTime = p.UploadTime.ToString("MM/dd HH:mm"),
                Case_ID = p.Case_ID,
                C_ID2 = Value3(p.C_ID2, p.Case_ID),
                BUSINESSNAME = p.BUSINESSNAME,
                Urgency = p.Urgency,
                OpinionType = p.OpinionType,
                Handle_Agent = p.Handle_Agent,
                Type = p.Type,
            });
            return JsonConvert.SerializeObject(b);
        }
        else
        {
            string sqlstr2 = @" select  *,  " +
            " CONVERT(varchar(100), SetupTime, 111) From CaseData " +
            " WHERE Type = @Type AND CONVERT(varchar(100), SetupTime, 111) = @date ";      //    AND date = @date

            var a = DBTool.Query<T_0030010003_2>(sqlstr2, new
                 {
                     date = date,
                     //ednDate = end,        //不知道end該改啥 暫用date頂替
                     Type = Type,
                     Agent_Team = Agent_Team,
                     Agent_ID = Agent_ID
                 });
            var b = a.ToList().Select(p => new
            {
                SetupTime = p.SetupTime.ToString("MM/dd HH:mm"),
                UploadTime = p.UploadTime.ToString("MM/dd HH:mm"),
                Case_ID = p.Case_ID,
                C_ID2 = Value3(p.C_ID2, p.Case_ID),
                BUSINESSNAME = p.BUSINESSNAME,
                Urgency = p.Urgency,
                OpinionType = p.OpinionType,
                Handle_Agent = p.Handle_Agent,
                Type = p.Type,
            });
            return JsonConvert.SerializeObject(b);
        }        
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]

    public static string URL(string mno)
    {
        //Check();
        mno = mno.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(mno) != true)
        {
            return JsonConvert.SerializeObject(new { status = error+"_1" });
        }

        if (mno.Length > 16 || mno.Length < 1)
        {
            return JsonConvert.SerializeObject(new { status = error + "_2" });
        }

        if (mno != "0")
        {
            string sqlstr = @"SELECT TOP 1 Case_ID FROM [DimaxCallcenter].[dbo].[CaseData] WHERE Case_ID=@Case_ID ";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { Case_ID = mno });

            if (!a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "查無【" + mno + "】需求單編號。", type = "no" });
            };
        };

        string str_url = "../0030010097.aspx?seqno=" + mno;         //打開10099 並放入同Case_ID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0030010003");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
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

    public class T_0030010003
    {
        public string title { get; set; }
        public string id { get; set; }
        public string type { get; set; }
        public string value { get; set; }
        public DateTime start { get; set; }
    }

    public class T_0030010003_2
    {
        public string title { get; set; }
        public string end { get; set; }
        public string id { get; set; }
        public string type { get; set; }
        public string value { get; set; }
        public string Case_ID { get; set; }
        public string ReplyType { get; set; }
        public string OpinionSubject { get; set; }
        public string Type { get; set; }
        public string Urgency { get; set; }
        public string ID { get; set; }
        public string Cust_Name { get; set; }
        public DateTime start { get; set; }
        public DateTime Upload_Time { get; set; }
        public DateTime EstimatedFinishTime { get; set; }
        public DateTime SetupTime { get; set; }
        public DateTime UploadTime { get; set; }
        public string BUSINESSNAME { get; set; }
        public string OpinionType { get; set; }
        public string Handle_Agent { get; set; }
        public string C_ID2 { get; set; }
    }
}