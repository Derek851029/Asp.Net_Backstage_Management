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
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string sqlstr = @"select  CaseDetailStatus + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Cast(AssignDate as date) as start, Type as type, CaseDetailStatus as value " +
                          " FROM CASEDetail WHERE AssignDate between @startDate AND @ednDate ";
        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND AssignDept = @Agent_Team";
                break;

            case "30":
                break;

            default:
                sqlstr += " AND AssignUser = @Agent_ID";
                break;
        }

        sqlstr += " group by Type,Cast(AssignDate as date),CaseDetailStatus";
        return JsonConvert.SerializeObject(DBTool.Query<fCeventItem>(sqlstr, new
        {
            startDate = start,
            ednDate = end,
            Agent_ID = ID,
            Agent_Team = Team
        }).ToList());
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetClassScheduleList(DateTime date, string type, string str_time)
    {
        Check();
        string ID = HttpContext.Current.Session["UserID"].ToString();
        string LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();

        string sqlstr = @"select * from CASEDetail where Cast(AssignDate as date) = @WORK_DATETime AND Type=@Type";
        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND AssignDept = @Agent_Team";
                break;

            case "30":
                break;

            default:
                sqlstr += " AND AssignUser = @Agent_ID";
                break;
        }

        var a = DBTool.Query<value_0020010005>(sqlstr,
           new
           {
               WORK_DATETime = date,
               Type = type,
               Agent_ID = ID,
               Agent_Team = Team
           }).ToList();

        var b =a.Select(p => new
        {
            CNo = p.CaseDetailNO,// 需求單編號
            Assign_Time = p.AssignDate.ToString("yyyy/MM/dd HH:mm"),//更新日期           
            NAME = p.BUSINESSNAME,//
            Type = p.Type,// 處理狀況
            Agent_Name = p.AssignUser,// 服務人員姓名
            Memo = p.AssignMemo,
            UPDATE_TIME = p.UpdateDate.ToString("yyyy/MM/dd HH:mm"),//更新日期
            UPDATE_Name = p.UpdateUser,//更新人員
        });
        return JsonConvert.SerializeObject(b);
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check()
    {
        string Check = JASON.Check_ID("0020010005.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }

    public class value_0020010005
    {
        public string CaseDetailNO { get; set; }
        public string BUSINESSNAME { get; set; }
        public string Type { get; set; }
        public string AssignUser { get; set; }
        public string AssignMemo { get; set; }
        public string UpdateUser { get; set; }
        public DateTime AssignDate { get; set; }
        public DateTime UpdateDate { get; set; }
    }
}