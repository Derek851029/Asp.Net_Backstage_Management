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
using System.Web.Script.Serialization;
using System.Threading;
using log4net;
using log4net.Config;

public partial class _0010010001 : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Check();
        }
    }

    public static void Check()
    {
        string Check = JASON.Check_ID("0010010001.aspx");
        if (Check == "NO")
        {
            System.Web.HttpContext.Current.Response.Redirect("~/Default.aspx");
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string List_Table(string flag, string search)
    {
        Check();
        string Sqlstr = "";
        string txt_search = "";

        try
        {
            int i = Int32.Parse(flag.Trim());
            flag = i.ToString();
        }
        catch
        {
            flag = "";
        }

        if (search != "")
        {
            txt_search = " AND txt_Title LIKE '%'+@value+'%' ";
        }

        Sqlstr = @"SELECT TOP 1000 * FROM View_Forum WHERE Flag = '1' " + txt_search;
        if (flag != "65535")
        {
            Sqlstr += " AND Service_ID=@Service_ID ";
        }

        string Agent_LV = HttpContext.Current.Session["Agent_LV"].ToString();
        string txt_button = "";
        if (Agent_LV == "20" || Agent_LV == "30")
        {
            txt_button = "<button id='look' type='button' class='btn btn-success btn-lg' data-toggle='modal' data-target='#Look_Modal'>" +
                "<span class='glyphicon glyphicon-search'></span>&nbsp;&nbsp;瀏覽</button>" +
                "&nbsp;&nbsp;" +
                "<button id='edit' type='button' class='btn btn-primary btn-lg' data-toggle='modal' data-target='#New_Modal'>" +
                "<span class='glyphicon glyphicon-pencil'></span>&nbsp;&nbsp;修改</button>";
        }
        else
        {
            txt_button = "<button id='edit' type='button' class='btn btn-success btn-lg' data-dismiss='modal'>" +
                                        "<span class='glyphicon glyphicon-search'></span>&nbsp;&nbsp;瀏覽</button>";
        }

        var a = DBTool.Query<Location_str>(Sqlstr, new { Service_ID = flag, value = search }).ToList().Select(p => new
        {
            SYSID = p.SYSID,
            Service = p.Service,
            ServiceName = p.ServiceName,
            Create_Name = p.Create_Name,
            txt_Title = p.txt_Title,
            Click = p.Click,
            Create_Time = p.Create_Time.ToString("yyyy/MM/dd HH:mm:ss"),
            txt_button = txt_button
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Service_List()
    {
        //Check();
        string Sqlstr = @"SELECT DISTINCT Service FROM Data WHERE Open_Flag = '1' Order By Service";
        var a = DBTool.Query<ClassTemplate>(Sqlstr).ToList().Select(p => new
        {
            Service = p.Service
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string ServiceName_List(string service)
    {
        Check();
        string Sqlstr = @"SELECT Service_ID, ServiceName FROM Data WHERE Open_Flag = '1' AND Service=@Service GROUP BY Service_ID, ServiceName Order By Service_ID, ServiceName ";
        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { Service = service }).ToList().Select(p => new
        {
            Service_ID = p.Service_ID,
            ServiceName = p.ServiceName
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }

    //==============================================
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Lift_Menu_List(string value)
    {
        Check();
        string txt_menu = "";
        string txt_search = "";
        int i = 0;
        if (value != "")
        {
            txt_search = " AND a.txt_Title LIKE '%'+@value+'%' ";
        }

        string Sqlstr = @"SELECT '' as Service_ID, a.Service, '' as ServiceName, COUNT(*) as Flag 
            FROM Forum as a LEFT JOIN Data as b ON a.Service_ID=b.Service_ID 
            WHERE a.Flag = '1' " + txt_search +
            @"GROUP BY a.Service  Union all 
            SELECT a.Service_ID, a.Service, a.ServiceName, COUNT(*) as Flag FROM Forum as a 
            LEFT JOIN Data as b  ON a.Service_ID=b.Service_ID 
            WHERE a.Flag = '1' " + txt_search +
            @"GROUP BY a.Service_ID, a.Service, a.ServiceName 
            ORDER BY a.Service, ServiceName, Flag ";

        var a = DBTool.Query<ClassTemplate>(Sqlstr, new { value = value });
        if (a.Count() > 0)
        {
            foreach (var r in a)
            {
                if (r.ServiceName == "")
                {
                    i++;
                    if (txt_menu != "")
                    {
                        txt_menu += "</div>";
                    }

                    txt_menu += "<a href='#" + i + "' class='list-group-item active' data-toggle='collapse'>" +
                        "<span class='glyphicon glyphicon-tag'></span>&nbsp;&nbsp;" + r.Service +
                        "<span class='badge' style='font-size: 16px'>" + r.Flag + "</span><span class='caret'></span></a>" +
                        "<div class='collapse list-group-level1 ' id='" + i + "'>";
                }
                else
                {
                    txt_menu += "<a class='list-group-item' type='button' onclick='List_Table(" + r.Service_ID + ")' data-parent='#" + i + "'>" + r.ServiceName +
                        "<span class='badge' style='font-size: 16px'>" + r.Flag + "</span></a>";
                }
            }
            txt_menu += "</div>";
        }
        else
        {
            txt_menu = "<a class='list-group-item active' data-toggle='collapse'>" +
                "<span class='glyphicon glyphicon-tag'></span>&nbsp;&nbsp;全部" +
                "<span class='badge' style='font-size: 16px'>0</span></a>";
        }
        return txt_menu;
    }

    //==============================================
    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Check_Value(string flag, string id, string sysid, string title, string content)
    {
        string error = "傳送系統參數錯誤，請再嘗試或詢問管理人員，謝謝。";
        string re = "";
        try
        {
            if (flag != "0" & flag != "1") { return JsonConvert.SerializeObject(new { status = error, flag = "1" }); }
            if (id.Trim() == "") { return JsonConvert.SerializeObject(new { status = "請選擇【文章項目】", flag = "1" }); }
            int i = Int32.Parse(id.Trim());
            int s = Int32.Parse(sysid.Trim());
            Thread.Sleep(100);
            //================【欄位驗證】==================
            string back = "";
            List<XXS> check_value = new List<XXS>();
            check_value.Add(new XXS { URL_ID = title, MiniLen = 1, MaxLen = 50, Alert_Name = "文章標題", URL_Type = "txt" });
            check_value.Add(new XXS { URL_ID = content, MiniLen = 1, MaxLen = 500, Alert_Name = "文章內容", URL_Type = "txt" });
            JavaScriptSerializer Serializer = new JavaScriptSerializer();
            string outputJson = Serializer.Serialize(check_value);
            back = JASON.Check_XSS(outputJson);
            if (back != "")
            {
                return JsonConvert.SerializeObject(new { status = back, flag = "1" });
            };
            Thread.Sleep(100);
            //==========================================
            if (flag == "0")
            {
                re = Forum_insert(i.ToString().Trim(), title.Trim(), content.Trim());
                if (re != "")
                {
                    Thread.Sleep(100);
                    return JsonConvert.SerializeObject(new { status = re, flag = "1" });
                }
                else
                {
                    Thread.Sleep(300);
                    return JsonConvert.SerializeObject(new { status = "文章新增完成", flag = "0" });
                }
            }
            else
            {
                re = Forum_update(s.ToString().Trim(), i.ToString().Trim(), title.Trim(), content.Trim());
                if (re != "")
                {
                    Thread.Sleep(100);
                    return JsonConvert.SerializeObject(new { status = re, flag = "1" });
                }
                else
                {
                    Thread.Sleep(300);
                    return JsonConvert.SerializeObject(new { status = "文章修改完成", flag = "0" });
                }
            }
        }
        catch(Exception err)
        {
            return JsonConvert.SerializeObject(new { status = error + "  err=" + err, flag = "1" });
        }
    }

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Look_Page(string ID)
    {
        Check();
        string Sqlstr = "";
        Sqlstr = @"SELECT TOP 1 * FROM View_Forum WHERE Flag = '1' AND SYSID=@SYSID ";
        var a = DBTool.Query<Location_str>(Sqlstr, new { SYSID = ID }).ToList().Select(p => new
        {
            SYSID = p.SYSID,
            Service = "【" + p.Service + "】【" + p.ServiceName + "】文章瀏覽",
            txt_Title = "※ " + p.txt_Title,
            txt_Content = p.txt_Content,
            Create_Time = "作者：" + p.Create_Name + "<br />發佈時間：" + p.Create_Time.ToString("yyyy/MM/dd HH:mm"),
            Update = "修改人員：" + p.Update_Name + "<br />修改時間：" + Check_Time(p.Update_Time.ToString("yyyy/MM/dd HH:mm"))
            // test = test(p.SYSID)
        });
        string outputJson = JsonConvert.SerializeObject(a);
        return outputJson;
    }
    //=============================================

    [WebMethod(EnableSession = true)]//或[WebMethod(true)]
    public static string Edit_Page(string ID)
    {
        Check();
        string Sqlstr = "";
        Sqlstr = @"SELECT TOP 1 * FROM View_Forum WHERE Flag = '1' AND SYSID=@SYSID ";
        var a = DBTool.Query<Location_str>(Sqlstr, new { SYSID = ID });

        if (a.Count() > 0)
        {
            var b = a.ToList().Select(p => new
            {
                SYSID = p.SYSID,
                Service = p.Service,
                txt_Title = p.txt_Title,
                txt_Content = p.txt_Content
            });
            return JsonConvert.SerializeObject(b);
        }
        else
        {
            return "[" + JsonConvert.SerializeObject(new
            {
                SYSID = "NULL"
            }) + "]"; // 組合JSON 格式
        }
    }
    //=============================================
    public static string Check_Time(string time)
    {
        if (time == "0001/01/01 00:00")
        {
            return "";
        }
        else
        {
            return time;
        }
    }

    //=============================================

    public static string Forum_insert(string id, string title, string content)
    {
        string sqlstr = "";

        //==========================================
        sqlstr = @"SELECT Service_ID FROM Data WHERE Service_ID=@Service_ID AND Open_Flag='1' ";
        var a = DBTool.Query<ClassTemplate>(sqlstr, new { Service_ID = id });
        if (a.Count() == 0)
        {
            return "沒有此服務項目。";
        }
        //==========================================

        sqlstr = @"SELECT SYSID FROM Forum WHERE Service_ID=@Service_ID AND txt_Title=@txt_Title AND txt_Content=@txt_Content ";
        a = DBTool.Query<ClassTemplate>(sqlstr, new { Service_ID = id, txt_Title = title, txt_Content = content });
        if (a.Count() > 0)
        {
            return "請勿重複發送文章。";
        }

        //sqlstr = "INSERT INTO Forum (Service_ID, txt_Title, txt_Content, Create_Name, Create_ID, Create_Time ) " +
        //"VALUES (@Service_ID, @txt_Title, @txt_Content, @Create_Name, @Create_ID, GETDATE()) ";
        sqlstr = @"INSERT INTO Forum (Service_ID, Service, ServiceName, txt_Title, txt_Content, 
            Create_Name, Create_ID, Create_Time ) 
            Select Top 1 @Service_ID, Service, ServiceName, @txt_Title, @txt_Content, 
            @Create_Name, @Create_ID, GETDATE() From Data Where Service_ID = @Service_ID ";
        Location_str update = new Location_str()
        {
            Service_ID = id,
            txt_Title = title,
            txt_Content = content,
            Create_ID = HttpContext.Current.Session["UserID"].ToString(),
            Create_Name = HttpContext.Current.Session["UserIDNAME"].ToString()
        };

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);
        return "";
    }

    public static string Forum_update(string sysid, string id, string title, string content)
    {
        string sqlstr = "";

        //==========================================
        sqlstr = @"SELECT Service_ID FROM Data WHERE Service_ID=@Service_ID AND Open_Flag='1' ";
        var a = DBTool.Query<ClassTemplate>(sqlstr, new { Service_ID = id });
        if (a.Count() == 0)
        {
            return "沒有此服務項目。";
        }

        sqlstr = "UPDATE Forum SET Service_ID=@Service_ID, txt_Title=@txt_Title, txt_Content=@txt_Content, " +
            "Update_Name=@Update_Name, Update_ID=@Update_ID, Update_Time=GETDATE() " +
            "WHERE SYSID=@SYSID AND Flag='1' ";
        Location_str update = new Location_str()
        {
            SYSID = sysid,
            Service_ID = id,
            txt_Title = title,
            txt_Content = content,
            Update_ID = HttpContext.Current.Session["UserID"].ToString(),
            Update_Name = HttpContext.Current.Session["UserIDNAME"].ToString()
        };

        using (IDbConnection db = DBTool.GetConn())
            db.Execute(sqlstr, update);
        return "";
    }

    public class Location_str
    {
        public string SYSID { get; set; }
        public string Service_ID { get; set; }
        public string Service { get; set; }
        public string ServiceName { get; set; }
        public string Create_ID { get; set; }
        public string Create_Name { get; set; }
        public DateTime Create_Time { get; set; }
        public string Update_ID { get; set; }
        public string Update_Name { get; set; }
        public DateTime Update_Time { get; set; }
        public string txt_Content { get; set; }
        public string txt_Title { get; set; }
        public string Click { get; set; }
        public string Open_Flag { get; set; }
    }
}
