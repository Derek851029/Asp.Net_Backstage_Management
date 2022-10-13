using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MemberEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }


    /// <summary>
    /// 取得家長資料
    /// </summary>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string bindata()
    {
        string sqlcmd = @" SELECT * FROM LineMember WHERE LMBID = @ID ";

        string LMBID = HttpContext.Current.Session["MemberEdit"].ToString();

        var data = DBTool.Query(sqlcmd, new { ID = LMBID });//LINE會員資料


        if (data.Any())
        {
            sqlcmd = @" SELECT SYSID,Agent_Name,Agent_Company,Agent_Phone_2,Agent_Team,Agent_Mail
                        FROM DispatchSystem WHERE LineUserID = @u ";
            string UserID = data.FirstOrDefault().UserID;
            var user = DBTool.Query(sqlcmd, new { u = UserID });

            return JsonConvert.SerializeObject(new { 
                LMBID = LMBID,
                LineName = data.FirstOrDefault().UserName,
                user = DBTool.Query(sqlcmd, new { u = UserID }).FirstOrDefault()
            });
        }

        return "";
    }

    [WebMethod(EnableSession = true)]
    public static string agentlist()
    {
        string sqlcmd = @" SELECT Agent_Name,SYSID FROM DispatchSystem WHERE Agent_Status = '在職' ";
        return JsonConvert.SerializeObject(DBTool.Query(sqlcmd, new { }));
    }

    [WebMethod(EnableSession = true)]
    public static string bindagent(string id)
    {
        string sqlcmd = @" SELECT SYSID,Agent_Name,Agent_Company,Agent_Phone_2,Agent_Team,Agent_Mail FROM DispatchSystem WHERE SYSID = @SYSID ";
        return JsonConvert.SerializeObject(DBTool.Query(sqlcmd, new { SYSID = id }).FirstOrDefault());
    }

    /// <summary>
    /// 修改家長資料
    /// </summary>
    /// <param name="data"></param>
    /// <returns></returns>
    [WebMethod(EnableSession =true)]
    public static string EditUser(string LMBID, string ID)
    {
        string sqlcmd = "";

        try
        {
            sqlcmd = @" SELECT * FROM LineMember WHERE LMBID = @ID ";
            string UserID = DBTool.Query(sqlcmd,new { ID = LMBID }).FirstOrDefault().UserID;

            //更新人員資料
            sqlcmd = @" UPDATE DispatchSystem SET 
                           LineUserID = @u
                           WHERE SYSID = @ID ";
            DBTool.Query(sqlcmd, new { u = UserID, ID = ID});

            return "編輯成功";
        }
        catch(Exception ex)
        {
            sqlcmd = @" INSERT INTO SystemLog (PageName,PageFunc,PageLog,PageParams,EX,IP,UserID) 
                        VALUES ('MemberEdit','EditUser','修改LINE對應會員資料',@data,@ex,@ip,@u ) ";
            DBTool.Query(sqlcmd, new { 
                data = ID,
                ex = ex.Message+";"+ex.StackTrace,
                ip = "",
                u = ""
            });

            return "編輯失敗";

        }
    }


}