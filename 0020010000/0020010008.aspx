<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0020010008.aspx.cs" Inherits="_0020010008" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="../js/jquery.validate.min.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        var str_CNo = '<%= seqno %>';
        var str_Array = [];
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            Hide_Object();
            CNo_Load();
            CNo_List();
        });

        function Hide_Object() {
            document.getElementById("Btn_A").style.display = "none";  //隱藏  【到點】  按鈕
            document.getElementById("Btn_B").style.display = "none";  //隱藏  【完成】  按鈕
            document.getElementById("Btn_C").style.display = "none";  //隱藏【暫結案】按鈕
            document.getElementById("Table_DEPT_Status").style.display = "none";  //隱藏 回覆  【是否回診】  欄位
            document.getElementById("Table_Answer2").style.display = "none";         //隱藏 回覆【暫結案說明】欄位
            document.getElementById("Table_DEPT_Status_2").style.display = "none";  //隱藏   【是否回診】  欄位
            document.getElementById("Table_Answer2_2").style.display = "none";         //隱藏 【暫結案說明】欄位
            document.getElementById("Table_Hospital").style.display = "none";   //隱藏 【醫療院所】欄位
        }

        function CNo_Load() {
            $.ajax({
                url: '0020010008.aspx/CNo_Load',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //var json = JSON.parse(doc.d.toString());
                    if (obj.data[0].status == "NULL") {
                        alert("沒有【" + CNo + "】的派工單資訊")
                        window.location.href = "/0020010000/0020010005.aspx";
                    }
                    else {
                        document.getElementById("txt_MNo").innerHTML = obj.data[0].MNo;
                        document.getElementById("txt_CNo").innerHTML = obj.data[0].CNo;
                        document.getElementById("txt_StartTime").innerHTML = obj.data[0].StartTime;
                        document.getElementById("txt_EndTime").innerHTML = obj.data[0].EndTime;
                        document.getElementById("txt_OverTime").innerHTML = obj.data[0].OverTime;
                        document.getElementById("txt_Danger").innerHTML = obj.data[0].Danger;
                        document.getElementById("txt_Agent_Company").innerHTML = obj.data[0].Agent_Company;
                        document.getElementById("txt_Agent_Team").innerHTML = obj.data[0].Agent_Team;
                        document.getElementById("txt_Agent_Name").innerHTML = obj.data[0].Agent_Name;
                        document.getElementById("txt_CarAgent_Team").innerHTML = obj.data[0].CarAgent_Team;
                        document.getElementById("txt_CarAgent_Name").innerHTML = obj.data[0].CarAgent_Name;
                        document.getElementById("txt_CarName").innerHTML = obj.data[0].CarName;
                        document.getElementById("txt_CarNumber").innerHTML = obj.data[0].CarNumber;
                        document.getElementById("txt_Answer").innerHTML = obj.data[0].Answer;
                        document.getElementById("txt_Answer2").innerHTML = obj.data[0].Answer2;
                        //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案
                        switch (obj.data[0].Type_Value) {
                            case "1":
                                // 更新狀態為處理中
                                $.ajax({
                                    url: '0020010008.aspx/Update_Type',
                                    type: 'POST',
                                    contentType: 'application/json; charset=UTF-8',
                                    dataType: "json",       //如果要回傳值，請設成 json
                                    success: function (doc) {
                                        document.getElementById("Btn_A").style.display = "";  //顯示【到點】按鈕
                                    }
                                });
                                break;
                            case "2":
                                document.getElementById("Btn_A").style.display = "";  //顯示【到點】按鈕
                                break;
                            case "3":
                                document.getElementById("Btn_B").style.display = "";  //顯示【完成】按鈕
                                break;
                            case "4":
                                document.getElementById("Btn_C").style.display = "";  //顯示【暫結案】按鈕
                                document.getElementById("Table_Answer2").style.display = "";   //顯示 回覆【暫結案說明】欄位
                                if (obj.data[0].Servicr == "醫療") {
                                    document.getElementById("Table_DEPT_Status").style.display = "";  //顯示 回覆  【是否回診】  欄位
                                };
                                break;
                            case "5":
                                document.getElementById("Table_data").style.display = "none";  //隱藏【派工單多選處理（瀏覽）】欄位
                                document.getElementById("Table_Answer2_2").style.display = "";   //顯示 【暫結案說明】欄位
                                if (obj.data[0].Servicr == "醫療") {
                                    document.getElementById("Table_DEPT_Status_2").style.display = "";  //顯示 【是否回診】  欄位
                                };
                                break;
                        }

                        if (obj.data[0].DEPT_Status == "1") {
                            document.getElementById("txt_DEPT_Status").innerHTML = "回診";
                        }
                        else {
                            document.getElementById("txt_DEPT_Status").innerHTML = "不回診";
                        }

                        MNo_Load(obj.data[0].MNo);
                    }
                }
            });
        }

        function MNo_Load(MNo) {
            $.ajax({
                url: '0020010008.aspx/MNo_Load',
                type: 'POST',
                data: JSON.stringify({ MNo: MNo }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //var json = JSON.parse(doc.d.toString());
                    if (obj.data[0].status == "NULL") {
                        alert("沒有【" + MNo + "】的需求單資訊")
                        window.location.href = "/0020010000/0020010005.aspx";
                    }
                    else {
                        document.getElementById("txt_Create_Name").innerHTML = obj.data[0].Create_Name;
                        document.getElementById("txt_Create_Team").innerHTML = obj.data[0].Create_Team;
                        document.getElementById("txt_Service").innerHTML = obj.data[0].Service;
                        document.getElementById("txt_ServiceName").innerHTML = obj.data[0].ServiceName;
                        document.getElementById("txt_Time_01").innerHTML = obj.data[0].Time_01;
                        document.getElementById("txt_Time_02").innerHTML = obj.data[0].Time_02;
                        document.getElementById("txt_LocationStart").innerHTML = obj.data[0].LocationStart;
                        document.getElementById("txt_LocationEnd").innerHTML = obj.data[0].LocationEnd;
                        document.getElementById("txt_Location").innerHTML = obj.data[0].Location;
                        document.getElementById("txt_CarSeat").innerHTML = obj.data[0].CarSeat;
                        document.getElementById("txt_ContactName").innerHTML = obj.data[0].ContactName;
                        document.getElementById("txt_ContactPhone3").innerHTML = obj.data[0].ContactPhone3;
                        document.getElementById("txt_ContactPhone2").innerHTML = obj.data[0].ContactPhone2;
                        document.getElementById("txt_Contact_Co_TEL").innerHTML = obj.data[0].Contact_Co_TEL;
                        document.getElementById("txt_Hospital").innerHTML = obj.data[0].Hospital;
                        document.getElementById("txt_HospitalClass").innerHTML = obj.data[0].HospitalClass;
                        document.getElementById("txt_Question").innerHTML = obj.data[0].Question;
                        if (obj.data[0].Service == "醫療") {
                            document.getElementById("Table_Hospital").style.display = "";   //顯示 【醫療院所】欄位
                        }
                        //==========【雇主及外勞資料】==========
                        document.getElementById("txt_Labor_Team").innerHTML = obj.data[0].Labor_Team;
                        document.getElementById("txt_Cust_Name").innerHTML = obj.data[0].Cust_Name;
                        document.getElementById("txt_Labor_CName").innerHTML = obj.data[0].Labor_CName;
                        document.getElementById("txt_Labor_Country").innerHTML = obj.data[0].Labor_Country;
                        document.getElementById("txt_Labor_ID").innerHTML = obj.data[0].Labor_ID;
                        document.getElementById("txt_Labor_PID").innerHTML = obj.data[0].Labor_PID;
                        document.getElementById("txt_Labor_RID").innerHTML = obj.data[0].Labor_RID;
                        document.getElementById("txt_Labor_EID").innerHTML = obj.data[0].Labor_EID;
                        document.getElementById("txt_Labor_Phone").innerHTML = obj.data[0].Labor_Phone;
                        document.getElementById("txt_Labor_Language").innerHTML = obj.data[0].Labor_Language;
                        document.getElementById("txt_Labor_Address").innerHTML = obj.data[0].Labor_Address;
                        document.getElementById("txt_Labor_Address2").innerHTML = obj.data[0].Labor_Address2;
                    }
                }
            });
        }

        function CNo_List() {
            $.ajax({
                url: '0020010008.aspx/CNo_List',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data').DataTable({
                        destroy: true,
                        data: eval(doc.d), "oLanguage": {
                            "sLengthMenu": "顯示 _MENU_ 筆記錄",
                            "sZeroRecords": "無符合資料",
                            "sInfo": "顯示第 _START_ 至 _END_ 項結果，共 _TOTAL_ 項",
                            "sInfoFiltered": "(從 _MAX_ 項結果過濾)",
                            "sInfoPostFix": "",
                            "sSearch": "搜索:",
                            "sUrl": "",
                            "oPaginate": {
                                "sFirst": "首頁",
                                "sPrevious": "上頁",
                                "sNext": "下頁",
                                "sLast": "尾頁"
                            }
                        },
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                            { data: "CNo" },
                            { data: "StartTime" },
                            { data: "Type" },
                            { data: "ServiceName" },
                            { data: "Cust_Name" },
                            { data: "Labor_CName" },
                            { data: "Question" },
                            { data: "Agent_Name" },
                            {
                                data: "SYSID", render: function (data, type, row, meta) {
                                    return "<div class='checkbox'><label>" +
                                        "<input type='checkbox' style='width: 30px; height: 30px;' id='chack' />" +
                                        "</label></div>"
                                }
                            }]
                    });
                    //==========================================================
                    $('#data tbody').on('click', '#chack', function () {
                        var table = $('#data').DataTable();
                        var cno = table.row($(this).parents('tr')).data().SYSID;
                        var a = this.checked;
                        if (a == true) {
                            str_Array.push(cno);
                        }
                        else {
                            str_Array.splice($.inArray(cno, str_Array), 1);
                        }
                    });
                    //==========================================================
                }
            });

        }

        function Btn_Back_Click() {
            window.location.href = "/0020010000/0020010005.aspx";
        }

        function Btn_Report_Click() {
            window.location.href = "/Re_Check.aspx?seqno=" + str_CNo;
        }

        function Btn_A_Click() {
            document.getElementById("Btn_A").disabled = true;
            $.ajax({
                url: '0020010008.aspx/Btn_A_Click',
                type: 'POST',
                data: JSON.stringify({ Array: str_Array }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    window.location.href = "/0020010000/0020010005.aspx";
                }
            });
            document.getElementById("Btn_A").disabled = false;
        }

        function Btn_B_Click() {
            document.getElementById("Btn_B").disabled = true;
            $.ajax({
                url: '0020010008.aspx/Btn_B_Click',
                type: 'POST',
                data: JSON.stringify({ Array: str_Array }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    window.location.href = "/0020010000/0020010005.aspx";
                }
            });
            document.getElementById("Btn_B").disabled = false;
        }

        function Btn_C_Click() {
            document.getElementById("Btn_C").disabled = true;
            var txt_Answer2 = document.getElementById("Reply_Answer2").value;
            var txt_DEPT_Status = document.getElementById("Reply_DEPT_Status").value;
            $.ajax({
                url: '0020010008.aspx/Btn_C_Click',
                type: 'POST',
                data: JSON.stringify({
                    Array: str_Array,
                    ANS: txt_Answer2,
                    DEPT: txt_DEPT_Status
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "success") {
                        window.location.href = "/0020010000/0020010005.aspx";
                    } else {
                        alert(json.status);
                    }
                    document.getElementById("Btn_C").disabled = false;
                }, error: function () {
                    document.getElementById("Btn_C").disabled = false;
                }
            });
        }
    </script>
    <style type="text/css">
        body {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 18px;
        }

        thead th {
            background-color: #666666;
            color: white;
        }

        tr td:first-child,
        tr th:first-child {
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }

        tr td:last-child,
        tr th:last-child {
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
        }

        #data td:nth-child(9), #data td:nth-child(8), #data td:nth-child(7),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1),
        #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <div style="width: 95%; margin: 10px 20px;">
        <!--===================================================-->
        <h2><strong>個人派工及結案管理（瀏覽）</strong>
            <button id='Btn_Report' type='button' class='btn btn-info btn-lg' onclick="Btn_Report_Click()">
                <span class='glyphicon glyphicon-file'></span>
                &nbsp;服務紀錄表預覽
            </button>
        </h2>
        <table class="table table-bordered table-striped">
            <thead>

                <!--========== 服務需求內容 ===========-->

                <tr style="height: 55px;">
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 22px"><strong>服務需求內容</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>

                <!--========== 服務項目 ===========-->

                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%;">
                        <strong>需求單狀態</strong>
                    </th>
                    <th style="width: 35%">
                        <strong>尚未結案</strong>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>結案日期</strong>
                    </th>
                    <th style="width: 35%"></th>
                </tr>

                <!--=========== 需求單編號 派工單編號 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>需求單編號</strong>
                    </td>
                    <td>
                        <label id="txt_MNo"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>派工單編號</strong>
                    </td>
                    <td>
                        <label id="txt_CNo"></label>
                    </td>
                </tr>

                <!--========= 填單人資訊 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>填單人</strong>
                    </td>
                    <td>
                        <label id="txt_Create_Name"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>填單人部門</strong>
                    </td>
                    <td>
                        <label id="txt_Create_Team"></label>
                    </td>
                </tr>

                <!--========== 服務 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>服務分類</strong>
                    </td>
                    <td>
                        <label id="txt_Service"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>服務內容</strong>
                    </td>
                    <td>
                        <label id="txt_ServiceName"></label>
                    </td>
                </tr>

                <!--========== 預定時間 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>預定起始時間</strong>
                    </td>
                    <td>
                        <label id="txt_Time_01"></label>
                    </td>

                    <td style="text-align: center">
                        <strong>預定終止時間</strong>
                    </td>
                    <td>
                        <label id="txt_Time_02"></label>
                    </td>
                </tr>

                <!--========== 行程 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>行程起點</strong>
                    </td>
                    <td>
                        <label id="txt_LocationStart"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>行程終點</strong>
                    </td>
                    <td>
                        <label id="txt_LocationEnd"></label>
                    </td>
                </tr>

                <!--========== 起始地點 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>地址與郵遞區號</strong>
                    </td>
                    <td>
                        <label id="txt_Location"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>搭車人數</strong>
                    </td>
                    <td>
                        <label id="txt_CarSeat"></label>
                    </td>
                </tr>

                <!--=========== 聯絡人 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡人</strong>
                    </td>
                    <td>
                        <label id="txt_ContactName"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>手機簡碼</strong>
                    </td>
                    <td>
                        <label id="txt_ContactPhone3"></label>
                    </td>
                </tr>

                <!--=========== 聯絡人 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>公司手機號碼</strong>
                    </td>
                    <td>
                        <label id="txt_ContactPhone2"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>公司電話</strong>
                    </td>
                    <td>
                        <label id="txt_Contact_Co_TEL"></label>
                    </td>
                </tr>

                <!--========== 醫療院所 ===========-->

                <tr id="Table_Hospital" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>醫療院所</strong>
                    </td>
                    <td>
                        <label id="txt_Hospital"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>就醫類型</strong>
                    </td>
                    <td>
                        <label id="txt_HospitalClass"></label>
                    </td>
                </tr>

                <!--========== 醫療院所 ===========-->

                <tr style="height: 80px;">
                    <td style="text-align: center">
                        <strong>狀況說明</strong>
                    </td>
                    <td>
                        <label id="txt_Question"></label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
            </tbody>
        </table>

        <!--============ 雇主及外勞資料 ============-->

        <table class="table table-bordered table-striped">
            <thead>
                <tr style="height: 55px;">
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 22px"><strong>雇主及外勞資料</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <td style="text-align: center; width: 15%;">
                        <strong>事業部門</strong>
                    </td>
                    <td style="width: 35%">
                        <label id="txt_Labor_Team"></label>
                    </td>
                    <td style="text-align: center; width: 15%;">
                        <strong>客戶（雇主）</strong>
                    </td>
                    <td style="width: 35%">
                        <label id="txt_Cust_Name"></label>
                    </td>
                </tr>

                <!--=========== 勞工資料 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>勞工姓名</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_CName"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>勞工國籍</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Country"></label>
                    </td>
                </tr>

                <!--=========== 勞工資料 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>勞工編號</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_ID"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>護照號碼</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_PID"></label>
                    </td>
                </tr>

                <!--=========== 勞工資料 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>居留證號</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_RID"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>職工編號</strong><br />
                        <strong>（長工號）</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_EID"></label>
                    </td>
                </tr>

                <!--=========== 勞工資料 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>連絡電話</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Phone"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>翻譯國籍</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Language"></label>
                    </td>
                </tr>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡地址</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Address"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>接送地址</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Address2"></label>
                    </td>
                </tr>
            </tbody>
        </table>

        <!--=========== 派工單內容 ===========-->

        <table class="table table-bordered table-striped">
            <thead>
                <tr style="height: 55px;">
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 22px"><strong>派工單內容</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>

                <!--========== 排定日期 排定終止時間 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center; width: 15%;">
                        <strong>排定日期</strong>
                    </td>
                    <td style="width: 35%;">
                        <label id="txt_StartTime"></label>
                    </td>
                    <td style="text-align: center; width: 15%;">
                        <strong>排定終止時間</strong>
                    </td>
                    <td style="width: 35%;">
                        <label id="txt_EndTime"></label>
                    </td>
                </tr>

                <!--========== 緊急程度 預定完成時間 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>緊急程度</strong>
                    </td>
                    <td>
                        <label id="txt_Danger"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>預定完成時間</strong>
                    </td>
                    <td>
                        <label id="txt_OverTime"></label>
                    </td>
                </tr>

                <!--========== 被派人員所屬公司 被派人員所屬部門 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>被派人員所屬公司</strong>
                    </td>
                    <td>
                        <label id="txt_Agent_Company"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>被派人員所屬部門</strong>
                    </td>
                    <td>
                        <label id="txt_Agent_Team"></label>
                    </td>
                </tr>

                <!--========== 被派人員 ===========-->

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>被派人員</strong>
                    </td>
                    <td>
                        <label id="txt_Agent_Name"></label>
                    </td>
                    <td style="text-align: center"></td>
                    <td></td>
                </tr>

                <!--========== 車輛保管人部門 車輛保管人 ===========-->

                <tr id="Tr3" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>車輛保管人部門</strong>
                    </td>
                    <td>
                        <label id="txt_CarAgent_Team"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>車輛保管人</strong>
                    </td>
                    <td>
                        <label id="txt_CarAgent_Name"></label>
                    </td>
                </tr>

                <!--========== 車輛分類 車牌號碼 ===========-->

                <tr id="Tr4" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>車輛分類</strong>
                    </td>
                    <td>
                        <label id="txt_CarName"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>車牌號碼</strong>
                    </td>
                    <td>
                        <label id="txt_CarNumber"></label>
                    </td>
                </tr>

                <!--========== 派工說明 ===========-->

                <tr style="height: 80px;">
                    <td style="text-align: center">
                        <strong>派工說明</strong>
                    </td>
                    <td>
                        <label id="txt_Answer"></label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>

                <!--========== 暫結案說明 ===========-->

                <tr id="Table_Answer2" style="height: 80px;">
                    <td style="text-align: center; color: #D50000; width: 15%">
                        <strong>暫結案說明<br />
                            （後續處理說明）</strong>
                    </td>
                    <td style="width: 85%;" colspan="3">
                        <div style="float: left" data-toggle="tooltip" title="必填，不能超過１５０個字元，並且含有不正確的符號">
                            <textarea id="Reply_Answer2" class="form-control" cols="60" rows="3" placeholder="暫結案說明"
                                style="resize: none; background-color: #ffffbb" maxlength="150" onkeyup="cs(this);"></textarea>
                        </div>
                    </td>
                </tr>

                <!--========== 是否回診 ===========-->

                <tr id="Table_DEPT_Status" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>是否回診</strong>
                    </td>
                    <td colspan="3">
                        <div>
                            <select id="Reply_DEPT_Status" name="Reply_DEPT_Status" style="Font-Size: 16px">
                                <option value="0">不回診</option>
                                <option value="1">回診</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr id="Table_Answer2_2" style="height: 80px;">
                    <td style="text-align: center">
                        <strong>暫結案說明<br />
                            （後續處理說明）</strong>
                    </td>
                    <td>
                        <label id="txt_Answer2"></label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <tr id="Table_DEPT_Status_2" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>是否回診</strong>
                    </td>
                    <td>
                        <label id="txt_DEPT_Status"></label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>

            </tbody>
        </table>
        <!--===================================================-->
        <div id="Table_data">
            <h2><strong>派工單多選處理（瀏覽）&nbsp; &nbsp;</strong></h2>
            <table id="data" class="display table table-striped" style="width: 99%">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 10%;">派工單編號</th>
                        <th style="text-align: center; width: 10%;">排定日期</th>
                        <th style="text-align: center; width: 10%;">案件狀態</th>
                        <th style="text-align: center; width: 10%;">服務內容</th>
                        <th style="text-align: center; width: 10%;">客戶</th>
                        <th style="text-align: center; width: 10%;">勞工姓名</th>
                        <th style="text-align: center; width: 20%;">狀況說明</th>
                        <th style="text-align: center; width: 10%;">被派人員</th>
                        <th style="text-align: center; width: 10%;">功能</th>
                    </tr>
                </thead>
            </table>
        </div>
        <br />
        <table class="table table-bordered table-striped">
            <tbody>
                <tr>
                    <td style="text-align: center;" colspan="4">
                        <input id="hid_type" runat="server" type="hidden" />
                        <button id="Btn_A" type="button" class="btn btn-primary btn-lg " onclick="Btn_A_Click()">
                            <h1>
                                <span class="glyphicon glyphicon-ok"></span>
                                <br />
                                &nbsp;到點&nbsp;
                            </h1>
                        </button>
                        <button id="Btn_B" type="button" class="btn btn-success btn-lg " onclick="Btn_B_Click()">
                            <h1>
                                <span class="glyphicon glyphicon-ok"></span>
                                <br />
                                &nbsp;完成&nbsp;
                            </h1>
                        </button>
                        <button id="Btn_C" type="button" class="btn btn-warning btn-lg " onclick="Btn_C_Click()">
                            <h1>
                                <span class="glyphicon glyphicon-ok"></span>
                                <br />
                                &nbsp;暫結案&nbsp;
                            </h1>
                        </button>
                        &nbsp; &nbsp;                        
                        <button id="Btn_Back" type="button" class="btn btn-default btn-lg " onclick="Btn_Back_Click()">
                            <h1>
                                <span class="glyphicon glyphicon-share-alt"></span>
                                <br />
                                &nbsp;返回&nbsp;
                            </h1>
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>
        <%--  ========== 第四行 ===========--%>
    </div>
</asp:Content>
