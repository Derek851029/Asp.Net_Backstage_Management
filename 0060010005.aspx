<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0060010005.aspx.cs" Inherits="_0060010005" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            bindTable();
            Change_Dispatch();
            Client_Code_Search();       //選客戶
            style('DealingProcess', '');
            style('SelectOpinionType', '');
            style('DropClientCode', '');
            style('SelectOverdueType', '');
            //bindTable_2();
            //ShowTime();
        });

        function bindTable() {
            $.ajax({
                url: '0060010005.aspx/GetCaseList',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data').DataTable({
                        destroy: true,
                        data: eval(doc.d),
                        "oLanguage": {
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
                        "aaSorting":[[0,'desc']],
                        "aLengthMenu": [[10,25, 50, 100], [10,25, 50, 100]],
                        "iDisplayLength": 10,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [                                      // 顯示資料列
                                { data: "SetupTime" },
                                { data: "C_ID2" },
                                { data: "BUSINESSNAME" },
                                { data: "OpinionType" },
                                { data: "Handle_Agent" },
                                { data: "Type" },                                
                                {
                                    data: "Case_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit02' class='btn btn-info btn-lg'>" +
                                "<span class='glyphicon glyphicon-search'></span>&nbsp;查看</button>";
                                    }
                                },
                                {
                                    data: "Case_ID", render: function (data, type, row, meta) {
                                        if (row.Agent_Company != '客服') {
                                            return "";
                                        }
                                        else {
                                            return "<button type='button' id='edit' class='btn btn-primary btn-lg'> " +
                                                //"data-toggle='modal' data-target='#newModal' >" +
                                                "<span class='glyphicon glyphicon-pencil'>" +
                                                "</span>&nbsp;修改</button>";
                                        }
                                    }
                                }
                        ]
                    });
                    $('#data tbody').unbind('click').
                       on('click', '#edit02', function () {
                           var table = $('#data').DataTable();
                           var Case_ID = table.row($(this).parents('tr')).data().Case_ID;
                           //alert(PID + '查看子公司');
                           URL(Case_ID);
                       }).on('click', '#edit', function () {
                           var table = $('#data').DataTable();
                           var Case_ID = table.row($(this).parents('tr')).data().Case_ID;
                           //alert(PID);
                           URL2(Case_ID);
                       });
                    // on('click', '#button', function () {
                    //var table = $('#data').DataTable();
                    //var PID = table.row($(this).parents('tr')).data().PID;
                    //Button(PID);
                    //var ROLE_ID = table.row($(this).parents('tr')).data().ROLE_ID;
                    //var ROLE_NAME = table.row($(this).parents('tr')).data().ROLE_NAME;
                    //document.getElementById("txt_title").innerHTML = '【' + ROLE_NAME + '】選單設定';
                    //List_PROGLIST(ROLE_ID);
                    //}).
                }
            });
        }

        function Client_Code_Search() {     //選客戶
            $.ajax({
                url: '0060010005.aspx/Client_Code_Search',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropClientCode");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.B+ "'>【" + obj.B + "】" + obj.A + "</option>");
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ });
                }
            });
        }
        function URL(Case_ID) {
            var newwin = window.open(); //另開視窗用 要放 $.ajax({ 前
            $.ajax({
                url: '0060010005.aspx/URL',
                type: 'POST',
                data: JSON.stringify({ Case_ID: Case_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.type == "ok") {
                        newwin.location = json.status;  //另開視窗指令
                        //window.location = json.status;
                    } else {
                        alert(json.status);
                    }
                }
            });
        }
        function URL2(Case_ID) {
            var newwin = window.open(); //另開視窗用 要放 $.ajax({ 前
            $.ajax({
                url: '0060010005.aspx/URL2',
                type: 'POST',
                data: JSON.stringify({ Case_ID: Case_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.type == "ok") {
                        newwin.location = json.status;  //另開視窗指令
                        //window.location = json.status;
                    } else {
                        alert(json.status);
                    }
                }
            });
        }
        function Change_Dispatch() {
            //var value = document.getElementById("Chose_Company").value;
            var value = "Engineer";
            $.ajax({
                url: '0030010099.aspx/List_Dispatch_Name',
                type: 'POST',
                data: JSON.stringify({ value: value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Dispatch_Name");     //派公人員選項
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇派工人員…" + "</option>");
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
                    //$('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        function Search() {            // 時間查案件
            var start = document.getElementById("datetimepicker01").value;
            var end = document.getElementById("datetimepicker02").value;
            var A_N = document.getElementById("Dispatch_Name").value;
            var D_P = document.getElementById("DealingProcess").value;
            var S_OC = document.getElementById("SelectOContent").value;
            var S_B_Name = document.getElementById("Search_B_Name").value;
            var S_OT = document.getElementById("SelectOpinionType").value;
            var PID = document.getElementById("DropClientCode").value;
            var Overdue_Type = document.getElementById("SelectOverdueType").value;
            //alert("S_OC = " + S_OC);
            $.ajax({
                url: '0060010005.aspx/SearchCase',
                type: 'POST',
                data: JSON.stringify({
                    start: start,
                    end: end,
                    A_N: A_N,
                    D_P: D_P,
                    S_OC: S_OC,
                    S_OT: S_OT,
                    PID: PID,
                    Overdue_Type: Overdue_Type,
                    S_B_Name: S_B_Name
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data').DataTable({
                        destroy: true,
                        data: eval(doc.d),
                        "oLanguage": {
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
                        "aaSorting": [[0, 'desc']],
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [                                      // 顯示資料列
                                { data: "SetupTime" },
                                { data: "C_ID2" },
                                { data: "BUSINESSNAME" },
                                { data: "OpinionType" },
                                { data: "Handle_Agent" },
                                { data: "Type" },
                                {
                                    data: "Case_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit02' class='btn btn-info btn-lg'>" +
                                "<span class='glyphicon glyphicon-search'></span>&nbsp;查看</button>";
                                    }
                                },
                                {
                                    data: "Case_ID", render: function (data, type, row, meta) {
                                        if (row.Agent_Company != '客服') {
                                            return "";
                                        }
                                        else {
                                            return "<button type='button' id='edit' class='btn btn-primary btn-lg' " +
                                                //"data-toggle='modal' data-target='#newModal' >" +
                                                "<span class='glyphicon glyphicon-pencil'>" +
                                                "</span>&nbsp;修改</button>";
                                        }
                                    }
                                 }

                        ]
                    });
                    $('#data tbody').unbind('click').
                       on('click', '#edit02', function () {
                           var table = $('#data').DataTable();
                           var Case_ID = table.row($(this).parents('tr')).data().Case_ID;
                           //alert(PID + '查看子公司');
                           URL(Case_ID);
                       }).on('click', '#edit', function () {
                           var table = $('#data').DataTable();
                           var Case_ID = table.row($(this).parents('tr')).data().Case_ID;
                           //alert(PID);
                           URL2(Case_ID);
                       });
                }
            });
        }

        function ShowTime() {                               //自動抓現在時間(實行指令時)
            var NowDate = new Date();
            var h = NowDate.getHours();
            var m = NowDate.getMinutes();
            var s = NowDate.getSeconds();
            var y = NowDate.getFullYear();
            var mon = NowDate.getMonth() + 1;
            var d = NowDate.getDate();
            <%--if (mon < 10) {
                if (d < 10) {
                    if (h < 10) {
                        document.getElementById('LoginTime').value = y + "/0" + mon + "/0" + d + " " + h + ":" + m;
                    }
                } else { document.getElementById('LoginTime').value = y + "/0" + mon + "/" + d + " " + h + ":" + m; }
            } else {
                if (d < 10) {
                    document.getElementById('LoginTime').value = y + "/" + mon + "/0" + d + " " + h + ":" + m;
                } else { document.getElementById('LoginTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m; }
                   }--%>
            document.getElementById('LoginTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
            //document.getElementById('EstimatedFinishTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
        }

        function List_PROGLIST(ROLE_ID) {
            $.ajax({
                url: '0060010005.aspx/List_PROGLIST',
                type: 'POST',
                data: JSON.stringify({ ROLE_ID: ROLE_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    if (obj.data[0].TREE_ID == "NULL") {
                        alert("查無此權限代碼，，請詢問管理人員，謝謝。");
                        return;
                    }
                    var table = $('#data2').DataTable({
                        destroy: true,
                        data: eval(doc.d),
                        "oLanguage": {
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
                        "aLengthMenu": [[25, 50, 100], [25, 50, 100]],
                        "iDisplayLength": 25,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                                { data: "TREE_ID" },
                                { data: "M_TREE_NAME" },
                                { data: "TREE_NAME" },
                                { data: "Agent_Name" },
                                { data: "UpDateDate" },
                                {
                                    data: "NowStatus", render: function (data, type, row, meta) {
                                        var checked = 'checked/>'
                                        if (data == '0') {
                                            checked = '/>'
                                        }
                                        return "<div class='checkbox'><label>" +
                                            "<input type='checkbox' style='width: 30px; height: 30px;' id=check " +
                                            checked + "</label></div>";
                                    }
                                }]
                    });
                    //================================

                    $('#data2 tbody').unbind('click').
                        on('click', '#check', function () {
                            var table = $('#data2').DataTable();
                            var Flag = table.row($(this).parents('tr')).data().NowStatus;
                            var TREE_ID = table.row($(this).parents('tr')).data().TREE_ID;
                            //Check(Flag, TREE_ID, ROLE_ID.toString());
                        });
                }
            });
        }

        function Check(Flag, TREE_ID, ROLE_ID) {
            $.ajax({
                //url: '0060010005.aspx/Check_Menu',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    TREE_ID: TREE_ID,
                    ROLE_ID: ROLE_ID,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                }
            });
            List_PROGLIST(ROLE_ID);
        }
        //==============================
        function Xin_De() {     //按新增客戶資料後
            Load_Modal("0");
            //alert('新增');
        }

        function Load_Modal(PID) {                                          // 讀資料
            //alert(PID);
            if (PID == 0) {
                //alert('檢查中1');
                document.getElementById("btn_new").style.display = "";
                document.getElementById("btn_update").style.display = "none";
                document.getElementById("title_modal").innerHTML = '客戶資料（新增）';
            } else {
                //alert('檢查中2');
                //document.getElementById("txt_ROLE_ID").disabled = true;
                document.getElementById("btn_update").style.display = "";                               //顯示修改鈕
                document.getElementById("btn_new").style.display = "none";                          //隱藏新增鈕
                document.getElementById("title_modal").innerHTML = '客戶資料（修改）';
                Load_Data(PID);
            }   //else 結束
        }

        // 預定修改執行部分
        

        function New() {
            document.getElementById("title_modal").innerHTML = '指定條件查詢';
            //document.getElementById("datetimepicker01").value = "";
            //document.getElementById("datetimepicker02").value = "";
            //style('Dispatch_Name', '');
            //style('DealingProcess', '');
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
            $('.chosen-single').css({  });
        }
        //==================
    </script>
    <style>
        body
        {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 18px;
        }

        thead th
        {
            background-color: #666666;
            color: white;
        }

        tr td:first-child,
        tr th:first-child
        {
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }

        tr td:last-child,
        tr th:last-child
        {
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
        }

        #data2 td:nth-child(6), #data2 td:nth-child(5), #data2 td:nth-child(4),
        #data2 td:nth-child(3), #data2 td:nth-child(2), #data2 td:nth-child(1),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5)
        {
            text-align: center;
        }
    </style>

    <!-- ====== 隱藏式 查詢表 ====== -->
    <div class="modal fade" id="newModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1100px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="title_modal"></label></strong></h2>
                </div>
                <div class="modal-body">
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>查詢條件</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr style="height: 55px;">
                                <th style="text-align: center; width: 15%">
                                    <strong>起點時間</strong>
                                </th>
                                <td style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01"  placeholder=""  />
                                    </div>
                                </td> 
                                <td style="text-align: center; width: 15%">
                                    <strong>終點時間</strong>
                                </td>
                                <td style="width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker02" name="datetimepicker02" />
                                    </div>
                                </td>
                            </tr>                            
                            <tr>
                                <th style="text-align: center; width: 15%">
                                    <strong>選擇客戶</strong>
                                </th>
                                <th style="width: 35%">
                                    <div data-toggle="tooltip" title="" style="width: 100%">
                                        <select id="DropClientCode" name="DropClientCode" class="chosen-select" onchange="">
                                            <option value="">請選擇客戶…</option>
                                        </select>
                                    </div>
                                </th>
                                <td style="text-align: center; width: 15%">
                                    <strong>查詢客戶名稱</strong>
                                </td>
                                <td style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="Search_B_Name" name="Search_B_Name" maxlength="" onkeyup="" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%">
                                    <strong>逾期類別</strong>
                                </th>                                
                                <th style="width: 35%">
                                    <select id="SelectOverdueType" name="SelectOverdueType" class="chosen-select" onchange="">
                                        <option value="">請選擇逾期類別…</option>
                                        <!--<option value="0">全類別</option>-->
                                        <option value="1">尚未完成</option>
                                        <option value="2">逾期完成</option>
                                        <option value="3">(補單)假日補單</option>
                                        <option value="4">(補單)未準時登記</option>
                                        <option value="5">(補單)其它原因</option>
                                    </select>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%">
                                    <strong>意見類型</strong>
                                </th>
                                <th style="width: 35%">
                                    <select id="SelectOpinionType" name="SelectOpinionType" class="chosen-select" onchange="">
                                        <option value="">請選擇意見類型…</option>
                                        <option value="故障報修(到場)">故障報修(到場)</option>
                                        <option value="故障報修(遠端)">故障報修(遠端)</option>
                                        <option value="軟體修改(到場)">軟體修改(到場)</option>
                                        <option value="軟體修改(遠端)">軟體修改(遠端)</option>
                                        <option value="技術諮詢">技術諮詢</option>
                                        <option value="其他服務">其他服務</option>
                                        <option value="保固">保固</option>
                                        <option value="租約">租約</option>
                                        <option value="定期維護">定期維護</option>
                                        <option value="測試">測試</option>
                                        <option value="專案">專案</option>
                                        <option value="設備擴充">設備擴充</option>
                                        <option value="駐點服務">駐點服務</option>
                                    </select>
                                </th>
                                <td style="text-align: center; width: 15%">
                                    <strong>查詢意見內容</strong>
                                </td>
                                <td style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="SelectOContent" name="SelectOContent" maxlength="" onkeyup="" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%">
                                    <strong>派工人員</strong>
                                </th>
                                <th style="width: 35%">
                                    <select id="Dispatch_Name" name="Dispatch_Name" class="chosen-select" onchange="">
                                        <option value="">選擇派工人員…</option>
                                    </select>
                                </th>
                                <td style="text-align: center; width: 15%">
                                    <strong>處理狀態</strong>
                                </td>
                                <th style="width: 35%">
                                    <select id="DealingProcess" name="DealingProcess" class="chosen-select" onchange="">
                                        <option value="">選擇處理狀態…</option>
                                        <option value="未到點">未到點</option>
                                        <option value="處理中">處理中</option>
                                        <option value="已結案">已結案</option>
                                        <option value="已結案已簽核">已結案已簽核</option>
                                    </select>
                                </th>
                            </tr>
                            <tr>
                                <td style="text-align: center; width: 50%" colspan="2">
                                    <button id="Button1" type="button" onclick="Search();" class="btn btn-success btn-lg " data-dismiss="modal"><span class="glyphicon glyphicon-search"></span>尋找&nbsp;&nbsp;</button>        
                                </td>
                                <td style="text-align: center; width: 50%" colspan="2">
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span>&nbsp;取消</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <!--====================客戶資料維護========================
    <div class="table-responsive" style="text-align: center; width: 95%; margin: 10px 20px">
        <h2><strong>案件資料查詢&nbsp; &nbsp;
        </strong></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="5">
                        <span style="font-size: 20px"><strong>查詢時間選擇</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>起點時間</strong>
                    </th>
                    <td style="width: 30%">
                        <div style="float: left" data-toggle="tooltip" title="">
                            <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01"  />
                        </div>
                    </td>
                    <td style="text-align: center; width: 15%">
                        <strong>終點時間</strong>     
                    </td>
                    <td style="width: 30%">
                        <div style="float: left" data-toggle="tooltip" title="">
                            <input type="text" class="form-control" id="datetimepicker02" name="datetimepicker01"  />
                        </div>
                    </td>                    
                </tr>
                <tr>
                    <th style="text-align: center; width: 15%">
                        <strong>派工人員</strong>
                    </th>
                    <th style="width: 35%">
                        <select id="Dispatch_Name" name="Dispatch_Name" class="chosen-select" onchange="">
                            <option value="">選擇派工人員…</option>
                        </select>
                    </th>
                    <td style="text-align: center; width: 15%">
                        <strong>處理狀態</strong>
                    </td>
                    <th>
                        <select id="DealingProcess" name="DealingProcess" class="chosen-select" onchange="">
                                <option value="">選擇緊急程度…</option>
                                <option value="未到點">未到點</option>
                                <option value="處理中">處理中</option>
                                <option value="已結案">已結案</option>
                                <option value="已結案已簽核">已結案已簽核</option>
                            </select>
                    </th>
                </tr>                
            </tbody>
        </table>
    </div>
            <!-- =========== Modal content =========== -->


        <script>
            $.datetimepicker.setLocale('ch');
            $('#datetimepicker01').datetimepicker({
                allowTimes: [
 /*                  '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'  //*/
                ]   
            });

            $('#datetimepicker02').datetimepicker({
               allowTimes: [
/*                     '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'  //*/
                ]   
            });            

            $(function () {
                $('.chosen-select').chosen();
                $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
                //$('.chosen-single').css({ 'background-color': '#ffffbb' });
            });
        </script>

    


    <div class="table-responsive" style="width: 95%; margin: 10px 20px">
        <h2><strong>案件資料清單&nbsp; &nbsp;
                <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#newModal" style="Font-Size: 20px;" onclick="New()">
                    <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;指定查詢</button>
        </strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>                    
                    <th style="text-align: center; width: 10%;">登錄日期</th>
                    <th style="text-align: center; width: 15%;">案件編號</th>
                    <th style="text-align: center; width: 17.5%">客戶名稱</th>
                    <th style="text-align: center; width: 10%">意見類別</th>
                    <th style="text-align: center; width: 10%">派工人員</th>
                    <th style="text-align: center; width: 10%">案件狀態</th>
                    <th style="text-align: center; width: 10%">詳情</th>
                    <th style="text-align: center; width: 10%">修改</th>
                </tr>
            </thead>
        </table>
    </div>

    


</asp:Content>
