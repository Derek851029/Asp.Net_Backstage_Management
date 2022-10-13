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
using System.Threading;


public partial class _0040010002 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected string MNo;
    protected string Answer2;

    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        MNo = Request.Params["seqno"];                          // 將seque 存入變數 MNo 
        Session["MNo"] = Request.Params["seqno"];
        string sql_txt = "";
        if (string.IsNullOrEmpty(MNo))      //當MNo 為 Null 或 Empty 時 回0040010001
        {
            Response.Redirect("0040010000/0040010001.aspx");
        }
        else
        {
            sql_txt = @"SELECT TOP 1 SYS_ID, Create_Team FROM LaborTemplate WHERE MNo=@MNo";
            var chk = DBTool.Query<ClassTemplate>(sql_txt, new { MNo = MNo });
            if (!chk.Any())
            {
                Response.Write("<script>alert('查無【" + MNo + "】需求單編號'); " +
                    "location.href='/0040010000/0040010001.aspx'; </script>");      // 提示 無此單號 回0040010001
            }
            else
            {
                ClassTemplate val = chk.First();
                if (Session["Agent_LV"].ToString() != "30")     //  權限不是30 提示無權 回0040010001
                {
                    if (Session["Agent_Team"].ToString() != val.Create_Team)
                    {
                        Response.Write("<script>alert('您沒有訪問此頁面的權限，需求單編號【" + MNo + "】非您部門的需求單。'); " +
                            "location.href='/0040010000/0040010001.aspx'; </script>");
                    }
                }
            };
        }
    }

    //================ 帶入【需求單】資訊 ===============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load()
    {
        Check();
        string MNo = HttpContext.Current.Session["MNo"].ToString();
        string sql_txt = @"SELECT TOP 1 * FROM LaborTemplate WHERE MNo=@MNo";
        string outputJson = "";
        var chk = DBTool.Query<ClassTemplate>(sql_txt, new { MNo = MNo });
        if (!chk.Any())
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { MNo = "NULL" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        else
        {
            outputJson = JsonConvert.SerializeObject(
                chk.ToList().Select(p => new
                {
                    MNo = p.MNo,
                    Create_ID = p.Create_ID,
                    Create_Team = p.Create_Team,
                    Create_Name = p.Create_Name,
                    Type_Value = p.Type_Value,
                    Service_ID = p.Service_ID,
                    Service = p.Service,
                    ServiceName = p.ServiceName,
                    Time_01 = p.Time_01.ToString("yyyy/MM/dd HH:mm"),
                    Time_02 = p.Time_02.ToString("yyyy/MM/dd HH:mm"),
                    Close_Time = p.Close_Time.ToString("yyyy/MM/dd HH:mm"),
                    Cust_Name = p.Cust_Name,
                    Labor_Team = p.Labor_Team,
                    Labor_CName = p.Labor_CName,
                    Labor_ID = p.Labor_ID,
                    Labor_PID = p.Labor_PID,
                    Labor_RID = p.Labor_RID,
                    Labor_EID = p.Labor_EID,
                    Labor_Country = p.Labor_Country,
                    Labor_Language = p.Labor_Language,
                    Labor_Phone = p.Labor_Phone,
                    Labor_Address = p.Labor_Address,
                    Labor_Address2 = p.Labor_Address2,
                    PostCode = p.PostCode,
                    Location = p.Location,
                    LocationStart = p.LocationStart,
                    LocationEnd = p.LocationEnd,
                    CarSeat = p.CarSeat,
                    ContactName = p.ContactName,
                    ContactPhone2 = p.ContactPhone2,
                    ContactPhone3 = p.ContactPhone3,
                    Contact_Co_TEL = p.Contact_Co_TEL,
                    Hospital = p.Hospital,
                    HospitalClass = p.HospitalClass,
                    Question = p.Question,
                    Answer = p.Answer
                })
            );
            return outputJson;
        }
    }

    //============= 帶入【被派人員（部門）】資訊 =============
    [WebMethod(EnableSession = true)]
    public static string Agent_Team()
    {
        Check();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string sqlstr = "";
        string str_flag = "";
        if (LV != "30")
        {
            sqlstr = "SELECT TOP 1 * FROM Agent_Team_Group WHERE Agent_Team=@Agent_Team";
            var Team_Array = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_Team = Agent_Team });
            if (Team_Array.Count() > 0)
            {
                foreach (var var in Team_Array)
                {
                    if (var.Flag_1 == "1")
                    {
                        str_flag += "Flag_1 = 1 OR ";
                    }

                    if (var.Flag_2 == "1")
                    {
                        str_flag += "Flag_2 = 1 OR ";
                    }

                    if (var.Flag_3 == "1")
                    {
                        str_flag += "Flag_3 = 1 OR ";
                    }

                    if (var.Flag_4 == "1")
                    {
                        str_flag += "Flag_4 = 1 OR ";
                    }

                    if (var.Flag_5 == "1")
                    {
                        str_flag += "Flag_5 = 1 OR ";
                    }

                    if (var.Flag_6 == "1")
                    {
                        str_flag += "Flag_6 = 1 OR ";
                    }
                }
            }

            sqlstr = @"SELECT Agent_Team FROM View_WorkDate " +
                "WHERE " + str_flag + "Agent_Team =@Agent_Team " +
                "GROUP BY Agent_Team  ORDER BY Agent_Team ";
        }
        else
        {
            sqlstr = @"SELECT Agent_Team FROM View_WorkDate " +
                //"WHERE Flag_1 IS NOT NULL " +
                "GROUP BY Agent_Team  ORDER BY Agent_Team ";
        };
        //logger.Info("派工部門 SQL：" + sqlstr);
        var a = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_Team = Agent_Team }).ToList().Select(p => new
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
        Check();
        string outputJson = "";
        if (value.Length < 20)
        {
            string sqlstr = @"SELECT Agent_ID, Agent_Name FROM View_WorkDate WHERE Agent_Team = @Agent_Team group by Agent_ID,Agent_Name ORDER BY Agent_Name";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_Team = value }).ToList().Select(p => new
            {
                Agent_ID = p.Agent_ID,
                Agent_Name = p.Agent_Name
            });
            outputJson = JsonConvert.SerializeObject(a);
        }
        else
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { Agent_ID = "", Agent_Name = "" }) + "]"; // 組合JSON 格式
        }
        return outputJson;
    }

    //============= 帶入【被派人員上下班時間】資訊 =============
    [WebMethod(EnableSession = true)]
    public static string Agent_WorkTime(string Time, string Agent_Team, string Agent_ID)
    {
        Check();
        string outputJson = "";
        if (Agent_Team.Length < 20 && Agent_ID.Length < 10)
        {
            string sqlstr = @"SELECT Working, WorkOff FROM View_WorkDate " +
                  "WHERE CONVERT(varchar(10), Work_Day,111) = CONVERT(varchar(10), @time,111) " +
                  "AND Agent_Team = @Agent_Team " +
                  "AND Agent_ID = @Agent_ID";
            var chk = DBTool.Query<ClassTemplate>(sqlstr, new { time = Time, Agent_Team = Agent_Team, Agent_ID = Agent_ID });
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
                       status = "OK",
                       Working = p.Working.ToString("HH:mm"),
                       WorkOff = p.WorkOff.ToString("HH:mm")
                   })
               );
                return outputJson;
            };
        }
        else
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { status = "" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
    }

    //============= 帶入【服務車輛（部門）】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Car_Team()
    {
        Check();
        string sqlstr = @"SELECT DISTINCT Agent_Team FROM DataCar";
        var a = DBTool.Query<ClassTemplate>(sqlstr).ToList().Select(p => new
        {
            Agent_Team = p.Agent_Team
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 帶入【服務車輛（保管人）】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Car_Name(string value)
    {
        Check();
        string outputJson = "";
        if (value.Length < 15)
        {
            string sqlstr = @"SELECT DISTINCT Agent_Name FROM DataCar WHERE Agent_Team=@Agent_Team";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_Team = value }).ToList().Select(p => new
            {
                Agent_Name = p.Agent_Name
            });
            outputJson = JsonConvert.SerializeObject(a);
        }
        else
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { Agent_Name = "" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        return outputJson;
    }

    //============= 帶入【服務車輛（車牌號碼）】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Car_Number(string value)
    {
        Check();
        string outputJson = "";
        if (value.Length < 10)
        {
            string sqlstr = @"SELECT DISTINCT CarNumber,CarName FROM DataCar WHERE Agent_Name=@Agent_Name";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_Name = value }).ToList().Select(p => new
            {
                CarNumber = p.CarNumber,
                CarName = p.CarName
            });
            outputJson = JsonConvert.SerializeObject(a);
        }
        else
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { CarNumber = "", CarName = "" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        return outputJson;
    }

    //======================= 需求單多選表
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetPartnerList()
    {
        Check();
        string OE_Main = HttpContext.Current.Session["OE_Main"].ToString();
        string OE_Detail = HttpContext.Current.Session["OE_Detail"].ToString();
        var a = PartnerHeaderRepository.CMS_0030010001_OE_List(OE_Main, OE_Detail)
            .Select(p => new
            {
                CNo = p.CNo,                                      //子單編號
                Agent_Team = p.Agent_Team,       //處理部門
                Agent_Name = p.Agent_Name,     //處理人員               
                Type = p.Type,                                    //案件狀態        
                Answer2 = p.Answer2,                          //狀況說明
                UpdateDate = p.UpdateDate,
                UpdateUser = p.UpdateUser,
                LastUpdateDate = p.LastUpdateDate,
                LastUpdateUser = p.LastUpdateUser,
                FinalUpdateDate = p.FinalUpdateDate,
                FinalUpdateUser = p.FinalUpdateUser
            });
        return JsonConvert.SerializeObject(a, Formatting.Indented);
    }

    //=======================可併單 車輛 
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetData2List(string start, string end, string hospital, string Service)
    {
        Check();
        string sql = " ";
        Convert.ToDateTime(start);
        Convert.ToDateTime(end);   //between @startDate AND @ednDate
        if (hospital != "")
        {
            sql = "AND Hospital = @Hospital ";
        }

        string Sqlstr = @"SELECT COUNT( SYSID ) as CNo, StartTime, EndTime, OverTime, Danger_Value, " +
            "ServiceName, Hospital, Agent_ID, Agent_Team, CarAgent_Name, CarAgent_Team, CarNumber, Answer " +
            "FROM CASEDetail WHERE " +
            "CONVERT(varchar(10), StartTime,111) BETWEEN CONVERT(varchar(10), @start,111) AND " +
            "CONVERT(varchar(10), @end,111) AND CarAgent_Name != '' " +
            "AND ServiceName = @Service " + sql;
        Sqlstr += " GROUP BY StartTime, EndTime, OverTime, Danger_Value, " +
            "ServiceName, Hospital, Agent_ID, Agent_Team, CarAgent_Name, CarAgent_Team, CarNumber, Answer";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { start = start, end = end, Hospital = hospital, Service = Service }).ToList()
            .Select(p => new
            {
                CNo = p.CNo, //子單編號
                StartTime = p.StartTime.ToString("yyyy/MM/dd HH:mm"),
                EndTime = p.EndTime.ToString("yyyy/MM/dd HH:mm"),
                OverTime = p.OverTime.ToString("yyyy/MM/dd HH:mm"),
                Danger_Value = p.Danger_Value,
                ServiceName = p.ServiceName,
                Hospital = p.Hospital, //地點
                Agent_ID = p.Agent_ID,
                Agent_Team = p.Agent_Team,
                CarAgent_Name = p.CarAgent_Name, //駕駛
                CarAgent_Team = p.CarAgent_Team,
                CarNumber = p.CarNumber, //車牌號碼      
                Answer = p.Answer //狀況說明
            });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //=====================================
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetinfoList(string Hospital, string ServiceName, string CarAgent_Team, string CarNumber, string Agent_Team, string Agent_ID, string StartTime, string EndTime, string Answer)
    {
        Check();
        string sql = "";
        if (Hospital != "")
        {
            sql = "AND Hospital = @Hospital";
        }

        string Sqlstr = @"SELECT * FROM CASEDetail " +
            "WHERE ServiceName=@ServiceName " +
            "AND CarAgent_Team=@CarAgent_Team " +
            "AND CarNumber=@CarNumber " +
            "AND Agent_Team=@Agent_Team " +
            "AND Agent_ID=@Agent_ID " +
            "AND Answer = @Answer " +
            "AND CONVERT(varchar(20), StartTime, 100) = CONVERT(varchar(20), @StartTime, 100) " +
            " " + sql;

        var a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Hospital = Hospital,
            ServiceName = ServiceName,
            CarAgent_Team = CarAgent_Team,
            CarNumber = CarNumber,
            Agent_Team = Agent_Team,
            Agent_ID = Agent_ID,
            Answer = Answer,
            StartTime = Convert.ToDateTime(StartTime),
            EndTime = Convert.ToDateTime(EndTime)
        }).ToList()
            .Select(p => new
            {
                CNo = p.CNo, //子單編號
                StartTime = p.StartTime.ToString("yyyy/MM/dd HH:mm"),
                Cust_Name = p.Cust_Name,
                ServiceName = p.ServiceName,
                Hospital = p.Hospital, //地點
                CarAgent_Name = p.CarAgent_Name, //駕駛
                CarNumber = p.CarNumber, //車牌號碼               
                CarSeat = p.CarSeat, //搭乘人數        
                Answer = p.Answer //狀況說明
            });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 帶入【併單】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Merger_CNo(int SYSID)
    {
        Check();
        string sql_txt = @"SELECT * FROM CASEDetail WHERE SYSID=@SYSID";
        string outputJson = "";
        var chk = DBTool.Query<ClassTemplate>(sql_txt, new { SYSID = SYSID });
        if (!chk.Any())
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { CNo = "NULL" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        else
        {
            outputJson = JsonConvert.SerializeObject(
                chk.ToList().Select(p => new
                {
                    Danger_Value = p.Danger_Value,
                    OverTime = p.OverTime.ToString("yyyy/MM/dd HH:mm"),
                    StartTime = p.StartTime.ToString("yyyy/MM/dd HH:mm"),
                    EndTime = p.EndTime.ToString("yyyy/MM/dd HH:mm"),
                    Agent_ID = p.Agent_ID,
                    Agent_Team = p.Agent_Team,
                    CarNumber = p.CarNumber,
                    CarAgent_Name = p.CarAgent_Name,
                    CarAgent_Team = p.CarAgent_Team,
                    Answer = p.Answer
                })
              );
            return outputJson;
        }
    }

    //=====================================
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string MNo_Table(string start, string end, string Service_ID, string code, string Hospital)
    {
        Check();
        string MNo = HttpContext.Current.Session["MNo"].ToString();
        string str_var = "";
        if (Hospital != "0")
        {
            if (code != "")
            {
                str_var = "AND SUBSTRING(PostCode, 1, 3) = @code";
            }
            else
            {
                str_var = "AND Hospital = @Hospital ";
            }
        }
        else
        {
            if (code != "")
            {
                str_var = "AND SUBSTRING(PostCode, 1, 3) = @code";
            }
        }
        Convert.ToDateTime(start);
        Convert.ToDateTime(end);
        string Sqlstr = @"SELECT * FROM LaborTemplate WHERE MNO = @MNo OR (" +
            "CONVERT(varchar(10), Time_01,111) BETWEEN CONVERT(varchar(10), @start,111) AND " +
            "CONVERT(varchar(10), @end,111) " +
            "AND Type_Value IN ('2', '3') " +
            "AND Service_ID = @Service_ID " + str_var + " ) ";
        logger.Info("需求單多選（瀏覽）SQL = " + Sqlstr);
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { start = start, end = end, Service_ID = Service_ID, code = code, Hospital = Hospital, MNo = MNo }).ToList()
            .Select(p => new
            {
                SYS_ID = p.SYS_ID,
                MNo = p.MNo, //母單編號
                Type = p.Type,  //狀態
                Type_Value = p.Type_Value,  //狀態
                Time_01 = p.Time_01.ToString("MM/dd HH:mm"),
                Cust_Name = p.Cust_Name, //廠商名稱
                Labor_CName = p.Labor_CName, //廠商名稱
                ServiceName = p.ServiceName, //服務內容
                LocationStart = p.LocationStart, //地點              
                Question = p.Question //狀況說明
            });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //=============【結案】=============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Btn_Closed_Click(string Answer)
    {
        Check();
        string MNo = HttpContext.Current.Session["MNo"].ToString();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_Name = HttpContext.Current.Session["UserIDNAME"].ToString();
        string back = "";

        List<XXS> check_value = new List<XXS>();
        check_value.Add(new XXS { URL_ID = Answer, MiniLen = 0, MaxLen = 250, Alert_Name = "結案說明", URL_Type = "txt" });
        JavaScriptSerializer Serializer = new JavaScriptSerializer();
        string outputJson = Serializer.Serialize(check_value);
        back = JASON.Check_XSS(outputJson);
        if (back != "")
        {
            return JsonConvert.SerializeObject(new { status = back });
        };

        string sqlstr = "";
        sqlstr = @"SELECT SYSID, CNo FROM CASEDetail WHERE MNo=@MNo AND FinalUpdateDate is NULL";
        var chk = DBTool.Query<ClassTemplate>(sqlstr, new { MNo = MNo });
        if (chk.Any())
        {
            Thread.Sleep(250);
            back = "【派工單】案件尚未完成\n";
            foreach (var var in chk)
            {
                back += "【" + var.CNo + "】\n";
            }
            return JsonConvert.SerializeObject(new { status = back += "案件狀態須為【暫結案】。" });
        }

        ClassTemplate update = new ClassTemplate()
        {
            MNo = MNo,
            Type = "已經結案",
            Type_Value = "4",  //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
            Close_ID = Agent_ID,
            Close_Name = Agent_Name,
            Close_Time = DateTime.Now,
            Answer = Answer
        };

        sqlstr = @"UPDATE LaborTemplate SET " +
            "Type=@Type, " +
            "Type_Value=@Type_Value, " +
            "Close_ID=@Close_ID, " +
            "Close_Name=@Close_Name, " +
            "Close_Time=@Close_Time, " +
            "Answer=@Answer " +
            "WHERE MNo=@MNo";

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);

        Thread.Sleep(250);
        //=============  EMMA =============

        string login = "";
        string mail = "";
        string service = "";
        string cust_name = "";
        string creat_name = "";
        sqlstr = @"SELECT UserID, Agent_Mail, ServiceName, Cust_Name, Create_Name FROM LaborTemplate WHERE MNo=@MNo";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { MNo = MNo });
        if (list.Any())
        {
            ClassTemplate schedule = list.First();
            login = schedule.UserID;
            mail = schedule.Agent_Mail;
            service = schedule.ServiceName;
            cust_name = schedule.Cust_Name;
            creat_name = schedule.Create_Name;
        }

        Thread.Sleep(250);
        string page = "4";  // 1.  需求單審核    2.   員工派工管理  3.  個人派工及結案管理
        string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
        string EMMA = URL + "CheckLogin.aspx?seqno=" + MNo + "&page=" + page + "&login=" + JASON.Encryption(login);

        ClassTemplate emma = new ClassTemplate()
        {
            AssignNo = "【結案通知】【" + cust_name + "：" + service + "】【填單人員：" + creat_name + "】",  // "審核"  "派工"  "接單"  "暫結案"  "結案"
            E_MAIL = mail,
            ConnURL = EMMA
        };
        sqlstr = @"INSERT INTO tblAssign (AssignNo ,E_MAIL ,ConnURL) VALUES(@AssignNo ,@E_MAIL ,@ConnURL)";
        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, emma);

        //=============  EMMA =============

        Thread.Sleep(250);
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //===============================
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check_Value(string[] Array, string Danger_Value, string StartTime, string EndTime, string OverTime, string Agent_ID, string CarNumber, string Answer)
    {
        Check();
        string Create_ID = HttpContext.Current.Session["UserID"].ToString();
        string Create_Name = HttpContext.Current.Session["UserIDNAME"].ToString();
        string str_MNo = HttpContext.Current.Session["MNo"].ToString();
        string sqlstr = "";
        string str_array = "";
        string Danger = "";
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        #region
        if (StartTime == "") { return JsonConvert.SerializeObject(new { status = "請填寫【排定起始時間】。" }); }
        if (EndTime == "") { return JsonConvert.SerializeObject(new { status = "請填寫【排定終止時間】。" }); }
        if (Agent_ID == "") { return JsonConvert.SerializeObject(new { status = "請選擇【被派人員】。" }); }
        if (CarNumber == "") { return JsonConvert.SerializeObject(new { status = "請選擇【服務車輛】。" }); }

        //================【欄位驗證】==================
        string back = "";
        List<XXS> check_value = new List<XXS>();
        check_value.Add(new XXS { URL_ID = Answer, MiniLen = 0, MaxLen = 250, Alert_Name = "派工說明", URL_Type = "txt" });
        JavaScriptSerializer Serializer = new JavaScriptSerializer();
        string outputJson = Serializer.Serialize(check_value);
        back = JASON.Check_XSS(outputJson);
        if (back != "")
        {
            return JsonConvert.SerializeObject(new { status = back });
        };
        //==========================================

        Thread.Sleep(100);

        DateTime dateTime;
        if (!DateTime.TryParse(StartTime, out dateTime))
        {
            return JsonConvert.SerializeObject(new { status = error });
        }
        else if (!DateTime.TryParse(EndTime, out dateTime))
        {
            return JsonConvert.SerializeObject(new { status = error });
        }
        else if (!DateTime.TryParse(OverTime, out dateTime))
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        // 驗證 【預定起始時間】是否小於【現在時間】
        if (Convert.ToDateTime(StartTime) < DateTime.Now.AddDays(-14))
        {
            return JsonConvert.SerializeObject(new { status = "【排定起始時間】不能小於【" + DateTime.Now.AddDays(-14).ToString("yyyy/MM/dd hh:mm") + "】" });
        }

        // 驗證 【預定起始時間】是否小於【預定終止時間】
        if (Convert.ToDateTime(StartTime) > Convert.ToDateTime(EndTime))
        {
            return JsonConvert.SerializeObject(new { status = "【排定起始時間】不能大於【排定終止時間】" });
        }

        if (Danger_Value != "0" && Danger_Value != "1" && Danger_Value != "2")
        {
            return JsonConvert.SerializeObject(new { status = error });
        }
        else
        {
            switch (Danger_Value)
            {
                case "0":
                    Danger = "一般";
                    break;
                case "1":
                    Danger = "重要";
                    break;
                case "2":
                    Danger = "緊急";
                    break;
                default:
                    Danger = "一般";
                    break;
            }
        }

        Thread.Sleep(100);

        sqlstr = @"SELECT TOP 1 Agent_ID FROM View_WorkDate WHERE Agent_ID=@Agent_ID";
        var chk = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = Agent_ID });
        if (chk.Count() < 1)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        Thread.Sleep(100);

        sqlstr = @"SELECT TOP 1 SYS_ID FROM DataCar WHERE CarNumber=@CarNumber";
        chk = DBTool.Query<ClassTemplate>(sqlstr, new { CarNumber = CarNumber });
        if (chk.Count() < 1)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        Thread.Sleep(100);

        //================【欄位驗證】==================
        #endregion

        logger.Info("===== 派工單迴圈開始 =====");
        if (Array.Length != 0)
        {
            sqlstr = "Declare @Array table(Value nvarchar(20)) ";
            str_array = " OR SYS_ID IN ( SELECT * FROM @Array ) ";
            for (int i = 0; i < Array.Length; i++)
            {
                if (JASON.IsInt(Array[i]) != false)
                {
                    sqlstr += "insert into @Array (Value) values ('" + Array[i] + "') ";
                }
            }
        }
        else
        {
            sqlstr = "";
            str_array = "";
        }
        sqlstr += @"SELECT MNo, Cust_ID, Cust_Name, Labor_ID, Labor_CName, Service, ServiceName, PostCode, Hospital, CarSeat, Create_Team FROM LaborTemplate WHERE MNo=@MNo" + str_array;

        logger.Info("需求單編號：" + str_MNo + ", SQL：" + sqlstr);

        var MNo_Array = DBTool.Query<ClassTemplate>(sqlstr, new { MNo = str_MNo });

        logger.Info("共：" + MNo_Array.Count() + "筆");
        if (MNo_Array.Count() > 0)
        {
            foreach (var var in MNo_Array)
            {
                logger.Info("===== 新增派工單開始 =====");
                string str_cno = "2" + DateTime.Now.ToString("yyMMdd");
                sqlstr = @"Declare @temp1 table ( [Agent_ID] [nvarchar](50) NULL " +
               " , [CarNumber] [nvarchar](50) NULL )";

                sqlstr += "insert into @temp1 ([Agent_ID], [CarNumber]) values ( @Agent_ID, @CarNumber) ";

                sqlstr += "INSERT INTO CASEDetail (MNo, CNo, PostCode, Type, Type_Value, " +
                    "Service, ServiceName, Cust_ID, Cust_Name, Labor_ID, Labor_CName, Hospital, " +
                    "CarName, CarNumber, CarSeat, CarAgent_Name, CarAgent_Team, " +
                    "Agent_ID, Agent_Name, Agent_Company, Agent_Team, Agent_Mail, UserID, " +
                    "Danger, Danger_Value, StartTime, EndTime, OverTime, Answer, Create_Name, Create_ID) ";

                sqlstr += "SELECT TOP 1 @MNo, @CNo, @PostCode, @Type, @Type_Value, " +
                    "@Service, @ServiceName, @Cust_ID, @Cust_Name, @Labor_ID, @Labor_CName, @Hospital, " +
                    "c.CarName, @CarNumber, @CarSeat, c.Agent_Name as CarAgent_Name, c.Agent_Team as CarAgent_Team, " +
                    "@Agent_ID, b.Agent_Name, b.Agent_Company, b.Agent_Team, b.Agent_Mail, b.UserID, " +
                    "@Danger, @Danger_Value, @StartTime, @EndTime, @OverTime, @Answer, @Create_Name, @Create_ID ";

                sqlstr += "FROM @temp1 as a " +
                    "left join [DispatchSystem] as b on a.[Agent_ID]=b.[Agent_ID] AND Agent_Status != '離職' " +
                    "left join [DataCar] as c on a.[CarNumber]=c.[CarNumber] AND c.Flag = '1' ";

                sqlstr += "UPDATE CASEDetail SET CNo = @CNo+Right('000000' + Cast((SELECT @@IDENTITY) as varchar),6) " +
                    "WHERE SYSID = (SELECT @@IDENTITY)";

                ClassTemplate update = new ClassTemplate()
                {
                    MNo = var.MNo,
                    CNo = str_cno,
                    PostCode = var.PostCode,
                    Type = "已分派",
                    Type_Value = "1",
                    Service = var.Service,
                    ServiceName = var.ServiceName,
                    Cust_ID = var.Cust_ID,
                    Cust_Name = var.Cust_Name,
                    Labor_ID = var.Labor_ID,
                    Labor_CName = var.Labor_CName,
                    Hospital = var.Hospital,
                    CarSeat = var.CarSeat,
                    CarNumber = CarNumber,
                    Agent_ID = Agent_ID,
                    Danger = Danger,
                    Danger_Value = Danger_Value,
                    StartTime = Convert.ToDateTime(StartTime),
                    EndTime = Convert.ToDateTime(EndTime),
                    OverTime = Convert.ToDateTime(OverTime),
                    Answer = Answer,
                    Create_Name = Create_Name,
                    Create_ID = Create_ID
                };

                logger.Info("SQL：" + sqlstr);
                using (IDbConnection db = DBTool.GetConn())
                    db.Execute(sqlstr, update);
                Thread.Sleep(100);

                sqlstr = @"SELECT TOP 1 CNO FROM CASEDetail " +
                    "WHERE MNo=@MNo ORDER BY SYSID DESC";
                var i = DBTool.Query<ClassTemplate>(sqlstr, new { MNo = var.MNo });
                if (i.Any())
                {
                    ClassTemplate i_value = i.First();
                    str_cno = i_value.CNo.ToString();
                }
                else
                {
                    str_cno = "";
                }

                Thread.Sleep(100);
                logger.Info("===== 新增派工單結束 =====");

                logger.Info("===== 更新母單狀態開始 =====");
                #region
                ClassTemplate update_mno = new ClassTemplate()
                {
                    MNo = var.MNo,
                    Type = "尚未結案",
                    Type_Value = "3",  //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
                    Dispatch_ID = Create_ID,
                    Dispatch_Name = Create_Name,
                    Dispatch_Time = DateTime.Now
                };

                sqlstr = @"UPDATE LaborTemplate SET " +
                    "Type=@Type, " +
                    "Type_Value=@Type_Value, " +
                    "Dispatch_ID=@Dispatch_ID, " +
                    "Dispatch_Name=@Dispatch_Name, " +
                    "Dispatch_Time=@Dispatch_Time " +
                    "WHERE MNo=@MNo";

                using (IDbConnection db = DBTool.GetConn())
                    db.Execute(sqlstr, update_mno);
                Thread.Sleep(100);
                #endregion
                logger.Info("===== 更新母單狀態結束 =====");

                logger.Info("===== EMMA通知開始 =====");
                #region
                string login = "";
                string mail = "";
                string Agent_Name = "";
                string Agent_Team = "";
                sqlstr = @"select TOP 1 UserID, Agent_Mail, Agent_Name, Agent_Team from DispatchSystem " +
                                  " where Agent_ID=@Agent_ID AND Agent_Status = '在職'";
                var list = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = Agent_ID });
                if (list.Any())
                {
                    ClassTemplate schedule = list.First();
                    login = schedule.UserID;
                    mail = schedule.Agent_Mail;
                    Agent_Name = schedule.Agent_Name;
                    Agent_Team = schedule.Agent_Team;
                }

                Thread.Sleep(100);
                string page = "3";  // 1.  需求單審核    2.   員工派工管理  3.  個人派工及結案管理
                string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
                string EMMA = URL + "CheckLogin.aspx?seqno=" + str_cno + "&page=" + page + "&login=" + JASON.Encryption(login);

                ClassTemplate emma = new ClassTemplate()
                {
                    AssignNo = "【接單通知】【" + var.Cust_Name + "：" + var.ServiceName + "】【被派人員：" + Agent_Name + "】",  // "審核"  "派工"  "接單"  "暫結案"  "結案"
                    E_MAIL = mail,
                    ConnURL = EMMA
                };
                sqlstr = @"INSERT INTO tblAssign " +
                                  "(AssignNo, E_MAIL, ConnURL) " +
                                  "VALUES(@AssignNo, @E_MAIL, @ConnURL)";
                using (IDbConnection db = DBTool.GetConn())
                    db.Execute(sqlstr, emma);
                Thread.Sleep(100);
                #endregion
                logger.Info("===== EMMA通知結束 =====");

                logger.Info("===== 轉派單判斷開始 =====");
                logger.Info("User_Team = " + var.Create_Team + " , Agent_Team = " + Agent_Team);
                if (var.Create_Team != Agent_Team)
                {
                    logger.Info("===== 轉派單迴圈開始 =====");
                    sqlstr = @"SELECT * FROM Master_DATA WHERE Agent_Team in (@Agent_Team, @User_Team) AND Flag = '1' ";
                    var sql_master = DBTool.Query<EMMA>(sqlstr, new { Agent_Team = Agent_Team, User_Team = var.Create_Team });
                    logger.Info("共：" + sql_master.Count() + "筆");
                    if (sql_master.Count() > 0)
                    {
                        foreach (var r in sql_master)
                        {
                            logger.Info("Agent_Name = " + r.Agent_Name + " , Agent_Team = " + r.Agent_Team);
                            ClassTemplate emma_master = new ClassTemplate()
                            {
                                AssignNo = "【轉派單通知】【" + var.Cust_Name + "：" + var.ServiceName + "】【被派人員部門：" + Agent_Team + "】【被派人員：" + Agent_Name + "】",  // "審核"  "派工"  "接單"  "暫結案"  "結案"
                                E_MAIL = r.E_Mail,
                                ConnURL = URL + "CheckLogin.aspx?seqno=" + str_cno + "&page=" + page + "&login=" + JASON.Encryption(r.UserID)
                            };
                            sqlstr = @"INSERT INTO tblAssign " +
                                              "(AssignNo, E_MAIL, ConnURL) " +
                                              "VALUES(@AssignNo, @E_MAIL, @ConnURL)";
                            using (IDbConnection db = DBTool.GetConn())
                            {
                                db.Execute(sqlstr, emma_master);
                                db.Close();
                            }
                            Thread.Sleep(100);
                        }
                    }
                    logger.Info("===== 轉派單迴圈結束 =====");
                }

                logger.Info("===== 轉派單判斷結束 =====");
                Thread.Sleep(100);
            }
            //======= foreach (var var in MNo_Array) =======
        }
        logger.Info("===== 派工單迴圈結束 =====");
        return JsonConvert.SerializeObject(new { status = "success", count = MNo_Array.Count() });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0040010001.aspx");
//        if (Check == "NO")
//        {
//            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
//        }
        return "";
    }


    //=============【緊急時間】=============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Danger_Changed(int value)
    {
        logger.Info("value = " + value);
        if (value != 1 && value != 2 && value != 4)
        {
            value = 4;
        }
        return DateTime.Now.AddHours(value).ToString("yyyy/MM/dd HH:mm");
    }

}