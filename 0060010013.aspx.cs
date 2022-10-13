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

public partial class _0060010013 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
    }

    [WebMethod(EnableSession = true)]
    public static string List_HRM2_Location()
    {
        Check();
        string sqlstr = @"SELECT * FROM HRM2_Location WHERE Flag = '1' ORDER BY Type, Postcode";
        var a = DBTool.Query<HRM2_Location>(sqlstr).ToList().Select(p => new
        {
            SYS_ID = p.SYS_ID,
            Type = p.Type.Trim(),
            Name = p.Name.Trim(),
            Location = p.Location.Trim(),
            Postcode = p.Postcode.Trim(),
            Address = p.Address.Trim(),
            TEL = p.TEL.Trim(),
            Location_Flag = p.Location_Flag.Trim()
        });

        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 帶入【服務分類】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Service()
    {
        Check();
        string Sqlstr = @"SELECT SYS_ID, Service_ID, Service, ServiceName FROM Data WHERE Open_Flag = '1' AND Service !='外包商' ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            Service_ID = p.Service_ID,
            Service = p.Service,
            ServiceName = p.ServiceName
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 刪除【單位地址】資訊 =============
    [WebMethod(EnableSession = true)]
    public static string Delete(string SYS_ID)
    {
        Check();

        if (JASON.IsInt(SYS_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }

        string Sqlstr = "";
        Sqlstr = @"UPDATE HRM2_Location SET Flag='0' WHERE SYS_ID = @SYS_ID";

        using (IDbConnection conn = DBTool.GetConn())
        {
            conn.Execute(Sqlstr, new { SYS_ID = SYS_ID });
            conn.Close();
        }
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //============= 新增【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Location(string SYS_ID, string Type, string Name,
        string Location, string Postcode, string Address, string TEL, string Location_Flag)
    {
        //表單輸入內容包含系統不允許的字元
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string Flag = "1";
        string status;
        string Sqlstr;

        if (JASON.IsInt(SYS_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        string back = "";
        List<XXS> check_value = new List<XXS>();
        check_value.Add(new XXS { URL_ID = Name, MiniLen = 1, MaxLen = 30, Alert_Name = "單位名稱", URL_Type = "txt" });
        check_value.Add(new XXS { URL_ID = Type, MiniLen = 1, MaxLen = 0, Alert_Name = "所屬服務", URL_Type = "date" });
        check_value.Add(new XXS { URL_ID = Location, MiniLen = 0, MaxLen = 30, Alert_Name = "區域名稱", URL_Type = "txt" });
        check_value.Add(new XXS { URL_ID = Postcode, MiniLen = 5, MaxLen = 5, Alert_Name = "郵遞區號", URL_Type = "int" });
        check_value.Add(new XXS { URL_ID = Address, MiniLen = 1, MaxLen = 100, Alert_Name = "地址", URL_Type = "txt" });
        check_value.Add(new XXS { URL_ID = TEL, MiniLen = 0, MaxLen = 20, Alert_Name = "電話", URL_Type = "tel" });
        check_value.Add(new XXS { URL_ID = Location_Flag, MiniLen = 1, MaxLen = 0, Alert_Name = "所屬區域", URL_Type = "date" });
        JavaScriptSerializer Serializer = new JavaScriptSerializer();
        string outputJson = Serializer.Serialize(check_value);
        back = JASON.Check_XSS(outputJson);
        if (back != "")
        {
            return JsonConvert.SerializeObject(new { status = back });
        };

        Sqlstr = @"SELECT TOP 1 SYS_ID FROM Data WHERE Service_ID=@Type AND Open_Flag !='0' AND Service !='外包商' ";
        var a = DBTool.Query<HRM2_Location>(Sqlstr, new
       {
           Type = Type
       });

        if (!a.Any())
        {
            return JsonConvert.SerializeObject(new { status = error });
        };

        if (Location_Flag != "北北基" && Location_Flag != "桃竹苗" && Location_Flag != "中彰投" &&
            Location_Flag != "雲嘉南" && Location_Flag != "高高屏" && Location_Flag != "宜花東")
        {
            return JsonConvert.SerializeObject(new { status = error });
        };

        Sqlstr = @"SELECT TOP 1 SYS_ID FROM HRM2_Location WHERE Type=@Type " +
           "AND Name=@Name " +
           "AND Postcode=@Postcode " +
           "AND Address=@Address " +
           "AND TEL=@TEL " +
           "AND Location_Flag=@Location_Flag " +
           "AND Flag = '1'";

        a = DBTool.Query<HRM2_Location>(Sqlstr, new
       {
           Type = Type,
           Name = Name,
           Postcode = Postcode,
           Address = Address,
           TEL = TEL,
           Location_Flag = Location_Flag
       });

        if (a.Any())
        {
            return JsonConvert.SerializeObject(new { status = "已有相同資訊。" });
        };

        if (SYS_ID == "0") { Flag = "0"; };
        if (Flag == "0")
        {
            Sqlstr = @"INSERT INTO HRM2_Location ( Type, Name, Location, Postcode, Address, TEL, Location_Flag ) " +
           " VALUES( @Type, @Name, @Location, @Postcode, @Address, @TEL, @Location_Flag )";
            status = "新增完成。";
        }
        else
        {
            Sqlstr = @"UPDATE HRM2_Location SET Type=@Type, Name=@Name, Location=@Location, " +
            "Postcode=@Postcode, Address=@Address, TEL=@TEL, Location_Flag=@Location_Flag " +
             "WHERE SYS_ID=@SYS_ID";
            status = "修改完成。";
        }

        a = DBTool.Query<HRM2_Location>(Sqlstr, new
       {
           SYS_ID = SYS_ID,
           Type = Type,
           Name = Name,
           Location = Location,
           Postcode = Postcode,
           Address = Address,
           TEL = TEL,
           Location_Flag = Location_Flag
       });
        return JsonConvert.SerializeObject(new { status = status });
    }

    //============= 帶入【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_HRM2_Location(string SYS_ID)
    {
        Check();

        if (JASON.IsInt(SYS_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        };

        string Sqlstr = @"SELECT * FROM HRM2_Location WHERE Flag = '1' AND SYS_ID = @SYS_ID";
        var a = DBTool.Query<HRM2_Location>(Sqlstr, new { SYS_ID = SYS_ID }).ToList().Select(p => new
        {
            SYS_ID = p.SYS_ID,
            Type = p.Type.Trim(),
            Name = p.Name.Trim(),
            Location = p.Location.Trim(),
            Postcode = p.Postcode.Trim(),
            Address = p.Address.Trim(),
            TEL = p.TEL.Trim(),
            Location_Flag = p.Location_Flag.Trim()
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
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
        public string SYS_ID { get; set; }
        public string Type { get; set; }
        public string Name { get; set; }
        public string Location { get; set; }
        public string Postcode { get; set; }
        public string Address { get; set; }
        public string TEL { get; set; }
        public string Location_Flag { get; set; }
    }
}
