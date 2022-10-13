using Dapper;
using Newtonsoft.Json;
using System;
using System.IO;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using log4net;
using log4net.Config;

public partial class _0250010002 : System.Web.UI.Page
{
    protected string seqno = "";
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        seqno = Request.Params["seqno"];
        if (string.IsNullOrEmpty(seqno))
        {
            Response.Redirect("/0250010001.aspx");
        }
        else
        {
            //Session["SYSID"] = seqno; //其它頁也會寫入 SYSID 導致錯誤
            Session["SYSID25002"] = seqno;
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Update_Location(int[] Top, int[] Left)
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string ID = HttpContext.Current.Session["SYSID25002"].ToString();
        string[] Alphabet = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L" };
        string sql = "UPDATE InSpecation.dbo.Mission_List SET equipment_X=@Top, equipment_Y=@Left WHERE ID=@ID AND Alphabet=@Alphabet ";
        if (Top.Length == 12 && Left.Length == 12)
        {
            for (int i = 0; i < 12; i++)
            {
                if (Top[i] > 999 || Left[i] > 999)
                {
                    return error;
                }

                var a = DBTool.Query<Value_0250010002>(sql, new { ID = ID, Top = Top[i], Left = Left[i], Alphabet = Alphabet[i] });
            }
            return "檢查點位置修改完成。";
        }
        else
        {
            return error;
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Update_Question(string sysid, string alphabet, string title, string[] question, string[] option, int[] type)
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        //string id = HttpContext.Current.Session["SYSID25002"].ToString();
        string id = sysid;
        int i = 0;
        int txt_Length = 0;

        //檢查 檢查點編號 參數是否正確
        if (!new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L" }.Contains(alphabet))
        {
            return JsonConvert.SerializeObject(new { status = error+"1", Flag = "0" });
        }

        //檢查 陣列數量是否正確
        if (question.Length == 5 && option.Length == 5 && type.Length == 5)
        {
            //檢查 回答類型 參數是否正確
            for (i = 0; i < 5; i++)
            {
                if (type[i] < 0 || type[i] > 6)
                {
                    return JsonConvert.SerializeObject(new { status = error + " type 值錯誤", Flag = "0" });
                }
            }

            //檢查 地點名稱 參數是否正確
            title = title.Trim();
            if (title.Length > 25 || title.Length < 1)
            {
                return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet + "】的【地點名稱】不能空白或超過２５個字元。", Flag = "0" });
            }
            else
            {
                i = title.Length;
                title = HttpUtility.HtmlEncode(title);
                if (title.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error + "3", Flag = "0" });
                }
            }

