<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0020010005.aspx.cs" Inherits="_0020010005" %>

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
        $(document).ready(function () {
            switch ('<%= str_time %>') {
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
            renderCalendar();
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
                    bindTable(calEvent.start, calEvent.type);
                },
                eventAfterRender: function (calEvent, jsEvent, view) {
                    //  類型  1：已分派  2：處理中  3：已到點    4：已完成    5：已結案    6：退單
                    if (calEvent.value == '1') {
                        jsEvent.css('background-color', '#9E9E9E');
                    } else if (calEvent.value == '2') {
                        jsEvent.css('background-color', '#757575');
                    } else if (calEvent.value == '3') {
                        jsEvent.css('background-color', '#616161');
                    } else if (calEvent.value == '4') {
                        jsEvent.css('background-color', '#424242');
                    } else if (calEvent.value == '5') {
                        jsEvent.css('background-color', '#212121');
                    } else if (calEvent.value == '6') {
                        jsEvent.css('background-color', '#F44336');
                    }
                },
                events: function (start, end, timezone, callback) {
                    $.ajax({
                        url: '0020010005.aspx/GetClassGroup',
                        type: 'POST',
                        //async: false,
                        data: JSON.stringify({ start: start.format("YYYY/MM/DD"), end: end.format("YYYY/MM/DD"), time: "<%= str_time %>" }),
                        contentType: 'application/json; charset=UTF-8',
                        dataType: "json",       //如果要回傳值，請設成 json
                        success: function (doc) {
                            var events = [];
                            $(eval(doc.d)).each(function () {
                                events.push({
                                    title: this.title,
                                    start: this.start,
                                    type: this.type,
                                    value: this.value
                                });
                            });
                            callback(events);
                        }
                    });
                }
            });
        }

        function bindTable(date, type) {
            $.ajax({
                url: '0020010005.aspx/GetClassScheduleList',
                type: 'POST',
                //async: false,
                data: JSON.stringify({ date: date.format("YYYY/MM/DD"), type: type, str_time: "<%= str_time %>" }),
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
                            "defaultContent": ""
                        }],
                        columns: [
                                { data: "CNo" },
                                { data: "Danger" },
                                { data: "OverTime" },
                                { data: "Type" },
                                { data: "ServiceName" },
                                { data: "Agent_Name" },
                                { data: "UPDATE_TIME" },
                                { data: "UPDATE_Name" },
                                {
                                    data: "", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-info btn-lg'><span class='glyphicon glyphicon-search'></span>&nbsp;&nbsp;明細</button>"
                                    }
                                }
                        ]
                    });

                    $('#data tbody').on('click', '#edit', function () {
                        var str_cno = table.row($(this).parents('tr')).data().CNo;
                        var URL = "../0020010000/0020010008.aspx?seqno=" + str_cno;
                        location.href = (URL);
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

    <h2><strong>&nbsp; &nbsp; 個人派工及結案管理（瀏覽） &nbsp; &nbsp;</strong></h2>

    <!----------------------------------------------->

    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">子單編號</th>
                    <th style="text-align: center;">緊急程度</th>
                    <th style="text-align: center;">預定完成時間</th>
                    <th style="text-align: center;">處理狀況</th>
                    <th style="text-align: center;">服務內容</th>
                    <th style="text-align: center;">被派人員</th>
                    <th style="text-align: center;">派單時間</th>
                    <th style="text-align: center;">派單人員</th>
                    <th style="text-align: center;">功能</th>
                </tr>
            </thead>
        </table>
    </div>
    <br />
    <div style="width: 1280px; height: 1000px; margin: 10px 20px">
        <div style="float: right;">
            <a id="btn_a" href="0020010005.aspx" class="btn btn-warning btn-lg"><span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;整天</a>&nbsp;
            <a id="btn_b" href="0020010005.aspx?str_time=1" class="btn btn-warning btn-lg"><span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;上午</a>&nbsp;
            <a id="btn_c" href="0020010005.aspx?str_time=2" class="btn btn-warning btn-lg"><span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;下午</a>
        </div>
        <div id="calendar"></div>
    </div>
</asp:Content>
