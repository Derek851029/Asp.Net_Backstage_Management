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
        //string sqlstr = @"SELECT PID,BUSINESSNAME,SalseAgent,Information_PS,Warr_Time,Prot_Time FROM BusinessData " +//,Eva_Flag as Flag
        string sqlstr = @"SELECT PID,BUSINESSNAME,SalseAgent,Information_PS,Warr_Time,Prot_Time, 
            Case When CycleTime='0'Then'每月'When CycleTime='1'Then'雙月'When CycleTime='2'Then'每季' 
            When CycleTime='3'Then'半年'When CycleTime='4'Then'每年'When CycleTime='5'Then'遠端維護' 
            When CycleTime='6'Then'無合約' End as CycleTime 
            FROM BusinessData 
            Where Type = '保留' ";
        var a = DBTool.Query<ClassTemplate>(sqlstr).ToList().Select(p => new
        {
            //SYSID = p.SYSID,            
            BUSINESSNAME = p.BUSINESSNAME,
            SalseAgent = p.SalseAgent,
            Information_PS = p.Information_PS,
            PID = p.PID,
            Warr_Time = Value3(p.Warr_Time),
            Prot_Time = Value3(p.Prot_Time),
            CycleTime = Value(p.CycleTime),
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Delete(string PID)
    {
        //Check();
        //string sqlstr = @"delete BusinessData  WHERE PID = @PID ";
        string sqlstr = @"update BusinessData set Type = '刪除' WHERE PID = @PID ";
        DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID });
        return JsonConvert.SerializeObject(new { status = "success" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string URL(string PID)
    {
        //Check();
        //PID = PID.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(PID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error + "_1" });
        }

 //       if (PID.Length > 16 || PID.Length < 1)        {
 //           return JsonConvert.SerializeObject(new { status = error + "_2" });        }

 /*       if (PID != "0")
        {
            string sqlstr = @"SELECT TOP 1 PID FROM [DimaxCallcenter].[dbo].[BusinessData] WHERE PID=@PID ";
            var a = DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID });

            if (!a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "查無【" + PID + "】此編號客戶。", type = "no" });
            };
        };  //*/
        string str_url = "../0060010000.aspx?seqno=" + PID;         //打開0060010000 並放入同PID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]       //子公司列表
    public static string GetSubsidiaryList()
    {
        //Check();
        //string sqlstr = @"SELECT PNumber,NAME, a.PID + b.BUSINESSNAME  as SalseAgent,a.Information_PS,a.SetupDate,a.UpdateDate FROM Business_Sub as a left join BusinessData as b on a.PID=b.PID";
        string sqlstr = @"SELECT PNumber,NAME,  b.BUSINESSNAME  as SalseAgent, a.Information_PS, a.SetupDate, a.UpdateDate FROM Business_Sub as a left join BusinessData as b on a.PID=b.PID where Type ='保留' ";
        //string sqlstr = @"SELECT PNumber,NAME,SalseAgent,Information_PS,SetupDate,UpdateDate FROM Business_Sub "; // +
            //" where PID = @PID";
        var a = DBTool.Query<ClassTemplate>(sqlstr, new {}).ToList().Select(p => new
        {
            //SYSID = p.SYSID,            
            PNumber = p.PNumber,
            SalseAgent = p.SalseAgent,
            BUSINESSNAME = p.Name,
            Information_PS = p.Information_PS,
            SetupDate = Value2(p.SetupDate),
            UpdateDate = Value2(p.UpdateDate)
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
        string sqlstr = @"SELECT *, CycleTime as time1, Saturday_Work as Flag_1, Sunday_Work as Flag_2 FROM BusinessData WHERE PID=@PID";
        //string outputJson = "";
        var lcd = DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID }).ToList().Select(p => new
        {
            PID = PID,
            BUSINESSNAME = p.BUSINESSNAME,
            BUSINESSID = p.BUSINESSID,
            ID = p.ID,
            //BUS_CREATE_DATE = Value2(p.BUS_CREATE_DATE),
            APPNAME = p.APPNAME,                                //APP_SUBTITLE = p.APP_SUBTITLE,
            APP_MTEL = p.APP_MTEL,                              APP_EMAIL = p.APP_EMAIL,
            APPNAME_2 = p.APPNAME_2,                        //APP_SUBTITLE_2 = p.APP_SUBTITLE_2,
            APP_MTEL_2 = p.APP_MTEL_2,                      APP_EMAIL_2 = p.APP_EMAIL_2,
            REGISTER_ADDR = p.REGISTER_ADDR,
            Card_Name = p.Card_Name,
            Card_Base64 = p.Card_Base64,
            CycleTime = p.time1,
            CONTACT_ADDR = p.CONTACT_ADDR,
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
            Warr_Time = Value3(p.Warr_Time),
            Protect_Date = Value2(p.Protect_Date),
            Prot_Time = Value3(p.Prot_Time),
            Receipt_Date = Value2(p.Receipt_Date),                  Receipt_PS = p.Receipt_PS,
            Close_Out_Date = Value2(p.Close_Out_Date),        Close_Out_PS = p.Close_Out_PS,
            Account_PS = p.Account_PS,                       Information_PS = p.Information_PS,
            SetupDate = Value2(p.SetupDate),
            Check_Saturday = Re_Checkbox(p.Flag_1),
            Check_Sunday = Re_Checkbox(p.Flag_2)
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

    //============= 建新資料用=============    
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Safe(int Flag,  string BUSINESSNAME, string BUSINESSID, string ID, string APPNAME, 
        string APP_MTEL, string APP_EMAIL, string APPNAME_2, string APP_MTEL_2, string APP_EMAIL_2,  
        string REGISTER_ADDR, string CONTACT_ADDR, string CycleTime, string APP_OTEL, string APP_FTEL, 
        string INVOICENAME, string Inads, string HardWare, string SoftwareLoad, string Mail_Type, 
        string SalseAgent, string Salse, string Salse_TEL, string SID, string Serial_Number, 
        string License_Host, string LAC, string Telecomm_ID, string FL, string Group_Name_ID, 
        string SERVICEITEM, string Warranty_Date, string Warr_Time, string Protect_Date, string Prot_Time, 
        string Close_Out_Date, string Close_Out_PS, string Account_PS, string Information_PS, string UpDateDate,
        string SetupDate, string C_Saturday, string C_Sunday,string Card_Name, string Card_Base64)   // 11.3 string Receipt_Date, string Receipt_PS, //string APP_SUBTITLE_2, string OE_Number, 
         //string BUS_CREATE_DATE, string APP_SUBTITLE, string Licence_Name,  string Our_Reference, string Your_Reference, string Auth_File_ID, string SED,             
    {       
        string status;
        string Sqlstr = "";
        DateTime Date;
        if (!String.IsNullOrEmpty(Warranty_Date))
        {
            if (!DateTime.TryParse(Warranty_Date, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "保固開始日 日期錯誤" });
            }
        }
        if (!String.IsNullOrEmpty(Warr_Time))
        {
            if (!DateTime.TryParse(Warr_Time, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "保固終止日 日期錯誤" });
            }
        }
        if (!String.IsNullOrEmpty(Protect_Date))
        {
            if (!DateTime.TryParse(Protect_Date, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "維護開始日 日期錯誤" });
            }
        }
        if (!String.IsNullOrEmpty(Prot_Time))
        {
            if (!DateTime.TryParse(Prot_Time, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "維護終止日 日期錯誤" });
            }
        }
        if (!String.IsNullOrEmpty(Close_Out_Date))
        {
            if (!DateTime.TryParse(Close_Out_Date, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "結案日期 日期錯誤" });
            }
        }

        if (!String.IsNullOrEmpty(BUSINESSNAME))
        {
            if (BUSINESSNAME.Length > 50)
                return JsonConvert.SerializeObject(new { status = "【客戶名稱】不能超過５０個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【客戶名稱】" });
        if (!String.IsNullOrEmpty(ID))
        {
            if (ID.Length > 8)
                return JsonConvert.SerializeObject(new { status = "【統一編號】不能超過８個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【統一編號】" });

        if (!String.IsNullOrEmpty(APPNAME))
        {
            if (APPNAME.Length > 50)
                return JsonConvert.SerializeObject(new { status = "【聯絡人1】不能超過５０個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【聯絡人1】" });

        if (!String.IsNullOrEmpty(APP_MTEL))
        {
            if (APP_MTEL.Length > 50)
                return JsonConvert.SerializeObject(new { status = "【行動電話1】不能超過５０個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【行動電話1】" });
        if (!String.IsNullOrEmpty(REGISTER_ADDR))
        {
            if (REGISTER_ADDR.Length > 200)
                return JsonConvert.SerializeObject(new { status = "【裝機地址】不能超過２００個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【裝機地址】" });

        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 * FROM BusinessData WHERE BUSINESSNAME=@BUSINESSNAME and ID = @ID and Type = '保留' ";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                ID = ID,                
                BUSINESSNAME = BUSINESSNAME
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有相同的客戶名稱與統編。" });
            };
            Sqlstr = @"INSERT INTO BusinessData (BUSINESSNAME, BUSINESSID, ID,  APPNAME, APP_MTEL, APP_EMAIL, APPNAME_2,  " +    //BUS_CREATE_DATE, APP_SUBTITLE, APP_SUBTITLE_2,
                " APP_MTEL_2, APP_EMAIL_2, REGISTER_ADDR, CycleTime, CONTACT_ADDR , APP_OTEL, APP_FTEL , INVOICENAME, Inads, HardWare, SoftwareLoad, " +
                " Mail_Type, SalseAgent, Salse, Salse_TEL, SID, Serial_Number, License_Host, LAC,  " +//Licence_Name, OE_Number, 
                " Telecomm_ID, FL, Group_Name_ID, SERVICEITEM,   " +//Our_Reference, Your_Reference, Auth_File_ID,SED, Warr_Time,  Prot_Time, 
                " Close_Out_PS, Account_PS, Information_PS, UpDateDate, SetupDate, Saturday_Work, Sunday_Work,Card_Name,Card_Base64) " +
                " VALUES (@BUSINESSNAME, @BUSINESSID, @ID,  @APPNAME, @APP_MTEL, @APP_EMAIL, @APPNAME_2, " +  //@BUS_CREATE_DATE,@APP_SUBTITLE, @APP_SUBTITLE_2 , 
                " @APP_MTEL_2, @APP_EMAIL_2, @REGISTER_ADDR, @CycleTime, @CONTACT_ADDR , @APP_OTEL, @APP_FTEL , @INVOICENAME, @Inads, @HardWare, @SoftwareLoad, " +
                " @Mail_Type, @SalseAgent, @Salse, @Salse_TEL, @SID, @Serial_Number, @License_Host, @LAC,  " +//@Licence_Name, @OE_Number, 
                " @Telecomm_ID, @FL, @Group_Name_ID, @SERVICEITEM, " +//@Our_Reference, @Your_Reference, @Auth_File_ID, @SED, 
                " @Close_Out_PS, @Account_PS, @Information_PS, @UpDateDate, @SetupDate, @C_Saturday, @C_Sunday,@Card_Name,@Card_Base64)";   //@Warr_Time, @Prot_Time, 
                //共50個    
            status = "new";

            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                BUSINESSNAME = BUSINESSNAME,
                BUSINESSID = BUSINESSID,
                ID = ID,
                //BUS_CREATE_DATE = BUS_CREATE_DATE,               
                APPNAME = APPNAME,
                //APP_SUBTITLE = APP_SUBTITLE,
                APP_MTEL = APP_MTEL,
                APP_EMAIL,
                APPNAME_2 = APPNAME_2,
                //APP_SUBTITLE_2 = APP_SUBTITLE_2,        //第10
                APP_MTEL_2 = APP_MTEL_2,
                APP_EMAIL_2 = APP_EMAIL_2,
                Card_Name = Card_Name,
                Card_Base64= Card_Base64,
                REGISTER_ADDR = REGISTER_ADDR,
                CycleTime = CycleTime,
                CONTACT_ADDR = CONTACT_ADDR,
                APP_OTEL = APP_OTEL,
                APP_FTEL = APP_FTEL,
                INVOICENAME = INVOICENAME,
                Inads = Inads,
                HardWare = HardWare,
                SoftwareLoad = SoftwareLoad,        //第20
                Mail_Type = Mail_Type,
                //OE_Number = OE_Number,
                SalseAgent = SalseAgent,
                Salse = Salse,
                Salse_TEL = Salse_TEL,
                SID = SID,
                Serial_Number = Serial_Number,
                License_Host = License_Host,
                //Licence_Name = Licence_Name,
                LAC = LAC,          //第30
                //Our_Reference = Our_Reference,
                //Your_Reference = Your_Reference,
                //Auth_File_ID = Auth_File_ID,SED = SED,
                Telecomm_ID = Telecomm_ID,
                FL = FL,
                Group_Name_ID = Group_Name_ID,                
                SERVICEITEM = SERVICEITEM,
                Warranty_Date = Test(Warranty_Date),
                Warr_Time = Warr_Time,          //第40
                Protect_Date = Test(Protect_Date),
                Prot_Time = Test(Prot_Time),
                //Receipt_Date = Test(Receipt_Date),
                //Receipt_PS = Receipt_PS,
                Close_Out_Date = Close_Out_Date,
                Close_Out_PS = Close_Out_PS,
                Account_PS = Account_PS,
                Information_PS = Information_PS,
                UpDateDate = Test(UpDateDate),
                SetupDate = Test(SetupDate),
                C_Saturday = Checkbox(C_Saturday),
                C_Sunday = Checkbox(C_Sunday),
            });
            int NewYear = DateTime.Now.AddMonths(3).Year;
            int NewMonth = DateTime.Now.AddMonths(3).Month;
            DateTime CheckDate = new DateTime(NewYear, NewMonth, 1);

            if (!string.IsNullOrEmpty(Warranty_Date.Trim()))   // 保固起始 非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Warranty_Date = @Warranty_Date " +
                    "WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate),
                    Warranty_Date = Test(Warranty_Date),
                });
            }
            else
            {
                Sqlstr = @"UPDATE BusinessData SET Warranty_Date = null " +
                        "WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate)
                });
            }

            if (!string.IsNullOrEmpty(Warr_Time.Trim()))   // 保固終止 非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Warr_Time = @Warr_Time " +
                    "";    //WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate
                if (Convert.ToDateTime(Warr_Time) < CheckDate)//
                {
                    Sqlstr += " ,Warr_Mail='1' ";
                }
                else
                    Sqlstr += " ,Warr_Mail='0' ";
                Sqlstr += " WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate),
                    Warr_Time = Test(Warr_Time),
                });
            }
            else
            {
                Sqlstr = @"UPDATE BusinessData SET Warr_Time = null, Warr_Mail = null " +
                        "WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate)
                });
            }
            if (!string.IsNullOrEmpty(Protect_Date.Trim()))   // 維護起始 非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Protect_Date = @Protect_Date " +
                    "WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate),
                    Protect_Date = Test(Protect_Date),
                });
            }
            else {
                Sqlstr = @"UPDATE BusinessData SET Protect_Date = null " +
                        "WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate)
                });
            }
            if (!string.IsNullOrEmpty(Prot_Time.Trim()))   // 維護終止 非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Prot_Time = @Prot_Time " +
                    "";    //WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate
                if (Convert.ToDateTime(Prot_Time) < CheckDate)//
                {
                    Sqlstr += " ,Prot_Mail='1' ";
                }
                else
                    Sqlstr += " ,Prot_Mail='0' ";
                Sqlstr += " WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate ";                
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate),
                    Prot_Time = Test(Prot_Time),
                });
            }
            else
            {
                Sqlstr = @"UPDATE BusinessData SET Prot_Time = null, Prot_Mail = null " +
                        "WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate)
                });
            }
            if (!string.IsNullOrEmpty(Close_Out_Date.Trim()))   // 結案日 非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Close_Out_Date=@Close_Out_Date  " +
                    " WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate),
                    Close_Out_Date  = Test(Close_Out_Date ),
                });
            }
            else
            {
                Sqlstr = @"UPDATE BusinessData SET Close_Out_Date = null " +
                        "WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate)
                });
            }

            //return JsonConvert.SerializeObject(new { status = "檢查中" });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝01。" });
        }
        return JsonConvert.SerializeObject(new { status = status });        // */
    }

    //============= 修改客戶資料 (Flag = 1)=============    
    
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New(int Flag, string PID, string BUSINESSNAME, string BUSINESSID, string ID, 
        string APPNAME, string APP_MTEL, string APP_EMAIL, string APPNAME_2, string APP_MTEL_2, 
        string APP_EMAIL_2, string REGISTER_ADDR, string CycleTime, string CONTACT_ADDR, string APP_OTEL, 
        string APP_FTEL, string INVOICENAME, string Inads, string HardWare, string SoftwareLoad, 
        string Mail_Type, string SalseAgent, string Salse, string Salse_TEL, string SID, 
        string Serial_Number, string License_Host, string LAC, string Telecomm_ID, string FL, 
        string Group_Name_ID, string SERVICEITEM, string Warranty_Date, string Warr_Time, string Protect_Date, 
        string Prot_Time, string Close_Out_Date, string Close_Out_PS, string Account_PS, string Information_PS,
        string UpDateDate, string C_Saturday, string C_Sunday,string Card_Base64,string Card_Name
        // string APP_SUBTITLE, string Licence_Name, string BUS_CREATE_DATE, string Our_Reference, string Your_Reference, string Auth_File_ID, 
        // string APP_SUBTITLE_2, string OE_Number, string Receipt_Date, string Receipt_PS, string SED, DateTime SetupDate,
        )   //共41個  
    {
        DateTime Date;
        if (!String.IsNullOrEmpty(Warranty_Date))
        {
            if (!DateTime.TryParse(Warranty_Date, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "保固開始日 日期錯誤" });
            }
        }
        if (!String.IsNullOrEmpty(Warr_Time))
        {
            if (!DateTime.TryParse(Warr_Time, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "保固終止日 日期錯誤" });
            }
        }
        if (!String.IsNullOrEmpty(Protect_Date))
        {
            if (!DateTime.TryParse(Protect_Date, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "維護開始日 日期錯誤" });
            }
        }
        if (!String.IsNullOrEmpty(Prot_Time))
        {
            if (!DateTime.TryParse(Prot_Time, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "維護終止日 日期錯誤" });
            }
        }
        if (!String.IsNullOrEmpty(Close_Out_Date))
        {
            if (!DateTime.TryParse(Close_Out_Date, out Date))
            {
                return JsonConvert.SerializeObject(new { status = "結案日期 日期錯誤" });
            }
        }
        if (!String.IsNullOrEmpty(BUSINESSNAME))
        {
            if (BUSINESSNAME.Length > 50)
                return JsonConvert.SerializeObject(new { status = "【客戶名稱】不能超過５０個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【客戶名稱】" });
        if (!String.IsNullOrEmpty(ID))
        {
            if (ID.Length > 8)
                return JsonConvert.SerializeObject(new { status = "【統一編號】不能超過８個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【統一編號】" });

        if (!String.IsNullOrEmpty(APPNAME))
        {
            if (APPNAME.Length > 50)
                return JsonConvert.SerializeObject(new { status = "【聯絡人1】不能超過５０個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【聯絡人1】" });

        if (!String.IsNullOrEmpty(APP_MTEL))
        {
            if (APP_MTEL.Length > 50)
                return JsonConvert.SerializeObject(new { status = "【行動電話1】不能超過５０個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【行動電話1】" });
        if (!String.IsNullOrEmpty(REGISTER_ADDR))
        {
            if (REGISTER_ADDR.Length > 200)
                return JsonConvert.SerializeObject(new { status = "【裝機地址】不能超過２００個字元。" });
        }
        else
            return JsonConvert.SerializeObject(new { status = "請填寫【裝機地址】" });
        //Check();
        //return BUSINESSNAME;
        PID = PID.Trim();
        string status;
        string Sqlstr = "";
        if (Flag == 1)
        {
            Sqlstr = @"SELECT PID FROM BusinessData WHERE BUSINESSNAME=@BUSINESSNAME and ID=@ID and PID !=@PID and Type = '保留' ";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            { BUSINESSNAME = BUSINESSNAME, ID = ID, PID = PID, });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有另一客戶，名稱與統編相同。" });
            };
            //Sqlstr = @"SELECT PID FROM BusinessData WHERE BUSINESSNAME!=@BUSINESSNAME and PID=@PID and Type = '保留' ";   //檢查更換名稱
            //a = DBTool.Query<ClassTemplate>(Sqlstr, new { BUSINESSNAME = BUSINESSNAME, ID = ID, PID = PID, });
            //if (a.Any())
            //{
            Sqlstr = @"UPDATE InSpecation_Dimax.dbo.Mission_Title SET mission_name=@BUSINESSNAME, T_ID=@Telecomm_ID" +
                    " ,ADDR=@REGISTER_ADDR, Name=@APPNAME, MTEL=@APP_MTEL  where PID = @PID ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    PID = PID,
                    BUSINESSNAME = BUSINESSNAME,
                    APPNAME = APPNAME,
                    APP_MTEL = APP_MTEL,
                    REGISTER_ADDR = REGISTER_ADDR,
                    Telecomm_ID = Telecomm_ID,
                });
            //};

            Sqlstr = @"UPDATE BusinessData set  BUSINESSNAME = @BUSINESSNAME " +
                ", BUSINESSID = @BUSINESSID, ID = @ID,  APPNAME = @APPNAME, " +  //BUS_CREATE_DATE = @BUS_CREATE_DATE,
                 "APP_MTEL = @APP_MTEL, APP_EMAIL = @APP_EMAIL, APPNAME_2 = @APPNAME_2, " +  //--10   APP_SUBTITLE = @APP_SUBTITLE,  APP_SUBTITLE_2 = @APP_SUBTITLE_2,
                 "APP_MTEL_2 = @APP_MTEL_2, APP_EMAIL_2 = @APP_EMAIL_2, REGISTER_ADDR = @REGISTER_ADDR, CycleTime = @CycleTime, CONTACT_ADDR = @CONTACT_ADDR, APP_OTEL = @APP_OTEL, " +
                 "APP_FTEL = @APP_FTEL, INVOICENAME = @INVOICENAME, Inads = @Inads, HardWare = @HardWare, SoftwareLoad = @SoftwareLoad, " + //--20
                 "Mail_Type = @Mail_Type, SalseAgent = @SalseAgent, Salse = @Salse, Salse_TEL = @Salse_TEL, " +
                 "SID = @SID, Serial_Number = @Serial_Number, License_Host = @License_Host, LAC = @LAC, " +  //--30OE_Number = @OE_Number, Licence_Name = @Licence_Name, 
                 "Telecomm_ID = @Telecomm_ID, FL = @FL, " +//Our_Reference = @Our_Reference, Your_Reference = @Your_Reference, Auth_File_ID = @Auth_File_ID, 
                 "Group_Name_ID = @Group_Name_ID, SERVICEITEM = @SERVICEITEM, " + //--40    SED = @SED, 
                 "Saturday_Work = @C_Saturday, Sunday_Work = @C_Sunday, " +
                 "Close_Out_PS = @Close_Out_PS, Account_PS = @Account_PS, Information_PS = @Information_PS, UpDateDate = @UpDateDate,Card_Base64 = @Card_Base64,Card_Name = @Card_Name " + //, SetupDate = @SetupDate
                 "Where PID = @PID ";
            status = "update";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                PID = PID,
                BUSINESSNAME = BUSINESSNAME,
                BUSINESSID = BUSINESSID,
                ID = ID,
                //Warranty_Date = Test(Warranty_Date),
                //BUS_CREATE_DATE = BUS_CREATE_DATE,
                Protect_Date = Test(Protect_Date),
                Close_Out_Date = Close_Out_Date,
                UpDateDate = UpDateDate,
                Card_Name = Card_Name,
                Card_Base64 = Card_Base64,
                APPNAME = APPNAME,                              // 10個
                APP_MTEL = APP_MTEL,
                //APP_SUBTITLE = APP_SUBTITLE,
                APP_EMAIL,
                APPNAME_2 = APPNAME_2,
                APP_MTEL_2 = APP_MTEL_2,
                APP_EMAIL_2 = APP_EMAIL_2,
                REGISTER_ADDR = REGISTER_ADDR,
                //Receipt_Date = Test(Receipt_Date),
                CycleTime = CycleTime,
                CONTACT_ADDR = CONTACT_ADDR,
                APP_OTEL = APP_OTEL,                            // 20個
                APP_FTEL = APP_FTEL,
                INVOICENAME = INVOICENAME,
                //APP_SUBTITLE_2 = APP_SUBTITLE_2,
                Inads = Inads,
                HardWare = HardWare,
                SoftwareLoad = SoftwareLoad,
                Mail_Type = Mail_Type,
                SalseAgent = SalseAgent,
                //OE_Number = OE_Number,
                Salse = Salse,
                Salse_TEL = Salse_TEL,                             // 30個
                SID = SID,
                Serial_Number = Serial_Number,
                License_Host = License_Host,
                //Licence_Name = Licence_Name,
                LAC = LAC,
                Telecomm_ID = Telecomm_ID,
                FL = FL,                                                        // 40 個
                Group_Name_ID = Group_Name_ID,
                SERVICEITEM = SERVICEITEM,
                //Our_Reference = Our_Reference,
                //Warr_Time = Warr_Time,
                //Prot_Time = Prot_Time,
                Close_Out_PS = Close_Out_PS,
                Account_PS = Account_PS,
                Information_PS = Information_PS,
                //Your_Reference = Your_Reference,
                //Auth_File_ID = Auth_File_ID,
                //SED = SED,
                //Receipt_PS = Receipt_PS,
                C_Saturday = Checkbox(C_Saturday),
                C_Sunday = Checkbox(C_Sunday),
            });


            if (!string.IsNullOrEmpty(Protect_Date))   // 維護起始 非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Protect_Date = @Protect_Date " +
                    "where PID = @PID ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    PID = PID,
                    Protect_Date = Test(Protect_Date),
                });
            }
            else {
                Sqlstr = @"UPDATE BusinessData SET Protect_Date = null where PID = @PID ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new{PID = PID });
            }

            if (!string.IsNullOrEmpty(Close_Out_Date.Trim()))   // 結案日 非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Close_Out_Date  = @Close_Out_Date  " +
                    "where PID = @PID ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    PID = PID,
                    Close_Out_Date = Test(Close_Out_Date),
                });
            }
            else
            {
                Sqlstr = @"UPDATE BusinessData SET Close_Out_Date = null where PID = @PID ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new { PID = PID });
            }

            if (!string.IsNullOrEmpty(Warranty_Date.Trim()))   // 保固起始 非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Warranty_Date = @Warranty_Date " +
                    "where PID = @PID ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    PID = PID,
                    BUSINESSNAME = BUSINESSNAME,
                    Warranty_Date = Test(Warranty_Date),
                });
            }
            else
            {
                Sqlstr = @"UPDATE BusinessData SET Warranty_Date = null where PID = @PID ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new { PID = PID });
            }
            int NewYear = DateTime.Now.AddMonths(3).Year;
            int NewMonth = DateTime.Now.AddMonths(3).Month;
            DateTime CheckDate = new DateTime(NewYear, NewMonth, 1);

            if (!string.IsNullOrEmpty(Warr_Time.Trim()))   // 保固終止 非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Warr_Time = @Warr_Time " +
                    "";    //where PID = @PID 
                if (Convert.ToDateTime(Warr_Time) < CheckDate)//
                {
                    Sqlstr += " ,Warr_Mail='1' ";
                }
                else
                    Sqlstr += " ,Warr_Mail='0' ";
                Sqlstr += " where PID = @PID  ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    PID = PID,
                    BUSINESSNAME = BUSINESSNAME,
                    Warr_Time = Test(Warr_Time),
                });
            }
            else
            {
                Sqlstr = @"UPDATE BusinessData SET Warr_Time = null, Warr_Mail = null where PID = @PID ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new { PID = PID });
            }
            if (!string.IsNullOrEmpty(Prot_Time.Trim()))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Prot_Time = @Prot_Time " +
                    "";    //where PID = @PID 
                if (Convert.ToDateTime(Prot_Time) < CheckDate)//
                {
                    Sqlstr += " ,Prot_Mail='1' ";
                }
                else
                    Sqlstr += " ,Prot_Mail='0' ";
                Sqlstr += " where PID = @PID ";    
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    PID = PID,
                    BUSINESSNAME = BUSINESSNAME,
                    Prot_Time = Test(Prot_Time),
                });
            }
            else
            {
                Sqlstr = @"UPDATE BusinessData SET Prot_Time = null, Prot_Mail = null where PID = @PID ";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new { PID = PID });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }   //*/

        return JsonConvert.SerializeObject(new { status = status });
    }   //  */

    //0060010000
 
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Eva(string PID)
    {
        //string Sqlstr = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_Title] ";
        string Sqlstr = @"select * FROM [InSpecation_Dimax].[dbo].[Mission_Title] " +
            "where PID=@PID ";
        var a = DBTool.Query<T_0060010001>(Sqlstr, new { PID = PID });
        if (a.Count() > 0)
        {
            var b = a.ToList()
            .Select(p => new
            {
                SYSID = p.SYSID,
                Bus_Name = Value(p.mission_name),
                Cycle_Name = p.Cycle_Name,
                Addr = Value(p.ADDR),
                T_id = Value(p.T_ID),
                Agent_Name = p.Agent_Name,
                Flag = p.Flag
            });
            string outputJson = JsonConvert.SerializeObject(b);
            return outputJson;
        }
        else
        {
            return "[]";
        }
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Get_info(string SYS_ID)
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string Sqlstr = @"SELECT TOP 1 SYSID FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@SYSID ";
        var a = DBTool.Query<T_0060010001>(Sqlstr, new { SYSID = SYS_ID });
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
        var a = DBTool.Query<T_0060010001>(Sqlstr, new { SYSID = SYS_ID });
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
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New_Title(string PID, string T_ID, string ADDR, string Name, string MTEL, string CycleTime, string Agent, string C_Name,
        string C_1, string C_2, string C_3, string C_4, string C_5, string C_6, string C_7, string C_8, string C_9, string C_10, string C_11, string C_12 
        )  //    string PID2, 
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        int i = 0;
        Name = Value(Name);
        MTEL = Value(MTEL);
        ADDR = Value(ADDR);
        C_Name = Value(C_Name);
        //===========================================================
        //if (String.IsNullOrEmpty(PID))
        //{
        //    return JsonConvert.SerializeObject(new { status = "請選擇【客戶】", Flag = "0" });
        //}
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
                    return JsonConvert.SerializeObject(new { status = error+"1", Flag = "0" });
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
                return JsonConvert.SerializeObject(new { status = error + "2", Flag = "0" });
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
                    return JsonConvert.SerializeObject(new { status = error + "3", Flag = "0" });
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
                    return JsonConvert.SerializeObject(new { status = error + "4", Flag = "0" });
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
                    return JsonConvert.SerializeObject(new { status = error + "5", Flag = "0" });
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
                return JsonConvert.SerializeObject(new { status = error + "6", Flag = "0" });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【巡查週期】", Flag = "0" });
        }
        //===========================================================   
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
            + "FROM [DimaxCallcenter].[dbo].[DispatchSystem] WHERE Agent_ID=@Agent_ID ";    //*/
        string sqlstr = @"INSERT INTO [InSpecation_Dimax].[dbo].[Mission_Title] "
            + " ( mission_name, PID, T_ID, ADDR, Name, MTEL, Cycle, Cycle_Name, Create_ID, Create_Name , "
            + " M_1, M_2, M_3, M_4, M_5, M_6, M_7, M_8, M_9, M_10, M_11, M_12 ) "       //
            + "values(@C_Name, @PID, @T_ID, @ADDR, @Name, @MTEL, @Cycle, @CycleName, @Create_ID, @Create_Name, "
            + " @M_1, @M_2, @M_3, @M_4, @M_5, @M_6, @M_7, @M_8, @M_9, @M_10, @M_11, @M_12)";
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
                return JsonConvert.SerializeObject(new { status = "修改工程師失敗。 " + er, Flag = "1" });
            }
        }
        return JsonConvert.SerializeObject(new { status = "維護任務 新增完成。", Flag = "1" });
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
    public static string Value3(string value)        // 當值為null時跳過  非 null 時改時間格式
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = DateTime.Parse(value).ToString("yyyy/MM/dd");
        }
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
    public static string Checkbox(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (value == "True")
        {
            value = "1";
        }
        else
            value = "0";
        return value;
    }
    public static string Re_Checkbox(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (value == "1")
        {
            value = "checked";
        }
        else
            value = "";
        return value;
    }
    public class T_0060010001
    {
        public string PID { get; set; }
        public string BUSINESSNAME { get; set; }
        public string BUSINESSID { get; set; }
        public string ID { get; set; }
        public string BUS_CREATE_DATE { get; set; }
        public string APPNAME { get; set; }
        public string APP_SUBTITLE { get; set; }
        public string APP_EMAIL { get; set; }
        public string APP_MTEL { get; set; }
        public string APPNAME_2 { get; set; }
        public string APP_SUBTITLE_2 { get; set; }
        public string APP_MTEL_2 { get; set; }
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
        public string ADDR { get; set; }
        public string Contac_ADDR { get; set; }

        public string Cycle_Name { get; set; }
        public string Start_Time { get; set; }
        public string End_Time { get; set; }
        public string Agent_Name { get; set; }
        public string bit { get; set; }
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
        public string T_ID { get; set; }
        public DateTime Work_Time { get; set; }
        public DateTime Create_Date { get; set; }
    }
}
