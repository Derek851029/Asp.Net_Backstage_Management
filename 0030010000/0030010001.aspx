<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0030010001.aspx.cs" Inherits="_0030010002" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../fullcalendar-3.0.1/fullcalendar.print.css" rel="stylesheet" media="print" />
    <link href="../fullcalendar-3.0.1/fullcalendar.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../js/jquery.min.js"></script>
    <script src="../DataTables/jquery-1.12.3.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../fullcalendar-3.0.1/lib/moment.min.js"></script>
    <script src="../fullcalendar-3.0.1/fullcalendar.min.js"></script>
    <script src="../fullcalendar-3.0.1/locale-all.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>

    <!------------------------------------------------------------------------------------>

    <script>
        $(document).ready(function () {
            Agent_Team_List();
            Agent_Name_List();
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
                defaultView: 'listDay',//listDay, listWeek
                locale: 'zh-tw',
                events: function (start, end, timezone, callback) {
                    var s = document.getElementById("select_Agent_Team");
                    var str_team = s.options[s.selectedIndex].value;
                    s = document.getElementById("select_Agent_Name");
                    var str_name = s.options[s.selectedIndex].value;
                    $.ajax({
                        url: '0030010001.aspx/GetClassGroup',
                        type: 'POST',
                        //async: false,
                        data: JSON.stringify({ start: start.format("YYYY/MM/DD"), end: end.format("YYYY/MM/DD"), Agent_ID: str_name, Agent_Team: str_team }),
                        contentType: 'application/json; charset=UTF-8',
                        dataType: "json",       //如果要回傳值，請設成 json
                        success: function (doc) {
                            var events = [];
                            $(eval(doc.d)).each(function () {
                                events.push({
                                    title: this.title,
                                    start: this.start,
                                    end: this.end
                                });
                            });
                            callback(events);
                        }
                    });
                }
            });
            $('#calendar').fullCalendar('refetchEvents');
        }

        //================ 帶入【被派人員】資訊 ==============

        function Agent_Team_List() {
            $.ajax({
                url: '0030010001.aspx/Agent_Team',
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
                }
            });
        }

        function Agent_Name_List() {
            var $select_elem = $("#select_Agent_Name");
            var s = document.getElementById("select_Agent_Team");
            var str_value = s.options[s.selectedIndex].value;
            $.ajax({
                url: '0030010001.aspx/Agent_Name',
                type: 'POST',
                data: JSON.stringify({ value: str_value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇人員姓名…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_ID + "'>" + obj.Agent_Name + "</option>");
                    });
                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                }
            });
            renderCalendar();
        }
    </script>
    <style>
        body {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 22px;
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
    </style>

    <!----------------------------------------------->
    <h2><strong>&nbsp; &nbsp; 派工人員行程表（瀏覽）</strong></h2>
    <div style="width: 95%; height: 1000px; margin: 10px 20px">
        <div id="Table">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center" colspan="2">
                            <span style="font-size: 20px"><strong>部門與人員選擇</strong></span>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="text-align: center; width: 30%;">
                            <strong>人員部門</strong>
                        </td>
                        <td style="width: 70%">
                            <select id="select_Agent_Team" name="select_Agent_Team" style="width: 100%" onchange="Agent_Name_List()">
                                <option value="">請選擇人員部門…</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; width: 30%;">
                            <strong>人員姓名</strong>
                        </td>
                        <td style="width: 70%">
                            <select id="select_Agent_Name" name="select_Agent_Name" style="width: 100%" onchange="renderCalendar()">
                                <option value="">請選擇人員姓名…</option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="calendar"></div>
    </div>
</asp:Content>
