<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0060010010.aspx.cs" Inherits="_0060010010" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            Service_List();  //帶入【服務分類 】資訊
            bindTable();
        });

        function bindTable() {
            $.ajax({
                url: '0060010010.aspx/GetPartnerList',
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
                                { data: "Service" },
                                { data: "ServiceName" },
                                {
                                    data: "UpDateDate", render: function (data, type, row, meta) {
                                        if (data == "0001/01/01 00:00") {
                                            return "";
                                        } else {
                                            return data;
                                        }
                                    }
                                },
                                { data: "UPDATE_NAME" },
                                {
                                    data: "Flag", render: function (data, type, row, meta) {
                                        var checked = 'checked/>'
                                        if (data == '0') {
                                            checked = '/>'
                                        }
                                        return "<div class='checkbox'><label>" +
                                            "<input id='Flag_1' type='checkbox' style='width: 30px; height: 30px;' " + checked +
                                            "</label></div>";
                                    }
                                },
                                {
                                    data: "Open_Flag", render: function (data, type, row, meta) {
                                        var checked = 'checked/>'
                                        if (data == '0') {
                                            checked = '/>'
                                        }
                                        return "<div class='checkbox'><label>" +
                                            "<input id='Flag_2' type='checkbox' style='width: 30px; height: 30px;' " + checked +
                                            "</label></div>";
                                    }
                                },
                                {
                                    data: "Service_ID", render: function (data, type, row, meta) {
                                        return "<button id='Flag_3' type='button' class='btn btn-success btn-lg' data-toggle='modal' data-target='#myModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>"
                                    }
                                }
                        ]
                    });
                    //====================
                    $('#data tbody').unbind('click').
                      on('click', '#Flag_1', function () {
                          var table = $('#data').DataTable();
                          var sys_id = table.row($(this).parents('tr')).data().SYS_ID;
                          var flag = table.row($(this).parents('tr')).data().Flag;
                          Open_Flag(sys_id, flag, '1');
                      }).
                       on('click', '#Flag_2', function () {
                           var table = $('#data').DataTable();
                           var sys_id = table.row($(this).parents('tr')).data().SYS_ID;
                           var flag = table.row($(this).parents('tr')).data().Open_Flag;
                           Open_Flag(sys_id, flag, '2');
                       }).
                       on('click', '#Flag_3', function () {
                           var table = $('#data').DataTable();
                           var flag = table.row($(this).parents('tr')).data().Service_ID;
                           Load_Service(flag);
                       });
                }
            });
        }

        function Open_Flag(SYS_ID, Flag, value) {
            if (Flag == '1') { Flag = '0'; } else { Flag = '1'; }
            $.ajax({
                url: '0060010010.aspx/Open_Flag',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID, Flag: Flag, value: value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                    bindTable();
                }
            });
        };

        //================ 帶入【服務分類 】資訊 ===============
        function Service_List() {
            $.ajax({
                url: '0060010010.aspx/Service_List',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var listItems = "";
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    for (var i = 0; i < obj.data.length; i++) {
                        listItems += "<option value='" + obj.data[i].Service + "'>" + obj.data[i].Service + "</option>";
                    }
                    $('#Service').append(listItems);
                }
            });
        };

        //================ 帶入【服務】資訊 ===============
        function Load_Service(Flag) {
            document.getElementById("btn_new").style.display = "none";
            document.getElementById("btn_update").style.display = "none";
            document.getElementById("Service").value = "";
            document.getElementById("ServiceName").value = "";
            $("#txt_hid_id").val(Flag);
            if (Flag == '0') {
                document.getElementById("btn_new").style.display = "";
                document.getElementById("txt_title").innerHTML = "服務內容（新增）";
            } else {
                document.getElementById("btn_update").style.display = "";
                document.getElementById("txt_title").innerHTML = "服務內容（修改）";
                $.ajax({
                    url: '0060010010.aspx/Load_Service',
                    type: 'POST',
                    data: JSON.stringify({
                        Service_ID: Flag,
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        document.getElementById("Service").value = obj.data[0].Service;
                        document.getElementById("ServiceName").value = obj.data[0].ServiceName;
                    }
                });
            }
        };

        //================ 新增【服務】資訊 ===============
        function New_Service() {
            document.getElementById("btn_update").disabled = true;
            document.getElementById("btn_new").disabled = true;
            $("#Div_Loading").modal();
            var Service = document.getElementById("Service").value;  //服務內容
            var ServiceName = document.getElementById("ServiceName").value;  //服務內容
            var value = $("#txt_hid_id").val();
            $.ajax({
                url: '0060010010.aspx/check_value',
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
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                },
                "error": function (msg) {
                    $("#Div_Loading").modal('hide');
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                }
            });
            bindTable();
        };
        //=======================
        function Xin_De() {
            Load_Service("0");
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

        #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <!-- ====== Loading ====== -->
    <div class="modal fade" id="Div_Loading" role="dialog" data-backdrop="static" data-keyboard="false" style="z-index: 1500">
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
    <!-- ====== Loading ====== -->
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 500px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <input id="txt_hid_id" name="txt_hid_id" type="hidden" />
                    <h2 class="modal-title"><strong>
                        <label id="txt_title">服務內容（新增）</label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>服務內容</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>服務項目</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <select id="Service" name="Service" class="form-control" style="Font-Size: 18px">
                                        <option value="">請選擇服務項目…</option>
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>服務名稱</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <div data-toggle="tooltip" title="必填，不能超過１５個字元">
                                        <input type="text" id="ServiceName" name="ServiceName" class="form-control" placeholder="服務名稱"  maxlength="15"
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
    <h2><strong>&nbsp; &nbsp;服務審核管理&nbsp;&nbsp;
    <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#myModal" style="Font-Size: 20px;" onclick="Xin_De()"><span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增服務</button></strong></h2>
    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">服務項目</th>
                    <th style="text-align: center;">服務名稱</th>
                    <th style="text-align: center;">異動時間</th>
                    <th style="text-align: center;">異動人員</th>
                    <th style="text-align: center;">
                        <div data-toggle="tooltip" data-placement="bottom"
                            title="設定該【服務內容】是否需經過【審核】後才可以做【派工】的動作">
                            審核設定
                        </div>
                    </th>
                    <th style="text-align: center;">
                        <div data-toggle="tooltip" data-placement="bottom"
                            title="設定是否開放該【服務內容】讓【填需求單】的人員可以選取">
                            服務設定
                        </div>
                    </th>
                    <th style="text-align: center;">修改</th>
                </tr>
            </thead>
        </table>
    </div>
</asp:Content>
