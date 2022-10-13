using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Windows.Forms;
using log4net;
using log4net.Config;

public partial class _0020010008 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected string str_title;
    protected string str_type;
    protected string Answer3;
    protected string seqno;

    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        seqno = Request.Params["seqno"];
        Session["CNo"] = Request.Params["seqno"];
        string LV = Session["Agent_LV"].ToString();
        string sql_txt = "";
        if (string.IsNullOrEmpty(seqno))
        {
            Response.Redirect("0020010005.aspx");
        }
        else
        {
            sql_txt = @"SELECT TOP 1 SYSID, Agent_Team, Agent_ID, Agent_Name FROM CASEDetail WHERE CNo=@CNo";
            var chk = DBTool.Query<ClassTemplate>(sql_txt, new { CNo = seqno });
            if (!chk.Any())
            {
                Response.Write("<script>alert('查無【" + seqno + "】派工單編號'); " +
                    "location.href='/0020010000/0020010005.aspx'; </script>");
            }
            else
            {
                ClassTemplate val = chk.First();
                if (LV != "30")
                {
                    if (LV == "20")
                    {
                        if (Session["Agent_Team"].ToString() != val.Agent_Team)
                        {
                            Response.Write("<script>alert('您沒有訪問此頁面的權限，編號【" + seqno + "】非您部門的派工單，此為【" + val.Create_Team + "】部門的派工單。'); " +
                                "location.href='/0020010000/0020010005.aspx'; </script>");
                        }
                    }
                    else
                    {
                        if (Session["UserID"].ToString() != val.Agent_ID)
                        {
                            Response.Write("<script>alert('您沒有訪問此頁面的權限，編號【" + seqno + "】非您的派工單，此為【" + val.Agent_Name + "】的派工單。'); " +
                                "location.href='/0020010000/0020010005.aspx'; </script>");
                        }
                    }
                }
            };
        }
    }

    //============= 帶入【派工單內容】資訊 =============
    [WebMethod(EnableSession = true)]
    public static string CNo_Load()
    {
        Check();
        string CNo = HttpContext.Current.Session["CNo"].ToString();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string str_sql = @"SELECT * FROM CASEDetail WHERE CNo=@CNo";
        string outputJson = "";
        var chk = DBTool.Query<ClassTemplate>(str_sql, new { CNo = CNo });
        if (!chk.Any())
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { status = "NULL" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        else
        {
            outputJson = JsonConvert.SerializeObject(
                 chk.ToList().Select(p => new
                 {
                     MNo = p.MNo,
                     CNo = p.CNo,
                     StartTime = p.StartTime.ToString("yyyy/MM/dd HH:mm"),
                     EndTime = p.EndTime.ToString("yyyy/MM/dd HH:mm"),
                     OverTime = p.OverTime.ToString("yyyy/MM/dd HH:mm"),
                     Danger = p.Danger,
                     Agent_Company = p.Agent_Company,
                     Agent_Team = p.Agent_Team,
                     Agent_Name = p.Agent_Name,
                     CarAgent_Team = p.CarAgent_Team,
                     CarAgent_Name = p.CarAgent_Name,
                     CarName = p.CarName,
                     CarNumber = p.CarNumber,
                     Servicr = p.Service,
                     Answer = p.Answer,
                     Answer2 = p.Answer2,
                     Type_Value = p.Type_Value,
                     DEPT_Status = p.DEPT_Status
                 })
                 );
            return outputJson;
        }
    }

    //============= 帶入【需求單內容】資訊 =============
    [WebMethod(EnableSession = true)]
    public static string MNo_Load(string MNo)
    {
        Check();
        string str_sql = @"SELECT * FROM LaborTemplate WHERE MNo=@MNo";
        string outputJson = "";
        var chk = DBTool.Query<ClassTemplate>(str_sql, new { MNo = MNo });
        if (!chk.Any())
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { status = "NULL" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        else
        {
            outputJson = JsonConvert.SerializeObject(
                 chk.ToList().Select(p => new
                 {
                     Create_Name = p.Create_Name,
                     Create_Team = p.Create_Team,
                     Service = p.Service,
                     ServiceName = p.ServiceName,
                     Time_01 = p.Time_01.ToString("yyyy/MM/dd HH:mm"),
                     Time_02 = p.Time_02.ToString("yyyy/MM/dd HH:mm"),
                     LocationStart = p.LocationStart,
                     LocationEnd = p.LocationEnd,
                     Location = p.Location,
                     CarSeat = p.CarSeat,
                     ContactName = p.ContactName,
                     ContactPhone3 = p.ContactPhone3,
                     ContactPhone2 = p.ContactPhone2,
                     Contact_Co_TEL = p.Contact_Co_TEL,
                     Hospital = p.Hospital,
                     HospitalClass = p.HospitalClass,
                     Question = p.Question,
                     //==========【雇主及外勞資料】==========
                     Labor_Team = p.Labor_Team,
                     Cust_Name = p.Cust_Name,
                     Labor_CName = p.Labor_CName,
                     Labor_Country = p.Labor_Country,
                     Labor_ID = p.Labor_ID,
                     Labor_PID = p.Labor_PID,
                     Labor_RID = p.Labor_RID,
                     Labor_EID = p.Labor_EID,
                     Labor_Phone = p.Labor_Phone,
                     Labor_Language = p.Labor_Language,
                     Labor_Address = p.Labor_Address,
                     Labor_Address2 = p.Labor_Address2
                 }));
            return outputJson;
        }
    }

    //============= 帶入【多選派工單】資訊 =============
    [WebMethod(EnableSession = true)]
    public static string CNo_List()
    {
        Check();
        string CNo = HttpContext.Current.Session["CNo"].ToString();
        string str_service = "";
        string str_type = "";
        string str_time = "";
        string str_agent_name = "";
        string txt_sql = "";
        string sqlstr = @"SELECT TOP 1 * FROM CASEDetail WHERE CNo = @CNo";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { CNo = CNo });
        if (list.Any())
        {
            ClassTemplate schedule = list.First();
            str_time = schedule.StartTime.ToString("yyyyMMdd");
            str_service = schedule.ServiceName;
            str_type = schedule.Type;
            str_agent_name = schedule.Agent_Name;
        }

        if (str_type == "已分派" || str_type == "處理中")
        {
            txt_sql = "Type IN ( '已分派', '處理中' ) AND ";
        }
        else
        {
            txt_sql = "Type = @Type AND ";
        }

        sqlstr = @"SELECT * FROM View_Service WHERE " + txt_sql +
            "CONVERT(varchar, StartTime, 112) = @StartTime AND " +
            "ServiceName = @ServiceName AND " +
            "Agent_Name = @Agent_Name AND " +
            "Type_Value != '4' ";

        var a = DBTool.Query<ClassTemplate>(sqlstr, new
        {
            StartTime = str_time,
            ServiceName = str_service,
            Type = str_type,
            Agent_Name = str_agent_name
        }).
        ToList().Select(p => new
        {
            SYSID = p.SYSID,
            CNo = p.CNo,
            StartTime = p.StartTime.ToString("MM/dd" + " " + "HH" + ":" + "mm"),
            Type = p.Type,
            ServiceName = p.ServiceName,
            Cust_Name = p.Cust_Name,
            Labor_CName = p.Labor_CName,
            Question = p.Question,
            Agent_Name = p.Agent_Name
        });

        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 更新【[dbo].[CASEDetail]】的狀態 已分派 為 處理中 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Update_Type()
    {
        Check();
        string OpenUser = HttpContext.Current.Session["UserIDNAME"].ToString();
        string OpenUserID = HttpContext.Current.Session["UserID"].ToString();
        string CNo = HttpContext.Current.Session["CNo"].ToString();
        ClassTemplate update = new ClassTemplate()
        {
            OpenDate = DateTime.Now,
            OpenUser = OpenUser,
            OpenUserID = OpenUserID,
            CNo = CNo,
            Type = "處理中",
            Type_Value = "2"
            //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
        };

        string sqlstr = @"UPDATE CASEDetail SET " +
            "Type=@Type, " +
            "Type_Value=@Type_Value, " +
            "OpenDate = @OpenDate, " +
            "OpenUser =@OpenUser, " +
            "OpenUserID = @OpenUserID " +
            "WHERE CNo=@CNo AND OpenDate IS NULL ";

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);

        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //============= 【Btn_A_Click】 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Btn_A_Click(string[] Array)
    {
        Check();
        string Agent_Name = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string CNo = HttpContext.Current.Session["CNo"].ToString();
        string str_Array = "";
        string str_time = DateTime.Now.ToString("yyyy/MM/dd HH:mm");
        ClassTemplate update = new ClassTemplate()
        {
            str_time = str_time,
            Agent_Name = Agent_Name,
            Agent_ID = Agent_ID,
            CNo = CNo,
            Type = "已到點",
            Type_Value = "3"  //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
        };

        string sqlstr = @"UPDATE CASEDetail SET " +
            "Type=@Type, " +
            "Type_Value=@Type_Value, " +
            "UpdateDate =@str_time, " +
            "UpdateUser = @Agent_Name, " +
            "UpdateUserID = @Agent_ID " +
            "WHERE (CNo=@CNo ";

        if (Array.Length != 0)
        {
            str_Array = " OR SYSID IN ( ";
            for (int i = 0; i < Array.Length; i++)
            {
                if (JASON.IsInt(Array[i]) != false)
                {
                    str_Array += "'" + Array[i] + "',";
                }
            }
            str_Array = str_Array.Substring(0, str_Array.Length - 1);
            str_Array += " ) ";
        }
        sqlstr += str_Array + " ) AND UpdateDate IS NULL ";
        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);
        //========== Update OpenDate is NULL ==========

        ClassTemplate OpenDate_NULL = new ClassTemplate()
        {
            str_time = str_time,
            OpenUser = Agent_Name,
            OpenUserID = Agent_ID,
            CNo = CNo
        };

        sqlstr = @"UPDATE CASEDetail SET " +
            "OpenDate =@str_time, " +
            "OpenUser = @OpenUser, " +
            "OpenUserID = @OpenUserID " +
            "WHERE (CNo=@CNo ";

        sqlstr += str_Array + " ) AND OpenDate IS NULL ";

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, OpenDate_NULL);

        //========== Update OpenDate is NULL ==========
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //============= 【Btn_B_Click】 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Btn_B_Click(string[] Array)
    {
        Check();
        string Agent_Name = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string CNo = HttpContext.Current.Session["CNo"].ToString();
        string str_Array = "";
        string str_time = DateTime.Now.ToString("yyyy/MM/dd HH:mm");
        string str_OB_time = DateTime.Now.AddMinutes(15).ToString("yyyy/MM/dd HH:mm");
        string str_OB_end = DateTime.Now.ToString("yyyy/MM/dd");
        ClassTemplate update = new ClassTemplate()
        {
            str_time = str_time,
            Agent_Name = Agent_Name,
            Agent_ID = Agent_ID,
            CNo = CNo,
            Type = "已完成",
            Type_Value = "4"  //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
        };

        string sqlstr = @"UPDATE CASEDetail SET " +
            "Type=@Type, " +
            "Type_Value=@Type_Value, " +
            "LastUpdateDate =@str_time, " +
            "LastUpdateUser = @Agent_Name, " +
            "LastUpdateID = @Agent_ID " +
            "WHERE (CNo=@CNo ";

        if (Array.Length != 0)
        {
            str_Array = " OR SYSID IN ( ";
            for (int i = 0; i < Array.Length; i++)
            {
                if (JASON.IsInt(Array[i]) != false)
                {
                    str_Array += "'" + Array[i] + "',";
                }
            }
            str_Array = str_Array.Substring(0, str_Array.Length - 1);
            str_Array += " ) ";
        }
        sqlstr += str_Array + " ) AND LastUpdateDate IS NULL ";
        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);

        //============= SYSID 尾數 0 寫至【[Faremma].[dbo].[OutBound_DATA]】內進行外撥 =============

        sqlstr = @"SELECT CNo, Agent_Name, Labor_ID, Labor_CName, Labor_Phone " +
            "FROM CASEDetail as a " +
            "outer apply (SELECT TOP 1 Labor_Phone FROM Labor_System WHERE a.Labor_ID=Labor_ID) as b " +
            "WHERE ( CNO=@CNO " + str_Array + " ) " +
            "AND SUBSTRING ( LTRIM ( CAST ( SYSID AS CHAR ) ) , LEN ( LTRIM ( CAST ( SYSID AS CHAR ) ) ) , 1 ) = '0' " +
            "AND Labor_ID !='' " +
            "ORDER BY SYSID ";

        var chk = DBTool.Query<ClassTemplate>(sqlstr, new { CNo = CNo });

        if (chk.Count() > 0)
        {
            sqlstr = @"INSERT INTO OutBound_DATA (CSR, Labor_ID, Labor_Name, Labor_TEL, callid, OutBound_Time, Start_Date, Stop_Date) " +
                              "VALUES(@Agent_Name, @Labor_ID, @Labor_CName, @Labor_Phone, @CNo, @str_time, @START_TIME, @END_TIME)";
            foreach (var value in chk)
            {
                logger.Info(
                    "子單編號 = " + value.CNo +
                    " , 服務人員 = " + value.Agent_Name +
                    " , 客戶編號 = " + value.Labor_ID +
                    " , 客戶名稱 = " + value.Labor_CName +
                    " , OutBound_Time = " + str_OB_time +
                    " , START_TIME = " + str_OB_end +
                    " , END_TIME = " + str_OB_end
                    );

                ClassTemplate emma = new ClassTemplate()
                {
                    Agent_Name = value.Agent_Name,
                    Labor_ID = value.Labor_ID,
                    Labor_CName = value.Labor_CName,
                    CNo = value.CNo,
                    Labor_Phone = value.Labor_Phone,
                    str_time = str_OB_time,
                    START_TIME = str_OB_end,
                    END_TIME = str_OB_end
                };

                using (IDbConnection db = DBTool.GetConn())
                    db.Execute(sqlstr, emma);
            }
        }

        //=====================================

        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //============= 【Btn_C_Click】 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Btn_C_Click(string[] Array, string ANS, string DEPT)
    {
        Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        //Array = new string[] { "10044", "3260", "3250", "3249", "3231" };

        if (DEPT != "0" && DEPT != "1")
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        string back = "";
        List<XXS> check_value = new List<XXS>();
        check_value.Add(new XXS { URL_ID = ANS, MiniLen = 1, MaxLen = 150, Alert_Name = "暫結案說明", URL_Type = "txt" });
        JavaScriptSerializer Serializer = new JavaScriptSerializer();
        string outputJson = Serializer.Serialize(check_value);
        back = JASON.Check_XSS(outputJson);
        if (back != "")
        {
            return JsonConvert.SerializeObject(new { status = back });
        };

        string Agent_Name = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string CNo = HttpContext.Current.Session["CNo"].ToString();
        string str_Array = "";
        string str_time = DateTime.Now.ToString("yyyy/MM/dd HH:mm");
        ClassTemplate update = new ClassTemplate()
        {
            str_time = str_time,
            Agent_Name = Agent_Name,
            Agent_ID = Agent_ID,
            CNo = CNo,
            Answer2 = ANS,
            DEPT_Status = DEPT,
            Type = "暫結案",
            Type_Value = "5"
            //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：暫結案
        };

        string sqlstr = @"UPDATE CASEDetail " +
                          "SET Type=@Type, " +
                          "Type_Value=@Type_Value, " +
                          "FinalUpdateDate =@str_time, " +
                          "FinalUpdateUser = @Agent_Name, " +
                          "FinalUpdateID = @Agent_ID, " +
                          "Answer2 = @Answer2, " +
                          "DEPT_Status = @DEPT_Status " +
                          "WHERE (CNo=@CNo ";

        if (Array.Length != 0)
        {
            str_Array = " OR SYSID IN ( ";
            for (int i = 0; i < Array.Length; i++)
            {
                if (JASON.IsInt(Array[i]) != false)
                {
                    str_Array += "'" + Array[i] + "',";
                }
            }
            str_Array = str_Array.Substring(0, str_Array.Length - 1);
            str_Array += " ) ";
        }
        sqlstr += str_Array + " ) AND FinalUpdateDate IS NULL ";

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);

        //=============  EMMA =============

        sqlstr = @"SELECT SYSID, MNo, CNo, ServiceName, Cust_Name, Create_ID, Agent_Name, b.Agent_Mail, b.UserID " +
            "FROM CASEDetail AS a " +
            "outer apply (SELECT TOP 1 Agent_Mail, UserID FROM DispatchSystem WHERE a.Create_ID=Agent_ID AND Agent_Status != '離職') as b " +
            "WHERE CNo = @CNo";

        sqlstr += str_Array;

        var list = DBTool.Query<ClassTemplate>(sqlstr, new { CNo = CNo });
        if (list.Count() > 0)
        {
            string page = "2";
            string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
            foreach (var var in list)
            {
                // 1.  需求單審核    2.   員工派工管理  3.  個人派工及結案管理
                string EMMA = URL + "CheckLogin.aspx?seqno=" + var.MNo + "&page=" + page + "&login=" + JASON.Encryption(var.UserID);

                //======================================================

                sqlstr = @"SELECT TOP 1 SYSID FROM tblAssign WHERE AssignNo=@AssignNo " +
                 "AND E_MAIL=@E_MAIL AND ConnURL=@ConnURL AND convert(varchar, CreateDate, 112)=@CreateDate";

                var a = DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    AssignNo = "【暫結案通知】【" + var.Cust_Name + "：" + var.ServiceName + "】【被派人員：" + var.Agent_Name + "】",
                    E_MAIL = var.Agent_Mail,
                    ConnURL = EMMA,
                    CreateDate = DateTime.Now.ToString("yyyyMMdd")
                });

                if (a.Any())
                {
                    logger.Info("防止重複填寫EMMA 通知：" + "【暫結案通知】【" + var.Cust_Name + "：" + var.ServiceName + "】【被派人員：" + var.Agent_Name + "】");
                    logger.Info("防止重複填寫EMMA 時間：" + DateTime.Now.ToString("yyyyMMdd"));
                    logger.Info("防止重複填寫EMMA ConnURL：" + EMMA);
                    logger.Info("防止重複填寫EMMA E_MAIL：" + var.Agent_Mail);
                }
                else
                {
                    ClassTemplate emma = new ClassTemplate()
                    {
                        // "審核"  "派工"  "接單"  "暫結案"  "結案"
                        AssignNo = "【暫結案通知】【" + var.Cust_Name + "：" + var.ServiceName + "】【被派人員：" + var.Agent_Name + "】",
                        E_MAIL = var.Agent_Mail,
                        ConnURL = EMMA
                    };

                    sqlstr = @"INSERT INTO tblAssign (AssignNo ,E_MAIL ,ConnURL) " +
                                      "VALUES(@AssignNo ,@E_MAIL ,@ConnURL)";

                    using (IDbConnection db = DBTool.GetConn())
                        db.Execute(sqlstr, emma);
                }
            }
        }

        //=============  EMMA =============

        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //================ 頁面權限檢查 ===============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string MNo = HttpContext.Current.Session["MNo"].ToString();
        string str_url = "../0030010097.aspx?seqno=" + MNo;
        //System.Web.HttpContext.Current.Response.Redirect(str_url);
        string Check = JASON.Check_ID("0020010005.aspx");
        if (Check == "NO")
        {
            //System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }
}