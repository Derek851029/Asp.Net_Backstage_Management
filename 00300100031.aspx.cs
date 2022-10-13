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

public partial class _00300100031 : System.Web.UI.Page
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
        string Check = JASON.Check_ID("00300100031.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetMainList()
    {
        //Check();
        string sqlstr = @"SELECT * FROM OE_Type where  Type = '1' ";
        var a = DBTool.Query<T_00300100031>(sqlstr).ToList().Select(p => new
        {
            OE_T_ID = Value(p.OE_T_ID),
            Main = Value(p.Main),
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Delete(string OE_T_ID)
    {
        //Check();
        string sqlstr = @"delete OE_Type  WHERE OE_T_ID = @OE_T_ID ";
        DBTool.Query<ClassTemplate>(sqlstr, new { OE_T_ID = OE_T_ID });
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

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetDetailList()
    {
        //Check();
        string sqlstr = @"SELECT * FROM OE_Type where  Type = '2' ";
        var a = DBTool.Query<T_00300100031>(sqlstr).ToList().Select(p => new
        {
            OE_T_ID = Value(p.OE_T_ID),
            Main = Value(p.Main),
            Detail = Value(p.Detail),
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
    public static string Safe(int Flag, string OE_T_ID, string Main)   
    {       
        string status;
        string Sqlstr = "";
        Main = Value(Main);

        if (Main == "")
        {
            status = "請填寫主分類(頭尾的空白會自動刪除)";
            return JsonConvert.SerializeObject(new { status = status });
        }

        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 * FROM OE_Type WHERE Main=@Main and Type = '1' ";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                Main = Main,
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有相同的主分類。" });
            };
            Sqlstr = @"INSERT INTO OE_Type (Type, Main ) " +
                " VALUES ('1', @Main)";
                //共50個    
            status = "new";

            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                Main = Main,
            });

/*            if (!string.IsNullOrEmpty(Protect_Date))   // 當值為null時跳過  非 null 時 update
            {
                Sqlstr = @"UPDATE BusinessData SET Protect_Date = @Protect_Date " +
                    "WHERE BUSINESSNAME = @BUSINESSNAME and SetupDate = @SetupDate";
                a = DBTool.Query<ClassTemplate>(Sqlstr, new
                {
                    BUSINESSNAME = BUSINESSNAME,
                    SetupDate = Test(SetupDate),
                    Protect_Date = Test(Protect_Date),
                });
            }   //*/
            //return JsonConvert.SerializeObject(new { status = "檢查中" });
        }
        else if (Flag == 1)
        {
            Sqlstr = @"SELECT TOP 1 * FROM OE_Type WHERE Main=@Main and Type = '1' and OE_T_ID != @OE_T_ID ";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                OE_T_ID = OE_T_ID,
                Main = Main,
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有其他同名的主分類。" });
            };
            Sqlstr = @"Update OE_Type Set Main = @Main " +
                "where OE_T_ID = @OE_T_ID ";
            //共50個    
            status = "update";

            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                OE_T_ID = OE_T_ID,
                Main = Main,
            });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "Flag 參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
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
    public static string New(int Flag, string OE_T_ID, string Main, string Detail)
    {
        string status;
        string Sqlstr = "";
        Main = Value(Main);
        Detail = Value(Detail);

        if (Main == "")
        {
            status = "請填寫主分類(頭尾的空白會自動刪除)";
            return JsonConvert.SerializeObject(new { status = status });
        }
        else if (Detail == "")
        {
            status = "請填寫主分類(頭尾的空白會自動刪除)";
            return JsonConvert.SerializeObject(new { status = status });
        }

        Sqlstr = @"SELECT TOP 1 Main FROM OE_Type WHERE Main=@Main and Type = '1' ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new
        {
            Main = Main
        });
        if (!a.Any())
        {
            return JsonConvert.SerializeObject(new { status = "查無該主分類。" });
        };

        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 * FROM OE_Type WHERE Main=@Main and Detail=@Detail and Type = '2' ";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                Main = Main,
                Detail = Detail,
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "該主分類下已有相同的子分類。" });
            };
            Sqlstr = @"INSERT INTO OE_Type (Type, Main, Detail ) " +
                " VALUES ('2', @Main, @Detail )";
            //共50個    
            status = "new";

            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                Main = Main,
                Detail = Detail,
            });
        }
        else if (Flag == 1)
        {
            Sqlstr = @"SELECT TOP 1 * FROM OE_Type WHERE Main=@Main and Detail=@Detail and Type = '2' and OE_T_ID != @OE_T_ID ";
            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                OE_T_ID = OE_T_ID,
                Main = Main,
                Detail = Detail,
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有其他同分類下的相同子分類。" });
            };
            Sqlstr = @"Update OE_Type Set Main = @Main, Detail=@Detail " +
                "where OE_T_ID = @OE_T_ID ";
            //共50個    
            status = "update";

            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                OE_T_ID = OE_T_ID,
                Main = Main,
                Detail = Detail,
            });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "Flag 參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
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
    }   //  */

    public class T_00300100031
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
        public string PNumber { get; set; }
        public string Name { get; set; }
        public string ADDR { get; set; }
        public string Contac_ADDR { get; set; }

        public string OE_T_ID { get; set; }
        public string Main { get; set; }
        public string Detail { get; set; }
    }
}
