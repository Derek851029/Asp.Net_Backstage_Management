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

public partial class _0030010005 : System.Web.UI.Page
{
    //protected string str_time;
    protected string str_day;
    protected string str_type;
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        //Check();
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
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end, string time)
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string Agent_Company = HttpContext.Current.Session["Agent_Company"].ToString();
        string Agent_Name = HttpContext.Current.Session["UserIDNAME"].ToString();

        if (Agent_Company == "Pre-sale" || Agent_Company == "Operation")
        {
            string sqlstr = @"select Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Con_Company as value, " +
        " CONVERT(varchar(100), SetupDate, 111) as start " +
        " FROM [DimaxCallcenter].[dbo].[OE_Data] " +
        " where Type = '尚未審查' and Con_Company != 'MA_Sales' " +
        " GROUP by Con_Company,Type,CONVERT(varchar(100), SetupDate, 111) ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
            var a = DBTool.Query<T_0030010005_2>(sqlstr, new      //行事曆案件整理
            {
                startDate = start,
                ednDate = end,
                //Agent_Company2 = Value1(Agent_Company1),
                //Agent_Company2 = "Sales 1",
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
        else if (Agent_Name == "簡鴻儒")
        {
            string sqlstr = @"select Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Con_Company as value, " +
        " CONVERT(varchar(100), SetupDate, 111) as start " +
        " FROM [DimaxCallcenter].[dbo].[OE_Data] " +
        " where Type = '尚未審查' and Con_Company in( 'Sales 1','Sales 2','Sales 3', 'MA_Sales') " +
        " GROUP by Con_Company,Type,CONVERT(varchar(100), SetupDate, 111) ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
            var a = DBTool.Query<T_0030010005_2>(sqlstr, new      //行事曆案件整理
            {
                startDate = start,
                ednDate = end,
                Agent_Company2 = Value1(Agent_Company),
                //Agent_Company2 = "Sales 1",
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
        else if (Agent_Company == "Engineer" && Agent_Team == "Leader")
        {
            string sqlstr = @"select Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Con_Company as value, " +
        " CONVERT(varchar(100), SetupDate, 111) as start " +
        " FROM [DimaxCallcenter].[dbo].[OE_Data] " +
        " where Type = '尚未審查' and Con_Company in( @Agent_Company2, 'MA_Sales') " +
        " GROUP by Con_Company,Type,CONVERT(varchar(100), SetupDate, 111) ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中
            var a = DBTool.Query<T_0030010005_2>(sqlstr, new      //行事曆案件整理
            {
                startDate = start,
                ednDate = end,
                Agent_Company2 = Value1(Agent_Company),
                //Agent_Company2 = "Sales 1",
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
        string Sqlstr = @"select Type +' '+ Convert(nvarchar(4),count(*)) as title, Type as type, Type_Value as value, " +
        " CONVERT(varchar(100), SetupDate, 111) as start " +
        " FROM [DimaxCallcenter].[dbo].[OE_Data] " +
        " where Type in( '尚未審查','尚未審核') and Con_Company = @Agent_Company " +
        " GROUP by Type_Value,Type,CONVERT(varchar(100), SetupDate, 111) ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

        var c = DBTool.Query<T_0030010005_2>(Sqlstr, new      //行事曆案件整理
        {
            startDate = start,
            ednDate = end,
            Agent_Team = Agent_Team,
            Agent_ID = Agent_ID,            
            Agent_Company = Value1(Agent_Company),
        });
        var d = c.ToList().Select(p => new
        {
            title = p.title,
            type = p.type,
            value = p.value,
            start = p.start.ToString("yyyy-MM-dd"),
            id = p.id
        });
        return JsonConvert.SerializeObject(d);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date, string Type, string Con_C)       //案件列表程式
    {
        //Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string Agent_Company1 = HttpContext.Current.Session["Agent_Company"].ToString();
        string Agent_Name = HttpContext.Current.Session["UserIDNAME"].ToString();
        if (Agent_Company1 == "Pre-sale" || Agent_Company1 == "Operation")
        {
            string sqlstr2 = @" select  Type_Value, SetupDate as SetupDate2, OE_Case_ID, Con_Name, BUSINESSNAME, Type, OE_PS " +
                " From OE_Data " +
            " WHERE Type = @Type AND CONVERT(varchar(100), SetupDate, 111) = @date and Con_Company !='MA_Sales'";      //    AND date = @date
            //" WHERE Type = @Type AND CONVERT(varchar(100), SetupDate, 111) = @date and Con_Company = @Con_C and Con_Company !='MA_Sales'";      //    AND date = @date
            var a = DBTool.Query<T_0030010005_2>(sqlstr2, new
                 {
                     date = date,
                     //ednDate = end,        //不知道end該改啥 暫用date頂替
                     Type = Type,
                     //Con_C = Con_C,
                     Agent_Team = Agent_Team,
                     Agent_ID = Agent_ID
                 });

            var b = a.ToList().Select(p => new
            {
                Type_Value = p.Type_Value,
                OE_Case_ID = p.OE_Case_ID,
                BUSINESSNAME = p.BUSINESSNAME,
                Con_Name = p.Con_Name,
                Type = p.Type,
                OE_PS = p.OE_PS,
                SetupDate = p.SetupDate2.ToString("yyyy-MM-dd")
                //EstimatedFinishTime = p.EstimatedFinishTime.ToString("MM/dd HH:mm")
            });
            return JsonConvert.SerializeObject(b);
        }
        else if (Agent_Name == "簡鴻儒")
        {
            string Sqlstr = @"select  Type_Value, SetupDate as SetupDate2, OE_Case_ID, Con_Name, BUSINESSNAME, Type, OE_PS " +
            " FROM OE_Data WHERE Type = @Type AND CONVERT(varchar(100), SetupDate, 111) = @date " +
            " and Con_Company in( 'Sales 1','Sales 2','Sales 3', 'MA_Sales') ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

            var c = DBTool.Query<T_0030010005_2>(Sqlstr, new      //行事曆案件整理
            {
                date = date,
                //ednDate = end,        //不知道end該改啥 暫用date頂替
                Type = Type,
                Agent_Team = Agent_Team,
                Agent_ID = Agent_ID,
                Agent_Company2 = Value1(Agent_Company1),
            });
            var d = c.ToList().Select(p => new
            {
                Type_Value = p.Type_Value,
                OE_Case_ID = p.OE_Case_ID,
                BUSINESSNAME = p.BUSINESSNAME,
                Con_Name = p.Con_Name,
                Type = p.Type,
                OE_PS = p.OE_PS,
                SetupDate = p.SetupDate2.ToString("yyyy-MM-dd")
            });
            return JsonConvert.SerializeObject(d);
        }
        else if (Agent_Company1 == "Engineer" && Agent_Team == ("Leader"))
        {
            string Sqlstr = @"select  Type_Value, SetupDate as SetupDate2, OE_Case_ID, Con_Name, BUSINESSNAME, Type, OE_PS " +
            " FROM OE_Data " +
            " WHERE Type = @Type AND CONVERT(varchar(100), SetupDate, 111) = @date and Con_Company in( @Agent_Company2, 'MA_Sales') ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

            var c = DBTool.Query<T_0030010005_2>(Sqlstr, new      //行事曆案件整理
            {
                date = date,
                //ednDate = end,        //不知道end該改啥 暫用date頂替
                Type = Type,
                Agent_Team = Agent_Team,
                Agent_ID = Agent_ID,
                Agent_Company2 = Value1(Agent_Company1),
            });
            var d = c.ToList().Select(p => new
            {
                Type_Value = p.Type_Value,
                OE_Case_ID = p.OE_Case_ID,
                BUSINESSNAME = p.BUSINESSNAME,
                Con_Name = p.Con_Name,
                Type = p.Type,
                OE_PS = p.OE_PS,
                SetupDate = p.SetupDate2.ToString("yyyy-MM-dd")
            });
            return JsonConvert.SerializeObject(d);
        }
        else
        {
            string Sqlstr = @"select  Type_Value, SetupDate as SetupDate2, OE_Case_ID, Con_Name, BUSINESSNAME, Type, OE_PS " +
            " FROM OE_Data " +
            " WHERE Type = @Type AND CONVERT(varchar(100), SetupDate, 111) = @date and Con_Company = @Agent_Company2 ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

            var c = DBTool.Query<T_0030010005_2>(Sqlstr, new      //行事曆案件整理
            {
                date = date,
                //ednDate = end,        //不知道end該改啥 暫用date頂替
                Type = Type,
                Agent_Team = Agent_Team,
                Agent_ID = Agent_ID,
                Agent_Company2 = Value1(Agent_Company1),
            });
            var d = c.ToList().Select(p => new
            {
                Type_Value = p.Type_Value,
                OE_Case_ID = p.OE_Case_ID,
                BUSINESSNAME = p.BUSINESSNAME,
                Con_Name = p.Con_Name,
                Type = p.Type,
                OE_PS = p.OE_PS,
                SetupDate = p.SetupDate2.ToString("yyyy-MM-dd")
            });
            return JsonConvert.SerializeObject(d);
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
            string sqlstr = @"SELECT TOP 1 OE_Case_ID FROM [DimaxCallcenter].[dbo].[OE_Data] WHERE OE_Case_ID=@Case_ID ";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { Case_ID = mno });

            if (!a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "查無【" + mno + "】需求單編號。", type = "no" });
            };
        };

        string str_url = "../0030010015.aspx?seqno=" + mno;         //打開10099 並放入同Case_ID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0030010005");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }

    public static string Value1(string value)        // 當值為null時跳過  非 null 時去除後方空白
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

    public class T_0030010005
    {
        public string title { get; set; }
        public string id { get; set; }
        public string type { get; set; }
        public string value { get; set; }
        public DateTime start { get; set; }

    }

    public class T_0030010005_2
    {
        public string title { get; set; }
        public string end { get; set; }
        public string id { get; set; }
        public string type { get; set; }
        public string value { get; set; }
        public string Case_ID { get; set; }
        public string ReplyType { get; set; }
        public string OpinionSubject { get; set; }
        public string Urgency { get; set; }
        public string ID { get; set; }
        public string Cust_Name { get; set; }
        public string Agent_Team { get; set; }
        public string Agent_ID { get; set; }
        public DateTime start { get; set; }
        public DateTime Upload_Time { get; set; }
        public DateTime EstimatedFinishTime { get; set; }

        public int a { get; set; }
        public string OE_ID { get; set; }
        public string Product_Name { get; set; }
        public string Product_ID { get; set; }
        public string Main_Classified { get; set; }
        public string Detail_Classified { get; set; }
        public string Unit_Price { get; set; }

        public string OE_O_ID { get; set; }
        public string OE_Case_ID { get; set; }
        public string Quantity { get; set; }
        public string T_Price { get; set; }

        public string OE_D_ID { get; set; }
        public string Con_Name { get; set; }
        public string Con_Phone { get; set; }
        public string SetupDate { get; set; }
        public DateTime SetupDate2 { get; set; }
        public string UpdateDate { get; set; }
        public string Total_Price { get; set; }
        public string BUSINESSNAME { get; set; }
        public string PID { get; set; }
        public string Type_Value { get; set; }
        public string Type { get; set; }
        public string APPNAME { get; set; }
        public string CONTACT_ADDR { get; set; }
        public string APP_FTEL { get; set; }
        public string APP_MTEL { get; set; }
        public string HardWare { get; set; }
        public string SoftwareLoad { get; set; }
        public string Name { get; set; }
        public string PNumber { get; set; }
        public string S_APPNAME { get; set; }
        public string S_CONTACT_ADDR { get; set; }
        public string S_APP_FTEL { get; set; }
        public string S_APP_MTEL { get; set; }
        public string S_HardWare { get; set; }
        public string S_SoftwareLoad { get; set; }
        public string RFQ { get; set; }
        public string Warranty_Date { get; set; }
        public string Warr_Time { get; set; }
        public string Protect_Date { get; set; }
        public string Prot_Time { get; set; }
        public string Receipt_Date { get; set; }
        public string Receipt_PS { get; set; }
        public string Close_Out_Date { get; set; }
        public string Close_Out_PS { get; set; }
        public string OE_PS { get; set; }
        public string Con_C { get; set; }
    }
}