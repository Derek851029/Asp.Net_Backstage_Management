<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0010010001.aspx.cs" Inherits="_0010010001" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            Lift_Menu_List("");
            List_Table("65535");
            Service_List();
        });

        function Lift_Menu_List(value) {
            $.ajax({
                url: '0010010001.aspx/Lift_Menu_List',
                type: 'POST',
                data: JSON.stringify({ value: value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    document.getElementById("Left_Menu").innerHTML = doc.d;
                }
            });
        }

        function List_Table(flag) {
            $.ajax({
                url: '0010010001.aspx/List_Table',
                type: 'POST',
                data: JSON.stringify({ flag: flag }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    document.getElementById("table_title").innerHTML = "【" + obj.data[0].Service + "】：" + obj.data[0].ServiceName;
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
                        "aaSorting": [[4, 'desc']],
                        "aLengthMenu": [[10, 25, 50, 100], [10, 25, 50, 100]],
                        "iDisplayLength": 50,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false,
                        }],
                        columns: [
                            { data: "SYSID" },
                            { data: "ServiceName" },
                            { data: "Create_Name" },
                            { data: "txt_Title" },
                            { data: "Create_Time" },
                            { data: "Click" },
                            { data: "txt_button" }
                        ]
                    });
                    //================================================
                    $('#data tbody').unbind('click').
                    on('click', '#look', function () {
                        var table = $('#data').DataTable();
                        var SYSID = table.row($(this).parents('tr')).data().SYSID;
                        Look_Page(SYSID);
                    }).
                     on('click', '#edit', function () {
                         var table = $('#data').DataTable();
                         var SYSID = table.row($(this).parents('tr')).data().SYSID;
                     });
                }
            });
        }

        function New_Page() {
            document.getElementById('btn_new').style.display = "";  //隱藏地址
            document.getElementById('btn_update').style.display = "none";  //隱藏地址
            document.getElementById("txt_hid_id").value = "0";
            document.getElementById("txt_Title").value = "";
            document.getElementById("txt_Content").value = "";
            document.getElementById("txt_Top").innerHTML = "新增文章（新增）";
            document.getElementById("Service").value = "";
            var $select_elem = $("#ServiceName");
            $select_elem.chosen("destroy")
            $select_elem.empty();
            $select_elem.append("<option value=''>請選擇文章項目…</option>");
            $select_elem.chosen(
            {
                width: "100%",
                search_contains: true
            });
            $('.chosen-single').css({ 'background-color': '#ffffbb', 'font-size': '18px' });
        }

        function New_Forum(flag) {
            var id = document.getElementById("ServiceName").value.trim();
            var title = document.getElementById("txt_Title").value.trim();
            var content = document.getElementById("txt_Content").value.trim();
            var sysid = document.getElementById("txt_hid_id").value.trim();
            $.ajax({
                url: '0010010001.aspx/Check_Value',
                type: 'POST',
                data: JSON.stringify({ flag: flag, id: id, sysid: sysid, title: title, content: content }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.flag == "0") {
                        alert(json.status);
                        Lift_Menu_List();
                        List_Table("65535");
                    } else {
                        alert(json.status);
                    }
                }
            });
        }

        function Look_Page(ID) {
            document.getElementById("lab_Service").innerHTML = "";
            document.getElementById("lab_ServiceName").innerHTML = "";
            document.getElementById("lab_Title").innerHTML = "";
            document.getElementById("lab_Content").innerHTML = "";
            $.ajax({
                url: '0010010001.aspx/Look_Page',
                type: 'POST',
                data: JSON.stringify({ ID: ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    document.getElementById("lab_Service").innerHTML = obj.data[0].Service;
                    document.getElementById("lab_ServiceName").innerHTML = obj.data[0].ServiceName;
                    document.getElementById("lab_Create_Name").innerHTML = obj.data[0].Create_Name;
                    document.getElementById("lab_Create_Time").innerHTML = obj.data[0].Create_Time;
                    document.getElementById("lab_Title").innerHTML = obj.data[0].txt_Title;
                    document.getElementById("lab_Content").innerHTML = obj.data[0].txt_Content;
                }
            });
        }

        function search_btn() {
            Lift_Menu_List(document.getElementById("txt_Search").value);
        }
        //================ 帶入【分類 】資訊 ===============
        function Service_List() {
            $.ajax({
                url: '0010010001.aspx/Service_List',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Service");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Service + "'>" + obj.Service + "</option>");
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb', 'font-size': '18px' });
                }
            });
        }

        //================ 帶入【項目 】資訊 ===============
        function ServiceName_List() {
            var str_value = document.getElementById("Service").value;
            if (str_value != "") {
                $.ajax({
                    url: '0010010001.aspx/ServiceName_List',
                    type: 'POST',
                    data: JSON.stringify({ service: str_value }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var json = JSON.parse(doc.d);
                        var $select_elem = $("#ServiceName");
                        $select_elem.chosen("destroy")
                        $select_elem.empty();
                        $select_elem.append("<option value=''>請選擇文章項目…</option>");
                        $.each(json, function (idx, obj) {
                            $select_elem.append("<option value='" + obj.Service_ID + "'>" + obj.ServiceName + "</option>");
                        });
                        $select_elem.chosen(
                        {
                            width: "100%",
                            search_contains: true
                        });
                        $('.chosen-single').css({ 'background-color': '#ffffbb', 'font-size': '18px' });
                    }
                });
            } else {
                var $select_elem = $("#ServiceName");
                $select_elem.chosen("destroy")
                $select_elem.empty();
                $select_elem.append("<option value=''>請選擇文章項目…</option>");
                $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                $('.chosen-single').css({ 'background-color': '#ffffbb', 'font-size': '18px' });
            }
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
            $('.chosen-single').css({ 'background-color': '#ffffbb', 'font-size': '18px' });
        }
    </script>
    <style>
        body {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 18px;
            background-color: #2E3039;
        }

        #main-menu {
            background-color: #2E3039;
        }

        .list-group-item {
            background-color: #2E3039;
            border: none;
        }

        a.list-group-item {
            color: #FFF;
        }

            a.list-group-item:hover,
            a.list-group-item:focus {
                background-color: #EAA333;
            }

            a.list-group-item.active,
            a.list-group-item.active:hover,
            a.list-group-item.active:focus {
                color: #FFF;
                background-color: #EAA333;
                border: none;
            }

        .list-group-item:first-child,
        .list-group-item:last-child {
            border-radius: 0;
        }

        .list-group-level1 .list-group-item {
            padding-left: 30px;
        }

        .list-group-level2 .list-group-item {
            padding-left: 60px;
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

        #data td:nth-child(7), #data td:nth-child(6),
        #data td:nth-child(5), #data td:nth-child(4), #data td:nth-child(3),
        #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="New_Modal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1024px;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <input id="txt_hid_id" name="txt_hid_id" type="hidden" />
                    <h2 class="modal-title"><strong>
                        <label id="txt_Top"></label>
                    </strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-bordered table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>文章內容</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>文章分類</strong>
                                </th>
                                <th style="width: 30%">
                                    <select id="Service" name="Service" class="form-control" onchange="ServiceName_List()">
                                        <option value="">請選擇文章分類…</option>
                                    </select>
                                </th>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>文章項目</strong>
                                </th>
                                <th style="width: 30%">
                                    <select id="ServiceName" name="ServiceName" class="form-control">
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;" colspan="4">
                                    <div align="center" data-toggle="tooltip" title="必填，不能超過５０個字元，並且含有不正確的符號">
                                        <input type="text" class="form-control" id="txt_Title" placeholder="文章標題"
                                            style="width: 98%; background-color: #ffffbb; Font-Size: 18px;" maxlength="50" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; height: 55px;" colspan="4">
                                    <div align="center" data-toggle="tooltip" title="必填，不能超過５００個字元，並且含有不正確的符號">
                                        <textarea id="txt_Content" class="form-control" cols="90" rows="10" placeholder="文章內容"
                                            style="resize: none; background-color: #ffffbb; Font-Size: 18px" maxlength="500" onkeyup="cs(this);"></textarea>
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;" colspan="4">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New_Forum(0)"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增文章</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="New_Forum(1)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改文章</button>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                    <!-- ========================================== -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">關閉</button>
                </div>
            </div>
        </div>
    </div>
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="Look_Modal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1024px;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>瀏覽文章（瀏覽）</strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-bordered table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>文章內容</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 45px;">
                                    <strong>文章分類</strong>
                                </th>
                                <th style="width: 30%">
                                    <label id="lab_Service"></label>
                                </th>
                                <th style="text-align: center; width: 20%; height: 45px;">
                                    <strong>文章項目</strong>
                                </th>
                                <th style="width: 30%">
                                    <label id="lab_ServiceName"></label>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 20%; height: 45px;">
                                    <strong>文章作者</strong>
                                </th>
                                <th style="width: 30%">
                                    <label id="lab_Create_Name"></label>
                                </th>
                                <th style="text-align: center; width: 20%; height: 45px;">
                                    <strong>發佈時間</strong>
                                </th>
                                <th style="width: 30%">
                                    <label id="lab_Create_Time"></label>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 20%; height: 45px;">
                                    <strong>修改人員</strong>
                                </th>
                                <th style="width: 30%">
                                    <label id="lab_Update_Name"></label>
                                </th>
                                <th style="text-align: center; width: 20%; height: 45px;">
                                    <strong>最後修改時間</strong>
                                </th>
                                <th style="width: 30%">
                                    <label id="lab_Update_Time"></label>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;" colspan="1">
                                    <strong>文章標題</strong>
                                </th>
                                <th style="height: 55px;" colspan="3"><strong>
                                    <label id="lab_Title" style="font-size: 22px"></label>
                                </strong>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;" colspan="1">
                                    <strong>文章內容</strong>
                                </th>
                                <th style="height: 55px;" colspan="3">
                                    <pre id="lab_Content" style="font-size: 18px; font-family: Microsoft JhengHei;"></pre>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;" colspan="1">
                                    <strong>附件</strong>
                                </th>
                                <th style="height: 55px;" colspan="3"></th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;" colspan="4">
                                    <button type="button" class="btn btn-default btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-arrow-left"></span>&nbsp;&nbsp;返回</button>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                    <!-- ========================================== -->
                </div>
            </div>
        </div>
    </div>
    <!-- ====== Modal ====== -->
    <div style="display: inline; float: left; width: 15%">
        <table style="width: 100%;">
            <tr>
                <td>
                    <div>
                        <!-- 大頭貼 -->
                        <div style="background-color: #2E3039; text-align: center;">
                            <img src="../images/Icon_001.png" class="img-rounded" style="margin: 10px;" />
                        </div>
                        <!-- 大頭貼 -->
                        <!-- 使用者訊息 -->
                        <div style="background-color: #2E3039; color: #FFF; text-align: center; font-size: 24px;">
                            <label>知識庫系統</label>
                        </div>
                        <div align="center">
                            <input type="text" class="form-control" id="txt_Search" placeholder="搜尋" />
                            <div style="height: 10px"></div>
                            <button type="button" class="btn btn-info" onclick="search_btn();"><span class='glyphicon glyphicon-search'></span>&nbsp;搜尋文章</button>
                            &nbsp;&nbsp;
                           <button type="button" class="btn btn-success " data-toggle="modal" data-target="#New_Modal" onclick="New_Page();"><span class='glyphicon glyphicon-pencil'></span>&nbsp;新增文章</button>
                            <div style="height: 10px"></div>
                        </div>
                        <!-- 使用者訊息 -->
                        <div id="Left_Menu">
                        </div>
                        <!-- 
                        <a href="#sub-menu" class="list-group-item active" data-toggle="collapse"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;Item 1 <span class="badge" style="font-size: 16px">3</span><span class="caret"></span></a>
                        <div class="collapse list-group-level1" id="sub-menu">
                            <a href="#" class="list-group-item" data-parent="#sub-menu">Sub Item 1</a>
                            <a href="#" class="list-group-item" data-parent="#sub-menu">Sub Item 2</a>
                            <a href="#sub-sub-menu" class="list-group-item" data-toggle="collapse" data-parent="#sub-menu">Sub Item 3 <span class="caret"></span></a>
                            <div class="collapse list-group-level2" id="sub-sub-menu">
                                <a href="#" class="list-group-item" data-parent="#sub-sub-menu">Sub Sub Item 1</a>
                                <a href="#" class="list-group-item" data-parent="#sub-sub-menu">Sub Sub Item 2</a>
                                <a href="#" class="list-group-item" data-parent="#sub-sub-menu">Sub Sub Item 3</a>
                            </div>
                        </div>
                            -->
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div style="float: left; background-color: #fff; width: 85%; height: 100%">
        <div style="width: 95%; margin: 10px 10px;">
            <h2>
                <label id="table_title"></label>
            </h2>
            <table id="data" class="display table table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 10%">編號</th>
                        <th style="text-align: center; width: 10%">分類</th>
                        <th style="text-align: center; width: 10%">作者</th>
                        <th style="text-align: center; width: auto">標題</th>
                        <th style="text-align: center; width: 10%">發佈時間</th>
                        <th style="text-align: center; width: 10%">瀏覽次數</th>
                        <th style="text-align: center; width: auto">功能</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
</asp:Content>
