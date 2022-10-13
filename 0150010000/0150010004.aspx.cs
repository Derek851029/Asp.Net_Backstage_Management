using Dapper;
using Newtonsoft.Json;
using System;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _0150010004 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        if (!IsPostBack)
        {

        }
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetPartnerList()
    {
        Check();
        var a = PartnerHeaderRepository.CMS_0150010004_GetList()
            .Select(p => new
            {
                SYS_ID = p.SYS_ID,//編號
                ClassName = p.ClassName,//班次名稱
                //WORK_Time = DateTime.ParseExact(string.Format("{0}:{1}:00 {2}", p.WORK_TimeHour,p.WORK_TimeMin,p.WORK_TimeType), "h:m:ss tt", CultureInfo.GetCultureInfo("zh-tw")),
                WORK_Time = string.Format("{0} {1} 點 {2} 分", p.WORK_TimeType, p.WORK_TimeHour, p.WORK_TimeMin),//到班時間
                DIAL_Time = string.Format("{0} {1} 點 {2} 分", p.WORK_TimeType, p.DIAL_TimeHour, p.DIAL_TimeMin),//通知時間
                MASTER_Name = p.MASTER_Name,//負責人員               
                MASTER1_NAME = p.MASTER1_NAME,//負責主管
                UPDATE_TIME = p.UPDATE_TIME.HasValue ? p.UPDATE_TIME.Value.ToString("yyyy/MM/dd hh:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd"),//更新日期
            });
        return JsonConvert.SerializeObject(a, Formatting.Indented);
        //return JsonConvert.SerializeObject(PartnerHeaderRepository.CMS_0150010004_GetList(), Formatting.Indented);
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

        string ID = HttpContext.Current.Session["UserID"].ToString();
        string NAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        try
        {
            PartnerHeaderRepository.CMS_0150010004_Delete(seqno, ID, NAME);
            //刪除 Rep_Classes2016 今天以後的班次 
            PartnerHeaderRepository.Delete_Rep_Classes2016(seqno);
            return JsonConvert.SerializeObject(new { status = "success" });
        }
        catch (Exception err)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0150010004");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }
}
