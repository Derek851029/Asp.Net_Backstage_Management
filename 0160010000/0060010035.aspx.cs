using Dapper;
using Newtonsoft.Json;
using System;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using log4net.Config;

public partial class _0350010001 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Check();
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Team()
    {
        Check();
        string sqlstr = "";
        sqlstr = @"DECLARE @t1 TABLE (Agent_Team nvarchar(50)); " +
            "insert into @t1(Agent_Team) values ('全部')  select 0 as ID,Agent_Team from @t1 " +
            "UNION " +
            "SELECT DISTINCT 1 as ID, Agent_Team FROM DispatchSystem WHERE Agent_ID !='' AND Agent_Status = '在職' ORDER BY ID, Agent_Team ";
        var a = DBTool.Query<Message_Value>(sqlstr).ToList().Select(p => new
        {
            ID = p.ID,
            Agent_Team = p.Agent_Team
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Message()
    {
        Check();
        string sqlstr = "";
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        if (Agent_LV == "10")
        {
            sqlstr = @"SELECT SYSID, Tag_Team, Create_Team, Create_Name, Create_Time, Title, Message FROM Msg_Message WHERE Tag_Team IN (@Agent_Team, '全部' ) AND Flag='0' ";
        }
        else
        {
            sqlstr = @"SELECT SYSID, Tag_Team, Create_Team, Create_Name, Create_Time, Title, Message FROM Msg_Message WHERE Flag='0' ";
        }

        var a = DBTool.Query<Message_Value>(sqlstr, new { Agent_Team = Agent_Team }).ToList().Select(p => new
        {
            SYSID = p.SYSID,
            Tag_Team = p.Tag_Team,
            Create_Team = p.Create_Team,
            Create_Name = p.Create_Name,
            Create_Time = p.Create_Time.ToString("yyyy/MM/dd HH:mm"),
            Title = HttpUtility.HtmlEncode(p.Title.Trim()),
            Message = HttpUtility.HtmlEncode(p.Message.Trim())
        });

        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Response(string ID)
    {
        Check();

        if (ID.Length > 10)
        {
            ID = "0";
        }
        else
        {
            if (JASON.IsInt(ID) != true)
            {
                ID = "0";
            }
        }

        string sqlstr = "";
        sqlstr = @"SELECT Agent_Name, Agent_Team, Response, Response_Time FROM Msg_Response WHERE ID=@ID ORDER BY Response_Time ";
        var a = DBTool.Query<Message_Value>(sqlstr, new { ID = ID }).ToList().Select(p => new
        {
            Agent_Team = p.Agent_Team,
            Agent_Name = p.Agent_Name,
            Response = HttpUtility.HtmlEncode(p.Response.Trim()),
            Response_Time = p.Response_Time.ToString("yyyy/MM/dd HH:mm")
        });

        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Msg(string Msg, string ID)
    {
        Check();
        int int_len = 0;
        string value = "";
        string error = "訊息發送失敗。";

        if (ID.Length > 10)
        {
            return JsonConvert.SerializeObject(new { status = "1", txt = error });
        }
        else
        {
            if (JASON.IsInt(ID) != true)
            {
                return JsonConvert.SerializeObject(new { status = "1", txt = error });
            }
        }

        Msg = Msg.Trim();

        if (Msg.Length < 1)
        {
            return JsonConvert.SerializeObject(new { status = "1", txt = error });
        }

        if (Msg.Length > 250)
        {
            return JsonConvert.SerializeObject(new { status = "1", txt = error });
        }
        else
        {
            int_len = Msg.Length;
            value = HttpUtility.HtmlEncode(Msg);
            if (value.Length != int_len)
            {
                return JsonConvert.SerializeObject(new { status = "1", txt = error });
            };
        }

        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string sqlstr = "";
        sqlstr = @"INSERT INTO Msg_Response ( ID, Agent_ID, Agent_Name, Agent_Team, Response ) " +
            " VALUES ( @ID, @Agent_ID, @Agent_Name, @Agent_Team, @Response ) ";

        Message_Value Template = new Message_Value()
        {
            ID = ID,
            Agent_ID = UserID,
            Agent_Name = UserIDNAME,
            Agent_Team = Agent_Team,
            Response = Msg
        };

        using (IDbConnection db = DBTool.GetConn())
        {
            db.Execute(sqlstr, Template);
            db.Close();
        }

        return JsonConvert.SerializeObject(new { status = "0", txt = "訊息發送成功。" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0060010035.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string SendMag(string[] str_Array, string Title, string Message)
    {
        Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_Name = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string check = "";
        string sqlstr = "";
        string back = "";
        bool all = Array.IndexOf(str_Array, "全部") >= 0;

        List<XXS> check_value = new List<XXS>();
        check_value.Add(new XXS { URL_ID = Title, MiniLen = 1, MaxLen = 250, Alert_Name = "公告標題", URL_Type = "txt" });
        check_value.Add(new XXS { URL_ID = Message, MiniLen = 1, MaxLen = 250, Alert_Name = "公告內容", URL_Type = "txt" });
        JavaScriptSerializer Serializer = new JavaScriptSerializer();
        string outputJson = Serializer.Serialize(check_value);
        back = JASON.Check_XSS(outputJson);
        if (back != "")
        {
            return back;
        };

        if (str_Array.Length != 0)
        {
            if (all == true)
            {
                sqlstr = @"INSERT INTO Msg_Message (Tag_ID, Tag_Name, Tag_Team, Create_ID, Create_Name, Create_Team, Title, Message) " +
                    "VALUES ('', '', '全部', @Agent_ID, @Agent_Name, @Agent_Team, @Title, @Message) ";
            }
            else
            {
                sqlstr = "Declare @Array table(Value nvarchar(20)) ";
                for (int i = 0; i < str_Array.Length; i++)
                {
                    //=========================================
                    check = @"SELECT TOP 1 SYSID FROM DispatchSystem WHERE Agent_Status != '離職' AND Agent_Team=@Agent_Team";
                    var a = DBTool.Query<ClassTemplate>(check, new { Agent_Team = str_Array[i] });
                    if (a.Any())
                    {
                        sqlstr += "INSERT INTO @Array (Value) VALUES ('" + str_Array[i] + "') ";
                    };
                    //=========================================
                }
                sqlstr += @"INSERT INTO Msg_Message (Tag_ID, Tag_Name, Tag_Team, Create_ID, Create_Name, Create_Team, Title, Message) " +
                    "SELECT '', '', Value, @Agent_ID, @Agent_Name, @Agent_Team, @Title, @Message " +
                    "FROM @Array ";
            }

            var b = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = Agent_ID, Agent_Name = Agent_Name, Agent_Team = Agent_Team, Title = Title, Message = Message });
            return "公告發送完成。";
        }
        else
        {
            return "請選擇要發送的部門。";
        }
    }

    public class Message_Value
    {
        public string SYSID { get; set; }
        public string ID { get; set; }
        public string Tag_Team { get; set; }
        public string Create_Team { get; set; }
        public string Create_Name { get; set; }
        public DateTime Create_Time { get; set; }
        public string Agent_ID { get; set; }
        public string Agent_Team { get; set; }
        public string Agent_Company { get; set; }
        public string Agent_Name { get; set; }
        public string Response { get; set; }
        public DateTime Response_Time { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
    }
}
