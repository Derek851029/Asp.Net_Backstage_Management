<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0030010008.aspx.cs" Inherits="_0030010008" %>

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
        $(document).ready(function () {
            /*switch (str_time) {
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
            }//*/
            document.getElementById('Btn_Refresh').style.display = "none";
            renderCalendar();
            Team_Check();
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
                    bindTable(calEvent.start, calEvent.type, calEvent.id);
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
                        url: '0030010008.aspx/GetClassGroup',
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
        function Team_Check() {
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

        function bindTable(date, type, id) {
            var title_value = "狀況說明";
            if (type == "取消") { title_value = "取消原因" };
            $.ajax({
                url: '0030010008.aspx/GetClassScheduleList',
                type: 'POST',
                //async: false,
                data: JSON.stringify({
                    date: date.format("YYYY/MM/DD"),
                    Type: type,
                    str_time: str_time
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
                                { data: "Case_ID" },
                                { data: "OnSpotTime" },
                                { data: "Telecomm_ID" },
                                { data: "Type" },
                                { data: "BUSINESSNAME" },
                                { data: "Agent_Name" },
                                { data: "ReachTime" },
                                /*{
                                    data: "Urgency", render: function (data, type, row, meta) {
                                        if (row.Type == '取消') { return row.OpinionType; }
                                        else { return row.Urgency; };
                                    }, title: title_value
                                },//*/
                                { data: "" }
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
                url: '0030010008.aspx/URL',
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
        
        function Xin_De() {
            URL("0");
        }

        function RE() {
            if (str_view == "0")
                window.location.href = '/0030010000/0030010008.aspx?view=1';
            else
                window.location.href = '/0030010000/0030010008.aspx?view=0';
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

    <h2><strong>&nbsp; &nbsp; 個人維護單瀏覽&nbsp; &nbsp;</strong>
    </h2>
    &nbsp;&nbsp;&nbsp;
    <button id="Btn_Refresh" type="button" onclick="RE();" class="btn btn-success btn-lg ">
        <span class="glyphicon glyphicon-refresh"></span>&nbsp;&nbsp;全體/個人切換</button>
    <!----------------------------------------------->

    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center; ">維護單編號</th>
                    <th style="text-align: center; ">預定日期</th>
                    <th style="text-align: center; ">維護廠商</th>
                    <th style="text-align: center; ">狀態</th>
                    <th style="text-align: center; ">客戶名稱</th>
                    <th style="text-align: center; ">維護工程師</th>
                    <th style="text-align: center; ">實際維護日期</th>
                    <th style="text-align: center; ">修改</th>
                </tr>
            </thead>
        </table>
        <br />
        <!--<div style="float: right;">
            <a id="btn_a" href="0030010008.aspx" class="btn btn-warning btn-lg"><span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;整天</a>&nbsp;
            <a id="btn_b" href="0030010008.aspx?str_time=1" class="btn btn-warning btn-lg"><span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;上午</a>&nbsp;
            <a id="btn_c" href="0030010008.aspx?str_time=2" class="btn btn-warning btn-lg"><span class='glyphicon glyphicon-search'></span>&nbsp; &nbsp;下午</a>
        </div>-->
        <div id="calendar"></div>
    </div>
</asp:Content>
