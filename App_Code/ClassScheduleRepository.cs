﻿using System;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using Dapper;
using log4net;
using log4net.Config;
/// <summary>
/// ClassScheduleRepository 的摘要描述
/// </summary>
public class ClassScheduleRepository : System.Web.UI.Page
{
    static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    public ClassScheduleRepository()
    {

    }

    public static void GenClassClassSchedule(int year, int month)
    {
        string insertsqlstr = @"if not exists (SELECT * FROM [InSpecation_Dimax].[dbo].[Mission_Case] WHERE Year = year(@datetime) and Month = month(@datetime) " +
    "AND Title_ID = @Template_SYS_ID ) " +
    "begin INSERT INTO [InSpecation_Dimax].[dbo].[Mission_Case] (" +//正在改這邊
    "Creat_Agent, " +
    "Title_ID, " +
    "Year, " +
    "Month, " +
    "Title_Name, " +    //第五
    "Cycle, " +
    "Telecomm_ID, " +
    "APPNAME, " +
    "APP_MTEL, " +
    "ADDR, " +      //第十
    "Type, " +
    "Type_Value, " +
    "Agent_ID, " +
    "Handle_Agent, " +
    "UserID, " +        //第十五
    "OnSpotTime, " +
    "Case_ID " +
    ") " +

    "VALUES ( " +
    "'自動產生', " +
    "@Template_SYS_ID, " +
    "Year(@datetime), " +
    "Month(@datetime), " +
    "@ClassName, " +    //第五
    "@ClassTimeType, " +
    "@Telecomm_ID, " +
    "@NAME, " +
    "@MTEL, " +
    "@ADDR, " +  //第十
    "'未到點', " +
    "'1', " +
    "@Agent_ID, " +
    "@Handle_Agent, " +
    "@UserID, " +       //第十五
    "@datetime, " +
    //"(select CAST(Year+right('0'+CAST(Month AS VARCHAR(2)), 2)+'001' AS decimal(18, 0))+CAST(count(SYSID) AS decimal(18, 0)) " +
    //"FROM [InSpecation_Dimax].[dbo].[Mission_Case] where Year= year(@datetime) and Month =month(@datetime) group by Year, Month ) " + //Group by 在沒資料時 不會出現 0 
    "( Select CAST(CONVERT(varchar,Year(@datetime ) )+right('0'+CAST(Month(@datetime ) AS VARCHAR(2)), 2)+'001'AS decimal(18, 0))" +
    "+count(SYSID)FROM [InSpecation_Dimax].[dbo].[Mission_Case] where Year= Year(@datetime) and Month =Month(@datetime) )" +
    ") end  " +
    "Update Top(1) [InSpecation_Dimax].[dbo].[Mission_Case] set " + //每月第一筆好像沒 Case_ID
    "Case_ID = CAST(YEAR(@datetime) AS VARCHAR(4))+ right('0'+CAST(MONTH(@datetime) AS VARCHAR(2)), 2)+'001' " +
    "where Year = year(@datetime) and Month=month(@datetime) and Case_ID is null "+
    "";
        IDbConnection conn = null;
        IDbTransaction tran = null;
        try
        {
            conn = DBTool.GetConn();
            conn.Open();
            tran = conn.BeginTransaction();
            conn.Execute(insertsqlstr, GetClassSchedule(year, month), tran);
            tran.Commit();
        }
        catch (Exception err)
        {
            tran.Rollback();
            logger.Info(err);
            throw err;
        }
        finally
        {
            if (tran != null)
                tran.Dispose();
            if (conn != null)
                conn.Dispose();
        }
    }
    /// <summary>
    /// 將ClassTemplate轉成指定年月ClassSchedule
    /// </summary>
    /// <param name="year"></param>
    /// <param name="month"></param>
    /// <returns></returns>
    private static List<ClassSchedule> GetClassSchedule(int year, int month)
    {
        List<ClassSchedule> result = new List<ClassSchedule>();
        //宣告台灣日期
        Calendar calendar1 = new TaiwanCalendar();
        //取得範本資料
        List<ClassTemplate> classtemplatelist = getClassTemplateList(false, month).ToList();

        //將設定年月執行
        //for (int i = 1; i <= DateTime.DaysInMonth(year, month); i++)
        for (int i = DateTime.DaysInMonth(year, month); i >= DateTime.DaysInMonth(year, month)-14; i--)
        {
            Func<ClassTemplate, bool> func = null;
            DateTime date = new DateTime(year, month, i);
            switch (calendar1.GetDayOfWeek(date))
            {
                case DayOfWeek.Sunday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Sun; };
                    logger.Info("第" + i + "次,年：" + year + ",月：" + month + ", Week：" + calendar1.GetDayOfWeek(date) + "," + date + ", func = " + func);
                    break;
                case DayOfWeek.Monday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Mon; };
                    logger.Info("第" + i + "次,年：" + year + ",月：" + month + ", Week：" + calendar1.GetDayOfWeek(date) + "," + date + ", func = " + func);
                    break;
                case DayOfWeek.Tuesday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Tue; };
                    logger.Info("第" + i + "次,年：" + year + ",月：" + month + ", Week：" + calendar1.GetDayOfWeek(date) + "," + date + ", func = " + func);
                    break;
                case DayOfWeek.Wednesday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Wed; };
                    logger.Info("第" + i + "次,年：" + year + ",月：" + month + ", Week：" + calendar1.GetDayOfWeek(date) + "," + date + ", func = " + func);
                    break;
                case DayOfWeek.Thursday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Thu; };
                    logger.Info("第" + i + "次,年：" + year + ",月：" + month + ", Week：" + calendar1.GetDayOfWeek(date) + "," + date + ", func = " + func);
                    break;
                case DayOfWeek.Friday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Fri; };
                    logger.Info("第" + i + "次,年：" + year + ",月：" + month + ", Week：" + calendar1.GetDayOfWeek(date) + "," + date + ", func = " + func);
                    break;
                case DayOfWeek.Saturday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Sat; };
                    logger.Info("第" + i + "次,年：" + year + ",月：" + month + ", Week：" + calendar1.GetDayOfWeek(date) + "," + date + ", func = " + func);
                    break;
            }
            result.AddRange(classtemplatelist.Where(func).Select(p => combineSchedule(p, date)));
        }
        return result;
    }


    /// <summary>
    /// 取得指定年月的ClassSchedule
    /// </summary>
    /// <param name="year"></param>
    /// <param name="month"></param>
    /// <returns></returns>
    public static List<ClassSchedule> GetClassScheduleList(int year, int month)
    {
        //string sqlstr = @"select * FROM [Faremma].[dbo].[ClassSchedule] " +
        //    "WHERE WORK_DATETime between @startDate AND @ednDate";

        string sqlstr = @"select * FROM [InSpecation_Dimax].[dbo].[Mission_Title] " +                                                   //待改?    已改部分
            "WHERE M_" + month + " = '1' " +
            "AND Flag = '1' ";           

        return DBTool.Query<ClassSchedule>(sqlstr, new
        {
            startDate = new DateTime(year, month, 1),
            ednDate = new DateTime(year, month, new TaiwanCalendar().GetDaysInMonth(year, month))
        }).ToList();
    }

    private static ClassSchedule combineSchedule(ClassTemplate classtemplate, DateTime datetime)
    {
        try
        {
            //4/4/2010 4:20:00 PM
            //string workstr = string.Format("{0} {1}:{2}:00 {3}", datetime.ToString("d/M/yyyy"));
            //string dialstr = string.Format("{0} {1}:{2}:00 {3}", datetime.ToString("d/M/yyyy"));
            string workstr = string.Format("{0} {1}:{2}:00 {3}", datetime.ToString("d/M/yyyy"), "07", "30", "上午");
            string dialstr = string.Format("{0} {1}:{2}:00 {3}", datetime.ToString("d/M/yyyy"), "06", "00", "下午");
            //string dialstr = string.Format("{0} {1}:{2}:00 {3}", datetime.ToString("d/M/yyyy"), classtemplate.DIAL_TimeHour, classtemplate.DIAL_TimeMin, classtemplate.WORK_TimeType);
            DateTime WORK_DATETime = DateTime.ParseExact(workstr, "d/M/yyyy h:m:ss tt", CultureInfo.GetCultureInfo("zh-tw"));
            DateTime DIAL_DATETime = DateTime.ParseExact(dialstr, "d/M/yyyy h:m:ss tt", CultureInfo.GetCultureInfo("zh-tw"));
            logger.Info(WORK_DATETime + "," + DIAL_DATETime);

            logger.Info("SYS_ID 001 = " + classtemplate.SYS_ID);
            logger.Info("mission_name = " + classtemplate.mission_name);
            //logger.Info("MASTER1_ID = " + classtemplate.MASTER1_ID);
            //logger.Info("MASTER1_NAME = " + classtemplate.MASTER1_NAME);
            logger.Info("現在時間為：" + DateTime.Now.TimeOfDay);

            return new ClassSchedule()
            {
                #region 組合資料
                /*Template_SYS_ID = classtemplate.SYS_ID,
            ClassName = classtemplate.ClassName,
            ClassTimeType = classtemplate.ClassTimeType,
            WORK_DATETime = WORK_DATETime,
            DIAL_DATETime = DIAL_DATETime,
            MASTER1_ID = classtemplate.MASTER1_ID,
            MASTER1_NAME = classtemplate.MASTER1_NAME,
            MASTER1_TEL = classtemplate.MASTER1_TEL,
            MASTER2_ID = classtemplate.MASTER2_ID,
            MASTER2_NAME = classtemplate.MASTER2_NAME,
            MASTER2_TEL = classtemplate.MASTER2_TEL,
            MASTER_Company = classtemplate.MASTER_Company,
            MASTER_Team = classtemplate.MASTER_Team,
            MASTER_ID = classtemplate.MASTER_ID,
            MASTER_Name = classtemplate.MASTER_Name,
            MASTER_TEL = classtemplate.MASTER_TEL,  //*/
                Template_SYS_ID = classtemplate.SYS_ID,     //SYSID
                ClassName = classtemplate.mission_name,        //mission_name
                ClassTimeType = classtemplate.ClassTimeType,
                WORK_DATETime = WORK_DATETime,
                DIAL_DATETime = DIAL_DATETime,

                Telecomm_ID = classtemplate.T_ID,
                ADDR = classtemplate.ADDR,
                Name = classtemplate.Name,
                MTEL = classtemplate.MTEL,
                Agent_ID = classtemplate.Agent_ID,
                Handle_Agent = classtemplate.Agent_Name,
                UserID = classtemplate.UserID,

                datetime = datetime,
                MASTER1_ID = "MASTER1_ID",
                MASTER1_NAME = "MASTER1_NAME",
                MASTER1_TEL = "MASTER1_TEL",
                MASTER2_ID = "MASTER2_ID",
                MASTER2_NAME = "MASTER2_NAME",
                MASTER2_TEL = "MASTER2_TEL",
                MASTER_Company = "MASTER_Company",
                MASTER_Team = "MASTER_Team",
                MASTER_ID = "MASTER_ID",
                MASTER_Name = "MASTER_Name",
                MASTER_TEL = "MASTER_TEL",

                Partner_Company = "",
                Partner_Driver = "",
                Partner_Phone = "",
                DRIVER_STATE = "等待外撥",
                DRIVER_DIAL_TIME = "0",
                MASTER1_STATE = "等待外撥",
                MASTER1_DIAL_TIME = "0",
                MASTER2_STATE = "等待外撥",
                MASTER2_DIAL_TIME = "0"
                #endregion
            };
        }
        catch (Exception err)
        {
            logger.Info(err);
            throw err;
        }
    }
    private static IEnumerable<ClassTemplate> getClassTemplateList(bool ClassDisable, int month)
    {
        string mon = month.ToString();
        string sqlstr = "select SYSID as SYS_ID, mission_name, Cycle as ClassTimeType, * "+
            ", CAST('1' AS decimal(18, 0)) as ClassWeek_Mon, CAST('1' AS decimal(18, 0)) as ClassWeek_Tue,  CAST('1' AS decimal(18, 0)) as ClassWeek_Wed,  CAST('1' AS decimal(18, 0)) as ClassWeek_Thu, CAST('1' AS decimal(18, 0)) as ClassWeek_Fri, CAST('0' AS decimal(18, 0)) as ClassWeek_Sat, CAST('0' AS decimal(18, 0)) as ClassWeek_Sun " +
            "FROM [InSpecation_Dimax].[dbo].[Mission_Title] where Flag='1' and M_" + mon + " = '1' ";  //*/
        //string sqlstr = "select * FROM [Faremma].[dbo].[ClassTemplate] where ClassDisable=@ClassDisable";
        return DBTool.Query<ClassTemplate>(sqlstr, new { ClassDisable = ClassDisable }
            );
    }

    public static List<ClassSchedule> GetClassScheduleList(DateTime WORK_DATETime, string ClassName)  // 設定 title 要帶哪個欄位的資料
    {
        logger.Info("WorkDate = " + WORK_DATETime + " , Agent_Name = " + ClassName);
        string sqlstr = @"select * 
                          from [Faremma].[dbo].[Rep_Classes2016]
                          where Cast(WORK_DATE as date) = @WORK_DATETime AND Class=@ClassName ";
        return DBTool.Query<ClassSchedule>(sqlstr,
            new
            {
                WORK_DATETime = WORK_DATETime,
                ClassName = ClassName
            }).ToList();
    }

    public static List<fCeventItem> GetClassGroup(int year, int month)  // 設定 title 要帶哪個欄位的資料
    {
        string sqlstr = @"select ClassName as title,Cast(WORK_DATETime as date) as start
                          FROM [Faremma].[dbo].[ClassSchedule]
                          where WORK_DATETime between @startDate AND @ednDate
                          group by ClassName,Cast(WORK_DATETime as date)";
        return DBTool.Query<fCeventItem>(sqlstr, new
        {
            startDate = new DateTime(year, month, 1),
            ednDate = new DateTime(year, month, new TaiwanCalendar().GetDaysInMonth(year, month))
        }).ToList();
    }
    public static List<fCeventItem> GetClassGroup(DateTime start, DateTime end)  // 設定 title 要帶哪個欄位的資料
    {
        string sqlstr = @"select Class as title,Cast(WORK_DATE as date) as start
                          from [Faremma].[dbo].[Rep_Classes2016]
                          where WORK_DATE between @startDate AND @ednDate
                          group by Class,Cast(WORK_DATE as date)";
        return DBTool.Query<fCeventItem>(sqlstr, new
        {
            startDate = start,
            ednDate = end
        }).ToList();
    }

    public static ClassSchedule GetClassSchedule(int seqno)
    {
        string sqlstr = @"select * from [Faremma].[dbo].[Rep_Classes2016]
                          where SYS_ID=@SYS_ID";
        var list = DBTool.Query<ClassSchedule>(sqlstr, new { SYS_ID = seqno });
        if (list.Count() > 0)
            return list.First();
        else
            return null;
    }

    //=======================================================

    public static List<ClassSchedule> _0020010004_ClassScheduleList(DateTime Work_Day, string Agent_Name)  // 設定 title 要帶哪個欄位的資料
    {
        logger.Info("Work_Day = " + Work_Day + " , Agent_Name = " + Agent_Name);
        string sqlstr = @"select * 
                          from [Faremma].[dbo].[AgentWorkDate]
                          where Cast(Work_Day as date) = @Work_Day AND Agent_Name=@Agent_Name ";
        return DBTool.Query<ClassSchedule>(sqlstr,
            new
            {
                Work_Day = Work_Day,
                Agent_Name = Agent_Name
            }).ToList();
    }

    public static List<fCeventItem> _0020010004_GetClassGroup(DateTime start, DateTime end, string Agent_ID)  // 設定 title 要帶哪個欄位的資料
    {
        string sqlstr = @"select Agent_Name as title,Cast(Work_Day as date) as start
                          from [Faremma].[dbo].[AgentWorkDate]
                          where Work_Day between @startDate AND @ednDate AND Agent_ID = @Agent_ID
                          group by Agent_Name,Cast(Work_Day as date)";
        return DBTool.Query<fCeventItem>(sqlstr, new
        {
            startDate = start,
            ednDate = end,
            Agent_ID = Agent_ID
        }).ToList();
    }

    public static bool _0020010004_Delete(string seqno)
    {
        int iseqno = 0;
        if (!int.TryParse(seqno, out iseqno))
            throw new Exception("來源資料不是數字");
        //Disable：是否停用該班次0:啟用; 1:停用
        String Sqlstr = @"DELETE [Faremma].[dbo].[AgentWorkDate] where SYS_ID=@SYS_ID";
        using (IDbConnection conn = DBTool.GetConn())
        {
            conn.Execute(Sqlstr, new { SYS_ID = seqno });
        }
        return true;
    }

    //=======================================================

    public static List<fCeventItem> _0030010002_GetClassGroup(DateTime start, DateTime end, string Agent_Team, string Agent_ID, string Agent_LV, string time)  // 設定 title 要帶哪個欄位的資料
    {
        string MNo_Flag = System.Web.Configuration.WebConfigurationManager.AppSettings["MNo_Flag"].ToString();
        string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Cast(Time_01 as date) as start, Type as type, Type_Value as value " +
                          "FROM [Faremma].[dbo].[LaborTemplate] " +
                          "WHERE Time_01 between @startDate AND @ednDate ";

        if (time == "1")  // time = 1 顯示上午班
        {
            sqlstr += " AND convert(varchar, Time_01, 114) > '00:00:00' AND convert(varchar, Time_01, 114) < '12:00:00:000'";
        }

        if (time == "2")  // time = 2 顯示下午班
        {
            sqlstr += " AND convert(varchar, Time_01, 114) > '12:00:00' AND convert(varchar, Time_01, 114) < '23:59:59:999'";
        }
        //使用者權限非 30 主管 則只能看見自己部門創建的單

        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND Create_Team = @Agent_Team ";
                break;

            case "30":
                break;

            default:
                if (MNo_Flag == "0")
                {
                    sqlstr += " AND Type_Value != 0 AND Create_Team = @Agent_Team ";
                }
                else
                {
                    sqlstr += " AND Type_Value != 0 AND Create_ID = @Agent_ID ";
                }
                break;
        }

        sqlstr += " group by Type,Cast(Time_01 as date),Type_Value";
        return DBTool.Query<fCeventItem>(sqlstr, new
        {
            startDate = start,
            ednDate = end,
            Agent_Team = Agent_Team,
            Agent_ID = Agent_ID
        }).ToList();
    }

    public static List<fCeventItem> _0040010001_GetClassGroup(DateTime start, DateTime end, string Agent_Team, string Agent_LV, string time)  // 設定 title 要帶哪個欄位的資料
    {
        //logger.Info("start = " + start + " , end = " + end + " , time = " + time);
        // time = 0 顯示全部
        // time = 1 顯示上午班
        // time = 2 顯示下午班

        string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Cast(Time_01 as date) as start, Type as type, Type_Value as value " +
                          "FROM [Faremma].[dbo].[LaborTemplate] " +
                          "WHERE Time_01 BETWEEN @startDate AND @ednDate AND Type_Value != 0 AND Type_Value != 5";

        if (time == "1")  // time = 1 顯示上午班
        {
            sqlstr += " AND convert(varchar, Time_01, 114) > '00:00:00' AND convert(varchar, Time_01, 114) < '12:00:00:000'";
        }

        if (time == "2")  // time = 2 顯示下午班
        {
            sqlstr += " AND convert(varchar, Time_01, 114) > '12:00:00' AND convert(varchar, Time_01, 114) < '23:59:59:999'";
        }

        //使用者權限非 30 主管 則只能看見自己部門創建的單

        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND Create_Team = @Agent_Team ";
                break;

            case "30":
                break;

            default:
                sqlstr += "AND Create_Team = @Agent_Team ";
                break;
        }

        sqlstr += " group by Type,Cast(Time_01 as date),Type_Value";
        return DBTool.Query<fCeventItem>(sqlstr, new
        {
            startDate = start,
            ednDate = end,
            Agent_Team = Agent_Team
        }).ToList();
    }

    public static List<ClassSchedule> _0040010001_ClassScheduleList(DateTime WORK_DATETime, string Type, string Create_Team, string Agent_LV, string str_time)  // 設定 title 要帶哪個欄位的資料
    {
        //logger.Info("Create_Team = " + Create_Team + "_Type = " + Type + "_Agent_LV = " + Agent_LV + "_str_time = " + str_time);
        // str_time = 0 顯示全部
        // str_time = 1 顯示上午班
        // str_time = 2 顯示下午班
        string sqlstr = @"SELECT SYS_ID, ISNULL(SYSID, '0') as SYSID, MNo, Type, Type_Value, Time_01, ServiceName, Cust_Name, Labor_CName, Labor_ID, Question, Create_Name " +
            " FROM [Faremma].[dbo].[LaborTemplate] AS a " +
            " outer apply ( select top 1 SYSID from CASEDetail WHERE a.MNo=MNo AND type !='暫結案' ) AS b " +
            " WHERE Cast(Time_01 as date) = @WORK_DATETime AND Type_Value=@Type";

        if (str_time == "1")  // time = 1 顯示上午班
        {
            sqlstr += " AND convert(varchar, Time_01, 114) > '00:00:00' AND convert(varchar, Time_01, 114) < '12:00:00:000'";
        }

        if (str_time == "2")  // time = 2 顯示下午班
        {
            sqlstr += " AND convert(varchar, Time_01, 114) > '12:00:00' AND convert(varchar, Time_01, 114) < '23:59:59:999'";
        }

        //使用者權限非 20 主管 則只能看見自己創建的單
        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND Create_Team = @Create_Team ";
                break;

            case "30":
                break;

            default:
                sqlstr += " AND Create_Team = @Create_Team ";
                break;
        }

        return DBTool.Query<ClassSchedule>(sqlstr,
            new
            {
                WORK_DATETime = WORK_DATETime,
                Type = Type,
                Create_Team = Create_Team
            }).ToList();
    }

    //==================  個人派工及結案管理頁面 過濾掉 非自己部門的單  ======================

    public static List<fCeventItem> _0020010005_GetClassGroup(DateTime start, DateTime end, string Agent_ID, string Agent_LV, string Agent_Team, string str_time)  // 設定 title 要帶哪個欄位的資料
    {
        string CNo_Flag = System.Web.Configuration.WebConfigurationManager.AppSettings["CNo_Flag"].ToString();
        string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Cast(StartTime as date) as start, Type as type, Type_Value as value " +
                          " FROM CASEDetail WHERE StartTime between @startDate AND @ednDate ";

        if (str_time == "1")  // time = 1 顯示上午班
        {
            sqlstr += " AND convert(varchar, StartTime, 114) > '00:00:00' AND convert(varchar, StartTime, 114) < '12:00:00:000'";
        }

        if (str_time == "2")  // time = 2 顯示下午班
        {
            sqlstr += " AND convert(varchar, StartTime, 114) > '12:00:00' AND convert(varchar, StartTime, 114) < '23:59:59:999'";
        }

        //使用者權限非 20 主管 則只能看見自己創建的單

        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND Agent_Team = @Agent_Team";
                break;

            case "30":
                break;

            default:
                if (CNo_Flag == "0")
                {
                    sqlstr += " AND Agent_Team = @Agent_Team";
                }
                else
                {
                    sqlstr += " AND Agent_ID = @Agent_ID";
                }
                break;
        }

        sqlstr += " group by Type,Cast(StartTime as date),Type_Value";
        return DBTool.Query<fCeventItem>(sqlstr, new
        {
            startDate = start,
            ednDate = end,
            Agent_ID = Agent_ID,
            Agent_Team = Agent_Team
        }).ToList();
    }

    public static List<ClassSchedule> _0020010005_ClassScheduleList(DateTime WORK_DATETime, string Type, string Agent_ID, string Agent_LV, string Agent_Team, string str_time)   // 設定 title 要帶哪個欄位的資料
    {
        string CNo_Flag = System.Web.Configuration.WebConfigurationManager.AppSettings["CNo_Flag"].ToString();
        string sqlstr = @"select * from CASEDetail where Cast(StartTime as date) = @WORK_DATETime AND Type=@Type";
        //使用者權限非 20 主管 則只能看見自己創建的單

        if (str_time == "1")  // time = 1 顯示上午班
        {
            sqlstr += " AND convert(varchar, StartTime, 114) > '00:00:00' AND convert(varchar, StartTime, 114) < '12:00:00:000'";
        }

        if (str_time == "2")  // time = 2 顯示下午班
        {
            sqlstr += " AND convert(varchar, StartTime, 114) > '12:00:00' AND convert(varchar, StartTime, 114) < '23:59:59:999'";
        }

        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND Agent_Team = @Agent_Team";
                break;

            case "30":
                break;

            default: if (CNo_Flag == "0")
                {
                    sqlstr += " AND Agent_Team = @Agent_Team";
                }
                else
                {
                    sqlstr += " AND Agent_ID = @Agent_ID";
                }
                break;
        }

        return DBTool.Query<ClassSchedule>(sqlstr,
            new
            {
                WORK_DATETime = WORK_DATETime,
                Type = Type,
                Agent_ID = Agent_ID,
                Agent_Team = Agent_Team
            }).ToList();
    }

    public static List<fCeventItem> _0020010006_GetClassGroup(DateTime start, DateTime end, string Create_Team, string Agent_LV)  // 設定 title 要帶哪個欄位的資料
    {
        string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Cast(Time_01 as date) as start, Type as type, Type_Value as value
                          from LaborTemplate
                          where Time_01 between @startDate AND @ednDate AND Type_Value in (1, 5)";

        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND Create_Team=@Create_Team";
                break;

            case "30":
                break;

            default:
                sqlstr += " AND Create_Team=@Create_Team";
                break;
        }

        sqlstr += " group by Type,Cast(Time_01 as date),Type_Value";

        return DBTool.Query<fCeventItem>(sqlstr, new
        {
            startDate = start,
            ednDate = end,
            Create_Team = Create_Team
        }).ToList();
    }

    public static List<ClassSchedule> _0020010006_ClassScheduleList(DateTime WORK_DATETime, string Type, string Create_Team, string Agent_LV)  // 設定 title 要帶哪個欄位的資料
    {
        string sqlstr = @"select * from LaborTemplate where Cast(Time_01 as date) = @WORK_DATETime AND Type=@Type AND Type_Value in (1, 5)";

        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND Create_Team=@Create_Team";
                break;

            case "30":
                break;

            default:
                sqlstr += " AND Create_Team=@Create_Team";
                break;
        }

        return DBTool.Query<ClassSchedule>(sqlstr,
            new
            {
                WORK_DATETime = WORK_DATETime,
                Type = Type,
                Create_Team = Create_Team,
                Agent_LV = Agent_LV
            }).ToList();
    }

    //==================  呼叫子單頁面資料  ======================

    public static ClassTemplate _0020010008_LaborTemplate(string seqno)
    {
        string sqlstr = @"select * from CASEDetail
                          where CNo=@CNo";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { CNo = seqno });
        if (list.Count() > 0)
            return list.First();
        else
            return null;
    }

    //==================  員工派工管理頁面 過濾掉 退單  ======================

    public static List<fCeventItem> _0040010001_GetClassGroup(DateTime start, DateTime end)  // 設定 title 要帶哪個欄位的資料
    {
        //        string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Cast(Time_01 as date) as start, Type as type, Create_ID as id, Type_Value as value
        //                          from LaborTemplate
        //                          where Time_01 between @startDate AND @ednDate AND Type_Value != 5  AND Type_Value != 1
        //                          group by Type,Cast(Time_01 as date),Create_ID,Type_Value";
        string sqlstr = @"select  Type_Value + '. ' + Type +' '+ Convert(nvarchar(4),count(*)) as title, Cast(Time_01 as date) as start, Type as type,Type_Value as value
                          from LaborTemplate
                          where Time_01 between @startDate AND @ednDate AND Type_Value != 5  AND Type_Value != 1
                          group by Type,Cast(Time_01 as date),Type_Value";
        return DBTool.Query<fCeventItem>(sqlstr, new
        {
            startDate = start,
            ednDate = end
        }).ToList();
    }

    public static ClassTemplate _0040010002_GetCNo(string CNo)
    {
        logger.Info("CNo = " + CNo);
        string sqlstr = @"select * from CASEDetail
                          where CNo=@CNo";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { CNo = CNo });
        if (list.Count() > 0)
            return list.First();
        else
            return null;
    }

    public static ClassTemplate _0040010002_GetCNo_View(string CNo)
    {
        logger.Info("CNo = " + CNo);
        string sqlstr = @"select * from CASEDetail
                          where CNo=@CNo";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { CNo = CNo });
        if (list.Count() > 0)
            return list.First();
        else
            return null;
    }
    //=============================================================

    public static List<ClassSchedule> _0030010002_ClassScheduleList(DateTime WORK_DATETime, string Type, string Create_Team, string Agent_ID, string Agent_LV, string str_time)  // 設定 title 要帶哪個欄位的資料
    {
        string MNo_Flag = System.Web.Configuration.WebConfigurationManager.AppSettings["MNo_Flag"].ToString();
        string sqlstr = @"SELECT [MNo], [Type], [Type_Value], [ServiceName], " +
            "[Labor_CName], " +
            "[Labor_ID], " +
            "substring([Question],1,100) as [Question], " +
            "[Question2], " +
            "[Cust_Name], [Create_ID], [Time_01] FROM LaborTemplate WHERE Cast(Time_01 as date) = @WORK_DATETime AND Type=@Type ";

        if (str_time == "1")  // time = 1 顯示上午班
        {
            sqlstr += " AND convert(varchar, Time_01, 114) > '00:00:00' AND convert(varchar, Time_01, 114) < '12:00:00:000'";
        }

        if (str_time == "2")  // time = 2 顯示下午班
        {
            sqlstr += " AND convert(varchar, Time_01, 114) > '12:00:00' AND convert(varchar, Time_01, 114) < '23:59:59:999'";
        }
        //使用者權限非 20 主管 則只能看見自己創建的單
        switch (Agent_LV)
        {
            case "20":
                sqlstr += " AND Create_Team = @Create_Team ";
                break;

            case "30":
                break;

            default:
                if (MNo_Flag == "0")
                {
                    sqlstr += " AND Create_Team = @Create_Team ";
                }
                else
                {
                    sqlstr += " AND Create_ID = @Agent_ID ";
                }
                break;
        }

        return DBTool.Query<ClassSchedule>(sqlstr,
            new
            {
                WORK_DATETime = WORK_DATETime,
                Type = Type,
                Create_Team = Create_Team,
                Agent_ID = Agent_ID
            }).ToList();
    }

    public static ClassTemplate _0030010001_LaborTemplate(string Case_ID)
    {
        string sqlstr = @"select * from LaborTemplate
                          where Case_ID=@Case_ID";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { Case_ID = Case_ID });
        if (list.Count() > 0)
            return list.First();
        else
            return null;
    }

    //======================== SQL View TEST ========================

    public static ClassTemplate _0030010001_View_Case_ID(string Case_ID)
    {
        string sqlstr = @"SELECT * FROM CaseData WHERE Case_ID=@Case_ID";      // LaborTemplate > CaseData              002
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { Case_ID = Case_ID });
        if (list.Count() > 0)
            return list.First();
        else
            return null;
    }

    //=======================================================

    public static ClassSchedule GetUpDate(int year, int month, int i, string ClassName)
    {
        string startdate = new DateTime(year, month, i).ToString("yyyy-MM-dd 00:00:00");
        string enddate = new DateTime(year, month, i).ToString("yyyy-MM-dd 23:59:59");
        string sqlstr = @"select * FROM [Faremma].[dbo].[ClassSchedule]
                          where ClassName = @ClassName ";
        var list = DBTool.Query<ClassSchedule>(sqlstr, new { ClassName = ClassName });
        if (list.Count() > 0)
            return list.First();
        else
            return null;
    }

    //========================================================

    public static List<ClassTemplate> CMS_0060010004_AgentList()
    {
        //Disable：是否停用該班次0:啟用; 1:停用
        String Sqlstr = @"select Top 500 * from DispatchSystem where Agent_ID !='' AND Agent_Status = '在職'";
        return DBTool.Query<ClassTemplate>(Sqlstr).ToList();
    }

    public static ClassTemplate CMS_0060010002_AgentUpdate(string ROLE_ID)
    {
        string sqlstr = @"select * from ROLELIST
                          where ROLE_ID=@ROLE_ID";
        var list = DBTool.Query<ClassTemplate>(sqlstr, new { ROLE_ID = ROLE_ID });
        if (list.Count() > 0)
            return list.First();
        else
            return null;
    }

    public static List<fCeventItem> Default_Table(string Agent_Team, string Agent_LV, string Agent_ID, string Time_Flag)  // 設定 title 要帶哪個欄位的資料
    {
        string MNo_Flag = System.Web.Configuration.WebConfigurationManager.AppSettings["MNo_Flag"].ToString();
        string CNo_Flag = System.Web.Configuration.WebConfigurationManager.AppSettings["CNo_Flag"].ToString();
        string mno_time = "";
        string cno_time = "";
        string str_mno = "";
        string str_cno = "";

        if (MNo_Flag == "0")
        {
            str_mno = " Create_Team = @Agent_Team ";
        }
        else
        {
            str_mno = " Create_ID = @Agent_ID ";
        }

        if (CNo_Flag == "0")
        {
            str_cno = " Agent_Team = @Agent_Team ";
        }
        else
        {
            str_cno = " Agent_ID = @Agent_ID ";
        }

        switch (Time_Flag)
        {
            case "2":
                mno_time = "";
                cno_time = "";
                break;
            case "1":
                mno_time = "AND convert(char(6),Time_01,112) = convert(char(6),GETDATE(),112)";
                cno_time = "AND convert(char(6),StartTime,112) = convert(char(6),GETDATE(),112)";
                break;
            default:
                mno_time = "AND convert(char,Time_01,112) = convert(char,GETDATE(),112)";
                cno_time = "AND convert(char,StartTime,112) = convert(char,GETDATE(),112)";
                break;
        };

        string sqlstr = @"SELECT a.Type_1, b.Type_2, c.Type_6, d.Type_3, e.Type_4, f.Type_5, g.Type_7, h.Type_8, i.Type_9, j.Type_0 " +
            " FROM " +
            "(SELECT count(*) as Type_1 FROM [Faremma].[dbo].[LaborTemplate] where " + str_mno + " and Type_Value = '1' " + mno_time + " ) a, " +
            "(SELECT count(*) as Type_2 FROM [Faremma].[dbo].[LaborTemplate] where " + str_mno + " and Type_Value = '2' " + mno_time + " ) b, " +
            "(SELECT count(*) as Type_6 FROM [Faremma].[dbo].[CASEDetail] where " + str_cno + " and Type_Value != '5' " + cno_time + " ) c, " +
            "(SELECT count(*) as Type_9 FROM [Faremma].[dbo].[CASEDetail] where " + str_cno + " and Type_Value = '5' " + cno_time + " ) i, " +
            "(SELECT count(*) as Type_3 FROM [Faremma].[dbo].[LaborTemplate] where " + str_mno + " and Type_Value = '3' " + mno_time + " ) d, " +
            "(SELECT count(*) as Type_4 FROM [Faremma].[dbo].[LaborTemplate] where " + str_mno + " and Type_Value = '4' " + mno_time + " ) e, " +
            "(SELECT count(*) as Type_5 FROM [Faremma].[dbo].[LaborTemplate] where " + str_mno + " and Type_Value = '5' " + mno_time + " ) f, " +
            "(SELECT count(*) as Type_7 FROM [Faremma].[dbo].[LaborTemplate] where " + str_mno + " and Type_Value != '0' " + mno_time + " ) g, " +
            "(SELECT count(*) as Type_8 FROM [Faremma].[dbo].[CASEDetail] where " + str_cno + " " + cno_time + " ) h, " +
            "(SELECT count(*) as Type_0 FROM [Faremma].[dbo].[LaborTemplate] where " + str_mno + " and Type_Value = '0' " + mno_time + " ) j ";

        if (Agent_LV == "20")
        {
            sqlstr = @"SELECT a.Type_1,b.Type_2,c.Type_6,d.Type_3,e.Type_4,f.Type_5, g.Type_7, h.Type_8, i.Type_9, j.Type_0 " +
                " FROM " +
                "(SELECT count(*) as Type_1 FROM [Faremma].[dbo].[LaborTemplate] where Create_Team = @Agent_Team and Type_Value = '1' " + mno_time + " ) a, " +
                "(SELECT count(*) as Type_2 FROM [Faremma].[dbo].[LaborTemplate] where Create_Team = @Agent_Team and Type_Value = '2' " + mno_time + " ) b, " +
                "(SELECT count(*) as Type_6 FROM [Faremma].[dbo].[CASEDetail] where Agent_Team = @Agent_Team and Type_Value != '5' " + cno_time + " ) c, " +
                "(SELECT count(*) as Type_9 FROM [Faremma].[dbo].[CASEDetail] where Agent_Team = @Agent_Team and Type_Value = '5' " + cno_time + " ) i, " +
                "(SELECT count(*) as Type_3 FROM [Faremma].[dbo].[LaborTemplate] where Create_Team = @Agent_Team and Type_Value = '3' " + mno_time + " ) d, " +
                "(SELECT count(*) as Type_4 FROM [Faremma].[dbo].[LaborTemplate] where Create_Team = @Agent_Team and Type_Value = '4' " + mno_time + " ) e, " +
                "(SELECT count(*) as Type_5 FROM [Faremma].[dbo].[LaborTemplate] where Create_Team = @Agent_Team and Type_Value = '5' " + mno_time + " ) f, " +
                "(SELECT count(*) as Type_7 FROM [Faremma].[dbo].[LaborTemplate] where Create_Team = @Agent_Team " + mno_time + " ) g, " +
                "(SELECT count(*) as Type_8 FROM [Faremma].[dbo].[CASEDetail] where Agent_Team = @Agent_Team " + cno_time + " ) h, " +
                "(SELECT count(*) as Type_0 FROM [Faremma].[dbo].[LaborTemplate] where Create_Team = @Agent_Team and Type_Value = '0' " + mno_time + " ) j ";
        };

        if (Agent_LV == "30")
        {
            sqlstr = @"SELECT a.Type_1, b.Type_2, c.Type_6, d.Type_3, e.Type_4, f.Type_5, g.Type_7, h.Type_8, i.Type_9, j.Type_0 " +
                " FROM " +
                "(SELECT count(*) as Type_1 FROM [Faremma].[dbo].[LaborTemplate] where Type_Value = '1' " + mno_time + " ) a, " +
                "(SELECT count(*) as Type_2 FROM [Faremma].[dbo].[LaborTemplate] where Type_Value = '2' " + mno_time + " ) b, " +
                "(SELECT count(*) as Type_6 FROM [Faremma].[dbo].[CASEDetail] where Type_Value != '5' " + cno_time + " ) c, " +
                "(SELECT count(*) as Type_9 FROM [Faremma].[dbo].[CASEDetail] where Type_Value = '5' " + cno_time + " ) i, " +
                "(SELECT count(*) as Type_3 FROM [Faremma].[dbo].[LaborTemplate] where Type_Value = '3' " + mno_time + " ) d, " +
                "(SELECT count(*) as Type_4 FROM [Faremma].[dbo].[LaborTemplate] where Type_Value = '4' " + mno_time + " ) e, " +
                "(SELECT count(*) as Type_5 FROM [Faremma].[dbo].[LaborTemplate] where Type_Value = '5' " + mno_time + " ) f, " +
                "(SELECT count(*) as Type_7 FROM [Faremma].[dbo].[LaborTemplate] where Type_Value != '99' " + mno_time + " ) g, " +
                "(SELECT count(*) as Type_8 FROM [Faremma].[dbo].[CASEDetail] where Type_Value != '99' " + cno_time + " ) h, " +
                "(SELECT count(*) as Type_0 FROM [Faremma].[dbo].[LaborTemplate] where Type_Value = '0' " + mno_time + " ) j ";
        };

        return DBTool.Query<fCeventItem>(sqlstr, new
        {
            Agent_Team = Agent_Team,
            Agent_ID = Agent_ID
        }).ToList();
    }

    public static List<ClassTemplate> Default_Flag(string Agent_Team, string Flag, string Agent_LV, string Agent_ID)  // 設定 title 要帶哪個欄位的資料
    {
        string sqlstr = @"SELECT * FROM LaborTemplate WHERE Type_Value = @Type_Value AND Create_Team = @Create_Team";

        if (Agent_LV == "30")
        {
            sqlstr = @"SELECT * FROM LaborTemplate WHERE Type_Value = @Type_Value";
        };

        if (Flag == "6")
        {
            sqlstr = @"SELECT * FROM CASEDetail WHERE Type_Value != '5' AND Agent_ID = @Agent_ID";

            if (Agent_LV == "20")
            {
                sqlstr = @"SELECT * FROM CASEDetail WHERE Type_Value != '5' AND Agent_Team = @Create_Team";
            };

            if (Agent_LV == "30")
            {
                sqlstr = @"SELECT * FROM CASEDetail WHERE Type_Value != '5'";
            };
        }

        if (Flag == "7")
        {
            sqlstr = @"SELECT * FROM LaborTemplate WHERE Type_Value != 0 AND Create_Team = @Create_Team";

            if (Agent_LV == "20")
            {
                sqlstr = @"SELECT * FROM LaborTemplate WHERE Create_Team = @Create_Team";
            };

            if (Agent_LV == "30")
            {
                sqlstr = @"SELECT * FROM LaborTemplate";
            };
        }

        if (Flag == "8")
        {
            sqlstr = @"SELECT * FROM CASEDetail WHERE Agent_ID = @Agent_ID";

            if (Agent_LV == "20")
            {
                sqlstr = @"SELECT * FROM CASEDetail WHERE Agent_Team = @Create_Team";
            };

            if (Agent_LV == "30")
            {
                sqlstr = @"SELECT * FROM CASEDetail";
            };
        }

        return DBTool.Query<ClassTemplate>(sqlstr, new
        {
            Type_Value = Flag,
            Create_Team = Agent_Team,
            Agent_ID = Agent_ID
        }).ToList();
    }

    //=========================================================

    public static void AddNewClass(int year, int month, int day, string ClassName)
    {
        string insertsqlstr = @"if not exists (SELECT * FROM [Faremma].[dbo].[Rep_Classes2016] WHERE Template_SYS_ID = @Template_SYS_ID " +
            "AND convert(VARCHAR(10),[WORK_DATE], 111) between convert(VARCHAR(10),@WORK_DATETime, 111) " +
            "AND convert(VARCHAR(10),@WORK_DATETime, 111) ) begin INSERT INTO [Faremma].[dbo].[Rep_Classes2016] (" +
            "Template_SYS_ID, " +
            "WORK_DATE, " +
            "Class, " +
            "ClassTimeType, " +
            "DIAL_TIME, " +
            "WORK_TIME, " +
            "DRIVER_Company, " +
            "DRIVER_Team, " +
            "MASTER_ID, " +
            "MASTER_NAME, " +
            "MASTER_TEL, " +
            "DRIVER_ID, " +
            "DRIVER_NAME, " +
            "DRIVER_TEL, " +
            "DRIVER_STATE, " +
            "DRIVER_DIAL_TIME, " +
            "MASTER1_ID, " +
            "MASTER1_NAME, " +
            "MASTER1_TEL, " +
            "MASTER1_STATE, " +
            "MASTER1_DIAL_TIME, " +
            "MASTER2_ID, " +
            "MASTER2_NAME, " +
            "MASTER2_TEL, " +
            "MASTER2_STATE, " +
            "MASTER2_DIAL_TIME, " +
            "Partner_Company, " +
            "Partner_Driver, " +
            "Partner_Phone) " +
            "VALUES ( " +
            "@Template_SYS_ID, " +
            "@WORK_DATETime, " +
            "@ClassName, " +
            "@ClassTimeType, " +
            "@DIAL_DATETime, " +
            "@WORK_DATETime, " +
            "@MASTER_Company, " +
            "@MASTER_Team, " +
            "@MASTER_ID, " +
            "@MASTER_Name, " +
            "@MASTER_TEL, " +
            "@MASTER_ID, " +
            "@MASTER_Name, " +
            "@MASTER_TEL, " +
            "@DRIVER_STATE, " +
            "@DRIVER_DIAL_TIME, " +
            "@MASTER1_ID, " +
            "@MASTER1_NAME, " +
            "@MASTER1_TEL, " +
            "@MASTER1_STATE, " +
            "@MASTER1_DIAL_TIME, " +
            "@MASTER2_ID, " +
            "@MASTER2_NAME, " +
            "@MASTER2_TEL, " +
            "@MASTER2_STATE, " +
            "@MASTER2_DIAL_TIME, " +
            "@Partner_Company, " +
            "@Partner_Driver, " +
            "@Partner_Phone) end ";
        IDbConnection conn = null;
        IDbTransaction tran = null;
        try
        {
            conn = DBTool.GetConn();
            conn.Open();
            tran = conn.BeginTransaction();
            conn.Execute(insertsqlstr, NewTemplate(year, month, day, ClassName), tran);
            tran.Commit();
        }
        catch (Exception err)
        {
            tran.Rollback();
            logger.Info(err);
            throw err;
        }
        finally
        {
            if (tran != null)
                tran.Dispose();
            if (conn != null)
                conn.Dispose();
        }
    }

    private static List<ClassSchedule> NewTemplate(int year, int month, int day, string ClassName)
    {
        List<ClassSchedule> result = new List<ClassSchedule>();
        //宣告台灣日期
        Calendar calendar1 = new TaiwanCalendar();
        //取得範本資料
        List<ClassTemplate> classtemplatelist = NewTemplateList(ClassName).ToList();

        //將設定年月執行
        for (int i = day; i <= DateTime.DaysInMonth(year, month); i++)
        {
            Func<ClassTemplate, bool> func = null;
            DateTime date = new DateTime(year, month, i);
            switch (calendar1.GetDayOfWeek(date))
            {
                case DayOfWeek.Sunday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Sun; };
                    break;
                case DayOfWeek.Monday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Mon; };
                    break;
                case DayOfWeek.Tuesday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Tue; };
                    break;
                case DayOfWeek.Wednesday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Wed; };
                    break;
                case DayOfWeek.Thursday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Thu; };
                    break;
                case DayOfWeek.Friday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Fri; };
                    break;
                case DayOfWeek.Saturday:
                    func = (ClassTemplate p) => { return p.ClassWeek_Sat; };
                    break;
            }
            result.AddRange(classtemplatelist.Where(func).Select(p => combineSchedule(p, date)));
        }
        return result;
    }

    private static IEnumerable<ClassTemplate> NewTemplateList(string ClassName)
    {
        string sqlstr = "SELECT TOP 1 * FROM [Faremma].[dbo].[ClassTemplate] WHERE ClassName=@ClassName AND ClassDisable = '0' ORDER BY SYS_ID DESC";
        return DBTool.Query<ClassTemplate>(sqlstr, new { ClassName = ClassName });
    }
}