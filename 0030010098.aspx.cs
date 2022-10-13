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

public partial class _0030010098 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    string sql_txt;
    protected string new_mno = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Check();
            new_mno = DateTime.Now.ToString("yyMMddHHmmssfff");
            Session["MNo"] = new_mno;
        }
    }

    //============= 帶入【服務分類】資訊 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string ServiceName_List()
    {
        Check();
        string Sqlstr = @"SELECT Service_ID, ServiceName FROM Data WHERE Open_Flag = '1' AND Service='外包商' ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            ServiceName = p.ServiceName,
            Service_ID = p.Service_ID
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //============= 驗證資料 ==============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check_Form(string Flag, string Service_ID, string Time_01, string Time_02, string LocationStart, string LocationEnd,
        string CarSeat, string ContactName, string ContactPhone2, string ContactPhone3, string Contact_Co_TEL,
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
            sql_check = @"SELECT TOP 1 SYS_ID, Service, ServiceName FROM Data WHERE Service_ID=@Service_ID AND Service = '外包商' ";
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
            return JsonConvert.SerializeObject(new { status = "【預定起始時間】不能小於【" + DateTime.Now.AddDays(-14).ToString("yyyy/MM/dd hh:mm") + "】" });
        }

        // 驗證 【預定起始時間】是否小於【預定終止時間】
        if (Convert.ToDateTime(Time_01) > Convert.ToDateTime(Time_02))
        {
            return JsonConvert.SerializeObject(new { status = "【預定起始時間】不能大於【預定終止時間】" });
        }

        //======================================================================
        string back = "";
        List<XXS> check_value = new List<XXS>();
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
        if (Service_ID == "60")
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

        sql_check = @"SELECT SYS_ID FROM MNo_Labor WHERE MNo=@MNo";
        var chk = DBTool.Query<ClassTemplate>(sql_check, new { MNo = MNo });
        if (chk.Count() > 0)
        {
            back = new_MNo(Service_ID, ServiceName, Time_01, Time_02, LocationStart, LocationEnd, CarSeat, ContactName, ContactPhone2,
                ContactPhone3, Contact_Co_TEL, Hospital, HospitalClass, Question);
            return JsonConvert.SerializeObject(new { status = back });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【雇主】或【外勞】" });
        }
    }

    //============= 新增需求單 =============
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string new_MNo(string Service_ID, string ServiceName, string Time_01, string Time_02, string LocationStart, string LocationEnd,
        string CarSeat, string ContactName, string ContactPhone2, string ContactPhone3, string Contact_Co_TEL, string Hospital, string HospitalClass,
        string Question)
    {
        Check();
        string MNo = HttpContext.Current.Session["MNo"].ToString();
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string language = "";
        string f_MNo;
        string sql_txt = "";
        string f_type = "已經結案";
        string f_value = "4";  //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
        Thread.Sleep(100);

        //============== 檢查 新增多筆勞工資訊（瀏覽） ==============
        #region
        sql_txt = @"SELECT * FROM MNo_Labor WHERE MNo=@MNo";
        var chk = DBTool.Query<ClassTemplate>(sql_txt, new { MNo = MNo });
        Thread.Sleep(100);
        if (chk.Count() > 0)
        {
            sql_txt = "Declare @temp1 table ( [Labor_ID] [nvarchar](50) NULL " +
                " , [Service_ID] [varchar](2) NULL " +
                " , [Create_ID] [nvarchar](50) NULL )";

            sql_txt += "insert into @temp1 " +
                "([Labor_ID], [Service_ID], [Create_ID]) values ( @Labor_ID, @Service_ID, @Create_ID) ";

            sql_txt += "insert into LaborTemplate ( [MNo], [Type_Value], [Type], [Cust_ID], [Cust_Name], [Labor_Team], [Labor_Company], [Labor_ID] " +
                ", [Labor_EName], [Labor_CName], [Labor_Country], [Labor_PID], [Labor_RID], [Labor_EID], [Labor_Phone], [Labor_Language] " +
                ", [Labor_Address], [Labor_Address2], [Labor_Valid], [Service_ID], [Service], [ServiceName], [Time_01], [Time_02], [CarSeat], [LocationStart], [LocationEnd] " +
                ", [Location], [PostCode], [ContactName], [ContactPhone2], [ContactPhone3], [Contact_Co_TEL], [Hospital], [HospitalClass], [Question], [Create_ID] " +
                ", [Create_Team], [Create_Name], [Create_Company], [Agent_Mail], [UserID], [Answer], [Close_ID], [Close_Name], [Close_Time] ) ";

            sql_txt += "select TOP 1 @MNo, @Type_Value, @Type, @Cust_ID, @Cust_Name, b.[Labor_Team], b.[Labor_Company], a.[Labor_ID] " +
                ", b.[Labor_EName], b.[Labor_CName], b.[Labor_Country], b.[Labor_PID], b.[Labor_RID], b.[Labor_EID], b.[Labor_Phone], @Labor_Language " +
                ", @Labor_Address, @Labor_Address2, b.[Labor_Valid], a.[Service_ID], c.[Service], c.[ServiceName], @Time_01, @Time_02, @CarSeat, @LocationStart, @LocationEnd " +
                ", @Location, @PostCode, @ContactName, @ContactPhone2, @ContactPhone3, @Contact_Co_TEL, @Hospital, @HospitalClass, @Question, a.[Create_ID] " +
                ", [Agent_Team] as [Create_Team]" +
                ", [Agent_Name] as [Create_Name]" +
                ", [Agent_Company] as [Create_Company]" +
                ", [Agent_Mail], [UserID] " +
                ", @Answer, @Create_ID, @Create_Name, (getdate()) ";

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
                    Create_Name = UserIDNAME,
                    PostCode = "",
                    Location = "",
                    Answer = "【外包商需求單】"
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
            }
            return "new";
        }
        else
        {
            return "請選擇【雇主】或【外勞】";
        }
        #endregion
    }

    public static void Check()
    {
        string Check = JASON.Check_ID("0030010002.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
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