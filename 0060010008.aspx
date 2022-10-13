<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0060010008.aspx.cs" Inherits="_0060010008" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            List_Agent_Team();  //帶入【部門 】資訊
            style("Select_Agent", "");
            bindTable();
        });

        function bindTable() {
            $.ajax({
                url: '0060010008.aspx/List_Master_DATA',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
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
                        "iDisplayLength": 100,
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
                                { data: "Agent_Team" },
                                {
                                    data: "Agent_LV", render: function (data, type, row, meta) {
                                        if (data == "15") {
                                            return "派工主管";
                                        } else {
                                            return "部門、行政主管"
                                        }
                                    }
                                },
                                { data: "Agent_Name" },
                                { data: "Agent_Mail" },
                                {
                                    data: "SYSID", render: function (data, type, row, meta) {
                                        return "<button id='edit' type='button' class='btn btn-primary btn-lg' data-toggle='modal' data-target='#myModal'>" +
                                            "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>"
                                    }
                                },
                                {
                                    data: "SYSID", render: function (data, type, row, meta) {
                                        return "<button id='delete' type='button' class='btn btn-danger btn-lg' >" +
                                            "<span class='glyphicon glyphicon-remove'></span>&nbsp;刪除</button>"
                                    }
                                }
                        ]
                    });
                    //=====================
                    $('#data tbody').unbind('click').
                      on('click', '#edit', function () {
                          var table = $('#data').DataTable();
                          var SYSID = table.row($(this).parents('tr')).data().SYSID;
                          Load_Agent(SYSID);
                      }).
                      on('click', '#delete', function () {
                          var table = $('#data').DataTable();
                          var SYSID = table.row($(this).parents('tr')).data().SYSID;
                          Delete(SYSID);
                      });
                }
            });
        }

        function Delete(SYSID) {
            if (confirm("確定要刪除該筆資料嗎？")) {
                $.ajax({
                    url: '0060010008.aspx/Delete',
                    type: 'POST',
                    data: JSON.stringify({ SYSID: SYSID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function () {
                        bindTable();
                    }
                });
            }
        };

        //================ 帶入【部門 】資訊 ===============
        function List_Agent_Team() {
            $.ajax({
                url: '0060010008.aspx/List_Agent_Team',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Select_Team");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_Team + "'>" + obj.Agent_Team + "（" + obj.Type + "）" + "</option>");
                    });
                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                }
            });
        };

        function Agent_Team() {
            var team = document.getElementById("Select_Team").value;
            List_Agent_Name(team);
            document.getElementById("txt_Agent_Team").value = team;
            document.getElementById("txt_Agent_Name").value = "";
            document.getElementById("txt_Agent_Mail").value = "";
            document.getElementById("hid_UserID").value = "";
        };

        //================ 帶入【人員 】資訊 ===============
        function List_Agent_Name(Team) {
            $.ajax({
                url: '0060010008.aspx/List_Agent_Name',
                type: 'POST',
                data: JSON.stringify({ Agent_Team: Team }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Select_Agent");
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇通知人員…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_ID + "'>" + obj.Agent_Name + "</option>");
                    });
                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                }
            });
        };

        function Agent_Name() {
            var agent = document.getElementById("Select_Agent").value;
            $.ajax({
                url: '0060010008.aspx/List_Agent',
                type: 'POST',
                data: JSON.stringify({ Agent_ID: agent }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    if (obj.data[0].status == "OK") {
                        document.getElementById("txt_Agent_Name").value = obj.data[0].Agent_Name;
                        document.getElementById("txt_Agent_Mail").value = obj.data[0].Agent_Mail;
                        document.getElementById("hid_UserID").value = obj.data[0].UserID;
                    } else {
                        document.getElementById("txt_Agent_Name").value = "";
                        document.getElementById("txt_Agent_Mail").value = "";
                        document.getElementById("hid_UserID").value = "";
                    }
                }
            });
        };

        //================ 帶入【服務】資訊 ===============
        function Load_Agent(SYSID) {
            style("Select_Team", "");
            List_Agent_Name("");
            document.getElementById("btn_new").style.display = "none";
            document.getElementById("btn_update").style.display = "none";
            document.getElementById("txt_Agent_Team").value = "";
            document.getElementById("txt_Agent_Name").value = "";
            document.getElementById("txt_Agent_Mail").value = "";
            document.getElementById("select_Agent_LV").value = "15";
            $("#txt_hid_id").val(SYSID);
            if (SYSID == '0') {
                document.getElementById("btn_new").style.display = "";
                document.getElementById("txt_title").innerHTML = "通知人員（新增）";
            } else {
                document.getElementById("btn_update").style.display = "";
                document.getElementById("txt_title").innerHTML = "通知人員（修改）";
                $.ajax({
                    url: '0060010008.aspx/Load_Agent',
                    type: 'POST',
                    data: JSON.stringify({
                        SYSID: SYSID,
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        if (obj.data[0].status == "ok") {
                            document.getElementById("txt_Agent_Team").value = obj.data[0].Agent_Team;
                            document.getElementById("txt_Agent_Name").value = obj.data[0].Agent_Name;
                            document.getElementById("txt_Agent_Mail").value = obj.data[0].Agent_Mail;
                            document.getElementById("select_Agent_LV").value = obj.data[0].Agent_LV;
                            document.getElementById("hid_UserID").value = obj.data[0].UserID;
                        } else {
                            alert(obj.data[0].note);
                        }
                    }
                });
            }
        };

        //================ 新增【服務】資訊 ===============
        function New_Agent() {
            document.getElementById("btn_update").disabled = true;
            document.getElementById("btn_new").disabled = true;
            var Flag;
            var Agent_Mail = document.getElementById("txt_Agent_Mail").value.trim();
            var Agent_LV = document.getElementById("select_Agent_LV").value.trim();
            var Agent_Name = document.getElementById("Select_Agent").value.trim();
            $.ajax({
                url: '0060010008.aspx/New_Agent',
                type: 'POST',
                data: JSON.stringify({
                    SYSID: $("#txt_hid_id").val(),
                    UserID: $("#hid_UserID").val(),
                    Agent_LV: Agent_LV.trim(),
                    Agent_Mail: Agent_Mail.trim()
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    List_Agent_Team();
                    bindTable();
                    alert(json.status);
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                },
                error: function () {
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                }
            });
        };

        function style(Name, value) {
            var $select_elem = $("#" + Name);
            $select_elem.chosen("destroy")
            document.getElementById(Name).value = value;
            $select_elem.chosen({
                width: "100%",
                search_contains: true
            });
        }

        function Xin_De() {
            Load_Agent("0");
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


        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1),
        #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 600px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <input id="txt_hid_id" name="txt_hid_id" type="hidden" />
                    <input id="hid_UserID" name="hid_UserID" type="hidden" />
                    <h2 class="modal-title"><strong>
                        <label id="txt_title">通知人員（新增）</label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="table table-bordered table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>通知人員</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>選擇所屬部門</strong>
                                </th>
                                <th style="width: 65%">
                                    <select id="Select_Team" name="Select_Team" class="chosen-select" style="Font-Size: 18px; width: 100%" onchange="Agent_Team()">
                                        <option value="">請選擇所屬部門…</option>
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;">
                                    <strong>選擇通知人員</strong>
                                </th>
                                <th>
                                    <select id="Select_Agent" name="Select_Agent" class="form-control" style="Font-Size: 18px; width: 100%" onchange="Agent_Name()">
                                        <option value="">請選擇通知人員…</option>
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;">
                                    <strong>人員類型</strong>
                                </th>
                                <th>
                                    <select id="select_Agent_LV" name="select_Agent_LV" class="form-control" style="Font-Size: 18px; width: 100%">
                                        <option value="15">派工主管</option>
                                        <option value="10">部門、行政主管</option>
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;">
                                    <strong>所屬部門</strong>
                                </th>
                                <th style="text-align: center;">
                                    <input type="text" id="txt_Agent_Team" name="txt_Agent_Team" class="form-control" placeholder="所屬部門" style="Font-Size: 18px; width: 100%" disabled="disabled" />
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;">
                                    <strong>通知人員</strong>
                                </th>
                                <th style="text-align: center;">
                                    <input type="text" id="txt_Agent_Name" name="txt_Agent_Name" class="form-control" placeholder="通知人員" style="Font-Size: 18px; width: 100%;" disabled="disabled" />
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;">
                                    <strong>電子信箱</strong>
                                </th>
                                <th style="text-align: center;">
                                    <div data-toggle="tooltip" title="必填，不能超過５０個字元，並且要有 '@' 與 ' . '">
                                        <input type="text" id="txt_Agent_Mail" name="txt_Agent_Mail" class="form-control" placeholder="電子信箱" maxlength="50"
                                            style="Font-Size: 18px; width: 100%; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New_Agent()"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="New_Agent()"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
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
    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
        <h2><strong>通知人員管理&nbsp;&nbsp;
    <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#myModal" style="Font-Size: 20px;" onclick="Xin_De()"><span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增通知人員</button></strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">通知部門</th>
                    <th style="text-align: center;">類型</th>
                    <th style="text-align: center;">通知人員</th>
                    <th style="text-align: center;">電子信箱</th>
                    <th style="text-align: center;">修改</th>
                    <th style="text-align: center;">刪除</th>
                </tr>
            </thead>
        </table>
    </div>
</asp:Content>
