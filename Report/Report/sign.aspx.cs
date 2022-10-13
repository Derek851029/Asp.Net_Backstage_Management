using Dapper;
using System;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
//using System.Web.HttpRequest;
//using System.Web.HttpException;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
//using System.Web.UI.Page.Request.get;
using Microsoft.Reporting.WebForms;
using log4net;
using log4net.Config;
using System.IO;

public partial class sign_001 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected string seqno;
    protected string str_view;
    protected string str_sign;

    protected void Page_Init(object sender, EventArgs e)
    {
        //Check();
        seqno = Request.Params["seqno"];
        Session["C_ID_S"] = Request.Params["seqno"];
        //Session["view"] = Request.Params["view"];
        Session["sign"] = Request.Params["sign"];
    }

    protected void Check()
    {
        string Check = JASON.Check_ID("0020010005.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    //public static string UploadPic(string imageData)
    public static string UploadPic(string imageData, string CNo)
    {
        try
        {
            //string CNo = HttpContext.Current.Session["CNo"].ToString();
            //string company = HttpContext.Current.Session["company"].ToString();
            string name = string.Format("{0:yyyyMMddHHmmss}", DateTime.Now);
            //string Pic_Path = (@"D:\Signature1\" + CNo + "_C_sign.jpg");
            string Pic_Path = (@"C:\Signature1\" + CNo + "_C_sign.jpg");    //德瑪
            //string Pic_Path = (@"118.163.27.22:8080/Signature/" + CNo + "_sign.jpg");
            using (FileStream fs = new FileStream(Pic_Path, FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(fs))
                {
                    byte[] data = Convert.FromBase64String(imageData);
                    bw.Write(data);
                    bw.Close();
                }
            }   // 這段產生了錯誤 */  

            /* string sqlstr = @"UPDATE CaseData SET " +
            "Service_Flag='1', Service_DATE=GETDATE() " +   
            "WHERE Case_ID=@Case_ID"; //目前交給工程師簽名判定 

             using (IDbConnection db = DBTool.GetConn())
                 db.Execute(sqlstr, new { Case_ID = CNo });*/

            return JsonConvert.SerializeObject(new { flag = "0", txt = "/Report/Report_001.aspx?seqno=" + CNo + "&company=" });// + company
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { flag = "1", txt = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" + ex });
        }
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    //public static string UploadPic2(string imageData)
    public static string UploadPic2(string imageData, string CNo)
    {
        try
        {
            //string CNo = HttpContext.Current.Session["C_ID_S"].ToString();
            string str_view = HttpContext.Current.Session["view"].ToString(); 
            string name = string.Format("{0:yyyyMMddHHmmss}", DateTime.Now);
            //string Pic_Path = (@"E:\巡查系統\Signature\" + CNo + "_sign.jpg");  //萬通
            string Pic_Path = (@"D:\Signature\" + CNo + "_sign.jpg"); //筆電
            using (FileStream fs = new FileStream(Pic_Path, FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(fs))
                {
                    byte[] data = Convert.FromBase64String(imageData);
                    bw.Write(data);
                    bw.Close();
                }
            }
            string sqlstr = @"UPDATE CASEDetail SET " +
           "sign_flag='1', sign_DATE=GETDATE() " +
           "WHERE CNo=@CNo";
            using (IDbConnection db = DBTool.GetConn())
                db.Execute(sqlstr, new { CNo = CNo });

            return JsonConvert.SerializeObject(new { flag = "0", txt = "/Report/Report_001.aspx?seqno=" + CNo + "&view=" + str_view });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { flag = "1", txt = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" + ex });
        }
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string UploadPic3(string imageData, string CNo)
    {
        try
        {
            //string CNo = HttpContext.Current.Session["C_ID_S"].ToString();
            string str_view = HttpContext.Current.Session["view"].ToString();
            string name = string.Format("{0:yyyyMMddHHmmss}", DateTime.Now);
            //string Pic_Path = (@"E:\巡查系統\Signature\" + CNo + "_L_sign.jpg");
            string Pic_Path = (@"D:\Signature\" + CNo + "_L_sign.jpg"); //筆電
            using (FileStream fs = new FileStream(Pic_Path, FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(fs))
                {
                    byte[] data = Convert.FromBase64String(imageData);
                    bw.Write(data);
                    bw.Close();
                }
            }
            string sqlstr = @"UPDATE CASEDetail SET " +
           "L_sign_flag='1', L_sign_DATE=GETDATE()  " +
           "WHERE CNo=@CNo";
            using (IDbConnection db = DBTool.GetConn())
                db.Execute(sqlstr, new { CNo = CNo });

            return JsonConvert.SerializeObject(new { flag = "0", txt = "/Report/Report_001.aspx?seqno=" + CNo + "&view=" + str_view });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { flag = "1", txt = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" + ex });
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string UploadPic5(string imageData, string CNo)
    {
        try
        {
            //string CNo = HttpContext.Current.Session["C_ID_S"].ToString();
            string str_view = HttpContext.Current.Session["view"].ToString();
            string name = string.Format("{0:yyyyMMddHHmmss}", DateTime.Now);
            string Pic_Path = (@"E:\巡查系統\Signature\" + CNo + "_Eva_S_sign.jpg");    //萬通
            //string Pic_Path = (@"D:\Signature\" + CNo + "_Eva_S_sign.jpg");    //筆電
            using (FileStream fs = new FileStream(Pic_Path, FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(fs))
                {
                    byte[] data = Convert.FromBase64String(imageData);
                    bw.Write(data);
                    bw.Close();
                }
            }
            string sqlstr = @"UPDATE CASEDetail SET " +
           "Eva_Sign='1' WHERE CNo=@CNo";

            using (IDbConnection db = DBTool.GetConn())
                db.Execute(sqlstr, new { CNo = CNo });
            return JsonConvert.SerializeObject(new { flag = "0", txt = "/0020010000/0020010008.aspx?seqno=" + CNo });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { flag = "1", txt = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" + ex });
        }
    }

    public class HRM2_Company
    {
        public string SYSID { get; set; }
        public string Company_CName { get; set; }
    }
}