<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0150010002.aspx.cs" Inherits="_0150010002" %>

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
                    $(this).css('border-color', 'red');
                    bindTable(calEvent.start, calEvent.title);
                },
                events: function (start, end, timezone, callback) {
                    $.ajax({
                        url: '0150010002.aspx/GetClassGroup',
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
                                    start: this.start
                                });
                            });
                            callback(events);
                        }
                    });
                }
            });
        }

        function bindTable(date, ClassName) {
            $.ajax({
                url: '0150010002.aspx/GetClassScheduleList',
                type: 'POST',
                //async: false,
                data: JSON.stringify({ date: date.format("YYYY/MM/DD"), ClassName: ClassName }),
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
                            "defaultContent":
                                "<button type='button' id='edit' class='btn btn-primary btn-lg'><span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>" +
                                "&nbsp; &nbsp;" +
                                "<button id='del' class='btn btn-danger btn-lg'><span class='glyphicon glyphicon-remove'></span>&nbsp;刪除</button>"
                        }],
                        columns: [
                                { data: "WORK_DATETime" },
                                { data: "ClassName" },
                                { data: "WORK_Time" },
                                { data: "DIAL_Time" },
                                { data: "MASTER_Name" },
                                { data: "Partner_Driver" },
                                { data: "MASTER1_NAME" },
                                { data: "WORK_Status" },
                                { data: "UPDATE_TIME" },
                                { data: "" }
                        ]
                    });

                    $('#data tbody').unbind('click').
                        on('click', '#del', function () {
                            if (confirm("確定要刪除嗎？")) {
                                var data = table.row($(this).parents('tr')).data();
                                $.ajax({
                                    url: '0150010002.aspx/DelPartner',
                                    ache: false,
                                    type: 'POST',
                                    //async: false,
                                    data: JSON.stringify({ seqno: table.row($(this).parents('tr')).data().SYS_ID }),
                                    contentType: 'application/json; charset=UTF-8',
                                    dataType: "json",       //如果要回傳值，請設成 json
                                    success: function (data) {
                                        var json = JSON.parse(data.d.toString());
                                        if (json.status == "success") {
                                            alert("刪除完成。");
                                            bindTable();
                                        }
                                        else {
                                            alert(json.status);
                                        }
                                    }
                                });
                            }
                        }).
                        on('click', '#edit', function () {
                            var str_sys_id = table.row($(this).parents('tr')).data().SYS_ID;
                            var URL = "../0150010000/0150010003.aspx?seqno=" + str_sys_id;
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

        #data td:nth-child(9), #data td:nth-child(8), #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5),
        #data td:nth-child(4), #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
        <h2><strong>班表查詢</strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">日期</th>
                    <th style="text-align: center;">班次名稱</th>
                    <th style="text-align: center;">到班時間</th>
                    <th style="text-align: center;">通知時間</th>
                    <th style="text-align: center;">駕駛</th>
                    <th style="text-align: center;">代理駕駛</th>
                    <th style="text-align: center;">負責主管</th>
                    <th style="text-align: center;">狀態</th>
                    <th style="text-align: center;">更新日期</th>
                    <th style="text-align: center;">維護</th>
                </tr>
            </thead>
        </table>
    </div>

    <div style="width: 1280px; height: 1000px; margin: 10px 20px">
        <div id="calendar"></div>
    </div>
</asp:Content>
