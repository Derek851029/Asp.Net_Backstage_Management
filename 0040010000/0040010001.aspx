<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0040010001.aspx.cs" Inherits="_0040010001" %>

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

    <script type="text/javascript">
        var time = '<%= str_time %>';
        var day = '<%= str_day %>';
        var type = '<%= str_type %>';
        $(document).ready(function () {
            switch (time) {
                case "1":
                    $("#btn_a").attr('class', 'btn btn-warning btn-lg');
                    $("#btn_b").attr('class', 'btn btn-default btn-lg disabled ');
                    $("#btn_c").attr('class', 'btn btn-warning btn-lg');
                    break;

                case "2":
                    $("#btn_a").attr('class', 'btn btn-warning btn-lg');
                    $("#btn_b").attr('class', 'btn btn-warning btn-lg');
                    $("#btn_c").attr('class', 'btn btn-default btn-lg disabled ');
                    break;

                default:
                    $("#btn_a").attr('class', 'btn btn-default btn-lg disabled ');
                    $("#btn_b").attr('class', 'btn btn-warning btn-lg');
                    $("#btn_c").attr('class', 'btn btn-warning btn-lg');
                    break;
            }
            bindTable(day, type);
            renderCalendar();
        });

        function bindTable(date, type) {
            $.ajax({
                url: '0040010001.aspx/GetClassScheduleList',
                type: 'POST',
                //async: false,
                data: JSON.stringify({ date: date, Type: type, str_time: time }),
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
                            "targets": 7,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                            { data: "MNo" },
                            { data: "Type" },
                            { data: "Time_01" },
                            { data: "ServiceName" },
                            { data: "Cust_Name" },
                            { data: "Labor_CName" },
                            {
                                data: "Question"
                            },
                            {
                                data: "", render: function (data, type, row, meta) {
                                    return "<button type='button' id='edit' class='btn btn-info btn-lg'>" +
                                        "<span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;明細</button>";
                                }
                            },
                            {
                                data: "Type_Value", render: function (data, type, row, meta) {
                                    if (data == "3") {
                                        if (row.SYSID == "0") {
                                            return "<button type='button' id='close' class='btn btn-danger btn-lg'><span class='glyphicon glyphicon-ok'></span>&nbsp; &nbsp;結案</button>";
                                        } else {
                                            return "<a class='btn btn-default btn-lg disabled'><span class='glyphicon glyphicon-ok'></span>&nbsp; &nbsp;結案</a>";
                                        }
                                    }
                                    else {
                                        return "<a class='btn btn-default btn-lg disabled'><span class='glyphicon glyphicon-ok'></span>&nbsp; &nbsp;結案</a>";
                                    }
                                }
                            }
                        ]
                    });

                    $('#data tbody').unbind('click').
                        on('click', '#edit', function () {
                            var str_mno = table.row($(this).parents('tr')).data().MNo;
                            var URL = "../0040010002.aspx?seqno=" + str_mno;
                            location.href = (URL);
                        }).
                        on('click', '#close', function () {
                            if (confirm("確定要直接結案嗎？")) {
                                var data = table.row($(this).parents('tr')).data();
                                $.ajax({
                                    url: '0040010001.aspx/Close_Flag',
                                    ache: false,
                                    type: 'POST',
                                    //async: false,
                                    data: JSON.stringify({
                                        SYS_ID: table.row($(this).parents('tr')).data().SYS_ID,
                                        MNo: table.row($(this).parents('tr')).data().MNo,
                                        ServiceName: table.row($(this).parents('tr')).data().ServiceName,
                                        Cust_Name: table.row($(this).parents('tr')).data().Cust_Name,
                                        Create_Name: table.row($(this).parents('tr')).data().Create_Name
                                    }),
                                    contentType: 'application/json; charset=utf-8',
                                    dataType: "json",       //如果要回傳值，請設成 json
                                    success: function (data) {
                                        var json = JSON.parse(data.d.toString());
                                        alert(json.status);
                                        bindTable(date, type);
                                    }
                                });
                            }
                        });
                    //========================
                }
            });
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
                    var url = "0040010001.aspx?date=" + calEvent.start.format("YYYY-MM-DD") + "&type=" + calEvent.value + "&str_time=" + time;
                    location.href = (url);
                    //bindTable(calEvent.start.format("YYYY-MM-DD"), calEvent.type);
                },
                eventAfterRender: function (calEvent, jsEvent, view) {
                    //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
                    if (calEvent.value == '1') {
                        jsEvent.css('background-color', '#9E9E9E');
                    } else if (calEvent.value == '2') {
                        jsEvent.css('background-color', '#43A047');
                    } else if (calEvent.value == '3') {
                        jsEvent.css('background-color', '#3F51B5');
                    } else if (calEvent.value == '4') {
                        jsEvent.css('background-color', '#424242');
                    } else if (calEvent.value == '5') {
                        jsEvent.css('background-color', '#FF0000');
                    } else if (calEvent.value == '0') {
                        jsEvent.css('background-color', '#FF0000');
                    }
                },
                events: function (start, end, timezone, callback) {
                    $.ajax({
                        url: '0040010001.aspx/GetClassGroup',
                        type: 'POST',
                        //async: false,
                        data: JSON.stringify({ start: start.format("YYYY/MM/DD"), end: end.format("YYYY/MM/DD"), time: time }),
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
    </script>
    <style>
        #calendar .fc-content {
            font-size: 16px;
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

    <h2><strong>&nbsp; &nbsp; 員工派工管理（瀏覽）</strong></h2>

    <!----------------------------------------------->

    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">母單編號</th>
                    <th style="text-align: center;">狀態</th>
                    <th style="text-align: center;">起始日期</th>
                    <th style="text-align: center;">服務內容</th>
                    <th style="text-align: center;">廠商名稱</th>
                    <th style="text-align: center;">勞工姓名</th>
                    <th style="text-align: center; width: 20%;">狀況說明</th>
                    <th style="text-align: center;">功能</th>
                    <th style="text-align: center;">結案</th>
                </tr>
            </thead>
        </table>
    </div>
    <br />
    <div style="width: 1280px; height: 1000px; margin: 10px 20px">
        <div style="float: right;">
            <a id="btn_a" href="0040010001.aspx?date=<%= str_day %>&type=<%= str_type %>&str_time=0" class="btn btn-warning btn-lg"><span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;整天</a>&nbsp;
            <a id="btn_b" href="0040010001.aspx?date=<%= str_day %>&type=<%= str_type %>&str_time=1" class="btn btn-warning btn-lg"><span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;上午</a>&nbsp;
            <a id="btn_c" href="0040010001.aspx?date=<%= str_day %>&type=<%= str_type %>&str_time=2" class="btn btn-warning btn-lg"><span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;下午</a>
        </div>
        <div id="calendar"></div>
    </div>
</asp:Content>
