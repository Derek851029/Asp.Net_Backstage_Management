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

public partial class _0030010002 : System.Web.UI.Page
{
    protected string str_time;
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end, string Agent_ID, string Agent_Team)
    {
        string sql_txt = @"SELECT Agent_Team, Agent_Name, Convert(nvarchar(4),count(*)) as Flag, StartTime, EndTime, Cust_Name, ServiceName FROM CASEDetail " +
           "WHERE EndTime BETWEEN @start AND @end ";
        if (Agent_Team != "")
        {
            sql_txt = sql_txt + "AND Agent_Team=@Agent_Team ";
            if (Agent_ID != "")
            {
                sql_txt = sql_txt + "AND Agent_ID=@Agent_ID ";
            }
        }
        sql_txt = sql_txt + "GROUP BY Agent_Team, Agent_Name, StartTime, EndTime, Cust_Name, ServiceName";
        //"WHERE convert(varchar, EndTime, 112) BETWEEN convert(varchar, getdate(), 112) AND convert(varchar, getdate(), 112) ";
        string outputJson = "";
        var chk = DBTool.Query<ClassTemplate>(sql_txt, new { start = start, end = end, Agent_ID = Agent_ID, Agent_Team = Agent_Team });
        outputJson = JsonConvert.SerializeObject(
            chk.ToList().Select(p => new
            {
                title = "客戶：" + p.Cust_Name + "\n" + "服務：" + p.ServiceName + "\n" + "部門：" + p.Agent_Team + "\n" + "人員：" + p.Agent_Name + "\n" + "筆數：" + p.Flag,
                start = p.StartTime.ToString("yyyy/MM/dd HH:mm"),
                end = p.EndTime.ToString("yyyy/MM/dd HH:mm")
            })
        );
        return outputJson;
    }

    //============= 帶入【被派人員（部門）】資訊 =============
    [WebMethod(EnableSession = true)]
    public static string Agent_Team()
    {
        string sqlstr = @"SELECT Agent_Team FROM CASEDetail group by Agent_Team ORDER BY Agent_Team";
        var a = DBTool.Query<ClassTemplate>(sqlstr).ToList().Select(p => new
        {
            Agent_Team = p.Agent_Team
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 帶入【被派人員（人員）】資訊 =============
    [WebMethod(EnableSession = true)]
    public static string Agent_Name(string value)
    {
        string sqlstr = @"SELECT Agent_ID, Agent_Name FROM CASEDetail WHERE Agent_Team = @Agent_Team group by Agent_ID,Agent_Name ORDER BY Agent_Name";
        var a = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_Team = value }).ToList().Select(p => new
        {
            Agent_ID = p.Agent_ID,
            Agent_Name = p.Agent_Name
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }
}