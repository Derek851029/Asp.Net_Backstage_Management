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

public partial class _0030010006 : System.Web.UI.Page
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
                Work = p.Work
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

//        string sqlstr = @"select CONVERT(varchar(100), To_W_Time, 8) as title, Job_Agent, " + //Schedule +' '+ Work as title,
 //           " CONVERT(varchar(100), [Off_W_Time], 8) as title2,  Day as start, Schedule  " +
//            " FROM Daily_Itinerary " +
//            " where Agent_ID = @Agent_ID ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
        string sqlstr = @"select Agent_Company+'  '+ Convert(nvarchar(4),count(*) )+'人' as title, Day as  start, " +
            "Agent_Company as type FROM Daily_Itinerary as a left join DispatchSystem as b on a.Agent_ID = b.Agent_ID " +
            //"where Work != '已下班' and Schedule !='休假' " +
            "GROUP by  Agent_Company, Day, Agent_Company ";

        var a = DBTool.Query<T_0030010006_2>(sqlstr, new      //行事曆案件整理
        {
            startDate = start,
            ednDate = end,
            Agent_Team = Agent_Team ,
            Agent_ID = Agent_ID
        });
        var b = a.ToList().Select(p => new
        {
            title = p.title,
            //title = Value4(p.title, p.title2, p.Schedule, p.Job_Agent),
            Schedule = p.Schedule,
            type = p.type,
            value = Value5(p.type),
            //value = Value5("Engineer"), //筆電測試用
            start = p.start.ToString("yyyy-MM-dd"),
            //id = p.id,
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

        //string sqlstr2 = @" select CONVERT(varchar(100), Day, 23) as D, c.* From Daily_Itinerary as c left join DispatchSystem as b" +
        //   "on c.Agent_ID = b.Agent_ID WHERE  Day = @date ";      //    AND date = @date
        string sqlstr2 = @" select CONVERT(varchar(100), Day, 23) as D, c.*, Agent_Name From [DimaxCallcenter].[dbo].Daily_Itinerary as c " +
            "left join [DimaxCallcenter].[dbo].DispatchSystem as b " +
            "on c.Agent_ID = b.Agent_ID WHERE  Day = @date and Agent_Company = @Type";

        var x = DBTool.Query<T_0030010006_2>(sqlstr2, new 
             {
                 date = date,
                 //ednDate = end,        //不知道end該改啥 暫用date頂替       
                 Type = Type,
                 //Agent_ID = Agent_ID
             });

        var y = x.ToList().Select(p => new
        {
            Agent_Name = Value(p.Agent_Name),
            DI_No = Value(p.DI_No),
            Day = Value(p.D),
            Job_Agent = Value(p.Job_Agent),
            //To_W_Time = Value3(p.To_W_Time),
            To_W_Time = p.To_W_Time.ToString("HH:mm:ss"),
            //Off_W_Time = Value3(p.Off_W_Time),
            Off_W_Time = p.Off_W_Time.ToString("HH:mm:ss"),
            Work = Value(p.Work),
            Schedule = Value(p.Schedule),
            S_UpdateTime = Value2(p.S_UpdateTime),
        });

        return JsonConvert.SerializeObject(y);
    }
    
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Data(string value)
    {
        //Check();
        string Sqlstr = @"SELECT CONVERT(varchar(100), Day, 23) as D, * " +
            " FROM Daily_Itinerary WHERE DI_No=@value";
        var a = DBTool.Query<T_0030010006_2>(Sqlstr, new { value = value }).ToList().Select(p => new
        {
            A = Value(p.D),
            B = Value(p.Agent_ID),
            C = p.To_W_Time.ToString("HH:mm:ss"),
            //C = Value3(p.To_W_Time),
            D = p.Off_W_Time.ToString("HH:mm:ss"),
            //D = Value3(p.Off_W_Time),    
        });
        string outputJson = JsonConvert.SerializeObject(a);

        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Dispatch_Team()
    {
        //Check();
        string Sqlstr = @"SELECT DISTINCT Agent_Company FROM DispatchSystem WHERE Agent_Status = '在職' AND UpdateTime > '20170704' ORDER BY Agent_Company ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            A = p.Agent_Company
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Dispatch_Name(string value)
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        if (value == "0")
        {
            string Sqlstr = @"SELECT DISTINCT Agent_ID, Agent_Name FROM DispatchSystem WHERE Agent_Status = '在職' " +
                        "AND UpdateTime > '20170704'  ORDER BY Agent_ID, Agent_Name ";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new { }).ToList().Select(p => new
            {
                A = p.Agent_Name,
                B = p.Agent_ID
            });
            string outputJson = JsonConvert.SerializeObject(a);
            return outputJson;
        }
        else
        {           
            string Sqlstr = @"SELECT DISTINCT Agent_ID, Agent_Name FROM DispatchSystem WHERE Agent_Status = '在職' " +
                        "AND UpdateTime > '20170704' and Agent_Company =@Agent_Company ORDER BY Agent_ID, Agent_Name ";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Agent_Company = value }).ToList().Select(p => new
            {
                A = p.Agent_Name,
                B = p.Agent_ID
            });
            string outputJson = JsonConvert.SerializeObject(a);
            return outputJson;  //*/
        }
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
    public static string Setup(string time1, string time2, string day, string Agent_ID)    //工單ID , 員工ID, 備註
    {
        //Check();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Type;

        string status = "請輸入正確時間格式 ex: 09:00, 12:01:59, 16:59:35.05";
        if (day =="")
        {
            status = "請選擇日期";
            return JsonConvert.SerializeObject(new { status = status });
        }
        else if (Agent_ID == "" )
        {
            status = "請選擇補打卡人員";
            return JsonConvert.SerializeObject(new { status = status });
        }
        else if (time1 == "" && time2 == "")
        {
            status = "請填入打卡時間";
            return JsonConvert.SerializeObject(new { status = status });
        }
        else if (time1 == "00:00:00" && time2 == "00:00:00")
        {
            status = "打卡時間不能都輸入 00:00:00";
            return JsonConvert.SerializeObject(new { status = status });
        }

        day = DateTime.Parse(day).ToString("yyyy/MM/dd");

        string sqlstr = @"select  TOP 1 DI_No " +
            " FROM Daily_Itinerary  " +
            " where Agent_ID = @Agent_ID and Day = @day ";      // 確認員工是否有當天的資料

        var chk = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = Agent_ID, day = day });    //    , Type = Type, Agent_Name = Agent_Name
        if (!chk.Any()) //查無資料下 新增資料
        {
            if (time1 != "" && time1 != "00:00:00")
            {
                Type = "已上班";
                sqlstr = @"INSERT INTO Daily_Itinerary ( Agent_ID, Day, To_W_Time, Work ) " +
                    " VALUES( @Agent_ID, @day, (@day +' '+@time1), @Type ) ";
                DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    Agent_ID = Agent_ID,
                    day = day,
                    time1 = time1,
                    Type = Type,
                });
                status = "new";
                if (time2 != "" && time2 != "00:00:00")   // 當值為null時跳過  非 null 時 update
                {
                    Type = "已下班";
                    sqlstr = @"UPDATE Daily_Itinerary SET Off_W_Time = (@day +' '+@time2), " +
                        "Work = @Type WHERE Agent_ID = @Agent_ID and Day = @day";
                    DBTool.Query<ClassTemplate>(sqlstr, new
                    {
                        Agent_ID = Agent_ID,
                        day = day,
                        time2 = time2,
                        Type = Type,
                    });
                }
            }
            else if (time2 != "" && time2 != "00:00:00")
            {
                Type = "已下班";
                sqlstr = @"INSERT INTO Daily_Itinerary ( Agent_ID, Day, Off_W_Time,  Work) " +
                    " VALUES( @Agent_ID, @day, (@day +' '+@time2), @Type ) ";
                DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    Agent_ID = Agent_ID,
                    day = day,
                    time2 = time2,
                    Type = Type,
                });
                status = "new";
            }
        }
        else
        {
            if (time1 != "" && time1 != "00:00:00")
            {
                Type = "已上班";
                sqlstr = @"update Daily_Itinerary set " +
                    " To_W_Time = (@day +' '+@time1), Work = @Type" +
                    " where Agent_ID = @Agent_ID and Day = @day ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
                chk = DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    Agent_ID = Agent_ID,
                    day = day,
                    time1 = time1,
                    Type = Type,
                });
                status = "update";
                if (time2 != "" && time2 != "00:00:00")   // 當值為null時跳過  非 null 時 update
                {
                    Type = "已下班";
                    sqlstr = @"UPDATE Daily_Itinerary SET Off_W_Time = (@day +' '+@time2), Work = @Type " +
                        "WHERE Agent_ID = @Agent_ID and Day = @day";
                    DBTool.Query<ClassTemplate>(sqlstr, new
                    {
                        Agent_ID = Agent_ID,
                        day = day,
                        time2 = time2,
                        Type = Type
                    });
                }
            }
            else if (time2 != "" && time2 != "00:00:00")
            {
                Type = "已下班";
                sqlstr = @"update Daily_Itinerary set " +
                    " Off_W_Time = (@day +' '+@time2), Work = @Type " +
                    " where Agent_ID = @Agent_ID and Day = @day ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
                chk = DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    Agent_ID = Agent_ID,
                    day = day,
                    time2 = time2,
                    Type = Type
                });
                status = "update";
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
        string Check = JASON.Check_ID("0030010006");
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
            value = DateTime.Parse(value).ToString("HH:mm:ss");
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
        if (!string.IsNullOrEmpty(value))
            if (value.Trim() == "Boss")
            {
                value = "1";
            }
            else if (value.Trim() == "Engineer")
            {
                value = "2";
            }
            else if (value.Trim() == "Finance")
            {
                value = "3";
            }
            else if (value.Trim() == "MA_Sales")
            {
                value = "4";
            }
            else if (value.Trim() == "Operation")
            {
                value = "5";
            }
            else if (value.Trim() == "Pre-sale")
            {
                value = "6";
            }
            else if (value.Trim() == "Sales 1")
            {
                value = "7";
            }
            else if (value.Trim() == "Sales 2")
            {
                value = "8";
            }
            else
            {
                value = "0";
            }
        return value;
    }    

    public class T_0030010006_2
    {
        public string title2 { get; set; }

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
        public string Agent_Company { get; set; }
        public string Agent_Name { get; set; }
        public string time1 { get; set; }
        public string time2 { get; set; }
    }
}