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

public partial class _0030010002 : System.Web.UI.Page
{
    protected string str_time;
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        //Check();
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end, string time)
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();

      string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Type_Value as value, CONVERT(varchar(100), Upload_Time, 111) as start " +
          " FROM DimaxCallcenter.dbo.CaseData " +
           " GROUP by Type_Value,Type,CONVERT(varchar(100), Upload_Time, 111) ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

        var a = DBTool.Query<T_0030010002>(sqlstr, new      //行事曆案件整理
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

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date, string Type)       //案件列表程式
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();

        string sqlstr2 = @" select ReplyType,  Upload_Time, EstimatedFinishTime, Urgency, Case_ID, ID, Cust_Name, OpinionSubject, Type " +
           " From [DimaxCallcenter].[dbo].[CaseData]  WHERE Type = @Type AND CONVERT(varchar(100), Upload_Time, 111) = @date ";      //    AND date = @date

        var a = DBTool.Query<T_0030010002_2>(sqlstr2, new 
             {
                 date = date,
                 //ednDate = end,        //不知道end該改啥 暫用date頂替
                 Type = Type,
                 Agent_Team = Agent_Team,
                 Agent_ID = Agent_ID
             });

        var b = a.ToList().Select(p => new
        {
            Case_ID = p.Case_ID,
            ReplyType = p.ReplyType,
            OpinionSubject = p.OpinionSubject,
            Type = p.Type,
            Urgency = p.Urgency,
            ID = p.ID,
            Cust_Name = p.Cust_Name,
            Upload_Time = p.Upload_Time.ToString("MM/dd HH:mm"),
            EstimatedFinishTime = p.EstimatedFinishTime.ToString("MM/dd HH:mm")
        });

        return JsonConvert.SerializeObject(b);
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

        string str_url = "../0030010100.aspx?seqno=" + mno;         //打開10099 並放入同Case_ID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0030010002");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }


    public class T_0030010002
    {
        public string title { get; set; }
        public string id { get; set; }
        public string type { get; set; }
        public string value { get; set; }
        public DateTime start { get; set; }
    }

    public class T_0030010002_2
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
    }
}