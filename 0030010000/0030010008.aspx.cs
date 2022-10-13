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

public partial class _0030010008 : System.Web.UI.Page
{
    protected string str_time;
    protected string str_view;
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        Session["view"] = Request.Params["view"];
        /*switch (Request.Params["str_time"])
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
        }*/
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end, string time)
    {
        Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Company = HttpContext.Current.Session["Agent_Company"].ToString(); //部門
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();               //職位
        string view = HttpContext.Current.Session["view"].ToString();

        if (Agent_Company == "Engineer" && Agent_Team != "Manager" && Agent_Team != "Leader")//    && view !="1"
        {
            string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Type_Value as value, " +
                  " CONVERT(varchar(100), OnSpotTime, 111) as start " +
                  " FROM [InSpecation_Dimax].[dbo].[Mission_Case] where Agent_ID = @Agent_ID  " +
                  " GROUP by Type_Value,Type,CONVERT(varchar(100), OnSpotTime, 111) ";
            var a = DBTool.Query<A_0030010008>(sqlstr, new      //行事曆案件整理
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
        else if (view == "1" && Agent_Company == "Engineer" && (Agent_Team == "Manager" || Agent_Team == "Leader"))
        {
            string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Type_Value as value, " +
                " CONVERT(varchar(100), OnSpotTime, 111) as start " +
                " FROM [InSpecation_Dimax].[dbo].[Mission_Case] where Agent_ID = @Agent_ID" +
                " GROUP by Type_Value,Type,CONVERT(varchar(100), OnSpotTime, 111) ";
            var a = DBTool.Query<A_0030010008>(sqlstr, new      //行事曆案件整理
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
            string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Type_Value as value, " +
                " CONVERT(varchar(100), OnSpotTime, 111) as start " +
                " FROM [InSpecation_Dimax].[dbo].[Mission_Case] " +
                " GROUP by Type_Value,Type,CONVERT(varchar(100), OnSpotTime, 111) ";
            var a = DBTool.Query<A_0030010008>(sqlstr, new      //行事曆案件整理
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

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date, string Type, string str_time)
    {
        Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Company = HttpContext.Current.Session["Agent_Company"].ToString(); //部門
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();               //職位
        string view = HttpContext.Current.Session["view"].ToString();

        if (Agent_Company == "Engineer" && Agent_Team != "Manager" && Agent_Team != "Leader")
        {
            string sqlstr2 = @" select  a.*, c.BUSINESSNAME, d.Name, e.Agent_Name, " +
              " CONVERT(varchar(100), SetupTime, 111), a.ReachTime as Time2 From [InSpecation_Dimax].[dbo].[Mission_Case] as a " +
              " left join InSpecation_Dimax.dbo.Mission_Title as b on a.Title_ID=b.SYSID " +
              " left join BusinessData as c on b.PID=c.PID " +
              " left join Business_Sub as d on b.PID2=d.PNumber " +
              " left join DispatchSystem as e on a.Agent_ID=e.Agent_ID " +
              " WHERE a.Type = @Type AND CONVERT(varchar(100), OnSpotTime, 111) = @date and a.Agent_ID = @Agent_ID ";      //    AND date = @date
            var a = DBTool.Query<A_0030010008>(sqlstr2, new
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
                OnSpotTime = p.OnSpotTime.ToString("yyyy/MM/dd HH:mm"),
                Telecomm_ID = p.Telecomm_ID,
                Agent_Name = p.Handle_Agent,
                Type = p.Type,
                //BUSINESSNAME = Name(p.Name, p.BUSINESSNAME),
                BUSINESSNAME = p.Title_Name,
                ReachTime = Value2(p.Time2),
                ReachName = p.ReachUser,
                Handle_Agent = p.Agent_ID

                /*Urgency = "Urgency",
                OpinionType = "OpinionType",
                Handle_Agent = p.Agent_ID,
                Type = p.Type,
                Agent_Name = p.Agent_Name   //*/
            });
            return JsonConvert.SerializeObject(b);
        }
        else if (view == "1" && Agent_Company == "Engineer" && (Agent_Team != "Manager" || Agent_Team != "Leader"))
        {
            string sqlstr2 = @" select  a.*, c.BUSINESSNAME, d.Name, e.Agent_Name, " +
              " CONVERT(varchar(100), SetupTime, 111), a.ReachTime as Time2  From [InSpecation_Dimax].[dbo].[Mission_Case] as a " +
              " left join InSpecation_Dimax.dbo.Mission_Title as b on a.Title_ID=b.SYSID " +
              " left join BusinessData as c on b.PID=c.PID " +
              " left join Business_Sub as d on b.PID2=d.PNumber " +
              " left join DispatchSystem as e on a.Agent_ID=e.Agent_ID " +
              " WHERE a.Type = @Type AND CONVERT(varchar(100), OnSpotTime, 111) = @date and a.Agent_ID = @Agent_ID ";      //    AND date = @date
            var a = DBTool.Query<A_0030010008>(sqlstr2, new
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
                OnSpotTime = p.OnSpotTime.ToString("yyyy/MM/dd HH:mm"),
                ReachTime = Value2(p.Time2),
                //BUSINESSNAME = Name(p.Name, p.BUSINESSNAME),
                BUSINESSNAME = p.Title_Name,
                Telecomm_ID = p.Telecomm_ID,
                Handle_Agent = p.Agent_ID,
                Type = p.Type,
                Agent_Name = p.Handle_Agent,
                ReachName = p.ReachUser
            });
            return JsonConvert.SerializeObject(b);
        }
        else
        {
            string sqlstr2 = @" select  a.*, c.BUSINESSNAME, d.Name, e.Agent_Name, " +
            " CONVERT(varchar(100), SetupTime, 111), a.ReachTime as Time2  From [InSpecation_Dimax].[dbo].[Mission_Case] as a " +
            " left join InSpecation_Dimax.dbo.Mission_Title as b on a.Title_ID=b.SYSID " +
            " left join BusinessData as c on b.PID=c.PID " +
            " left join Business_Sub as d on b.PID2=d.PNumber " +
            " left join DispatchSystem as e on a.Agent_ID=e.Agent_ID " +
            " WHERE a.Type = @Type AND CONVERT(varchar(100), OnSpotTime, 111) = @date ";      //    AND date = @date
            var a = DBTool.Query<A_0030010008>(sqlstr2, new
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
                OnSpotTime = p.OnSpotTime.ToString("yyyy/MM/dd HH:mm"),
                ReachTime = Value2(p.Time2),
                //BUSINESSNAME = Name(p.Name, p.BUSINESSNAME),
                BUSINESSNAME = p.Title_Name,
                Telecomm_ID = p.Telecomm_ID,
                Handle_Agent = p.Agent_ID,
                Type = p.Type,
                Agent_Name = p.Handle_Agent,
                ReachName = p.ReachUser
            });
            return JsonConvert.SerializeObject(b);
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string URL(string mno)
    {
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(mno) != true)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        if (mno.Length > 16 || mno.Length < 1)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        if (mno != "0")
        {
            string sqlstr = @"SELECT TOP 1 SYSID FROM InSpecation_Dimax.dbo.Mission_Case WHERE Case_ID=@MNo ";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { MNo = mno });

            if (!a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "查無【" + mno + "】維護單編號。", type = "no" });
            };
        };

        string str_url = "../0250010004.aspx?seqno=" + mno;
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

    public static string Name(string value, string value2)        // 當value值為""  非 value=value2
    {
        if (string.IsNullOrEmpty(value))
        {
            value = value2.Trim();
        }
        else
            value = value.Trim();
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
    public class A_0030010008 
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
        public DateTime OnSpotTime { get; set; }
        public string Creat_Agent { get; set; }
        public string BUSINESSNAME { get; set; }
        public string Name { get; set; }
        public string OpinionType { get; set; }
        public string Handle_Agent { get; set; }
        public string C_ID2 { get; set; }
        public string Agent_ID { get; set; }
        public string Agent_Name { get; set; }
        public string ReachUser { get; set; }
        public string Title_Name { get; set; }
        public string Time { get; set; }
        public string Time2 { get; set; }
        public string Telecomm_ID { get; set; }
    }
}