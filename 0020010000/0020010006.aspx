<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0020010006.aspx.cs" Inherits="_0020010006" %>

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
        $(document).ready(function () {
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
                    //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
                    if (calEvent.value == '1') {
                        jsEvent.css('background-color', '#9E9E9E');
                    } else if (calEvent.value == '2') {
                        jsEvent.css('background-color', '#757575');
                    } else if (calEvent.value == '3') {
                        jsEvent.css('background-color', '#616161');
                    } else if (calEvent.value == '4') {
                        jsEvent.css('background-color', '#424242');
                    } else if (calEvent.value == '5') {
                        jsEvent.css('background-color', '#F44336');
                    }
                },
                events: function (start, end, timezone, callback) {
                    $.ajax({
                        url: '0020010006.aspx/GetClassGroup',
                        type: 'POST',
                        //async: false,
                        data: JSON.stringify({ start: start.format("YYYY/MM/DD"), end: end.format("YYYY/MM/DD") }),
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
                url: '0020010006.aspx/GetClassScheduleList',
                type: 'POST',
                //async: false,
                data: JSON.stringify({ date: date.format("YYYY/MM/DD"), Type: type }),
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
                            "defaultContent": "<button id='edit' type='button' class='btn btn-info btn-lg'>" +
                                "<span class='glyphicon glyphicon-search'></span>&nbsp;明細</button>"
                        }],
                        columns: [
                                { data: "MNo" },
                                { data: "Type" },
                                { data: "Time_01" },
                                { data: "ServiceName" },
                                { data: "Cust_Name" },
                                { data: "Labor_CName" },
                                { data: "Question" },
                                { data: "" }
                        ]
                    });

                    $('#data tbody').unbind('click').
                        on('click', '#edit', function () {
                            var str_mno = table.row($(this).parents('tr')).data().MNo;
                            var URL = "../0020010000/0020010007.aspx?seqno=" + str_mno;
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

    <h2><strong>&nbsp; &nbsp; 勞工需求單（審核）&nbsp; &nbsp;</strong></h2>

    <!----------------------------------------------->

    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center; width: 15%;">母單編號</th>
                    <th style="text-align: center; width: 10%;">狀態</th>
                    <th style="text-align: center; width: 10%;">起始日期</th>
                    <th style="text-align: center; width: 10%;">服務內容</th>
                    <th style="text-align: center; width: 15%;">廠商名稱</th>
                    <th style="text-align: center; width: 10%;">勞工姓名</th>
                    <th style="text-align: center; width: 20%;">狀況說明</th>
                    <th style="text-align: center; width: 10%;">功能</th>
                </tr>
            </thead>
        </table>
    </div>

    <div style="width: 1280px; height: 1000px; margin: 10px 20px">
        <div id="calendar"></div>
    </div>
</asp:Content>
