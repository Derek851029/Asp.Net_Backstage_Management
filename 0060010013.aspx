<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0060010013.aspx.cs" Inherits="_0060010013" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            List_Service();
            bindTable();
        });

        function bindTable() {
            $.ajax({
                url: '0060010013.aspx/List_HRM2_Location',
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
                                { data: "SYS_ID" },
                                { data: "Name" },
                                { data: "Location" },
                                { data: "Postcode" },
                                { data: "Address" },
                                { data: "TEL" },
                                { data: "Location_Flag" },
                                {
                                    data: "SYS_ID", render: function (data, type, row, meta) {
                                        return "<button id='edit' type='button' class='btn btn-primary btn-lg' data-toggle='modal' data-target='#myModal'>" +
                                            "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>"
                                    }
                                },
                                {
                                    data: "SYS_ID", render: function (data, type, row, meta) {
                                        return "<button id='delete' type='button' class='btn btn-danger btn-lg' >" +
                                            "<span class='glyphicon glyphicon-remove'></span>&nbsp;刪除</button>"
                                    }
                                }
                        ]
                    });
                    //============================
                    $('#data tbody').unbind('click').
                     on('click', '#edit', function () {
                         var table = $('#data').DataTable();
                         var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                         Load_Location(SYS_ID);
                     }).
                     on('click', '#delete', function () {
                         var table = $('#data').DataTable();
                         var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                         Delete(SYS_ID);
                     });
                    //============================
                }
            });
        }

        //================ 帶入【服務】資訊 ===============
        function List_Service() {
            $.ajax({
                url: '0060010013.aspx/List_Service',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_Service");
                    $select_elem.empty();
                    $select_elem.append("<option value=''>選擇所屬服務");
                    $.each(json, function (idx, obj) {
                        var value = obj.Service_ID;
                        if (obj.Service == '醫療') {
                            value = '39';
                        }
                        $select_elem.append("<option value='" + value + "'>" + "（" + obj.Service + "）" + obj.ServiceName + "</option>");
                    });
                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                }
            });
        };

        //================ 刪除【單位地點】資訊 ===============
        function Delete(SYS_ID) {
            if (confirm("確定要刪除該筆資料嗎？")) {
                $.ajax({
                    url: '0060010013.aspx/Delete',
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

        //================ 帶入【服務】資訊 ===============
        function Load_Location(Flag) {
            document.getElementById("btn_new").style.display = "none";
            document.getElementById("btn_update").style.display = "none";
            document.getElementById("txt_Name").value = "";
            document.getElementById("txt_Location").value = "";
            document.getElementById("txt_Postcode").value = "";
            document.getElementById("txt_Address").value = "";
            document.getElementById("txt_TEL").value = "";
            document.getElementById("txt_Location_Flag").value = "";
            ChangeSelect("select_Service", "");

            $("#txt_hid_id").val(Flag);
            if (Flag == '0') {
                document.getElementById("btn_new").style.display = "";
                document.getElementById("txt_title").innerHTML = "政府單位地點（新增）";
            } else {
                document.getElementById("btn_update").style.display = "";
                document.getElementById("txt_title").innerHTML = "政府單位地點（修改）";
                $.ajax({
                    url: '0060010013.aspx/Load_HRM2_Location',
                    type: 'POST',
                    data: JSON.stringify({
                        SYS_ID: Flag,
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        document.getElementById("txt_Name").value = obj.data[0].Name;
                        ChangeSelect("select_Service", obj.data[0].Type);
                        document.getElementById("txt_Location").value = obj.data[0].Location;
                        document.getElementById("txt_Postcode").value = obj.data[0].Postcode;
                        document.getElementById("txt_Address").value = obj.data[0].Address;
                        document.getElementById("txt_TEL").value = obj.data[0].TEL;
                        document.getElementById("txt_Location_Flag").value = obj.data[0].Location_Flag;
                    }
                });
            }
        };

        //================ ==========================
        function ChangeSelect(ID, Value) {
            var str = "#" + ID;
            var $select_elem = $(str);
            $select_elem.chosen("destroy")
            document.getElementById(ID).value = Value;
            $select_elem.chosen({
                width: "100%",
                search_contains: true
            });
        };

        //================ 新增【服務】資訊 ===============
        function New_Car() {
            var Flag;
            var Name = document.getElementById("txt_Name").value.trim();
            var Type = document.getElementById("select_Service").value.trim();
            var Location = document.getElementById("txt_Location").value.trim();
            var Postcode = document.getElementById("txt_Postcode").value.trim();
            var Address = document.getElementById("txt_Address").value.trim();
            var TEL = document.getElementById("txt_TEL").value.trim();
            var Location_Flag = document.getElementById("txt_Location_Flag").value.trim();

            $.ajax({
                url: '0060010013.aspx/New_Location',
                type: 'POST',
                data: JSON.stringify({
                    SYS_ID: $("#txt_hid_id").val(),
                    Type: Type,
                    Name: Name,
                    Location: Location,
                    Postcode: Postcode,
                    Address: Address,
                    TEL: TEL,
                    Location_Flag: Location_Flag
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                    bindTable();
                }
            });
        };
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

        #data td:nth-child(8), #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5),
        #data td:nth-child(4), #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1),
        #data th:nth-child(5) {
            text-align: center;
        }
    </style>

    <!-- ====== Modal ====== -->
    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 750px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <input id="txt_hid_id" name="txt_hid_id" type="hidden" />
                    <h2 class="modal-title"><strong>
                        <label id="txt_title">政府單位地點（新增）</label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>政府單位地點</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>單位名稱</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div data-toggle="tooltip" title="必填，不能超過３０個字元">
                                        <input type="text" id="txt_Name" name="txt_Name" class="form-control" placeholder="單位名稱" maxlength="30" onkeyup="cs(this);"
                                            style="Font-Size: 18px; width: 100%; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>所屬服務</strong>
                                </th>
                                <th style="width: 65%">
                                    <div data-toggle="tooltip" title="必選">
                                        <select id="select_Service" name="select_Service" style="Font-Size: 18px">
                                            <option value="">選擇所屬服務</option>
                                        </select>
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>區域名稱</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div data-toggle="tooltip" title="不能超過３０個字元">
                                        <input type="text" id="txt_Location" name="txt_Location" class="form-control" placeholder="區域名稱" maxlength="30" style="Font-Size: 18px; width: 100%" onkeyup="cs(this);" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>郵遞區號（五碼）</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div data-toggle="tooltip" title="必填，只能輸入五碼郵遞區號">
                                        <input type="text" id="txt_Postcode" name="txt_Postcode" class="form-control" placeholder="郵遞區號（五碼）" maxlength="5" onkeyup="int(this);"
                                            style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>地址</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div data-toggle="tooltip" title="必填，不能超過１００個字元">
                                        <input type="text" id="txt_Address" name="txt_Address" class="form-control" placeholder="地址" maxlength="100" onkeyup="cs(this);"
                                            style="Font-Size: 18px; width: 100%; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>電話</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div data-toggle="tooltip" title="不能超過２０個字元，格式為【12-123#123】或【12-123】">
                                        <input type="text" id="txt_TEL" name="txt_TEL" class="form-control" placeholder="01-234567#789" maxlength="20" style="Font-Size: 18px;" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>所屬區域</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div data-toggle="tooltip" title="必選">
                                        <select id="txt_Location_Flag" name="txt_Location_Flag" class="form-control" style="Font-Size: 18px; width: 50%">
                                            <option value="">請選擇所屬區域</option>
                                            <option value="北北基">北北基</option>
                                            <option value="桃竹苗">桃竹苗</option>
                                            <option value="中彰投">中彰投</option>
                                            <option value="雲嘉南">雲嘉南</option>
                                            <option value="高高屏">高高屏</option>
                                            <option value="宜花東">宜花東</option>
                                        </select>
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New_Car()">
                                        <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="New_Car()">
                                        <span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
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
        <h2><strong>政府單位地點管理&nbsp;&nbsp;
    <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#myModal" style="Font-Size: 20px;" onclick="Load_Location(0)">
        <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增政府單位地點</button></strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center; width: 10%">編號</th>
                    <th style="text-align: center; width: 15%">單位名稱</th>
                    <th style="text-align: center; width: 15%">區域名稱</th>
                    <th style="text-align: center; width: 10%">郵遞區號（五碼）</th>
                    <th style="text-align: center; width: 20%">地址</th>
                    <th style="text-align: center; width: 10%">電話</th>
                    <th style="text-align: center; width: 10%">所屬區域</th>
                    <th style="text-align: center; width: 5%">修改</th>
                    <th style="text-align: center; width: 5%">刪除</th>
                </tr>
            </thead>
        </table>
    </div>
</asp:Content>
