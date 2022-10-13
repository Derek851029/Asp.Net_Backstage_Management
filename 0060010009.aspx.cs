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

public partial class _0060010009 : System.Web.UI.Page
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
        string sqlstr = @"SELECT * FROM DataHospital";
        var a = DBTool.Query<CMS_0060010000>(sqlstr).ToList().Select(p => new
        {
            SYS_ID = p.SYS_ID,
            HospitalName = p.HospitalName,
            UpDateDate = Convert.ToDateTime(p.UpDateDate).ToString("yyyy/MM/dd HH:mm"),
            UPDATE_NAME = p.UPDATE_NAME,
            Flag = p.Flag
        });
        return JsonConvert.SerializeObject(a);
    }

    [WebMethod(EnableSession = true)]
    public static string Open_Flag(string SYS_ID, string Flag)
    {
        Check();
        if (Flag != "0" && Flag != "1")
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        };

        if (Flag == "1")
        {
            Flag = "0";
        }
        else
        {
            Flag = "1";
        };

        string ID = HttpContext.Current.Session["UserID"].ToString();
        string NAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string TIME = DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss");
        string Sqlstr = @"update DataHospital Set UPDATE_ID=@ID,UPDATE_NAME=@NAME,UpDateDate=@TIME,Flag=@Flag where SYS_ID = @SYS_ID";
        using (IDbConnection conn = DBTool.GetConn())
        {
            conn.Execute(Sqlstr, new { SYS_ID = SYS_ID, ID = ID, NAME = NAME, TIME = TIME, Flag = Flag });
            conn.Close();
        }
        return JsonConvert.SerializeObject(new { status = "修改完成。" });
    }

    //============= 新增【醫療院所名稱】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Service(string HospitalName)
    {
        Check();

        if (HospitalName.Length < 1 || HospitalName.Length > 15)
        {
            return JsonConvert.SerializeObject(new { status = "【醫療院所名稱】不能空白或超過１５個字元。" });
        }
        else 
        {
            HospitalName = HttpUtility.HtmlEncode(HospitalName);
            if (HospitalName.Length > 20)
            {
                System.Threading.Thread.Sleep(100);
                return JsonConvert.SerializeObject(new { status = "【醫療院所名稱】含有不正確的關鍵字。" });
            }
        }

        string ID = HttpContext.Current.Session["UserID"].ToString();
        string NAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Sqlstr = @"SELECT TOP 1 SYS_ID FROM DataHospital WHERE HospitalName=@HospitalName";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { HospitalName = HospitalName });
        if (a.Any())
        {
            return JsonConvert.SerializeObject(new { status = "已有相同的醫療院所名稱。" });
        };

        Sqlstr = @"INSERT INTO DataHospital (HospitalName, Create_ID, Create_Name) " +
            " VALUES(@HospitalName, @Create_ID, @Create_Name)";
        a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            HospitalName = HospitalName,
            Create_ID = ID,
            Create_Name = NAME
        });
        return JsonConvert.SerializeObject(new { status = "新增完成。" });
    }

    //================================================
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0060010009");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }
}
