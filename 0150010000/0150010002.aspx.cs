using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using log4net.Config;

public partial class _0150010002 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        if (!IsPostBack)
        {

        }
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string DelPartner(string seqno)
    {
        Check();
        if (JASON.IsInt(seqno) != true)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }

        if (seqno.Length > 10)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }

        try
        {
            PartnerHeaderRepository.CMS_0150010002_Delete(seqno);
            return JsonConvert.SerializeObject(new { status = "success" });
        }
        catch (Exception err)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end)
    {
        Check();
        return JsonConvert.SerializeObject(ClassScheduleRepository.GetClassGroup(start, end), Formatting.Indented);
    }


    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date, string ClassName)
    {
        Check();
        var a = ClassScheduleRepository.GetClassScheduleList(date, ClassName)
            .Select(p => new
            {
                SYS_ID = p.SYS_ID,//編號
                WORK_DATETime = p.WORK_DATE.ToString("yyyy/MM/dd"),//日期
                ClassName = p.Class,//班次名稱
                WORK_Time = p.WORK_TIME.ToString("tt HH:mm"),//到班時間
                DIAL_Time = p.DIAL_TIME.ToString("tt HH:mm"),//到班時間
                MASTER_Name = p.MASTER_Name,//負責人員
                Partner_Driver = p.Partner_Driver,//代理人員
                MASTER1_NAME = p.MASTER1_NAME,//負責主管
                WORK_Status = p.DRIVER_STATE,//狀態
                UPDATE_TIME = p.UPDATE_TIME.HasValue ? p.UPDATE_TIME.Value.ToString("yyyy/MM/dd") : DateTime.Now.ToString("yyyy/MM/dd"),//更新日期
            });

        return JsonConvert.SerializeObject(a, Formatting.Indented);
    }

    public static string Check()
    {
        string Check = JASON.Check_ID("0150010002.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }
}