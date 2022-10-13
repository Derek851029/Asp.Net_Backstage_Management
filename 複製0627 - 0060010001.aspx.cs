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

public partial class _0060010001 : System.Web.UI.Page
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
        string Check = JASON.Check_ID("0060010001.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetPartnerList()
    {
        //Check();
        string sqlstr = @"SELECT PID,APP_OTEL,BUSINESSNAME,ID,SetupDate,UpdateDate FROM BusinessData ";
        var a = DBTool.Query<CMS_0060010000>(sqlstr).ToList().Select(p => new
        {
            SYSID = p.SYSID,
            //BUSINESSID = p.BUSINESSID,
            APP_OTEL = p.APP_OTEL,
            BUSINESSNAME = p.BUSINESSNAME,
            ID = p.ID,
            PID = p.PID,
            SetupDate = p.SetupDate,
            UpdateDate = p.UpdateDate
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
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
            BUSINESSNAME = p.BUSINESSNAME,          BUSINESSID = p.BUSINESSID,
            ID = p.ID,                                                            BUS_CREATE_DATE = p.BUS_CREATE_DATE,
            APPNAME = p.APPNAME,                                APP_SUBTITLE = p.APP_SUBTITLE,
            APP_MTEL = p.APP_MTEL,                              APP_EMAIL = p.APP_EMAIL,
            APPNAME_2 = p.APPNAME_2,                        APP_SUBTITLE_2 = p.APP_SUBTITLE_2,
            APP_MTEL_2 = p.APP_MTEL_2,                      APP_EMAIL_2 = p.APP_EMAIL_2,
            REGISTER_ADDR = p.REGISTER_ADDR,        CONTACT_ADDR = p.CONTACT_ADDR,
            APP_OTEL = p.APP_OTEL,                              APP_FTEL = p.APP_FTEL,
            INVOICENAME = p.INVOICENAME,            Inads = p.Inads,
            HardWare = p.HardWare,                              SoftwareLoad = p.SoftwareLoad,
            Mail_Type = p.Mail_Type,                            OE_Number = p.OE_Number,
            SalseAgent = p.SalseAgent,                          Salse = p.Salse,
            Salse_TEL = p.Salse_TEL,                                SID = p.SID,
            Serial_Number = p.Serial_Number,            License_Host = p.License_Host,
            Licence_Name = p.Licence_Name,              LAC = p.LAC,
            Our_Reference = p.Our_Reference,            Your_Reference = p.Your_Reference,
            Auth_File_ID = p.Auth_File_ID,                    Telecomm_ID = p.Telecomm_ID,
            FL = p.FL,                                                         Group_Name_ID = p.Group_Name_ID,
            SED = p.SED,                                                    SERVICEITEM = p.SERVICEITEM,
            Warranty_Date = p.Warranty_Date,            Warr_Time = p.Warr_Time,
            Protect_Date = p.Protect_Date,                  Prot_Time = p.Prot_Time,
            Receipt_Date = p.Receipt_Date,                  Receipt_PS = p.Receipt_PS,
            Close_Out_Date = p.Close_Out_Date,        Close_Out_PS = p.Close_Out_PS,
            Account_PS = p.Account_PS,                       Information_PS = p.Information_PS,
            SetupDate = p.SetupDate                           
            // 共讀取 49 個

            //H = p.HardWare.Trim(),      // 硬體   .Trim() 去除資料後方多餘的空白
        });

        string outputJson = JsonConvert.SerializeObject(lcd);
        return outputJson;
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

    //============= 新增【使用者權限】=============
    
    
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New(int Flag,  DateTime BUS_CREATE_DATE, DateTime Warranty_Date, DateTime Protect_Date, DateTime Receipt_Date,  //time04
        DateTime Close_Out_Date, DateTime SetupDate, DateTime LoginTime, string BUSINESSNAME, string ID, string BUSINESSID, //10
        string APPNAME, string APP_SUBTITLE, string APP_MTEL, string APP_EMAIL, //text4 14
        string APPNAME_2, string APP_SUBTITLE_2, string APP_MTEL_2, string APP_EMAIL_2, string REGISTER_ADDR, string CONTACT_ADDR, //text10 20
        string APP_OTEL, string APP_FTEL, string INVOICENAME, string Inads, string HardWare, string SoftwareLoad, string Mail_Type, //text17    27
        string OE_Number, string SalseAgent, string Salse, string Salse_TEL, string SID, string Serial_Number, string License_Host, string Licence_Name, //text25   35
        string LAC, string Our_Reference, string Your_Reference, string Auth_File_ID, string Telecomm_ID, string FL, string Group_Name_ID, //text32 42
        string SED, string SERVICEITEM, string Warr_Time, string Prot_Time, string Receipt_PS, string Close_Out_PS, string Account_PS, string Information_PS)   //50
    {
        //Check();
        //return BUSINESSNAME;

        string status;
        string Sqlstr = "";
        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 PID FROM BusinessData WHERE PID=@PID";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new { BUS_CREATE_DATE = BUS_CREATE_DATE ,  Warranty_Date = Warranty_Date ,  Protect_Date = Protect_Date ,  
                Receipt_Date = Receipt_Date ,  Close_Out_Date = Close_Out_Date ,  SetupDate = SetupDate ,  LoginTime = LoginTime , APPNAME = APPNAME , 
                APP_SUBTITLE = APP_SUBTITLE , APP_MTEL = APP_MTEL , APP_EMAIL, APPNAME_2 = APPNAME_2 , APP_SUBTITLE_2 = APP_SUBTITLE_2 , APP_MTEL_2 = APP_MTEL_2 , 
                APP_EMAIL_2 = APP_EMAIL_2 , REGISTER_ADDR = REGISTER_ADDR , CONTACT_ADDR = CONTACT_ADDR , APP_OTEL = APP_OTEL , APP_FTEL = APP_FTEL , 
                INVOICENAME = INVOICENAME , Inads = Inads , HardWare = HardWare , SoftwareLoad = SoftwareLoad , Mail_Type = Mail_Type, OE_Number=OE_Number, 
                SalseAgent = SalseAgent , Salse = Salse , Salse_TEL = Salse_TEL , SID = SID , Serial_Number = Serial_Number , License_Host = License_Host , 
                Licence_Name = Licence_Name, LAC = LAC , Our_Reference = Our_Reference , Your_Reference = Your_Reference , Auth_File_ID = Auth_File_ID , 
                Telecomm_ID = Telecomm_ID , FL = FL , Group_Name_ID = Group_Name_ID, SED = SED , SERVICEITEM = SERVICEITEM , Warr_Time = Warr_Time , 
                Prot_Time = Prot_Time , Receipt_PS = Receipt_PS , Close_Out_PS = Close_Out_PS , Account_PS = Account_PS , Information_PS =Information_PS });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有相同的【權限代碼】或【權限名稱】。" });
            };

            Sqlstr = @"INSERT INTO ROLELIST (BUSINESSNAME, BUSINESSID, ID, BUS_CREATE_DATE, APPNAME, APP_SUBTITLE, APP_MTEL, APP_EMAIL, APPNAME_2, " +                                   
                " APP_SUBTITLE_2 , APP_MTEL_2, APP_EMAIL_2, REGISTER_ADDR, CONTACT_ADDR , APP_OTEL, APP_FTEL , INVOICENAME, Inads, HardWare, SoftwareLoad, " + 
                " Mail_Type, OE_Number, SalseAgent, Salse, Salse_TEL, SID, Serial_Number, License_Host, Licence_Name, LAC, Our_Reference, Your_Reference, Auth_File_ID, " + 
                " Telecomm_ID, FL, Group_Name_ID, SED, SERVICEITEM,  Warranty_Date, Warr_Time, Protect_Date, Prot_Time, Receipt_Date, Receipt_PS, Close_Out_Date,  " +                    
                " Close_Out_PS, Account_PS, Information_PS, UpDateDate, SetupDate)      VALUES (@BUSINESSNAME, @BUSINESSID, @ID, @BUS_CREATE_DATE, @APPNAME, " +        
                " @APP_SUBTITLE, @APP_MTEL, @APP_EMAIL, @APPNAME_2, @APP_SUBTITLE_2 , @APP_MTEL_2, @APP_EMAIL_2, @REGISTER_ADDR, @CONTACT_ADDR , " +   
                " @APP_OTEL, @APP_FTEL , @INVOICENAME, @Inads, @HardWare, @SoftwareLoad,  @Mail_Type, @OE_Number, @SalseAgent, @Salse, @Salse_TEL,  " + 
                " @ SID, @ Serial_Number, @ License_Host, @ Licence_Name, @ LAC, @ Our_Reference, @ Your_Reference, @ Auth_File_ID, @Telecomm_ID, @ FL, " +                    
                " @ Group_Name_ID, @ SED, @ SERVICEITEM, @  Warranty_Date, @ Warr_Time, @ Protect_Date, @ Prot_Time, @ Receipt_Date, @ Receipt_PS, " +         
                " @ Close_Out_Date, @  Close_Out_PS, @ Account_PS, @ Information_PS, @ UpDateDate, @ SetupDate)";                
            status = "new";
        }
        else if (Flag == 1)
        {
            Sqlstr = @"SELECT TOP 1 PID FROM BusinessData WHERE PID=@PID";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new {  BUS_CREATE_DATE = BUS_CREATE_DATE ,  Warranty_Date = Warranty_Date ,  Protect_Date = Protect_Date ,  
                Receipt_Date = Receipt_Date ,  Close_Out_Date = Close_Out_Date ,    LoginTime = LoginTime , APPNAME = APPNAME , 
                APP_SUBTITLE = APP_SUBTITLE , APP_MTEL = APP_MTEL , APP_EMAIL, APPNAME_2 = APPNAME_2 , APP_SUBTITLE_2 = APP_SUBTITLE_2 , APP_MTEL_2 = APP_MTEL_2 , 
                APP_EMAIL_2 = APP_EMAIL_2 , REGISTER_ADDR = REGISTER_ADDR , CONTACT_ADDR = CONTACT_ADDR , APP_OTEL = APP_OTEL , APP_FTEL = APP_FTEL , 
                INVOICENAME = INVOICENAME , Inads = Inads , HardWare = HardWare , SoftwareLoad = SoftwareLoad , Mail_Type = Mail_Type, OE_Number=OE_Number, 
                SalseAgent = SalseAgent , Salse = Salse , Salse_TEL = Salse_TEL , SID = SID , Serial_Number = Serial_Number , License_Host = License_Host , 
                Licence_Name = Licence_Name, LAC = LAC , Our_Reference = Our_Reference , Your_Reference = Your_Reference , Auth_File_ID = Auth_File_ID , 
                Telecomm_ID = Telecomm_ID , FL = FL , Group_Name_ID = Group_Name_ID, SED = SED , SERVICEITEM = SERVICEITEM , Warr_Time = Warr_Time , 
                Prot_Time = Prot_Time , Receipt_PS = Receipt_PS , Close_Out_PS = Close_Out_PS , Account_PS = Account_PS , Information_PS =Information_PS });
            //  更改不用改   SetupDate = SetupDate ,
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有相同的【權限名稱】。" });
            };

            //Sqlstr = @"UPDATE ROLELIST SET ROLE_NAME=@ROLE_NAME, UpDateUser=@UpDateUser, " +
           //"UpDateDate=@UpDateDate WHERE ROLE_ID=@ROLE_ID";
            Sqlstr = @"UPDATE ROLELIST SET (BUSINESSNAME, BUSINESSID, ID, BUS_CREATE_DATE, APPNAME, APP_SUBTITLE, APP_MTEL, APP_EMAIL, APPNAME_2, " +                                   
                " APP_SUBTITLE_2 , APP_MTEL_2, APP_EMAIL_2, REGISTER_ADDR, CONTACT_ADDR , APP_OTEL, APP_FTEL , INVOICENAME, Inads, HardWare, SoftwareLoad, " + 
                " Mail_Type, OE_Number, SalseAgent, Salse, Salse_TEL, SID, Serial_Number, License_Host, Licence_Name, LAC, Our_Reference, Your_Reference, Auth_File_ID, " + 
                " Telecomm_ID, FL, Group_Name_ID, SED, SERVICEITEM,  Warranty_Date, Warr_Time, Protect_Date, Prot_Time, Receipt_Date, Receipt_PS, Close_Out_Date,  " +                    
                " Close_Out_PS, Account_PS, Information_PS, UpDateDate)      VALUES (@BUSINESSNAME, @BUSINESSID, @ID, @BUS_CREATE_DATE, @APPNAME, " +        
                " @APP_SUBTITLE, @APP_MTEL, @APP_EMAIL, @APPNAME_2, @APP_SUBTITLE_2 , @APP_MTEL_2, @APP_EMAIL_2, @REGISTER_ADDR, @CONTACT_ADDR , " +   
                " @APP_OTEL, @APP_FTEL , @INVOICENAME, @Inads, @HardWare, @SoftwareLoad,  @Mail_Type, @OE_Number, @SalseAgent, @Salse, @Salse_TEL,  " + 
                " @ SID, @ Serial_Number, @ License_Host, @ Licence_Name, @ LAC, @ Our_Reference, @ Your_Reference, @ Auth_File_ID, @Telecomm_ID, @ FL, " +                    
                " @ Group_Name_ID, @ SED, @ SERVICEITEM, @  Warranty_Date, @ Warr_Time, @ Protect_Date, @ Prot_Time, @ Receipt_Date, @ Receipt_PS, " +         
                " @ Close_Out_Date, @  Close_Out_PS, @ Account_PS, @ Information_PS, @ UpDateDate)";
            status = "update";
            //  更改不用改   , SetupDate , @ SetupDate
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }

        try
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
        }

        return JsonConvert.SerializeObject(new { status = status });        // */
    }   //  */

    /*
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_ROLELIST(string ROLE_ID)
    {
        Check();
        string Sqlstr = @"SELECT ROLE_ID, ROLE_NAME FROM ROLELIST WHERE ROLE_ID = @ROLE_ID AND OPEN_DEL = 'Y' ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { ROLE_ID = ROLE_ID }).ToList().Select(p => new
        {
            ROLE_ID = p.Role_ID,
            ROLE_NAME = p.ROLE_NAME
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }   */
}
