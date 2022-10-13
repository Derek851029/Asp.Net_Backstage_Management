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

public partial class _0020010005 : System.Web.UI.Page
{
    protected string str_time;
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        switch (Request.Params["str_time"])
        {
            case "1":
                str_time = "1";
                break;
            case "2":
                str_time = "2";
                break;
            default:
                str_time = "0";
                break;
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end, string time)
    {
        Check();
        string ID = HttpContext.Current.Session["UserID"].ToString();
        string LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Team = HttpContext.Current.Session["Agent_Team"].ToString();
        return JsonConvert.SerializeObject(ClassScheduleRepository._0020010005_GetClassGroup(start, end, ID, LV, Team, time), Formatting.Indented);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date, string type, string str_time)
    {
        Check();
        string ID = HttpContext.Current.Session["UserID"].ToString();
        string LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Team = HttpContext.Current.Session["Agent_Team"].ToString();
        var a = ClassScheduleRepository._0020010005_ClassScheduleList(date, type, ID, LV, Team, str_time)
            .Select(p => new
            {
                CNo = p.CNo,// 需求單編號
                Danger = p.Danger,//緊急程度
                OverTime = p.OverTime.ToString("yyyy/MM/dd HH:mm"),
                Type = p.Type,// 處理狀況
                Type_Value = p.Type_Value,// 處理狀況
                //ServiceName = p.ServiceName,// 服務內容
                Agent_Name = p.Agent_Name,// 服務人員姓名
                UPDATE_TIME = p.CREATE_DATE.ToString("yyyy/MM/dd HH:mm"),//更新日期
                UPDATE_Name = p.Create_Name,//更新人員
            });
        return JsonConvert.SerializeObject(a, Formatting.Indented);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        System.Web.HttpContext.Current.Response.Redirect("~/0030010000/0030010003.aspx");
        string Check = JASON.Check_ID("0020010005.aspx");
        if (Check == "NO")
        {
            //System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");            
        }
        return "";
    }
}