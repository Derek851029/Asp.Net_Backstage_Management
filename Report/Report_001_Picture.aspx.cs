using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

public partial class Report_Report_001_Picture : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Check();
        if (!IsPostBack)
        {
            string seqno = "";
            seqno = Request.Params["seqno"];
            rptviewer.LocalReport.EnableExternalImages = true;
            rptviewer.LocalReport.ReportPath = Server.MapPath("/Report/Report_001_Picture.rdlc");
            rptviewer.LocalReport.DataSources.Clear();
            ReportParameter ImagePath = new ReportParameter("ImagePath", @"D:\Signature1\" + seqno + "_sign.jpg");
            rptviewer.LocalReport.SetParameters(new ReportParameter[] { ImagePath });
            rptviewer.LocalReport.Refresh();
        }
    }

    protected void Check()
    {
        string Check = JASON.Check_ID("0030010000/0030010003.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }
}