using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _0150010005 : System.Web.UI.Page
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
        return JsonConvert.SerializeObject(PartnerHeaderRepository.GetList(), Formatting.Indented);
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
            PartnerHeaderRepository.Delete(seqno);
            return JsonConvert.SerializeObject(new { status = "success" });
        }
        catch (Exception err)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
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
