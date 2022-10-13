<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0030010006.aspx.cs" Inherits="_0030010006" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../fullcalendar-2.8.0/fullcalendar.css" rel="stylesheet" />
    <link href="../fullcalendar-2.8.0/fullcalendar.print.css" rel="stylesheet" media="print" />
    <link href="../fullcalendar-2.8.0/fullcalendar.min.css" rel="stylesheet" />
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery-1.12.3.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../fullcalendar-2.8.0/lib/moment.min.js"></script>
    <script src="../fullcalendar-2.8.0/fullcalendar.min.js"></script>
    <script src="../fullcalendar-2.8.0/lang-all.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>

    <!------------------------------------------------------------------------------------>
    
    <script >
        var str_time = '<%= str_time %>';
        $(document).ready(function () {           
            renderCalendar();
            Load();
            //style('Schedule', '');
            List_Dispatch_Team();
            Change_Dispatch();   //"0"
            style('Chose_Company', '0');
            style('Dispatch_Name', '');
            //bindTable(calEvent.start, calEvent.type, calEvent.id);    //似乎不用先執行
        });
        function ShowTime() {                               //自動抓現在時間(實行指令時)
            var NowDate = new Date();
            var h = NowDate.getHours();
            var m = NowDate.getMinutes();
            var s = NowDate.getSeconds();
            var y = NowDate.getFullYear();
            var mon = NowDate.getMonth() + 1;
            var d = NowDate.getDate();            
            document.getElementById('LoginTime').innerHTML = y + "/" + mon + "/" + d + " " + h + ":" + m;
        }
        //產生行事曆
        function renderCalendar() {
            $('#calendar').fullCalendar({
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: '' //'month,agendaWeek,agendaDay'
                },
                editable: false,
                defaultDate: new Date(),
                lang: 'zh-tw',
                eventClick: function (calEvent, jsEvent, view) {
                    //alert();
                    //alert(calEvent.start);
                    bindTable(calEvent.start, calEvent.type);
                },
                eventAfterRender: function (calEvent, jsEvent, view) {
                    //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
                    if (calEvent.value == '1') {
                        jsEvent.css('background-color', '#e00000');
                    } else if (calEvent.value == '2') {
                        jsEvent.css('background-color', '#e06800');
                    } else if (calEvent.value == '3') {
                        jsEvent.css('background-color', '#cde000');
                    } else if (calEvent.value == '4') {
                        jsEvent.css('background-color', '#43e000');
                    } else if (calEvent.value == '5') {
                        jsEvent.css('background-color', '#00e077');
                    } else if (calEvent.value == '6') {
                        jsEvent.css('background-color', '#00afaf');
                    } else if (calEvent.value == '7') {
                        jsEvent.css('background-color', '#0061e0');
                    } else if (calEvent.value == '8') {
                        jsEvent.css('background-color', '#9c00e0');
                    } else if (calEvent.value == '0') {
                        jsEvent.css('background-color', '#7a7a7a');
                    }
                },
                events: function (start, end, timezone, callback) {
                    $.ajax({
                        url: '0030010006.aspx/GetClassGroup',
                        type: 'POST',
                        //async: false,
                        data: JSON.stringify({
                            start: start.format("YYYY/MM/DD"),
                            end: end.format("YYYY/MM/DD"),
                            time: str_time
                        }),
                        contentType: 'application/json; charset=UTF-8',
                        dataType: "json",       //如果要回傳值，請設成 json
                        success: function (doc) {
                            var events = [];
                            $(eval(doc.d)).each(function () {
                                events.push({
                                    title: this.title,
                                    start: this.start,
                                    type: this.type,
                                    value: this.value,
                                    id: this.id
                                });
                            });
                            callback(events);
                        }
                    });
                }
            });
        }
        //==============================
 
        function Load() {                                          // 讀資料            
            //ShowTime();
            //document.getElementById("Button2").style.display = "none";
            document.getElementById("title_modal").innerHTML = '補打卡';
            $.ajax({
                url: '0030010006.aspx/Load',
                type: 'POST',
                data: JSON.stringify({}),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    //alert(json.status);
                    if (json.status != "空的") {
                        var text = '{"data":' + doc.d + '}';
                        var obj = JSON.parse(text);
                        //alert(obj.data[0].Work);
                        if (obj.data[0].Work == "已上班") {
                            //alert("已打上班卡");
                            //document.getElementById("Lable1").innerHTML = "已打上班卡";
                            //document.getElementById("Button1").style.display = "none";
                            //document.getElementById("Button2").style.display = "none";
                        }
                        else
                        {
                            //document.getElementById("Button1").style.display = "none";
                            //document.getElementById("Button2").style.display = "none";
                        }
                        
                    }
                    else {
                        //alert("本日尚未打卡");
                        //document.getElementById("Lable1").innerHTML = "本日尚未打卡";
                    }
                }
            });
            /*           if (a == 0) {
                           //alert('檢查中1');
                           document.getElementById("btn_new").style.display = "";
                           document.getElementById("btn_update").style.display = "none";
                           document.getElementById("title_modal").innerHTML = '上班打卡';
                       } else {
                           //alert('檢查中2');
                           //document.getElementById("txt_ROLE_ID").disabled = true;
                           document.getElementById("btn_update").style.display = "";                               //顯示修改鈕
                           document.getElementById("btn_new").style.display = "none";                          //隱藏新增鈕
                           document.getElementById("title_modal").innerHTML = '下班打卡';
                           //Load_ Data(OE_ID); 
                       }   //else 結束*/
        }


        function bindTable(date, type) {            //案件列表程式
            //alert(type);
            console.log('date', date.format("YYYY/MM/DD"), 'type', type);
            $.ajax({
                url: '0030010006.aspx/GetClassScheduleList',
                type: 'POST',
                //async: false,     //功能???
                data: JSON.stringify({
                    date: date.format("YYYY-MM-DD"),
                    Type: type
                }),
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
                            "info": false,
                            "defaultContent": "<button type='button' id='edit' class='btn btn-info btn-lg'>" +
                                "<span class='glyphicon glyphicon-search'></span>&nbsp;明細</button>"
                        }],
                        columns: [
                                { data: "Day" },
                                { data: "Agent_Name" },
                                { data: "Schedule" },
                                { data: "Work" },
                                { data: "Job_Agent" },
                                { data: "S_UpdateTime" },
                                { data: "To_W_Time" },
                                { data: "Off_W_Time" },
                                {
                                    data: "DI_No", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-primary btn-lg' " +
                                            "data-toggle='modal' data-target='#newModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'>" +
                                            "</span>&nbsp;修改打卡時間</button>";
                                    }
                                }                                
                        ]
                    });
                    $('#data tbody').unbind('click').
                        on('click', '#edit', function () {
                            var mno = table.row($(this).parents('tr')).data().DI_No.toString();
                            //alert(mno);
                            Load_Data(mno);
                        }); //*/
                }
            });
        }
        
        function Load_Data(mno) {     //選顧客後抓資料           
            $.ajax({
                url: '0030010006.aspx/Load_Data',
                type: 'POST',
                data: JSON.stringify({ value: mno }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //alert("A"+obj.data[0].A + "A");
                    //alert("B" + obj.data[0].B + "B");
                    //alert("C" + obj.data[0].C + "C");
                    document.getElementById("datetimepicker01").value = obj.data[0].A;//顯示成可更改的欄位
                    style('Dispatch_Name', obj.data[0].B);
                    document.getElementById("Time1").value = obj.data[0].C;
                    document.getElementById("Time2").value = obj.data[0].D;
                      //*/
                }
            });
        }

        function List_Dispatch_Team() {     //選派工部門選項(停用)
            $.ajax({
                url: '0030010006.aspx/List_Dispatch_Team',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Chose_Company");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.A + "'>" + obj.A + "</option>");
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({  }); //'background-color': '#ffffbb' });
                }
            });
        }

        function Change_Dispatch() {     //Company
            var value = document.getElementById("Chose_Company").value;
            //alert(value);
            $.ajax({
                url: '0030010006.aspx/List_Dispatch_Name',
                type: 'POST',
                data: JSON.stringify({ value: value }), //value: value
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Dispatch_Name");     //派公人員選項
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選打卡員工…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.B + "'>" + obj.A + "</option>");
                        //document.getElementById("A_ID").value = obj.B;      //data[0].
                        //document.getElementById("Handle_Agent").value = obj.A;      //data[0].
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        function URL(mno) {
            $.ajax({
                url: '0030010006.aspx/URL',
                type: 'POST',
                data: JSON.stringify({ mno: mno }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.type == "ok") {
                        window.location = json.status;
                    } else {
                        alert(json.status);
                    }
                }
            });
        }

        function OnWork() {
            if (confirm("確定打上班卡嗎？")) {
                $.ajax({
                    url: '0030010006.aspx/Onwork',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    //data: JSON.stringify({ Agent_ID: Agent_ID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "onwork") {
                            alert('打卡成功');
                            window.location.href = "/0030010000/0030010006.aspx";
                        }
                        else if (json.status == "Any") {
                            alert('已有資料');
                        }
                        else alert('上班失敗');
                    }
                });
            }
        };
        function OffWork() {
            if (confirm("確定打下班卡嗎？")) {
                $.ajax({
                    url: '0030010006.aspx/Offwork',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    //data: JSON.stringify({ Agent_ID: Agent_ID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "offwork") {
                            alert('下班成功');
                            window.location.href = "/0030010000/0030010006.aspx";
                        }
                        else alert('下班失敗');
                    }
                });
            }
        };

        function New() {
            document.getElementById("datetimepicker01").value = "";
            //document.getElementById("Dispatch_Name").value = "";
            style('Dispatch_Name', '');
            document.getElementById("Time1").value = "";
            document.getElementById("Time2").value = "";
        };

        //================【下拉選單】 CSS 修改 ================
        function style(Name, value) {
            var $select_elem = $("#" + Name);
            $select_elem.chosen("destroy")
            document.getElementById(Name).value = value;
            $select_elem.chosen({
                width: "100%",
                search_contains: true
            });
            $('.chosen-single').css({   });//'background-color': '#ffffbb' });
        }

        function Setup() {
            var day = document.getElementById("datetimepicker01").value.toString("yyyy/MM/dd");
            var str_j_a = document.getElementById("Dispatch_Name").value;
            var time1 = document.getElementById("Time1").value;
            var time2 = document.getElementById("Time2").value;

            //alert("A"+day+"A");
            if (confirm("確認要修改打卡紀錄嗎")) {
                $.ajax({
                    url: '0030010006.aspx/Setup',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ day: day, Agent_ID: str_j_a, time1: time1, time2: time2 }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "new") {                     
                            //alert("新增成功");
                            window.location = "../0030010000/0030010006.aspx"
                        }
                        else if (json.status == "update") {                
                            //alert("修改成功");
                            window.location = "../0030010000/0030010006.aspx"
                        }
                        else alert(json.status);
                    }
                    ,error: function () { alert("請輸入正確時間格式 ex: 09:00, 12:01:59, 16:59:35.05"); }
                });
                renderCalendar();
            }   //*/            
        };

        function Wai_Bau() {
            window.location = "../0030010098.aspx"
        }


                
    </script>
    <style>
        #calendar .fc-content {
            font-size: 18px;
        }

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

        #data td:nth-child(8), #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5),
        #data td:nth-child(4), #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1),
        #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <!----------------------------------------------->
    <div class="table-responsive" style="text-align: center; width:500px; margin: 10px 20px">
        <h2><strong>補打卡頁面&nbsp; &nbsp;<!--<label id="Lable1" style="color:#fb4848" ></label>-->
        </strong></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="5">
                        <span style="font-size: 20px"><strong>打卡處&nbsp;&nbsp;</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <td>
                        <!--<button id="Button1" type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="" style="width: 110px; height: 65px" onclick="OnWork()">
                                <span class=''></span>&nbsp;上班&nbsp;</button>
                            <button id="Button2" type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="" style="width: 110px; height: 65px" onclick="OffWork()">
                                <span class=''></span>&nbsp;下班&nbsp;</button>-->
                        <button id="Button3" type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#newModal" style="width: 110px; height: 65px" onclick="New()">
                                <span class=""></span>&nbsp;補打卡&nbsp;</button>                                    
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
       <table  id="data" class="display table table-striped" style="width: 99%">
            
            <thead>
                <tr>
                    <th style="text-align: center;" width: 10%;>
                       <%-- <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" >
                            <span></span>回覆</button> --%>
                        <strong>日期</strong>
                    </th>
                    <th style="text-align: center;" width: 10%;>員工名稱</th>
                    <th style="text-align: center;" width: 15%;>預定行程</th>
                    <th style="text-align: center;" width: 10%;>打卡狀態</th>
                    <th style="text-align: center;" width: 10%;>代理人</th>
                    <th style="text-align: center;" width: 15%;>行程修改時間</th>
                    <th style="text-align: center;" width: 10%;>上班時間</th>
                    <th style="text-align: center;" width: 10%;>下班時間</th>
                    <th style="text-align: center;" width: 10%;>打卡</th>   
                </tr>
                <%--  =========== 勞工資料 ===========--%>                
            </thead>           
        </table>        
        <div id="calendar"></div>
    </div>

 

    <!-- ====== 上下班表 ====== -->
    <div class="modal fade" id="newModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1100px;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="title_modal"></label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== 表格 -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="6">
                                    <span style="font-size: 20px"><strong>排定規劃</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>排定日期</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="必選">
                                        <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01" placeholder="不記錄時間" style="background-color: #ffffbb" />
                                    </div>
                                </td>                                
                                <!--                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>排定行程</strong>
                                </th>
                                <td style="width: 30%">
                                    <div data-toggle="tooltip" title="必選">
                                      <select id="Schedule" name="Schedule" class="chosen-select" background-color: #ffffbb>
                                            <option value="">請選擇…</option>
                                            <option value="休假申請">休假申請</option>
                                            <option value="公出">公出</option>
                                          <option value="1">其他</option>
                                      </select>
                                                                      <input type="text" id="Schedule" name="Schedule" class="form-control" placeholder=""
                                            maxlength="" style="Font-Size: 18px; background-color: #ffffbb" title="必填" />  
                                    </div>
                                </td>-->
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 20%">
                                    <strong>選擇員工部門</strong>
                                </th>
                                <th style="width: 30%">
                                    <select id="Chose_Company" name="Chose_Company" class="chosen-select" onchange="Change_Dispatch()">
                                        <option value="0">請選擇部門…</option>
                                    </select>
                                </th>
                                <th style="text-align: center; width: 20%">
                                    <strong>選擇打卡員工</strong>
                                </th>
                                <th style="width: 30%">
                                    <select id="Dispatch_Name" name="Dispatch_Name" class="chosen-select" onchange="" style="background-color: #ffffbb">
                                        <option value="">請選擇員工…</option>
                                    </select>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>上班時間</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="請依時間格式  時:分 或 時:分:秒 輸入">
                                        <input type="text" class="form-control" id="Time1" name="Time1" maxlength="15" placeholder="09:00 或 09:00:35.00..." />
                                    </div>
                                </td>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>下班時間</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="請依時間格式  時:分 或 時:分:秒 輸入">
                                        <input type="text" class="form-control" id="Time2" name="Time2" maxlength="15" placeholder="17:00 或 17:01:23.45..." />
                                    </div>
                                </td>
                            </tr>
                            <tr>

                                <th style="text-align: center;">
                                    <button id="Button4" type="button" class="btn btn-primary btn-lg" onclick="Setup()"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;打卡</button>
                                </th>
                                <th>
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span>&nbsp;取消</button>
                                </th>

                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <script  type="text/javascript">
            $.datetimepicker.setLocale('ch');
            $('#datetimepicker01').datetimepicker({
                allowTimes: [
 /*                  '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'  //*/
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



