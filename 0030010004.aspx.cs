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

public partial class _0030010004 : System.Web.UI.Page
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
          " FROM CaseData " +
           " GROUP by Type_Value,Type,CONVERT(varchar(100), Upload_Time, 111) ";      // 原始的不會 Group    CONVERT(varchar(100), Upload_Time, 111) 要整串放進 Group 中

        var a = DBTool.Query<T_0030010004>(sqlstr, new      //行事曆案件整理
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

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]       //OE_Main() 主分類選項
    public static string OE_Main()
    {
        //Check();
        string sqlstr = @"SELECT DISTINCT Main_Classified FROM OE_Product ";
        var a = DBTool.Query<ClassTemplate>(sqlstr).ToList().Select(p => new
        {
            Main_Classified = p.Main_Classified
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============ QE 子分類選項 ===========
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string OE_Detail(string value)
    {
        //Check();
        string sqlstr = @"SELECT DISTINCT Detail_Classified FROM OE_Product WHERE Main_Classified=@Main_Classified";
        var a = DBTool.Query<ClassTemplate>(sqlstr, new { Main_Classified = value }).ToList().Select(p => new
        {
            Detail_Classified = p.Detail_Classified
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]       //OE商品列表
    public static string GetOEList()       //案件列表程式
    {
        //Check();
        //string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        //string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        //string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();

        string sqlstr2 = @" select * From [DimaxCallcenter].[dbo].[OE_Product] "; 
 //           " WHERE Type = @Type AND CONVERT(varchar(100), Upload_Time, 111) = @date ";      

        var a = DBTool.Query<T_0030010004_2>(sqlstr2, new 
             {
                 //date = date,
                 //ednDate = end,        //不知道end該改啥 暫用date頂替
                 //Type = Type,
                 //Agent_Team = Agent_Team,
                 //Agent_ID = Agent_ID
             });

        var b = a.ToList().Select(p => new
        {
            ID = p.OE_ID,
            Product_Name = p.Product_Name,
            Main_Classified = p.Main_Classified,
            Detail_Classified = p.Detail_Classified,
            Price = p.Unit_Price,
        });

        return JsonConvert.SerializeObject(b);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Show_Client_Data(string value)                     // 叫出商業資料  234行
    {
        Check();
        string Sqlstr = @"SELECT PID,BUSINESSNAME,APPNAME,APP_OTEL_AREA,APP_OTEL,APP_MTEL,HardWare, " +
            " SoftwareLoad,SERVICEITEM FROM BusinessData WHERE PID=@value ";                                                                //  ID=@value ?
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { value = value }).ToList().Select(p => new
        {
            K = p.PID,
            C = p.BUSINESSNAME,         // 公司名
            D = p.APPNAME,                  // 聯絡人
            E = p.APP_OTEL_AREA,
            F = p.APP_OTEL,                  // 電話
            G = p.APP_MTEL,                 // 手機
            H = p.HardWare.Trim(),      // 硬體
            I = p.SoftwareLoad,
            J = p.SERVICEITEM              // 合約
        });
        string outputJson = JsonConvert.SerializeObject(a);

        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]

    public static string URL(string ID)
    {
        //Check();
        ID = ID.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error+"_1" });
        }
        if (ID != "0")
        {
            string sqlstr = @"SELECT TOP 1 * FROM [DimaxCallcenter].[dbo].[CaseData] WHERE ID=@ID ";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { ID = ID });

            if (!a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "查無【" + ID + "】需求單編號。", type = "no" });
            };
        };

        string str_url = "../0030010100.aspx?seqno=" + ID;         //打開10099 並放入同Case_ID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0030010004");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }


    public class T_0030010004
    {
        public string title { get; set; }
        public string id { get; set; }
        public string type { get; set; }
        public string value { get; set; }
        public DateTime start { get; set; }
    }
    
    public class T_0030010004_2
    {
        public string OE_ID { get; set; }
        public string Product_Name { get; set; }
        public string Product_ID { get; set; }
        public string Main_Classified { get; set; }
        public string Detail_Classified { get; set; }
        public string Unit_Price { get; set; }
        //public DateTime EstimatedFinishTime { get; set; }
    }
}