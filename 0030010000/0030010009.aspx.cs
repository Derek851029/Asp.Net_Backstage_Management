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

public partial class _0030010009 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //Check();
        }
    }

    public static void Check()
    {
        string Check = JASON.Check_ID("0030010009.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetCaseList()
    {
        //Check();
        string Agent_Company = HttpContext.Current.Session["Agent_Company"].ToString();
        //string sqlstr = @"SELECT Top 1000 * FROM CaseData order by SetupTime desc";
        string sqlstr = @"SELECT * FROM InSpecation_Dimax.dbo.Mission_Case Order by OnSpotTime Desc";
        var a = DBTool.Query<T_0030010009>(sqlstr).ToList().Select(p => new
        {
            OnSpotTime = Value2(p.OnSpotTime),
            Case_ID = Value(p.Case_ID),
            Title_Name = Value(p.Title_Name),
            Handle_Agent = Value(p.Handle_Agent),
            Type = Value(p.Type),
            Agent_Company = "",
            Telecomm_ID = Value(p.Telecomm_ID)
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Client_Code_Search()
    {
        //Check();
        string Sqlstr = @"Select Title_Name,Title_ID FROM InSpecation_Dimax.dbo.Mission_Case " + 
            " Where Title_Name<>'' Group by Title_Name,Title_ID order by Title_ID ";
        var a = DBTool.Query<T_0030010009>(Sqlstr).ToList().Select(p => new
        {
            A = p.Title_Name,
            B = p.Title_ID
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Dispatch_Name(string value)
    {
        string Sqlstr = @"SELECT DISTINCT Agent_ID, Handle_Agent as Agent_Name FROM InSpecation_Dimax.dbo.Mission_Case " +
               " WHERE Agent_ID<>'' " +
               " ORDER BY Agent_ID, Agent_Name ";
        /*string Sqlstr = @"SELECT DISTINCT Agent_ID, Agent_Name FROM DispatchSystem WHERE Agent_Status = '在職' " +
            " AND Agent_Company in ('Engineer', 'Pre-sale') " +
            " ORDER BY Agent_ID, Agent_Name ";  //*/
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Agent_Company = value }).ToList().Select(p => new
        {
            A = p.Agent_Name,
            B = p.Agent_ID
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]       //子公司列表
    public static string SearchCase(string start, string end, string A_N, string D_P, string S_C_ID, string S_OT, string T_ID)
    {
        //Check();
        string outputJson = "";
        string sqlstr = @"SELECT * FROM InSpecation_Dimax.dbo.Mission_Case WHERE 1=1 ";
        if (start != "")//
        {
            sqlstr += " AND OnSpotTime > @start ";  
        } 
        if (end != "")//
        {
            sqlstr += " AND OnSpotTime < @end ";  
        }
        if (A_N != "")//
        {
            sqlstr += " AND Agent_ID = @Agent_ID ";  
        } 
        if (D_P != "")//
        {
            sqlstr += " AND Type = @Type ";  
        }
        if (S_C_ID != "")//
        {
            sqlstr += " AND Case_ID LIKE '%'+@OC+'%'  ";  
        }
        /*if (S_OT != "")//
        {
            sqlstr += " AND OpinionType=@SOT ";  
        }   //*/
        if (T_ID != "")//
        {
            sqlstr += " AND Title_ID=@T_ID  ";  
        }

        sqlstr += " Order by  OnSpotTime Desc ";
        var a = DBTool.Query<T_0030010009>(sqlstr, new {
            start = start,
            end = end,
            Agent_ID = A_N,
            Type = D_P,
            OC = S_C_ID,
            SOT = S_OT,
            T_ID = T_ID
        }).ToList().Select(p => new
                {
                    OnSpotTime = Value2(p.OnSpotTime),
                    Case_ID = Value(p.Case_ID),
                    Title_Name = Value(p.Title_Name),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),
                    kind = "新版",
                    OpinionType = "",//Value(p.OpinionType),
                    Name = "",//Value(p.Handle_Agent),
                    //C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    Agent_Company = "",
                    Telecomm_ID = Value(p.Telecomm_ID)
                });
        outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]

    public static string URL(string Case_ID)
    {
        //Check();
        //PID = PID.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(Case_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error + "_1" });
        }

        //string str_url = "../0030010097.aspx?seqno=" + Case_ID;         //打開0060010000 並放入同PID號的資料
        string str_url = "../0250010004.aspx?seqno=" + Case_ID;         //
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)] 
    public static string URL2(string Case_ID)
    {
        //Check();
        //PID = PID.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(Case_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error + "_1" });
        }

        //string str_url = "../0030010099.aspx?seqno=" + Case_ID;         //打開0060010000 並放入同PID號的資料
        string str_url = "../0250010000.aspx?seqno=" + Case_ID;         //
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }    
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_PROGLIST(string ROLE_ID)
    {
        //Check();
        string sqlstr = "";
        string outputJson = "";

        //============= 驗證 權限代碼有無被竄改 =============
        sqlstr = @"SELECT TOP 1 * FROM ROLELIST WHERE ROLE_ID=@ROLE_ID";
        var chk = DBTool.Query<CMS_0060010000>(sqlstr, new { ROLE_ID = ROLE_ID });
        if (!chk.Any())
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { TREE_ID = "NULL" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        //============= 驗證 權限代碼有無被竄改 =============

        sqlstr = @"select case when c.TREE_Name is null then a.TREE_NAME else c.TREE_NAME end  as M_TREE_NAME,a.TREE_ID , a.TREE_NAME ," +
           " Case when b.Tree_ID is not null then '1' else '0' end as NowStatus ,d.Agent_Name , b.UpDateDate " +
           " FROM ( select * from PROGLIST where NAVIGATE_URL is not null and LTRIM(NAVIGATE_URL) <> '' and IS_OPEN='Y') as a " +
           " Left join ROLEPROG b on b.Role_ID = @Role_ID and a.TREE_ID = b.TREE_ID and IS_OPEN = 'Y' " +
           " Left join (select * from PROGLIST where (PARENT_ID is not null and LTRIM(PARENT_ID) <> '') " +
           " and (NAVIGATE_URL is  null or LTRIM(NAVIGATE_URL) = '') ) as c on a.PARENT_ID = c.TREE_ID " +
           " Left join DispatchSystem as d on d.Agent_ID = b.UpDateUser " +
           " order by c.sort_id , a.sort_id ";
        var a = DBTool.Query<CMS_0060010000>(sqlstr, new { ROLE_ID = ROLE_ID }).ToList().Select(p => new
        {
            TREE_ID = p.TREE_ID,
            M_TREE_NAME = p.M_TREE_NAME,
            TREE_NAME = p.TREE_NAME,
            Agent_Name = p.Agent_Name,
            UpDateDate = p.UpDateDate,
            NowStatus = p.NowStatus
        });
        outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    // 預定修改執行部分
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Data(string PID)                                                       // 新增 讀CaseData 案件資料
    {
        //Check();
        //string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        //string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string sqlstr = @"SELECT * FROM BusinessData WHERE PID=@PID";
        //string outputJson = "";
        var lcd = DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID }).ToList().Select(p => new
        {
            PID = PID,
            BUSINESSNAME = p.BUSINESSNAME,
            BUSINESSID = p.BUSINESSID,
            ID = p.ID,
            //BUS_CREATE_DATE = Value2(p.BUS_CREATE_DATE),
            APPNAME = p.APPNAME,                                APP_SUBTITLE = p.APP_SUBTITLE,
            APP_MTEL = p.APP_MTEL,                              APP_EMAIL = p.APP_EMAIL,
            APPNAME_2 = p.APPNAME_2,                        APP_SUBTITLE_2 = p.APP_SUBTITLE_2,
            APP_MTEL_2 = p.APP_MTEL_2,                      APP_EMAIL_2 = p.APP_EMAIL_2,
            REGISTER_ADDR = p.REGISTER_ADDR,        CONTACT_ADDR = p.CONTACT_ADDR,
            APP_OTEL = p.APP_OTEL,                              APP_FTEL = p.APP_FTEL,
            INVOICENAME = p.INVOICENAME,
            Inads = Value(p.Inads),
            HardWare = Value(p.HardWare),
            SoftwareLoad = Value(p.SoftwareLoad),
            Mail_Type = Value(p.Mail_Type),
            OE_Number = Value(p.OE_Number),
            SalseAgent = Value(p.SalseAgent),
            Salse = Value(p.Salse),
            Salse_TEL = p.Salse_TEL,                                SID = p.SID,
            Serial_Number = p.Serial_Number,            License_Host = p.License_Host,
            Licence_Name = p.Licence_Name,              LAC = p.LAC,
            Our_Reference = p.Our_Reference,            Your_Reference = p.Your_Reference,
            Auth_File_ID = p.Auth_File_ID,                    Telecomm_ID = p.Telecomm_ID,
            FL = p.FL,                                                         Group_Name_ID = p.Group_Name_ID,
            SED = p.SED,                                                    SERVICEITEM = p.SERVICEITEM,
            Warranty_Date = Value2(p.Warranty_Date),
            Warr_Time = Value(p.Warr_Time),
            Protect_Date = Value2(p.Protect_Date),
            Prot_Time = Value(p.Prot_Time),
            Receipt_Date = Value2(p.Receipt_Date),                  Receipt_PS = p.Receipt_PS,
            Close_Out_Date = Value2(p.Close_Out_Date),        Close_Out_PS = p.Close_Out_PS,
            Account_PS = p.Account_PS,                       Information_PS = p.Information_PS,
            SetupDate = Value2(p.SetupDate)                           
            // 共讀取 49 個

            //H = p.HardWare.Trim(),      // 硬體   .Trim() 去除資料後方多餘的空白
        });

        string outputJson = JsonConvert.SerializeObject(lcd);
        return outputJson;
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
    /*
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check_Menu(string Flag, string TREE_ID, string ROLE_ID)
    {
        Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        if (Flag.Length > 1)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }

        if (TREE_ID.Length > 10)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }

        if (ROLE_ID.Length > 10)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
        string sqlstr = "";

        //============= 驗證 權限代碼有無被竄改 =============
        sqlstr = @"SELECT TOP 1 * FROM ROLELIST WHERE ROLE_ID=@ROLE_ID";
        var chk = DBTool.Query<CMS_0060010000>(sqlstr, new { ROLE_ID = ROLE_ID });
        if (!chk.Any())
        {
            return JsonConvert.SerializeObject(new { status = "無此系統參數，請再嘗試或詢問管理人員，謝謝。" });
        }
        //============= 驗證 權限代碼有無被竄改 =============

        //============= 驗證 選單編號有無被竄改 =============
        sqlstr = @"SELECT TOP 1 * FROM PROGLIST WHERE TREE_ID=@TREE_ID";
        chk = DBTool.Query<CMS_0060010000>(sqlstr, new { TREE_ID = TREE_ID });
        if (!chk.Any())
        {
            return JsonConvert.SerializeObject(new { status = "無此系統參數，請再嘗試或詢問管理人員，謝謝。" });
        }
        //============= 驗證 選單編號有無被竄改 =============

        if (Flag == "1")
        {
            sqlstr = @"DELETE FROM ROLEPROG WHERE Role_ID=@ROLE_ID AND TREE_ID=@TREE_ID";
            Flag = "系統選單關閉完成。";
        }
        else
        {
            sqlstr = @"INSERT INTO ROLEPROG ( Role_ID, TREE_ID, UpDateUser, UpDateDate ) VALUES(@ROLE_ID, @TREE_ID, @Agent_ID, @DateTime)";
            Flag = "系統選單開啟完成。";
        }

        try
        {
            using (IDbConnection conn = DBTool.GetConn())
            {
                conn.Execute(sqlstr, new { TREE_ID = TREE_ID, ROLE_ID = ROLE_ID, Agent_ID = Agent_ID, DateTime = DateTime.Now });
            }
            return JsonConvert.SerializeObject(new { status = Flag });
        }
        catch (Exception err)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
    }   */

    //============= 建新資料用=============    

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Safe(int Flag,  string Warranty_Date, string Protect_Date,  //string BUS_CREATE_DATE,
        string Receipt_Date, string Close_Out_Date, string SetupDate, string UpDateDate, string BUSINESSNAME, 
        string ID, string BUSINESSID, string APPNAME, string APP_SUBTITLE, string APP_MTEL, 
        string APP_EMAIL, string APPNAME_2, string APP_SUBTITLE_2, string APP_MTEL_2, string APP_EMAIL_2, 
        string REGISTER_ADDR, string CONTACT_ADDR, string APP_OTEL, string APP_FTEL, string INVOICENAME, 
        string Inads, string HardWare, string SoftwareLoad, string Mail_Type, string OE_Number, 
        string SalseAgent, string Salse, string Salse_TEL, string SID, string Serial_Number, 
        string License_Host, string Licence_Name, string LAC, string Our_Reference, string Your_Reference, 
        string Auth_File_ID, string Telecomm_ID, string FL, string Group_Name_ID, string SED, 
        string SERVICEITEM, string Warr_Time, string Prot_Time, string Receipt_PS, string Close_Out_PS, 
        string Account_PS, string Information_PS )   
    {       
        string status;
        string Sqlstr = "";
        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 * FROM BusinessData WHERE BUSINESSNAME=@BUSINESSNAME and ID = @ID";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                ID = ID,                
                BUSINESSNAME = BUSINESSNAME
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有相同的客戶名稱與統編。" });
            };
            Sqlstr = @"INSERT INTO BusinessData (BUSINESSNAME, BUSINESSID, ID,  APPNAME, APP_SUBTITLE, APP_MTEL, APP_EMAIL, APPNAME_2, APP_SUBTITLE_2 ,  " +    //BUS_CREATE_DATE,
                " APP_MTEL_2, APP_EMAIL_2, REGISTER_ADDR, CONTACT_ADDR , APP_OTEL, APP_FTEL , INVOICENAME, Inads, HardWare, SoftwareLoad, " +
                " Mail_Type, OE_Number, SalseAgent, Salse, Salse_TEL, SID, Serial_Number, License_Host, Licence_Name, LAC,  " +
                " Our_Reference, Your_Reference, Auth_File_ID,Telecomm_ID, FL, Group_Name_ID, SED, SERVICEITEM,  Warranty_Date, Warr_Time,   " +
                " Protect_Date, Prot_Time, Receipt_Date, Receipt_PS, Close_Out_Date, Close_Out_PS, Account_PS, Information_PS, UpDateDate, SetupDate) " +
                " VALUES (@BUSINESSNAME, @BUSINESSID, @ID,  @APPNAME, @APP_SUBTITLE, @APP_MTEL, @APP_EMAIL, @APPNAME_2, @APP_SUBTITLE_2 , " +  //@BUS_CREATE_DATE,
                " @APP_MTEL_2, @APP_EMAIL_2, @REGISTER_ADDR, @CONTACT_ADDR , @APP_OTEL, @APP_FTEL , @INVOICENAME, @Inads, @HardWare, @SoftwareLoad, " +
                " @Mail_Type, @OE_Number, @SalseAgent, @Salse, @Salse_TEL, @SID, @Serial_Number, @License_Host, @Licence_Name, @LAC,  " +
                " @Our_Reference, @Your_Reference, @Auth_File_ID, @Telecomm_ID, @FL, @Group_Name_ID, @SED, @SERVICEITEM, @Warranty_Date, @Warr_Time, " +
                " @Protect_Date, @Prot_Time, @Receipt_Date, @Receipt_PS, @Close_Out_Date, @Close_Out_PS, @Account_PS, @Information_PS, @UpDateDate, @SetupDate)";
                //共50個    
            status = "new";

            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                BUSINESSNAME = BUSINESSNAME,
                BUSINESSID = BUSINESSID,
                ID = ID,
                //BUS_CREATE_DATE = BUS_CREATE_DATE,               
                APPNAME = APPNAME,
                APP_SUBTITLE = APP_SUBTITLE,
                APP_MTEL = APP_MTEL,
                APP_EMAIL,
                APPNAME_2 = APPNAME_2,
                APP_SUBTITLE_2 = APP_SUBTITLE_2,        //第10
                APP_MTEL_2 = APP_MTEL_2,
                APP_EMAIL_2 = APP_EMAIL_2,
                REGISTER_ADDR = REGISTER_ADDR,
                CONTACT_ADDR = CONTACT_ADDR,
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
                Warranty_Date = Test(Warranty_Date),
                Warr_Time = Warr_Time,          //第40
                Protect_Date = Test(Protect_Date),
                Prot_Time = Test(Prot_Time),
                Receipt_Date = Test(Receipt_Date),
                Receipt_PS = Receipt_PS,
                Close_Out_Date = Close_Out_Date,
                Close_Out_PS = Close_Out_PS,
                Account_PS = Account_PS,
                Information_PS = Information_PS,
                UpDateDate = Test(UpDateDate), 
                SetupDate = Test(SetupDate),
            });

            //return JsonConvert.SerializeObject(new { status = "檢查中" });
        }        
        else
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝01。" });
        }

 /*     try
        {
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                //ROLE_ID = ROLE_ID,
                //ROLE_NAME = ROLE_NAME,
                //UpDateUser = HttpContext.Current.Session["UserIDNAME"].ToString(),
                //UpDateDate = DateTime.Now
            });
        }       //
        catch
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝02。" });
        }   //*/

        return JsonConvert.SerializeObject(new { status = status });        // */
    }

    //============= 修改客戶資料 (Flag = 1)=============    
    
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New(int Flag, string PID,  string Warranty_Date, string Protect_Date,   //string BUS_CREATE_DATE,
        string Receipt_Date, string Close_Out_Date, string UpDateDate, string BUSINESSNAME, string ID,
        string BUSINESSID, string APPNAME, string APP_SUBTITLE, string APP_MTEL, string APP_EMAIL, 
        string APPNAME_2, string APP_SUBTITLE_2, string APP_MTEL_2, string APP_EMAIL_2, string REGISTER_ADDR, 
        string CONTACT_ADDR, string APP_OTEL, string APP_FTEL, string INVOICENAME, string Inads, 
        string HardWare, string SoftwareLoad, string Mail_Type, string OE_Number, string SalseAgent, 
        string Salse, string Salse_TEL, string SID, string Serial_Number, string License_Host, 
        string Licence_Name, string LAC, string Our_Reference, string Your_Reference, string Auth_File_ID, 
        string Telecomm_ID, string FL, string Group_Name_ID, string SED, string SERVICEITEM, 
        string Warr_Time, string Prot_Time, string Receipt_PS, string Close_Out_PS, string Account_PS, 
        string Information_PS)   //共51個  DateTime SetupDate,
    {
        //Check();
        //return BUSINESSNAME;
        PID = PID.Trim();
        string status;
        string Sqlstr = "";
        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 PID FROM BusinessData WHERE BUSINESSNAME=@BUSINESSNAME and ID=@ID";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new { 
 //               BUS_CREATE_DATE = BUS_CREATE_DATE ,  Warranty_Date = Warranty_Date ,  Protect_Date = Protect_Date ,  
  //              Receipt_Date = Receipt_Date ,  Close_Out_Date = Close_Out_Date ,  SetupDate = SetupDate ,  LoginTime = LoginTime , APPNAME = APPNAME , 
//                APP_SUBTITLE = APP_SUBTITLE , APP_MTEL = APP_MTEL , APP_EMAIL, APPNAME_2 = APPNAME_2 , APP_SUBTITLE_2 = APP_SUBTITLE_2 , APP_MTEL_2 = APP_MTEL_2 , 
//                APP_EMAIL_2 = APP_EMAIL_2 , REGISTER_ADDR = REGISTER_ADDR , CONTACT_ADDR = CONTACT_ADDR , APP_OTEL = APP_OTEL , APP_FTEL = APP_FTEL , 
//                INVOICENAME = INVOICENAME , Inads = Inads , HardWare = HardWare , SoftwareLoad = SoftwareLoad , Mail_Type = Mail_Type, OE_Number=OE_Number, 
//                SalseAgent = SalseAgent , Salse = Salse , Salse_TEL = Salse_TEL , SID = SID , Serial_Number = Serial_Number , License_Host = License_Host , 
//                Licence_Name = Licence_Name, LAC = LAC , Our_Reference = Our_Reference , Your_Reference = Your_Reference , Auth_File_ID = Auth_File_ID , 
//                Telecomm_ID = Telecomm_ID , FL = FL , Group_Name_ID = Group_Name_ID, SED = SED , SERVICEITEM = SERVICEITEM , Warr_Time = Warr_Time , 
 //               Prot_Time = Prot_Time , Receipt_PS = Receipt_PS , Close_Out_PS = Close_Out_PS , Account_PS = Account_PS , Information_PS =Information_PS 
                BUSINESSNAME = BUSINESSNAME, ID = ID
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有相同的客戶名稱與統編。" });
            };
