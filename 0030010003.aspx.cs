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

public partial class _0030010003 : System.Web.UI.Page
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
        string Check = JASON.Check_ID("0030010003.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]       //OE商品列表
    public static string GetOEList()       //案件列表程式
    {
        string sqlstr2 = @" select * From OE_Product ";
        var a = DBTool.Query<T_0030010003>(sqlstr2, new
        {
            
        });
        var b = a.ToList().Select(p => new
        {
            OE_ID = Value(p.OE_ID),
            Product_Name = Value(p.Product_Name),
            Product_ID = Value(p.Product_ID),
            Main_Classified = Value(p.Main_Classified),
            Detail_Classified = Value(p.Detail_Classified),
            Price = Value(p.Unit_Price),
        });
        return JsonConvert.SerializeObject(b);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Delete(string OE_ID)
    {
        //Check();
        string sqlstr = @"delete OE_Product  WHERE OE_ID = @OE_ID ";
        DBTool.Query<ClassTemplate>(sqlstr, new { OE_ID = OE_ID });
        return JsonConvert.SerializeObject(new { status = "success" });
    }

/*    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetOEList2()
    {
        //Check();
        string sqlstr = @"SELECT * FROM OE_Product ";
        var a = DBTool.Query<T_0030010003>(sqlstr).ToList().Select(p => new
        {

            OE_ID = OE_ID ,
            Product_Name = Product_Name,
            Product_ID = Product_ID,
            Main_Classified = Main_Classified,
            Detail_Classified = Detail_Classified,
            Unit_Price = Unit_Price
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }   //*/

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
        string sqlstr = @"SELECT PNumber,NAME,  b.BUSINESSNAME  as SalseAgent, a.Information_PS, a.SetupDate, a.UpdateDate FROM Business_Sub as a left join BusinessData as b on a.PID=b.PID";
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
    public static string Load_Data(string OE_ID)                                                       // 新增 讀CaseData 案件資料
    {
        //Check();
        //string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        //string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string sqlstr = @"SELECT * FROM OE_Product WHERE OE_ID=@OE_ID";
        //string outputJson = "";
        var lcd = DBTool.Query<T_0030010003>(sqlstr, new { OE_ID = OE_ID }).ToList().Select(p => new
        {
            //ID = p.OE_ID,
            Product_Name = Value(p.Product_Name),
            P_ID = Value(p.Product_ID),
            Main_Classified = Value(p.Main_Classified),
            Detail_Classified = Value(p.Detail_Classified),
            Unit_Price = Value(p.Unit_Price),
            Work_List = p.Work_List,
        });

        string outputJson = JsonConvert.SerializeObject(lcd);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Main_List()
    {
        string Sqlstr = @"SELECT Main FROM OE_Type where Type = '1' ";
        var a = DBTool.Query<T_0030010003>(Sqlstr).ToList().Select(p => new
        {
            A = Value(p.Main),
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Detail_List(string Main)
    {
        string Sqlstr;
        string outputJson;
        
        if (Main == "")
        {
            Sqlstr = @"SELECT Detail FROM OE_Type where Type = '2' ";
            var a = DBTool.Query<T_0030010003>(Sqlstr).ToList().Select(p => new
            {
                A = Value(p.Detail),
            });
            outputJson = JsonConvert.SerializeObject(a);
            return outputJson;
        }
        else 
        {
            Sqlstr = @"SELECT Detail FROM OE_Type where Type = '2' and Main = @Main";
            var a = DBTool.Query<T_0030010003>(Sqlstr, new { Main = Main }).ToList().Select(p => new
            {
                A = Value(p.Detail),
            });
            outputJson = JsonConvert.SerializeObject(a);
            return outputJson;
        }        
        
        
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
    public static string Safe(int Flag, string OE_ID, string Product_Name, string P_ID, string Main_Classified,  //string BUS_CREATE_DATE,
        string Detail_Classified, string Unit_Price, string Work_List)   
    {
        Product_Name = Value(Product_Name);
        P_ID = Value(P_ID);
        Unit_Price = Value(Unit_Price);

        string status;
        string Sqlstr = "";
        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 * FROM OE_Product WHERE Product_Name=@Product_Name";
            var a = DBTool.Query<T_0030010003>(Sqlstr, new
            {       
                Product_Name = Product_Name
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有同名的商品。" });
            };
            Sqlstr = @"INSERT INTO OE_Product (Product_Name, Product_ID, Main_Classified, Detail_Classified,  Unit_Price, Work_List) " +
                " VALUES (@Product_Name, @P_ID, @Main_Classified, @Detail_Classified,  @Unit_Price, @Work_List)";
                //共50個    
            status = "new";

            a = DBTool.Query<T_0030010003>(Sqlstr, new
            {
                Product_Name = Product_Name,
                P_ID = P_ID,
                Main_Classified = Main_Classified,
                Detail_Classified = Detail_Classified,
                Unit_Price = Unit_Price,
                Work_List = Work_List,
            });
            return JsonConvert.SerializeObject(new { status = "商品新增成功。" });
        }
        else if (Flag == 1)
        {
            Sqlstr = @"SELECT TOP 1 * FROM OE_Product WHERE Product_Name=@Product_Name and OE_ID != @OE_ID ";
            var a = DBTool.Query<T_0030010003>(Sqlstr, new
            {
                OE_ID = OE_ID,
                Product_Name = Product_Name,
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有其他同名的商品。" });
            };
            Sqlstr = @"UPDATE OE_Product  SET Product_Name = @Product_Name, Product_ID = @P_ID, " +
                "Main_Classified = @Main_Classified, Detail_Classified = @Detail_Classified,  Unit_Price = @Unit_Price, Work_List = @Work_List " +
                "Where OE_ID = @OE_ID";
            status = "update";

            a = DBTool.Query<T_0030010003>(Sqlstr, new
            {
                OE_ID = OE_ID,
                Product_Name = Product_Name,
                P_ID = P_ID,
                Main_Classified = Main_Classified,
                Detail_Classified = Detail_Classified,
                Unit_Price = Unit_Price,
                Work_List = Work_List,
            });
            return JsonConvert.SerializeObject(new { status = "商品修改成功。" });
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

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Safe_Main_Detail(string Main,string Detail)
    {
        string Sqlstr = "";

        Sqlstr = @"SELECT TOP 1 * FROM OE_Type WHERE Main=@Main and Type = '1' ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Main = Main,
        });
        //if (a.Any())
        //{
        //    return JsonConvert.SerializeObject(new { status = "已有相同的主分類。" });
        //};

        Sqlstr = @"INSERT INTO OE_Type (Type, Main) " +
            " VALUES ('1', @Main)";

        a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Main = Main,
        });

        Sqlstr = @"INSERT INTO OE_Type (Type, Main,Detail) " +
            " VALUES ('2', @Main,@Detail)";

        a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Main = Main,
            Detail = Detail
        });
        return JsonConvert.SerializeObject(new { status = "主/子分類新增成功。" });
    }

    public static string Value(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
        }
        return value;
    }
    public static string Value2(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = DateTime.Parse(value).ToString("yyyy/MM/dd hh:mm");
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

    public class T_0030010003
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
        
        public string OE_ID { get; set; }
        public string Product_Name { get; set; }
        public string Product_ID { get; set; }
        public string Main_Classified { get; set; }
        public string Detail_Classified { get; set; }
        public string Unit_Price { get; set; }
        public string Work_List { get; set; }
        public string P_ID { get; set; }
        public string Main { get; set; }
        public string Detail { get; set; }
    }
}
