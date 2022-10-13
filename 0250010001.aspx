<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0250010001.aspx.cs" Inherits="_0250010001" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../js/jquery-ui.css" rel="stylesheet" />
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../js/jquery-ui.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>

    <script type="text/javascript">
        $(function () {
            List_Location();    //抓紀錄表
            List_PID(); //抓公司下拉
            List_Agent(0); //抓工程師下拉
        });

        function List_Location() {
            $.ajax({
                url: '0250010001.aspx/List_Location',
                type: 'POST',
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
                            "info": false
                        }],
                        columns: [
                           { data: "SYSID" },
                            { data: "Bus_Name" },
                            { data: "Cycle_Name" },
                            { data: "Addr" },
                            { data: "T_id" },
                            { data: "Agent_Name" },
                            {
                                data: "SYSID", render: function (data, type, row, meta) {
                                    return "<button id='edit' type='button' class='btn btn-primary btn-lg' >" +
                                        "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>" +
                                        "<button type='button' class='btn btn-danger btn-lg' id='delete'>" +
                                        "<span class='glyphicon glyphicon-remove'></span>&nbsp;刪除</button>";
                                }
                            },
                            { data: "Flag2" },
                            {
                                data: "Flag", render: function (data, type, row, meta) {
                                    var checked = 'checked/>'
                                    if (data == '0') {
                                        checked = '/>'
                                    }
                                    return "<div class='checkbox'><label>" +
                                        "<input id='Flag' type='checkbox' style='width: 30px; height: 30px;' " + checked +
                                        "</label></div>";
                                }
                            }
                        ]
                    });
                    //==========================
                    $('#data tbody').unbind('click').
                        on('click', '#edit', function () {
                            var table = $('#data').DataTable();
                            var id = table.row($(this).parents('tr')).data().SYSID;
                            Get_info(id);
                        })
                        .on('click', '#delete', function () {
                            var table = $('#data').DataTable();
                            var id = table.row($(this).parents('tr')).data().SYSID;
                            Delete(id);
                        }).
                       on('click', '#Flag', function () {
                           var table = $('#data').DataTable();
                           var id = table.row($(this).parents('tr')).data().SYSID;
                           var flag = table.row($(this).parents('tr')).data().Flag;
                           Open_Flag(id, flag);
                       });
                }
            });
        };

        

        function Get_info(SYS_ID) {     //轉跳第二頁
            $.ajax({
                url: '0250010001.aspx/Get_info',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        window.location = json.status;
                    } else {
                        alert(json.status);
                    }
                }
            });
        };

        function Delete(SYS_ID) { //刪除維護任務
            if (confirm("確定要刪除維護任務嗎？")) {
                $.ajax({
                    url: '0250010001.aspx/Delete_M_T',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ SYSID: SYS_ID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {
                            List_Location();
                        }
                        else
                            alert(json.status);
                    }
                });
            }
        };

        function Open_Flag(SYS_ID, Flag) {  //啟用與否的 Flag
            $.ajax({
                url: '0250010001.aspx/Open_Flag',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID, Flag: Flag }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        List_Location();
                    }
                    alert(json.status);
                }
            });
        };

        function CheckFlag() {  //測試時用的
            var a = document.getElementById("Checkbox1").checked;
            var b = document.getElementById("Checkbox2").checked;
            var c = document.getElementById("Checkbox3").checked;
            var d = document.getElementById("Checkbox4").checked;
            var e = document.getElementById("Checkbox5").checked;
            alert("box0=" + a + "  box1=" + b + "  box2=" + c + "   box3=" + d + "  box4=" + e);
            //document.getElementById("Checkbox0").checked = 'checked'
        }

        function Add_New() {    //新增清空格子
            style('New_PID', '');
            //document.getElementById("New_PID").value = '';
            //document.getElementById("New_PID2").value = '';
            document.getElementById("New_T_ID").value = '';
            document.getElementById("New_ADDR").value = '';
            document.getElementById("New_Name").value = '';
            document.getElementById("New_MTEL").value = '';
            document.getElementById("New_CycleTime").value = '';
            document.getElementById("New_Agent").value = '';
            document.getElementById("C_Name").value = '';
        }

        function List_PID() {   //客戶下拉
            $.ajax({
                url: '0250010001.aspx/List_PID',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#New_PID");
                    $select_elem.chosen("destroy")
                    //$select_elem.empty();
                    //$select_elem.append("<option value=''>" + "請選擇客戶…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.PID + "'>" + obj.BUSINESSNAME + "</option>");
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
        function Show_PID() {     //選顧客後抓資料
            var PID = document.getElementById("New_PID").value;
            //List_PID2(PID);     //子公司選單
            $.ajax({
                url: '0250010001.aspx/Show_PID',
                type: 'POST',
                data: JSON.stringify({ value: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //document.getElementById("Label1").innerHTML = obj.data[0].A;
                    //List_Record(obj.data[0].A);
                    if (obj.data[0].A == "中華電信" || obj.data[0].A == "遠傳" || obj.data[0].A == "德瑪")
                        //document.getElementById("New_T_ID").value = obj.data[0].A;
                        style('New_T_ID', obj.data[0].A);
                    else
                        //document.getElementById("New_T_ID").value = "其他";
                        style('New_T_ID', '其他');
                    //alert(obj.data[0].A);
                    document.getElementById("New_ADDR").value = obj.data[0].B;
                    document.getElementById("New_Name").value = obj.data[0].C;
                    document.getElementById("New_MTEL").value = obj.data[0].D;
                    document.getElementById("C_Name").value = obj.data[0].E;
                    document.getElementById("New_CycleTime").value = obj.data[0].F;
                    Set_Month('0',obj.data[0].F);
                }
            });
        }
        function List_PID2(PID) {    //子公司下拉
            $.ajax({
                url: '0250010001.aspx/List_PID2',
                type: 'POST',
                data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#New_PID2");
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.A + "'>" + obj.B + "</option>");     // 顯示客戶代碼選單
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    //$('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }
        function Show_PID2() {     //選子公司後抓資料
            var PID = document.getElementById("New_PID2").value;
            //List_PID2(PID);     //子公司選單
            $.ajax({
                url: '0250010001.aspx/Show_PID2',
                type: 'POST',
                data: JSON.stringify({ value: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //document.getElementById("Label1").innerHTML = obj.data[0].A;
                    //List_Record(obj.data[0].A);
                    if (obj.data[0].C == "中華電信" || obj.data[0].C == "遠傳" || obj.data[0].C == "德瑪")
                        document.getElementById("New_T_ID").value = obj.data[0].C;
                    else
                        document.getElementById("New_T_ID").value = "其他";
                    document.getElementById("New_ADDR").value = obj.data[0].B;
                    document.getElementById("New_Name").value = obj.data[0].C;
                    document.getElementById("New_MTEL").value = obj.data[0].D;
                }
            });
        }

        function New_Title() {  //存新增維護任務
            var PID = document.getElementById("New_PID").value;
            //var PID2 = document.getElementById("New_PID2").value;
            var T_ID = document.getElementById("New_T_ID").value;
            var ADDR = document.getElementById("New_ADDR").value;
            var Name = document.getElementById("New_Name").value;
            var MTEL = document.getElementById("New_MTEL").value;
            var CycleTime = document.getElementById("New_CycleTime").value;
            var Agent = document.getElementById("New_Agent").value;
            var C_Name = document.getElementById("C_Name").value;
            var Check_1 = document.getElementById("Checkbox1").checked;
            var Check_2 = document.getElementById("Checkbox2").checked;
            var Check_3 = document.getElementById("Checkbox3").checked;
            var Check_4 = document.getElementById("Checkbox4").checked;
            var Check_5 = document.getElementById("Checkbox5").checked;
            var Check_6 = document.getElementById("Checkbox6").checked;
            var Check_7 = document.getElementById("Checkbox7").checked;
            var Check_8 = document.getElementById("Checkbox8").checked;
            var Check_9 = document.getElementById("Checkbox9").checked;
            var Check_10 = document.getElementById("Checkbox10").checked;
            var Check_11 = document.getElementById("Checkbox11").checked;
            var Check_12 = document.getElementById("Checkbox12").checked;
            //alert(Check_1 + "  " + Check_2 + "  " + Check_3 + "  " + Check_4 + "  " + Check_5 + "  " + Check_6 );
            $.ajax({
                url: '0250010001.aspx/New_Title',
                type: 'POST',
                data: JSON.stringify({
                    PID: PID,
                    //PID2: PID2,
                    T_ID: T_ID,
                    ADDR: ADDR,
                    Name: Name,
                    MTEL: MTEL,
                    CycleTime: CycleTime,
                    Agent: Agent,
                    C_Name: C_Name,
                    C_1: Check_1,
                    C_2: Check_2,
                    C_3: Check_3,
                    C_4: Check_4,
                    C_5: Check_5,
                    C_6: Check_6,
                    C_7: Check_7,
                    C_8: Check_8,
                    C_9: Check_9,
                    C_10: Check_10,
                    C_11: Check_11,
                    C_12: Check_12
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        List_Location();
                        window.location = "../0250010001.aspx"
                    }
                    alert(json.status);
                }
            });//*/
        }

        function List_Agent(Team) {
            var $select_elem = $("#New_Agent");
            $.ajax({
                url: '0250010001.aspx/List_Agent',
                type: 'POST',
                data: JSON.stringify({ Team: Team }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇工程師…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_ID + "'>" + obj.Agent_Name + "</option>");
                    });
                }
            });
        }

        function Change_Team() {
            var s = document.getElementById("New_Team");
            var str_value = s.options[s.selectedIndex].value;
            List_Agent(str_value);
        }

        function Set_Month(Flag, value) {
            //alert("Flag = " + Flag + "  value = " + value);
            //var CycleTime = document.getElementById("New_CycleTime").value;
            if (Flag == 1)
                value = document.getElementById("New_CycleTime").value;
            if (value == '0') {
                document.getElementById("Checkbox1").checked = "True";
                document.getElementById("Checkbox2").checked = "True";
                document.getElementById("Checkbox3").checked = "True";
                document.getElementById("Checkbox4").checked = "True";
                document.getElementById("Checkbox5").checked = "True";
                document.getElementById("Checkbox6").checked = "True";
                document.getElementById("Checkbox7").checked = "True";
                document.getElementById("Checkbox8").checked = "True";
                document.getElementById("Checkbox9").checked = "True";
                document.getElementById("Checkbox10").checked = "True";
                document.getElementById("Checkbox11").checked = "True";
                document.getElementById("Checkbox12").checked = "True";
            }
            else if (value == '1') {
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "True";
                document.getElementById("Checkbox3").checked = "";
                document.getElementById("Checkbox4").checked = "True";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "True";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "True";
                document.getElementById("Checkbox9").checked = "";
                document.getElementById("Checkbox10").checked = "True";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "True";
            }
            else if (value == '2') {
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "";
                document.getElementById("Checkbox3").checked = "True";
                document.getElementById("Checkbox4").checked = "";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "True";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "";
                document.getElementById("Checkbox9").checked = "True";
                document.getElementById("Checkbox10").checked = "";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "True";
            }
            else if (value == '3') {
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "";
                document.getElementById("Checkbox3").checked = "";
                document.getElementById("Checkbox4").checked = "";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "True";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "";
                document.getElementById("Checkbox9").checked = "";
                document.getElementById("Checkbox10").checked = "";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "True";
            }
            else if (value == '4') {
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "";
                document.getElementById("Checkbox3").checked = "";
                document.getElementById("Checkbox4").checked = "";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "";
                document.getElementById("Checkbox9").checked = "";
                document.getElementById("Checkbox10").checked = "";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "True";
            }
            else {
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "";
                document.getElementById("Checkbox3").checked = "";
                document.getElementById("Checkbox4").checked = "";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "";
                document.getElementById("Checkbox9").checked = "";
                document.getElementById("Checkbox10").checked = "";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "";
            }   //*/
        }

        //================【下拉選單】 CSS 修改 ================
        function style(Name, value) {
            var $select_elem = $("#" + Name);
            $select_elem.chosen("destroy")
            document.getElementById(Name).value = value;
            $select_elem.chosen({
                width: "100%",
                search_contains: true
            });
            $('.chosen-single').css({ 'background-color': '#ffffbb' });
        }
    </script>
    <style>
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

        #data td:nth-child(8), #data td:nth-child(7), #data td:nth-child(6),
        #data td:nth-child(5), #data td:nth-child(4), #data td:nth-child(3),
        #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }
    </style>

    <!-- ====== Modal ====== -->
    <div class="modal fade" id="data02" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width:  1200px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span>&nbsp;關閉</button>
                    <h2 class="modal-title"><strong>維護任務（新增）</strong></h2>

                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <div style="height: 20px;"></div>
                    <div>
                        <table class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th style="text-align: center" colspan="4">
                                        <span style="font-size: 20px"><strong>維護設定</strong></span>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr style="height: 55px;">
                                    <th style="text-align: center; width: 15%">
                                        <strong>客戶選擇</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <select id="New_PID" name="New_PID" class="form-control" style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" onchange="Show_PID()">
                                            <option value="">請選擇客戶…</option>
                                        </select>
                                    </th>
                                    <!--<th style="text-align: center; width: 15%">
                                        <strong>子公司選擇</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <select id="New_PID2" name="New_PID2" class="form-control" style="width: 100%; Font-Size: 18px;" onchange="Show_PID2()">
                                            <option value="">請選擇子公司…</option>
                                        </select>
                                    </th>
                                </tr>
                                <tr style="height: 55px;">-->
                                    <th style="text-align: center; width: 15%">
                                        <strong>客戶名稱</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <input id="C_Name" class="form-control" value="" maxlength="50" onkeyup=""
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                                    </th>
                                </tr>
                                <tr style="height: 55px;">
                                    <th style="text-align: center; width: 15%">
                                        <strong>維護廠商</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <select id="New_T_ID" name="New_T_ID" class="form-control" style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;">
                                            <option value="">請選擇維護廠商…</option>
                                            <option value="中華電信">中華電信</option>
                                            <option value="遠傳">遠傳</option>
                                            <option value="德瑪">德瑪</option>
                                            <option value="其他">其他</option>
                                        </select>
                                    </th>
                                    <th style="text-align: center; width: 15%">
                                        <strong>維護地址</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <input id="New_ADDR" class="form-control" value="" maxlength="200" onkeyup="cs(this);"
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                                    </th>
                                </tr>
                                <tr style="height: 55px;">
                                    <th style="text-align: center; width: 15%">
                                        <strong>聯絡人</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <input id="New_Name" class="form-control" value="" maxlength="15" onkeyup="cs(this);"
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                                    </th>
                                    <th style="text-align: center; width: 15%">
                                        <strong>聯絡電話</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <input id="New_MTEL" class="form-control" value="" maxlength="25" onkeyup=""
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                                    </th>
                                </tr>
                                
                                <tr style="height: 55px;">
                                    <th style="text-align: center; width: 15%">
                                        <strong>維護週期</strong></th>
                                    <th style="width: 35%">
                                        <select id="New_CycleTime" name="New_CycleTime" class="form-control" onchange="Set_Month('1','4')"
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;">
                                            <option value="">請選擇維護週期…</option>
                                            <option value="0">單月</option>
                                            <option value="1">雙月</option>
                                            <option value="2">每季</option>
                                            <option value="3">半年</option>
                                            <option value="4">每年</option>
                                            <option value="5">不維護</option>
                                        </select>
                                    </th>
                                    <th style="text-align: center;">
                                        <strong>負責工程師</strong>
                                    </th>
                                    <th>
                                        <select id="New_Agent" name="New_Agent" class="form-control" style="width: 100%; Font-Size: 18px; color: #333333;">
                                            <option value="">請選擇工程師…</option>
                                        </select>
                                    </th>
                                </tr>
                                <tr style="height: 55px;">
                                    <th style="text-align: center;">
                                        <strong>維護月份</strong>
                                    </th>
                                </tr>
                                <tr style="height: 55px;">
                                    <td colspan="4"  style="text-align: center;">
                                        <strong>一月</strong>
                                        <input id='Checkbox1' type='checkbox' style='width: 30px; height: 30px;'  />&nbsp;<!--   onclick="CheckFlag();"     -->
                                        <strong>二月</strong>
                                        <input id='Checkbox2' type='checkbox' style='width: 30px; height: 30px;'  />&nbsp;
                                        <strong>三月</strong>
                                        <input id='Checkbox3' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>四月</strong>
                                        <input id='Checkbox4' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>五月</strong>
                                        <input id='Checkbox5' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>六月</strong>
                                        <input id='Checkbox6' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>七月</strong>
                                        <input id='Checkbox7' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>八月</strong>
                                        <input id='Checkbox8' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>九月</strong>
                                        <input id='Checkbox9' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>十月</strong>
                                        <input id='Checkbox10' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>十一月</strong>
                                        <input id='Checkbox11' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>十二月</strong>
                                        <input id='Checkbox12' type='checkbox' style='width: 30px; height: 30px;' />
                                    </td>
                                </tr>
                                <tr>
                                    <th style="text-align: center;" colspan="4">
                                        <button type="button" class="btn btn-success btn-lg" onclick="New_Title();"> <!--      CheckFlag();  -->
                                            <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    </th>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <!--===================================================-->
    <div style="width: 1280px; margin: 10px 20px">
        <h2><strong>維護任務管理&nbsp;&nbsp;
    <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#data02"
        style="Font-Size: 20px;" onclick="Add_New()">
        <span class='glyphicon glyphicon-plus'></span>
        &nbsp;&nbsp;新增維護任務
    </button></strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">編號</th>
                    <th style="text-align: center;">客戶名稱</th>
                    <th style="text-align: center;">維護週期</th>
                    <th style="text-align: center;">維護地址</th>
                    <th style="text-align: center;">維護廠商</th>
                    <th style="text-align: center;">負責工程師</th>
                    <th style="text-align: center;">設定</th>
                    <th style="text-align: center;">啟用</th>
                    <th style="text-align: center;"></th>
                </tr>
            </thead>
        </table>
    </div>
    <script type="text/javascript">
        $.datetimepicker.setLocale('ch');
        $('#New_StartTime,#New_EndTime').datetimepicker({
            datepicker: false,
            useSeconds: false,
            format: 'H:i',
            allowTimes: [
                '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
            ]
        });
    </script>
</asp:Content>
