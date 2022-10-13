using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _0150010003 : System.Web.UI.Page
{
    public string SQL_Agent_Company;
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        if (!IsPostBack)
        {
            int seqno = 0;
            if (Request.Params["seqno"] == null || !int.TryParse(Request.Params["seqno"].ToString(), out seqno))
            {
                RegisterStartupScript("sqno不能為空白");
                Response.Redirect("0150010002.aspx");
            }
            BindData(seqno);
        }
    }

    private void BindData(int seqno)
    {
        ClassSchedule schedule = ClassScheduleRepository.GetClassSchedule(seqno);
        if (schedule == null)
            throw new Exception("seqno 找不到資料");
        Agent agent = new Agent();
        agent.Agent_Company().ForEach(p => drop_company.Items.Add(new ListItem(p)));

        var list = PartnerHeaderRepository.GetList().Select(p => new ListItem(p.Partner_Company, p.SYS_ID.ToString()));
        drop_partner_Company.DataSource = list;
        drop_partner_Company.DataTextField = "text";
        drop_partner_Company.DataValueField = "value";
        drop_partner_Company.DataBind();
        drop_partner_Company.Items.Insert(0, new ListItem("請選擇配合廠商…", ""));

        #region 對應資料
        hid_tel.Value = schedule.MASTER_TEL.ToString();
        hid_seqno.Value = schedule.SYS_ID.ToString();
        txt_class.Text = schedule.Class;
        drop_AM_PM_1.Text = schedule.ClassTimeType;
        txt_WORK_DATETime.Text = schedule.WORK_TIME.ToString("yyyy-MM-dd");
        drop_AM_PM.SelectedValue = schedule.WORK_TIME.ToString("tt");
        drop_Hour.SelectedValue = schedule.WORK_TIME.ToString("HH");
        drop_Minute.SelectedValue = schedule.WORK_TIME.ToString("mm");
        drop_Hour_2.SelectedValue = schedule.DIAL_TIME.ToString("HH");
        drop_Minute_2.SelectedValue = schedule.DIAL_TIME.ToString("mm");
        //先選好公司在連動負責主管/代理主管
        drop_company.SelectedValue = schedule.DRIVER_Company;
        drop_company_SelectedIndexChanged(null, null);

        drop_managername.SelectedValue = schedule.MASTER1_ID;
        drop_agent_managername.SelectedValue = schedule.MASTER2_ID;

        //指定部門再連動負責人員
        drop_Team.SelectedValue = schedule.DRIVER_Team;
        drop_Team_SelectedIndexChanged(null, null);
        drop_Name.SelectedValue = schedule.MASTER_ID;

        #endregion
    }

    /// <summary>
    /// 新增資料
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Btn_Save_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txt_class.Text))
        {
            RegisterStartupScript("班次名稱未填寫");
            return;
        }
        if (string.IsNullOrEmpty(drop_Team.Text))
        {
            RegisterStartupScript("請選擇所屬部門");
            return;
        }
        if (string.IsNullOrEmpty(drop_Name.Text))
        {
            RegisterStartupScript("請選擇負責司機");
            return;
        }
        if (string.IsNullOrEmpty(drop_managername.Text))
        {
            RegisterStartupScript("請選擇負責主管");
            return;
        }
        if (string.IsNullOrEmpty(drop_agent_managername.Text))
        {
            RegisterStartupScript("請選擇部門主管");
            return;
        }
        string workstr = string.Format("{0} {1}:{2}:00 {3}", txt_WORK_DATETime.Text, drop_Hour.Text, drop_Minute.Text, drop_AM_PM.Text);
        string dialstr = string.Format("{0} {1}:{2}:00 {3}", txt_WORK_DATETime.Text, drop_Hour_2.Text, drop_Minute_2.Text, drop_AM_PM.Text);
        DateTime WORK_DATETime = DateTime.ParseExact(workstr, "yyyy-M-d h:m:ss tt", CultureInfo.GetCultureInfo("zh-tw"));
        DateTime DIAL_DATETime = DateTime.ParseExact(dialstr, "yyyy-M-d h:m:ss tt", CultureInfo.GetCultureInfo("zh-tw"));

        ClassSchedule classschedule = new ClassSchedule()
        {
            SYS_ID = int.Parse(hid_seqno.Value),
            ClassName = txt_class.Text,
            ClassTimeType = drop_AM_PM_1.Text,
            WORK_DATETime = WORK_DATETime,
            DIAL_DATETime = DIAL_DATETime,
            MASTER1_ID = "",
            MASTER1_NAME = "",
            MASTER1_TEL = "",
            MASTER2_ID = "",
            MASTER2_NAME = "",
            MASTER2_TEL = "",
            MASTER_Company = "",
            MASTER_Team = "",
            MASTER_ID = "",
            MASTER_Name = "",
            DRIVER_ID = "",
            DRIVER_NAME = "",
            DRIVER_TEL = "",
            Partner_Company = "",
            Partner_Driver = "",
            Partner_Phone = "",
            UPDATE_TIME = DateTime.Now,
        };
        #region 判斷資料
        if (!string.IsNullOrEmpty(drop_managername.SelectedValue))
        {
            classschedule.MASTER1_ID = drop_managername.SelectedValue;
            classschedule.MASTER1_NAME = drop_managername.SelectedItem.Text;
            classschedule.MASTER1_TEL = DispatchSystemRepository.GetAgentPhone(drop_managername.SelectedValue);
        }
        if (!string.IsNullOrEmpty(drop_agent_managername.SelectedValue))
        {
            classschedule.MASTER2_ID = drop_agent_managername.SelectedValue;
            classschedule.MASTER2_NAME = drop_agent_managername.SelectedItem.Text;
            classschedule.MASTER2_TEL = DispatchSystemRepository.GetAgentPhone(drop_agent_managername.SelectedValue);
        }
        if (!string.IsNullOrEmpty(drop_company.SelectedValue))
        {
            classschedule.MASTER_Company = drop_company.SelectedValue;
            classschedule.MASTER_Team = drop_Team.SelectedValue;
            classschedule.MASTER_ID = drop_Name.SelectedValue;
            classschedule.MASTER_Name = drop_Name.SelectedItem.Text;
        }
        if (!string.IsNullOrEmpty(drop_partner_Company.SelectedValue))
        {
            classschedule.Partner_Company = drop_partner_Company.SelectedItem.Text;
            classschedule.Partner_Driver = txt_partner_driver.Text;
            classschedule.Partner_Phone = txt_partner_phone.Text;
            classschedule.DRIVER_NAME = txt_partner_driver.Text;
            classschedule.DRIVER_TEL = txt_partner_phone.Text;
        }
        else
        {
            classschedule.DRIVER_NAME = drop_Name.SelectedItem.Text;
            classschedule.DRIVER_TEL = hid_tel.Value;
        }

        #endregion

        string sqlstr = @"UPDATE [dbo].[Rep_Classes2016]
                          SET Class=@ClassName,
                              ClassTimeType=@ClassTimeType,
                              WORK_DATE=@WORK_DATETime,
                              WORK_TIME=@WORK_DATETime,
                              DIAL_TIME=@DIAL_DATETime,
                              MASTER1_ID=@MASTER1_ID,
                              MASTER1_NAME=@MASTER1_NAME,
                              MASTER1_TEL=@MASTER1_TEL,
                              MASTER2_ID=@MASTER2_ID,
                              MASTER2_NAME=@MASTER2_NAME,
                              MASTER2_TEL=@MASTER2_TEL,
                              DRIVER_Company=@MASTER_Company,
                              DRIVER_Team=@MASTER_Team,
                              DRIVER_ID=@MASTER_ID,
                              DRIVER_NAME=@DRIVER_NAME,
                              DRIVER_TEL=@DRIVER_TEL,
                              MASTER_ID=@MASTER_ID,
                              MASTER_NAME=@MASTER_Name,
                              Partner_Company=@Partner_Company,
                              Partner_Driver=@Partner_Driver,
                              Partner_Phone=@Partner_Phone,
                              UPDATE_TIME=@UPDATE_TIME
                          WHERE SYS_ID=@SYS_ID";
        using (IDbConnection conn = DBTool.GetConn())
        {
            conn.Execute(sqlstr, classschedule);
        }
        RegisterStartupScript("更新完成");
        Response.Redirect("0150010002.aspx");
        //Response.Redirect("Default3.aspx");
    }

    protected void Btn_Back_Click(object sender, EventArgs e)
    {
        Response.Redirect("0150010002.aspx");
    }

    /// <summary>
    /// 所屬公司事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void drop_company_SelectedIndexChanged(object sender, EventArgs e)
    {
        string company = drop_company.SelectedValue;
        if (string.IsNullOrEmpty(company))
            return;
        Agent agent = new Agent();
        drop_Team.Items.Clear();
        drop_Team.Items.Insert(0, new ListItem("請選擇所屬部門", ""));
        agent.Agent_Team(company, true).ForEach(p => drop_Team.Items.Add(new ListItem(p, p)));
        var list = agent.AgentItemList(company, string.Empty, true).Select(p => new { value = p.Agent_ID, text = p.Agent_Name });
        //代理人員
        drop_Name.DataSource = list;
        drop_Name.DataTextField = "text";
        drop_Name.DataValueField = "value";
        drop_Name.DataBind();
        drop_Name.Items.Insert(0, new ListItem("請選擇駕駛", ""));
        //負責主管
        drop_managername.DataSource = list;
        drop_managername.DataTextField = "text";
        drop_managername.DataValueField = "value";
        drop_managername.DataBind();
        drop_managername.Items.Insert(0, new ListItem("請選擇負責主管", ""));
        //代理主管
        drop_agent_managername.DataSource = list;
        drop_agent_managername.DataTextField = "text";
        drop_agent_managername.DataValueField = "value";
        drop_agent_managername.DataBind();
        drop_agent_managername.Items.Insert(0, new ListItem("請選擇部門主管", ""));
    }
    /// <summary>
    /// 所屬部門事件，連動人員
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void drop_Team_SelectedIndexChanged(object sender, EventArgs e)
    {
        Agent agent = new Agent();
        var list = agent
            .AgentItemList(drop_company.SelectedValue, drop_Team.SelectedValue, true)
            .Select(p => new { value = p.Agent_ID, text = p.Agent_Name });
        drop_Name.DataSource = list;
        drop_Name.DataTextField = "text";
        drop_Name.DataValueField = "value";
        drop_Name.DataBind();
        drop_Name.Items.Insert(0, new ListItem("請選擇駕駛", ""));

        //負責主管
        drop_managername.DataSource = list;
        drop_managername.DataTextField = "text";
        drop_managername.DataValueField = "value";
        drop_managername.DataBind();
        drop_managername.Items.Insert(0, new ListItem("請選擇負責主管", ""));

        //代理主管
        drop_agent_managername.DataSource = list;
        drop_agent_managername.DataTextField = "text";
        drop_agent_managername.DataValueField = "value";
        drop_agent_managername.DataBind();
        drop_agent_managername.Items.Insert(0, new ListItem("請選擇部門主管", ""));
    }
    // <summary>
    /// Render結束後要執行的javascript，有ScriptManager的話要透過ScriptManager註冊
    /// </summary>
    private void RegisterStartupScript(string msg)
    {

        if (ScriptManager.GetCurrent(this.Page) == null)
        {
            Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "buttonStartup", "alert('" + msg + "');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "buttonStartupBySM", "alert('" + msg + "');", true);
        }
    }

    protected void drop_partner_Company_SelectedIndexChanged(object sender, EventArgs e)
    {
        var partner = PartnerHeaderRepository.GetList().Where(p => p.SYS_ID.ToString().Equals(drop_partner_Company.SelectedValue));

        if (partner.Any())
        {
            txt_partner_driver.Text = partner.First().Partner_Driver;
            txt_partner_phone.Text = partner.First().Partner_Phone;
        }
        else
        {
            txt_partner_driver.Text = string.Empty;
            txt_partner_phone.Text = string.Empty;
        }
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