            //檢查 檢查內容 參數是否正確
            for (i = 0; i < 5; i++)
            {
                if (question[i].Length > 500)
                {
                    i++;
                    return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet + "】的【" + i + ". 檢查內容】不能超過５００個字元。", Flag = "0" });
                }
                else
                {
                    question[i] = question[i].Trim();
                    txt_Length = question[i].Length;
                    question[i] = HttpUtility.HtmlEncode(question[i]);
                    if (question[i].Length != txt_Length)
                    {
                        i++;
                        return JsonConvert.SerializeObject(new { status = "【" + i + ". 檢查內容】" + error + "4", Flag = "0" });
                    }
                }
            }

            //檢查 回答內容單位 參數是否正確
            for (i = 0; i < 5; i++)
            {
                if (option[i].Length > 2)
                {
                    i++;
                    return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet + "】的【" + i + ". 回答內容】單位不能超過２個字元。", Flag = "0" });
                }
            }

            //====================================================================

            string sql = "UPDATE InSpecation_Dimax.dbo.Mission_List SET "
                + " equipment_name=@name, "
                + " equipment_type1=@type1, equipment_question1=@question1, equipment_Option1=@Option1, "
                + " equipment_type2=@type2, equipment_question2=@question2, equipment_Option2=@Option2, "
                + " equipment_type3=@type3, equipment_question3=@question3, equipment_Option3=@Option3, "
                + " equipment_type4=@type4, equipment_question4=@question4, equipment_Option4=@Option4, "
                + " equipment_type5=@type5, equipment_question5=@question5, equipment_Option5=@Option5 "
                //+ " equipment_type6=@type6, equipment_question6=@question6, equipment_Option6=@Option6 "
                //+ " equipment_type7=@type7, equipment_question7=@question7, equipment_Option7=@Option7 "
                //+ " equipment_type8=@type8, equipment_question8=@question8, equipment_Option8=@Option8 "
                //+ " equipment_type9=@type9, equipment_question9=@question9, equipment_Option9=@Option9 "
                //+ " equipment_type10=@type10, equipment_question10=@question10, equipment_Option10=@Option10 "
                //+ " equipment_type11=@type11, equipment_question11=@question11, equipment_Option11=@Option11 "
                //+ " equipment_type12=@type12, equipment_question12=@question12, equipment_Option12=@Option12 "
                + " WHERE ID=@ID AND Alphabet=@Alphabet ";

            DBTool.Query<Value_0250010002>(sql, new
            {
                ID = id,
                Alphabet = alphabet,
                name = title,
                type1 = type[0],
                type2 = type[1],
                type3 = type[2],
                type4 = type[3],
                type5 = type[4],
                /*type6 = type[5],
                type7 = type[6],
                type8 = type[7],
                type9 = type[8],
                type10 = type[9],
                type11 = type[10],
                type12 = type[11],*/    
                question1 = question[0],
                question2 = question[1],
                question3 = question[2],
                question4 = question[3],
                question5 = question[4],
                /*question6 = question[5],
                question7 = question[6],
                question8 = question[7],
                question9 = question[8],
                question10 = question[9],
                question11 = question[10],
                question12 = question[11],*/
                Option1 = option[0],
                Option2 = option[1],
                Option3 = option[2],
                Option4 = option[3],
                Option5 = option[4],
                /*Option6 = option[5],
                Option7 = option[6],
                Option8 = option[7],
                Option9 = option[8],
                Option10 = option[9],
                Option11 = option[10],
                Option12 = option[11],*/
            });
            return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet + "】內容修改完成" + id , Flag = "1" });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = error + "5", Flag = "0" });
        }
    }

    public static string Check_Value(string value, int Max, int Min)
    {
        return value;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Update_Title(string sysid, string PID, string T_ID, string ADDR,    //string PID2, 
        string Name, string MTEL, string CycleTime, string Agent, string C_Name,
        string C_1, string C_2, string C_3, string C_4, string C_5, string C_6, string C_7, string C_8, string C_9, string C_10, string C_11, string C_12
        )
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        //string SYSID = HttpContext.Current.Session["SYSID25002"].ToString();
        string SYSID = sysid;
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        int i = 0;

        //===========================================================
        if (String.IsNullOrEmpty(PID))
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【客戶】", Flag = "0" });
        }
        //===========================================================
        if (!String.IsNullOrEmpty(C_Name))
        {
            i = Name.Length;
            if (Name.Length > 50)
            {
                return JsonConvert.SerializeObject(new { status = "【客戶名稱】不能超過５０個字元。", Flag = "0" });
            }
            else
            {
                Name = HttpUtility.HtmlEncode(Name.Trim());
                if (Name.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【客戶名稱】", Flag = "0" });
        }
        //==========================================================
        if (!String.IsNullOrEmpty(T_ID))
        {
            if (!new string[] { "中華電信", "遠傳", "德瑪", "其他" }.Contains(T_ID))
            {
                return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【維護廠商】", Flag = "0" });
        }
        //==========================================================
        if (!String.IsNullOrEmpty(ADDR))
        {
            i = ADDR.Length;
            if (ADDR.Length > 200)
            {
                return JsonConvert.SerializeObject(new { status = "【維護地址】不能超過２００個字元。", Flag = "0" });
            }
            else
            {
                ADDR = HttpUtility.HtmlEncode(ADDR.Trim());
                if (ADDR.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【維護地址】", Flag = "0" });
        }
        //===========================================================
        if (!String.IsNullOrEmpty(Name))
        {
            i = Name.Length;
            if (Name.Length > 15)
            {
                return JsonConvert.SerializeObject(new { status = "【聯絡人】不能超過１５個字元。", Flag = "0" });
            }
            else
            {
                Name = HttpUtility.HtmlEncode(Name.Trim());
                if (Name.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【聯絡人】", Flag = "0" });
        }
        //===========================================================
        if (!String.IsNullOrEmpty(MTEL))
        {
            i = MTEL.Length;
            if (MTEL.Length > 25)
            {
                return JsonConvert.SerializeObject(new { status = "【聯絡電話】不能超過２５個字元。", Flag = "0" });
            }
            else
            {
                MTEL = HttpUtility.HtmlEncode(MTEL.Trim());
                if (MTEL.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
                }
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請填寫【聯絡電話】", Flag = "0" });
        }
        //==========================================================
        if (!String.IsNullOrEmpty(CycleTime))
        {
            if (!new string[] { "0", "1", "2", "3", "4", "5" }.Contains(CycleTime))
            {
                return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【巡查週期】", Flag = "0" });
        }
        //===========================================================
        //if (String.IsNullOrEmpty(Agent))
        //{
        //    return JsonConvert.SerializeObject(new { status = "請選擇【負責工程師】", Flag = "0" });
        //}
        //return JsonConvert.SerializeObject(new { status = "修改檢測結束", Flag = "0" });
        //===========================================================

        if (Check_Menu() == "")
        {
            string CycleName;
            switch (CycleTime)
            {
                case "0": CycleName = "單月";
                    break;
                case "1": CycleName = "雙月";
                    break;
                case "2": CycleName = "每季";
                    break;
                case "3": CycleName = "半年";
                    break;
                case "4": CycleName = "每年";
                    break;
                case "5": CycleName = "不維護";
                    break;
                default:
                    CycleName = "";
                    break;
            };

            string sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Title] SET "
                + " PID=@PID, T_ID=@T_ID, ADDR=@ADDR, "
                + " Name=@Name, MTEL=@MTEL, Cycle=@CycleTime,  Cycle_Name=@CycleName,  mission_name = @C_Name,"
                + " M_1=@M_1, M_2=@M_2, M_3=@M_3, M_4=@M_4, M_5=@M_5, M_6=@M_6, M_7=@M_7, M_8=@M_8, M_9=@M_9, M_10=@M_10, M_11=@M_11, M_12=@M_12 "
                + " WHERE SYSID=@SYSID ";

            using (IDbConnection db = DBTool.GetConn())
            {
                db.Execute(sqlstr, new
                {
                    SYSID = SYSID,
                    PID = PID,
                    T_ID = T_ID,
                    ADDR = ADDR,
                    Name = Name,
                    MTEL = MTEL,
                    CycleTime = CycleTime,
                    CycleName = CycleName,
                    C_Name = C_Name,
                    M_1 = Checkbox(C_1),
                    M_2 = Checkbox(C_2),
                    M_3 = Checkbox(C_3),
                    M_4 = Checkbox(C_4),
                    M_5 = Checkbox(C_5),
                    M_6 = Checkbox(C_6),
                    M_7 = Checkbox(C_7),
                    M_8 = Checkbox(C_8),
                    M_9 = Checkbox(C_9),
                    M_10 = Checkbox(C_10),
                    M_11 = Checkbox(C_11),
                    M_12 = Checkbox(C_12), 
                });
                db.Close();
            };  //*/
            /*if (!string.IsNullOrEmpty(PID2))   // 當值為null時跳過  非 null 時 update
            {
                sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Title] SET PID2 = @PID2 WHERE SYSID = @SYSID";
                var a = DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    SYSID = SYSID,
                    PID2 = PID2,
                });
            }   //*/
            if (!string.IsNullOrEmpty(Agent))   // 當值為null時跳過  非 null 時 update
            {
                sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Title] SET Mission_Title.Agent_ID = DispatchSystem.Agent_ID, " +
                    "Mission_Title.Agent_Name = DispatchSystem.Agent_Name, " +
                    "Mission_Title.UserID = DispatchSystem.UserID, " +
                    "Mission_Title.Agent_Team = DispatchSystem.Agent_Team " +
                    "FROM [DispatchSystem] WHERE Mission_Title.SYSID = @SYSID and DispatchSystem.Agent_ID = @Agent ";
                var a = DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    SYSID = SYSID,
                    Agent = Agent,
                });
            }
            else {
                sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Title] SET Agent_ID = '', " +
                    "Agent_Name = '', " +
                    "UserID = '', " +
                    "Agent_Team = '' " +
                    "WHERE SYSID = @SYSID ";
                var a = DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    SYSID = SYSID,
                });
            }
            if (CycleTime=="5")   // 當值為null時跳過  非 null 時 update
            {
                sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Title] SET " +
                    "Flag = '0' " +
                    "WHERE SYSID = @SYSID";
                var a = DBTool.Query<ClassTemplate>(sqlstr, new
                {
                    SYSID = SYSID
                });
            }
            return JsonConvert.SerializeObject(new { status = "維護設定 修改完成。", Flag = "1" });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "權限不足。", Flag = "0" }); ;
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Get_Title()
    {
        string ID = HttpContext.Current.Session["SYSID25002"].ToString();
        string sql = @"SELECT TOP 1 mission_name, File_name, Agent_ID, Agent_Team, Cycle, Start_Time, End_Time "
            + " FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@ID ";
        string image = "";
        string title = "";
        string team = "";
        string id = "";
        string cycle = "";
        string start_time = "";
        string end_time = "";

        var Array = DBTool.Query<Value_0250010002>(sql, new { ID = ID });

        if (Array.Count() > 0)
        {
            foreach (var var in Array)
            {
                image = var.File_name;
                title = var.mission_name;
                team = var.Agent_Team;
                id = var.Agent_ID;
                cycle = var.Cycle;
                start_time = var.Start_Time;
                end_time = var.End_Time;
                if (string.IsNullOrEmpty(image))
                {
                    image = "NULL.png";
                }
            }
        }

        return JsonConvert.SerializeObject(new
        {
            status = "<img id='img_MAP' src='Patrol_System/" + image + "' />",
            title = title,
            team = team,
            id = id,
            cycle = cycle,
            start_time = start_time,
            end_time = end_time
        });
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Get_info()
    {
        string ID = HttpContext.Current.Session["SYSID25002"].ToString();
        string sql = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_List] WHERE Flag=1 AND ID=@ID ORDER BY Alphabet";
        var Array = DBTool.Query<Value_0250010002>(sql, new { ID = ID });
        string outputJson = "";
        if (Array.Count() > 0)  //有資料時直接讀取
        {
            var a = Array.ToList().Select(p => new
            {
                bit = p.Alphabet,
                x = p.equipment_X,
                y = p.equipment_Y,
                name = p.equipment_name,
                t_1 = p.equipment_type1,
                t_2 = p.equipment_type2,
                t_3 = p.equipment_type3,
                t_4 = p.equipment_type4,
                t_5 = p.equipment_type5,
                q_1 = p.equipment_question1,
                q_2 = p.equipment_question2,
                q_3 = p.equipment_question3,
                q_4 = p.equipment_question4,
                q_5 = p.equipment_question5,
                o_1 = p.equipment_Option1,
                o_2 = p.equipment_Option2,
                o_3 = p.equipment_Option3,
                o_4 = p.equipment_Option4,
                o_5 = p.equipment_Option5,
                status = ""
            });
            outputJson = JsonConvert.SerializeObject(a);
            return @outputJson;
        }
        else    //沒資料時
        {
            string ID2 = HttpContext.Current.Session["SYSID25002"].ToString();
            sql = @"SELECT T_ID FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@ID3 and (T_ID='中華電信')";
            var z = DBTool.Query<Value_0250010002>(sql, new { ID3 = ID2 });
            if (z.Count() > 0)      //
            {
                //return JsonConvert.SerializeObject(new { status = "中華電信。", Flag = "0" });
                sql = @"INSERT INTO InSpecation_Dimax.dbo.Mission_List " +
                "(ID ,Alphabet ,equipment_name ,equipment_ID ,equipment_X " +
                ",equipment_Y ,equipment_type1 ,equipment_question1 ,equipment_Option1 ,equipment_type2 " +
                ",equipment_question2 ,equipment_Option2 ,equipment_type3 ,equipment_question3 ,equipment_Option3 " +
                ",equipment_type4 ,equipment_question4 ,equipment_Option4 ,equipment_type5 ,equipment_question5 " +
                ",equipment_Option5 ,Create_Date ,Flag) " +

                "select @ID as ID ,Alphabet ,equipment_name ,equipment_ID ,equipment_X " +
                ",equipment_Y ,equipment_type1 ,equipment_question1 ,equipment_Option1 ,equipment_type2 " +
                ",equipment_question2 ,equipment_Option2 ,equipment_type3 ,equipment_question3 ,equipment_Option3 " +
                ",equipment_type4 ,equipment_question4 ,equipment_Option4 ,equipment_type5 ,equipment_question5 " +
                ",equipment_Option5 ,Create_Date ,Flag  " +
                "FROM InSpecation_Dimax.dbo.Mission_List	  where ID = '1' "+    //  ID = 中華 德瑪範例           
                " SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_List] WHERE Flag=1 AND ID=@ID ORDER BY Alphabet";
                var a = DBTool.Query<Value_0250010002>(sql, new { ID = ID }).ToList().Select(p => new
                {
                    bit = p.Alphabet,
                    x = p.equipment_X,
                    y = p.equipment_Y,
                    name = p.equipment_name,
                    t_1 = p.equipment_type1,
                    t_2 = p.equipment_type2,
                    t_3 = p.equipment_type3,
                    t_4 = p.equipment_type4,
                    t_5 = p.equipment_type5,
                    q_1 = p.equipment_question1,
                    q_2 = p.equipment_question2,
                    q_3 = p.equipment_question3,
                    q_4 = p.equipment_question4,
                    q_5 = p.equipment_question5,
                    o_1 = p.equipment_Option1,
                    o_2 = p.equipment_Option2,
                    o_3 = p.equipment_Option3,
                    o_4 = p.equipment_Option4,
                    o_5 = p.equipment_Option5,
                    status = ""
                });
                outputJson = JsonConvert.SerializeObject(a);
                return @outputJson; //*/
            }
            else
            {
                sql = @"SELECT T_ID FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@ID and (T_ID='遠傳' or T_ID='德瑪')";
                var y = DBTool.Query<Value_0250010002>(sql, new { ID = ID });
                if (y.Count() > 0)
                {
                    //return JsonConvert.SerializeObject(new { status = "遠傳。", Flag = "0" });
                    sql = @"INSERT INTO InSpecation_Dimax.dbo.Mission_List " +
                "(ID ,Alphabet ,equipment_name ,equipment_ID ,equipment_X " +
                ",equipment_Y ,equipment_type1 ,equipment_question1 ,equipment_Option1 ,equipment_type2 " +
                ",equipment_question2 ,equipment_Option2 ,equipment_type3 ,equipment_question3 ,equipment_Option3 " +
                ",equipment_type4 ,equipment_question4 ,equipment_Option4 ,equipment_type5 ,equipment_question5 " +
                ",equipment_Option5 ,Create_Date ,Flag) " +

                "select @ID as ID ,Alphabet ,equipment_name ,equipment_ID ,equipment_X " +
                ",equipment_Y ,equipment_type1 ,equipment_question1 ,equipment_Option1 ,equipment_type2 " +
                ",equipment_question2 ,equipment_Option2 ,equipment_type3 ,equipment_question3 ,equipment_Option3 " +
                ",equipment_type4 ,equipment_question4 ,equipment_Option4 ,equipment_type5 ,equipment_question5 " +
                ",equipment_Option5 ,Create_Date ,Flag  " +
                "FROM InSpecation_Dimax.dbo.Mission_List	  where ID = '2' " +   //  ID = 遠傳範例                
                " SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_List] WHERE Flag=1 AND ID=@ID ORDER BY Alphabet";
                    var b = DBTool.Query<Value_0250010002>(sql, new { ID = ID }).ToList().Select(p => new
                    {
                        bit = p.Alphabet,
                        x = p.equipment_X,
                        y = p.equipment_Y,
                        name = p.equipment_name,
                        t_1 = p.equipment_type1,
                        t_2 = p.equipment_type2,
                        t_3 = p.equipment_type3,
                        t_4 = p.equipment_type4,
                        t_5 = p.equipment_type5,
                        q_1 = p.equipment_question1,
                        q_2 = p.equipment_question2,
                        q_3 = p.equipment_question3,
                        q_4 = p.equipment_question4,
                        q_5 = p.equipment_question5,
                        o_1 = p.equipment_Option1,
                        o_2 = p.equipment_Option2,
                        o_3 = p.equipment_Option3,
                        o_4 = p.equipment_Option4,
                        o_5 = p.equipment_Option5,
                        status = ""
                    });
                    outputJson = JsonConvert.SerializeObject(b);
                    return @outputJson; //*/
                }
                else
                {
                    //return JsonConvert.SerializeObject(new { status = "其他。", Flag = "0" });

                    sql = @"Declare @Array table(Value nvarchar(20)) "
                    + "insert into @Array (Value) values ('A') "
                    + "insert into @Array (Value) values ('B') "
                    + "insert into @Array (Value) values ('C') "
                    + "insert into @Array (Value) values ('D') "
                    + "insert into @Array (Value) values ('E') "
                    + "insert into @Array (Value) values ('F') "
                    + "insert into @Array (Value) values ('G') "
                    + "insert into @Array (Value) values ('H') "
                    + "insert into @Array (Value) values ('I') "
                    + "insert into @Array (Value) values ('J') "
                    + "insert into @Array (Value) values ('K') "
                    + "insert into @Array (Value) values ('L') "    //建立 12項空白問題
                    + " "
                    + "Declare @NAME nvarchar(50) "
                    + "SET @NAME = ( SELECT [mission_name] FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@ID ) "
                    + " "
                    + "INSERT INTO [InSpecation_Dimax].[dbo].[Mission_List] "
                    + " ( "
                    + "ID, Alphabet, equipment_name, equipment_ID, equipment_X, equipment_Y, "
                    + "equipment_type1, equipment_question1, equipment_Option1, "
                    + "equipment_type2, equipment_question2, equipment_Option2, "
                    + "equipment_type3, equipment_question3, equipment_Option3, "
                    + "equipment_type4, equipment_question4, equipment_Option4, "
                    + "equipment_type5, equipment_question5, equipment_Option5 "
                    + " ) "
                    + " SELECT @ID, Value, @NAME + ' 項目 ' + Value , '0', '0', '0', "
                    + " '6', '', '', "
                    + " '6', '', '', "
                    + " '6', '', '', "
                    + " '6', '', '', "
                    + " '6', '', '' "
                    + " FROM @Array "
                    + " SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_List] WHERE Flag=1 AND ID=@ID ORDER BY Alphabet";
                    var c = DBTool.Query<Value_0250010002>(sql, new { ID = ID }).ToList().Select(p => new
                    {
                        bit = p.Alphabet,
                        x = p.equipment_X,
                        y = p.equipment_Y,
                        name = p.equipment_name,
                        t_1 = p.equipment_type1,
                        t_2 = p.equipment_type2,
                        t_3 = p.equipment_type3,
                        t_4 = p.equipment_type4,
                        t_5 = p.equipment_type5,
                        q_1 = p.equipment_question1,
                        q_2 = p.equipment_question2,
                        q_3 = p.equipment_question3,
                        q_4 = p.equipment_question4,
                        q_5 = p.equipment_question5,
                        o_1 = p.equipment_Option1,
                        o_2 = p.equipment_Option2,
                        o_3 = p.equipment_Option3,
                        o_4 = p.equipment_Option4,
                        o_5 = p.equipment_Option5,
                        status = ""
                    });
                    outputJson = JsonConvert.SerializeObject(c);
                    return @outputJson; //*/                    
                }
            }
            /*sql = " SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_List] WHERE Flag=1 AND ID=@ID ORDER BY Alphabet";
            var d = DBTool.Query<Value_0250010002>(sql, new { ID = ID }).ToList().Select(p => new
            {
                bit = p.Alphabet,
                x = p.equipment_X,
                y = p.equipment_Y,
                name = p.equipment_name,
                t_1 = p.equipment_type1,
                t_2 = p.equipment_type2,
                t_3 = p.equipment_type3,
                t_4 = p.equipment_type4,
                t_5 = p.equipment_type5,
                q_1 = p.equipment_question1,
                q_2 = p.equipment_question2,
                q_3 = p.equipment_question3,
                q_4 = p.equipment_question4,
                q_5 = p.equipment_question5,
                o_1 = p.equipment_Option1,
                o_2 = p.equipment_Option2,
                o_3 = p.equipment_Option3,
                o_4 = p.equipment_Option4,
                o_5 = p.equipment_Option5,
                status = ""
            });
            outputJson = JsonConvert.SerializeObject(d);
            return @outputJson; //*/
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check(string ID)
    {
        if (JASON.Alphabet_Check(ID) == false)
        {
            return "A";
        }
        else
        {
            return ID;
        };
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Show_Title()
    {
        Thread.Sleep(500);
        string ID = HttpContext.Current.Session["SYSID25002"].ToString();
        Thread.Sleep(500);
        string Sqlstr = @"SELECT * " +
            " FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@value";
        var a = DBTool.Query<Value_0250010002>(Sqlstr, new { value = ID }).ToList().Select(p => new
        {
            A = Value(p.PID),
            //B = Value(p.PID2),
            C = Value(p.T_ID),
            D = Value(p.ADDR),
            E = Value(p.Name),
            F = Value(p.MTEL),
            G = Value(p.Cycle),
            H = Value(p.Agent_ID),
            I = Value(p.mission_name),
            C1 = Re_Checkbox(p.M_1),
            C2 = Re_Checkbox(p.M_2),
            C3 = Re_Checkbox(p.M_3),
            C4 = Re_Checkbox(p.M_4),
            C5 = Re_Checkbox(p.M_5),
            C6 = Re_Checkbox(p.M_6),
            C7 = Re_Checkbox(p.M_7),
            C8 = Re_Checkbox(p.M_8),
            C9 = Re_Checkbox(p.M_9),
            C10 = Re_Checkbox(p.M_10),
            C11 = Re_Checkbox(p.M_11),
            C12 = Re_Checkbox(p.M_12)
        });
        string outputJson = JsonConvert.SerializeObject(a);
        Thread.Sleep(500);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]
    public static string List_Agent(string Team)
    {
        string outputJson = "";
        string sqlstr = @"SELECT  Agent_ID, Agent_Name FROM DispatchSystem WHERE Agent_Status = '在職' AND Agent_Team = @Team ORDER BY Agent_Name";
        var a = DBTool.Query<ClassTemplate>(sqlstr, new { Team = Team }).ToList().Select(p => new
        {
            Agent_ID = p.Agent_ID,
            Agent_Name = p.Agent_Name
        });
        outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Open_Month(string id, string Flag)
    {
        //return JsonConvert.SerializeObject(new { status = id +"  "+ Flag +"  "+ Checkbox(Flag), Flag = "0" });
        //Flag = Checkbox(Flag);
        string SYSID = HttpContext.Current.Session["SYSID25002"].ToString();
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string str_back;
        if (Flag == "True")
        {
            Flag = "1";
            str_back = "編號【" + SYSID + "】【" + id + "】月產單已啟用。";
        }
        else
        {
            Flag = "0";
            str_back = "編號【" + SYSID + "】【" + id + "】月產單已停用。";
        };

        string Sqlstr = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@SYSID ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { SYSID = SYSID });
        if (a.Count() > 0)
        {
            Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Title] SET "
                + " M_" + id + " =@Flag "
                + " WHERE SYSID=@SYSID ";

            using (IDbConnection db = DBTool.GetConn())
            {
                db.Execute(Sqlstr, new { Flag = Flag, SYSID = SYSID });
                db.Close();
            };
            return JsonConvert.SerializeObject(new { status = str_back, Flag = "1" });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
        }
    }

    public static bool Check_Time(string Time)
    {
        return Regex.IsMatch(Time, "^[0-9]{2}:[0-9]{2}$");
    }

    public static string Check_Menu()
    {
        return "";
    }
    public static string Value(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = value.Trim();
        }
        return value;
    }
    public static string Re_Checkbox(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (value == "1")
        {
            value = "checked";
        }
        else
            value = "";
        return value;
    }
    public static string Checkbox(string value)        // 當值為null時跳過  非 null 時去除後方空白
    {
        if (value == "True")
        {
            value = "1";
        }
        else
            value = "0";
        return value;
    }
    public class Value_0250010002
    {
        public string Cycle { get; set; }
        public string Cycle_Name { get; set; }
        public string Start_Time { get; set; }
        public string End_Time { get; set; }
        public string Agent_ID { get; set; }
        public string Agent_Name { get; set; }
        public string Agent_Team { get; set; }
        public string bit { get; set; }
        public string x { get; set; }
        public string y { get; set; }
        public string Flag { get; set; }
        public string SYSID { get; set; }
        public string mission_name { get; set; }
        public string person_charge { get; set; }
        public string Alphabet { get; set; }
        public string equipment_X { get; set; }
        public string equipment_Y { get; set; }
        public string equipment_name { get; set; }
        public string equipment_type1 { get; set; }
        public string equipment_type2 { get; set; }
        public string equipment_type3 { get; set; }
        public string equipment_type4 { get; set; }
        public string equipment_type5 { get; set; }
        public string equipment_question1 { get; set; }
        public string equipment_question2 { get; set; }
        public string equipment_question3 { get; set; }
        public string equipment_question4 { get; set; }
        public string equipment_question5 { get; set; }
        public string equipment_Option1 { get; set; }
        public string equipment_Option2 { get; set; }
        public string equipment_Option3 { get; set; }
        public string equipment_Option4 { get; set; }
        public string equipment_Option5 { get; set; }
        public string equipment_Option6 { get; set; }
        public string equipment_Option7 { get; set; }
        public string equipment_Option8 { get; set; }
        public string equipment_Option9 { get; set; }
        public string equipment_Option10 { get; set; }
        public string equipment_Option11 { get; set; }
        public string equipment_Option12 { get; set; }
        public string File_name { get; set; }
        public string PID { get; set; }
        public string PID2 { get; set; }
        public string T_ID { get; set; }
        public string ADDR { get; set; }
        public string Name { get; set; }
        public string MTEL { get; set; }
        public DateTime Work_Time { get; set; }
        public DateTime Create_Date { get; set; }
        public string M_1 { get; set; }
        public string M_2 { get; set; }
        public string M_3 { get; set; }
        public string M_4 { get; set; }
        public string M_5 { get; set; }
        public string M_6 { get; set; }
        public string M_7 { get; set; }
        public string M_8 { get; set; }
        public string M_9 { get; set; }
        public string M_10 { get; set; }
        public string M_11 { get; set; }
        public string M_12 { get; set; }
    }
}
