using Dapper;
using Newtonsoft.Json;
using System;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using log4net.Config;

public partial class _0060010006 : System.Web.UI.Page
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
    public static string GetDealerList()  //  string[] Array
    {
        //Check();
/*        string check = "";
        string sqlstr = "";
        string str_array = "";
        if (Array.Length != 0)
        {
            sqlstr = "Declare @Array table(Value nvarchar(20)) ";
            str_array = " AND Agent_Company IN ( SELECT * FROM @Array ) ";
            for (int i = 0; i < Array.Length; i++)
            {
                //=========================================
                check = @"SELECT TOP 1 SYSID FROM DispatchSystem WHERE Agent_Status != '離職' AND Agent_Company=@Agent_Company";
                var b = DBTool.Query<ClassTemplate>(check, new { Agent_Company = Array[i] });
                if (b.Any())
                {
                    sqlstr += "insert into @Array (Value) values ('" + Array[i] + "') ";
                };
                //=========================================
            }
        }   //*/

        string sqlstr = @"SELECT * FROM Dealer  " ;
        var a = DBTool.Query<T_0060010006>(sqlstr).ToList().Select(p => new
        {            
            Agent_ID = p.D_ID,//編號
            Agent_Name = p.D_Name.Trim(),//名子
            Agent_Company = p.D_PS.Trim(),//備註
        });

        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Agent_Company_List()
    {
        Check();
        string sqlstr = @"SELECT DISTINCT Agent_Company FROM DispatchSystem WHERE Agent_ID !='' AND Agent_Status = '在職' ORDER BY Agent_Company";
        var a = DBTool.Query<ClassTemplate>(sqlstr).ToList().Select(p => new
        {
            Agent_Company = p.Agent_Company.Trim()
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Agent_Team_List()
    {
        Check();
        string sqlstr = @"SELECT DISTINCT Agent_Team FROM DispatchSystem WHERE Agent_ID !='' AND Agent_Status = '在職' ORDER BY Agent_Team";
        var a = DBTool.Query<ClassTemplate>(sqlstr).ToList().Select(p => new
        {
            Agent_Team = p.Agent_Team.Trim()
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 帶入【系統選單權限】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string ROLELIST_List()
    {
        Check();
        string sqlstr = @"SELECT ROLE_ID, ROLE_NAME FROM ROLELIST WHERE OPEN_DEL = 'Y' ";
        var a = DBTool.Query<ClassTemplate>(sqlstr).ToList().Select(p => new
        {
            ROLE_ID = p.Role_ID.Trim(),
            ROLE_NAME = p.ROLE_NAME.Trim()
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 帶入【人員】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string DispatchSystem(string Agent_ID)
    {
        Check();
        string sqlstr = @"SELECT TOP 1 * FROM Dealer WHERE D_ID = @Agent_ID ";

        var a = DBTool.Query<T_0060010006>(sqlstr, new { Agent_ID = Agent_ID }).ToList().Select(p => new
        {
            Agent_ID = p.D_ID,
            Agent_Name = p.D_Name,
            PS = p.D_PS,
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 刪除【人員】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Delete(string Agent_ID)
    {
        Check();
        string sqlstr = @"delete Dealer  WHERE D_ID = @Agent_ID ";
        DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = Agent_ID });
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //============= 新增【人員】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Dealer(string PS, string Agent_Name, string Agent_ID, string Flag)      
        // string Agent_Company, string Agent_Team, string Agent_Mail, string Agent_Phone_2, string UserID, string Password, string Role_ID, string Agent_LV, string Agent_Co_TEL,
        //string Agent_Phone_3, string Agent_Code, string Agent_MVPN,
    {
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string back;
        string Sqlstr;
        string sql_pass = "";
        
        Agent_Name = Agent_Name.Trim();
        if (!String.IsNullOrEmpty(Agent_Name))
        {
            if (Agent_Name.Length > 50)
            {
                return JsonConvert.SerializeObject(new { status = "【名稱】不能超過５０個字元。" });
            }
            else
            {
                if (JASON.IsNumericOrLetterOrChinese(Agent_Name) != true)
                {
                    return JsonConvert.SerializeObject(new { status = "【名稱】只能輸入數字、英文或中文。" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【經銷商名稱】" });
        }

        //驗證 Agent_Company 【所屬公司】
        PS = PS.Trim();
        if (!String.IsNullOrEmpty(PS))
        {
            if (PS.Length > 50)
            {
                return JsonConvert.SerializeObject(new { status = "【備註】不能超過５０個字元。" });
            }
            else
            {
                PS = HttpUtility.HtmlEncode(PS);
                if (PS.Length > 50)
                {
                    return JsonConvert.SerializeObject(new { status = error });
                }
            }
        }

 /*       Sqlstr = @"SELECT TOP 1 D_Name FROM Dealer WHERE D_Name ==@Agent_Name and D_ID != @Agent_ID ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Agent_Name = Agent_Name });
        if (a.Any())
        {
            return JsonConvert.SerializeObject(new { status = "已有相同的【經銷商】" });
        };  //*/

        if (Flag == "0")
        {
            Sqlstr = @"SELECT TOP 1 D_Name FROM Dealer WHERE D_Name = @Agent_Name and D_ID != @Agent_ID";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Agent_Name = Agent_Name, Agent_ID = Agent_ID });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有相同的【經銷商】" });
            };

            Sqlstr = @"INSERT INTO Dealer (D_Name, D_PS)" +
                " VALUES(@Agent_Name, @PS )";
            back = "new";
        }
        else
        {
            Sqlstr = @"UPDATE Dealer SET " +
               "D_Name = @Agent_Name, " +
               "D_PS = @PS " +
               "WHERE D_ID = @Agent_ID";
            back = "update";
        }
        var b = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Agent_ID = Agent_ID.Trim(),
            Agent_Name = Agent_Name.Trim(),
            PS = PS.Trim(),
            //Password = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(Password, "MD5").ToUpper(),
            //UpdateTime = DateTime.Now
        });
        return JsonConvert.SerializeObject(new { status = back });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0060010006.aspx");
        if (Check == "NO")
        {
            //System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }

    public class T_0060010006
    {
        public int D_ID { get; set; }
        public string D_Name { get; set; }
        public string D_PS { get; set; }
    }
}

