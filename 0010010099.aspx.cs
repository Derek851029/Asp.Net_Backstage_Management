using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using log4net;
using log4net.Config;

public partial class _0010010099 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Check();
        }
    }

    public static void Check()
    {
        try
        {
            string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
            if (Agent_LV == "20" || Agent_LV == "30")
            {

            }
            else
            {
                System.Web.HttpContext.Current.Response.Redirect("~/0010010001.aspx");
            }
        }
        catch
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Login.aspx");
        }
    }

    //==========================================================
    [WebMethod(EnableSession = true)]
    public static string check_value(string Service, string Service_ID, string ServiceName)
    {
        Check();
        int i = 0;
        Service = Service.Trim();
        Service_ID = Service_ID.Trim();
        ServiceName = ServiceName.Trim();
        System.Threading.Thread.Sleep(50);

        if (Service.Length < 1 || Service.Length > 15)
        {
            System.Threading.Thread.Sleep(100);
            return JsonConvert.SerializeObject(new { status = "【分類名稱】不能空白或超過１５個字元。" });
        }
        else
        {
            i = HttpUtility.HtmlEncode(Service).Length;
            if (i != Service.Length)
            {
                System.Threading.Thread.Sleep(100);
                return JsonConvert.SerializeObject(new { status = "【分類名稱】含有不正確的關鍵字。" });
            }
        }

        if (ServiceName.Length < 1 || ServiceName.Length > 15)
        {
            System.Threading.Thread.Sleep(100);
            return JsonConvert.SerializeObject(new { status = "【項目名稱】不能空白或超過１５個字元。" });
        }
        else
        {
            i = HttpUtility.HtmlEncode(ServiceName).Length;
            if (i != ServiceName.Length)
            {
                System.Threading.Thread.Sleep(100);
                return JsonConvert.SerializeObject(new { status = "【項目名稱】含有不正確的關鍵字。" });
            }
        }

        System.Threading.Thread.Sleep(100);
        string Back = "";
        if (Service_ID == "0")
        {
            Back = New_Service(Service, ServiceName);
        }
        else
        {
            Back = Update_Service(Service, Service_ID, ServiceName);
        };

        System.Threading.Thread.Sleep(1000);
        return JsonConvert.SerializeObject(new { status = Back });
    }

    //============= 新增【服務】資訊 =============
    public static string New_Service(string Service, string ServiceName)
    {
        string ID = HttpContext.Current.Session["UserID"].ToString();
        string NAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Sqlstr = @"SELECT TOP 1 Service_ID FROM Data WHERE ServiceName=@ServiceName ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { ServiceName = ServiceName });
        if (a.Any())
        {
            return "已有相同的項目名稱。";
        };

        Sqlstr = @"INSERT INTO Data ( Service, ServiceName, Create_ID, Create_Name) 
            VALUES(@Service, @ServiceName, @Create_ID, @Create_Name)
            Update Data Set Service_ID =SYS_ID Where Service_ID is null or Service_ID='' ";

        a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Service = Service,
            ServiceName = ServiceName,
            Create_ID = ID,
            Create_Name = NAME
        });

        return "新增完成。";
    }

    public static string Update_Service(string Service, string Service_ID, string ServiceName)
    {
        string ID = HttpContext.Current.Session["UserID"].ToString();
        string NAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Sqlstr = @"SELECT TOP 1 Service_ID FROM Data WHERE ServiceName=@ServiceName AND Service_ID != @Service_ID ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Service_ID = Service_ID, ServiceName = ServiceName });
        if (a.Any())
        {
            return "已有相同的項目名稱。";
        };

        Sqlstr = @"UPDATE Data SET Service=@Service, ServiceName=@ServiceName, " +
           "UPDATE_ID=@UPDATE_ID, UPDATE_NAME=@UPDATE_NAME, UpDateDate=getdate() " +
           "WHERE Service_ID=@Service_ID";

        a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Service_ID = Service_ID,
            Service = Service,
            ServiceName = ServiceName,
            UPDATE_ID = ID,
            UPDATE_NAME = NAME
        });

        return "修改完成。";
    }

    //============= 帶入【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Service(string Service_ID)
    {
        Check();
        string Sqlstr = @"SELECT Service, ServiceName FROM Data WHERE Service_ID = @Service_ID ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Service_ID = Service_ID }).ToList().Select(p => new
        {
            Service = p.Service,
            ServiceName = p.ServiceName
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 帶入【服務分類】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Service_List()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT Service FROM Data";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            Service = p.Service
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Table()
    {
        try
        {
            string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
            string Sqlstr = "";
            Sqlstr = @"SELECT * FROM Data ";
            var a = DBTool.Query<Location_str>(Sqlstr).ToList().Select(p => new
            {
                Service_ID = p.Service_ID,
                Service = p.Service,
                ServiceName = p.ServiceName,
                UPDATE_NAME = p.UPDATE_NAME,
                UpDateDate = Check_Time(p.UpDateDate.ToString("yyyy/MM/dd HH:mm:ss")),
                Open_Flag = p.Open_Flag
            });
            string outputJson = JsonConvert.SerializeObject(a);
            return outputJson;
        }
        catch
        {
            return "error";
        }
    }

    //============ 開啟關閉 群組名稱 ======================
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Open_Service(string SYSID, string Flag)
    {
        string ID = HttpContext.Current.Session["UserID"].ToString();
        string NAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Sqlstr = "";
        string text = "";
        if (Agent_LV == "20" || Agent_LV == "30")
        {
            if (Flag == "0") { Flag = "1"; text = "已啟用。"; } else { Flag = "0"; text = "已停用。"; }

            Sqlstr = @"UPDATE Data SET Open_Flag=@Flag, UPDATE_NAME=@NAME, UPDATE_ID=@ID, UpDateDate=getdate() " +
                "WHERE Service_ID = @SYSID ";

            using (IDbConnection db = DBTool.GetConn())
            {
                db.Execute(Sqlstr, new { SYSID = SYSID, NAME = NAME, ID = ID, Flag = Flag });
                db.Close();
            }
            return JsonConvert.SerializeObject(new { status = "0", back = text });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "您沒有修改權限，請再嘗試或詢問管理人員，謝謝。" });
        }
    }

    public static string Check_Time(string time)
    {
        if (time == "0001/01/01 00:00:00")
        {
            return "";
        }
        else
        {
            return time;
        }
    }

    public class Location_str
    {
        public string SYSID { get; set; }
        public string Service_ID { get; set; }
        public string Service { get; set; }
        public string ServiceName { get; set; }
        public string Create_ID { get; set; }
        public string Create_Name { get; set; }
        public DateTime Create_Time { get; set; }
        public string UPDATE_NAME { get; set; }
        public DateTime UpDateDate { get; set; }
        public string txt_Content { get; set; }
        public string txt_Title { get; set; }
        public string Click { get; set; }
        public string Open_Flag { get; set; }
    }
}
