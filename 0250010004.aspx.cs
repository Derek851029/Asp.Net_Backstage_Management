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

public partial class _0250010004 : System.Web.UI.Page
{
    protected string seqno = "";
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        seqno = Request.Params["seqno"];
        if (string.IsNullOrEmpty(seqno))
        {
            Response.Redirect("0030010000/0030010008.aspx?view=0");
        }
        else
        {
            Session["SYSID"] = seqno;
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Update_Location(int[] Top, int[] Left)
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string ID = HttpContext.Current.Session["SYSID"].ToString();
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

                var a = DBTool.Query<Value_0250010004>(sql, new { ID = ID, Top = Top[i], Left = Left[i], Alphabet = Alphabet[i] });
            }
            return "檢查點位置修改完成。";
        }
        else
        {
            return error;
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Update_Answers(string alphabet, string title, string[] question, string[] option, int[] type, string[] answer, string caseid)
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string id = HttpContext.Current.Session["SYSID"].ToString();
        int i = 0;
        int txt_Length = 0;
        Thread.Sleep(500);
        //檢查 檢查點編號 參數是否正確
        if (!new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L" }.Contains(alphabet))
        {
            return JsonConvert.SerializeObject(new { status = error + "檢查點編號 參數錯誤 儲存失敗", Flag = "0" });
        }

        //檢查 陣列數量是否正確
        if (question.Length == 5 && option.Length == 5 && type.Length == 5)
        {
            //檢查 回答類型 參數是否正確
            for (i = 0; i < 5; i++)
            {
                if (type[i] < 0 || type[i] > 6)
                {
                    return JsonConvert.SerializeObject(new { status = error + "陣列數量錯誤 儲存失敗", Flag = "0" });
                }
            }

            title = title.Trim();
            if (title.Length > 25 || title.Length < 1)
            {
                return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet + "】的【地點名稱】不能空白或超過２５個字元。 儲存失敗", Flag = "0" });
            }
            else
            {
                i = title.Length;
                title = HttpUtility.HtmlEncode(title);
                if (title.Length != i)
                {
                    return JsonConvert.SerializeObject(new { status = error + "title.Length != i 儲存失敗", Flag = "0" });
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
                        return JsonConvert.SerializeObject(new { status = "【" + i + ". 檢查內容】" + error, Flag = "0" });
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

            /*for (i = 0; i < 5; i++)     //檢查是否有填寫回答
            {
                if (question[i].Length > 0 && answer[i].Length==0)  //
                {
                    if (question[i] != "異常原因或說明(txt)" && question[i] != "其他內容" && question[i] != "客戶建議事項" && question[i] != "內容"
                      )  //&& question[i] != "7.電壓"
                    //if (type[i] != 1)  //
                    {
                        return JsonConvert.SerializeObject(new { status = "【檢查項目 " + alphabet + "】的【"+question[i]+"】尚未填寫。", Flag = "0" });
                    }
                }
            }//*/

            for (i = 0; i < 5; i++)     //回答是否超過200字
            {
                if (answer[i].Length > 200)
                {
                    i++;
                    return JsonConvert.SerializeObject(new { status = "【檢查項目 " + alphabet + "】的【" + i + ". 回答內容】不能超過２００個字元。", Flag = "0" });
                }
                else
                {
                    answer[i] = answer[i].Trim();
                    txt_Length = answer[i].Length;
                    answer[i] = HttpUtility.HtmlEncode(answer[i]);
                    if (answer[i].Length != txt_Length)
                    {
                        i++;
                        return JsonConvert.SerializeObject(new { status = "【" + i + ". 檢查內容】" + error, Flag = "0" });
                    }
                }
            }
            //====================================================================
            string Sqlstr = @"SELECT TOP 1 * FROM [InSpecation_Dimax].[dbo].[Mission_Ans] WHERE Case_ID=@ID AND Alphabet=@Alphabet ";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                ID = caseid,
                Alphabet = alphabet,
            });
            if (!a.Any())   // 沒資料 新增回答
            {
                //return JsonConvert.SerializeObject(new { status = "修改檢測結束 a.Any()", Flag = "0" });
                string sql = "insert into InSpecation_Dimax.dbo.Mission_Ans  "
                    + " (equipment_name, equipment_type1, equipment_question1, equipment_Option1, equipment_type2, equipment_question2, "
                    + " equipment_Option2, equipment_type3, equipment_question3, equipment_Option3, equipment_type4, equipment_question4, "
                    + " equipment_Option4, equipment_type5, equipment_question5, equipment_Option5, Case_ID, Alphabet, "
                    + " equipment_Ans1, equipment_Ans2, equipment_Ans3, equipment_Ans4, equipment_Ans5) "
                    + " values(@name, @type1, @question1, @Option1, @type2, @question2, "
                    + " @Option2, @type3, @question3, @Option3, @type4, @question4, "
                    + " @Option4, @type5, @question5, @Option5, @ID, @Alphabet, "
                    + " @answer1, @answer2, @answer3, @answer4, @answer5)";                

                DBTool.Query<Value_0250010004>(sql, new
                {
                    ID = caseid,
                    Alphabet = alphabet,
                    name = title,
                    type1 = type[0],
                    type2 = type[1],
                    type3 = type[2],
                    type4 = type[3],
                    type5 = type[4],
                    question1 = question[0],
                    question2 = question[1],
                    question3 = question[2],
                    question4 = question[3],
                    question5 = question[4],
                    Option1 = option[0],
                    Option2 = option[1],
                    Option3 = option[2],
                    Option4 = option[3],
                    Option5 = option[4],
                    answer1 = answer[0],
                    answer2 = answer[1],
                    answer3 = answer[2],
                    answer4 = answer[3],
                    answer5 = answer[4],
                }); 
                
                for (i = 0; i < 5; i++)     //檢查是否有填寫回答
                {
                    if (question[i].Length > 0 && answer[i].Length == 0)  //
                    {
                        if (question[i] != "異常原因或說明(txt)" && question[i] != "其他內容" && question[i] != "客戶建議事項" && question[i] != "內容"
                          )  //&& question[i] != "7.電壓"
                        //if (type[i] != 1)  //
                        {
                            return JsonConvert.SerializeObject(new { status = "【檢查項目 " + alphabet + "】的【" + question[i] + "】尚未填寫。", Flag = "0" });
                        }
                    }
                }
                return JsonConvert.SerializeObject(new { status = "【" + caseid + "檢查項目 " + alphabet + "】紀錄完成", Flag = "1" });
            }
            else {  //有資料 修改回答
                //return JsonConvert.SerializeObject(new { status = "修改檢測結束 有資料 修改回答", Flag = "0" });
                string sql = "UPDATE InSpecation_Dimax.dbo.Mission_Ans SET "
                    + " equipment_name=@name, "
                    + " equipment_type1=@type1, equipment_question1=@question1, equipment_Option1=@Option1, "
                    + " equipment_type2=@type2, equipment_question2=@question2, equipment_Option2=@Option2, "
                    + " equipment_type3=@type3, equipment_question3=@question3, equipment_Option3=@Option3, "
                    + " equipment_type4=@type4, equipment_question4=@question4, equipment_Option4=@Option4, "
                    + " equipment_type5=@type5, equipment_question5=@question5, equipment_Option5=@Option5, "
                    + " equipment_Ans1=@answer1, equipment_Ans2=@answer2, equipment_Ans3=@answer3, "
                    + " equipment_Ans4=@answer4, equipment_Ans5=@answer5 "
                    + " WHERE Case_ID=@ID AND Alphabet=@Alphabet ";

                DBTool.Query<Value_0250010004>(sql, new
                {
                    ID = caseid,
                    Alphabet = alphabet,
                    name = title,
                    type1 = type[0],
                    type2 = type[1],
                    type3 = type[2],
                    type4 = type[3],
                    type5 = type[4],
                    question1 = question[0],
                    question2 = question[1],
                    question3 = question[2],
                    question4 = question[3],
                    question5 = question[4],
                    Option1 = option[0],
                    Option2 = option[1],
                    Option3 = option[2],
                    Option4 = option[3],
                    Option5 = option[4],
                    answer1 = answer[0],
                    answer2 = answer[1],
                    answer3 = answer[2],
                    answer4 = answer[3],
                    answer5 = answer[4],
                });

                for (i = 0; i < 5; i++)     //檢查是否有填寫回答
                {
                    if (question[i].Length > 0 && answer[i].Length == 0)  //
                    {
                        if (question[i] != "異常原因或說明(txt)" && question[i] != "其他內容" && question[i] != "客戶建議事項" && question[i] != "內容"
                          )  //&& question[i] != "7.電壓"
                        //if (type[i] != 1)  //
                        {
                            return JsonConvert.SerializeObject(new { status = "【檢查項目 " + alphabet + "】的【" + question[i] + "】尚未填寫。", Flag = "0" });
                        }
                    }
                }
                return JsonConvert.SerializeObject(new { status = "【" + caseid + "檢查項目 " + alphabet + "】修改完成", Flag = "1" });
            }            
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Update_Answers_New(string[] alphabet,string[] title,string caseid,
        string[] question1,string[] question2,string[] question3,string[] question4,string[] question5,
        //string[] option1,string[] option2,string[] option3,string[] option4,string[] option5,
        string[] type1,string[] type2,string[] type3,string[] type4,string[] type5,
        string[] answer1,string[] answer2,string[] answer3,string[] answer4,string[] answer5 )
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        //string id = HttpContext.Current.Session["SYSID"].ToString();  //已有 string caseid
        int i = 0;
        int j = 0;
        int txt_Length = 0;
        string Sqlstr = "";
        string sql = "";
        string str_alert = "";
        string Agent_Name = HttpContext.Current.Session["UserIDNAME"].ToString();

        try
        {
            if (alphabet.Length == 12 && title.Length == 12
                && question1.Length == 12 && question2.Length == 12 && question3.Length == 12 && question4.Length == 12 && question5.Length == 12
                && type1.Length == 12 && type2.Length == 12 && type3.Length == 12 && type4.Length == 12 && type5.Length == 12
                && answer1.Length == 12 && answer2.Length == 12 && answer3.Length == 12 && answer4.Length == 12 && answer5.Length == 12
                )   //檢查 陣列數量是否正確
            {
                //title = title.Trim();
                for (i = 0; i < 12; i++)
                {
                    if (!new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L" }.Contains(alphabet[i]))
                        return JsonConvert.SerializeObject(new { status = error + "檢查點編號 參數錯誤 儲存失敗", Flag = "0" });

                    title[i] = Value(title[i]);
                    if (title[i].Length > 25 || title[i].Length < 1)
                        return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet[i] + "】的【地點名稱】不能空白或超過２５個字元。 儲存失敗", Flag = "0" });
                    else
                    {
                        j = title[i].Length;
                        //title = HttpUtility.HtmlEncode(title);
                        if (title[i].Length != j)
                        {
                            return JsonConvert.SerializeObject(new { status = error +(char)13+ "title[i].Length != j 儲存失敗", Flag = "0" });
                        }
                    }
                    if (question1[i].Length > 500)  //檢查 檢查內容 字數是否正確
                        return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet[i] + "】的【1. 檢查內容】不能超過５００個字元 儲存失敗。", Flag = "0" });
                    else if (question2[i].Length > 500)
                        return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet[i] + "】的【2. 檢查內容】不能超過５００個字元 儲存失敗。", Flag = "0" });
                    else if (question3[i].Length > 500)
                        return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet[i] + "】的【3. 檢查內容】不能超過５００個字元 儲存失敗。", Flag = "0" });
                    else if (question4[i].Length > 500)
                        return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet[i] + "】的【4. 檢查內容】不能超過５００個字元 儲存失敗。", Flag = "0" });
                    else if (question5[i].Length > 500)
                        return JsonConvert.SerializeObject(new { status = "【檢查點 " + alphabet[i] + "】的【5. 檢查內容】不能超過５００個字元 儲存失敗。", Flag = "0" });

                    if (answer1[i].Length > 200)    //檢查 回答內容 是否超過200字
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【1. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });
                    else if (answer2[i].Length > 200)    
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【2. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });
                    else if (answer3[i].Length > 200)    
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【3. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });
                    else if (answer4[i].Length > 200)    
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【4. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });
                    else if (answer5[i].Length > 200)    
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【5. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });

                    if (answer1[i].Length > 200)    //檢查 回答內容 是否超過200字
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【1. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });
                    else if (answer2[i].Length > 200)    
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【2. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });
                    else if (answer3[i].Length > 200)    
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【3. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });
                    else if (answer4[i].Length > 200)    
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【4. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });
                    else if (answer5[i].Length > 200)    
                        return JsonConvert.SerializeObject(new { status = "【回答內容 " + alphabet[i] + "】的【5. 回答內容】不能超過２００個字元 儲存失敗。", Flag = "0" });

                    if (type1[i].Length > 1)
                        return JsonConvert.SerializeObject(new { status = error + (char)13 + "【" + alphabet[i] + "的 type1 太長】儲存失敗", Flag = "0" });
                    else if (type2[i].Length > 1)
                        return JsonConvert.SerializeObject(new { status = error + (char)13 + "【" + alphabet[i] + "的 type2 太長】儲存失敗", Flag = "0" });
                    else if (type3[i].Length > 1)
                        return JsonConvert.SerializeObject(new { status = error + (char)13 + "【" + alphabet[i] + "的 type3 太長】儲存失敗", Flag = "0" });
                    else if (type4[i].Length > 1)
                        return JsonConvert.SerializeObject(new { status = error + (char)13 + "【" + alphabet[i] + "的 type4 太長】儲存失敗", Flag = "0" });
                    else if (type5[i].Length > 1)
                        return JsonConvert.SerializeObject(new { status = error + (char)13 + "【" + alphabet[i] + "的 type5 太長】儲存失敗", Flag = "0" });
                }

                for (i = 0; i < 12; i++){
                    Sqlstr = @"SELECT TOP 1 * FROM [InSpecation_Dimax].[dbo].[Mission_Ans] WHERE Case_ID=@ID AND Alphabet=@Alphabet ";
                    var a = DBTool.Query<ClassTemplate>(Sqlstr, new
                    {
                        ID = caseid,
                        Alphabet = alphabet[i],
                    });
                    if (!a.Any())
                    {
                        sql = @"Insert into InSpecation_Dimax.dbo.Mission_Ans  "
                            + " (equipment_name, equipment_type1, equipment_question1, equipment_Option1, equipment_type2, equipment_question2, "
                            + " equipment_Option2, equipment_type3, equipment_question3, equipment_Option3, equipment_type4, equipment_question4, "
                            + " equipment_Option4, equipment_type5, equipment_question5, equipment_Option5, Case_ID, Alphabet, "
                            + " equipment_Ans1, equipment_Ans2, equipment_Ans3, equipment_Ans4, equipment_Ans5) "
                            + " values(@name, @type1, @question1, @Option1, @type2, @question2, "
                            + " @Option2, @type3, @question3, @Option3, @type4, @question4, "
                            + " @Option4, @type5, @question5, @Option5, @ID, @Alphabet, "
                            + " @answer1, @answer2, @answer3, @answer4, @answer5)";
                        DBTool.Query<Value_0250010004>(sql, new
                        {
                            ID = caseid,
                            Alphabet = alphabet[i],
                            name = title[i],
                            type1 = type1[i],
                            type2 = type2[i],
                            type3 = type3[i],
                            type4 = type4[i],
                            type5 = type5[i],
                            question1 = question1[i],
                            question2 = question2[i],
                            question3 = question3[i],
                            question4 = question4[i],
                            question5 = question5[i],
                            Option1 = "",
                            Option2 = "",
                            Option3 = "",
                            Option4 = "",
                            Option5 = "",
                            answer1 = answer1[i],
                            answer2 = answer2[i],
                            answer3 = answer3[i],
                            answer4 = answer4[i],
                            answer5 = answer5[i],
                        });
                    }
                    else
                    {
                        sql = "UPDATE InSpecation_Dimax.dbo.Mission_Ans SET "
                          + " equipment_name=@name, "
                          + " equipment_type1=@type1, equipment_question1=@question1, equipment_Option1=@Option1, "
                          + " equipment_type2=@type2, equipment_question2=@question2, equipment_Option2=@Option2, "
                          + " equipment_type3=@type3, equipment_question3=@question3, equipment_Option3=@Option3, "
                          + " equipment_type4=@type4, equipment_question4=@question4, equipment_Option4=@Option4, "
                          + " equipment_type5=@type5, equipment_question5=@question5, equipment_Option5=@Option5, "
                          + " equipment_Ans1=@answer1, equipment_Ans2=@answer2, equipment_Ans3=@answer3, "
                          + " equipment_Ans4=@answer4, equipment_Ans5=@answer5 "
                          + " WHERE Case_ID=@ID AND Alphabet=@Alphabet ";
                        DBTool.Query<Value_0250010004>(sql, new
                        {
                            ID = caseid,
                            Alphabet = alphabet[i],
                            name = title[i],
                            type1 = type1[i],
                            type2 = type2[i],
                            type3 = type3[i],
                            type4 = type4[i],
                            type5 = type5[i],
                            question1 = question1[i],
                            question2 = question2[i],
                            question3 = question3[i],
                            question4 = question4[i],
                            question5 = question5[i],
                            Option1 = "",
                            Option2 = "",
                            Option3 = "",
                            Option4 = "",
                            Option5 = "",
                            answer1 = answer1[i],
                            answer2 = answer2[i],
                            answer3 = answer3[i],
                            answer4 = answer4[i],
                            answer5 = answer5[i],
                        });
                    }
                    if (question1[i].Length > 0 && answer1[i].Length == 0)  //
                    {
                        if (question1[i] != "異常原因或說明(txt)" && question1[i] != "其他內容" && question1[i] != "客戶建議事項" && question1[i] != "內容")  //&& question1[i] != "7.電壓"
                            str_alert = str_alert + "【檢查項目 " + alphabet[i] + "】的【" + question1[i] + "】尚未填寫。"+(char)13;
                    }
                    if (question2[i].Length > 0 && answer2[i].Length == 0)  //
                    {
                        if (question2[i] != "異常原因或說明(txt)" && question2[i] != "其他內容" && question2[i] != "客戶建議事項" && question2[i] != "內容")  //&& question2[i] != "7.電壓"
                            str_alert = str_alert + "【檢查項目 " + alphabet[i] + "】的【" + question2[i] + "】尚未填寫。" + (char)13;
                    }
                    if (question3[i].Length > 0 && answer3[i].Length == 0)  //
                    {
                        if (question3[i] != "異常原因或說明(txt)" && question3[i] != "其他內容" && question3[i] != "客戶建議事項" && question3[i] != "內容")  //&& question3[i] != "7.電壓"
                            str_alert = str_alert + "【檢查項目 " + alphabet[i] + "】的【" + question3[i] + "】尚未填寫。" + (char)13;
                    }
                    if (question4[i].Length > 0 && answer4[i].Length == 0)  //
                    {
                        if (question4[i] != "異常原因或說明(txt)" && question4[i] != "其他內容" && question4[i] != "客戶建議事項" && question4[i] != "內容")  //&& question4[i] != "7.電壓"
                            str_alert = str_alert + "【檢查項目 " + alphabet[i] + "】的【" + question4[i] + "】尚未填寫。" + (char)13;
                    }
                    if (question5[i].Length > 0 && answer5[i].Length == 0)  //
                    {
                        if (question5[i] != "異常原因或說明(txt)" && question5[i] != "其他內容" && question5[i] != "客戶建議事項" && question5[i] != "內容")  //&& question5[i] != "7.電壓"
                            str_alert = str_alert + "【檢查項目 " + alphabet[i] + "】的【" + question5[i] + "】尚未填寫。" + (char)13;
                    }
                }
                if (str_alert!="")
                    return JsonConvert.SerializeObject(new { status = "儲存完畢" + (char)13 + str_alert, Flag = "0" });
                else
                    return JsonConvert.SerializeObject(new { status = "【維護單" + caseid + " 全檢查項目 】儲存完畢", Flag = "1", Agent_Name = Agent_Name });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = "其中一個陣列數量不是１２筆 儲存失敗" + (char)13 + error, Flag = "0" });
            }
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = error+(char)13+ ex, Flag = "0" });
        }
    }

    public static string Check_Value(string value, int Max, int Min)
    {
        return value;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Update_Title(string PID, string PID2, string T_ID, string ADDR,
        string Name, string MTEL, string CycleTime, string Agent)
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string SYSID = HttpContext.Current.Session["SYSID"].ToString();
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string UserIDNAME = HttpContext.Current.Session["UserIDNAME"].ToString();
        int i = 0;

        //===========================================================
        if (String.IsNullOrEmpty(PID))
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【客戶】", Flag = "0" });
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
            if (!new string[] { "0", "1", "2", "3" }.Contains(CycleTime))
            {
                return JsonConvert.SerializeObject(new { status = error, Flag = "0" });
            }
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【巡查週期】", Flag = "0" });
        }
        //===========================================================
        if (String.IsNullOrEmpty(Agent))
        {
            return JsonConvert.SerializeObject(new { status = "請選擇【負責工程師】", Flag = "0" });
        }
        return JsonConvert.SerializeObject(new { status = "修改檢測結束", Flag = "0" });
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
                default:
                    CycleName = "";
                    break;
            };

            /*string sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Title] SET "
                + " mission_name=@Location, Agent_ID=a.Agent_ID, Agent_Name=a.Agent_Name, Agent_Team=a.Agent_Team, "
                + " Cycle=@Cycle, Cycle_Name=@CycleName, Start_Time=@Start_Time, End_Time=@End_Time "
                + " FROM [Faremma].[dbo].[DispatchSystem] as a "
                + " WHERE a.Agent_ID=@Agent_ID AND [InSpecation_Dimax].[dbo].[Mission_Title].SYSID=@SYSID ";

            using (IDbConnection db = DBTool.GetConn())
            {
                db.Execute(sqlstr, new
                {
                    SYSID = SYSID,
                    Location = Location,
                    Agent_ID = Agent,
                    Cycle = CycleTime,
                    CycleName = CycleName,
                    Start_Time = StartTime,
                    End_Time = EndTime
                });
                db.Close();
            };  //*/
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
        string ID = HttpContext.Current.Session["SYSID"].ToString();
        string sql = @"SELECT TOP 1 mission_name, File_name, Agent_ID, Agent_Team, Cycle, Start_Time, End_Time "
            + " FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@ID ";
        string image = "";
        string title = "";
        string team = "";
        string id = "";
        string cycle = "";
        string start_time = "";
        string end_time = "";

        var Array = DBTool.Query<Value_0250010004>(sql, new { ID = ID });

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
        string ID = HttpContext.Current.Session["SYSID"].ToString();
        string outputJson = "";
        string Telecomm_ID = "";
        string sql = @"SELECT Telecomm_ID FROM [InSpecation_Dimax].[dbo].[Mission_Case] " +
            "WHERE Case_ID=@ID";
        var list = DBTool.Query<Value_0250010004>(sql, new { ID = ID });
        if (list.Any())
        {
            Value_0250010004 schedule = list.First();
            Telecomm_ID = schedule.Telecomm_ID;
        }

        if (Telecomm_ID == "中華電信")
        {
            sql = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_List] " +
            "WHERE ID='1' order by Alphabet";
            var a = DBTool.Query<Value_0250010004>(sql, new { ID = ID }).ToList().Select(p => new        
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
        else if (Telecomm_ID == "遠傳" || Telecomm_ID == "德瑪")
        {
            sql = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_List] " +
            "WHERE ID='2' order by Alphabet";
            var a = DBTool.Query<Value_0250010004>(sql, new { ID = ID }).ToList().Select(p => new
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
        else
        {
            sql = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_List] " +
            "WHERE ID='1' order by Alphabet";
            var a = DBTool.Query<Value_0250010004>(sql, new { ID = ID }).ToList().Select(p => new
            {
                bit = p.Alphabet,
                x = "",
                y = "",
                name = "維護廠商 其他 無對應題目",
                t_1 = "6",
                t_2 = "6",
                t_3 = "6",
                t_4 = "6",
                t_5 = "6",
                q_1 = "",
                q_2 = "",
                q_3 = "",
                q_4 = "",
                q_5 = "",
                o_1 = "6",
                o_2 = "6",
                o_3 = "6",
                o_4 = "6",
                o_5 = "6",
                status = ""
            });
            outputJson = JsonConvert.SerializeObject(a);
            return @outputJson;
        }
        /*string sql = @"SELECT a.* FROM [InSpecation_Dimax].[dbo].[Mission_List] as a " +
            "left join [InSpecation_Dimax].[dbo].[Mission_Case] as b on a.ID = b.Title_ID " +
            "WHERE Case_ID=@ID ORDER BY Alphabet ";
        var Array = DBTool.Query<Value_0250010004>(sql, new { ID = ID });
        string outputJson = "";

        if (Array.Count() > 0)
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
        else
        {
                 sql = @" SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_List] WHERE Flag=1 AND ID=@ID ORDER BY Alphabet";
            var a = DBTool.Query<Value_0250010004>(sql, new { ID = ID }).ToList().Select(p => new
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
        }//*/
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
    public static string Get_Ans()
    {
        Thread.Sleep(1000);
        string ID = HttpContext.Current.Session["SYSID"].ToString();
        string sql = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_Ans]  " +
            "WHERE Case_ID=@ID ORDER BY Alphabet ";
        var Array = DBTool.Query<Value_0250010004>(sql, new { ID = ID });
        string outputJson = "";

        var a = Array.ToList().Select(p => new
        {
            bit = p.Alphabet,
            a_1 = p.equipment_Ans1,
            a_2 = p.equipment_Ans2,
            a_3 = p.equipment_Ans3,
            a_4 = p.equipment_Ans4,
            a_5 = p.equipment_Ans5,
            status = ""
        });
        outputJson = JsonConvert.SerializeObject(a);
        Thread.Sleep(1000);
        return @outputJson;        
    }
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Get_Ans2(string ID, string Eng)
    {
        string sql = @"SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_Ans]  " +
            "WHERE Case_ID=@ID and Alphabet = @Eng ";
        var Array = DBTool.Query<Value_0250010004>(sql, new { ID = ID, Eng = Eng });
        string outputJson = "";

        var a = Array.ToList().Select(p => new
        {
            bit = p.Alphabet,
            a_1 = p.equipment_Ans1,
            a_2 = p.equipment_Ans2,
            a_3 = p.equipment_Ans3,
            a_4 = p.equipment_Ans4,
            a_5 = p.equipment_Ans5,
            status = ""
        });
        outputJson = JsonConvert.SerializeObject(a);
        return @outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Load_Data(string Case_ID)
    {
        //Check();
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_ID = HttpContext.Current.Session["UserIDNO"].ToString();
        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string Agent_Team = HttpContext.Current.Session["Agent_Team"].ToString();
        string sqlstr = @"SELECT TOP 1 a.*, mission_name FROM [InSpecation_Dimax].[dbo].[Mission_Case] as a " +
            "left join [InSpecation_Dimax].[dbo].[Mission_Title] as b on a.Title_ID = b.[SYSID] " +
            "left join DispatchSystem as c on a.Agent_ID = c.Agent_ID " +
            "WHERE Case_ID=@Case_ID";
        string outputJson = "";
        var chk = DBTool.Query<Value_0250010004>(sqlstr, new { Case_ID = Case_ID });
        if (!chk.Any())
        {
            outputJson = "[" + JsonConvert.SerializeObject(new { MNo = "NULL" }) + "]"; // 組合JSON 格式
            return outputJson;
        }
        else
        {
            outputJson = JsonConvert.SerializeObject(
                chk.ToList().Select(p => new
                {
                    A = Value(p.Creat_Agent),
                    B = Value2(p.SetupTime),
                    C = Value(p.Title_ID),
                    D = Value(p.Telecomm_ID),
                    E = Value(p.ADDR),
                    F = Value(p.APPNAME),
                    G = Value(p.APP_MTEL),
                    H = Value(p.Cycle),
                    I = Value(p.Handle_Agent),
                    J = Value2(p.OnSpotTime),
                    K = Value(p.Type),
                    L = Value(p.ReachTime),
                    M = Value(p.FinishTime),
                    N = Value(p.mission_name),
                    O = Value(p.Agent_ID),
                    U_ID = UserID,
                })
              );
            return outputJson;
        }

    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Show_Title()
    {
        string ID = HttpContext.Current.Session["SYSID"].ToString();
        string Sqlstr = @"SELECT * " +
            " FROM [InSpecation_Dimax].[dbo].[Mission_Title] WHERE SYSID=@value";
        var a = DBTool.Query<Value_0250010004>(Sqlstr, new { value = ID }).ToList().Select(p => new
        {
            A = Value(p.PID),
            B = Value(p.PID2),
            C = Value(p.T_ID),
            D = Value(p.ADDR),
            E = Value(p.Name),
            F = Value(p.MTEL),
            G = Value(p.Cycle),
            H = Value(p.Agent_ID),
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]
    public static string List_Agent(string Team)
    {
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string Agent_ID = HttpContext.Current.Session["Agent_ID"].ToString();
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
    public static string Reach(string sysid, int Flag)  //string time,   補到點用
    {
        string UserID = HttpContext.Current.Session["UserID"].ToString();
        string Name = HttpContext.Current.Session["UserIDNAME"].ToString();
        string Type_Value = "";
        string Type = "";
        string Time_01 = "";
        string status = "error";
        if (Flag ==0)    //到點
        {
            Type_Value = "2";
            Type = "維護中";
            Time_01 = DateTime.Now.ToString("yyyy/MM/dd HH:mm");

            string Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Case] SET " +
            "Type = @Type, " +
            "Type_Value = @Type_Value, " +
            "ReachTime = @ReachTime, " +
            "ReachUser = @Name, " +
            "ReachUserID = @UserID " +
            "WHERE Case_ID = @sysid";
            status = "reach";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                sysid = sysid,
                Type = Type,
                Type_Value = Type_Value,
                ReachTime = Time_01,
                UserID = UserID,
                Name = Name
            });
        return JsonConvert.SerializeObject(new { status = status });
        }
        else if (Flag ==1)   //完成
        {
            //Thread.Sleep(10000);    //十秒?
            Type_Value = "3";
            Type = "已完成";
            Time_01 = DateTime.Now.ToString("yyyy/MM/dd HH:mm");

            string Sqlstr = @"UPDATE [InSpecation_Dimax].[dbo].[Mission_Case] SET " +
            "Type = @Type, " +
            "Type_Value = @Type_Value, " +
            "FinishTime = @FinishTime, " +
            "FinishUser = @Name, " +
            "FinishUserID = @UserID " +
            "WHERE Case_ID = @sysid";               //4+11+8+11         
            status = "reach";
            var a = DBTool.Query<ClassTemplate>(Sqlstr, new
            {
                sysid = sysid,
                Type = Type,
                Type_Value = Type_Value,
                FinishTime = Time_01,
                UserID = UserID,
                Name = Name
            });
            return JsonConvert.SerializeObject(new { status = status });
        }
        //else if (Flag == "3")     //補到點
            //Time_01 = time;
        return JsonConvert.SerializeObject(new { status = "修改檢測結束", Flag = "0" });
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
    public static string Value2(string value)        // 當值為null時跳過  非 null 時改時間格式
    {
        if (!string.IsNullOrEmpty(value))
        {
            value = DateTime.Parse(value).ToString("yyyy/MM/dd HH:mm");
        }
        return value;
    }

    public class Value_0250010004
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
        public string equipment_Ans1 { get; set; }
        public string equipment_Ans2 { get; set; }
        public string equipment_Ans3 { get; set; }
        public string equipment_Ans4 { get; set; }
        public string equipment_Ans5 { get; set; }
        public string File_name { get; set; }
        public string PID { get; set; }
        public string PID2 { get; set; }
        public string T_ID { get; set; }
        public string ADDR { get; set; }
        public string Name { get; set; }
        public string MTEL { get; set; }
        public DateTime Work_Time { get; set; }
        public DateTime Create_Date { get; set; }

        public string Creat_Agent { get; set; }
        public string SetupTime { get; set; }
        public string Title_ID { get; set; }
        public string Telecomm_ID { get; set; }
        public string APPNAME { get; set; }
        public string APP_MTEL { get; set; }
        public string OnSpotTime { get; set; }
        public string Type { get; set; }
        public string ReachTime { get; set; }
        public string FinishTime { get; set; }
        public string Handle_Agent { get; set; }
    }
}
