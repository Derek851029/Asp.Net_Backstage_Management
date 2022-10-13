<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0030010102.aspx.cs" Inherits="_0030010102" %>

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
        $(document).ready(function () {           
            renderCalendar();
            OE_Main_List();
            //bindTable(0, 0, 0);
            //bindTable(start, type, id);
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
                        url: '0030010102.aspx/GetClassGroup',
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

        //==========================  OE 主分類
        function OE_Main_List() {
            alert(0);
            $.ajax({
                url: '0030010102.aspx/OE_Main',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    alert(1);
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_OE_Main");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Main_Classified + "'>" + obj.Main_Classified + "</option>");
                    });
                    alert(2);

                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });

                }
            });
        }
//*/
        function bindTable(date, type, id) {            //案件列表程式
            //console.log('date', date.format("YYYY/MM/DD"), 'type', type, 'id', id);
            //var title_value = "狀況說明";
            //if (type == "取消") { title_value = "取消原因" };
            
            $.ajax({                
                url: '0030010102.aspx/GetClassScheduleList',
                type: 'POST',
                //async: false,
                data: JSON.stringify({
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
                                { data: "ReplyType" },
                                { data: "Upload_Time" },
                                { data: "EstimatedFinishTime" },
                                { data: "Urgency" },
                                { data: "Case_ID" },
                                { data: "Cust_Name" },
                                { data: "ID" },
                                { data: "OpinionSubject" },
                                {
                                    data: "Type"},
                                {
                                    data: "", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-info btn-lg'>" +
                                "&nbsp;訂購&nbsp;</button>";
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
                url: '0030010102.aspx/URL',
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

        function Wai_Bau() {
            window.location = "../0030010098.aspx"
        }

        function Xin_De() {
            URL("0");
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

    <h2><strong>&nbsp; &nbsp; 10102 OE單 &nbsp; &nbsp;</strong>
    </h2>
    <!----------------------------------------------->

    <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>標地物清單（瀏覽）</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%;">
                        <strong>主類別</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip" title="" style="width: 100%">
                            <select id="select_OE_Main" name="select_OE_Main" class="chosen-select" onchange="">
                                <option value="">請選擇主分類</option>
                            </select>
                        </div>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>子類別</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip" title="" style="width: 100%">
                            <select id="select_OE_Detail" name="select_OE_Detail" class="chosen-select" onchange="">
                                <option value="">請選擇子分類</option>
                            </select>
                        </div>
                    </th>
                </tr>
                <tr>
                    <th>
                        <button id="Btn_Closed" type="button" onclick="bindTable();" class="btn btn-danger btn-lg ">                            
                            &nbsp;列表&nbsp;
                        </button>
                    </th>
                    
                </tr>
    <!----------------------------------------------->

    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
       <table  id="data" class="display table table-striped" style="width: 99%">
            
            <thead>
                <tr>
                    <th style="text-align: center;" width: 8%;>
                       <%-- <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" >
                            <span></span>回覆</button> --%>
                        <strong>回覆</strong>
                    </th>
                    <th style="text-align: center;" width: 9%;>登錄日期</th>
                    <th style="text-align: center;" width: 9%;>預定完成時間</th>
                    <th style="text-align: center;" width: 4%;>緊急程度</th>
                    <th style="text-align: center;" width: 10%;>案件編號</th>
                    <th style="text-align: center;" width: 10%;>登錄人員</th>
                    <th style="text-align: center;" width: 14%;>客戶ID</th>
                    <th style="text-align: center;" width: 14%;>意見主旨</th>
                    <th style="text-align: center;" width: 12%;>案件狀態</th>
                    <th style="text-align: center;" width: 10%;>維護</th>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
           
            </thead>
        </table>
        

        
        <div id="calendar"></div>
    </div>
</asp:Content>



