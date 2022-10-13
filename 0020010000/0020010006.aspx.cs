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

public partial class _0020010006 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassGroup(DateTime start, DateTime end)
    {
        Check();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        var a = ClassScheduleRepository._0020010006_GetClassGroup(start, end, Agent_Team, Agent_LV);
        return JsonConvert.SerializeObject(a);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date, string Type)
    {
        Check();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        var a = ClassScheduleRepository._0020010006_ClassScheduleList(date, Type, Agent_Team, Agent_LV)
              .Select(p => new
              {
                  Case_ID = p.Case_ID,// 需求單編號
                  Type = p.Type,// 狀態 
                  ID = p.ID,// 填單人員 ?
                  OpinionSubject = p.OpinionSubject,// 意見主旨
                  Urgency = p.Urgency,// 緊急程度
                  ReplyType = p.ReplyType,//回復
                  Type_Value = p.Type_Value,// 狀態編號
                  //ServiceName = p.ServiceName,// 服務內容
                  //Labor_CName = p.Labor_CName,// 勞工姓名
                  //Labor_ID = p.Labor_ID,// 勞工編號
                  Question = p.Question.Trim(), // 狀況說明
                  Cust_Name = p.Cust_Name,// 填單人員姓名
                  EstimatedFinishTime = p.EstimatedFinishTime.ToString("MM/dd HH:mm"),//預定完成時間
                  Time_01 = p.Time_01.ToString("MM/dd HH:mm"),//上傳時間
                  Upload_Time = p.Upload_Time.ToString("MM/dd HH:mm") //登錄日期
              });

        return JsonConvert.SerializeObject(a);
    }

    public static void Check()
    {
        string Check = JASON.Check_ID("0020010006.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }
}