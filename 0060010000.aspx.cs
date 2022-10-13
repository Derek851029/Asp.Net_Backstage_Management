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

public partial class _0060010000 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
//    string sql_txt;

    protected string opinionsubject = "";
    protected string opinioncontent_txt = "456";
    protected string test = "123";

    protected string seqno = "";
    protected string str_title = "新增";
    protected string str_type = " 存檔後系統自動編號";
    protected string new_mno = "";

    protected void Page_Load(object sender, EventArgs e)            //判斷是否前往 10000/10003.aspx  或回到 10000/10002.aspx
    {
        if (!IsPostBack)
        {
            Check();
            seqno = Request.Params["seqno"];
            if (string.IsNullOrEmpty(seqno))
            {
                Response.Redirect("/0060010001.aspx");  //如果 seqno 沒有任何值 則回到 Default.aspx
            }

            if (seqno != "0")
            {
                Session["PID"] = seqno;
                str_title = "顯示";
                string sqlstr = @"SELECT TOP 1 PID FROM BusinessData WHERE PID=@PID";          //  LaborTemplate > CaseData, MNo > Case_ID

                var chk = DBTool.Query<ClassTemplate>(sqlstr, new { PID = seqno });                 // MNo > Case_ID               001
                if (!chk.Any())
                {
                    //Response.Redirect("/0030010000/0030010002.aspx");
                    Response.Write("<script>alert('查無【" + seqno + "】客戶編號'); location.href='/0060010001.aspx'; </script>");
                }
                /*               else
                               {
                                   ClassTemplate schedule = ClassScheduleRepository._0030010001_View_Case_ID(seqno);       // To 730
                                   string url = "/0030010000/0030010003.aspx?seqno=" + Request.Params["seqno"];
                                   if (schedule.Type_Value == "1")
                                   {
                                       str_title = "顯示";
                                       str_type = "尚未審核";
                                       opinionsubject = @"SELECT TOP 1 OpinionSubject as OS FROM CaseData WHERE Case_ID=@Case_ID";     //意見主旨內容
                        
                                       if (Session["Agent_LV"].ToString() != "30")         // 權限 = 30 ?
                                       {
                                           if (Session["Agent_Team"].ToString() != schedule.Type_Value)
                                           {
                                               Response.Write("<script>alert('您沒有訪問此頁面的權限，此需求單非您部門的需求單。'); location.href='/0030010000/0030010002.aspx'; </script>");
                                           }
                                       }
                                   }
                                   else
                                   {
                                       Response.Redirect(url);
                                   }
                               };  */
            }
            else
            {
                //【創造母單編號】
                new_mno = DateTime.Now.ToString("yyMMddHHmmssfff");         // 增單時自動產生的編號 要F5 才會有新編號
                //Session["Case_ID"] = new_mno;
            }
        }
    }

    //protected string opinionsubject = "意見主旨";
    //protected string opinioncontent_txt = "意見內容";

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Case_Save(string sysid, string login_time, string client_id, string urgency, string op_source, string op_type, string esti_fin_time, string op_sub, string onspot_time, string opinion, string rep_type, string ps, string deal_process, string rep, int telecomm_id)
   // 新需求單 數據登錄
    {
        DateTime time_02 = DateTime.Parse(esti_fin_time);
        DateTime time = DateTime.Parse(login_time);
        string Sqlstr = @"INSERT INTO CaseData (Case_ID, Upload_Time, ID, Urgency, OpinionContent, " +
            "OpinionSource, OpinionType, OpinionSubject, OnSpotTime, EstimatedFinishTime, " +
            "ReplyType, PS, DealingProcess, Reply, Telecomm_ID ) " +
           " VALUES( @sysid, @login_time, @client_id, @urgency, @opinion, " +             //sysid > Case_ID ?
           "@op_source, @op_type, @op_sub,@onspot_time, @esti_fin_time, " +
           "@rep_type, @ps, @deal_process, @rep, @telecomm_id )";
                        // 增加資料 依前後排序一一寫入CaseData中
        string status = "登單完成";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            sysid = sysid,
            telecomm_id = telecomm_id,
            login_time = login_time,
            client_id = client_id,
            urgency = urgency,
            op_source = op_source,
            op_type = op_type,
            esti_fin_time = time_02.ToString("yyyy-MM-dd hh:mm:ss"),
            op_sub = op_sub,
            onspot_time = onspot_time,
            opinion = opinion,
            rep_type = rep_type,
            ps = ps,
            deal_process = deal_process,
            rep = rep
        });
        return JsonConvert.SerializeObject(new { status = status });
    }

    //===============

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Labor_Delete(string SYS_ID)                            // 舊的 刪除用?
    {
        Check();
        string Sqlstr = @"DELETE FROM MNo_Labor WHERE SYS_ID = @SYS_ID";
        using (IDbConnection conn = DBTool.GetConn())
        {
            conn.Execute(Sqlstr, new { SYS_ID = SYS_ID });
            conn.Close();
        }
        return JsonConvert.SerializeObject(new { status = "success" });
    }
    //===============  

    public static void Check()
    {
        //string Check = JASON.Check_ID("0030010002.aspx");
        //if (Check == "NO")
        //{
        //   System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        //}
    }

    //===============  

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_BusData(string PID)                                                       // 新增 讀BusinessData 案件資料
    {
        //Check();        
        string sqlstr = @"SELECT * FROM BusinessData  WHERE PID=@PID";
        //string outputJson = "";
        var lcd = DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID }).ToList().Select(p => new
        {
            PID = p.PID,
            BUSINESSNAME = p.BUSINESSNAME,
            ID = p.ID,
            CONTACT_ADDR = p.CONTACT_ADDR,
            APP_OTEL = p.APP_OTEL,
            APP_FTEL = p.APP_FTEL,
            APPNAME = p.APPNAME,
            APP_SUBTITLE = p.APP_SUBTITLE,
            APP_MTEL = p.APP_MTEL,
            APP_EMAIL = p.APP_EMAIL    
        });
        string outputJson = JsonConvert.SerializeObject(lcd);
        return outputJson;
    }

    //===============  

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetSubsidiaryList(string PID)                                                       // 新增 讀BusinessData 案件資料
    {
        //Check(); 
        PID = PID.Trim();
        string sqlstr = @"SELECT * FROM Business_Sub  WHERE PID=@PID";
        //string outputJson = "";
        var lcd = DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID }).ToList().Select(p => new
        {
            PID = p.PID,
            PNumber = p.PNumber,
            SalseAgent = p.SalseAgent,
            BUSINESSNAME = p.Name,
            Information_PS = p.Information_PS,
            SetupDate = DateTime.Parse(p.SetupDate).ToString("yyyy/MM/dd hh:mm"),
            UpDateDate = DateTime.Parse(p.UpDateDate).ToString("yyyy/MM/dd hh:mm")
            //UpDateDate = Value2(p.UpDateDate)
        });
        string outputJson = JsonConvert.SerializeObject(lcd);
        return outputJson;
    }
    //==============讀取完整子公司資料
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Data(string PNumber)                                                       // 新增 讀CaseData 案件資料
    {
        //Check();
        //string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        //string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString('yyyy/mm/dd hh:mm:ss');
        string sqlstr = @"SELECT * FROM Business_Sub WHERE PNumber=@PNumber";
        //string outputJson = "";
        var lcd = DBTool.Query<ClassTemplate>(sqlstr, new { PNumber = PNumber }).ToList().Select(p => new
        {
            PNumber = p.PNumber,
            Name = p.Name,
            ADDR = p.ADDR,
            CONTACT_ADDR = p.Contact_ADDR,           
            APP_OTEL = p.APP_OTEL,
            APP_FTEL = p.APP_FTEL,
            //PID = PID,
            BUSINESSNAME = p.BUSINESSNAME,
            BUSINESSID = p.BUSINESSID,
            ID = p.ID,
            //BUS_CREATE_DATE = p.BUS_CREATE_DATE,
            APPNAME = p.APPNAME,
            APP_SUBTITLE = p.APP_SUBTITLE,
            APP_MTEL = p.APP_MTEL,
            APP_EMAIL = p.APP_EMAIL,
            APPNAME_2 = p.APPNAME_2,
            APP_SUBTITLE_2 = p.APP_SUBTITLE_2,
            APP_MTEL_2 = p.APP_MTEL_2,
            APP_EMAIL_2 = p.APP_EMAIL_2, 
            INVOICENAME = p.INVOICENAME,
            Inads = Value(p.Inads),
            HardWare = Value(p.HardWare),
            SoftwareLoad = Value(p.SoftwareLoad),
            Mail_Type = Value(p.Mail_Type),
            OE_Number = Value(p.OE_Number),
            SalseAgent = Value(p.SalseAgent),
            Salse = Value(p.Salse),
            Salse_TEL = p.Salse_TEL,
            SID = p.SID,
            Serial_Number = p.Serial_Number,
            License_Host = p.License_Host,
            Licence_Name = p.Licence_Name,
            LAC = p.LAC,
            Our_Reference = p.Our_Reference,
            Your_Reference = p.Your_Reference,
            Auth_File_ID = p.Auth_File_ID,
            Telecomm_ID = p.Telecomm_ID,
            FL = p.FL,
            Group_Name_ID = p.Group_Name_ID,
            SED = p.SED,
            SERVICEITEM = p.SERVICEITEM,
            Warranty_Date = Value2(p.Warranty_Date),
            Warr_Time = Value(p.Warr_Time),
            Protect_Date = Value2(p.Protect_Date),
            Prot_Time = Value(p.Prot_Time),
            Receipt_Date = Value2(p.Receipt_Date),
            Receipt_PS = p.Receipt_PS,
            Close_Out_Date = Value2(p.Close_Out_Date),
            Close_Out_PS = p.Close_Out_PS,
            Account_PS = p.Account_PS,
            Information_PS = p.Information_PS,
            SetupDate = Value2(p.SetupDate),
            // 共讀取 49 個     */

            //H = p.HardWare.Trim(),      // 硬體   .Trim() 去除資料後方多餘的空白
        });

        string outputJson = JsonConvert.SerializeObject(lcd);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Safe2(int Flag, string PNumber, string PID, string ID, string Warranty_Date, string Protect_Date,
        string Receipt_Date, string Close_Out_Date, string SetupDate, string UpDateDate, 
        string Name, string APPNAME, string APP_SUBTITLE, string APP_MTEL,
        string APP_EMAIL, string APPNAME_2, string APP_SUBTITLE_2, string APP_MTEL_2, string APP_EMAIL_2,
        string ADDR, string Contact_ADDR, string APP_OTEL, string APP_FTEL, string INVOICENAME,
        string Inads, string HardWare, string SoftwareLoad, string Mail_Type, string OE_Number,
        string SalseAgent, string Salse, string Salse_TEL, string SID, string Serial_Number,
        string License_Host, string Licence_Name, string LAC, string Our_Reference, string Your_Reference,
        string Auth_File_ID, string Telecomm_ID, string FL, string Group_Name_ID, string SED,
        string SERVICEITEM, string Warr_Time, string Prot_Time, string Receipt_PS, string Close_Out_PS,
        string Account_PS, string Information_PS)
    {
        string status;
        string Sqlstr = "";
        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 Name, PID FROM Business_Sub WHERE Name=@Name and PID = @PID ";    // 
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                Name = Name
                ,PID = PID
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "該客戶已有相同的子公司。" });
            };
            Sqlstr = @"INSERT INTO Business_Sub (Name, PID, ID, APPNAME, APP_SUBTITLE, APP_MTEL, APP_EMAIL, APPNAME_2, APP_SUBTITLE_2 ,  " +
                " APP_MTEL_2, APP_EMAIL_2, ADDR, Contact_ADDR , APP_OTEL, APP_FTEL , INVOICENAME, Inads, HardWare, SoftwareLoad, " +
                " Mail_Type, OE_Number, SalseAgent, Salse, Salse_TEL, SID, Serial_Number, License_Host, Licence_Name, LAC,  " +
                " Our_Reference, Your_Reference, Auth_File_ID,Telecomm_ID, FL, Group_Name_ID, SED, SERVICEITEM, Warr_Time,   " +
                " Prot_Time, Receipt_PS, Close_Out_PS, Account_PS, Information_PS, UpDateDate, SetupDate) " +
                " VALUES (@Name, @PID, @ID, @APPNAME, @APP_SUBTITLE, @APP_MTEL, @APP_EMAIL, @APPNAME_2, @APP_SUBTITLE_2 , " +
                " @APP_MTEL_2, @APP_EMAIL_2, @ADDR, @Contact_ADDR , @APP_OTEL, @APP_FTEL , @INVOICENAME, @Inads, @HardWare, @SoftwareLoad, " +
                " @Mail_Type, @OE_Number, @SalseAgent, @Salse, @Salse_TEL, @SID, @Serial_Number, @License_Host, @Licence_Name, @LAC,  " +
                " @Our_Reference, @Your_Reference, @Auth_File_ID, @Telecomm_ID, @FL, @Group_Name_ID, @SED, @SERVICEITEM, @Warr_Time, " +
                " @Prot_Time, @Receipt_PS, @Close_Out_PS, @Account_PS, @Information_PS, @UpDateDate, @SetupDate)";
            //共50個    
            status = "new";

            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                Name = Name,
                PID = PID,
                ID = ID,
                APPNAME = APPNAME,
                APP_SUBTITLE = APP_SUBTITLE,
                APP_MTEL = APP_MTEL,
                APP_EMAIL,
                APPNAME_2 = APPNAME_2,
                APP_SUBTITLE_2 = APP_SUBTITLE_2,        //第10
                APP_MTEL_2 = APP_MTEL_2,
                APP_EMAIL_2 = APP_EMAIL_2,
                ADDR = ADDR,
                Contact_ADDR = Contact_ADDR,
                APP_OTEL = APP_OTEL,
                APP_FTEL = APP_FTEL,
                INVOICENAME = INVOICENAME,
                Inads = Inads,
                HardWare = HardWare,
                SoftwareLoad = SoftwareLoad,        //第20
                Mail_Type = Mail_Type,
                OE_Number = OE_Number,
                SalseAgent = SalseAgent,
                Salse = Salse,
                Salse_TEL = Salse_TEL,
                SID = SID,
                Serial_Number = Serial_Number,
                License_Host = License_Host,
                Licence_Name = Licence_Name,
                LAC = LAC,          //第30
                Our_Reference = Our_Reference,
                Your_Reference = Your_Reference,
                Auth_File_ID = Auth_File_ID,
                Telecomm_ID = Telecomm_ID,
                FL = FL,
                Group_Name_ID = Group_Name_ID,
                SED = SED,
                SERVICEITEM = SERVICEITEM,
                Warranty_Date = Warranty_Date,
                Warr_Time = Warr_Time,          //第40
                Protect_Date = Protect_Date,
                Prot_Time = Prot_Time,
                Receipt_Date = Receipt_Date,
                Receipt_PS = Receipt_PS,
                Close_Out_Date = Close_Out_Date,
                Close_Out_PS = Close_Out_PS,
                Account_PS = Account_PS,
                Information_PS = Information_PS,
                UpDateDate = UpDateDate,
                SetupDate = SetupDate
            });
            if (!string.IsNullOrEmpty(Protect_Date))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE Business_Sub SET Protect_Date = @Protect_Date " +
                    "WHERE Name = @Name and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    Name = Name,
                    SetupDate = SetupDate,
                    Protect_Date = Protect_Date,
                });
            }
            if (!string.IsNullOrEmpty(Receipt_Date))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE Business_Sub SET Receipt_Date = @Receipt_Date " +
                    "WHERE Name = @Name and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    Name = Name,
                    SetupDate = SetupDate,
                    Receipt_Date = Receipt_Date,
                });
            }
            if (!string.IsNullOrEmpty(Close_Out_Date))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE Business_Sub SET Close_Out_Date  = @Close_Out_Date  " +
                    "WHERE Name = @Name and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    Name = Name,
                    SetupDate = SetupDate,
                    Close_Out_Date = Close_Out_Date,
                });
            }
            if (!string.IsNullOrEmpty(Warranty_Date))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE Business_Sub SET Warranty_Date = @Warranty_Date " +
                    "WHERE Name = @Name and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    Name = Name,
                    SetupDate = SetupDate,
                    Warranty_Date = Warranty_Date,
                });
            }




            //return JsonConvert.SerializeObject(new { status = "檢查中" });
        }   //if(Flag == 0)結束
        else if (Flag == 1)
        {
            Sqlstr = @"SELECT TOP 1 Name, PID FROM Business_Sub WHERE Name=@Name and PID = @PID and  PNumber != @PNumber";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Name = Name, PID = PID, PNumber = PNumber });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "該客戶已有相同的子公司。" });
            };

            Sqlstr = @"UPDATE Business_Sub SET Name=@Name, ADDR=@ADDR, " +
                "Contact_ADDR=@Contact_ADDR, UpDateDate=@UpDateDate,  " +
                "ID = @ID, APPNAME = @APPNAME, " +
                 "APP_SUBTITLE = @APP_SUBTITLE, APP_MTEL = @APP_MTEL, APP_EMAIL = @APP_EMAIL, APPNAME_2 = @APPNAME_2, APP_SUBTITLE_2 = @APP_SUBTITLE_2, " +  //--10
                 "APP_MTEL_2 = @APP_MTEL_2, APP_EMAIL_2 = @APP_EMAIL_2, APP_OTEL = @APP_OTEL, " +
                 "APP_FTEL = @APP_FTEL, INVOICENAME = @INVOICENAME, Inads = @Inads, HardWare = @HardWare, SoftwareLoad = @SoftwareLoad, " + //--20
                 "Mail_Type = @Mail_Type, OE_Number = @OE_Number, SalseAgent = @SalseAgent, Salse = @Salse, Salse_TEL = @Salse_TEL, " +
                 "SID = @SID, Serial_Number = @Serial_Number, License_Host = @License_Host, Licence_Name = @Licence_Name, LAC = @LAC, " +  //--30
                 "Our_Reference = @Our_Reference, Your_Reference = @Your_Reference, Auth_File_ID = @Auth_File_ID, Telecomm_ID = @Telecomm_ID, FL = @FL, " +
                 "Group_Name_ID = @Group_Name_ID, SED = @SED, SERVICEITEM = @SERVICEITEM, Warr_Time = @Warr_Time, " + //--40
                 "Prot_Time = @Prot_Time, 	Receipt_PS = @Receipt_PS, " +
                 "Close_Out_PS = @Close_Out_PS, Account_PS = @Account_PS, Information_PS = @Information_PS WHERE PNumber = @PNumber ";

            status = "update";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                PNumber = PNumber,
                Name = Name,                
                ID = ID,
                APPNAME = APPNAME,
                APP_SUBTITLE = APP_SUBTITLE,
                APP_MTEL = APP_MTEL,
                APP_EMAIL,
                APPNAME_2 = APPNAME_2,
                APP_SUBTITLE_2 = APP_SUBTITLE_2,        //第10
                APP_MTEL_2 = APP_MTEL_2,
                APP_EMAIL_2 = APP_EMAIL_2,
                ADDR = ADDR,
                Contact_ADDR = Contact_ADDR,
                APP_OTEL = APP_OTEL,
                APP_FTEL = APP_FTEL,
                INVOICENAME = INVOICENAME,
                Inads = Inads,
                HardWare = HardWare,
                SoftwareLoad = SoftwareLoad,        //第20
                Mail_Type = Mail_Type,
                OE_Number = OE_Number,
                SalseAgent = SalseAgent,
                Salse = Salse,
                Salse_TEL = Salse_TEL,
                SID = SID,
                Serial_Number = Serial_Number,
                License_Host = License_Host,
                Licence_Name = Licence_Name,
                LAC = LAC,          //第30
                Our_Reference = Our_Reference,
                Your_Reference = Your_Reference,
                Auth_File_ID = Auth_File_ID,
                Telecomm_ID = Telecomm_ID,
                FL = FL,
                Group_Name_ID = Group_Name_ID,
                SED = SED,
                SERVICEITEM = SERVICEITEM,
                Warranty_Date = Warranty_Date,
                Warr_Time = Warr_Time,          //第40
                Protect_Date = Protect_Date,
                Prot_Time = Prot_Time,
                Receipt_Date = Receipt_Date,
                Receipt_PS = Receipt_PS,
                Close_Out_Date = Close_Out_Date,
                Close_Out_PS = Close_Out_PS,
                Account_PS = Account_PS,
                Information_PS = Information_PS,
                UpDateDate = UpDateDate
            });
            if (!string.IsNullOrEmpty(Protect_Date))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE Business_Sub SET Protect_Date = @Protect_Date " +
                    "WHERE Name = @Name and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    Name = Name,
                    SetupDate = SetupDate,
                    Protect_Date = Protect_Date,
                });
            }
            else
            {
                Sqlstr = @"UPDATE Business_Sub SET Protect_Date = null where PNumber = @PNumber ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new { PNumber = PNumber });
            }
            if (!string.IsNullOrEmpty(Receipt_Date))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE Business_Sub SET Receipt_Date = @Receipt_Date " +
                    "WHERE Name = @Name and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    Name = Name,
                    SetupDate = SetupDate,
                    Receipt_Date = Receipt_Date,
                });
            }
            else
            {
                Sqlstr = @"UPDATE Business_Sub SET Receipt_Date = null where PNumber = @PNumber ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new { PNumber = PNumber });
            }
            if (!string.IsNullOrEmpty(Close_Out_Date))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE Business_Sub SET Close_Out_Date  = @Close_Out_Date  " +
                    "WHERE Name = @Name and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    Name = Name,
                    SetupDate = SetupDate,
                    Close_Out_Date = Close_Out_Date,
                });
            }
            else
            {
                Sqlstr = @"UPDATE Business_Sub SET Close_Out_Date = null where PNumber = @PNumber ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new { PNumber = PNumber });
            }
            if (!string.IsNullOrEmpty(Warranty_Date))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE Business_Sub SET Warranty_Date = @Warranty_Date " +
                    "WHERE Name = @Name and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    Name = Name,
                    SetupDate = SetupDate,
                    Warranty_Date = Warranty_Date,
                });
            }
            else
            {
                Sqlstr = @"UPDATE Business_Sub SET Warranty_Date = null where PNumber = @PNumber ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new { PNumber = PNumber });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝01。" });
        }
        return JsonConvert.SerializeObject(new { status = status });        // */
    }

    public static string Value(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
        }
        return value;
    }
    public static string Value2(string value)        // 當值為null時跳過  非 null 時改時間格式
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = DateTime.Parse(value).ToString("yyyy/MM/dd hh:mm");
        }
        return value;
    }

/*     //=============== 
    public static string Show_CaseData(string value)                     // 叫出商業資料  234行
    {
        Check();
        string Sqlstr = @"SELECT BUSINESSNAME,APPNAME,APP_OTEL_AREA,APP_OTEL,APP_MTEL,HardWare, " +
            " SoftwareLoad,SERVICEITEM FROM BusinessData WHERE ID=@value ";                                                                //  ID=@value ?
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { value = value }).ToList().Select(p => new
        {
            C = p.BUSINESSNAME,         // 公司名
            D = p.APPNAME,                  // 聯絡人
            E = p.APP_OTEL_AREA,
            F = p.APP_OTEL,                  // 電話
            G = p.APP_MTEL,                 // 手機
            H = p.HardWare.Trim(),      // 硬體
            I = p.SoftwareLoad,
            J = p.SERVICEITEM              // 合約
        });
        string outputJson = JsonConvert.SerializeObject(a);

        return outputJson;
    }           */

    //===============  
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