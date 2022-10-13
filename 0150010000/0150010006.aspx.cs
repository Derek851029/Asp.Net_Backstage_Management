using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _0150010006 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        if (!IsPostBack)
        {
            int seqno = 0;
            if (Request.Params["seqno"] == null || !int.TryParse(Request.Params["seqno"].ToString(), out seqno))
            {
                RegisterStartupScript("sqno不能為空白");
                Response.Redirect("0150010005.aspx");
            }
            BindData(seqno);
        }
    }

    private void BindData(int seqno)
    {
        PartnerHeader partner = PartnerHeaderRepository.Get(seqno);
        txt_Partner_Company.Text = partner.Partner_Company;
        txt_Partner_Driver.Text = partner.Partner_Driver;
        txt_Partner_Phone.Text = partner.Partner_Phone;
        hid_SysID.Value = partner.SYS_ID.ToString();
    }

    /// <summary>
    /// 更新資料
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Btn_Save_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txt_Partner_Company.Text))
        {
            RegisterStartupScript("請輸入配合廠商");
            return;
        }

        if (txt_Partner_Company.Text.Length > 10)
        {
            RegisterStartupScript("配合廠商不能超過１０個字元");
            return;
        }

        if (string.IsNullOrEmpty(txt_Partner_Driver.Text))
        {
            RegisterStartupScript("請輸入駕駛姓名");
            return;
        }

        if (txt_Partner_Driver.Text.Length > 10)
        {
            RegisterStartupScript("駕駛姓名不能超過１０個字元");
            return;
        }

        if (string.IsNullOrEmpty(txt_Partner_Phone.Text))
        {
            RegisterStartupScript("請輸入電話");
            return;
        }

        if (txt_Partner_Phone.Text.Length > 10)
        {
            RegisterStartupScript("電話不能超過１０個字元");
            return;
        }

        int sysid = 0;
        if (string.IsNullOrEmpty(hid_SysID.Value) || !int.TryParse(hid_SysID.Value, out sysid))
        {
            Response.Redirect("0150010005.aspx");
            return;
        }

        PartnerHeader partner = new PartnerHeader()
        {
            SYS_ID = sysid,
            Partner_Company = txt_Partner_Company.Text,
            Partner_Driver = txt_Partner_Driver.Text,
            Partner_Phone = txt_Partner_Phone.Text,
            UPDATE_TIME = DateTime.Now
        };
        if (PartnerHeaderRepository.Update(partner))
        {
            RegisterStartupScript("更新完成");
            Response.Redirect("0150010005.aspx");
        }
        else
            RegisterStartupScript("更新失敗");
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

    public static string Check()
    {
        string Check = JASON.Check_ID("0150010005.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
        return "";
    }
}
