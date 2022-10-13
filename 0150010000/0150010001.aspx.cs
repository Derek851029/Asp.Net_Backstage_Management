using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using log4net.Config;

public partial class _0150010001 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    public string SQL_Agent_Company;
    protected string str_title;
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        if (Request.Params["seqno"] == "99999999")
        {
            str_title = "新增";
            Btn_New.Style.Add("display", "");
            Btn_Save.Style.Add("display", "none");
        }
        else
        {
            str_title = "修改";
            Btn_New.Style.Add("display", "none");
            Btn_Save.Style.Add("display", "");
        }

        if (!IsPostBack)
        {
            Agent agent = new Agent();
            agent.Agent_Company().ForEach(p => drop_company.Items.Add(new ListItem(p)));
            int seqno = 0;
            if (Request.Params["seqno"] == null || !int.TryParse(Request.Params["seqno"].ToString(), out seqno))
            {
                RegisterStartupScript("sqno不能為空白");
                Response.Redirect("0150010004.aspx");
            }

            if (Request.Params["seqno"] != "99999999")
            {
                BindData(seqno);
            }
        }
    }

    private void BindData(int seqno)
    {
        PartnerHeader schedule = PartnerHeaderRepository.CMS_0150010004_Get(seqno);
        if (schedule == null)
            throw new Exception("seqno 找不到資料");

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

        MASTER_TEL.Text = schedule.MASTER_TEL;

        #endregion
    }

    protected void Btn_Back_Click(object sender, EventArgs e)
    {
        Response.Redirect("0150010004.aspx");
    }
    /// <summary>
    /// 新增資料
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Btn_New_Click(object sender, EventArgs e)
    {
        #region 檢查欄位
        if (string.IsNullOrEmpty(txt_class.Text))
        {
            RegisterStartupScript("班次名稱未填寫");
            return;
        }

        if (txt_class.Text.Length > 10)
        {
            RegisterStartupScript("班次名稱不能超過１０個字元");
            return;
        }

        if (!chk_Mon.Checked && !chk_Tue.Checked &&
            !chk_Wed.Checked && !chk_Thu.Checked &&
            !chk_Fri.Checked && !chk_Sat.Checked &&
            !chk_Sun.Checked)
        {
            RegisterStartupScript("至少需要選擇一天為工作天");
            return;
        }
        if (string.IsNullOrEmpty(drop_Team.Text))
        {
            RegisterStartupScript("請選擇所屬部門");
            return;
        }
        if (string.IsNullOrEmpty(drop_Name.Text))
        {
            RegisterStartupScript("請選擇負責駕駛");
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

        if (string.IsNullOrEmpty(MASTER_TEL.Text))
        {
            RegisterStartupScript("請填寫駕駛電話");
            return;
        }

        if (MASTER_TEL.Text.Length > 10)
        {
            RegisterStartupScript("駕駛電話不能超過１０個字元");
            return;
        }
        #endregion

        ClassTemplate template = new ClassTemplate()
        {
            ClassName = txt_class.Text,
            ClassTimeType = drop_AM_PM_1.SelectedValue,
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
            MASTER_TEL = MASTER_TEL.Text,
            ClassDisable = false,
            UPDATE_TIME = DateTime.Now
        };

        if (!string.IsNullOrEmpty(drop_managername.SelectedValue))
        {
            template.MASTER1_ID = drop_managername.SelectedItem.Value;
            template.MASTER1_NAME = drop_managername.SelectedItem.Text;
            template.MASTER1_TEL = DispatchSystemRepository.GetAgentPhone(template.MASTER1_ID);
        }

        logger.Info("MASTER1_ID = " + template.MASTER1_ID);
        logger.Info("MASTER1_NAME = " + template.MASTER1_NAME);
        logger.Info("MASTER1_TEL = " + template.MASTER1_TEL);

        if (!string.IsNullOrEmpty(drop_agent_managername.SelectedValue))
        {
            template.MASTER2_ID = drop_agent_managername.SelectedItem.Value;
            template.MASTER2_NAME = drop_agent_managername.SelectedItem.Text;
            template.MASTER2_TEL = DispatchSystemRepository.GetAgentPhone(template.MASTER2_ID);
        }

        if (!string.IsNullOrEmpty(drop_company.SelectedValue))
        {
            template.MASTER_Company = drop_company.SelectedValue;
            template.MASTER_Team = drop_Team.SelectedValue;
            template.MASTER_ID = drop_Name.SelectedValue;
            template.MASTER_Name = drop_Name.SelectedItem.Text;
        }

        string checkstr = @"select top 1 SYS_ID from ClassTemplate where ClassName=@ClassName AND MASTER_ID=@MASTER_ID AND ClassDisable = 0 ";

        var chk = DBTool.Query<String>(checkstr, template);
        if (chk.Any())
        {
            RegisterStartupScript("已有重複的班次與駕駛");
            return;
        }

        string sqlstr = @"INSERT INTO [dbo].[ClassTemplate] 
                          (
                            [ClassName],[ClassTimeType],[ClassWeek_Mon],[ClassWeek_Tue],[ClassWeek_Wed],[ClassWeek_Thu],[ClassWeek_Fri],
                            [ClassWeek_Sat],[ClassWeek_Sun],[WORK_TimeType],[WORK_TimeHour],[WORK_TimeMin],[DIAL_TimeHour],[DIAL_TimeMin],[MASTER1_ID],[MASTER1_NAME],
                            [MASTER1_TEL],[MASTER2_ID],[MASTER2_NAME],[MASTER2_TEL],[MASTER_Company],[MASTER_Team],[MASTER_ID],[MASTER_Name],[MASTER_TEL],
                            [Partner_Company],[Partner_Driver],[Partner_Phone],[ClassDisable],[UPDATE_TIME])
                          VALUES(
                            @ClassName,@ClassTimeType,@ClassWeek_Mon,@ClassWeek_Tue,@ClassWeek_Wed,@ClassWeek_Thu,@ClassWeek_Fri,
                            @ClassWeek_Sat,@ClassWeek_Sun,@WORK_TimeType,@WORK_TimeHour,@WORK_TimeMin,@DIAL_TimeHour,@DIAL_TimeMin,@MASTER1_ID,
                            @MASTER1_NAME,@MASTER1_TEL,@MASTER2_ID,@MASTER2_NAME,@MASTER2_TEL,@MASTER_Company,@MASTER_Team,@MASTER_ID,@MASTER_Name,@MASTER_TEL,
                            @Partner_Company,@Partner_Driver,@Partner_Phone,@ClassDisable,@UPDATE_TIME)";
        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, template);

        // ===== 產生新增的班表 =====
        DateTime date = DateTime.Now;
        logger.Info("Year：" + date.Year + ", Month：" + date.Month + ", Day：" + date.AddDays(1).Day);
        logger.Info("新增班次完成，班次名稱：" + txt_class.Text.Trim());
        ClassScheduleRepository.AddNewClass(date.Year, date.Month, date.AddDays(1).Day, txt_class.Text.Trim());

        RegisterStartupScript("執行完成");
        Response.Redirect("0150010004.aspx");
    }

    /// <summary>
    /// 所屬公司事件
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void drop_company_SelectedIndexChanged(object sender, EventArgs e)
    {
        MASTER_TEL.Text = "";
        drop_Team.Items.Clear();
        drop_Team.Items.Insert(0, new ListItem("請選擇所屬部門...", ""));
        drop_Name.Items.Clear();
        drop_Name.Items.Insert(0, new ListItem("請選擇駕駛...", ""));
        drop_managername.Items.Clear();
        drop_managername.Items.Insert(0, new ListItem("請選擇負責主管...", ""));
        drop_agent_managername.Items.Clear();
        drop_agent_managername.Items.Insert(0, new ListItem("請選擇部門主管...", ""));
        string company = drop_company.SelectedValue;
        if (string.IsNullOrEmpty(company))
            return;
        Agent agent = new Agent();
        agent.Agent_Team(company, true).ForEach(p => drop_Team.Items.Add(new ListItem(p, p)));
        var list = agent.AgentItemList(company, string.Empty, true).Select(p => new { value = p.Agent_ID, text = p.Agent_Name });
        //代理人員
        drop_Name.DataSource = list;
        drop_Name.DataTextField = "text";
        drop_Name.DataValueField = "value";
        drop_Name.DataBind();
        drop_Name.Items.Insert(0, new ListItem("請選擇駕駛...", ""));
        //負責主管
        drop_managername.DataSource = list;
        drop_managername.DataTextField = "text";
        drop_managername.DataValueField = "value";
        drop_managername.DataBind();
        //代理主管
        drop_agent_managername.DataSource = list;
        drop_agent_managername.DataTextField = "text";
        drop_agent_managername.DataValueField = "value";
        drop_agent_managername.DataBind();
    }

    protected void drop_Name_SelectedIndexChanged(object sender, EventArgs e)
    {
        MASTER_TEL.Text = "";
        MASTER_TEL.Text = DispatchSystemRepository.GetAgentPhone(drop_Name.SelectedValue);
    }

    protected void drop_Team_SelectedIndexChanged(object sender, EventArgs e)
    {
        MASTER_TEL.Text = "";
        drop_Name.Items.Clear();
        drop_Name.Items.Insert(0, new ListItem("請選擇駕駛...", ""));
        drop_managername.Items.Clear();
        drop_managername.Items.Insert(0, new ListItem("請選擇負責主管...", ""));
        drop_agent_managername.Items.Clear();
        drop_agent_managername.Items.Insert(0, new ListItem("請選擇部門主管...", ""));
        string team = drop_Team.SelectedValue;
        if (string.IsNullOrEmpty(team))
            return;
        Agent agent = new Agent();
        var list = agent
            .AgentItemList(drop_company.SelectedValue, drop_Team.SelectedValue, true)
            .Select(p => new { value = p.Agent_ID, text = p.Agent_Name });
        drop_Name.DataSource = list;
        drop_Name.DataTextField = "text";
        drop_Name.DataValueField = "value";
        drop_Name.DataBind();
        drop_Name.Items.Insert(0, new ListItem("請選擇駕駛...", ""));

        //負責主管
        drop_managername.DataSource = list;
        drop_managername.DataTextField = "text";
        drop_managername.DataValueField = "value";
        drop_managername.DataBind();

        //代理主管
        drop_agent_managername.DataSource = list;
        drop_agent_managername.DataTextField = "text";
        drop_agent_managername.DataValueField = "value";
        drop_agent_managername.DataBind();
    }
    // <summary>
    /// Render結束後要執行的javascript，有ScriptManager的話要透過ScriptManager註冊
    /// </summary>
    /// 
    protected void Btn_Save_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txt_class.Text))
        {
            RegisterStartupScript("班次名稱未填寫");
            return;
        }

        if (txt_class.Text.Length > 10)
        {
            RegisterStartupScript("班次名稱不能超過１０個字元");
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

        if (string.IsNullOrEmpty(MASTER_TEL.Text))
        {
            RegisterStartupScript("請填寫駕駛電話");
            return;
        }

        if (txt_class.Text.Length > 10)
        {
            RegisterStartupScript("駕駛電話不能超過１０個字元");
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
            MASTER_TEL = MASTER_TEL.Text,
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
                              MASTER_TEL=@MASTER_TEL,
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

    public static string Check()
    {
        string Check = JASON.Check_ID("0150010004.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }
}
