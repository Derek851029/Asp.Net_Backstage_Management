<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0040010002.aspx.cs" Inherits="_0040010002" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        var array_mno = [];

        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            Load();
            Danger_Changed();
        });

        //================ 帶入【需求單】資訊 ===============
        function Load() {
            document.getElementById("Btn_Update").style.display = "none";  //隱藏【派工】按鈕
            document.getElementById("Hospital_Table_1").style.display = "none";  //隱藏【醫療院所】欄位
            document.getElementById("Table_CNo").style.display = "none";  //隱藏【派工單處理狀況（瀏覽）】欄位
            $.ajax({
                url: '0040010002.aspx/Load',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
                    switch (obj.data[0].Type_Value) {
                        case "1":
                            window.location.href = "/0020010000/0020010007.aspx?seqno=" + obj.data[0].MNo;
                            break;
                        case "2":
                            document.getElementById("str_type").innerHTML = "尚未派工";
                            document.getElementById("Btn_Update").style.display = "";  //顯示【派工】按鈕
                            break;
                        case "3":
                            document.getElementById("str_type").innerHTML = "尚未結案";
                            bindTable();
                            document.getElementById("Table_CNo").style.display = "";  //顯示【派工單處理狀況（瀏覽）】欄位
                            document.getElementById("Btn_Update").style.display = "";  //顯示【派工】按鈕
                            break;
                        case "4":
                            document.getElementById("str_type").innerHTML = "已經結案";
                            bindTable();
                            document.getElementById("MNo_table_1").style.display = "none";    //隱藏【需求單（瀏覽）】欄位
                            document.getElementById("Table_CNo").style.display = "";  //顯示【派工單處理狀況（瀏覽）】欄位
                            document.getElementById("Table").style.display = "none";  //隱藏【派工單新增或併單】欄位
                            document.getElementById("title_table_2").style.display = "none";  //隱藏【需求單搜尋】欄位
                            document.getElementById("title_table").style.display = "none";  //隱藏【可併單車輛】欄位
                            document.getElementById("Btn_Closed").style.display = "none";  //隱藏【結案】按鈕
                            var time_value = obj.data[0].Close_Time;
                            if (time_value == "0001/01/01 00:00") {
                                document.getElementById("str_Close_Time").innerHTML = "";
                            }
                            else {
                                document.getElementById("str_Close_Time").innerHTML = time_value;
                            }
                            break;
                        case "5":
                        case "0":
                            window.location.href = "/0030010000/0030010003.aspx?seqno=" + obj.data[0].MNo;
                            break;
                    };
                    if (obj.data[0].Service == "醫療") {
                        document.getElementById("str_Hospital").innerHTML = obj.data[0].Hospital;
                        document.getElementById("str_HospitalClass").innerHTML = obj.data[0].HospitalClass;
                        document.getElementById("Hospital_Table_1").style.display = "";  //顯示【醫療院所】欄位
                    }
                    document.getElementById("str_sysid").innerHTML = obj.data[0].MNo;
                    document.getElementById("str_Create_Team").innerHTML = obj.data[0].Create_Team;
                    document.getElementById("str_Create_Name").innerHTML = obj.data[0].Create_Name;
                    document.getElementById("str_Service").innerHTML = obj.data[0].Service;
                    document.getElementById("str_ServiceName").innerHTML = obj.data[0].ServiceName;
                    document.getElementById("str_Time_01").innerHTML = obj.data[0].Time_01;
                    document.getElementById("datetimepicker03").value = obj.data[0].Time_01;
                    document.getElementById("str_Time_02").innerHTML = obj.data[0].Time_02;
                    document.getElementById("datetimepicker04").value = obj.data[0].Time_02;
                    document.getElementById("str_Location").innerHTML = obj.data[0].Location;
                    document.getElementById("str_LocationStart").innerHTML = obj.data[0].LocationStart;
                    document.getElementById("str_LocationEnd").innerHTML = obj.data[0].LocationEnd;
                    document.getElementById("str_ContactName").innerHTML = obj.data[0].ContactName;

                    if (obj.data[0].ContactPhone2 != null) {
                        document.getElementById("str_ContactPhone2").innerHTML = obj.data[0].ContactPhone2;
                    } else {
                        document.getElementById("str_ContactPhone2").innerHTML = "";
                    }

                    if (obj.data[0].ContactPhone3 != null) {
                        document.getElementById("str_ContactPhone3").innerHTML = obj.data[0].ContactPhone3;
                    } else {
                        document.getElementById("str_ContactPhone3").innerHTML = "";
                    }

                    if (obj.data[0].CarSeat != null) {
                        document.getElementById("txt_CarSeat").innerHTML = obj.data[0].CarSeat;
                    } else {
                        document.getElementById("txt_CarSeat").innerHTML = "";
                    }

                    if (obj.data[0].Contact_Co_TEL != null) {
                        document.getElementById("str_Contact_Co_TEL").innerHTML = obj.data[0].Contact_Co_TEL;
                    } else {
                        document.getElementById("str_Contact_Co_TEL").innerHTML = "";
                    }

                    if (obj.data[0].Question != null) {
                        document.getElementById("str_Question").innerHTML = obj.data[0].Question;
                    } else {
                        document.getElementById("str_Question").innerHTML = "";
                    }

                    if (obj.data[0].Answer != null) {
                        document.getElementById("str_Answer").innerHTML = obj.data[0].Answer;
                    } else {
                        document.getElementById("str_Answer").innerHTML = "";
                    }

                    document.getElementById("str_Labor_Team").innerHTML = obj.data[0].Labor_Team
                    document.getElementById("str_Cust_Name").innerHTML = obj.data[0].Cust_Name;
                    document.getElementById("str_Labor_Name").innerHTML = obj.data[0].Labor_CName;
                    document.getElementById("str_Labor_Country").innerHTML = obj.data[0].Labor_Country;
                    document.getElementById("str_Labor_ID").innerHTML = obj.data[0].Labor_ID;
                    document.getElementById("str_Labor_PID").innerHTML = obj.data[0].Labor_PID;
                    document.getElementById("str_Labor_RID").innerHTML = obj.data[0].Labor_RID;
                    document.getElementById("str_Labor_EID").innerHTML = obj.data[0].Labor_EID;
                    document.getElementById("str_Labor_Phone").innerHTML = obj.data[0].Labor_Phone;
                    document.getElementById("str_Labor_Language").innerHTML = obj.data[0].Labor_Language;
                    document.getElementById("str_Labor_Address").innerHTML = obj.data[0].Labor_Address;
                    document.getElementById("str_Labor_Address2").innerHTML = obj.data[0].Labor_Address2;
                    $("#hid_Service_ID").val(obj.data[0].Service_ID);
                    $("#hid_PostCode").val(obj.data[0].PostCode);
                    $("#hid_Create_ID").val(obj.data[0].Create_ID);
                    $("#hid_Type_Value").val(obj.data[0].Type_Value);
                    if (obj.data[0].Type_Value == '2' || obj.data[0].Type_Value == '3') {
                        Car_Team_List();
                        Agent_Team_List();
                        MNo_Table();
                        data2();
                    }
                }
            });
        }

        //================ 帶入【被派人員】資訊 ==============

        function Agent_Team_List() {
            $.ajax({
                url: '0040010002.aspx/Agent_Team',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_Agent_Team");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_Team + "'>" + obj.Agent_Team + "</option>");
                    });
                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        function Agent_Name_List(Agent_ID) {
            document.getElementById("working").innerHTML = "";
            document.getElementById("noworking").innerHTML = "";
            var $select_elem = $("#select_Agent_Name");
            var s = document.getElementById("select_Agent_Team");
            var str_value = s.options[s.selectedIndex].value;
            $.ajax({
                url: '0040010002.aspx/Agent_Name',
                type: 'POST',
                data: JSON.stringify({ value: str_value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇被派人員…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_ID + "'>" + obj.Agent_Name + "</option>");
                    });

                    if (Agent_ID != '0') {
                        document.getElementById("select_Agent_Name").value = Agent_ID;
                        Agent_WorkTime();
                    };

                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        function Agent_WorkTime() {
            document.getElementById("working").innerHTML = "";
            document.getElementById("noworking").innerHTML = "";
            var time = document.getElementById("datetimepicker03").value;
            if (time == "") {
                alert("請填寫排定起始時間");
            }
            else {
                var team = document.getElementById("select_Agent_Team");
                var Agent_Team = team.options[team.selectedIndex].value;
                var id = document.getElementById("select_Agent_Name");
                var Agent_ID = id.options[id.selectedIndex].value;
                if (Agent_ID != '') {
                    //=========================
                    $.ajax({
                        url: '0040010002.aspx/Agent_WorkTime',
                        type: 'POST',
                        data: JSON.stringify({ Time: time, Agent_Team: Agent_Team, Agent_ID: Agent_ID }),
                        contentType: 'application/json; charset=UTF-8',
                        dataType: "json",
                        success: function (doc) {
                            var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                            if (obj.data[0].status == "OK") {
                                document.getElementById("working").innerHTML = "上班　" + obj.data[0].Working + "~" + obj.data[0].WorkOff;
                            }
                            else {
                                document.getElementById("noworking").innerHTML = "休假";
                            }
                        }
                    });
                    //==========================
                }
            }
        }

        //============================================
        //================ 帶入【服務車輛】資訊 ==============

        function Car_Team_List() {
            $.ajax({
                url: '0040010002.aspx/Car_Team',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_Car_Team");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_Team + "'>" + obj.Agent_Team + "</option>");
                    });
                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        function Car_Name_List(Car_Name, Car_Number) {
            var s = document.getElementById("select_Car_Team");
            var str_value = s.options[s.selectedIndex].value;
            $.ajax({
                url: '0040010002.aspx/Car_Name',
                type: 'POST',
                data: JSON.stringify({ value: str_value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_Car_Name");
                    $select_elem.chosen("destroy");
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇車輛保管人…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_Name + "'>" + obj.Agent_Name + "</option>");
                    });

                    if (Car_Name != '0') {
                        document.getElementById("select_Car_Name").value = Car_Name;
                    };

                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                    if (Car_Number != '0') {
                        Car_Number_List(Car_Number);
                    }
                }
            });
            if (Car_Number == '0') {
                var $select_elem = $("#select_Car_Number");
                $select_elem.chosen("destroy")
                $select_elem.empty();
                $select_elem.append("<option value=''>" + "請選擇車牌號碼…" + "</option>");
                $select_elem.chosen({
                    width: "100%",
                    search_contains: true
                });
                $('.chosen-single').css({ 'background-color': '#ffffbb' });
            }
        }

        function Car_Number_List(Car_Number) {
            var s = document.getElementById("select_Car_Name");
            var str_value = s.options[s.selectedIndex].value;
            $.ajax({
                url: '0040010002.aspx/Car_Number',
                type: 'POST',
                data: JSON.stringify({ value: str_value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_Car_Number");
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇車牌號碼…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.CarNumber + "'>" + "（" + obj.CarName + "）" + obj.CarNumber + "</option>");
                    });

                    if (Car_Number != '0') {
                        document.getElementById("select_Car_Number").value = Car_Number;
                    };

                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        //=========================================
        //================ 選擇緊急程度 ================

        function Danger_Changed() {
            var s = document.getElementById("Danger");
            var str_value = s.options[s.selectedIndex].value;
            var str_hours
            if (str_value != "") {
                switch (str_value) {
                    case "1":
                        str_hours = 2;
                        break;
                    case "2":
                        str_hours = 1;
                        break;
                    default:
                        str_hours = 4;
                        break;
                }
                $.ajax({
                    url: '0040010002.aspx/Danger_Changed',
                    type: 'POST',
                    data: JSON.stringify({ value: str_hours }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (doc) {
                        document.getElementById("str_OverTime").innerHTML = doc.d;
                    }
                });
            
            } else {
                document.getElementById("str_OverTime").innerHTML = "";
            }
        }

        //=============== 需求單多選（瀏覽） ====================

        function MNo_Table() {
            var str_Time_01 = document.getElementById("str_Time_01").textContent;
            var str_Time_02 = document.getElementById("str_Time_02").textContent;
            var str_Service = document.getElementById("hid_Service_ID").value;
            var str_PostCode = document.getElementById("hid_PostCode").value.substring(0, 3);
            var str_Service_Name = document.getElementById("str_Service").textContent;
            var str_Hospital = "0";

            if (str_Service_Name == '醫療') {
                str_Hospital = document.getElementById("str_Hospital").textContent;
            }

            $.ajax({
                url: '0040010002.aspx/MNo_Table',
                type: 'POST',
                data: JSON.stringify({ start: str_Time_01, end: str_Time_02, Service_ID: str_Service, code: str_PostCode, Hospital: str_Hospital }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data3').DataTable({
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
                           { data: "Time_01" },
                            { data: "MNo" },
                            {
                                data: "Type", render: function (data, type, row, meta) {
                                    if (row.Type_Value == "3") { return "<div style='color: #D50000'>" + data + "</div>" }
                                    else { return "<strong>" + data + "</strong>" }
                                }
                            },
                            { data: "ServiceName" },
                            { data: "Cust_Name" },
                            { data: "Labor_CName" },
                            { data: "LocationStart" },
                            { data: "Question" },
                            {
                                data: "SYS_ID", render: function (data, type, row, meta) {
                                    return "<div class='checkbox'><label>" +
                                        "<input type='checkbox' style='width: 30px; height: 30px;' id='chack' />" +
                                        "</label></div>"
                                }
                            }
                        ]
                    });
                    //=====================================
                    $('#data3 tbody').unbind('click').
                        on('click', '#chack', function () {
                            var table = $('#data3').DataTable();
                            var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                            var a = this.checked;
                            if (a == false) {
                                array_mno.splice($.inArray(SYS_ID, array_mno), 1);
                            }
                            else {
                                array_mno.push(SYS_ID);
                            }
                        });
                }
            });
        }

        //=======================需求單多選表=========
        function bindTable() {
            $.ajax({
                url: '0040010002.aspx/GetPartnerList',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data').DataTable({
                        destroy: true,
                        data: eval(doc.d), "oLanguage": {
                            "sLengthMenu": "顯示 _MENU_ 筆記錄",
                            "sZeroRecords": "無派工單資訊",
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
                            "info": false,
                            "defaultContent": "<button id='url' type='button' class='btn btn-info btn-lg'>" +
                                "<span class='glyphicon glyphicon-search'>" +
                                "</span>&nbsp;&nbsp;明細</button>"
                        }],
                        columns: [
                            { data: "CNo" },
                            { data: "Type" },
                            { data: "Agent_Team" },
                            { data: "Agent_Name" },
                            { data: "Answer2" },
                            { data: "UpdateDate" },
                            { data: "UpdateUser" },
                            { data: "LastUpdateDate" },
                            { data: "LastUpdateUser" },
                            { data: "FinalUpdateDate" },
                            { data: "FinalUpdateUser" },
                            { data: "" }
                        ]
                    });

                    $('#data tbody').on('click', '#url', function () {
                        var table = $('#data').DataTable();
                        var str_cno = table.row($(this).parents('tr')).data().CNo;
                        var URL = "../0020010000/0020010008.aspx?seqno=" + str_cno;
                        location.href = (URL);
                    });
                }
            });
        }
        //=================可併單 車輛
        function data2() {
            var str_Time_01 = document.getElementById("str_Time_01").textContent;
            var str_Time_02 = document.getElementById("str_Time_02").textContent;
            var str_Hospital = document.getElementById("str_Hospital").textContent;
            var str_Service = document.getElementById("str_ServiceName").textContent;
            $.ajax({
                url: '0040010002.aspx/GetData2List',
                type: 'POST',
                data: JSON.stringify({ start: str_Time_01, end: str_Time_02, hospital: str_Hospital, Service: str_Service }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data2').DataTable({
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
                            { data: "StartTime" },
                            {
                                data: "CNo", render: function (data, type, row, meta) {
                                    return "<button id='info' type='button' class='btn btn-danger btn-lg' data-toggle='modal' data-target='#myModal' >" +
                                        "<span class='glyphicon glyphicon-search'></span>&nbsp;&nbsp;已併 " + data + " 張單</button>"
                                }
                            },
                            { data: "ServiceName" },
                            { data: "Hospital" },
                            { data: "CarAgent_Name" },
                            { data: "CarNumber" },
                            { data: "Answer" },
                            {
                                data: "", render: function (data, type, row, meta) {
                                    return "<button id='click' type='button' class='btn btn-info btn-lg' >" +
                                        "<span class='glyphicon glyphicon-share'></span>&nbsp;&nbsp;併單</button>"
                                }
                            }
                        ]
                    });
                    //=======================================================
                    $('#data2 tbody').unbind('click').
                    on('click', '#click', function () {
                        var table = $('#data2').DataTable().row($(this).parents('tr')).data();
                        ChangeSelect("Danger", table.Danger_Value);
                        ChangeSelect("select_Car_Team", table.CarAgent_Team);
                        Car_Name_List(table.CarAgent_Name, table.CarNumber);
                        ChangeSelect("select_Agent_Team", table.Agent_Team);
                        Agent_Name_List(table.Agent_ID);
                        document.getElementById("str_OverTime").innerHTML = table.OverTime;
                        document.getElementById("datetimepicker03").value = table.StartTime;
                        document.getElementById("datetimepicker04").value = table.EndTime;
                        document.getElementById("Answer2").value = table.Answer;
                    }).
                    on('click', '#info', function () {
                        var table = $('#data2').DataTable().row($(this).parents('tr')).data();
                        $.ajax({
                            url: '0040010002.aspx/GetinfoList',
                            type: 'POST',
                            data: JSON.stringify({
                                ServiceName: table.ServiceName,
                                Hospital: table.Hospital,
                                CarAgent_Team: table.CarAgent_Team,
                                CarNumber: table.CarNumber,
                                Agent_Team: table.Agent_Team,
                                Agent_ID: table.Agent_ID,
                                StartTime: table.StartTime.toString("yyyy-MM-dd HH:mm"),
                                EndTime: table.EndTime.toString("yyyy-MM-dd HH:mm"),
                                Answer: table.Answer
                            }),
                            contentType: 'application/json; charset=UTF-8',
                            dataType: "json",       //如果要回傳值，請設成 json
                            success: function (doc) {
                                var table = $('#info').DataTable({
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
                                        { data: "StartTime" },
                                        { data: "CNo" },
                                        { data: "Cust_Name" },
                                        { data: "ServiceName" },
                                        { data: "Hospital" },
                                        { data: "CarAgent_Name" },
                                        { data: "CarNumber" },
                                        { data: "CarSeat" },
                                        { data: "Answer" }
                                    ]
                                });
                            }
                        });
                        //===========================================
                    });
                }
            });
        }

        //================【併單】================
        function Merger_CNo(SYSID) {
            $.ajax({
                url: '0040010002.aspx/Merger_CNo',
                type: 'POST',
                data: JSON.stringify({ SYSID: SYSID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    if (obj.data[0].CNo == "NULL") {
                        alert("查無此子單編號");
                        return;
                    }
                    ChangeSelect("Danger", obj.data[0].Danger_Value);
                    ChangeSelect("select_Car_Team", obj.data[0].CarAgent_Team);
                    Car_Name_List(obj.data[0].CarAgent_Name, obj.data[0].CarNumber);
                    ChangeSelect("select_Agent_Team", obj.data[0].Agent_Team);
                    Agent_Name_List(obj.data[0].Agent_ID);
                    document.getElementById("str_OverTime").innerHTML = obj.data[0].OverTime;
                    document.getElementById("datetimepicker03").value = obj.data[0].StartTime;
                    document.getElementById("datetimepicker04").value = obj.data[0].EndTime;
                    document.getElementById("Answer2").value = obj.data[0].Answer;
                }
            });
        };

        //=========================================
        function ChangeSelect(ID, Value) {
            var str = "#" + ID;
            var $select_elem = $(str);
            $select_elem.chosen("destroy")
            document.getElementById(ID).value = Value;
            $select_elem.chosen({
                width: "100%",
                search_contains: true
            });
            $('.chosen-single').css({ 'background-color': '#ffffbb' });
        };

        //==================【返回】=================
        function Btn_Back_Click() {
            window.location.href = "/0040010000/0040010001.aspx";
        };

        //==================【派工】=================
        function Btn_New_Click() {
            var danger_value = document.getElementById("Danger").value;
            var over_time = document.getElementById("str_OverTime").innerText;
            var start_time = document.getElementById("datetimepicker03").value;            //排定起始時間
            var end_time = document.getElementById("datetimepicker04").value;             //排定終止時間
            var agent_name = document.getElementById("select_Agent_Name").value;   //被派人員
            var car_number = document.getElementById("select_Car_Number").value;     //車牌號碼
            var answer = document.getElementById("Answer2").value;
            document.getElementById("Btn_Update").disabled = true;
            $("#Div_Loading").modal();
            $.ajax({
                url: '0040010002.aspx/Check_Value',
                type: 'POST',
                data: JSON.stringify({
                    Array: array_mno,
                    Agent_ID: agent_name,
                    CarNumber: car_number,
                    Danger_Value: danger_value,
                    StartTime: start_time,
                    EndTime: end_time,
                    OverTime: over_time,
                    Answer: answer
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "success") {
                        alert("派工單新增【" + json.count + " 筆】完成。");
                        window.location.href = "/0040010000/0040010001.aspx";
                    } else {
                        document.getElementById("Btn_Update").disabled = false;
                        $("#Div_Loading").modal('hide');
                        alert(json.status);
                    }
                },
                error: function () {
                    document.getElementById("Btn_Update").disabled = false;
                    $("#Div_Loading").modal('hide');
                }
            });
        }

        //==================【結案】=================
        function Btn_Closed_Click() {
            document.getElementById("Btn_Closed").disabled = true;
            var txt_CaseClosed = document.getElementById("txt_CaseClosed").value;
            var txt_Type_Value = document.getElementById("hid_Type_Value").value;
            if (txt_Type_Value == "2") {
                if (txt_CaseClosed.length < 1) {
                    alert("需求單狀態為【尚未派工】時請務必填寫【結案說明 】。");
                    document.getElementById("Btn_Closed").disabled = false;
                    return;
                }
            };

            $("#Div_Loading").modal();
            $.ajax({
                url: '0040010002.aspx/Btn_Closed_Click',
                type: 'POST',
                data: JSON.stringify({ Answer: txt_CaseClosed }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "success") {
                        window.location.href = "/0040010000/0040010001.aspx";
                    } else {
                        alert(json.status);
                    }
                    document.getElementById("Btn_Closed").disabled = false;
                    $("#Div_Loading").modal("hide");
                },
                beforeSend: function () {
                    //發送請求之前會執行的函式。
                    //$('#loadingIMG').show();
                },
                complete: function () {
                    //請求完成時執行的函式(不論結果是success或error)。
                    //$('#loadingIMG').hide();
                },
                error: function () {
                    document.getElementById("Btn_Closed").disabled = false;
                    $("#Div_Loading").modal("hide");
                }
            });
        }
        //=========================================
    </script>
    <style type="text/css">
        body {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 16px;
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

        #info td:nth-child(9), #info td:nth-child(8),
        #info td:nth-child(7), #info td:nth-child(6), #info td:nth-child(5), #info td:nth-child(4),
        #info td:nth-child(3), #info td:nth-child(2), #info td:nth-child(1), #info th:nth-child(5) {
            text-align: center;
        }

        #data3 td:nth-child(9), #data3 td:nth-child(8),
        #data3 td:nth-child(7), #data3 td:nth-child(6), #data3 td:nth-child(5), #data3 td:nth-child(4),
        #data3 td:nth-child(3), #data3 td:nth-child(2), #data3 td:nth-child(1), #data3 th:nth-child(5) {
            text-align: center;
        }

        #data2 td:nth-child(8), #data2 td:nth-child(7), #data2 td:nth-child(6), #data2 td:nth-child(5),
        #data2 td:nth-child(4), #data2 td:nth-child(3), #data2 td:nth-child(2), #data2 td:nth-child(1),
        #data2 th:nth-child(5) {
            text-align: center;
        }

        #data td:nth-child(12), #data td:nth-child(11), #data td:nth-child(10), #data td:nth-child(9),
        #data td:nth-child(8), #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5),
        #data td:nth-child(4), #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1),
        #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <!-- ====== Loading ====== -->
    <div class="modal fade" id="Div_Loading" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 350px;">
            <div class="modal-content" style="margin-top: 100%; margin-left: 25%;">
                <div style="text-align: center">
                    <br />
                    <img src="img/ajax-loader.gif" />
                    <h3>Loading...</h3>
                    <br />
                </div>
            </div>
        </div>
    </div>
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1280px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="txt_title">已併單明細</label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table id="info" class="display table table-striped">
                        <thead>
                            <tr>
                                <th style="text-align: center; width: 12%;">排定起始時間</th>
                                <th style="text-align: center; width: 10%;">派工單編號</th>
                                <th style="text-align: center; width: 10%;">廠商名稱</th>
                                <th style="text-align: center; width: 10%;">服務內容</th>
                                <th style="text-align: center; width: 10%;">地點</th>
                                <th style="text-align: center; width: 10%;">駕駛</th>
                                <th style="text-align: center; width: 10%;">車牌號碼</th>
                                <th style="text-align: center; width: 10%;">搭乘人數</th>
                                <th style="text-align: center; width: 10%;">派工說明</th>
                            </tr>
                        </thead>
                    </table>
                    <!-- ========================================== -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">關閉</button>
                </div>
            </div>

        </div>
    </div>
    <!--===================================================-->
    <div style="width: 1280px; margin: 10px 20px">
        <!--===================================================-->
        <h2><strong>員工派工管理（瀏覽）</strong></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>服務需求內容</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%;">
                        <strong>需求單狀態</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="str_type"></label>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>結案日期</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="str_Close_Time"></label>
                    </th>
                </tr>
                <%--  =========== 填單人資料 ===========--%>
                <tr id="tr_sysid" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>需求單編號</strong>
                    </td>
                    <td>
                        <label id="str_sysid"></label>
                    </td>
                    <td style="text-align: center"></td>
                    <td></td>
                </tr>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>填單人</strong>
                    </td>
                    <td>
                        <label id="str_Create_Name"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>填單人部門</strong>
                    </td>
                    <td>
                        <label id="str_Create_Team"></label>
                    </td>
                </tr>
                <%--  ========== 服務項目 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>服務分類</strong>
                    </td>
                    <td>
                        <label id="str_Service"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>服務內容</strong>
                    </td>
                    <td>
                        <label id="str_ServiceName"></label>
                    </td>
                </tr>
                <%--  ========== 服務項目 ===========--%>

                <%--  ========== 需求日期 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>預定起始時間</strong>
                    </td>
                    <td>
                        <label id="str_Time_01"></label>
                    </td>

                    <td style="text-align: center">
                        <strong>預定終止時間</strong>
                    </td>
                    <td>
                        <label id="str_Time_02"></label>
                    </td>
                </tr>
                <%--  ========== 需求日期 ===========--%>

                <%--  =========== 行程= ===========--%>
                <tr id="PathTable" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>行程起點</strong>
                    </td>
                    <td>
                        <label id="str_LocationStart"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>行程終點</strong>
                    </td>
                    <td>
                        <label id="str_LocationEnd"></label>
                    </td>
                </tr>
                <%--  =========== 行程 ============--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>地址與郵遞區號</strong>
                    </td>
                    <td>
                        <label id="str_Location"></label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <%--  ========== 起始地點 ===========--%>
                <tr id="PathStartTable" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>搭車人數</strong>
                    </td>
                    <td>
                        <label id="txt_CarSeat"></label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>

                <%--  ========== 起始地點 ===========--%>

                <%--  =========== 聯絡人 ===========--%>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡人</strong>
                    </td>
                    <td>
                        <label id="str_ContactName"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>手機簡碼</strong>
                    </td>
                    <td>
                        <label id="str_ContactPhone3"></label>
                    </td>
                </tr>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>公司手機號碼</strong>
                    </td>
                    <td>
                        <label id="str_ContactPhone2"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>公司電話</strong>
                    </td>
                    <td>
                        <label id="str_Contact_Co_TEL"></label>
                    </td>
                </tr>

                <%--  =========== 聯絡人 ===========--%>

                <%--  ========== 醫療院所 ===========--%>

                <tr id="Hospital_Table_1" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>醫療院所</strong>
                    </td>
                    <td>
                        <label id="str_Hospital"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>就醫類型</strong>
                    </td>
                    <td>
                        <label id="str_HospitalClass"></label>
                    </td>
                </tr>

                <%--  ========== 醫療院所 ===========--%>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>狀況說明</strong>
                    </td>
                    <td>
                        <label id="str_Question"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>結案說明</strong>
                    </td>
                    <td>
                        <label id="str_Answer"></label>
                    </td>
                </tr>
            </tbody>
        </table>
        <%--  =========== 勞工資料 ===========--%>

        <%--  =========== 勞工資料 ===========--%>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>雇主及外勞資料</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <td style="text-align: center; width: 15%;">
                        <strong>事業部門</strong>
                    </td>
                    <td style="width: 35%;">
                        <label id="str_Labor_Team"></label>
                    </td>
                    <td style="text-align: center; width: 15%;">
                        <strong>客戶（雇主）</strong>
                    </td>
                    <td style="width: 35%;">
                        <label id="str_Cust_Name"></label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>勞工姓名</strong>
                    </td>
                    <td>
                        <label id="str_Labor_Name"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>勞工國籍</strong>
                    </td>
                    <td>
                        <label id="str_Labor_Country"></label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>勞工編號</strong>
                    </td>
                    <td>
                        <label id="str_Labor_ID"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>護照號碼</strong>
                    </td>
                    <td>
                        <label id="str_Labor_PID"></label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr>
                    <td style="text-align: center">
                        <strong>居留證號</strong>
                    </td>
                    <td>
                        <label id="str_Labor_RID"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>職工編號</strong><br />
                        <strong>（長工號）</strong>
                    </td>
                    <td>
                        <label id="str_Labor_EID"></label>
                    </td>
                </tr>

                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>連絡電話</strong>
                    </td>
                    <td>
                        <label id="str_Labor_Phone"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>翻譯國籍</strong>
                    </td>
                    <td>
                        <label id="str_Labor_Language"></label>
                    </td>
                </tr>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡地址</strong>
                    </td>
                    <td>
                        <label id="str_Labor_Address"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>接送地址</strong>
                    </td>
                    <td>
                        <label id="str_Labor_Address2"></label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
            </tbody>
        </table>

        <%--  ========== 併單 ===========--%>
        <div id="MNo_table_1" class="table-responsive">
            <h2><strong>需求單多選（瀏覽） &nbsp; &nbsp;</strong>
                <%--<button id="RE2" class="btn btn-success btn-lg" type="button" onclick="data2()"><span class='glyphicon glyphicon-refresh'></span>&nbsp;&nbsp;更新</button>--%>
            </h2>
            <h4 style="color: #D50000">同性質工作與同區域案件參考</h4>
            <table id="data3" class="display table table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 10%;">預定時間</th>
                        <th style="text-align: center; width: 10%;">需求單編號</th>
                        <th style="text-align: center; width: 8%;">狀態</th>
                        <th style="text-align: center; width: 10%;">服務內容</th>
                        <th style="text-align: center; width: 10%;">廠商名稱</th>
                        <th style="text-align: center; width: 10%;">勞工姓名</th>
                        <th style="text-align: center; width: 15%;">地點</th>
                        <th style="text-align: center; width: 20%;">狀況說明</th>
                        <th style="text-align: center; width: 7%;">多選</th>
                    </tr>
                </thead>
            </table>
        </div>

        <%--  ========== 併單 ===========--%>
        <div id="title_table" class="table-responsive">
            <h2><strong>可併單車輛 &nbsp; &nbsp;</strong>
                <button id="RE" class="btn btn-success btn-lg" type="button" onclick="data2()"><span class='glyphicon glyphicon-refresh'></span>&nbsp;&nbsp;更新</button>
            </h2>
            <table id="data2" class="display table table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 10%;">排定起始時間</th>
                        <th style="text-align: center; width: 10%;">已併單數量</th>
                        <th style="text-align: center; width: 10%;">服務內容</th>
                        <th style="text-align: center; width: 10%;">地點</th>
                        <th style="text-align: center; width: 10%;">駕駛</th>
                        <th style="text-align: center; width: 10%;">車牌號碼</th>
                        <th style="text-align: center; width: 20%;">派工說明</th>
                        <th style="text-align: center; width: 10%;">併單</th>
                    </tr>
                </thead>
            </table>
        </div>

        <!--===================================================-->
        <div id="Table">
            <h2 id="title_table_2"><strong>派工單新增或併單</strong></h2>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center" colspan="4">
                            <span style="font-size: 20px"><strong>派工單新增或併單</strong></span>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="text-align: center; color: #D50000; width: 15%;">
                            <strong>緊急程度</strong>
                        </td>
                        <td style="width: 35%">
                            <div data-toggle="tooltip" title="緊急程度，預設為一般" style="width: 100%">
                                <select id="Danger" class="chosen-select" style="Font-Size: 16px; width: 100%" onchange="Danger_Changed()">
                                    <option value="0">一般</option>
                                    <option value="1">重要</option>
                                    <option value="2">緊急</option>
                                </select>
                            </div>
                        </td>
                        <td style="text-align: center; width: 15%">
                            <strong>預定完成時間</strong>
                        </td>
                        <td style="width: 35%">
                            <label id="str_OverTime"></label>
                        </td>
                    </tr>
                    <%--  ========== 第一行 ===========--%>
                    <tr>
                        <td style="text-align: center; color: #D50000; width: 15%;">
                            <strong>排定起始時間</strong>
                        </td>
                        <td>
                            <div style="float: left" data-toggle="tooltip" title="必填">
                                <input type="text" class="form-control" id="datetimepicker03" name="datetimepicker03" style="background-color: #ffffbb" />
                            </div>
                        </td>
                        <td style="text-align: center; color: #D50000; width: 15%;">
                            <strong>排定終止時間</strong>
                        </td>
                        <td>
                            <div style="float: left" data-toggle="tooltip" title="必填">
                                <input type="text" class="form-control" id="datetimepicker04" name="datetimepicker04" style="background-color: #ffffbb" />
                            </div>
                        </td>
                    </tr>
                    <%--  ========== 第一行 ===========--%>

                    <%--  ========== 第二行 緊急程度 ===========--%>


                    <%--  ========== 第二行 緊急程度 ===========--%>

                    <tr>
                        <td style="text-align: center; color: #D50000;">
                            <strong>被派人員</strong>
                        </td>
                        <td>
                            <div>
                                <select id="select_Agent_Team" name="select_Agent_Team" class="chosen-select" style="width: 100%" onchange="Agent_Name_List('0')">
                                    <option value="">請選擇所屬部門…</option>
                                </select>
                            </div>
                            <div>
                                <select id="select_Agent_Name" name="select_Agent_Name" class="chosen-select" style="width: 100%" onchange="Agent_WorkTime()">
                                    <option value="">請選擇被派人員…</option>
                                </select>
                            </div>
                            <div>
                                人員狀態：
                                <label id="working" style="color: #009933"></label>
                                <label id="noworking" style="color: #ff0000"></label>
                            </div>
                        </td>
                        <td style="text-align: center; color: #D50000;">
                            <strong>服務車輛</strong>
                        </td>
                        <td>
                            <div>
                                <select id="select_Car_Team" name="select_Car_Team" class="chosen-select" style="width: 100%" onchange="Car_Name_List('0','0')">
                                    <option value="">請選擇所屬部門…</option>
                                </select>
                            </div>
                            <div>
                                <select id="select_Car_Name" name="select_Car_Name" class="chosen-select" style="width: 100%" onchange="Car_Number_List('0')">
                                    <option value="">請選擇車輛保管人…</option>
                                </select>
                            </div>
                            <div>
                                <select id="select_Car_Number" name="select_Car_Number" class="chosen-select" style="width: 100%">
                                    <option value="">請選擇車牌號碼…</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center">
                            <strong>派工說明</strong>
                        </td>
                        <td>
                            <div style="float: left" data-toggle="tooltip" data-placement="bottom" title="不能超過２５０個字元，並且含有不正確的符號">
                                <textarea id="Answer2" class="form-control" cols="45" rows="3" placeholder="派工說明" maxlength="250" onkeyup="txt(this);" style="resize: none"></textarea>
                            </div>
                        </td>
                        <td style="text-align: center; color: #D50000;">
                            <strong>結案說明</strong>
                        </td>
                        <td>
                            <div style="float: left" data-toggle="tooltip" data-placement="bottom"
                                title="需求單狀態為【尚未派工】時請務必填寫【結案說明 】，不能超過２５０個字元，並且含有不正確的符號">
                                <textarea id="txt_CaseClosed" class="form-control" cols="45" rows="3" placeholder="結案說明" maxlength="250" onkeyup="txt(this);"
                                    style="resize: none; background-color: #ffffbb"></textarea>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <table class="table table table-striped">
            <tbody>
                <tr>
                    <td colspan="4" style="text-align: center">
                        <input id="hid_Create_ID" type="hidden" />
                        <input id="hid_Type_Value" type="hidden" />
                        <input id="hid_PostCode" type="hidden" />
                        <input id="hid_Service_ID" type="hidden" />
                        <button id="Btn_Update" type="button" onclick="Btn_New_Click();" class="btn btn-primary btn-lg ">
                            <span class="glyphicon glyphicon-user"></span>
                            &nbsp;&nbsp;派工
                        </button>
                        &nbsp;&nbsp;
                        <button id="Btn_Back" type="button" onclick="Btn_Back_Click();" class="btn btn-default btn-lg ">
                            返回&nbsp;&nbsp;
                            <span class="glyphicon glyphicon-share-alt"></span>
                        </button>
                        &nbsp;&nbsp;                   
                        <button id="Btn_Closed" type="button" onclick="Btn_Closed_Click();" class="btn btn-danger btn-lg ">
                            <span class="glyphicon glyphicon-ok"></span>
                            &nbsp;&nbsp;結案
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>

        <!--===================================================-->

        <%--  ========== 子單 ===========--%>
        <div class="table-responsive" id="Table_CNo">
            <h2><strong>派工單處理狀況（瀏覽）&nbsp; &nbsp;</strong></h2>
            <table id="data" class="display table table-striped" style="width: 99%">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 9%;">派工單編號</th>
                        <th style="text-align: center; width: 6%;">案件狀態</th>
                        <th style="text-align: center; width: 10%;">處理部門</th>
                        <th style="text-align: center; width: 6%;">處理人員</th>
                        <th style="text-align: center; width: 15%;">暫結案說明<br />
                            （後續處理說明）</th>
                        <th style="text-align: center; width: 9%;">到點時間</th>
                        <th style="text-align: center; width: 6%;">到點人員</th>
                        <th style="text-align: center; width: 9%;">完成時間</th>
                        <th style="text-align: center; width: 6%;">完成人員</th>
                        <th style="text-align: center; width: 9%;">暫結案<br />
                            時間</th>
                        <th style="text-align: center; width: 7%;">暫結案<br />
                            人員</th>
                        <th style="text-align: center; width: 8%;">功能</th>
                    </tr>
                </thead>
            </table>
        </div>

        <!--===================================================-->

        <script>
            $.datetimepicker.setLocale('ch');
            $('#datetimepicker03').datetimepicker({
                allowTimes: [
                   '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                   '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                   '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                   '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
                ]
            });

            $('#datetimepicker04').datetimepicker({
                allowTimes: [
                   '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                   '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                   '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                   '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
                ]
            });

            $(function () {
                $('.chosen-select').chosen();
                $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
                $('.chosen-single').css({ 'background-color': '#ffffbb' });
            });
        </script>
    </div>
</asp:Content>
