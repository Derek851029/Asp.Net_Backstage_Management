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

public partial class _0060010012 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
    }

    [WebMethod(EnableSession = true)]
    public static string List_Team_Group()
    {
        Check();
        string sqlstr = @"SELECT * FROM Agent_Team_Group ORDER BY Agent_Team";
        var a = DBTool.Query<Agent_Team_Group>(sqlstr).ToList().Select(p => new
        {
            //Time_01 = DateTime.Now.ToString("yyyy/MM/dd HH:mm");
            SYS_ID = p.SYS_ID,
            Agent_Team = p.Agent_Team.Trim(),
            Flag_1 = p.Flag_1,
            Flag_2 = p.Flag_2,
            Flag_3 = p.Flag_3,
            Flag_4 = p.Flag_4,
            Flag_5 = p.Flag_5,
            Flag_6 = p.Flag_6
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 帶入【服務分類】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Agent_Team()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT Agent_Team FROM View_WorkDate WHERE Flag_1 IS NULL ORDER BY Agent_Team";
        var a = DBTool.Query<Agent_Team_Group>(Sqlstr).ToList().Select(p => new
        {
            Agent_Team = p.Agent_Team
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 刪除【Agent_Team_Group】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Delete(string SYS_ID)
    {
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";

        if (JASON.IsInt(SYS_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error });
        };

        string Sqlstr = @"DELETE FROM Agent_Team_Group WHERE SYS_ID=@SYS_ID";
        var a = DBTool.Query<Agent_Team_Group>(Sqlstr, new { SYS_ID = SYS_ID });
        return JsonConvert.SerializeObject(new { status = "刪除完成。" });

    }

    //============= 新增【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Agent_Team(string Agent_Team)
    {
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";

        if (Agent_Team.Length < 1)
        {
            System.Threading.Thread.Sleep(50);
            return JsonConvert.SerializeObject(new { status = "請選擇【派工部門】。" });
        }

        string Sqlstr = @"SELECT DISTINCT Agent_Team FROM View_WorkDate WHERE Flag_1 IS NULL AND Agent_Team=@Agent_Team";
        var a = DBTool.Query<Agent_Team_Group>(Sqlstr, new { Agent_Team = Agent_Team });
        if (!a.Any())
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        System.Threading.Thread.Sleep(50);

        Sqlstr = @"SELECT TOP 1 SYS_ID FROM Agent_Team_Group WHERE Agent_Team=@Agent_Team ";
        a = DBTool.Query<Agent_Team_Group>(Sqlstr, new { Agent_Team = Agent_Team });
        if (a.Any())
        {
            return JsonConvert.SerializeObject(new { status = "已有相同的部門。" });
        };

        System.Threading.Thread.Sleep(50);

        Sqlstr = @"INSERT INTO Agent_Team_Group (Agent_Team) VALUES(@Agent_Team)";
        a = DBTool.Query<Agent_Team_Group>(Sqlstr, new { Agent_Team = Agent_Team });

        System.Threading.Thread.Sleep(50);

        return JsonConvert.SerializeObject(new { status = "新增完成。" });
    }

    //============= Checkbox 開關 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Checkbox(string Flag, string value, string SYS_ID)
    {
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";

        try
        {
            int i = Int32.Parse(Flag);
            if (i < 1 || i > 6)
            {
                return JsonConvert.SerializeObject(new { status = error });
            }
            Flag = "Flag_" + Flag;
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        if (value != "0" && value != "1")
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        if (value == "0")
        {
            value = "1";
        }
        else
        {
            value = "0";
        };

        if (JASON.IsInt(SYS_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        string Sqlstr = @"UPDATE Agent_Team_Group SET " + Flag + "=@value WHERE SYS_ID = @SYS_ID";
        using (IDbConnection conn = DBTool.GetConn())
        {
            conn.Execute(Sqlstr, new { SYS_ID = SYS_ID, value = value });
            conn.Close();
        }
        return JsonConvert.SerializeObject(new { status = "修改完成。" });
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

    public class Agent_Team_Group
    {
        public string SYS_ID { get; set; }
        public string Agent_Team { get; set; }
        public string value { get; set; }
        public string Flag_1 { get; set; }
        public string Flag_2 { get; set; }
        public string Flag_3 { get; set; }
        public string Flag_4 { get; set; }
        public string Flag_5 { get; set; }
        public string Flag_6 { get; set; }
    }
}
