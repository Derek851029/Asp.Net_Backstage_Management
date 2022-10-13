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

public partial class _0060010008 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
    }

    [WebMethod(EnableSession = true)]
    public static string List_Master_DATA()
    {
        Check();
        string sqlstr = @"SELECT * FROM Master_DATA WHERE Flag='1' ORDER BY Agent_Team,Agent_Name";
        var a = DBTool.Query<EMMA>(sqlstr).ToList().Select(p => new
        {
            SYSID = p.SYSID,
            Agent_LV = p.Agent_LV,
            Agent_Mail = p.E_Mail,
            Agent_Name = p.Agent_Name,
            Agent_Team = p.Agent_Team
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]
    public static string Delete(string SYSID)
    {
        Check();
        string Sqlstr = "";
        Sqlstr = @"UPDATE Master_DATA SET Flag='0'  WHERE SYSID = @SYSID";
        using (IDbConnection conn = DBTool.GetConn())
        {
            conn.Execute(Sqlstr, new { SYSID = SYSID });
            conn.Close();
        }
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //============= 帶入【部門】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Agent_Team()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT Agent_Team, count(*) as Type FROM DispatchSystem WHERE Agent_Status != '離職' " +
            "GROUP BY Agent_Team ORDER BY Agent_Team";
        var a = DBTool.Query<EMMA>(Sqlstr).ToList().Select(p => new
        {
            Agent_Team = p.Agent_Team,
            Type = p.Type
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 帶入【人員】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Agent_Name(string Agent_Team)
    {
        Check();
        string Sqlstr = @"SELECT Agent_ID, Agent_Name FROM DispatchSystem " +
            "WHERE Agent_Status != '離職' AND Agent_Team = @Agent_Team ORDER BY Agent_Name, Agent_ID";
        var a = DBTool.Query<EMMA>(Sqlstr, new { Agent_Team = Agent_Team }).ToList().Select(p => new
        {
            Agent_ID = p.Agent_ID,
            Agent_Name = p.Agent_Name
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Agent(string Agent_ID)
    {
        Check();
        string outputJson;
        string Sqlstr = @"SELECT Agent_Name, Agent_Mail, UserID FROM DispatchSystem " +
            "WHERE Agent_Status != '離職' AND Agent_ID = @Agent_ID";
        var a = DBTool.Query<EMMA>(Sqlstr, new { Agent_ID = Agent_ID });
        if (!a.Any())
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { status = "NULL" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        else
        {
            outputJson = JsonConvert.SerializeObject(
               a.ToList().Select(p => new
               {
                   status = "OK",
                   Agent_Name = p.Agent_Name,
                   Agent_Mail = p.Agent_Mail,
                   UserID = p.UserID
               })
           );
            return outputJson;
        };
    }

    //============= 新增【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Agent(string SYSID, string UserID, string Agent_LV, string Agent_Mail)
    {
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (UserID.Length < 1)
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【通知人員】。" });
        };

        //驗證 Agent_Mail 【電子信箱】
        Agent_Mail = Agent_Mail.Trim();
        if (!String.IsNullOrEmpty(Agent_Mail))
        {
            if (Agent_Mail.Length > 50)
            {
                return JsonConvert.SerializeObject(new { status = "【電子信箱】不能超過５０個字元。" });
            }
            else
            {
                if (JASON.IsEmail(Agent_Mail) != true)
                {
                    return JsonConvert.SerializeObject(new { status = "【電子信箱】格式不正確。" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【電子信箱】。" });
        }

        if (Agent_LV != "10" && Agent_LV != "15")
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        if (JASON.IsNumeric(SYSID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        string status = "";
        string Sqlstr = "";
        string Flag = "0";
        string Agent_Name = "";
        string Agent_Team = "";

        if (SYSID != "0")
        {
            Flag = "1";
        }

        Sqlstr = @"SELECT TOP 1 SYSID, Agent_Name, Agent_Team FROM DispatchSystem WHERE UserID=@UserID AND Agent_Status != '離職'";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { UserID = UserID });
        if (a.Any())
        {
            ClassTemplate schedule = a.First();
            Agent_Name = schedule.Agent_Name;
            Agent_Team = schedule.Agent_Team;

            Sqlstr = @"SELECT TOP 1 SYSID FROM Master_DATA WHERE UserID=@UserID AND Agent_Team=@Agent_Team AND SYSID != @SYSID AND Flag='1' ";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new { UserID = UserID, SYSID = SYSID, Agent_Team = Agent_Team });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有重複的通知人員。" });
            };

            if (Flag == "0")
            {
                Sqlstr = @"INSERT INTO Master_DATA (UserID, Agent_LV, Agent_Name, Agent_Team, E_Mail, login) " +
               " VALUES(@UserID, @Agent_LV, @Agent_Name, @Agent_Team, @E_Mail, @login)";
                status = "新增完成。";
            }
            else
            {
                Sqlstr = @"UPDATE Master_DATA SET UserID=@UserID, E_Mail=@E_Mail, login=@login, " +
               "Agent_LV=@Agent_LV, Agent_Name=@Agent_Name, Agent_Team=@Agent_Team " +
               "WHERE SYSID=@SYSID";
                status = "修改完成。";
            }

            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                Agent_Name = Agent_Name,
                Agent_LV = Agent_LV,
                Agent_Team = Agent_Team,
                E_Mail = Agent_Mail,
                UserID = UserID,
                login = JASON.Encryption(UserID),
                SYSID = SYSID
            });
            return JsonConvert.SerializeObject(new { status = status });
        }

        return JsonConvert.SerializeObject(new { status = error });
    }

    //============= 帶入【服務】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Agent(string SYSID)
    {
        Check();
        string Sqlstr = @"SELECT UserID, Agent_LV, E_Mail, Agent_Name, Agent_Team FROM Master_DATA WHERE SYSID = @SYSID";
        string outputJson = "";
        var a = DBTool.Query<EMMA>(Sqlstr, new { SYSID = SYSID });
        if (!a.Any())
        {
            outputJson = "[" + JsonConvert.SerializeObject(new
            {
                status = "error",
                note = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。"
            }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        else
        {
            outputJson = JsonConvert.SerializeObject(
                a.ToList().Select(p => new
                {
                    status = "ok",
                    UserID = p.UserID,
                    Agent_LV = p.Agent_LV,
                    Agent_Mail = p.E_Mail,
                    Agent_Name = p.Agent_Name,
                    Agent_Team = p.Agent_Team
                })
            );
        }
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0060010008.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }
}
