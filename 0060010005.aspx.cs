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
using log4net;
using log4net.Config;

public partial class _0060010005 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //Check();
        }
    }

    public static void Check()
    {
        string Check = JASON.Check_ID("0060010005.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string GetCaseList()
    {
        //Check();
        string Agent_Company = HttpContext.Current.Session["Agent_Company"].ToString();
        string sqlstr = @"SELECT Top 5000 * FROM CaseData order by SetupTime desc";
        var a = DBTool.Query<T_0060010005>(sqlstr).ToList().Select(p => new
        {
            SetupTime = Value2(p.SetupTime),
            Case_ID = Value(p.Case_ID),
            C_ID2 = Value3(p.C_ID2, p.Case_ID),
            BUSINESSNAME = Value(p.BUSINESSNAME),
            Name = Value(p.Name),
            OpinionType = Value(p.OpinionType),
            Handle_Agent = Value(p.Handle_Agent),
            Type = Value(p.Type),
            Agent_Company = Agent_Company
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Client_Code_Search()
    {
        Check();
        string Sqlstr = @"SELECT DISTINCT PID,BUSINESSNAME FROM BusinessData where Type = '保留' order by PID ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            A = p.BUSINESSNAME,
            B = p.PID
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]       //
    public static string SearchCase(string start, string end, string A_N, string D_P, string S_OC, string S_OT, string PID, string Overdue_Type, string S_B_Name)
    {
        //Check();
        string Agent_Company = HttpContext.Current.Session["Agent_Company"].ToString();
        string outputJson = "";
        //string sqlstr = @"SELECT * FROM CaseData WHERE 1=1 ";
        string sqlstr = @"SELECT Top 5000 a.* FROM CaseData a left join BusinessData b on a.PID=b.PID WHERE 1=1 ";
        if (start != ""){
            sqlstr += " AND SetupTime > @start ";  
        } 
        if (end != "") {
            sqlstr += " AND SetupTime < @end ";  
        }
        if (A_N != "") {
            sqlstr += " AND Agent_ID = @Agent_ID ";  
        } 
        if (D_P != ""){
            //sqlstr += " AND Type = @Type ";  
            sqlstr += " AND a.Type = @Type ";  
        }
        if (S_OC != ""){
            sqlstr += " AND OpinionContent LIKE '%'+@OC+'%'  ";  
        }
        if (S_B_Name != "")
        {
            //sqlstr += " AND BUSINESSNAME LIKE '%'+@S_B_Name+'%'  ";
            sqlstr += " AND a.BUSINESSNAME LIKE '%'+@S_B_Name+'%'  ";  
        }
        if (S_OT != ""){
            sqlstr += " AND OpinionType=@SOT ";  
        }
        if (PID != ""){
            //sqlstr += " AND PID=@PID  ";  
            sqlstr += " AND a.PID=@PID  ";  
        }
        if (Overdue_Type == "1")
        {
            //sqlstr += " AND a.Type in('未到點','處理中') AND (CONVERT(varchar, SetupTime+1, 23)<CONVERT(varchar, GETDATE(), 23) "+
            //    " or (CONVERT(varchar, SetupTime, 23)<CONVERT(varchar, GETDATE(), 23)and Urgency in('緊急故障','重要故障')) ) ";
            sqlstr += " AND a.Type in('未到點','處理中') And Urgency not in('','其他') And " +
                "((((Saturday_Work=1 and b.Sunday_Work=1)or DATEPART(WEEKDAY, SetupTime-1)<4 " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=4 and Urgency in('緊急故障','重要故障')) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=4 and Saturday_Work=1) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=5 and Urgency in('緊急故障','重要故障')and Saturday_Work=1) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=7 and Sunday_Work=1) ) and " +
                "  (CONVERT(varchar, SetupTime+1, 23)<CONVERT(varchar, GETDATE(), 23) " +
                "   or (CONVERT(varchar, SetupTime, 23)<CONVERT(varchar, GETDATE(), 23)and Urgency in('緊急故障','重要故障')))) or " +
                " (((DATEPART(WEEKDAY, SetupTime-1)=4 and Urgency not in('緊急故障','重要故障')and Saturday_Work=0 and Sunday_Work=1) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=5 and Saturday_Work=0 and Sunday_Work=1) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=5 and Urgency not in('緊急故障','重要故障')and (Saturday_Work=1 and Sunday_Work=0)) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=6 and ((Saturday_Work=1 and Sunday_Work=0)or(Saturday_Work=0 and Sunday_Work=1))) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=7 and Sunday_Work=0 ))and " +
                "  (CONVERT(varchar, SetupTime+2, 23)<CONVERT(varchar, GETDATE(), 23) " +
                "   or (CONVERT(varchar, SetupTime+1, 23)<CONVERT(varchar, GETDATE(), 23)and Urgency in('緊急故障','重要故障')))) or " +
                " (((DATEPART(WEEKDAY, SetupTime-1)=4 and Urgency not in('緊急故障','重要故障')and Saturday_Work=0 and Sunday_Work=0) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=5 and Saturday_Work=0 and Sunday_Work=0) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=6 and Saturday_Work=0 and Sunday_Work=0))and " +
                "  (CONVERT(varchar, SetupTime+3, 23)<CONVERT(varchar, GETDATE()-0, 23) " +
                "   or(CONVERT(varchar, SetupTime+2, 23)<CONVERT(varchar, GETDATE()-0, 23)and Urgency in('緊急故障','重要故障')) " +
                ")))";
        }
        if (Overdue_Type == "2")
        {
            sqlstr += " AND a.Type in('已結案','已結案已簽核') And Urgency not in('','其他') And " +
                "((((Saturday_Work=1 and b.Sunday_Work=1)or DATEPART(WEEKDAY, SetupTime-1)<4 " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=4 and Urgency in('緊急故障','重要故障')) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=4 and Saturday_Work=1) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=5 and Urgency in('緊急故障','重要故障')and Saturday_Work=1) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=7 and Sunday_Work=1) ) and " +
                "  (CONVERT(varchar, SetupTime+1, 23)<CONVERT(varchar, FinishTime, 23) " +
                "   or (CONVERT(varchar, SetupTime, 23)<CONVERT(varchar, FinishTime, 23)and Urgency in('緊急故障','重要故障')))) or " +
                " (((DATEPART(WEEKDAY, SetupTime-1)=4 and Urgency not in('緊急故障','重要故障')and Saturday_Work=0 and Sunday_Work=1) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=5 and Saturday_Work=0 and Sunday_Work=1) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=5 and Urgency not in('緊急故障','重要故障')and (Saturday_Work=1 and Sunday_Work=0) ) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=6 and ((Saturday_Work=1 and Sunday_Work=0)or(Saturday_Work=0 and Sunday_Work=1)) ) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=7 and Sunday_Work=0 ))and " +
                "  (CONVERT(varchar, SetupTime+2, 23)<CONVERT(varchar, FinishTime, 23) " +
                "   or (CONVERT(varchar, SetupTime+1, 23)<CONVERT(varchar, FinishTime, 23)and Urgency in('緊急故障','重要故障')) )) or " +
                " (((DATEPART(WEEKDAY, SetupTime-1)=4 and Urgency not in('緊急故障','重要故障')and Saturday_Work=0 and Sunday_Work=0) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=5 and Saturday_Work=0 and Sunday_Work=0) " +
                "   or (DATEPART(WEEKDAY, SetupTime-1)=6 and Saturday_Work=0 and Sunday_Work=0) ) and " +
                "  (CONVERT(varchar, SetupTime+3, 23)<CONVERT(varchar, FinishTime, 23) or " +
                "   (CONVERT(varchar, SetupTime+2, 23)<CONVERT(varchar, FinishTime, 23)and Urgency in('緊急故障','重要故障') ) " +
                "))) ";
        }
        if (Overdue_Type == "3")
        {
            sqlstr += " AND Patch_Finish_Reason like'%假日補單%' ";
        }
        if (Overdue_Type == "4")
        {
            sqlstr += " AND Patch_Finish_Reason like'%未準時登記%' ";
        }
        if (Overdue_Type == "5")
        {
            sqlstr += " AND Patch_Finish_Reason not like'%假日補單%'and Patch_Finish_Reason not like'%未準時登記%' ";
        }
        //else return JsonConvert.SerializeObject(new { status = "逾期類別 錯誤" });            


        sqlstr += " Order by  SetupTime Desc ";
        var a = DBTool.Query<T_0060010005>(sqlstr, new { start = start, end = end, Agent_ID = A_N, Type = D_P, OC = S_OC, 
            SOT = S_OT, PID = PID, S_B_Name = S_B_Name }).ToList().Select(p => new
                {
                    SetupTime = Value2(p.SetupTime),
                    Case_ID = Value(p.Case_ID),
                    C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    BUSINESSNAME = Value(p.BUSINESSNAME),
                    Name = Value(p.Name),
                    OpinionType = Value(p.OpinionType),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),   
                    Agent_Company = Agent_Company
                });
        outputJson = JsonConvert.SerializeObject(a);

        /*if (!string.IsNullOrEmpty(end))    //有結尾時間
        {
            if (A_N != "" && D_P != "")
            {
                string sqlstr = @"SELECT * FROM CaseData " +
                            "where SetupTime > @start and SetupTime < @end and Agent_ID = @Agent_ID and Type = @Type";
                if (S_OC != "")//
                {
                    sqlstr += " AND OpinionContent LIKE '%'+@OC+'%'  ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                if (S_OT != "")//
                {
                    sqlstr += " AND OpinionType=@SOC ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                if (PID != "")//
                {
                    sqlstr += " AND PID=@PID ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                var a = DBTool.Query<T_0060010005>(sqlstr, new { start = start, end = end, Agent_ID = A_N, Type = D_P, OC = S_OC, SOT = S_OT, PID = PID }).ToList().Select(p => new
                {
                    SetupTime = Value2(p.SetupTime),
                    Case_ID = Value(p.Case_ID),
                    C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    BUSINESSNAME = Value(p.BUSINESSNAME),
                    Name = Value(p.Name),
                    OpinionType = Value(p.OpinionType),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),
                    kind = "第一種"
                    //Agent_Company = Agent_Company
                });
                outputJson = JsonConvert.SerializeObject(a);
            }
            else if (A_N != "" && D_P == "")
            {
                string sqlstr = @"SELECT * FROM CaseData " +
                            "where SetupTime > @start and SetupTime < @end and Agent_ID = @Agent_ID";
                if (S_OC != "")//
                {
                    sqlstr += " AND OpinionContent LIKE '%'+@OC+'%'  ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                if (S_OT != "")//
                {
                    sqlstr += " AND OpinionType=@SOC ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                if (PID != "")//
                {
                    sqlstr += " AND PID=@PID ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                var a = DBTool.Query<T_0060010005>(sqlstr, new { start = start, end = end, Agent_ID = A_N, OC = S_OC, SOT = S_OT, PID = PID }).ToList().Select(p => new
                {
                    SetupTime = Value2(p.SetupTime),
                    Case_ID = Value(p.Case_ID),
                    C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    BUSINESSNAME = Value(p.BUSINESSNAME),
                    Name = Value(p.Name),
                    OpinionType = Value(p.OpinionType),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),
                    kind = "第二種"
                });
                outputJson = JsonConvert.SerializeObject(a);
            }
            else if (A_N == "" && D_P != "")
            {
                string sqlstr = @"SELECT * FROM CaseData " +
                            "where SetupTime > @start and SetupTime < @end and Type = @Type";
                if (S_OC != "")//
                {
                    sqlstr += " AND OpinionContent LIKE @OC  ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                if (S_OT != "")//
                {
                    sqlstr += " AND OpinionType=@SOC ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                if (PID != "")//
                {
                    sqlstr += " AND PID=@PID ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                var a = DBTool.Query<T_0060010005>(sqlstr, new { start = start, end = end, Type = D_P, OC = S_OC, SOT = S_OT, PID = PID }).ToList().Select(p => new
                {
                    SetupTime = Value2(p.SetupTime),
                    Case_ID = Value(p.Case_ID),
                    C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    BUSINESSNAME = Value(p.BUSINESSNAME),
                    Name = Value(p.Name),
                    OpinionType = Value(p.OpinionType),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),
                    kind = "第三種"
                });
                outputJson = JsonConvert.SerializeObject(a);
            }
            else
            {
                string sqlstr = @"SELECT * FROM CaseData " +
                                            "where SetupTime > @start and SetupTime < @end  ";
                if (S_OC != "")//
                {
                    sqlstr += " AND OpinionContent LIKE '%'+@OC+'%'  ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                if (S_OT != "")//
                {
                    sqlstr += " AND OpinionType=@SOC ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                if (PID != "")//
                {
                    sqlstr += " AND PID=@PID ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                var a = DBTool.Query<T_0060010005>(sqlstr, new { start = start, end = end, OC = S_OC, SOT = S_OT, PID = PID }).ToList().Select(p => new
                {
                    SetupTime = Value2(p.SetupTime),
                    Case_ID = Value(p.Case_ID),
                    C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    BUSINESSNAME = Value(p.BUSINESSNAME),
                    Name = Value(p.Name),
                    OpinionType = Value(p.OpinionType),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),
                    kind = "第四種"
                });
                outputJson = JsonConvert.SerializeObject(a);
            }
        }

        else
        {
            if (A_N != "" && D_P != "") 
            {
                string sqlstr = @"SELECT * FROM CaseData " +
                                "where SetupTime > @start and Agent_ID = @Agent_ID and Type = @Type";
                if (S_OC != "")//
                {
                    sqlstr += " AND OpinionContent LIKE '%'+@OC+'%'  ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                var a = DBTool.Query<T_0060010005>(sqlstr, new { start = start, end = end, Agent_ID = A_N, Type = D_P, OC = S_OC }).ToList().Select(p => new
                {
                    SetupTime = Value2(p.SetupTime),
                    Case_ID = Value(p.Case_ID),
                    C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    BUSINESSNAME = Value(p.BUSINESSNAME),
                    Name = Value(p.Name),
                    OpinionType = Value(p.OpinionType),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),
                    kind = "第五種"
                });
                outputJson = JsonConvert.SerializeObject(a);
            }
            else if (A_N != "" && D_P == "") 
            {
                string sqlstr = @"SELECT * FROM CaseData " +
                                    "where SetupTime > @start and Agent_ID = @Agent_ID ";
                if (S_OC != "")//
                {
                    sqlstr += " AND OpinionContent LIKE '%'+@OC+'%'  ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                var a = DBTool.Query<T_0060010005>(sqlstr, new { start = start, end = end, Agent_ID = A_N, Type = D_P, OC = S_OC }).ToList().Select(p => new
                {
                    SetupTime = Value2(p.SetupTime),
                    Case_ID = Value(p.Case_ID),
                    C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    BUSINESSNAME = Value(p.BUSINESSNAME),
                    Name = Value(p.Name),
                    OpinionType = Value(p.OpinionType),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),
                    kind = "第六種"
                });
                outputJson = JsonConvert.SerializeObject(a);
            }
            else if (A_N == "" && D_P != "") 
            {
                string sqlstr = @"SELECT * FROM CaseData " +
                                    "where SetupTime > @start and Type = @Type";
                if (S_OC != "")//
                {
                    sqlstr += " AND OpinionContent LIKE '%'+@OC+'%'  ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                var a = DBTool.Query<T_0060010005>(sqlstr, new { start = start, end = end, Agent_ID = A_N, Type = D_P, OC = S_OC }).ToList().Select(p => new
                {
                    SetupTime = Value2(p.SetupTime),
                    Case_ID = Value(p.Case_ID),
                    C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    BUSINESSNAME = Value(p.BUSINESSNAME),
                    Name = Value(p.Name),
                    OpinionType = Value(p.OpinionType),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),
                    kind = "第七種"
                });
                outputJson = JsonConvert.SerializeObject(a);
            }
            else
            {
                string sqlstr = @"SELECT * FROM CaseData " +
                                "where SetupTime > @start ";
                if (S_OC != "")//
                {
                    sqlstr += " AND OpinionContent LIKE '%'+@OC+'%'  ";  // AND Service_ID_HM= '1' and Finish_Flag != '1' 
                }
                var a = DBTool.Query<T_0060010005>(sqlstr, new { start = start, end = end, OC = S_OC }).ToList().Select(p => new
                {
                    SetupTime = Value2(p.SetupTime),
                    Case_ID = Value(p.Case_ID),
                    C_ID2 = Value3(p.C_ID2, p.Case_ID),
                    BUSINESSNAME = Value(p.BUSINESSNAME),
                    Name = Value(p.Name),
                    OpinionType = Value(p.OpinionType),
                    Handle_Agent = Value(p.Handle_Agent),
                    Type = Value(p.Type),
                    kind = "第八種"
                });
                outputJson = JsonConvert.SerializeObject(a);
            }
        }//*/
        
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]

    public static string URL(string Case_ID)
    {
        //Check();
        //PID = PID.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(Case_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error + "_1" });
        }

        string str_url = "../0030010097.aspx?seqno=" + Case_ID;         //打開0060010000 並放入同PID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)] 
    public static string URL2(string Case_ID)
    {
        //Check();
        //PID = PID.Trim();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        if (JASON.IsInt(Case_ID) != true)
        {
            return JsonConvert.SerializeObject(new { status = error + "_1" });
        }

        string str_url = "../0030010099.aspx?seqno=" + Case_ID;         //打開0060010000 並放入同PID號的資料
        return JsonConvert.SerializeObject(new { status = str_url, type = "ok" });
    }    
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_PROGLIST(string ROLE_ID)
    {
        //Check();
        string sqlstr = "";
        string outputJson = "";

        //============= 驗證 權限代碼有無被竄改 =============
        sqlstr = @"SELECT TOP 1 * FROM ROLELIST WHERE ROLE_ID=@ROLE_ID";
        var chk = DBTool.Query<CMS_0060010000>(sqlstr, new { ROLE_ID = ROLE_ID });
        if (!chk.Any())
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { TREE_ID = "NULL" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        //============= 驗證 權限代碼有無被竄改 =============

        sqlstr = @"select case when c.TREE_Name is null then a.TREE_NAME else c.TREE_NAME end  as M_TREE_NAME,a.TREE_ID , a.TREE_NAME ," +
           " Case when b.Tree_ID is not null then '1' else '0' end as NowStatus ,d.Agent_Name , b.UpDateDate " +
           " FROM ( select * from PROGLIST where NAVIGATE_URL is not null and LTRIM(NAVIGATE_URL) <> '' and IS_OPEN='Y') as a " +
           " Left join ROLEPROG b on b.Role_ID = @Role_ID and a.TREE_ID = b.TREE_ID and IS_OPEN = 'Y' " +
           " Left join (select * from PROGLIST where (PARENT_ID is not null and LTRIM(PARENT_ID) <> '') " +
           " and (NAVIGATE_URL is  null or LTRIM(NAVIGATE_URL) = '') ) as c on a.PARENT_ID = c.TREE_ID " +
           " Left join DispatchSystem as d on d.Agent_ID = b.UpDateUser " +
           " order by c.sort_id , a.sort_id ";
        var a = DBTool.Query<CMS_0060010000>(sqlstr, new { ROLE_ID = ROLE_ID }).ToList().Select(p => new
        {
            TREE_ID = p.TREE_ID,
            M_TREE_NAME = p.M_TREE_NAME,
            TREE_NAME = p.TREE_NAME,
            Agent_Name = p.Agent_Name,
            UpDateDate = p.UpDateDate,
            NowStatus = p.NowStatus
        });
        outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    // 預定修改執行部分
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Data(string PID)                                                       // 新增 讀CaseData 案件資料
    {
        //Check();
        //string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        //string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string sqlstr = @"SELECT * FROM BusinessData WHERE PID=@PID";
        //string outputJson = "";
        var lcd = DBTool.Query<ClassTemplate>(sqlstr, new { PID = PID }).ToList().Select(p => new
        {
            PID = PID,
            BUSINESSNAME = p.BUSINESSNAME,
            BUSINESSID = p.BUSINESSID,
            ID = p.ID,
            //BUS_CREATE_DATE = Value2(p.BUS_CREATE_DATE),
            APPNAME = p.APPNAME,                                APP_SUBTITLE = p.APP_SUBTITLE,
            APP_MTEL = p.APP_MTEL,                              APP_EMAIL = p.APP_EMAIL,
            APPNAME_2 = p.APPNAME_2,                        APP_SUBTITLE_2 = p.APP_SUBTITLE_2,
            APP_MTEL_2 = p.APP_MTEL_2,                      APP_EMAIL_2 = p.APP_EMAIL_2,
            REGISTER_ADDR = p.REGISTER_ADDR,        CONTACT_ADDR = p.CONTACT_ADDR,
            APP_OTEL = p.APP_OTEL,                              APP_FTEL = p.APP_FTEL,
            INVOICENAME = p.INVOICENAME,
            Inads = Value(p.Inads),
            HardWare = Value(p.HardWare),
            SoftwareLoad = Value(p.SoftwareLoad),
            Mail_Type = Value(p.Mail_Type),
            OE_Number = Value(p.OE_Number),
            SalseAgent = Value(p.SalseAgent),
            Salse = Value(p.Salse),
            Salse_TEL = p.Salse_TEL,                                SID = p.SID,
            Serial_Number = p.Serial_Number,            License_Host = p.License_Host,
            Licence_Name = p.Licence_Name,              LAC = p.LAC,
            Our_Reference = p.Our_Reference,            Your_Reference = p.Your_Reference,
            Auth_File_ID = p.Auth_File_ID,                    Telecomm_ID = p.Telecomm_ID,
            FL = p.FL,                                                         Group_Name_ID = p.Group_Name_ID,
            SED = p.SED,                                                    SERVICEITEM = p.SERVICEITEM,
            Warranty_Date = Value2(p.Warranty_Date),
            Warr_Time = Value(p.Warr_Time),
            Protect_Date = Value2(p.Protect_Date),
            Prot_Time = Value(p.Prot_Time),
            Receipt_Date = Value2(p.Receipt_Date),                  Receipt_PS = p.Receipt_PS,
            Close_Out_Date = Value2(p.Close_Out_Date),        Close_Out_PS = p.Close_Out_PS,
            Account_PS = p.Account_PS,                       Information_PS = p.Information_PS,
            SetupDate = Value2(p.SetupDate)                           
            // 共讀取 49 個

            //H = p.HardWare.Trim(),      // 硬體   .Trim() 去除資料後方多餘的空白
        });

        string outputJson = JsonConvert.SerializeObject(lcd);
        return outputJson;
    }

    public static string Value(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
        }
        return value;
    }
    public static string Value2(string value)        // 當值為null時跳過  非 null 時改時間格式
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = DateTime.Parse(value).ToString("yyyy/MM/dd HH:mm");
        }
        return value;
    }
    public static string Value3(string value, string value2)        // 當value值為""  非 value=value2
    {
        if (string.IsNullOrEmpty(value))
        {
            value = value2.Trim();
        }
        else
            value = value.Trim();
        return value;
    }
    public static string Test(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
            if (value == "1900/01/01 12:00")
            {
                value = "";
            }
        }
        return value;
    }
    /*
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check_Menu(string Flag, string TREE_ID, string ROLE_ID)
    {
        Check();
        string Agent_ID = HttpContext.Current.Session["UserID"].ToString();
        if (Flag.Length > 1)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }

        if (TREE_ID.Length > 10)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }

        if (ROLE_ID.Length > 10)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
        string sqlstr = "";

        //============= 驗證 權限代碼有無被竄改 =============
        sqlstr = @"SELECT TOP 1 * FROM ROLELIST WHERE ROLE_ID=@ROLE_ID";
        var chk = DBTool.Query<CMS_0060010000>(sqlstr, new { ROLE_ID = ROLE_ID });
        if (!chk.Any())
        {
            return JsonConvert.SerializeObject(new { status = "無此系統參數，請再嘗試或詢問管理人員，謝謝。" });
        }
        //============= 驗證 權限代碼有無被竄改 =============

        //============= 驗證 選單編號有無被竄改 =============
        sqlstr = @"SELECT TOP 1 * FROM PROGLIST WHERE TREE_ID=@TREE_ID";
        chk = DBTool.Query<CMS_0060010000>(sqlstr, new { TREE_ID = TREE_ID });
        if (!chk.Any())
        {
            return JsonConvert.SerializeObject(new { status = "無此系統參數，請再嘗試或詢問管理人員，謝謝。" });
        }
        //============= 驗證 選單編號有無被竄改 =============

        if (Flag == "1")
        {
            sqlstr = @"DELETE FROM ROLEPROG WHERE Role_ID=@ROLE_ID AND TREE_ID=@TREE_ID";
            Flag = "系統選單關閉完成。";
        }
        else
        {
            sqlstr = @"INSERT INTO ROLEPROG ( Role_ID, TREE_ID, UpDateUser, UpDateDate ) VALUES(@ROLE_ID, @TREE_ID, @Agent_ID, @DateTime)";
            Flag = "系統選單開啟完成。";
        }

        try
        {
            using (IDbConnection conn = DBTool.GetConn())
            {
                conn.Execute(sqlstr, new { TREE_ID = TREE_ID, ROLE_ID = ROLE_ID, Agent_ID = Agent_ID, DateTime = DateTime.Now });
            }
            return JsonConvert.SerializeObject(new { status = Flag });
        }
        catch (Exception err)
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
    }   */

    //============= 建新資料用=============    

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Safe(int Flag,  string Warranty_Date, string Protect_Date,  //string BUS_CREATE_DATE,
        string Receipt_Date, string Close_Out_Date, string SetupDate, string UpDateDate, string BUSINESSNAME, 
        string ID, string BUSINESSID, string APPNAME, string APP_SUBTITLE, string APP_MTEL, 
        string APP_EMAIL, string APPNAME_2, string APP_SUBTITLE_2, string APP_MTEL_2, string APP_EMAIL_2, 
        string REGISTER_ADDR, string CONTACT_ADDR, string APP_OTEL, string APP_FTEL, string INVOICENAME, 
        string Inads, string HardWare, string SoftwareLoad, string Mail_Type, string OE_Number, 
        string SalseAgent, string Salse, string Salse_TEL, string SID, string Serial_Number, 
        string License_Host, string Licence_Name, string LAC, string Our_Reference, string Your_Reference, 
        string Auth_File_ID, string Telecomm_ID, string FL, string Group_Name_ID, string SED, 
        string SERVICEITEM, string Warr_Time, string Prot_Time, string Receipt_PS, string Close_Out_PS, 
        string Account_PS, string Information_PS )   
    {       
        string status;
        string Sqlstr = "";
        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 * FROM BusinessData WHERE BUSINESSNAME=@BUSINESSNAME and ID = @ID";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                ID = ID,                
                BUSINESSNAME = BUSINESSNAME
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有相同的客戶名稱與統編。" });
            };
            Sqlstr = @"INSERT INTO BusinessData (BUSINESSNAME, BUSINESSID, ID,  APPNAME, APP_SUBTITLE, APP_MTEL, APP_EMAIL, APPNAME_2, APP_SUBTITLE_2 ,  " +    //BUS_CREATE_DATE,
                " APP_MTEL_2, APP_EMAIL_2, REGISTER_ADDR, CONTACT_ADDR , APP_OTEL, APP_FTEL , INVOICENAME, Inads, HardWare, SoftwareLoad, " +
                " Mail_Type, OE_Number, SalseAgent, Salse, Salse_TEL, SID, Serial_Number, License_Host, Licence_Name, LAC,  " +
                " Our_Reference, Your_Reference, Auth_File_ID,Telecomm_ID, FL, Group_Name_ID, SED, SERVICEITEM,  Warranty_Date, Warr_Time,   " +
                " Protect_Date, Prot_Time, Receipt_Date, Receipt_PS, Close_Out_Date, Close_Out_PS, Account_PS, Information_PS, UpDateDate, SetupDate) " +
                " VALUES (@BUSINESSNAME, @BUSINESSID, @ID,  @APPNAME, @APP_SUBTITLE, @APP_MTEL, @APP_EMAIL, @APPNAME_2, @APP_SUBTITLE_2 , " +  //@BUS_CREATE_DATE,
                " @APP_MTEL_2, @APP_EMAIL_2, @REGISTER_ADDR, @CONTACT_ADDR , @APP_OTEL, @APP_FTEL , @INVOICENAME, @Inads, @HardWare, @SoftwareLoad, " +
                " @Mail_Type, @OE_Number, @SalseAgent, @Salse, @Salse_TEL, @SID, @Serial_Number, @License_Host, @Licence_Name, @LAC,  " +
                " @Our_Reference, @Your_Reference, @Auth_File_ID, @Telecomm_ID, @FL, @Group_Name_ID, @SED, @SERVICEITEM, @Warranty_Date, @Warr_Time, " +
                " @Protect_Date, @Prot_Time, @Receipt_Date, @Receipt_PS, @Close_Out_Date, @Close_Out_PS, @Account_PS, @Information_PS, @UpDateDate, @SetupDate)";
                //共50個    
            status = "new";

            a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                BUSINESSNAME = BUSINESSNAME,
                BUSINESSID = BUSINESSID,
                ID = ID,
                //BUS_CREATE_DATE = BUS_CREATE_DATE,               
                APPNAME = APPNAME,
                APP_SUBTITLE = APP_SUBTITLE,
                APP_MTEL = APP_MTEL,
                APP_EMAIL,
                APPNAME_2 = APPNAME_2,
                APP_SUBTITLE_2 = APP_SUBTITLE_2,        //第10
                APP_MTEL_2 = APP_MTEL_2,
                APP_EMAIL_2 = APP_EMAIL_2,
                REGISTER_ADDR = REGISTER_ADDR,
                CONTACT_ADDR = CONTACT_ADDR,
                APP_OTEL = APP_OTEL,
                APP_FTEL = APP_FTEL,
                INVOICENAME = INVOICENAME,
                Inads = Inads,
                HardWare = HardWare,
                SoftwareLoad = SoftwareLoad,        //第20
                Mail_Type = Mail_Type,
                OE_Number = OE_Number,
                SalseAgent = SalseAgent,
                Salse = Salse,
                Salse_TEL = Salse_TEL,
                SID = SID,
                Serial_Number = Serial_Number,
                License_Host = License_Host,
                Licence_Name = Licence_Name,
                LAC = LAC,          //第30
                Our_Reference = Our_Reference,
                Your_Reference = Your_Reference,
                Auth_File_ID = Auth_File_ID,
                Telecomm_ID = Telecomm_ID,
                FL = FL,
                Group_Name_ID = Group_Name_ID,
                SED = SED,
                SERVICEITEM = SERVICEITEM,
                Warranty_Date = Test(Warranty_Date),
                Warr_Time = Warr_Time,          //第40
                Protect_Date = Test(Protect_Date),
                Prot_Time = Test(Prot_Time),
                Receipt_Date = Test(Receipt_Date),
                Receipt_PS = Receipt_PS,
                Close_Out_Date = Close_Out_Date,
                Close_Out_PS = Close_Out_PS,
                Account_PS = Account_PS,
                Information_PS = Information_PS,
                UpDateDate = Test(UpDateDate), 
                SetupDate = Test(SetupDate),
            });

            //return JsonConvert.SerializeObject(new { status = "檢查中" });
        }        
        else
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝01。" });
        }

 /*     try
        {
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                //ROLE_ID = ROLE_ID,
                //ROLE_NAME = ROLE_NAME,
                //UpDateUser = HttpContext.Current.Session["UserIDNAME"].ToString(),
                //UpDateDate = DateTime.Now
            });
        }       //
        catch
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝02。" });
        }   //*/

        return JsonConvert.SerializeObject(new { status = status });        // */
    }

    //============= 修改客戶資料 (Flag = 1)=============    
    
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string New(int Flag, string PID,  string Warranty_Date, string Protect_Date,   //string BUS_CREATE_DATE,
        string Receipt_Date, string Close_Out_Date, string UpDateDate, string BUSINESSNAME, string ID,
        string BUSINESSID, string APPNAME, string APP_SUBTITLE, string APP_MTEL, string APP_EMAIL, 
        string APPNAME_2, string APP_SUBTITLE_2, string APP_MTEL_2, string APP_EMAIL_2, string REGISTER_ADDR, 
        string CONTACT_ADDR, string APP_OTEL, string APP_FTEL, string INVOICENAME, string Inads, 
        string HardWare, string SoftwareLoad, string Mail_Type, string OE_Number, string SalseAgent, 
        string Salse, string Salse_TEL, string SID, string Serial_Number, string License_Host, 
        string Licence_Name, string LAC, string Our_Reference, string Your_Reference, string Auth_File_ID, 
        string Telecomm_ID, string FL, string Group_Name_ID, string SED, string SERVICEITEM, 
        string Warr_Time, string Prot_Time, string Receipt_PS, string Close_Out_PS, string Account_PS, 
        string Information_PS)   //共51個  DateTime SetupDate,
    {
        //Check();
        //return BUSINESSNAME;
        PID = PID.Trim();
        string status;
        string Sqlstr = "";
        if (Flag == 0)
        {
            Sqlstr = @"SELECT TOP 1 PID FROM BusinessData WHERE BUSINESSNAME=@BUSINESSNAME and ID=@ID";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new { 
 //               BUS_CREATE_DATE = BUS_CREATE_DATE ,  Warranty_Date = Warranty_Date ,  Protect_Date = Protect_Date ,  
  //              Receipt_Date = Receipt_Date ,  Close_Out_Date = Close_Out_Date ,  SetupDate = SetupDate ,  LoginTime = LoginTime , APPNAME = APPNAME , 
//                APP_SUBTITLE = APP_SUBTITLE , APP_MTEL = APP_MTEL , APP_EMAIL, APPNAME_2 = APPNAME_2 , APP_SUBTITLE_2 = APP_SUBTITLE_2 , APP_MTEL_2 = APP_MTEL_2 , 
//                APP_EMAIL_2 = APP_EMAIL_2 , REGISTER_ADDR = REGISTER_ADDR , CONTACT_ADDR = CONTACT_ADDR , APP_OTEL = APP_OTEL , APP_FTEL = APP_FTEL , 
//                INVOICENAME = INVOICENAME , Inads = Inads , HardWare = HardWare , SoftwareLoad = SoftwareLoad , Mail_Type = Mail_Type, OE_Number=OE_Number, 
//                SalseAgent = SalseAgent , Salse = Salse , Salse_TEL = Salse_TEL , SID = SID , Serial_Number = Serial_Number , License_Host = License_Host , 
//                Licence_Name = Licence_Name, LAC = LAC , Our_Reference = Our_Reference , Your_Reference = Your_Reference , Auth_File_ID = Auth_File_ID , 
//                Telecomm_ID = Telecomm_ID , FL = FL , Group_Name_ID = Group_Name_ID, SED = SED , SERVICEITEM = SERVICEITEM , Warr_Time = Warr_Time , 
 //               Prot_Time = Prot_Time , Receipt_PS = Receipt_PS , Close_Out_PS = Close_Out_PS , Account_PS = Account_PS , Information_PS =Information_PS 
                BUSINESSNAME = BUSINESSNAME, ID = ID
            });
            if (a.Any())
            {
                return JsonConvert.SerializeObject(new { status = "已有相同的客戶名稱與統編。" });
            };
/*
            Sqlstr = @"INSERT INTO ROLELIST (BUSINESSNAME, BUSINESSID, ID, BUS_CREATE_DATE, APPNAME, APP_SUBTITLE, APP_MTEL, APP_EMAIL, APPNAME_2, " +                                   
                " APP_SUBTITLE_2 , APP_MTEL_2, APP_EMAIL_2, REGISTER_ADDR, CONTACT_ADDR , APP_OTEL, APP_FTEL , INVOICENAME, Inads, HardWare, SoftwareLoad, " + 
                " Mail_Type, OE_Number, SalseAgent, Salse, Salse_TEL, SID, Serial_Number, License_Host, Licence_Name, LAC, Our_Reference, Your_Reference, Auth_File_ID, " + 
                " Telecomm_ID, FL, Group_Name_ID, SED, SERVICEITEM,  Warranty_Date, Warr_Time, Protect_Date, Prot_Time, Receipt_Date, Receipt_PS, Close_Out_Date,  " +                    
                " Close_Out_PS, Account_PS, Information_PS, UpDateDate, SetupDate)      VALUES (@BUSINESSNAME, @BUSINESSID, @ID, @BUS_CREATE_DATE, @APPNAME, " +        
                " @APP_SUBTITLE, @APP_MTEL, @APP_EMAIL, @APPNAME_2, @APP_SUBTITLE_2 , @APP_MTEL_2, @APP_EMAIL_2, @REGISTER_ADDR, @CONTACT_ADDR , " +   
                " @APP_OTEL, @APP_FTEL , @INVOICENAME, @Inads, @HardWare, @SoftwareLoad,  @Mail_Type, @OE_Number, @SalseAgent, @Salse, @Salse_TEL,  " + 
                " @SID, @Serial_Number, @License_Host, @Licence_Name, @LAC, @Our_Reference, @Your_Reference, @Auth_File_ID, @Telecomm_ID, @FL, " +                    
                " @Group_Name_ID, @SED, @SERVICEITEM, @Warranty_Date, @Warr_Time, @Protect_Date, @Prot_Time, @Receipt_Date, @Receipt_PS, " +         
                " @Close_Out_Date, @Close_Out_PS, @Account_PS, @Information_PS, @UpDateDate, @SetupDate)";               //*/  //錯誤的 下方才是正確的 update
            status = "new";         
        }
        else if (Flag == 1)
        {            
            Sqlstr = @"UPDATE BusinessData set  BUSINESSNAME = @BUSINESSNAME " +
                ", BUSINESSID = @BUSINESSID, ID = @ID,  APPNAME = @APPNAME, " +  //BUS_CREATE_DATE = @BUS_CREATE_DATE,
                 "APP_SUBTITLE = @APP_SUBTITLE, APP_MTEL = @APP_MTEL, APP_EMAIL = @APP_EMAIL, APPNAME_2 = @APPNAME_2, APP_SUBTITLE_2 = @APP_SUBTITLE_2, " +  //--10
                 "APP_MTEL_2 = @APP_MTEL_2, APP_EMAIL_2 = @APP_EMAIL_2, REGISTER_ADDR = @REGISTER_ADDR, CONTACT_ADDR = @CONTACT_ADDR, APP_OTEL = @APP_OTEL, " +
                 "APP_FTEL = @APP_FTEL, INVOICENAME = @INVOICENAME, Inads = @Inads, HardWare = @HardWare, SoftwareLoad = @SoftwareLoad, " + //--20
                 "Mail_Type = @Mail_Type, OE_Number = @OE_Number, SalseAgent = @SalseAgent, Salse = @Salse, Salse_TEL = @Salse_TEL, " +
                 "SID = @SID, Serial_Number = @Serial_Number, License_Host = @License_Host, Licence_Name = @Licence_Name, LAC = @LAC, " +  //--30
                 "Our_Reference = @Our_Reference, Your_Reference = @Your_Reference, Auth_File_ID = @Auth_File_ID, Telecomm_ID = @Telecomm_ID, FL = @FL, " +
                 "Group_Name_ID = @Group_Name_ID, SED = @SED, SERVICEITEM = @SERVICEITEM, Warranty_Date = @Warranty_Date, Warr_Time = @Warr_Time, " + //--40
                 "Protect_Date = @Protect_Date, 	Prot_Time = @Prot_Time, 	Receipt_Date = @Receipt_Date, Receipt_PS = @Receipt_PS, Close_Out_Date = @Close_Out_Date, " +
                 "Close_Out_PS = @Close_Out_PS, Account_PS = @Account_PS, Information_PS = @Information_PS, UpDateDate = @UpDateDate " + //, SetupDate = @SetupDate
                 "where PID = @PID ";
            status = "update";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                PID = PID,
                BUSINESSNAME = BUSINESSNAME,
                BUSINESSID = BUSINESSID,
                ID = ID,
                //BUS_CREATE_DATE = BUS_CREATE_DATE,
                Warranty_Date = Test(Warranty_Date),
                Protect_Date = Test(Protect_Date),
                Receipt_Date = Test(Receipt_Date),
                Close_Out_Date = Close_Out_Date,
                UpDateDate = UpDateDate,
                APPNAME = APPNAME,                              // 10個
                APP_SUBTITLE = APP_SUBTITLE,
                APP_MTEL = APP_MTEL,
                APP_EMAIL,
                APPNAME_2 = APPNAME_2,
                APP_SUBTITLE_2 = APP_SUBTITLE_2,
                APP_MTEL_2 = APP_MTEL_2,
                APP_EMAIL_2 = APP_EMAIL_2,
                REGISTER_ADDR = REGISTER_ADDR,
                CONTACT_ADDR = CONTACT_ADDR,
                APP_OTEL = APP_OTEL,                            // 20個
                APP_FTEL = APP_FTEL,
                INVOICENAME = INVOICENAME,
                Inads = Inads,
                HardWare = HardWare,
                SoftwareLoad = SoftwareLoad,
                Mail_Type = Mail_Type,
                OE_Number = OE_Number,
                SalseAgent = SalseAgent,
                Salse = Salse,
                Salse_TEL = Salse_TEL,                             // 30個
                SID = SID,
                Serial_Number = Serial_Number,
                License_Host = License_Host,
                Licence_Name = Licence_Name,
                LAC = LAC,
                Our_Reference = Our_Reference,
                Your_Reference = Your_Reference,
                Auth_File_ID = Auth_File_ID,
                Telecomm_ID = Telecomm_ID,
                FL = FL,                                                        // 40 個
                Group_Name_ID = Group_Name_ID,
                SED = SED,
                SERVICEITEM = SERVICEITEM,
                Warr_Time = Warr_Time,
                Prot_Time = Prot_Time,
                Receipt_PS = Receipt_PS,
                Close_Out_PS = Close_Out_PS,
                Account_PS = Account_PS,
                Information_PS = Information_PS
            });
            //  更改不用改   SetupDate = SetupDate ,
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }
/*        try
        {
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                //ROLE_ID = ROLE_ID,
                //ROLE_NAME = ROLE_NAME,
                UpDateUser = HttpContext.Current.Session["UserIDNAME"].ToString(),
                UpDateDate = DateTime.Now
            });
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。" });
        }        // */
        return JsonConvert.SerializeObject(new { status = status });
    }   //  */    

    public class T_0060010005
    {
        public string PID { get; set; }
        public string BUSINESSNAME { get; set; }
        public string BUSINESSID { get; set; }
        public string ID { get; set; }
        public string BUS_CREATE_DATE { get; set; }
        public string APPNAME { get; set; }
        public string APP_SUBTITLE { get; set; }
        public string APP_MTEL { get; set; }
        public string APP_SUBTITLE_2 { get; set; }
        public string APP_EMAIL_2 { get; set; }
        public string REGISTER_ADDR { get; set; }
        public string CONTACT_ADDR { get; set; }
        public string APP_FTEL { get; set; }
        public string INVOICENAME { get; set; }
        public string Inads { get; set; }
        public string Mail_Type { get; set; }
        public string OE_Number { get; set; }
        public string SalseAgent { get; set; }
        public string Salse { get; set; }
        public string Salse_TEL { get; set; }
        public string SID { get; set; }
        public string Serial_Number { get; set; }
        public string License_Host { get; set; }
        public string Licence_Name { get; set; }
        public string LAC { get; set; }
        public string Our_Reference { get; set; }
        public string Your_Reference { get; set; }
        public string Auth_File_ID { get; set; }
        public string FL { get; set; }
        public string Group_Name_ID { get; set; }
        public string SED { get; set; }
        public string Warranty_Date { get; set; }
        public string Warr_Time { get; set; }
        public string Protect_Date { get; set; }
        public string Prot_Time { get; set; }
        public string Receipt_Date { get; set; }
        public string Receipt_PS { get; set; }
        public string Close_Out_Date { get; set; }
        public string Close_Out_PS { get; set; }
        public string Account_PS { get; set; }
        public string Information_PS { get; set; }
        public string SetupDate { get; set; }
        public string Del_Flag { get; set; }
        public string UpdateDate { get; set; }
        //0628 子公司
        public string PNumber { get; set; }
        public string Name { get; set; }
        public string Contac_ADDR { get; set; }

        public string Case_ID { get; set; }
        public string SetupTime { get; set; }
        public string Caller_ID { get; set; }
        public string Creat_Agent { get; set; }
        public string ADDR { get; set; }
        public string Telecomm_ID { get; set; }
        public string APP_EMAIL { get; set; }
        public string SERVICEITEM { get; set; }
        public string APPNAME_2 { get; set; }
        public string ID_2 { get; set; }
        public string APP_MTEL_2 { get; set; }
        public string ADDR_2 { get; set; }
        public string HardWare_2 { get; set; }
        public string SoftwareLoad_2 { get; set; }
        public string Urgency { get; set; }
        public string OnSpotTime { get; set; }
        public string OpinionType { get; set; }
        public string ReplyType { get; set; }
        public string OpinionContent { get; set; }
        public string Handle_Agent { get; set; }
        public string PS { get; set; }
        public string Reply { get; set; }
        public string UploadTime { get; set; }
        public string ReachTime { get; set; }
        public string FinishTime { get; set; }
        public string Agent_ID { get; set; }
        public string Type { get; set; }
        public string Type_Value { get; set; }
        public string C_ID2 { get; set; }
        public string Agent_Company { get; set; }
    }
}
