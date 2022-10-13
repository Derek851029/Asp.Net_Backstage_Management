using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using log4net.Config;

public partial class _0250010001 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Title(string PID, string T_ID, string ADDR, string Name, string MTEL, string CycleTime, string Agent, string C_Name,  //string PID2, 
        string C_1, string C_2, string C_3, string C_4, string C_5, string C_6, string C_7, string C_8, string C_9, string C_10, string C_11, string C_12
        )
    {
        //return JsonConvert.SerializeObject(new { status = C_1 + C_2 + C_3 + Checkbox(C_4) + Checkbox(C_5) + Checkbox(C_6), Flag = "0" });
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        int i = 0;
        //===========================================================
        if (String.IsNullOrEmpty(PID))
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【客戶】", Flag = "0" });
        }
        //===========================================================
        if (!String.IsNullOrEmpty(C_Name))
        {
            i = Name.Length;
            if (Name.Length > 50)
            {
                return JsonConvert.SerializeObject(new { status = "【客戶名稱】不能超過５０個字元。", Flag = "0" });
            }
            else
            {
                Name = HttpUtility.HtmlEncode(Name.Trim());
                if (Name.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【客戶名稱】", Flag = "0" });
        }
        //==========================================================
        if (!String.IsNullOrEmpty(T_ID))
        {
            if (!new string[] { "中華電信", "遠傳", "德瑪", "其他" }.Contains(T_ID))
            {
                return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【維護廠商】", Flag = "0" });
        }
        //==========================================================
        if (!String.IsNullOrEmpty(ADDR))
        {
            i = ADDR.Length;
            if (ADDR.Length > 200)
            {
                return JsonConvert.SerializeObject(new { status = "【維護地址】不能超過２００個字元。", Flag = "0" });
            }
            else
            {
                ADDR = HttpUtility.HtmlEncode(ADDR.Trim());
                if (ADDR.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【維護地址】", Flag = "0" });
        }
        //===========================================================
        if (!String.IsNullOrEmpty(Name))
        {
            i = Name.Length;
            if (Name.Length > 15)
            {
                return JsonConvert.SerializeObject(new { status = "【聯絡人】不能超過１５個字元。", Flag = "0" });
            }
            else
            {
                Name = HttpUtility.HtmlEncode(Name.Trim());
                if (Name.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【聯絡人】", Flag = "0" });
        }
        //===========================================================
        if (!String.IsNullOrEmpty(MTEL))
        {
            i = MTEL.Length;
            if (MTEL.Length > 25)
            {
                return JsonConvert.SerializeObject(new { status = "【聯絡電話】不能超過２５個字元。", Flag = "0" });
            }
            else
            {
                MTEL = HttpUtility.HtmlEncode(MTEL.Trim());
                if (MTEL.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【聯絡電話】", Flag = "0" });
        }
        //==========================================================
        if (!String.IsNullOrEmpty(CycleTime))
        {
            if (!new string[] { "0", "1", "2", "3", "4", "5" }.Contains(CycleTime))
            {
                return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【巡查週期】", Flag = "0" });        }
        
        //===========================================================   
        if (Check_Menu() == "")
        {
            string CycleName;
            switch (CycleTime)
            {
                case "0": CycleName = "單月";
                    break;
                case "1": CycleName = "雙月";
                    break;
                case "2": CycleName = "每季";
                    break;
                case "3": CycleName = "半年";
                    break;
                case "4": CycleName = "每年";
                    break;
                case "5": CycleName = "不維護";
                    break;
                default:
                    CycleName = "";
                    break;
            };

            DateTime Time_01 = DateTime.Now;
            /*string sqlstr = @"INSERT INTO [InSpecation_Dimax].[dbo].[Mission_Title] "
                + " ( "
                + " Agent_Team, Agent_ID, Agent_Name, PID, PID2, T_ID, ADDR, Name, MTEL, Cycle, Cycle_Name, Create_ID, Create_Name, mission_name "       //
                + " ) "
                + "SELECT TOP 1 Agent_Team, Agent_ID, Agent_Name, @PID, @PID2, @T_ID, @ADDR, @Name, @MTEL, @Cycle, @CycleName, @Create_ID, @Create_Name, @C_Name "
                + "FROM [DispatchSystem] WHERE Agent_ID=@Agent_ID ";    //*/
            string sqlstr = @"INSERT INTO [InSpecation_Dimax].[dbo].[Mission_Title] "
                + " ( mission_name, PID, T_ID, ADDR, Name, MTEL, Cycle, Cycle_Name, Create_ID, Create_Name, " //PID2, 
                + " M_1, M_2, M_3, M_4, M_5, M_6, M_7, M_8, M_9, M_10, M_11, M_12) "       //
                + " values(@C_Name, @PID, @T_ID, @ADDR, @Name, @MTEL, @Cycle, @CycleName, @Create_ID, @Create_Name, "    //@PID2, 
                + " @M_1, @M_2, @M_3, @M_4, @M_5, @M_6, @M_7, @M_8, @M_9, @M_10, @M_11, @M_12) ";
            using (IDbConnection db = DBTool.GetConn())
            {
                db.Execute(sqlstr, new
                {
                    PID = PID,
                    //PID2 = PID2,
                    T_ID = T_ID,
                    ADDR = ADDR,
                    Name = Name,
                    MTEL = MTEL,
                    Cycle = CycleTime,
                    CycleName = CycleName,
                    //Agent_ID = Agent,
                    Create_ID = UserID,
                    Create_Name = UserIDNAME,
                    C_Name = C_Name,
                    M_1 = Checkbox(C_1),
                    M_2 = Checkbox(C_2),
                    M_3 = Checkbox(C_3),
                    M_4 = Checkbox(C_4),
                    M_5 = Checkbox(C_5),
                    M_6 = Checkbox(C_6),
                    M_7 = Checkbox(C_7),
                    M_8 = Checkbox(C_8),
                    M_9 = Checkbox(C_9),
                    M_10 = Checkbox(C_10),
                    M_11 = Checkbox(C_11), 
                    M_12 = Checkbox(C_12), 
                });
                db.Close();
            };

            if (!string.IsNullOrEmpty(Agent))
            {
                sqlstr = @"select Top 1 Create_Date as Time_02 FROM [InSpecation_Dimax].[dbo].[Mission_Title] " +
                "order by [Create_Date] desc ";
                var list = DBTool.Query<ClassTemplate>(sqlstr);
                if (list.Any())
                {
                    ClassTemplate schedule = list.First();
                    Time_01 = schedule.Time_02;
                }
                //return JsonConvert.SerializeObject(new { status = "修改工程師失敗。 " + str_time, Flag = "1" }); 
                try
                {
                    sqlstr = @"update [InSpecation_Dimax].[dbo].[Mission_Title] set "
                    + " Mission_Title.Agent_ID = DispatchSystem.Agent_ID, "
                    + " Mission_Title.Agent_Name = DispatchSystem.Agent_Name,  "
                    + " Mission_Title.UserID = DispatchSystem.UserID,  "
                    + " Mission_Title.Agent_Team = DispatchSystem.Agent_Team "
                    + " FROM [DispatchSystem] "
                    + " WHERE Mission_Title.Create_Date = @Time and DispatchSystem.Agent_ID =@Agent";
                    var b = DBTool.Query<ClassTemplate>(sqlstr, new
                    {
                        Time = Time_01,
                        Agent = Agent
                    });
                }
                catch (Exception er)
                {
                    return JsonConvert.SerializeObject(new { status = "修改工程師失敗。 "+er, Flag = "1" }); 
                }
                    
            }

            return JsonConvert.SerializeObject(new { status = "維護客戶 新增完成。", Flag = "1" });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "權限不足。", Flag = "0" }); ;
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Get_info(string SYS_ID)
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string Sqlstr = @"SELECT TOP 1 SYSID FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@SYSID ";
        var a = DBTool.Query<InSpecation>(Sqlstr, new { SYSID = SYS_ID });
        if (a.Count() > 0)
        {
            return JsonConvert.SerializeObject(new { status = "../0250010002.aspx?seqno=" + SYS_ID, Flag = "1" });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Delete_M_T(string SYSID)
    {
        string sqlstr = @"Delete [InSpecation_Dimax].[dbo].[Mission_Title] Where SYSID=@SYSID " +
            " Delete [InSpecation_Dimax].[dbo].[Mission_List] Where ID=@SYSID ";
        DBTool.Query<ClassTemplate>(sqlstr, new { SYSID = SYSID });
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Open_Flag(string SYS_ID, string Flag)
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string str_back;
        if (Flag == "0")
        {
            Flag = "1";
            str_back = "編號【" + SYS_ID + "】維護任務已啟用。";
        }
        else
        {
            Flag = "0";
            str_back = "編號【" + SYS_ID + "】維護任務已停用。";
        };

        string Sqlstr = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@SYSID ";
        var a = DBTool.Query<InSpecation>(Sqlstr, new { SYSID = SYS_ID });
        if (a.Count() > 0)
        {
            Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Title] SET "
                + " Flag=@Flag "
                + " WHERE SYSID=@SYSID ";

            using (IDbConnection db = DBTool.GetConn())
            {
                db.Execute(Sqlstr, new { Flag = Flag, SYSID = SYS_ID });
                db.Close();
            };
            return JsonConvert.SerializeObject(new { status = str_back, Flag = "1" });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
        }
        return JsonConvert.SerializeObject(new { status = "權限不足。", Flag = "0" }); ;

    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Location()
    {
        //string Sqlstr = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_Title] ";
        string Sqlstr = @"select A.*, B.BUSINESSNAME as B_N, C.Name as C_N FROM [InSpecation_Dimax].[dbo].[Mission_Title]as A " +
            "left join [BusinessData] as B on A.PID=B.PID  " +
            "left join [Business_Sub] as C on A.PID2=C.PNumber ";
        var a = DBTool.Query<InSpecation>(Sqlstr);
        if (a.Count() > 0)
        {
            var b = a.ToList()
            .Select(p => new
            {
                SYSID = p.SYSID,
                Bus_Name = Name(p.B_N, p.C_N, p.mission_name),
                Cycle_Name = p.Cycle_Name,
                Addr = Value(p.ADDR),
                T_id = Value(p.T_ID),
                Agent_Name = p.Agent_Name,
                Flag = p.Flag,
                Flag2 = CheckToString(p.Flag)
            });
            string outputJson = JsonConvert.SerializeObject(b);
            return outputJson;
        }
        else
        {
            return "[]";
        }
    }   

    [WebMethod(EnableSession = true)]
    public static string List_PID()
    {
        string outputJson = "";
        string sqlstr = @"SELECT DISTINCT PID, BUSINESSNAME FROM BusinessData WHERE Type != '刪除' ORDER BY BUSINESSNAME";
        var a = DBTool.Query<ClassTemplate>(sqlstr).ToList().Select(p => new
        {
            PID = Value(p.PID),
            BUSINESSNAME = Value(p.BUSINESSNAME)
        });
        outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Show_PID(string value)
    {
        string Sqlstr = @"SELECT Telecomm_ID, REGISTER_ADDR, APPNAME, APP_MTEL, BUSINESSNAME, CycleTime " +
            " FROM BusinessData WHERE PID=@value";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { value = value }).ToList().Select(p => new
        {
            A = Value(p.Telecomm_ID),
            B = Value(p.REGISTER_ADDR),
            C = Value(p.APPNAME),
            D = Value(p.APP_MTEL),
            E = Value(p.BUSINESSNAME),
            F = Value(p.CycleTime),
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }
    [WebMethod(EnableSession = true)]
    public static string List_PID2(string PID)
    {
        string outputJson = "";
        if (PID == "0")
        {
            string sqlstr = @"SELECT DISTINCT PNumber, Name FROM Business_Sub";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID }).ToList().Select(p => new
            {
                A = Value(p.PNumber),
                B = Value(p.Name)
            });
            outputJson = JsonConvert.SerializeObject(a);
            return outputJson;
        }
        else
        {
            string sqlstr = @"SELECT DISTINCT PNumber, Name FROM Business_Sub WHERE PID = @PID ORDER BY Name";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID }).ToList().Select(p => new
            {
                A = Value(p.PNumber),
                B = Value(p.Name)
            });
            outputJson = JsonConvert.SerializeObject(a);
            return outputJson;
        }
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Show_PID2(string value)
    {
        string Sqlstr = @"SELECT Telecomm_ID, ADDR, APPNAME, APP_MTEL " +
            " FROM Business_Sub WHERE PNumber=@value";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { value = value }).ToList().Select(p => new
        {
            A = Value(p.Telecomm_ID),
            B = Value(p.ADDR),
            C = Value(p.APPNAME),
            D = Value(p.APP_MTEL),
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]
    public static string List_Agent(string Team)
    {
        string outputJson = "";
        string sqlstr = @"SELECT  Agent_ID, Agent_Name FROM DispatchSystem WHERE Agent_Status = '在職' AND Agent_Company = 'Engineer'";
        var a = DBTool.Query<ClassTemplate>(sqlstr, new { Team = Team }).ToList().Select(p => new
        {
            Agent_ID = p.Agent_ID,
            Agent_Name = p.Agent_Name
        });
        outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    public static bool Check_Time(string Time)
    {
        return Regex.IsMatch(Time, "^[0-9]{2}:[0-9]{2}$");
    }

    public static string Check_Menu()
    {
        return "";
    }
    public static string Name(string value, string value2, string value3)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value3))
        {
            value = value3.Trim();
        }
        else {
            if (!string.IsNullOrEmpty(value2))
            {
                value = "(子) " + value2.Trim();
            }
            else
                value = value.Trim();
        }
        return value;
    }
    public static string Value(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
        }
        return value;
    }
    public static string Checkbox(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (value =="True")
        {
            value = "1";
        }
        else
            value = "0";
        return value;
    }
    public static string CheckToString(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (value == "1")
        {
            value = "啟用";
        }
        else
            value = "停用";
        return value;
    }
    public class InSpecation
    {
        public string Cycle_Name { get; set; }
        public string Start_Time { get; set; }
        public string End_Time { get; set; }
        public string Agent_Name { get; set; }
        public string bit { get; set; }
        public string x { get; set; }
        public string y { get; set; }
        public string Flag { get; set; }
        public string SYSID { get; set; }
        public string mission_name { get; set; }
        public string person_charge { get; set; }
        public string Alphabet { get; set; }
        public string equipment_X { get; set; }
        public string equipment_Y { get; set; }
        public string equipment_name { get; set; }
        public string equipment_type1 { get; set; }
        public string equipment_question1 { get; set; }
        public string equipment_question2 { get; set; }
        public string equipment_question3 { get; set; }
        public string equipment_question4 { get; set; }
        public string equipment_question5 { get; set; }
        public string File_name { get; set; }
        public string B_N { get; set; }
        public string C_N { get; set; }
        public string ADDR { get; set; }
        public string T_ID { get; set; }
        public DateTime Work_Time { get; set; }
        public DateTime Create_Date { get; set; }
    }
}
