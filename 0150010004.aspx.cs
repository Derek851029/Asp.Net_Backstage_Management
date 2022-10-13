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
            var list = Agent_Name(true).Select(p => new { value = p.Agent_ID, text = p.Agent_Name });
            //代理人員
            drop_Name.DataSource = list;
            drop_Name.DataTextField = "text";
            drop_Name.DataValueField = "value";
            drop_Name.DataBind();
            drop_Name.Items.Insert(0, new ListItem("請選擇駕駛…", ""));
            //負責主管
            drop_managername.DataSource = list;
            drop_managername.DataTextField = "text";
            drop_managername.DataValueField = "value";
            drop_managername.DataBind();
            drop_managername.Items.Insert(0, new ListItem("請選擇負責主管…", ""));
            //代理主管
            drop_agent_managername.DataSource = list;
            drop_agent_managername.DataTextField = "text";
            drop_agent_managername.DataValueField = "value";
            drop_agent_managername.DataBind();
            drop_agent_managername.Items.Insert(0, new ListItem("請選擇部門主管…", ""));
        }
    }

    public List<AgentItem> Agent_Name(bool isdistinct = true)
    {
        string sqlstr = @"SELECT Agent_ID, Agent_Name FROM DispatchSystem WHERE " +
            "Agent_Team = '營繕暨安全衛生部' AND Agent_Status = '在職' AND Agent_ID != '' ";
        var result = DBTool.Query<AgentItem>(sqlstr);
        if (isdistinct)
            result = result.Distinct();
        return result.ToList();
    }

    protected void Changed_1(object sender, EventArgs e)
    {
        MASTER_TEL.Text = "";
        MASTER_TEL.Text = DispatchSystemRepository.GetAgentPhone(drop_Name.SelectedValue);
    }

    protected void Changed_2(object sender, EventArgs e)
    {
        MASTER_TEL_2.Text = "";
        MASTER_TEL_2.Text = DispatchSystemRepository.GetAgentPhone(drop_managername.SelectedValue);
    }

    protected void Changed_3(object sender, EventArgs e)
    {
        MASTER_TEL_3.Text = "";
        MASTER_TEL_3.Text = DispatchSystemRepository.GetAgentPhone(drop_agent_managername.SelectedValue);
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
                WORK_Time = string.Format("{0} {1} 點 {2} 分", p.WORK_TimeType, p.WORK_TimeHour, p.WORK_TimeMin),//到班時間
                DIAL_Time = string.Format("{0} {1} 點 {2} 分", p.WORK_TimeType, p.DIAL_TimeHour, p.DIAL_TimeMin),//通知時間
                MASTER_Name = p.MASTER_Name,//負責人員               
                MASTER1_NAME = p.MASTER1_NAME,//負責主管
                UPDATE_TIME = p.UPDATE_TIME.HasValue ? p.UPDATE_TIME.Value.ToString("yyyy/MM/dd hh:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd"),//更新日期
            });
        return JsonConvert.SerializeObject(a);
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

    public class AgentItem
    {
        public string Agent_ID { get; set; }
        public string Agent_Name { get; set; }
    }
}
