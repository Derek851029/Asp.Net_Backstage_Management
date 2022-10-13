using Dapper;
using System;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;
using log4net;
using log4net.Config;
using System.IO;

public partial class Report_Report_001 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected string seqno;
    protected void Page_Init(object sender, EventArgs e)
    {
        Check();
        seqno = Request.Params["seqno"];
        Session["CNo"] = Request.Params["seqno"];
        //if (string.IsNullOrEmpty(Request.Params["company"]))
        //    Session["company"] = Request.Params["company"];
        //else
        //    Session["company"] = "0";
        string str_company = Request.Params["company"];
        if (string.IsNullOrEmpty(seqno))
        {
            Response.Redirect("~/0030010000/0030010003.aspx");
        }
        //http://127.0.0.1:5000/Report02/Report_001.aspx?seqno=161130131535020

        string CaseID = Request.Params["seqno"];
        string APPNAME = "APPNAME";
        string APP_MTEL = "APP_MTEL";
        string Cust_Name = "Cust_Name";
        string R_Time = "";
        string F_Time = "";
        string Day = "Day";
        string DEPT_Status = "DEPT_Status";
        string Logo = "Logo";
        string T_ID = "T_ID";
        string A_Ans1 = "";
        string A_Ans2 = "";
        string A_Ans3 = "";
        string A_Ans4 = "";
        string A_Ans5 = "";
        string B_Ans1 = "";
        string B_Ans2 = "";
        string B_Ans3 = "";
        string B_Ans4 = "";
        string B_Ans5 = "";
        string C_Ans1 = "";
        string C_Ans2 = "";
        string C_Ans3 = "";
        string C_Ans4 = "";
        string C_Ans5 = "";
        string D_Ans1 = "";
        string D_Ans2 = "";
        string D_Ans3 = "";
        string D_Ans4 = "";
        string D_Ans5 = "";
        string E_Ans1 = "";
        string E_Ans2 = "";
        string E_Ans3 = "";
        string E_Ans4 = "";
        string E_Ans5 = "";
        string F_Ans1 = "";
        string F_Ans2 = "";
        string F_Ans3 = "";
        string F_Ans4 = "";
        string F_Ans5 = "";
        string G_Ans1 = "";
        string G_Ans2 = "";
        string G_Ans3 = "";
        string G_Ans4 = "";
        string G_Ans5 = "";
        string H_Ans1 = "";
        string H_Ans2 = "";
        string H_Ans3 = "";
        string H_Ans4 = "";
        string H_Ans5 = "";
        string I_Ans1 = "";
        string I_Ans2 = "";
        string I_Ans3 = "";
        string I_Ans4 = "";
        string I_Ans5 = "";
        string J_Ans1 = "";
        string J_Ans2 = "";
        string J_Ans3 = "";
        string J_Ans4 = "";
        string J_Ans5 = "";
        string K_Ans1 = "";
        string K_Ans2 = "";
        string K_Ans3 = "";
        string K_Ans4 = "";
        string K_Ans5 = "";
        string L_Ans1 = "";
        string L_Ans2 = "";
        string L_Ans3 = "";
        string L_Ans4 = "";
        string L_Ans5 = "";
        string Agent_Sign = "";
                
        string sqlstr = "";
        /*sqlstr = @"SELECT Top 1 a.* " +
            ", a.ReachTime as Time_01, a.FinishTime as Time_02, a.Service_DATE as Time_03, b.mission_name as  Cust_Name " +
            "FROM [InSpecation_Dimax].[dbo].[Mission_Case] as a  " +
            "left join [InSpecation_Dimax].[dbo].[Mission_Title] as b on a.Title_ID = b.SYSID  " +
            "left join [DimaxCallcenter].[dbo].[BusinessData] as c on b.PID = c.PID  " +
            "WHERE Case_ID=@Case_ID";   //  只讀取Mission_Case抓答案的 */    
        sqlstr = @"SELECT Top 1 * " +
            ", ReachTime as Time_01, FinishTime as Time_02, Service_DATE as Time_03 " +
            "FROM [InSpecation_Dimax].[dbo].[View_Eva_Case]  " +
            "WHERE Case_ID=@Case_ID";   //  只讀取Mission_Case抓答案的 */    
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { Case_ID = seqno });
        if (list.Any())
        {
            ClassTemplate schedule = list.First();
            Cust_Name = schedule.Cust_Name;
            APPNAME = schedule.APPNAME;
            APP_MTEL = schedule.APP_MTEL;
            A_Ans1 = schedule.A_Ans1;
            A_Ans2 = schedule.A_Ans2;
            A_Ans3 = schedule.A_Ans3;
            A_Ans4 = schedule.A_Ans4;
            A_Ans5 = schedule.A_Ans5;
            B_Ans1 = schedule.B_Ans1;
            B_Ans2 = schedule.B_Ans2;
            B_Ans3 = schedule.B_Ans3;
            B_Ans4 = schedule.B_Ans4;
            B_Ans5 = schedule.B_Ans5;
            C_Ans1 = schedule.C_Ans1;
            C_Ans2 = schedule.C_Ans2;
            C_Ans3 = schedule.C_Ans3;
            C_Ans4 = schedule.C_Ans4;
            C_Ans5 = schedule.C_Ans5;
            D_Ans1 = schedule.D_Ans1;
            D_Ans2 = schedule.D_Ans2;
            D_Ans3 = schedule.D_Ans3;
            D_Ans4 = schedule.D_Ans4;
            D_Ans5 = schedule.D_Ans5;
            E_Ans1 = schedule.E_Ans1;
            E_Ans2 = schedule.E_Ans2;
            E_Ans3 = schedule.E_Ans3;
            E_Ans4 = schedule.E_Ans4;
            E_Ans5 = schedule.E_Ans5;
            F_Ans1 = schedule.F_Ans1;
            F_Ans2 = schedule.F_Ans2;
            F_Ans3 = schedule.F_Ans3;
            F_Ans4 = schedule.F_Ans4;
            F_Ans5 = schedule.F_Ans5;
            G_Ans1 = schedule.G_Ans1;
            G_Ans2 = schedule.G_Ans2;
            G_Ans3 = schedule.G_Ans3;
            G_Ans4 = schedule.G_Ans4;
            G_Ans5 = schedule.G_Ans5;
            H_Ans1 = schedule.H_Ans1;
            H_Ans2 = schedule.H_Ans2;
            H_Ans3 = schedule.H_Ans3;
            H_Ans4 = schedule.H_Ans4;
            H_Ans5 = schedule.H_Ans5;
            I_Ans1 = schedule.I_Ans1;
            I_Ans2 = schedule.I_Ans2;
            I_Ans3 = schedule.I_Ans3;
            I_Ans4 = schedule.I_Ans4;
            I_Ans5 = schedule.I_Ans5;
            J_Ans1 = schedule.J_Ans1;
            J_Ans2 = schedule.J_Ans2;
            J_Ans3 = schedule.J_Ans3;
            J_Ans4 = schedule.J_Ans4;
            J_Ans5 = schedule.J_Ans5;
            K_Ans1 = schedule.K_Ans1;
            K_Ans2 = schedule.K_Ans2;
            K_Ans3 = schedule.K_Ans3;
            K_Ans4 = schedule.K_Ans4;
            K_Ans5 = schedule.K_Ans5;
            L_Ans1 = schedule.L_Ans1;
            L_Ans2 = schedule.L_Ans2;
            L_Ans3 = schedule.L_Ans3;
            L_Ans4 = schedule.L_Ans4;
            L_Ans5 = schedule.L_Ans5;
            T_ID = schedule.Telecomm_ID;
            if (string.IsNullOrEmpty(schedule.ReachTime))
            {
                R_Time = "　　年　月　日　 時　分 ";
            }
            else
            {
                R_Time = schedule.Time_01.ToString("yyyy年MM月dd日 HH時mm分");
            }   //*/
            if (string.IsNullOrEmpty(schedule.FinishTime))
            {
                F_Time = "　　年　月　日　 時　分";
            }
            else
            {
                F_Time = schedule.Time_02.ToString("yyyy年MM月dd日 HH時mm分");
            }   //*/
            if (schedule.Service_Flag == "1")
            {
                Agent_Sign = schedule.Handle_Agent;
            }
            else
            {
                Agent_Sign = "";
            }
        }   //*/

        if (!string.IsNullOrEmpty(T_ID))
        {
            if (T_ID == "中華電信" || T_ID == "德瑪")
            {
                DEPT_Status = "德瑪科技股份有限公司 台北市堤頂大道二段297號8樓 TEL：886-2-7718-8250 FAX：886-2-2657-7739";
                Logo = "Dimax";
            }
            else if (T_ID == "遠傳")
            {
                DEPT_Status = "遠傳電信      台北市內湖區瑞光路218號  TEL：886-2-7718-8250";  //   ■   □
                Logo = "Far";
            }
            else
            {
                DEPT_Status = "";
                Logo = "defaultimage";
            }
        }
        else
        {
            DEPT_Status = "";
            Logo = "defaultimage";
        }

        rptviewer.LocalReport.EnableExternalImages = true;
        rptviewer.LocalReport.ReportPath = Server.MapPath("/Report02/Report_FET.rdlc");
        rptviewer.LocalReport.DataSources.Clear();

        if (str_company != "")
        {
            sqlstr = @"SELECT Top 1 * FROM BusinessData ";
            var list_company = DBTool.Query<HRM2_Company>(sqlstr, new {  });
            if (list_company.Any())
            {
                HRM2_Company schedule = list_company.First();
                //APP_MTEL = schedule.BUSINESSNAME;
            }
        }

        string imagepath = string.Format("{0}", seqno.Trim());
        logger.Info("Signature" + imagepath + ".jpg");
        if (!File.Exists(@"C:\Eva_Signature\" + imagepath + "_sign.jpg"))
        {
            imagepath = "defaultimage";
        }
        string imagepath2 = string.Format("{0}", seqno.Trim());
        logger.Info("Signature" + imagepath2 + ".jpg");
        if (!File.Exists(@"C:\Eva_Signature\" + imagepath2 + "_C_sign.jpg"))
        {
            imagepath2 = "defaultimage";
        }

         CaseID =Request.Params["seqno"];

        Microsoft.Reporting.WebForms.ReportParameter p_1 = new Microsoft.Reporting.WebForms.ReportParameter("Cust_Name", Cust_Name);
        Microsoft.Reporting.WebForms.ReportParameter p_2 = new Microsoft.Reporting.WebForms.ReportParameter("CaseID", CaseID);
        Microsoft.Reporting.WebForms.ReportParameter p_3 = new Microsoft.Reporting.WebForms.ReportParameter("APP_MTEL", APP_MTEL);
        Microsoft.Reporting.WebForms.ReportParameter p_4 = new Microsoft.Reporting.WebForms.ReportParameter("APPNAME", APPNAME);
        Microsoft.Reporting.WebForms.ReportParameter p_5 = new Microsoft.Reporting.WebForms.ReportParameter("ReachTime", R_Time);
        Microsoft.Reporting.WebForms.ReportParameter p_6 = new Microsoft.Reporting.WebForms.ReportParameter("FinishTime", F_Time);
        Microsoft.Reporting.WebForms.ReportParameter p_7 = new Microsoft.Reporting.WebForms.ReportParameter("Model", A_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_8 = new Microsoft.Reporting.WebForms.ReportParameter("Version", A_Ans2);
        Microsoft.Reporting.WebForms.ReportParameter p_9 = new Microsoft.Reporting.WebForms.ReportParameter("Eva_Type", A_Ans3);
        Microsoft.Reporting.WebForms.ReportParameter p_10 = new Microsoft.Reporting.WebForms.ReportParameter("Item1", B_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_11 = new Microsoft.Reporting.WebForms.ReportParameter("Item2", B_Ans2);
        Microsoft.Reporting.WebForms.ReportParameter p_12 = new Microsoft.Reporting.WebForms.ReportParameter("ImagePath", @"C:\Eva_Signature\" + imagepath + "_sign.jpg");
        Microsoft.Reporting.WebForms.ReportParameter p_13 = new Microsoft.Reporting.WebForms.ReportParameter("ImagePath2", @"C:\Eva_Signature\" + imagepath2 + "_C_sign.jpg");
        Microsoft.Reporting.WebForms.ReportParameter p_14 = new Microsoft.Reporting.WebForms.ReportParameter("AVAYA", @"D:\Signature1\AVAYA.png");  //@"C:\DIMAX\images\AVAYA.png"
        Microsoft.Reporting.WebForms.ReportParameter p_15 = new Microsoft.Reporting.WebForms.ReportParameter("Logo", @"D:\Signature1\" + Logo + ".png");    //@"C:\DIMAX\images\" + Logo + ".png"
        Microsoft.Reporting.WebForms.ReportParameter p_16 = new Microsoft.Reporting.WebForms.ReportParameter("Tem", B_Ans3);
        Microsoft.Reporting.WebForms.ReportParameter p_17 = new Microsoft.Reporting.WebForms.ReportParameter("Hum", B_Ans4);
        Microsoft.Reporting.WebForms.ReportParameter p_18 = new Microsoft.Reporting.WebForms.ReportParameter("Item3", C_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_19 = new Microsoft.Reporting.WebForms.ReportParameter("Item4", C_Ans2);
        Microsoft.Reporting.WebForms.ReportParameter p_20 = new Microsoft.Reporting.WebForms.ReportParameter("Item5", D_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_21 = new Microsoft.Reporting.WebForms.ReportParameter("Item6", D_Ans2);
        Microsoft.Reporting.WebForms.ReportParameter p_22 = new Microsoft.Reporting.WebForms.ReportParameter("Item7", E_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_23 = new Microsoft.Reporting.WebForms.ReportParameter("Item8", E_Ans3);
        Microsoft.Reporting.WebForms.ReportParameter p_24 = new Microsoft.Reporting.WebForms.ReportParameter("Item9", F_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_25 = new Microsoft.Reporting.WebForms.ReportParameter("Item10", F_Ans2);
        Microsoft.Reporting.WebForms.ReportParameter p_26 = new Microsoft.Reporting.WebForms.ReportParameter("Item11", G_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_27 = new Microsoft.Reporting.WebForms.ReportParameter("Item12", G_Ans2);
        Microsoft.Reporting.WebForms.ReportParameter p_28 = new Microsoft.Reporting.WebForms.ReportParameter("Item13", H_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_29 = new Microsoft.Reporting.WebForms.ReportParameter("Item14", H_Ans2);
        Microsoft.Reporting.WebForms.ReportParameter p_30 = new Microsoft.Reporting.WebForms.ReportParameter("Item15", I_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_31 = new Microsoft.Reporting.WebForms.ReportParameter("Item16", I_Ans2);
        Microsoft.Reporting.WebForms.ReportParameter p_32 = new Microsoft.Reporting.WebForms.ReportParameter("Item17", J_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_33 = new Microsoft.Reporting.WebForms.ReportParameter("Item18", K_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_34 = new Microsoft.Reporting.WebForms.ReportParameter("Item19", L_Ans1);
        Microsoft.Reporting.WebForms.ReportParameter p_35 = new Microsoft.Reporting.WebForms.ReportParameter("Item20", Agent_Sign);
        Microsoft.Reporting.WebForms.ReportParameter p_36 = new Microsoft.Reporting.WebForms.ReportParameter("Volt", E_Ans2);
        Microsoft.Reporting.WebForms.ReportParameter p_37 = new Microsoft.Reporting.WebForms.ReportParameter("ADDR", DEPT_Status);
        rptviewer.LocalReport.SetParameters(new Microsoft.Reporting.WebForms.ReportParameter[] { p_1, p_2, p_3, p_4, p_5, p_6, p_7, p_8, p_9, p_10, p_11, p_12, p_13, p_14, p_15, p_16, p_17, p_18, p_19, p_20, p_21, p_22, p_23, p_24, p_25, p_26, p_27, p_28, p_29, p_30, p_31, p_32, p_33, p_34, p_35, p_36, p_37 });
        rptviewer.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("View_Service", list));
        rptviewer.LocalReport.Refresh();
    }

    protected void Check()
    {
        string Check = JASON.Check_ID("0020010005.aspx");
        if (Check == "NO")
        {
            //System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    //============= 帶入【仲介】選單 =============
    [WebMethod(EnableSession = true)]
    public static string Company_List()
    {
        string sqlstr = "SELECT * FROM HRM2_Company ORDER BY Company_CName ";
        var a = DBTool.Query<HRM2_Company>(sqlstr).ToList().Select(p => new
        {
            SYSID = p.SYSID,
            Company_CName = p.Company_CName
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    public class HRM2_Company
    {
        public string SYSID { get; set; }
        public string Company_CName { get; set; }
        public string BUSINESSNAME { get; set; }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string UploadPic()
    {
        try
        {
            //string company = HttpContext.Current.Session["company"].ToString();
            //string Pic_Path = (@"118.163.27.22:8080/Signature/" + CNo + "_sign.jpg");
            string CNo = HttpContext.Current.Session["CNo"].ToString();
            string name = string.Format("{0:yyyyMMddHHmmss}", DateTime.Now);
            //string Pic_Path = (@"D:\Signature1\" + CNo + "_sign.jpg");
            /*using (FileStream fs = new FileStream(Pic_Path, FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(fs))
                {
                    byte[] data = Convert.FromBase64String(imageData);
                    bw.Write(data);
                    bw.Close();
                }
            }   // 這段產生了錯誤 */  

            string sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Case] SET " +   //工程師簽名後改 Service_Flag 此案件不再被下載
           "Service_Flag='1', Service_DATE=GETDATE() " +    
           "WHERE Case_ID=@Case_ID";

            using (IDbConnection db = DBTool.GetConn())
                db.Execute(sqlstr, new { Case_ID = CNo });

            /*sqlstr = @"insert into  CASEDetail (CNo, Service_DATE, Service_Flag) " +   //移除案件測試
           "Values(@Case_ID, GETDATE(), '1') ";

            using (IDbConnection db = DBTool.GetConn())
                db.Execute(sqlstr, new { Case_ID = CNo });  //*/

            return JsonConvert.SerializeObject(new { flag = "0", txt = "/Report02/Report_FET.aspx?seqno=" + CNo });//+ CNo + "&company=" + company 
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { flag = "1", txt = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" + ex });
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string UploadPic_C(string imageData)
    {
        try
        {
            string CNo = HttpContext.Current.Session["CNo"].ToString();
            //string company = HttpContext.Current.Session["company"].ToString();
            string name = string.Format("{0:yyyyMMddHHmmss}", DateTime.Now);
            string Pic_Path = (@"C:\Eva_Signature\" + CNo + "_C_sign.jpg");
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

            return JsonConvert.SerializeObject(new { flag = "0", txt = "/Report02/Report_FET.aspx?seqno=" + CNo + "&company="  });// + company
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { flag = "1", txt = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" + ex });
        }
    }    

    public static string Value(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
        }
        return value;
    }

    public class Report_FET
    {
        public string Alphabet { get; set; }
        public string equipment_Ans1 { get; set; }
        public string equipment_Ans2 { get; set; }
        public string equipment_Ans3 { get; set; }
        public string equipment_Ans4 { get; set; }
        public string equipment_Ans5 { get; set; }
    }
}