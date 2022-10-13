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

public partial class _0060010011 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
    }

    [WebMethod(EnableSession = true)]
    public static string List_DataCar()
    {
        Check();
        string sqlstr = @"SELECT * FROM DataCar WHERE Flag = '1' ORDER BY Agent_Team,Agent_Name";
        var a = DBTool.Query<ClassTemplate>(sqlstr).ToList().Select(p => new
        {
            SYS_ID = p.SYS_ID,
            CarName = p.CarName,
            CarNumber = p.CarNumber,
            Agent_Name = p.Agent_Name,
            Agent_Team = p.Agent_Team
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]
    public static string Delete(string SYS_ID)
    {
        Check();
        string Sqlstr = "";
        Sqlstr = @"UPDATE DataCar SET Flag='0' WHERE SYS_ID = @SYS_ID";

        using (IDbConnection conn = DBTool.GetConn())
        {
            conn.Execute(Sqlstr, new { SYS_ID = SYS_ID });
            conn.Close();
        }
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //============= 帶入【服務分類】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Agent_Team()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT Agent_Team FROM DataCar WHERE Flag = '1' ORDER BY Agent_Team";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            Agent_Team = p.Agent_Team
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 新增【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Car(string SYS_ID, string Agent_Team, string Agent_Name, string CarName, string CarNumber)
    {
        Check();
        string status;
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        int int_len = 0;

        if (JASON.IsInt(SYS_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        //============================================================
        if (Agent_Team.Length < 1 || Agent_Team.Length > 15)
        {
            System.Threading.Thread.Sleep(50);
            return JsonConvert.SerializeObject(new { status = "【所屬部門】不能空白或超過１５個字元。" });
        }
        else
        {
            int_len = Agent_Team.Length;
            Agent_Team = HttpUtility.HtmlEncode(Agent_Team);
            if (Agent_Team.Length != int_len)
            {
                System.Threading.Thread.Sleep(50);
                return JsonConvert.SerializeObject(new { status = "【所屬部門】含有不正確的關鍵字。" });
            }
        }

        //=============================================================
        if (Agent_Name.Length < 1 || Agent_Name.Length > 10)
        {
            System.Threading.Thread.Sleep(50);
            return JsonConvert.SerializeObject(new { status = "【所屬人員】不能空白或超過１０個字元。" });
        }
        else
        {
            int_len = Agent_Name.Length;
            Agent_Name = HttpUtility.HtmlEncode(Agent_Name);
            if (Agent_Name.Length != int_len)
            {
                System.Threading.Thread.Sleep(50);
                return JsonConvert.SerializeObject(new { status = "【所屬人員】含有不正確的關鍵字。" });
            }
        }

        //=============================================================
        if (CarNumber.Length < 1 || CarNumber.Length > 15)
        {
            System.Threading.Thread.Sleep(50);
            return JsonConvert.SerializeObject(new { status = "【車牌號碼】不能空白或超過１５個字元。" });
        }
        else
        {
            if (JASON.IsCar(CarNumber) != true)
            {
                return JsonConvert.SerializeObject(new { status = "【車牌號碼】格式不正確。" });
            }
        }

        //=============================================================
        if (CarName != "私用車" && CarName != "公用車")
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        string Sqlstr = @"SELECT TOP 1 SYS_ID FROM DataCar WHERE CarNumber=@CarNumber AND Flag = '1' AND SYS_ID != @SYS_ID";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { CarNumber = CarNumber, SYS_ID = SYS_ID });
        if (a.Any())
        {
            return JsonConvert.SerializeObject(new { status = "已有相同的車牌號碼。" });
        };

        string Flag = "0";
        if (SYS_ID != "0")
        {
            Flag = "1";
        };

        if (Flag == "0")
        {
            Sqlstr = @"INSERT INTO DataCar (CarName, CarNumber, Agent_Name, Agent_Team) " +
           " VALUES(@CarName, @CarNumber, @Agent_Name, @Agent_Team)";
            status = "新增完成。";
        }
        else
        {
            Sqlstr = @"UPDATE DataCar SET CarName=@CarName, CarNumber=@CarNumber, " +
           "Agent_Name=@Agent_Name, Agent_Team=@Agent_Team " +
           "WHERE SYS_ID=@SYS_ID";
            status = "修改完成。";
        }

        a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            CarName = CarName,
            CarNumber = CarNumber,
            Agent_Name = Agent_Name,
            Agent_Team = Agent_Team,
            SYS_ID = SYS_ID
        });
        return JsonConvert.SerializeObject(new { status = status });
    }

    //============= 帶入【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Car(string SYS_ID)
    {
        Check();
        string Sqlstr = @"SELECT CarName, CarNumber, Agent_Name, Agent_Team FROM DataCar WHERE SYS_ID = @SYS_ID";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { SYS_ID = SYS_ID }).ToList().Select(p => new
        {
            CarName = p.CarName,
            CarNumber = p.CarNumber,
            Agent_Name = p.Agent_Name,
            Agent_Team = p.Agent_Team
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //================================================
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0060010011");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }
}
