using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Windows.Forms;
using log4net;
using log4net.Config;

public partial class _0250010000 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    string sql_txt;

    protected string opinionsubject = "";
    protected string seqno = "";
    protected string str_title = "新增";
    protected string str_type = "存檔後系統自動編號";
    protected string new_mno = "";
    protected string new_mno2 = "";
    protected string new_mno3 = "";
    protected long mno3 = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Check();
            seqno = Request.Params["seqno"];
            if (string.IsNullOrEmpty(seqno))
            {
                Response.Redirect("/0030010000/0030010007.aspx");
            }

            if (seqno != "0")
            {
                Session["MNo"] = seqno;
                sql_txt = @"SELECT TOP 1 Case_ID FROM [InSpecation_Dimax].[dbo].[Mission_Case] WHERE Case_ID=@Case_ID";
                var chk = DBTool.Query<ClassTemplate>(sql_txt, new { Case_ID = seqno });
                if (!chk.Any())
                {
                    //Response.Redirect("/0030010000/0030010002.aspx");
                    Response.Write("<script>alert('查無【" + seqno + "】母單編號'); location.href='0030010000/0030010007.aspx'; </script>");
                }
                else
                {
                    /*  ClassTemplate schedule = ClassScheduleRepository._0030010001_View_Case_ID(seqno);
                    string url = "/0250010000.aspx?seqno=" + Request.Params["seqno"];
                    if (schedule.Type_Value == "1")
                    {
                        //str_title = "修改";
                        //str_type = "尚未審核";
                        opinionsubject = @"SELECT TOP 1 OpinionSubject as OS FROM CaseData WHERE Case_ID=@Case_ID";     //意見主旨內容
                    }   //*/
                };
            }
            else
            {
                //【創造母單編號】
                int s = 0;
                new_mno = DateTime.Now.ToString("yyyyMMddHHmmss"); //("yyMMddHHmmssfff");
                new_mno2 = DateTime.Now.ToString("yyyyMM");
                string Sqlstr = @"select count(*) as Flag FROM [InSpecation_Dimax].[dbo].[Mission_Case] where " +
                    " year(SetupTime)=year(getdate()) and month(SetupTime)=month(getdate())";
                var a = DBTool.Query<ClassTemplate>(Sqlstr);
                foreach (var q in a)
                {
                    s = Int32.Parse(q.Flag);
                };
                mno3 = Int64.Parse(new_mno2 + "001") + s;
                
                Session["Case_ID"] = new_mno;
                //string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
            }
        }
    }       //*/

    //============= 帶入【填單人】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load()
    {
        Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        string Sqlstr = @"SELECT TOP 1 * FROM DispatchSystem WHERE Agent_ID = @Agent_ID AND Agent_Status != '離職'";      // 員工名單內且未離職
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Agent_ID = Agent_ID }).ToList().Select(p => new
        {
            Agent_Team = p.Agent_Team,
            Agent_Name = p.Agent_Name,
            Agent_ID = Value(p.Agent_ID),
            //Agent_Phone_2 = p.Agent_Phone_2,
            //Agent_Phone_3 = p.Agent_Phone_3,
            //Agent_Co_TEL = p.Agent_Co_TEL,
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Creat_ID(DateTime time)
    {
        Check();
        int s = 0;
        string mno = time.ToString("yyyyMMddHHmmss");
        string mno2 = time.ToString("yyyyMMdd");
        long Int1 = 0;
        long Int2 = 0;
        string Sqlstr = @"select count(*) as Flag FROM CaseData where CONVERT(varchar(100), SetupTime, 111)=CONVERT(varchar(100), @time, 111)";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { time = time });
        foreach (var q in a)
        {
            s = Int32.Parse(q.Flag);
        };
        Int1 = Int64.Parse(mno2 + "001") + s;
        Int2 = Int64.Parse(mno) + s+59;
        //string outputJson = JsonConvert.SerializeObject(a);
        //return outputJson;
        return JsonConvert.SerializeObject(new { Int1, Int2 });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Client_Code_Search()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT PID,BUSINESSNAME,ID FROM BusinessData where Type = '保留' order by PID ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            A = p.BUSINESSNAME,
            B = p.ID,
            C = p.PID
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Client_Code_Search2(string PID)                   // 缺個檢查 無子公司
    {
        //Check();
        PID = PID.Trim();
        string Sqlstr = @"SELECT PNumber, Name  FROM Business_Sub where PID = @PID ";      //整理出子公司列表 '108'

        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { PID = PID }).ToList().Select(p => new
        {
            A = p.Name,
            B = p.PNumber
            //C = p.PID
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Select_Title_ID()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT mission_name, a.SYSID,b.BUSINESSNAME,c.Name  FROM [InSpecation_Dimax].[dbo].[Mission_Title] as a " +
            "left join BusinessData as b on a.PID=b.PID " +
            "left join Business_Sub as c on a.PID2=c.PNumber where Flag = '1' ";
        var b = DBTool.Query<T_0250010000>(Sqlstr).ToList().Select(p => new
        {
            A = Value(p.SYSID),
            //B = Name(p.BUSINESSNAME, p.Name),
            C = Value(p.mission_name),
        });
        string outputJson = JsonConvert.SerializeObject(b);
        return outputJson;
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Show_Title(string value)
    {
        string Sqlstr = @"SELECT T_ID, ADDR, Name, MTEL, Cycle, Agent_ID FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@value";
        var a = DBTool.Query<T_0250010000>(Sqlstr, new { value = value }).ToList().Select(p => new
        {
            A = Value(p.T_ID),
            B = Value(p.ADDR),
            C = Value(p.Name),
            D = Value(p.MTEL),
            E = Value(p.Cycle),
            F = Value(p.Agent_ID),
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string ShowMonths(string value)
    {
        string time = DateTime.Now.ToString("MM");
        if (value =="0")
        {
            time = DateTime.Now.ToString("MM")+" 月";
        }            
        else if (value == "1")
        {
            if (time == "01" || time == "02")
                time = "1~2 月";
            else if (time == "03" || time == "04")
                time = "3~4 月";
            else if (time == "05" || time == "06")
                time = "5~6 月";
            else if (time == "07" || time == "08")
                time = "7~8 月";
            else if (time == "09" || time == "10")
                time = "9~10 月";
            else
                time = "11~12 月";
        }
        else if (value == "2")
        {
            if (time == "01" || time == "02" || time == "03")
                time = "1~3 月";
            else if (time == "04" || time == "05" || time == "06")
                time = "4~6 月";
            else if (time == "07" || time == "08" || time == "09")
                time = "7~9 月";
            else if (time == "10" || time == "11" || time == "12")
                time = "10~12 月";
        }
        else if (value == "3")
        {
            if(time=="01" || time=="02" || time=="03" || time=="04" || time=="05" || time=="06" )
                time = "1~6 月";
            else
                time = "7~12 月";
        }
            
        return time;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Show_Client_Data(string value)
    {
        Check();
        string Sqlstr = @"SELECT * " +
//  BUSINESSNAME, APPNAME, APP_OTEL_AREA, APP_OTEL, APP_MTEL, " +
//            "HardWare, SoftwareLoad, SERVICEITEM, SalseAgent, CONTACT_ADDR, MEMO " +
            " FROM BusinessData WHERE PID=@value";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { value = value }).ToList().Select(p => new
        {
            A = Value(p.PID),
            C = Value(p.BUSINESSNAME),
            D = Value(p.APPNAME),
            E = Value(p.APP_OTEL_AREA),
            F = Value(p.APP_OTEL),
            G = Value(p.APP_MTEL),
            H = Value(p.HardWare),
            I = Value(p.SoftwareLoad),
            J = Value(p.SERVICEITEM),
            K = Value(p.Telecomm_ID),
            L = Value(p.CONTACT_ADDR),
            //M = p.MEMO,
            N = Value(p.APP_EMAIL),
            O = Value(p.ID),
        });
        //06/21待續
        //string Sqlstr1 = @"SELECT BusinessData.Telecomm_ID,Telecomm.Telecomm_ID,Telecomm.Telecomm_Name FROM BusinessData,Telecomm WHERE BusinessData.Telecomm_ID=Telecomm.Telecomm_ID AND BusinessData.ID=@value";
        //var b = DBTool.Query<ClassTemplate>(Sqlstr1, new { value = value }).ToList().Select(q => new
        //{
        // K = q.Telecomm_ID1,
        // L = q.Telecomm_ID2,
        // M = q.Telecomm_Name
        //});
        string outputJson = JsonConvert.SerializeObject(a);

        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Show_Client_Data2(string value_2)                     // 叫出商業資料  234行
    {
        Check();
        string Sqlstr = @"SELECT * FROM Business_Sub WHERE PNumber=@value_2 ";                                                                //  ID=@value ?
        var a = DBTool.Query<T_0250010000>(Sqlstr, new { value_2 = value_2 }).ToList().Select(p => new
        {
            B = p.ID,
            C = p.Name,         // 公司名
            D = p.APPNAME,                  // 聯絡人
            E = p.Contact_ADDR,
            F = p.APP_FTEL,
            G = p.APP_MTEL,                 // 手機
            H = p.HardWare.Trim(),      // 硬體
            I = p.SoftwareLoad
            //J = p.SERVICEITEM,              // 合約
            //E = p.APP_OTEL_AREA,
            //F = p.APP_OTEL,                  // 電話
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Record(string id)
    {
        Check();
        string Sqlstr = @"SELECT C_ID2, Case_ID, SetupTime, BUSINESSNAME, OpinionContent, ReplyType, Reply, Type " +
            "FROM CaseData  WHERE PID=@id ";
        var a = DBTool.Query<T_0250010000>(Sqlstr, new { id = id }).ToList().Select(p => new
        {
            A = Value3(p.C_ID2,p.Case_ID),
            //B = Convert.ToDateTime(p.SetupTime).ToString("yyyy/MM/dd HH:mm"),
            B = Value2(p.SetupTime),
            C = Value(p.BUSINESSNAME),
            D = Value(p.OpinionContent),
            E = Value(p.ReplyType),
            F = Value(p.Reply),
            G = Value(p.Type)
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    public static string DealingProcess(string value)
    {
        if (value == "0")
        {
            return "結案";
        }
        else
        {
            return "處理中";
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Case_Save(string sysid2, string Creat_Agent, string login_time, string spottime,       //   string sysid, 
        string id, string t_id, string addr, string name, string mtel, string cycletime, string agent )
    {
        //DateTime time = DateTime.Parse(login_time);        
        string type = "未到點";
        string Type_Value = "1";
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Sqlstr;
        Sqlstr = @"SELECT TOP 1 Case_ID FROM [InSpecation_Dimax].[dbo].[Mission_Case] WHERE Case_ID=@Case_ID ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Case_ID = sysid2,
        });
        if (a.Any())
        {
            return JsonConvert.SerializeObject(new { status = "已有同Case_ID。" });
        };
        /*Sqlstr = @"SELECT TOP 1 C_ID2 FROM CaseData WHERE C_ID2=@C_ID2 ";
        a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            C_ID2 = sysid2,
        });
        if (a.Any())
        {
            return JsonConvert.SerializeObject(new { status = "已有相同案件編號，請利用產生補單編號鈕產生新的案件編號。" });
        };  //*/

        Sqlstr = @"INSERT INTO [InSpecation_Dimax].[dbo].[Mission_Case] ( Case_ID, SetupTime, Creat_Agent, Title_ID, " +      //4
            " Telecomm_ID, ADDR, APPNAME, APP_MTEL, " +     //8
            " Cycle, Agent_ID, Type_Value, Type ) " +                   //12
            // PS, 
            " Values (@sysid2, @Setuptime, @Creat_Agent, @Title_ID, " +       //4
            " @Telecomm_ID, @ADDR, @APPNAME, @APP_MTEL, " +
            " @Cycle, @Agent_ID, @Type_Value, @Type) ";                  //12
        string status = "new";  //    @ps, 

        a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            //sysid = sysid, 
            sysid2 = sysid2,
            SetupTime = login_time, 
            Creat_Agent = Creat_Agent,

            Title_ID = id,
            Telecomm_ID = t_id,
            ADDR = addr,
            APPNAME = name,
            APP_MTEL = mtel,
            Cycle = cycletime,
            Agent_ID = agent,

            Type_Value = Type_Value, Type = type,   //12
        });

        if (!string.IsNullOrEmpty(agent))   // 當值為null時跳過  非 null 時 update
        {
            Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Case] SET " +
                "Mission_Case.Agent_ID = DispatchSystem.Agent_ID, " +
                "Mission_Case.Handle_Agent = DispatchSystem.Agent_Name " +
                "FROM [DimaxCallcenter].[dbo].[DispatchSystem]  WHERE Mission_Case.Case_ID = @sysid2 and DispatchSystem.Agent_ID =@Agent_ID";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                sysid2 = sysid2,
                Agent_ID = agent,
            });
        }
        if (!string.IsNullOrEmpty(spottime))   // 當值為null時跳過  非 null 時 update
        {
            Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Case] SET OnSpotTime = @onspot_time WHERE Case_ID = @sysid2";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                sysid2 = sysid2,
                onspot_time = spottime,
            });
        }
       
        return JsonConvert.SerializeObject(new { status = status });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Case_Update(string sysid2, string Creat_Agent, string spottime,       //   string sysid, 
        string id, string t_id, string addr, string name, string mtel, string cycletime, string agent) //
    {
        //DateTime time = DateTime.Parse(login_time);
        //string Setuptime = login_time
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Case] SET " +      //
            "Creat_Agent = @Creat_Agent, " +       //4
            //"Title_ID = @Title_ID, " +
            "Telecomm_ID = @Telecomm_ID, ADDR = @ADDR, " +
            "APPNAME = @APPNAME, APP_MTEL = @APP_MTEL, " +
            "Cycle = @Cycle " +
            "WHERE Case_ID = @sysid2";
        string status = "update";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            sysid2 = sysid2,
            Creat_Agent = Creat_Agent,
            //Title_ID = id,
            Telecomm_ID = t_id,
            ADDR = addr,
            APPNAME = name,
            APP_MTEL = mtel,
            Cycle = cycletime,
            Agent_ID = agent,
        });

        if (!string.IsNullOrEmpty(id))   // 當值為null時跳過  非 null 時 update
        {
            Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Case] SET Title_ID = @Title_ID WHERE Case_ID = @sysid2";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                sysid2 = sysid2,
                Title_ID = id,
            });
        }
        if (!string.IsNullOrEmpty(spottime))   // 當值為null時跳過  非 null 時 update
        {
            Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Case] SET OnSpotTime = @onspot_time WHERE Case_ID = @sysid2";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                sysid2 = sysid2,
                onspot_time = spottime,
            });
        }
        if (!string.IsNullOrEmpty(agent))   // 當值為null時跳過  非 null 時 update
        {
            Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Case] SET " +
                "Mission_Case.Agent_ID = DispatchSystem.Agent_ID, " +
                "Mission_Case.Handle_Agent = DispatchSystem.Agent_Name " +
                "FROM [DimaxCallcenter].[dbo].[DispatchSystem]  WHERE Mission_Case.Case_ID = @sysid2 and DispatchSystem.Agent_ID = @Agent_ID ";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                sysid2 = sysid2,
                Agent_ID = agent,
            });
        }
        return JsonConvert.SerializeObject(new { status = status });
    }

    
    //=============【取消需求單】=============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Cancel(string sysid, string rep)
    {
        //Check();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string MNo = HttpContext.Current.Session["MNo"].ToString();
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        int i = 0;
        if (!String.IsNullOrEmpty(rep))
        {
            i = rep.Length;
            if (rep.Length > 250)
            {
                return JsonConvert.SerializeObject(new { status = "【取消原因】不能超過２５０個字元。" });
            }
            else
            {
                rep = HttpUtility.HtmlEncode(rep.Trim());
                if (rep.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = " 結尾處不能用空白或換行 " });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【取消原因】" });
        }

        //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單    0：取消        
        ClassTemplate template = new ClassTemplate()
        {
            MNo = MNo,
            Type_Value = "0",
            Type = "取消",
            Reply = rep.Trim(),
            //Cancel_ID = UserID,
            //Cancel_Name = UserIDNAME,
            //Cancel_Time = DateTime.Now
        };

        string sqlstr = @"UPDATE CaseData SET " +
        "Type_Value=@Type_Value, " +
        "Type=@Type, " +
        "Reply=@Question, " +
        "Service_Flag='1' " +
        "WHERE Case_ID=@MNo";

        using (IDbConnection db = DBTool.GetConn())
        {
            db.Execute(sqlstr, template);
            db.Close();
        };

        return JsonConvert.SerializeObject(new { status = "success", mno = MNo });
    }

    //=============【帶入需求單 母單內容】=============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Data(string Case_ID)
    {
        Check();
        Thread.Sleep(500);
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string sqlstr = @"SELECT TOP 1 * FROM [InSpecation_Dimax].[dbo].[Mission_Case] WHERE Case_ID=@Case_ID";
        string outputJson = "";
        var chk = DBTool.Query<T_0250010000>(sqlstr, new { Case_ID = Case_ID });
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
                    A = Value(p.Creat_Agent),
                    B = Value2(p.SetupTime),
                    C = Value(p.Title_ID),
                    D = Value(p.Telecomm_ID),
                    E = Value(p.ADDR),
                    F = Value(p.APPNAME),
                    G = Value(p.APP_MTEL),
                    H = Value(p.Cycle),
                    I = Value(p.Agent_ID),
                    J = Value2(p.OnSpotTime),
                    K = Value(p.Type),
                })
              );
            Thread.Sleep(500);
            return outputJson;
        }

    }

    //============= 驗證資料 ==============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check_Form(string Flag, string Service_ID, string Time_01, string Time_02, string PostCode, string Location, string LocationStart,
        string LocationEnd, string CarSeat, string ContactName, string ContactPhone2, string ContactPhone3, string Contact_Co_TEL,
        string Hospital, string HospitalClass, string Question)
    {
        Check();
        DateTime Date;
        string MNo = HttpContext.Current.Session["MNo"].ToString();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string Service = "";
        string ServiceName = "";
        string sql_check = "";

        // 驗證 Service_ID 服務內容
        if (!String.IsNullOrEmpty(Service_ID))
        {
            sql_check = @"SELECT TOP 1 Case_ID, Service, ServiceName FROM Data WHERE Service_ID=@Service_ID AND Service !='外包商' ";
            var check = DBTool.Query<ClassTemplate>(sql_check, new { Service_ID = Service_ID });
            if (!check.Any())
            {
                return JsonConvert.SerializeObject(new { status = "沒有此【服務內容】名稱" });
            }
            else
            {
                ClassTemplate schedule = check.First();
                Service = schedule.Service;
                ServiceName = schedule.ServiceName;
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【服務內容】" });
        }

        // 驗證 Time_01 預定起始時間是否為時間 是否空白
        if (!String.IsNullOrEmpty(Time_01))
        {
            if (!DateTime.TryParse(Time_01, out Date))
            {
                return JsonConvert.SerializeObject(new { status = error });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【預定起始時間】" });
        }

        // 驗證 Time_02 預定終止時間是否為時間 是否空白
        if (!String.IsNullOrEmpty(Time_02))
        {
            if (!DateTime.TryParse(Time_02, out Date))
            {
                return JsonConvert.SerializeObject(new { status = error });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【預定終止時間】" });
        }

        // 驗證 【預定起始時間】是否小於【現在時間】
        if (Convert.ToDateTime(Time_01) < DateTime.Now.AddDays(-14))
        {
            return JsonConvert.SerializeObject(new { status = "【預定起始時間】不能小於【" + DateTime.Now.AddDays(-14).ToString("yyyy/MM/dd HH:mm") + "】" });
        }

        // 驗證 【預定起始時間】是否小於【預定終止時間】
        if (Convert.ToDateTime(Time_01) > Convert.ToDateTime(Time_02))
        {
            return JsonConvert.SerializeObject(new { status = "【預定起始時間】不能大於【預定終止時間】" });
        }

        // 驗證 PostCode 郵遞區號是否為數字 是否不超過五碼
        if (!String.IsNullOrEmpty(PostCode))
        {
            if (PostCode.Length > 5)
            {
                return JsonConvert.SerializeObject(new { status = error });
            }
            else
            {
                try
                {
                    int i = Convert.ToInt32(PostCode);
                }
                catch
                {
                    return JsonConvert.SerializeObject(new { status = error });
                }
            }
        }

        //======================================================================
        string back = "";
        List<XXS> check_value = new List<XXS>();
        check_value.Add(new XXS { URL_ID = Location, MiniLen = 0, MaxLen = 100, Alert_Name = "地址與郵遞區號", URL_Type = "txt" });
        check_value.Add(new XXS { URL_ID = LocationStart, MiniLen = 0, MaxLen = 100, Alert_Name = "行程起點", URL_Type = "txt" });
        check_value.Add(new XXS { URL_ID = LocationEnd, MiniLen = 0, MaxLen = 100, Alert_Name = "行程終點", URL_Type = "txt" });
        check_value.Add(new XXS { URL_ID = ContactPhone2, MiniLen = 0, MaxLen = 10, Alert_Name = "公司手機號碼", URL_Type = "int" });
        check_value.Add(new XXS { URL_ID = ContactPhone3, MiniLen = 0, MaxLen = 10, Alert_Name = "手機簡碼", URL_Type = "int" });
        check_value.Add(new XXS { URL_ID = Question, MiniLen = 1, MaxLen = 250, Alert_Name = "狀況說明", URL_Type = "txt" });
        JavaScriptSerializer Serializer = new JavaScriptSerializer();
        string outputJson = Serializer.Serialize(check_value);
        back = JASON.Check_XSS(outputJson);
        if (back != "")
        {
            return JsonConvert.SerializeObject(new { status = back });
        };
        //=======================================================================

        //驗證 CarSeat 搭車人數是否為數字
        try
        {
            if (Convert.ToInt32(CarSeat) > 10 || Convert.ToInt32(CarSeat) < 0)
            {
                return JsonConvert.SerializeObject(new { status = error });
            }
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = error });
        }

        //驗證 ContactName 【聯絡人】
        if (!String.IsNullOrEmpty(ContactName))
        {
            if (ContactName.Length > 10)
            {
                return JsonConvert.SerializeObject(new { status = "【聯絡人】不能超過１０個字元。" });
            }
            else
            {
                if (JASON.IsNumericOrLetterOrChinese(ContactName) != true)
                {
                    return JsonConvert.SerializeObject(new { status = "【聯絡人】只能輸入數字、英文或中文。" });
                }
            }
        }

        //驗證 Contact_Co_TEL 【公司電話】
        Contact_Co_TEL = Contact_Co_TEL.Trim();
        if (!String.IsNullOrEmpty(Contact_Co_TEL))
        {
            if (Contact_Co_TEL.Length > 20)
            {
                return JsonConvert.SerializeObject(new { status = "【公司電話】不能超過２０個字元。" });
            }
            else
            {
                if (JASON.IsTelephone(Contact_Co_TEL) != true)
                {
                    return JsonConvert.SerializeObject(new { status = "【公司電話】格式不正確。" });
                }
            }
        }

        //驗證 Hospital 【醫療院所】與 HospitalClass【就醫類型】
        if (Service == "醫療")
        {
            //================ 驗證 Hospital 【醫療院所】 ================
            if (!String.IsNullOrEmpty(Hospital))
            {
                sql_check = @"SELECT HospitalName FROM DataHospital WHERE HospitalName = @HospitalName AND Flag = '1'";
                var check = DBTool.Query<ClassTemplate>(sql_check, new { HospitalName = Hospital });
                if (!check.Any())
                {
                    return JsonConvert.SerializeObject(new { status = "沒有此【醫療院所】名稱" });
                }
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = "請選擇【醫療院所】" });
            }

            //================ 驗證 HospitalClass【就醫類型】 ================
            if (!String.IsNullOrEmpty(HospitalClass))
            {
                if (HospitalClass != "上班就醫" && HospitalClass != "上班就醫 ( 需診斷書 )" && HospitalClass != "下班就醫" && HospitalClass != "下班就醫 ( 需診斷書 )" && HospitalClass != "")
                {
                    return JsonConvert.SerializeObject(new { status = "沒有此【就醫類型】名稱" });
                }
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = "請選擇【就醫類型】" });
            }
        }

        if (Flag == "1")
        {
            update_MNo(Service_ID, ServiceName, Time_01, Time_02, LocationStart, LocationEnd, CarSeat, ContactName, ContactPhone2,
                   ContactPhone3, Contact_Co_TEL, Hospital, HospitalClass, Question, PostCode, Location);
            return JsonConvert.SerializeObject(new { status = "update" });
        }
        else
        {
            sql_check = @"SELECT SYS_ID FROM MNo_Labor WHERE MNo=@MNo";
            var chk = DBTool.Query<ClassTemplate>(sql_check, new { MNo = MNo });
            if (chk.Count() > 0)
            {
                back = new_MNo(Service_ID, ServiceName, Time_01, Time_02, LocationStart, LocationEnd, CarSeat, ContactName, ContactPhone2,
                    ContactPhone3, Contact_Co_TEL, Hospital, HospitalClass, Question, PostCode, Location);
                return JsonConvert.SerializeObject(new { status = back });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = "請選擇【雇主】或【外勞】" });
            }
        }
    }

    //============= 新增需求單 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string new_MNo(string Service_ID, string ServiceName, string Time_01, string Time_02, string LocationStart, string LocationEnd,
        string CarSeat, string ContactName, string ContactPhone2, string ContactPhone3, string Contact_Co_TEL, string Hospital, string HospitalClass,
        string Question, string PostCode, string Location)
    {
        Check();
        string MNo = HttpContext.Current.Session["MNo"].ToString();
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string language = "";
        string EMMA_URL;
        string sql;
        string f_MNo;

        //↓↓↓↓↓ 檢查 [Faremma].[dbo].[Data] 服務項目 需不需要審核 ↓↓↓↓↓
        string EMMA = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
        string sql_txt = @"SELECT TOP 1 SYS_ID FROM Data WHERE Service_ID=@Service_ID AND Flag = '1' AND Service !='外包商' ";
        string f_type = "尚未派工";
        string f_value = "2";  //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
        string f_page = "2";  // 1.  需求單審核    2.   員工派工管理  3.  個人派工及結案管理
        string f_no = "派工";   // "審核"  "派工"  "接單"  "暫結案"  "結案"    
        var chk = DBTool.Query<ClassTemplate>(sql_txt, new { Service_ID = Service_ID });
        if (chk.Any())
        {
            f_type = "尚未審核";
            f_value = "1";
            f_page = "1";
            f_no = "審核";
        }
        //↑↑↑↑↑ 檢查 [Faremma].[dbo].[Data] 服務項目 需不需要審核 ↑↑↑↑↑
        Thread.Sleep(100);

        //============== 檢查 新增多筆勞工資訊（瀏覽） ==============
        #region
        sql_txt = @"SELECT * FROM MNo_Labor WHERE MNo=@MNo";
        chk = DBTool.Query<ClassTemplate>(sql_txt, new { MNo = MNo });
        Thread.Sleep(100);
        if (chk.Count() > 0)
        {
            #region
            //sql_txt = @"INSERT INTO LaborTemplate" +
            //    "(MNo, Type_Value, Type, Cust_Name, Cust_ID, Labor_ID, Labor_Team, Labor_Phone, Labor_Address, Labor_Address2, " +
            //    "Labor_Language, Service_ID, Time_01, Time_02, LocationStart, LocationEnd, CarSeat, ContactName, " +
            //    "ContactPhone2, ContactPhone3, Contact_Co_TEL, Hospital, HospitalClass, Question, Create_ID, PostCode, Location) " +
            //    "VALUES" +
            //    "(@MNo,@Type_Value,@Type,@Cust_Name, @Cust_ID, @Labor_ID,@Labor_Team,@Labor_Phone,@Labor_Address,@Labor_Address2, " +
            //    "@Labor_Language, @Service_ID, @Time_01, @Time_02, @LocationStart, @LocationEnd,@CarSeat, @ContactName, " +
            //     "@ContactPhone2, @ContactPhone3, @Contact_Co_TEL, @Hospital, @HospitalClass, @Question, @Create_ID, @PostCode, @Location)";
            #endregion
            sql_txt = "Declare @temp1 table ( [Labor_ID] [nvarchar](50) NULL " +
                " , [Service_ID] [varchar](2) NULL " +
                " , [Create_ID] [nvarchar](50) NULL )";

            sql_txt += "insert into @temp1 " +
                "([Labor_ID], [Service_ID], [Create_ID]) values ( @Labor_ID, @Service_ID, @Create_ID) ";

            sql_txt += "insert into LaborTemplate ([MNo], [Type_Value], [Type], [Cust_ID], [Cust_Name], [Labor_Team], [Labor_Company], [Labor_ID] " +
                ", [Labor_EName], [Labor_CName], [Labor_Country], [Labor_PID], [Labor_RID], [Labor_EID], [Labor_Phone], [Labor_Language] " +
                ", [Labor_Address], [Labor_Address2], [Labor_Valid], [Service_ID], [Service], [ServiceName], [Time_01], [Time_02], [CarSeat], [LocationStart], [LocationEnd] " +
                ", [Location], [PostCode], [ContactName], [ContactPhone2], [ContactPhone3], [Contact_Co_TEL], [Hospital], [HospitalClass], [Question], [Create_ID] " +
                ", [Create_Team], [Create_Name], [Create_Company], [Agent_Mail], [UserID] ) ";

            sql_txt += "select TOP 1 @MNo, @Type_Value, @Type, @Cust_ID, @Cust_Name, b.[Labor_Team], b.[Labor_Company], a.[Labor_ID] " +
                ", b.[Labor_EName], b.[Labor_CName], b.[Labor_Country], b.[Labor_PID], b.[Labor_RID], b.[Labor_EID], b.[Labor_Phone], @Labor_Language " +
                ", @Labor_Address, @Labor_Address2, b.[Labor_Valid], a.[Service_ID], c.[Service], c.[ServiceName], @Time_01, @Time_02, @CarSeat, @LocationStart, @LocationEnd " +
                ", @Location, @PostCode, @ContactName, @ContactPhone2, @ContactPhone3, @Contact_Co_TEL, @Hospital, @HospitalClass, @Question, a.[Create_ID] " +
                ", [Agent_Team] as [Create_Team]" +
                ", [Agent_Name] as [Create_Name]" +
                ", [Agent_Company] as [Create_Company]" +
                ", [Agent_Mail], [UserID] ";

            sql_txt += "from @temp1 as a " +
                "left join [Labor_System] as b on a.[Labor_ID]=b.[Labor_ID] " +
                "left join [Data] as c on a.[Service_ID]=c.[Service_ID] " +
                "left join [DispatchSystem] as d on a.[Create_ID]=d.[Agent_ID]";

            Thread.Sleep(100);
            foreach (var q in chk)
            {
                f_MNo = "1" + DateTime.Now.ToString("yyMMdd") + q.SYS_ID.ToString("000000");
                switch (q.Labor_Country.Trim())
                {
                    case "南非":
                        language = "英語";
                        break;
                    case "泰國":
                        language = "泰語";
                        break;
                    case "越南":
                        language = "越南語";
                        break;
                    case "印尼":
                        language = "印尼語";
                        break;
                    case "菲律賓":
                        language = "菲律賓語";
                        break;
                    default:
                        language = "";
                        break;
                }
                ClassTemplate template = new ClassTemplate()
                {
                    MNo = f_MNo,
                    Type = f_type,
                    Type_Value = f_value,  //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
                    Cust_Name = q.Cust_FullName,
                    Cust_ID = q.Cust_ID,
                    Labor_ID = q.Labor_ID,
                    Labor_Team = q.Labor_Team,
                    Labor_Phone = q.Labor_Phone,
                    Labor_Address = q.Labor_Address,
                    Labor_Address2 = q.Labor_Address2,
                    Labor_Language = language,
                    Service_ID = Service_ID,
                    Time_01 = Convert.ToDateTime(Time_01),
                    Time_02 = Convert.ToDateTime(Time_02),
                    LocationStart = LocationStart.Trim(),
                    LocationEnd = LocationEnd.Trim(),
                    CarSeat = CarSeat,
                    ContactName = ContactName,
                    ContactPhone2 = ContactPhone2,
                    ContactPhone3 = ContactPhone3,
                    Contact_Co_TEL = Contact_Co_TEL,
                    Hospital = Hospital,
                    HospitalClass = HospitalClass,
                    Question = Question.Trim(),
                    Create_ID = UserID,
                    PostCode = PostCode,
                    Location = Location
                };
                Thread.Sleep(100);

                try
                {
                    using (IDbConnection db = DBTool.GetConn())
                    {
                        db.Execute(sql_txt, template);
                        db.Close();
                    }
                }
                catch
                {
                    logger.Info("需求單新增錯誤：編號：" + f_MNo + "，Service_ID：" + Service_ID + "，Create_ID：" + UserID + "，Labor_ID：" + q.Labor_ID);
                    logger.Info("需求單新增錯誤：SQL：" + sql_txt);
                    return "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
                }

                Thread.Sleep(100);
                //=============  EMMA =============
                #region EMMA

                EMMA_URL = EMMA + "CheckLogin.aspx?seqno=" + f_MNo + "&page=" + f_page + "&login=";
                sql = @"SELECT * FROM Master_DATA WHERE Agent_Team=@Agent_Team AND Agent_LV = '15' ";
                var list = DBTool.Query<EMMA>(sql, new { Agent_Team = Agent_Team });
                //logger.Info("需求單編號：【" + f_MNo + "】EMMA Function 開始，部門【" + Agent_Team + "】");
                if (list.Count() > 0)
                {
                    sql = @"INSERT INTO tblAssign (AssignNo, E_MAIL, ConnURL) VALUES(@AssignNo ,@E_MAIL ,@ConnURL)";
                    logger.Info("===== EMMA 部門迴圈 開始=====");
                    foreach (var r in list)
                    {
                        ClassTemplate emma = new ClassTemplate()
                        {
                            AssignNo = "【" + f_no + "通知】【" + q.Cust_FullName + "：" + ServiceName + "】",    // "審核"  "派工"  "接單"  "暫結案"  "結案"
                            ConnURL = EMMA_URL + JASON.Encryption(r.UserID),
                            E_MAIL = r.E_Mail
                        };
                        using (IDbConnection db = DBTool.GetConn())
                        {
                            db.Execute(sql, emma);
                            db.Close();
                        }
                    }
                    logger.Info("===== EMMA 部門迴圈 結束=====");
                }
                logger.Info("===== EMMA Function 結束=====");

                #endregion
                //=============  EMMA =============
                Thread.Sleep(100);
            }
            return "new";
        }
        else
        {
            return "請選擇【雇主】或【外勞】";
        }
        #endregion
    }   //*/

    //============= 修改需求單 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string update_MNo(string Service_ID, string ServiceName, string Time_01, string Time_02, string LocationStart, string LocationEnd,
        string CarSeat, string ContactName, string ContactPhone2, string ContactPhone3, string Contact_Co_TEL, string Hospital, string HospitalClass,
        string Question, string PostCode, string Location)
    {
        Check();
        string MNo = HttpContext.Current.Session["MNo"].ToString();
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string sql_txt = @"UPDATE LaborTemplate SET " +
            "Service_ID=@Service_ID, " +
            "Time_01=@Time_01, " +
            "Time_02=@Time_02, " +
            "Location=@Location, " +
            "PostCode=@PostCode, " +
            "LocationStart=@LocationStart, " +
            "LocationEnd=@LocationEnd, " +
            "CarSeat=@CarSeat, " +
            "ContactName=@ContactName, " +
            "ContactPhone2=@ContactPhone2, " +
            "ContactPhone3=@ContactPhone3, " +
            "Contact_Co_TEL=@Contact_Co_TEL, " +
            "Hospital=@Hospital, " +
            "HospitalClass=@HospitalClass, " +
            "Question=@Question, " +
            "UPDATE_ID=@UPDATE_ID, " +
            "UPDATE_Name=@UPDATE_Name, " +
            "UPDATE_TIME=@UPDATE_TIME " +
            "WHERE MNo = @MNo";

        ClassTemplate template = new ClassTemplate()
        {
            MNo = MNo,
            Service_ID = Service_ID,
            Time_01 = Convert.ToDateTime(Time_01),
            Time_02 = Convert.ToDateTime(Time_02),
            Location = Location,
            PostCode = PostCode,
            LocationStart = LocationStart,
            LocationEnd = LocationEnd,
            CarSeat = CarSeat,
            ContactName = ContactName,
            ContactPhone2 = ContactPhone2,
            ContactPhone3 = ContactPhone3,
            Contact_Co_TEL = Contact_Co_TEL,
            Hospital = Hospital,
            HospitalClass = HospitalClass,
            Question = Question,
            UPDATE_ID = UserID,
            UPDATE_Name = UserIDNAME,
            UPDATE_TIME = DateTime.Now,
        };
        using (IDbConnection db = DBTool.GetConn())
        {
            db.Execute(sql_txt, template);
            db.Close();
        }
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //============= 讀取機關地址 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Location_List(string Type)
    {
        Check();
        string Sqlstr = @"SELECT SYS_ID, Name, Location, Postcode, Address, TEL FROM HRM2_Location WHERE Type = @Type ";
        var a = DBTool.Query<Location_str>(Sqlstr, new { Type = Type }).ToList().Select(p => new
        {
            SYS_ID = p.SYS_ID,
            Name = p.Name,
            Location = p.Location,
            Postcode = p.Postcode,
            Address = p.Address,
            TEL = p.TEL
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 地址欄位帶入地址 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Add_Location(string ID, string Flag)
    {
        Check();
        string sqlstr = "";
        if (Flag == "0")
        {
            sqlstr = @"SELECT Name, Location, Postcode, Address FROM HRM2_Location WHERE SYS_ID = @SYS_ID ";
            var a = DBTool.Query<Location_str>(sqlstr, new { SYS_ID = ID }).ToList().Select(p => new
            {
                Name = p.Name,
                Location = p.Location,
                Postcode = p.Postcode,
                Address = p.Address
            });
            string outputJson = JsonConvert.SerializeObject(a);
            return outputJson;
        }
        else
        {
            sqlstr = @"SELECT Cust_FullName, Cust_Postcode, Cust_Address_ZH FROM HRM2_Cust_System WHERE SYS_ID = @SYS_ID ";
            var a = DBTool.Query<Location_str>(sqlstr, new { SYS_ID = ID }).ToList().Select(p => new
            {
                Name = p.Cust_FullName,
                Location = "",
                Postcode = p.Cust_Postcode,
                Address = p.Cust_Address_ZH
            });
            string outputJson = JsonConvert.SerializeObject(a);
            return outputJson;
        }
    }

    public static void Check()
    {
        string Check = JASON.Check_ID("0250010000.aspx");
        if (Check == "NO")
        {
            //System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string ShowTime()
    {
        string time = DateTime.Now.ToString("yyyy/MM/dd HH:mm");
        return time;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Dispatch_Team()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT Agent_Company FROM DispatchSystem WHERE Agent_Status = '在職' ORDER BY Agent_Company ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            A = p.Agent_Company
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Agent()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT Agent_ID, Agent_Name FROM DispatchSystem WHERE Agent_Status = '在職' AND Agent_Company = 'Engineer' ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { }).ToList().Select(p => new
        {
            A = p.Agent_Name,
            B = p.Agent_ID
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }
    //============= 新增頁面派工 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Send_Save(string sysid, string value, string C_Name, string S_O_Type)    //工單ID , 員工ID, 備註
    {
        //Check();
        string Type = "承辦中";
        string sqlstr = @"INSERT INTO Case_Agent ( UpdateTime, Case_ID, Agent_ID, Type ) " +
        " VALUES( @UpdateTime, @Case_ID, @Agent_ID, @Type) ";
        DBTool.Query<ClassTemplate>(sqlstr, new
        {
            Case_ID = sysid,
            Agent_ID = value,
            Type = Type,        // 狀態 承辦中 or 已轉派
            //Agent_PS = PS,
            UpdateTime = DateTime.Now,  //抓在在時間?   
        });      //                
        string mail = "";
        string Agent_Name = "";
        sqlstr = @"SELECT * FROM DispatchSystem WHERE Agent_ID=@Agent_ID";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = value });
        if (list.Any())
        {
            ClassTemplate schedule = list.First();  // 功能???            
            mail = schedule.Agent_Mail;
            Agent_Name = schedule.Agent_Name;
        }
        string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
        string EMMA = URL + "CheckLogin.aspx?seqno=" + sysid + "&page=4";
        ClassTemplate emma = new ClassTemplate()
        {
            AssignNo = "【派工通知】【" + C_Name + "：" + S_O_Type + "】",        // + service + "【填單人員：" + creat_name + "】
            E_MAIL = mail,
            ConnURL = EMMA
        };
        sqlstr = @"INSERT INTO tblAssign (AssignNo ,E_MAIL ,ConnURL) VALUES(@AssignNo ,@E_MAIL ,@ConnURL)";
        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, emma);

/*        string Sqlstr = @"UPDATE CaseData SET Handle_Agent = @Agent_Name, " + // 新增頁面前無資料
                "Agent_ID=@Agent_ID WHERE Case_ID = @sysid";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            sysid = sysid,
            Agent_Name = Agent_Name,
            Agent_ID = value,
        });     //*/

        Thread.Sleep(250);
        return JsonConvert.SerializeObject(new { status = "success" });
    }
    //============= 派工 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Send(string sysid, string value, string C_Name, string S_O_Type)    //工單ID , 員工ID, 備註
    {
        //Check();
        string Type = "承辦中";
        string sqlstr = @"INSERT INTO Case_Agent ( UpdateTime, Case_ID, Agent_ID, Type ) " +
        " VALUES( @UpdateTime, @Case_ID, @Agent_ID, @Type ) ";
        DBTool.Query<ClassTemplate>(sqlstr, new 
        { 
            Case_ID = sysid,
            Agent_ID = value,
            Type = Type,        // 狀態 承辦中 or 已轉派
            //Agent_PS = PS,
            UpdateTime = DateTime.Now,  //抓在在時間?   
        });      //                

        string mail = "";
        string Agent_Name = "";
        sqlstr = @"SELECT * FROM DispatchSystem WHERE Agent_ID=@Agent_ID";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = value });
        if (list.Any())
        {
            ClassTemplate schedule = list.First();  // 功能???            
            mail = schedule.Agent_Mail;
            Agent_Name = schedule.Agent_Name;
        }
        string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
        string EMMA = URL + "CheckLogin.aspx?seqno=" + sysid + "&page=4";
        ClassTemplate emma = new ClassTemplate()
       {
           AssignNo = "【派工通知】【" + C_Name + "：" + S_O_Type + "】",        // + service + "【填單人員：" + creat_name + "】
           E_MAIL = mail,
           ConnURL = EMMA
       };
        sqlstr = @"INSERT INTO tblAssign (AssignNo ,E_MAIL ,ConnURL) VALUES(@AssignNo ,@E_MAIL ,@ConnURL)";
        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, emma);

        string Sqlstr = @"UPDATE CaseData SET Handle_Agent = @Agent_Name, " +
                "Agent_ID=@Agent_ID WHERE Case_ID = @sysid";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            sysid = sysid,
            Agent_Name = Agent_Name,
            Agent_ID = value,
        });

         Thread.Sleep(250);
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    //============= 轉派工 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Change(string sysid, string value, string C_Name, string S_O_Type, string value2)    //工單ID , 員工ID, 備註
    {
        //Check();
        string Type = "承辦中";
        string sqlstr = @"INSERT INTO Case_Agent ( UpdateTime, Case_ID, Agent_ID, Type ) " +
        " VALUES( @UpdateTime, @Case_ID, @Agent_ID, @Type ) ";
        DBTool.Query<ClassTemplate>(sqlstr, new
        {
            Case_ID = sysid,
            Agent_ID = value,
            Type = Type,        // 狀態 承辦中 or 已轉派
            //Agent_PS = PS,
            UpdateTime = DateTime.Now,  //抓在在時間?   
        });      //                
        string mail = "";
        string Agent_Name = "";
        string mail2 = "";
        string name = "";
        sqlstr = @"SELECT * FROM DispatchSystem WHERE Agent_ID=@Agent_ID";  // 抓派工員工信箱
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = value });
        if (list.Any())
        {
            ClassTemplate schedule = list.First();  // 功能???            
            name = schedule.Agent_Name;
            mail = schedule.Agent_Mail;
            Agent_Name = schedule.Agent_Name;
        }
        sqlstr = @"SELECT * FROM DispatchSystem WHERE Agent_ID=@Agent_ID";  // 抓取消員工信箱
        list = DBTool.Query<ClassTemplate>(sqlstr, new { Agent_ID = value2 });
        if (list.Any())
        {
            ClassTemplate schedule = list.First();  // 功能???            
            mail2 = schedule.Agent_Mail;
        }

        string URL = System.Web.Configuration.WebConfigurationManager.AppSettings["EMMA"].ToString();
        string EMMA = URL + "CheckLogin.aspx?seqno=" + sysid + "&page=4" ;
        ClassTemplate emma = new ClassTemplate()
        {
            AssignNo = "【派工通知】【" + C_Name + "：" + S_O_Type + "】",        // + service + "【填單人員：" + creat_name + "】
            E_MAIL = mail,
            ConnURL = EMMA
        };
        sqlstr = @"INSERT INTO tblAssign (AssignNo ,E_MAIL ,ConnURL) VALUES(@AssignNo ,@E_MAIL ,@ConnURL)";
        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, emma);
        Thread.Sleep(250);

        ClassTemplate emma2 = new ClassTemplate()
        {
            AssignNo = "【轉派工通知】【" + C_Name + "：" + S_O_Type + "】【已轉派給：" + name  + "】",        // + service + "【填單人員：" + creat_name + "】
            E_MAIL = mail2,
            ConnURL = EMMA
        };
        sqlstr = @"INSERT INTO tblAssign (AssignNo ,E_MAIL ,ConnURL) VALUES(@AssignNo ,@E_MAIL ,@ConnURL)";
        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, emma2);

        string Sqlstr = @"UPDATE CaseData SET Handle_Agent = @Agent_Name, " +
                "Agent_ID=@Agent_ID WHERE Case_ID = @sysid";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            sysid = sysid,
            Agent_Name = Agent_Name,
            Agent_ID = value,
        });

        Thread.Sleep(250);
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string URL(string Case_ID)        //轉跳
    {
        //Check();
        //Case_ID = Case_ID.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(Case_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error + "_1" });
        }

        //       if (Case_ID.Length > 16 || Case_ID.Length < 1)        {
        //           return JsonConvert.SerializeObject(new { status = error + "_2" });        }

        /*       if (Case_ID != "0")
               {
                   string sqlstr = @"SELECT TOP 1 PID FROM [DimaxCallcenter].[dbo].[BusinessData] WHERE PID=@PID ";
                   var a = DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID });

                   if (!a.Any())
                   {
                       return JsonConvert.SerializeObject(new { status = "查無【" + PID + "】此編號客戶。", type = "no" });
                   };
               };  //*/
        string str_url = "../0250010000.aspx?seqno=" + Case_ID;         //打開0060010000 並放入同PID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }    

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Show(string value)
    {
        //Check();
        string Sqlstr = @"SELECT DISTINCT Agent_ID, Agent_Name, UserID FROM DispatchSystem WHERE Agent_Status = '在職' AND Agent_ID=@Agent_ID";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Agent_ID = value }).ToList().Select(p => new
        {
            A = Value(p.Agent_Name),
            B = Value(p.Agent_ID),
            C = Value(p.UserID)
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    public static string Value(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
        }
        else value = "";
        return value;
    }
    public static string Value2(string value)        // 當值為null時跳過  非 null 時改時間格式
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = DateTime.Parse(value).ToString("yyyy/MM/dd HH:mm");
        }
        return value;
    }
    public static string Value3(string value, string value2)        // 當value值為""  非 value=value2
    {
        if (string.IsNullOrEmpty(value))
        {
            value = value2.Trim();
        }
        else
            value = value.Trim();
        return value;
    }
    public static string Test(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
            if (value == "1900/01/01 12:00")
            {
                value = "";
            }
        }
        return value;
    }
    public static string Name(string value, string value2)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value2))
        {
            value = "(子) " + value2.Trim();
        }
        else
            value = value.Trim();
        return value;
    }

    public class Location_str
    {
        public string SYS_ID { get; set; }
        public string Service { get; set; }
        public string Flag_Add { get; set; }
        public string Name { get; set; }
        public string Location { get; set; }
        public string Postcode { get; set; }
        public string Address { get; set; }
        public string TEL { get; set; }
        public string Cust_Address_ZH { get; set; }
        public string Cust_FullName { get; set; }
        public string Cust_Postcode { get; set; }
    }
    public class T_0250010000
    {
        public int a { get; set; }
        public string ID { get; set; }
        public string OE_ID { get; set; }
        public string Product_Name { get; set; }
        public string Product_ID { get; set; }
        public string Main_Classified { get; set; }
        public string Detail_Classified { get; set; }
        public string Unit_Price { get; set; }
        public string Contact_ADDR { get; set; }

        public string OE_O_ID { get; set; }
        public string OE_Case_ID { get; set; }
        public string Quantity { get; set; }
        public string T_Price { get; set; }

        public string OE_D_ID { get; set; }
        public string Con_Name { get; set; }
        public string Con_Phone { get; set; }
        public string SetupDate { get; set; }
        public string UpdateDate { get; set; }
        public string Total_Price { get; set; }
        public string BUSINESSNAME { get; set; }
        public string PID { get; set; }
        public string PID2 { get; set; }
        public string Type_Value { get; set; }
        public string Type { get; set; }
        public string APPNAME { get; set; }
        public string CONTACT_ADDR { get; set; }
        public string APP_FTEL { get; set; }
        public string APP_MTEL { get; set; }
        public string HardWare { get; set; }
        public string SoftwareLoad { get; set; }
        public string Name { get; set; }
        public string PNumber { get; set; }
        public string S_APPNAME { get; set; }
        public string S_CONTACT_ADDR { get; set; }
        public string S_APP_FTEL { get; set; }
        public string S_APP_MTEL { get; set; }
        public string S_HardWare { get; set; }
        public string S_SoftwareLoad { get; set; }
        public string RFQ { get; set; }
        public string Warranty_Date { get; set; }
        public string Warr_Time { get; set; }
        public string Protect_Date { get; set; }
        public string Prot_Time { get; set; }
        public string Receipt_Date { get; set; }
        public string Receipt_PS { get; set; }
        public string Close_Out_Date { get; set; }
        public string Close_Out_PS { get; set; }
        public string OE_PS { get; set; }
        public string Final_Price { get; set; }
        public string str_sysid { get; set; }

        public string Case_ID { get; set; }
        public string SetupTime { get; set; }
        public string Caller_ID { get; set; }
        public string Creat_Agent { get; set; }
        public string ADDR { get; set; }
        public string Telecomm_ID { get; set; }
        public string APP_EMAIL { get; set; }
        public string SERVICEITEM { get; set; }
        public string APPNAME_2 { get; set; }
        public string ID_2 { get; set; }
        public string APP_MTEL_2 { get; set; }
        public string ADDR_2 { get; set; }
        public string HardWare_2 { get; set; }
        public string SoftwareLoad_2 { get; set; }
        public string Urgency { get; set; }
        public string OnSpotTime { get; set; }
        public string OpinionType { get; set; }   
        public string ReplyType { get; set; }
        public string OpinionContent { get; set; }
        public string Handle_Agent { get; set; }
        public string PS { get; set; }
        public string Reply { get; set; }
        public string UploadTime { get; set; }
        public string ReachTime { get; set; }
        public string FinishTime { get; set; }
        public string Agent_ID { get; set; }
        public string C_ID2 { get; set; }
        public string UserID { get; set; }
        public string SYSID { get; set; }
        public string T_ID { get; set; }
        public string MTEL { get; set; }
        public string Cycle { get; set; }
        public string Title_ID { get; set; }
        public string mission_name { get; set; }
    }
    
}

//==================== LINQ SQL 迴圈====================
//      string sqlstr = @"select * from EMMA_System
//                          where Service=@Service";
//        var list = DBTool.Query<ClassTemplate>(sqlstr, new { Service = "郵寄" });
//        logger.Info("=====================================");
//        if (list.Count() > 0)
//        {
//            foreach (var q in list)
//            {
//                logger.Info("Name = \"{0}\", Score = {1}" + q.SYS_ID + q.ServiceName);
//            }
//        }
//==================================================