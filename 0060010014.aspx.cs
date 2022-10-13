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

public partial class _0060010014 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
    }


    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Labor(string SYSID)
    {
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string back = "";
        string Sqlstr = "";
        List<XXS> check_value = new List<XXS>();
        check_value.Add(new XXS { URL_ID = SYSID, MiniLen = 1, MaxLen = 8, Alert_Name = "SYSID", URL_Type = "int" });
        JavaScriptSerializer Serializer = new JavaScriptSerializer();
        string outputJson = Serializer.Serialize(check_value);
        back = JASON.Check_XSS(outputJson);
        if (back != "")
        {
            return "[" + JsonConvert.SerializeObject(new { status = error }) + "]"; // 組合JSON 格式
        };

        Sqlstr = @"SELECT TOP 1 SYSID, Cust_FullName, Labor_ID, Labor_CName, Labor_Phone " +
            "FROM Labor_System " +
            "WHERE Cust_ID != '' AND Labor_Type = '任用' AND SYSID = @SYSID";
        var a = DBTool.Query<HRM2_Location>(Sqlstr, new { SYSID = SYSID });

        if (!a.Any())
        {
            return "[" + JsonConvert.SerializeObject(new { status = error }) + "]"; // 組合JSON 格式
        }

        var b = a.Select(p => new
        {
            SYSID = p.SYSID,
            Cust_FullName = p.Cust_FullName,
            Labor_ID = p.Labor_ID,
            Labor_CName = p.Labor_CName,
            Labor_Phone = p.Labor_Phone,
            status = ""
        });

        return JsonConvert.SerializeObject(b);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Edit_TEL(string SYSID, string Labor_Phone)
    {
        Check();
        string back = "";
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
               
        if (JASON.IsInt(SYSID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        if (SYSID.Length > 8 || SYSID.Length < 1)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        List<XXS> check_value = new List<XXS>();
        check_value.Add(new XXS { URL_ID = Labor_Phone, MiniLen = 10, MaxLen = 10, Alert_Name = "聯絡電話", URL_Type = "int" });
        JavaScriptSerializer Serializer = new JavaScriptSerializer();
        string outputJson = Serializer.Serialize(check_value);
        back = JASON.Check_XSS(outputJson);
        if (back != "")
        {
            return JsonConvert.SerializeObject(new { status = back });
        };

        string sql_txt = @"UPDATE Labor_System SET " +
           "Labor_Phone=@Labor_Phone " +
           "WHERE Cust_ID != '' AND Labor_Type = '任用' AND SYSID = @SYSID";

        HRM2_Location template = new HRM2_Location()
        {
            SYSID = SYSID,
            Labor_Phone = Labor_Phone
        };

        using (IDbConnection db = DBTool.GetConn())
        {
            db.Execute(sql_txt, template);
            db.Close();
        }
        return JsonConvert.SerializeObject(new { status = "ok" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0060010012");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }

    public class HRM2_Location
    {
        public string SYSID { get; set; }
        public string Cust_FullName { get; set; }
        public string Labor_ID { get; set; }
        public string Labor_CName { get; set; }
        public string Labor_Phone { get; set; }
    }
}
