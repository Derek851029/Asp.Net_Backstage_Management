<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0030010003.aspx.cs" Inherits="_0030010003" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery-1.12.3.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <link href="../fullcalendar-2.8.0/fullcalendar.css" rel="stylesheet" />
    <link href="../fullcalendar-2.8.0/fullcalendar.print.css" rel="stylesheet" media="print" />
    <link href="../fullcalendar-2.8.0/fullcalendar.min.css" rel="stylesheet" />
    <script src="../fullcalendar-2.8.0/lib/moment.min.js"></script>
    <script src="../fullcalendar-2.8.0/fullcalendar.min.js"></script>
    <script src="../fullcalendar-2.8.0/lang-all.js"></script>

    <!------------------------------------------------------------------------------------>
    
    <script>
        var str_time = '<%= str_time %>';
        var str_view = '<%= Session["view"] %>';
        var day = '<%= str_day %>';
        var type = '<%= str_type %>';
        $(document).ready(function () {
            document.getElementById('Btn_Refresh').style.display = "none";
            renderCalendar();
            Team_Check();
            //bindTable(calEvent.start, calEvent.type, calEvent.id);
            bindTable(day, type, "");
        });
        
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
                    //bindTable(calEvent.start, calEvent.type, calEvent.id);
                    var url = "0030010003.aspx?view=" + str_view + "&date=" + calEvent.start.format("YYYY-MM-DD") + "&type=" + calEvent.type;
                    location.href = (url);
                },
                eventAfterRender: function (calEvent, jsEvent, view) {
                    //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
                    if (calEvent.value == '1') {
                        jsEvent.css('background-color', '#9E9E9E');
                    } else if (calEvent.value == '2') {
                        jsEvent.css('background-color', '#616161'); //757575
                    } else if (calEvent.value == '3') {
                        jsEvent.css('background-color', '#353535');//424242
                    } else if (calEvent.value == '4') {
                        jsEvent.css('background-color', '#000000');
                    } else if (calEvent.value == '5') {
                        jsEvent.css('background-color', '#F44336');
                    } else if (calEvent.value == '6') {
                        jsEvent.css('background-color', '#F44336');
                    }
                },
                events: function (start, end, timezone, callback) {
                    $.ajax({
                        url: '0030010003.aspx/GetClassGroup',
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

        function Team_Check(){
            $.ajax({
                url: '0030010003.aspx/Team_Check',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    //alert(json.status);
                    if (json.status == "leader") {
                        document.getElementById('Btn_Refresh').style.display = "";
                    }
                }
            });
        };

        function bindTable(date, type, id) {            //案件列表程式
            //console.log('date', date.format("YYYY/MM/DD"), 'type', type, 'id', id);
            var title_value = "狀況說明";
            if (type == "取消") { title_value = "取消原因" };
            $.ajax({
                url: '0030010003.aspx/GetClassScheduleList',
                type: 'POST',
                //async: false,
                data: JSON.stringify({
                    //date: date.format("YYYY/MM/DD"),
                    date: date,
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
                                //{ data: "ReplyType" },
                                { data: "SetupTime" },
                                { data: "UploadTime" },
                                { data: "C_ID2" },
                                { data: "BUSINESSNAME" },
                                { data: "Urgency" },
                                { data: "OpinionType" },
                                { data: "Handle_Agent" },
                                {
                                    data: "Type"},
                                {
                                    data: "Case_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-info btn-lg'>" +
                                "<span class='glyphicon glyphicon-search'></span>&nbsp;明細</button>";
                                    }
                                }
                        ]
                    });

                    $('#data tbody').unbind('click').
                        on('click', '#edit', function () {
                            var mno = table.row($(this).parents('tr')).data().Case_ID.toString();
                            URL(mno);
                        });
                }
            });
        }

        function URL(mno) {
            $.ajax({
                url: '0030010003.aspx/URL',
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

        function RE() {
            if (str_view == "0")
                window.location.href = '/0030010000/0030010003.aspx?view=1';
            else
                window.location.href = '/0030010000/0030010003.aspx?view=0';
        }

        //function Xin_De() {
        //    URL("0");
        //}
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

    <h2><strong>&nbsp; &nbsp; 接單處理&nbsp; &nbsp;
        <button id="Btn_Refresh" type="button" onclick="RE();" class="btn btn-success btn-lg ">
            <span class="glyphicon glyphicon-refresh"></span>
            &nbsp;&nbsp;全體/個人切換
        </button>
    </strong></h2>

    <!----------------------------------------------->

    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
       <table  id="data" class="display table table-striped" style="width: 99%">
            
            <thead>
                <tr>
                    <th style="text-align: center;" width: 10%;>
                       <%-- <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" >
                            <span></span>回覆</button> --%>
                        <strong>登錄日期</strong>
                    </th>
                    
                    <th style="text-align: center;" width: 10%;>資料修改時間</th>
                    <th style="text-align: center;" width: 10%;>案件編號</th>
                    <th style="text-align: center;" width: 20%;>客戶名稱</th>
                    <th style="text-align: center;" width: 10%;>緊急程度</th>
                    <th style="text-align: center;" width: 10%;>意見類型</th>
                    <th style="text-align: center;" width: 10%;>派工人員</th>
                    <th style="text-align: center;" width: 10%;>案件狀態</th>
                    <th style="text-align: center;" width: 10%;>詳情</th>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
           
            </thead>
        </table>


        
        <div id="calendar"></div>
    </div>
</asp:Content>



