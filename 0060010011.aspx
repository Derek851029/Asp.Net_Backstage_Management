<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0060010011.aspx.cs" Inherits="_0060010011" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            List_Agent_Team();
            bindTable();
        });

        function bindTable() {
            $.ajax({
                url: '0060010011.aspx/List_DataCar',
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
                                { data: "Agent_Name" },
                                { data: "CarName" },
                                { data: "CarNumber" },
                                {
                                    data: "SYS_ID", render: function (data, type, row, meta) {
                                        return "<button id='load' type='button' class='btn btn-primary btn-lg' data-toggle='modal' data-target='#myModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>"
                                    }
                                }, {
                                    data: "SYS_ID", render: function (data, type, row, meta) {
                                        return "<button id='delete' type='button' class='btn btn-danger btn-lg' >" +
                                            "<span class='glyphicon glyphicon-remove'></span>&nbsp;刪除</button>"
                                    }
                                }
                        ]
                    });
                    //===============================
                    $('#data tbody').unbind('click').
                      on('click', '#load', function () {
                          var table = $('#data').DataTable();
                          var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                          Load_Car(SYS_ID);
                      }).
                      on('click', '#delete', function () {
                          var table = $('#data').DataTable();
                          var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                          Delete(SYS_ID);
                      });
                }
            });
        }

        function Delete(SYS_ID) {
            if (confirm("確定要刪除該筆資料嗎？")) {
                $.ajax({
                    url: '0060010011.aspx/Delete',
                    type: 'POST',
                    data: JSON.stringify({ SYS_ID: SYS_ID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function () {
                        alert("刪除完成！");
                        bindTable();
                    }
                });
            }
        };

        //================ 帶入【部門 】資訊 ===============
        function List_Agent_Team() {
            $.ajax({
                url: '0060010011.aspx/List_Agent_Team',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    $('#Select_Team').append().empty();
                    var listItems = "<option value=''>請選擇所屬部門…</option>";
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    for (var i = 0; i < obj.data.length; i++) {
                        listItems += "<option value='" + obj.data[i].Agent_Team + "'>" + obj.data[i].Agent_Team + "</option>";
                    }
                    $('#Select_Team').append(listItems);
                }
            });
        };

        function Agent_Team() {
            var team = document.getElementById("Select_Team").value;
            document.getElementById("txt_Agent_Team").value = team.trim();
        };

        //================ 帶入【服務】資訊 ===============
        function Load_Car(SYS_ID) {
            document.getElementById("btn_new").style.display = "none";
            document.getElementById("btn_update").style.display = "none";
            document.getElementById("Select_Team").value = "";
            document.getElementById("txt_Agent_Team").value = "";
            document.getElementById("txt_Agent_Name").value = "";
            document.getElementById("txt_CarName").value = "公用車";
            document.getElementById("txt_CarNumber").value = "";
            $("#txt_hid_id").val(SYS_ID);
            if (SYS_ID == '0') {
                document.getElementById("btn_new").style.display = "";
                document.getElementById("txt_title").innerHTML = "服務車輛（新增）";
            } else {
                document.getElementById("btn_update").style.display = "";
                document.getElementById("txt_title").innerHTML = "服務車輛（修改）";
                $.ajax({
                    url: '0060010011.aspx/Load_Car',
                    type: 'POST',
                    data: JSON.stringify({
                        SYS_ID: SYS_ID,
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        document.getElementById("Select_Team").value = obj.data[0].Agent_Team;
                        document.getElementById("txt_Agent_Team").value = obj.data[0].Agent_Team;
                        document.getElementById("txt_Agent_Name").value = obj.data[0].Agent_Name;
                        document.getElementById("txt_CarName").value = obj.data[0].CarName;
                        document.getElementById("txt_CarNumber").value = obj.data[0].CarNumber;
                    }
                });
            }
        };

        //================ 新增【服務】資訊 ===============
        function New_Car() {
            document.getElementById("btn_update").disabled = true;
            document.getElementById("btn_new").disabled = true;
            var Flag;
            var Agent_Team = document.getElementById("txt_Agent_Team").value.trim();
            var Agent_Name = document.getElementById("txt_Agent_Name").value.trim();
            var CarName = document.getElementById("txt_CarName").value.trim();
            var CarNumber = document.getElementById("txt_CarNumber").value.trim();
            $.ajax({
                url: '0060010011.aspx/New_Car',
                type: 'POST',
                data: JSON.stringify({
                    SYS_ID: $("#txt_hid_id").val(),
                    Agent_Team: Agent_Team.trim(),
                    Agent_Name: Agent_Name.trim(),
                    CarName: CarName.trim(),
                    CarNumber: CarNumber.trim()
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                    List_Agent_Team();
                    bindTable();
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                },
                error: function () {
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                }
            });
        };

        function Xin_De() {
            Load_Car("0");
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
        <div class="modal-dialog" style="width: 500px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <input id="txt_hid_id" name="txt_hid_id" type="hidden" />
                    <h2 class="modal-title"><strong>
                        <label id="txt_title">服務車輛（新增）</label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>服務車輛</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>選擇所屬部門</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <select id="Select_Team" name="Select_Team" class="form-control" style="Font-Size: 18px; width: 100%" onchange="Agent_Team()">
                                        <option value="">請選擇所屬部門…</option>
                                    </select>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>所屬部門</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <div data-toggle="tooltip" title="必填，不能超過１５個字元">
                                        <input type="text" id="txt_Agent_Team" name="txt_Agent_Team" class="form-control" placeholder="所屬部門" maxlength="15"
                                            style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>所屬人員</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <div data-toggle="tooltip" title="必填，不能超過５個字元">
                                        <input type="text" id="txt_Agent_Name" name="txt_Agent_Name" class="form-control" placeholder="所屬人員" maxlength="5"
                                            style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>車輛分類</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <select id="txt_CarName" name="txt_CarName" class="form-control" style="Font-Size: 18px; width: 100%">
                                        <option value="公用車">公用車</option>
                                        <option value="私用車">私用車</option>
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>車牌號碼</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <div data-toggle="tooltip" title="必填，不能超過１５個字元，格式為【XXX-XXX】">
                                        <input type="text" id="txt_CarNumber" name="txt_CarNumber" class="form-control" placeholder="XXX-XXX" maxlength="15"
                                            style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New_Car()"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="New_Car()"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
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
        <h2><strong>服務車輛管理&nbsp;&nbsp;
    <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#myModal" style="Font-Size: 20px;" onclick="Xin_De()"><span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增服務車輛</button></strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">所屬部門</th>
                    <th style="text-align: center;">所屬人員</th>
                    <th style="text-align: center;">車輛分類</th>
                    <th style="text-align: center;">車牌號碼</th>
                    <th style="text-align: center;">修改</th>
                    <th style="text-align: center;">刪除</th>
                </tr>
            </thead>
        </table>
    </div>
</asp:Content>
