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
using log4net;
using log4net.Config;

public partial class _0060010010 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
    }

    [WebMethod(EnableSession = true)]
    public static string GetPartnerList()
    {
        Check();
        string sqlstr = @"SELECT * FROM Data WHERE Service_ID != '60' ";
        var a = DBTool.Query<CMS_0060010000>(sqlstr).ToList().Select(p => new
        {
            //Time_01 = DateTime.Now.ToString("yyyy/MM/dd HH:mm");
            SYS_ID = p.SYS_ID,
            Service_ID = p.Service_ID,
            Service = p.Service,
            ServiceName = p.ServiceName,
            UpDateDate = Convert.ToDateTime(p.UpDateDate).ToString("yyyy/MM/dd HH:mm"),
            UPDATE_NAME = p.UPDATE_NAME,
            Flag = p.Flag,
            Open_Flag = p.Open_Flag
        });
        return JsonConvert.SerializeObject(a);
    }

    [WebMethod(EnableSession = true)]
    public static string Open_Flag(string SYS_ID, string Flag, string value)
    {
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string Sqlstr = "";
        string TIME = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss");
        string ID = HttpContext.Current.Session["UserID"].ToString();
        string NAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        if (value == "1")
        {
            Sqlstr = @"update Data Set UPDATE_ID=@ID,UPDATE_NAME=@NAME,UpDateDate=@TIME,Flag=@Flag where SYS_ID = @SYS_ID";
        }
        else if (value == "2")
        {
            Sqlstr = @"update Data Set UPDATE_ID=@ID,UPDATE_NAME=@NAME,UpDateDate=@TIME,Open_Flag=@Flag where SYS_ID = @SYS_ID";
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        if (Flag != "1" && Flag != "0")
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        using (IDbConnection conn = DBTool.GetConn())
        {
            conn.Execute(Sqlstr, new { SYS_ID = SYS_ID, ID = ID, NAME = NAME, TIME = TIME, Flag = Flag });
            conn.Close();
        }
        return JsonConvert.SerializeObject(new { status = "設定完成。" });
    }


    [WebMethod(EnableSession = true)]
    public static string check_value(string Service, string Service_ID, string ServiceName)
    {
        Check();

        System.Threading.Thread.Sleep(50); 

        if (Service.Length < 1)
        {
            System.Threading.Thread.Sleep(100); 
            return JsonConvert.SerializeObject(new { status = "請選擇【服務項目】。" });
        };

        if (ServiceName.Length < 1 || ServiceName.Length > 15)
        {
            System.Threading.Thread.Sleep(100); 
            return JsonConvert.SerializeObject(new { status = "【服務名稱】不能空白或超過１５個字元。" });
        }
        else
        {
            ServiceName = HttpUtility.HtmlEncode(ServiceName);
            if (ServiceName.Length > 20)
            {
                System.Threading.Thread.Sleep(100); 
                return JsonConvert.SerializeObject(new { status = "【服務名稱】含有不正確的關鍵字。" });
            }
        }
        Service = HttpUtility.HtmlEncode(Service);
        string Sqlstr = @"SELECT TOP 1 SYS_ID FROM Data WHERE Service=@Service ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Service = Service });
        if (!a.Any())
        {
            System.Threading.Thread.Sleep(100); 
            return JsonConvert.SerializeObject(new { status = "無此系統參數，請再嘗試或詢問管理人員，謝謝。" });
        };

        System.Threading.Thread.Sleep(50); 

        string ID = HttpContext.Current.Session["UserID"].ToString();
        string NAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Back = "";
        if (Service_ID == "0")
        {
            Back = New_Service(ID, NAME, Service, Service_ID, ServiceName);
        }
        else
        {
            Back = Update_Service(ID, NAME, Service, Service_ID, ServiceName);
        };

        return JsonConvert.SerializeObject(new { status = Back });
    }

    //============= 帶入【服務分類】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Service_List()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT Service FROM Data WHERE Open_Flag = '1' ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            Service = p.Service
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 新增【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Service(string ID, string NAME, string Service, string Service_ID, string ServiceName)
    {
        Check();

        System.Threading.Thread.Sleep(50);

        string Sqlstr = @"SELECT TOP 1 SYS_ID FROM Data WHERE ServiceName=@ServiceName ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { ServiceName = ServiceName });
        if (a.Any())
        {
            return "已有相同的服務名稱。";
        };

        System.Threading.Thread.Sleep(50); 

        int int_service_ID = 0;
        Sqlstr = @"SELECT TOP 1 Service_ID FROM Data WHERE ORDER BY SYS_ID DESC";
        a = DBTool.Query<ClassTemplate>(Sqlstr);
        foreach (var q in a)
        {
            int_service_ID = Int32.Parse(q.Service_ID);
        };
        string str_Service_ID = (int_service_ID + 1).ToString();

        Sqlstr = @"INSERT INTO Data (Service_ID, Service, ServiceName, Create_ID, Create_Name) " +
            " VALUES(@Service_ID, @Service, @ServiceName, @Create_ID, @Create_Name)";
        a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Service_ID = str_Service_ID,
            Service = Service,
            ServiceName = ServiceName,
            Create_ID = ID,
            Create_Name = NAME
        });

        System.Threading.Thread.Sleep(50); 

        return "新增完成。";
    }

    //============= 修改【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Update_Service(string ID, string NAME, string Service, string Service_ID, string ServiceName)
    {
        Check();

        System.Threading.Thread.Sleep(50); 

        string Sqlstr = @"SELECT TOP 1 SYS_ID FROM Data WHERE ServiceName=@ServiceName AND Service_ID != @Service_ID";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { ServiceName = ServiceName, Service_ID = Service_ID });
        if (a.Any())
        {
            return "已有相同的服務名稱。";
        };

        System.Threading.Thread.Sleep(50); 

        Sqlstr = @"SELECT TOP 1 SYS_ID FROM Data WHERE Service_ID = @Service_ID";
        a = DBTool.Query<ClassTemplate>(Sqlstr, new { Service_ID = Service_ID });
        if (!a.Any())
        {
            return "無此系統參數，請再嘗試或詢問管理人員，謝謝。";
        };

        System.Threading.Thread.Sleep(50); 

        string TIME = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss");
        Sqlstr = @"UPDATE Data SET Service=@Service, ServiceName=@ServiceName, " +
           "UPDATE_ID=@UPDATE_ID, UPDATE_NAME=@UPDATE_NAME, UpDateDate=@UpDateDate " +
           "WHERE Service_ID=@Service_ID";
        a = DBTool.Query<ClassTemplate>(Sqlstr, new
       {
           Service_ID = Service_ID,
           Service = Service,
           ServiceName = ServiceName,
           UPDATE_ID = ID,
           UPDATE_NAME = NAME,
           UpDateDate = TIME
       });

        System.Threading.Thread.Sleep(50); 

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

    private void RegisterStartupScript(string msg)
    {
        if (ScriptManager.GetCurrent(this.Page) == null)
        {
            Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "buttonStartup", "alert('" + msg + "');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "buttonStartupBySM", "alert('" + msg + "');", true);
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0060010010");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }
}
