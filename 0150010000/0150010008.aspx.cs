using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _0150010008 : System.Web.UI.Page
{
    public string SQL_Agent_Company;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int seqno = 0;
            if (Request.Params["seqno"] == null || !int.TryParse(Request.Params["seqno"].ToString(), out seqno))
            {
                RegisterStartupScript("sqno不能為空白");
                Response.Redirect("0150010004.aspx");
            }
            BindData(seqno);
        }
    }

    private void BindData(int seqno)
    {
        PartnerHeader schedule = PartnerHeaderRepository.CMS_0150010004_Get(seqno);
        if (schedule == null)
            throw new Exception("seqno 找不到資料");
        Agent agent = new Agent();
        agent.Agent_Company().ForEach(p => drop_company.Items.Add(new ListItem(p)));

        #region 對應資料

        hid_seqno.Value = schedule.SYS_ID.ToString();
        txt_class.Text = schedule.ClassName;
        drop_AM_PM_1.Text = schedule.ClassTimeType;
        drop_AM_PM.SelectedValue = schedule.WORK_TimeType;
        drop_Hour.SelectedValue = schedule.WORK_TimeHour;
        drop_Minute.SelectedValue = schedule.WORK_TimeMin;
        drop_Hour_2.SelectedValue = schedule.DIAL_TimeHour;
        drop_Minute_2.SelectedValue = schedule.DIAL_TimeMin;
        chk_Mon.Checked = schedule.ClassWeek_Mon;
        chk_Tue.Checked = schedule.ClassWeek_Tue;
        chk_Wed.Checked = schedule.ClassWeek_Wed;
        chk_Thu.Checked = schedule.ClassWeek_Thu;
        chk_Fri.Checked = schedule.ClassWeek_Fri;
        chk_Sat.Checked = schedule.ClassWeek_Sat;
        chk_Sun.Checked = schedule.ClassWeek_Sun;
        //先選好公司在連動負責主管/代理主管
        drop_company.SelectedValue = schedule.MASTER_Company;
        drop_company_SelectedIndexChanged(null, null);

        drop_managername.SelectedValue = schedule.MASTER1_ID;
        drop_agent_managername.SelectedValue = schedule.MASTER2_ID;

        //指定部門再連動負責人員
        drop_Team.SelectedValue = schedule.MASTER_Team;
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

        ClassTemplate classschedule = new ClassTemplate()
        {
            SYS_ID = int.Parse(hid_seqno.Value),
            ClassName = txt_class.Text,
            ClassTimeType = drop_AM_PM_1.Text,
            ClassWeek_Mon = chk_Mon.Checked,
            ClassWeek_Tue = chk_Tue.Checked,
            ClassWeek_Wed = chk_Wed.Checked,
            ClassWeek_Thu = chk_Thu.Checked,
            ClassWeek_Fri = chk_Fri.Checked,
            ClassWeek_Sat = chk_Sat.Checked,
            ClassWeek_Sun = chk_Sun.Checked,
            WORK_TimeType = drop_AM_PM.SelectedValue,
            WORK_TimeHour = drop_Hour.SelectedValue,
            WORK_TimeMin = drop_Minute.SelectedValue,
            DIAL_TimeHour = drop_Hour_2.SelectedValue,
            DIAL_TimeMin = drop_Minute_2.SelectedValue,
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
            ClassDisable = false,
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

        #endregion
        string sqlstr = @"UPDATE [dbo].[ClassTemplate]
                          SET ClassName=@ClassName,
                              ClassTimeType=@ClassTimeType,
                              ClassWeek_Mon=@ClassWeek_Mon,
                              ClassWeek_Tue=@ClassWeek_Tue,
                              ClassWeek_Wed=@ClassWeek_Wed,
                              ClassWeek_Thu=@ClassWeek_Thu,
                              ClassWeek_Fri=@ClassWeek_Fri,
                              ClassWeek_Sat=@ClassWeek_Sat,
                              ClassWeek_Sun=@ClassWeek_Sun,
                              WORK_TimeType=@WORK_TimeType,
                              WORK_TimeHour=@WORK_TimeHour,
                              WORK_TimeMin=@WORK_TimeMin,
                              DIAL_TimeHour=@DIAL_TimeHour,
                              DIAL_TimeMin=@DIAL_TimeMin,
                              MASTER1_ID=@MASTER1_ID,
                              MASTER1_NAME=@MASTER1_NAME,
                              MASTER1_TEL=@MASTER1_TEL,
                              MASTER2_ID=@MASTER2_ID,
                              MASTER2_NAME=@MASTER2_NAME,
                              MASTER2_TEL=@MASTER2_TEL,
                              MASTER_Company=@MASTER_Company,
                              MASTER_Team=@MASTER_Team,
                              MASTER_ID=@MASTER_ID,
                              MASTER_Name=@MASTER_Name,
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
        Response.Redirect("0150010004.aspx");
        //Response.Redirect("Default3.aspx");
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
}