/*
            Sqlstr = @"INSERT INTO ROLELIST (BUSINESSNAME, BUSINESSID, ID, BUS_CREATE_DATE, APPNAME, APP_SUBTITLE, APP_MTEL, APP_EMAIL, APPNAME_2, " +                                   
                " APP_SUBTITLE_2 , APP_MTEL_2, APP_EMAIL_2, REGISTER_ADDR, CONTACT_ADDR , APP_OTEL, APP_FTEL , INVOICENAME, Inads, HardWare, SoftwareLoad, " + 
                " Mail_Type, OE_Number, SalseAgent, Salse, Salse_TEL, SID, Serial_Number, License_Host, Licence_Name, LAC, Our_Reference, Your_Reference, Auth_File_ID, " + 
                " Telecomm_ID, FL, Group_Name_ID, SED, SERVICEITEM,  Warranty_Date, Warr_Time, Protect_Date, Prot_Time, Receipt_Date, Receipt_PS, Close_Out_Date,  " +                    
                " Close_Out_PS, Account_PS, Information_PS, UpDateDate, SetupDate)      VALUES (@BUSINESSNAME, @BUSINESSID, @ID, @BUS_CREATE_DATE, @APPNAME, " +        
                " @APP_SUBTITLE, @APP_MTEL, @APP_EMAIL, @APPNAME_2, @APP_SUBTITLE_2 , @APP_MTEL_2, @APP_EMAIL_2, @REGISTER_ADDR, @CONTACT_ADDR , " +   
                " @APP_OTEL, @APP_FTEL , @INVOICENAME, @Inads, @HardWare, @SoftwareLoad,  @Mail_Type, @OE_Number, @SalseAgent, @Salse, @Salse_TEL,  " + 
                " @SID, @Serial_Number, @License_Host, @Licence_Name, @LAC, @Our_Reference, @Your_Reference, @Auth_File_ID, @Telecomm_ID, @FL, " +                    
                " @Group_Name_ID, @SED, @SERVICEITEM, @Warranty_Date, @Warr_Time, @Protect_Date, @Prot_Time, @Receipt_Date, @Receipt_PS, " +         
                " @Close_Out_Date, @Close_Out_PS, @Account_PS, @Information_PS, @UpDateDate, @SetupDate)";               //*/  //錯誤的 下方才是正確的 update
            status = "new";         
        }
        else if (Flag == 1)
        {            
            Sqlstr = @"UPDATE BusinessData set  BUSINESSNAME = @BUSINESSNAME " +
                ", BUSINESSID = @BUSINESSID, ID = @ID,  APPNAME = @APPNAME, " +  //BUS_CREATE_DATE = @BUS_CREATE_DATE,
                 "APP_SUBTITLE = @APP_SUBTITLE, APP_MTEL = @APP_MTEL, APP_EMAIL = @APP_EMAIL, APPNAME_2 = @APPNAME_2, APP_SUBTITLE_2 = @APP_SUBTITLE_2, " +  //--10
                 "APP_MTEL_2 = @APP_MTEL_2, APP_EMAIL_2 = @APP_EMAIL_2, REGISTER_ADDR = @REGISTER_ADDR, CONTACT_ADDR = @CONTACT_ADDR, APP_OTEL = @APP_OTEL, " +
                 "APP_FTEL = @APP_FTEL, INVOICENAME = @INVOICENAME, Inads = @Inads, HardWare = @HardWare, SoftwareLoad = @SoftwareLoad, " + //--20
                 "Mail_Type = @Mail_Type, OE_Number = @OE_Number, SalseAgent = @SalseAgent, Salse = @Salse, Salse_TEL = @Salse_TEL, " +
                 "SID = @SID, Serial_Number = @Serial_Number, License_Host = @License_Host, Licence_Name = @Licence_Name, LAC = @LAC, " +  //--30
                 "Our_Reference = @Our_Reference, Your_Reference = @Your_Reference, Auth_File_ID = @Auth_File_ID, Telecomm_ID = @Telecomm_ID, FL = @FL, " +
                 "Group_Name_ID = @Group_Name_ID, SED = @SED, SERVICEITEM = @SERVICEITEM, Warranty_Date = @Warranty_Date, Warr_Time = @Warr_Time, " + //--40
                 "Protect_Date = @Protect_Date, 	Prot_Time = @Prot_Time, 	Receipt_Date = @Receipt_Date, Receipt_PS = @Receipt_PS, Close_Out_Date = @Close_Out_Date, " +
                 "Close_Out_PS = @Close_Out_PS, Account_PS = @Account_PS, Information_PS = @Information_PS, UpDateDate = @UpDateDate " + //, SetupDate = @SetupDate
                 "where PID = @PID ";
            status = "update";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                PID = PID,
                BUSINESSNAME = BUSINESSNAME,
                BUSINESSID = BUSINESSID,
                ID = ID,
                //BUS_CREATE_DATE = BUS_CREATE_DATE,
                Warranty_Date = Test(Warranty_Date),
                Protect_Date = Test(Protect_Date),
                Receipt_Date = Test(Receipt_Date),
                Close_Out_Date = Close_Out_Date,
                UpDateDate = UpDateDate,
                APPNAME = APPNAME,                              // 10個
                APP_SUBTITLE = APP_SUBTITLE,
                APP_MTEL = APP_MTEL,
                APP_EMAIL,
                APPNAME_2 = APPNAME_2,
                APP_SUBTITLE_2 = APP_SUBTITLE_2,
                APP_MTEL_2 = APP_MTEL_2,
                APP_EMAIL_2 = APP_EMAIL_2,
                REGISTER_ADDR = REGISTER_ADDR,
                CONTACT_ADDR = CONTACT_ADDR,
                APP_OTEL = APP_OTEL,                            // 20個
                APP_FTEL = APP_FTEL,
                INVOICENAME = INVOICENAME,
                Inads = Inads,
                HardWare = HardWare,
                SoftwareLoad = SoftwareLoad,
                Mail_Type = Mail_Type,
                OE_Number = OE_Number,
                SalseAgent = SalseAgent,
                Salse = Salse,
                Salse_TEL = Salse_TEL,                             // 30個
                SID = SID,
                Serial_Number = Serial_Number,
                License_Host = License_Host,
                Licence_Name = Licence_Name,
                LAC = LAC,
                Our_Reference = Our_Reference,
                Your_Reference = Your_Reference,
                Auth_File_ID = Auth_File_ID,
                Telecomm_ID = Telecomm_ID,
                FL = FL,                                                        // 40 個
                Group_Name_ID = Group_Name_ID,
                SED = SED,
                SERVICEITEM = SERVICEITEM,
                Warr_Time = Warr_Time,
                Prot_Time = Prot_Time,
                Receipt_PS = Receipt_PS,
                Close_Out_PS = Close_Out_PS,
                Account_PS = Account_PS,
                Information_PS = Information_PS
            });
            //  更改不用改   SetupDate = SetupDate ,
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
/*        try
        {
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                //ROLE_ID = ROLE_ID,
                //ROLE_NAME = ROLE_NAME,
                UpDateUser = HttpContext.Current.Session["UserIDNAME"].ToString(),
                UpDateDate = DateTime.Now
            });
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }        // */
        return JsonConvert.SerializeObject(new { status = status });
    }   //  */    

    public class T_0030010009
    {
        public string PID { get; set; }
        public string BUSINESSNAME { get; set; }
        public string BUSINESSID { get; set; }
        public string ID { get; set; }
        public string BUS_CREATE_DATE { get; set; }
        public string APPNAME { get; set; }
        public string APP_SUBTITLE { get; set; }
        public string APP_MTEL { get; set; }
        public string APP_SUBTITLE_2 { get; set; }
        public string APP_EMAIL_2 { get; set; }
        public string REGISTER_ADDR { get; set; }
        public string CONTACT_ADDR { get; set; }
        public string APP_FTEL { get; set; }
        public string INVOICENAME { get; set; }
        public string Inads { get; set; }
        public string Mail_Type { get; set; }
        public string OE_Number { get; set; }
        public string SalseAgent { get; set; }
        public string Salse { get; set; }
        public string Salse_TEL { get; set; }
        public string SID { get; set; }
        public string Serial_Number { get; set; }
        public string License_Host { get; set; }
        public string Licence_Name { get; set; }
        public string LAC { get; set; }
        public string Our_Reference { get; set; }
        public string Your_Reference { get; set; }
        public string Auth_File_ID { get; set; }
        public string FL { get; set; }
        public string Group_Name_ID { get; set; }
        public string SED { get; set; }
        public string Warranty_Date { get; set; }
        public string Warr_Time { get; set; }
        public string Protect_Date { get; set; }
        public string Prot_Time { get; set; }
        public string Receipt_Date { get; set; }
        public string Receipt_PS { get; set; }
        public string Close_Out_Date { get; set; }
        public string Close_Out_PS { get; set; }
        public string Account_PS { get; set; }
        public string Information_PS { get; set; }
        public string SetupDate { get; set; }
        public string Del_Flag { get; set; }
        public string UpdateDate { get; set; }
        //0628 子公司
        public string PNumber { get; set; }
        public string Name { get; set; }
        public string Contac_ADDR { get; set; }

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
        public string Type { get; set; }
        public string Type_Value { get; set; }
        public string C_ID2 { get; set; }
        public string Agent_Company { get; set; }

        public string Title_Name { get; set; }
        public string Title_ID { get; set; }
    }
}
