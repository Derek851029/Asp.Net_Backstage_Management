<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0010010099.aspx.cs" Inherits="_0010010099" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            List_Table();
            Service_List();
        });

        //================ 帶入【服務分類 】資訊 ===============
        function Service_List() {
            $.ajax({
                url: '0010010099.aspx/Service_List',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_Service");
                    $select_elem.chosen("destroy");
                    $select_elem.empty();
                    $select_elem.append("<option value=''>請選擇分類名稱…</option>");
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
        };

        //================ 帶入【服務分類 】資訊 ===============
        function List_Table() {
            $.ajax({
                url: '0010010099.aspx/List_Table',
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
                        //"aaSorting": [[4, 'desc']],
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
                            { data: "Service_ID" },
                            { data: "Service" },
                            { data: "ServiceName" },
                            { data: "UPDATE_NAME" },
                            { data: "UpDateDate" },
                            {
                                data: "Open_Flag", render: function (data, type, row, meta) {
                                    var a = "<button id='open' type='button' class='btn btn-success btn-lg' >已啟用</button>";
                                    if (data == "0") {
                                        a = "<button id='open' type='button' class='btn btn-lg ' >已停用</button>";
                                    }
                                    return a;
                                }
                            },
                            {
                                data: "Open_Flag", render: function (data, type, row, meta) {
                                    var a = "<button id='edit' type='button' class='btn btn-primary btn-lg' data-toggle='modal' data-target='#myModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>";
                                    return a;
                                }
                            }
                        ]
                    });
                    //================================================
                    $('#data tbody').unbind('click').
                    on('click', '#open', function () {
                        var table = $('#data').DataTable();
                        var ID = table.row($(this).parents('tr')).data().Service_ID;
                        var Service = table.row($(this).parents('tr')).data().Service;
                        var ServiceName = table.row($(this).parents('tr')).data().ServiceName;
                        var Flag = table.row($(this).parents('tr')).data().Open_Flag;
                        Open_Service(ID, Flag, Service, ServiceName);
                    }).
                     on('click', '#edit', function () {
                         var table = $('#data').DataTable();
                         var SYSID = table.row($(this).parents('tr')).data().Service_ID;
                         Load_Service(SYSID);
                     });
                }
            });
        }

        function Load_Service(Flag) {
            document.getElementById("btn_new").style.display = "none";
            document.getElementById("btn_update").style.display = "none";
            style('select_Service', "");
            document.getElementById("Add_Service").value = "";
            document.getElementById("Add_ServiceName").value = "";
            $("#txt_hid_id").val(Flag);
            if (Flag == '0') {
                document.getElementById("btn_new").style.display = "";
                document.getElementById("txt_title").innerHTML = "（新增）";
            } else {
                document.getElementById("btn_update").style.display = "";
                document.getElementById("txt_title").innerHTML = "（修改）";
                $.ajax({
                    url: '0010010099.aspx/Load_Service',
                    type: 'POST',
                    data: JSON.stringify({
                        Service_ID: Flag,
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        style('select_Service', obj.data[0].Service);
                        document.getElementById("Add_Service").value = obj.data[0].Service;
                        document.getElementById("Add_ServiceName").value = obj.data[0].ServiceName;
                    }
                });
            }
        }

        //===========================================

        function Open_Service(ID, Flag, Service, ServiceName) {
            $("#Div_Loading").modal();
            $.ajax({
                url: '0010010099.aspx/Open_Service',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                data: JSON.stringify({ SYSID: ID, Flag: Flag }),
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "0") {
                        List_Table();
                        Service_List();
                        alert("分類【" + Service + "】項目【" + ServiceName + "】" + json.back);
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                },
                error: function () {
                    $("#Div_Loading").modal('hide');
                }
            });
        }

        //================ 新增【服務】資訊 ===============
        function New_Service() {
            $("#myModal").css({ "display": "" });
            $("#Div_Loading").modal();
            var Service = document.getElementById("Add_Service").value;  //服務內容
            var ServiceName = document.getElementById("Add_ServiceName").value;  //服務內容
            var value = $("#txt_hid_id").val();
            $.ajax({
                url: '0010010099.aspx/check_value',
                type: 'POST',
                data: JSON.stringify({
                    Service: Service,
                    Service_ID: value,
                    ServiceName: ServiceName.trim(),
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                    $("#Div_Loading").modal('hide');
                    $("#myModal").css({ "display": "block", "padding-right": "21px" });
                },
                "error": function (msg) {
                    $("#Div_Loading").modal('hide');
                    $("#myModal").css({ "display": "block", "padding-right": "21px" });
                }
            });
            List_Table();
        };

        function change_Service() {
            var team = document.getElementById("select_Service").value;
            document.getElementById("Add_Service").value = team.trim();
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
            $('.chosen-single').css({ 'background-color': '#ffffbb', 'font-size': '18px' });
        }

        //============================================

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
    <!-- ====== Loading ====== -->
    <div class="modal fade" id="Div_Loading" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 350px;">
            <div class="modal-content" style="margin-top: 100%; margin-left: 25%;">
                <div style="text-align: center">
                    <br />
                    <img src="img/ajax-loader.gif" />
                    <h3>Loading...</h3>
                    <br />
                </div>
            </div>
        </div>
    </div>
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 500px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <input id="txt_hid_id" name="txt_hid_id" type="hidden" />
                    <h2 class="modal-title"><strong>分類項目
                        <label id="txt_title"></label>
                    </strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>分類項目</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>分類名稱</strong>
                                </th>
                                <th style="width: 50%">
                                    <select id="select_Service" name="select_Service" class="form-control" onchange="change_Service()">
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>分類名稱</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <div data-toggle="tooltip" title="必填，不能超過１５個字元">
                                        <input type="text" id="Add_Service" name="Add_Service" class="form-control" placeholder="分類名稱" maxlength="15" onkeyup='cs(this);'
                                            style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>項目名稱</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <div data-toggle="tooltip" title="必填，不能超過１５個字元">
                                        <input type="text" id="Add_ServiceName" name="Add_ServiceName" class="form-control" placeholder="項目名稱" maxlength="15" onkeyup='cs(this);'
                                            style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New_Service()"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="New_Service()"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
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
    <!--===================================================-->
    <div style="display: inline; float: left; width: 15%">
        <table style="width: 100%;">
            <tr>
                <td>
                    <div>
                        <!-- 大頭貼 -->
                        <div style="background-color: #2E3039; text-align: center;">
                            <img src="../images/Icon_003.png" class="img-rounded" style="margin: 10px;" />
                        </div>
                        <!-- 大頭貼 -->
                        <!-- 使用者訊息 -->
                        <div style="background-color: #2E3039; color: #FFF; text-align: center; font-size: 24px;">
                            <label>後台管理系統</label>
                        </div>
                        <div align="center">
                            <button type="button" class="btn btn-success btn-lg " data-toggle="modal" data-target="#myModal" onclick="Load_Service(0);"><span class='glyphicon glyphicon-pencil'></span>&nbsp;新增分類項目</button>&nbsp;
                            <div style="height: 10px"></div>
                        </div>
                        <!-- 使用者訊息 -->
                        <div id="Left_Menu">
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div style="float: left; background-color: #fff; width: 85%; height: 100%">
        <div style="width: 95%; margin: 10px 10px;">
            <h2><strong>【分類項目管理】</strong></h2>
            <table id="data" class="display table table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 10%">編號</th>
                        <th style="text-align: center; width: 15%">分類</th>
                        <th style="text-align: center; width: 15%">項目</th>
                        <th style="text-align: center; width: 15%">修改人員</th>
                        <th style="text-align: center; width: 15%">修改時間</th>
                        <th style="text-align: center; width: 15%">狀態</th>
                        <th style="text-align: center; width: 15%">功能</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
</asp:Content>
