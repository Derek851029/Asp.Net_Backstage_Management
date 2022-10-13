using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class Report_Image_Load : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string seqno = Request.Params["seqno"];
            if (string.IsNullOrEmpty(seqno))
            {
                Response.Write("<script>alert('無派工單編號'); location.href='/0030010000/0030010003.aspx'; </script>");
            }
            Session["CNo"] = seqno;
        }
        catch
        {
            Response.Write("<script>alert('系統錯誤，將返回首頁。'); location.href='/Default.aspx'; </script>");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load()
    {
        string CNo = HttpContext.Current.Session["CNo"].ToString();
        string Sqlstr = @"SELECT MD5_CNo as CNo, MD5_Name as SYSID, Type FROM Upload_Image WHERE CNo = @CNo ";
        string outputJson = "";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { CNo = CNo });
        if (a.Count() > 0)
        {
            int i = 0;
            int id = 0;
            foreach (var var in a)
            {
                i++;
                id++;
                if (i == 1)
                {
                    outputJson += "<tr><th style='text-align: center; width: 100%;'>";
                }
                outputJson += "<img src='../21232F297A57A5A743894A0E4A801FC3/" + var.CNo + "/" + var.SYSID + var.Type + "' " +
                    " id=P_" + id.ToString() +
                    " onclick=image_List(" + id.ToString() + ")" +
                    " style='text-align: center; width: 24%;' class='img-thumbnail' " +
                    " data-toggle='modal' data-target='#myModal' />";
                if (i >= 4)
                {
                    outputJson += "</th></tr>";
                    i = 0;
                };
            }

            if (i != 0)
            {
                for (int b = i; b < 4; b++)
                {
                    id++;
                    outputJson += "<img src='../Patrol_System/NULL.png' " +
                        " id=P_" + id.ToString() +
                        " onclick=image_List(" + id.ToString() + ")" +
                        " style='text-align: center; width: 24%;' class='img-thumbnail' " +
                        " data-toggle='modal' data-target='#myModal' />";
                }
                outputJson += "</th></tr>";
            }

            return "[" + JsonConvert.SerializeObject(new { flag = "0", value = outputJson }) + "]"; // 組合JSON 格
        }
        else
        {
            return "[" + JsonConvert.SerializeObject(new { flag = "1" }) + "]"; // 組合JSON 格式
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Back()
    {
        string CNo = HttpContext.Current.Session["CNo"].ToString();
        return "../0030010097.aspx?seqno=" + CNo;
    }
}