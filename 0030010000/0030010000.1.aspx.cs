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
using Dapper;
using log4net;
using log4net.Config;

public partial class _0030010000 : System.Web.UI.Page
{
    protected string str_time;
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        //Check();
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load()
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string status = "null";
        string outputJson; 
        string Sqlstr = @"SELECT TOP 1 * FROM Daily_Itinerary WHERE Agent_ID = @Agent_ID AND Day = @day";      // 員工名單內且未離職
        var chk = DBTool.Query<ClassTemplate>(Sqlstr, new { Agent_ID = Agent_ID, day = DateTime.Now.ToString("yyyy-MM-dd") });
        if (!chk.Any())
        {
            status = "空的";
            return JsonConvert.SerializeObject(new { status = status });
        }
        else
        {
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                Agent_ID = Agent_ID,
                day = DateTime.Now.ToString("yyyy-MM-dd")
            }).ToList().Select(p => new
            {
                Work = Value3(p.Work)
            }); //*/
            outputJson = JsonConvert.SerializeObject(a);
            return outputJson;
        }
        return JsonConvert.SerializeObject(new { status = status });
        //return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end, string time)
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();

        string sqlstr = @"select CONVERT(varchar(100), To_W_Time, 8) as title, Job_Agent, " + //Schedule +' '+ Work as title,
            " CONVERT(varchar(100), [Off_W_Time], 8) as title2,  Day as start, Schedule  " +
            " FROM Daily_Itinerary " +
            " where Agent_ID = @Agent_ID ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

        var a = DBTool.Query<T_0030010000>(sqlstr, new      //行事曆案件整理
        {
            startDate = start,
            ednDate = end,
            Agent_Team = Agent_Team ,
            Agent_ID = Agent_ID
        });
        var b = a.ToList().Select(p => new
        {
            //title = "上班" + Value0(p.title) + "\n下班" + Value0(p.title2)+"\n"+p.Schedule,
            title = Value4(p.title, p.title2, p.Schedule, p.Job_Agent),
            Schedule = p.Schedule,
            type = p.type,
            value = Value5(p.Schedule),
            start = p.start.ToString("yyyy-MM-dd"),
            id = p.id,
        });
        return JsonConvert.SerializeObject(b);            //  6/8 PM1600 之前的版本

    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date)       //案件列表程式
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();

        string sqlstr2 = @" select CONVERT(varchar(100), Day, 23) as D, * From Daily_Itinerary " +
           " WHERE  Day = @date and Agent_ID = @Agent_ID ";      //    AND date = @date

        var a = DBTool.Query<T_0030010000_2>(sqlstr2, new 
             {
                 date = date,
                 //ednDate = end,        //不知道end該改啥 暫用date頂替          
                 Agent_ID = Agent_ID
             });

        var b = a.ToList().Select(p => new
        {
            DI_No = Value(p.DI_No),
            Day = Value(p.D),
            Job_Agent = Value(p.Job_Agent),
            To_W_Time = p.To_W_Time.ToString("HH:mm:ss"),
            Off_W_Time = p.Off_W_Time.ToString("HH:mm:ss"),
            Work = Value(p.Work),
            Schedule = Value(p.Schedule),
            S_UpdateTime = Value2(p.S_UpdateTime),
        });

        return JsonConvert.SerializeObject(b);
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Data(string value)
    {
        //Check();
        string Sqlstr = @"SELECT CONVERT(varchar(100), Day, 23) as D, * " +
            " FROM Daily_Itinerary WHERE DI_No=@value";
        var a = DBTool.Query<T_0030010000_2>(Sqlstr, new { value = value }).ToList().Select(p => new
        {
            A = Value(p.D),
            B = Value(p.Schedule),
            C = Value(p.Job_Agent),            
        });
        string outputJson = JsonConvert.SerializeObject(a);

        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Dispatch_Name()
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Sqlstr = @"SELECT DISTINCT Agent_ID, Agent_Name FROM DispatchSystem WHERE Agent_Status = '在職' " +
            "AND UpdateTime > '20170704' AND Agent_ID !=@Agent_ID ORDER BY Agent_ID, Agent_Name ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Agent_ID = Agent_ID }).ToList().Select(p => new
        {
            A = p.Agent_Name,
            //B = p.Agent_ID
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Onwork()
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string Type = "已上班";
        //string Time_01 = DateTime.Now();

        string sqlstr = @"select  TOP 1 DI_No " +
            " FROM Daily_Itinerary  " +
            " where Agent_ID = @Agent_ID and Day = @day ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
        string status = "error";
        var chk = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = Agent_ID, day = DateTime.Now.ToString("yyyy-MM-dd") });
        if (!chk.Any())
        {
            sqlstr = @"INSERT INTO Daily_Itinerary ( Agent_ID, Day, To_W_Time, Work ) " +
                " VALUES( @Agent_ID, @day, @To_W_Time, @Type ) ";
            DBTool.Query<ClassTemplate>(sqlstr, new
            {
                Agent_ID = Agent_ID,
                day = DateTime.Now.ToString("yyyy-MM-dd"),  //抓現在時間
                To_W_Time = DateTime.Now,
                Type = Type
            });
            status = "onwork";
        }
        else
        {
            sqlstr = @"update Daily_Itinerary set " +
                " To_W_Time = @To_W_Time, Work = @Type  " +
                " where Agent_ID = @Agent_ID and Day = @day ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
            chk = DBTool.Query<ClassTemplate>(sqlstr, new 
            { 
                Agent_ID = Agent_ID, 
                day = DateTime.Now.ToString("yyyy-MM-dd"), 
                To_W_Time = DateTime.Now,
                Type = Type
            });            
            status = "onwork";
        }   
        return JsonConvert.SerializeObject(new { status = status });
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Offwork()
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string Type = "已下班";

        string sqlstr = @"update Daily_Itinerary set " +
            " Off_W_Time = @Off_W_Time, Work = @Type  " +
            " where Agent_ID = @Agent_ID and Day = @day ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
        string status = "offwork";
        var chk = DBTool.Query<ClassTemplate>(sqlstr, new
            {
                Agent_ID = Agent_ID,
                day = DateTime.Now.ToString("yyyy-MM-dd"),
                Off_W_Time = DateTime.Now,
                Type = Type
            });
        status = "offwork";

        return JsonConvert.SerializeObject(new { status = status });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Setup(string str_s, string day, string Agent_Name)    //工單ID , 員工ID, 備註
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string Type = Value(str_s);
        string status = "出錯";
        if (day =="")
        {
            status = "請選擇日期";
            return JsonConvert.SerializeObject(new { status = status });
        }
        else if (Type == "")
        {
            status = "請填寫行程";
            return JsonConvert.SerializeObject(new { status = status });
        }
        else if (Type == "休假申請" && Agent_Name == "")
        {
            status = "請選擇代理人員";
            return JsonConvert.SerializeObject(new { status = status });
        }
        else if (Type == "休假" || Type == "代理被拒")
        {
            status = "不能填入休假或代理被拒";
            return JsonConvert.SerializeObject(new { status = status });
        }

        if (Type != "休假申請")
            Agent_Name = "";

        string sqlstr = @"select  TOP 1 DI_No " +
            " FROM Daily_Itinerary  " +
            " where Agent_ID = @Agent_ID and Day = @day ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

        var chk = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = Agent_ID, day = day });    //    , Type = Type, Agent_Name = Agent_Name
        if (!chk.Any())
        {
            sqlstr = @"INSERT INTO Daily_Itinerary ( Agent_ID, Day, Schedule, S_UpdateTime ) " +
                " VALUES( @Agent_ID, @day, @Schedule, @S_UpdateTime ) ";
            DBTool.Query<ClassTemplate>(sqlstr, new
            {
                Agent_ID = Agent_ID,
                day = day,
                Schedule = Type,  
                S_UpdateTime = DateTime.Now,                
            });
            status = "new";
            if (Type == "休假申請")
            {
                sqlstr = @"update Daily_Itinerary set " +
                " Job_Agent = @job_agent  " +
                " where Agent_ID = @Agent_ID and Day = @day ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
                chk = DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    Agent_ID = Agent_ID,
                    day = day,
                    job_agent = Agent_Name,                    
                });
            }
        }
        else
        {
            sqlstr = @"update Daily_Itinerary set " +
                " Schedule = @Schedule, S_UpdateTime = @S_UpdateTime, Job_Agent = @Agent_Name  " +
                " where Agent_ID = @Agent_ID and Day = @day ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
            chk = DBTool.Query<ClassTemplate>(sqlstr, new
            {
                Agent_ID = Agent_ID,
                day = day,
                S_UpdateTime = DateTime.Now,
                Schedule = Type,
                Agent_Name = Agent_Name
            });
            status = "update";
            if (Type == "休假申請")
            {
                sqlstr = @"update Daily_Itinerary set " +
                " Job_Agent = @job_agent  " +
                " where Agent_ID = @Agent_ID and Day = @day ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
                chk = DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    Agent_ID = Agent_ID,
                    day = day,
                    job_agent = Agent_Name,
                });
            }
        }
        return JsonConvert.SerializeObject(new { status = status });
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
        string Check = JASON.Check_ID("0030010000");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }

    public static string Value0(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (string.IsNullOrEmpty(value))
        {
            value = "";
        }
        return value;
    }
    public static string Value(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
        }
        return value;
    }
    public static string Value2(string value)        // 當值為null時跳過  非 null 時改時間格式
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = DateTime.Parse(value).ToString("yyyy/MM/dd HH:mm");
        }
        return value;
    }
    public static string Value3(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (string.IsNullOrEmpty(value))
        {
            value = "未打卡";
        }
        return value;
    }
    public static string Value4(string value, string value2, string value3, string value4 )        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (value3.Trim() == "休假申請" || value3.Trim() == "代理被拒")
        {
            value = value3;
        }
        else if(value3.Trim() == "休假" )
        {
            value = value3 + "(" + value4 + " 代)";
        }
        else 
        {
            value = "上班" + value + "\n下班" + value2 + "\n" + value3;
        }
        return value;
    }
    public static string Value5(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (value.Trim() == "休假申請")
        {
            value = "1";
        }
        else if (value.Trim() == "代理被拒")
        {
            value = "0";
        }
        else if (value.Trim() == "休假")
        {
            value = "2";
        }
        else
        {
            value = "3";
        }
        return value;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string TWO()
    {
        //Response.Write("郵件發送狀態：成功" + "<br>");
        //Response.Write("<Script language='JavaScript'>alert('警告訊息！');</Script>");
        string str_url = "../0030010000/0030010006.aspx";         //轉跳補打卡頁面
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }

    public class T_0030010000
    {
        public string title { get; set; }
        public string title2 { get; set; }
        public string id { get; set; }
        public string type { get; set; }
        public string value { get; set; }
        public DateTime start { get; set; }
        public string To_W_Time { get; set; }
        public string Off_W_Time { get; set; }
        public string Work { get; set; }
        public string Schedule { get; set; }
        public string S_UpdateTime { get; set; }
        public string Job_Agent { get; set; }
    }

    public class T_0030010000_2
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
        public string DI_No { get; set; }
        public string Agent_ID { get; set; }
        public string Day { get; set; }
        public DateTime To_W_Time { get; set; }
        public DateTime Off_W_Time { get; set; }
        public string Work { get; set; }
        public string Schedule { get; set; }
        public string S_UpdateTime { get; set; }
        public string D { get; set; }
        public string Job_Agent { get; set; }
    }
}