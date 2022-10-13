<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0060010014.aspx.cs" Inherits="_0060010014" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            Labor_Table();
            Owner_List();
        });

        function Labor_Table() {
            $("#data").dataTable({
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
                "aLengthMenu": [[10, 25, 50, 100], [10, 25, 50, 100]],
                "iDisplayLength": 100,
                "bSortClasses": false,
                "bStateSave": false,
                "bPaginate": true,
                "bAutoWidth": false,
                "bProcessing": true,
                "bServerSide": true,
                "bDestroy": true,
                "sAjaxSource": "../WebService.asmx/Labor_System",
                "sServerMethod": "POST",
                "contentType": "application/json; charset=UTF-8",
                "sPaginationType": "full_numbers",
                "bDeferRender": true,
                "fnServerParams": function (aoData) {
                    aoData.push(
                        { "name": "iParticipant", "value": $("#participant").val() },
                        { "name": "Cust_ID", "value": document.getElementById("DropOwner").value },
                        { "name": "Flag", "value": "B" }
                        );
                },
                "fnServerData": function (sSource, aoData, fnCallback) {
                    $.ajax({
                        "dataType": 'json',
                        "contentType": 'application/json; charset=UTF-8',
                        "type": "GET",
                        "url": sSource,
                        "data": aoData,
                        "success":
                            function (msg) {
                                var json = jQuery.parseJSON(msg.d);
                                fnCallback(json);
                                $("#data").show();
                            }
                    });
                }
            });
        }

        function Owner_List() {
            $.ajax({
                url: '0030010099.aspx/Owner_List',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropOwner");
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "顯示全部廠商…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Cust_ID + "'>" + "（" + obj.Cust_ID + "）" + obj.Cust_FullName + "</option>");
                    });
                    $select_elem.chosen({
                        width: "50%",
                        search_contains: true
                    });
                }
            });
        }

        function DropOwnerChanged() {
            Labor_Table();
        }

        function Labor_add(SYSID) {
            document.getElementById("txt_Cust_Name").innerHTML = "";
            document.getElementById("txt_Labor_Name").innerHTML = "";
            document.getElementById("txt_Labor_ID").innerHTML = "";
            document.getElementById("txt_TEL").value = "";
            document.getElementById("txt_hid_id").value = "";
            $.ajax({
                url: '0060010014.aspx/List_Labor',
                type: 'POST',
                data: JSON.stringify({ SYSID: SYSID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    if (obj.data[0].status == "") {
                        document.getElementById("txt_Cust_Name").innerHTML = obj.data[0].Cust_FullName;
                        document.getElementById("txt_Labor_Name").innerHTML = obj.data[0].Labor_CName;
                        document.getElementById("txt_Labor_ID").innerHTML = obj.data[0].Labor_ID;
                        document.getElementById("txt_TEL").value = obj.data[0].Labor_Phone;
                        document.getElementById("txt_hid_id").value = obj.data[0].SYSID;
                    }
                    else {
                        alert(obj.data[0].status);
                    }
                }
            });
        }

        function Edit_TEL() {
            document.getElementById("btn_update").disabled = true;
            var tel = document.getElementById("txt_TEL").value;
            var sysid = document.getElementById("txt_hid_id").value;
            $.ajax({
                url: '0060010014.aspx/Edit_TEL',
                type: 'POST',
                data: JSON.stringify({ SYSID: sysid, Labor_Phone: tel }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "ok") {
                        Labor_Table();
                        alert("修改完成。");
                    }
                    else {
                        alert(json.status);
                    }
                    document.getElementById("btn_update").disabled = false;
                }, error: function () {
                    document.getElementById("btn_update").disabled = false;
                }
            });
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

        #data td:nth-child(10), #data td:nth-child(9), #data td:nth-child(8), #data td:nth-child(7),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4), #data td:nth-child(3),
        #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }
    </style>

    <!-- ====== Modal ====== -->
    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 450px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <input id="txt_hid_id" name="txt_hid_id" type="hidden" />
                    <h2 class="modal-title"><strong>
                        <label id="txt_title">勞工電話（修改）</label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>勞工資訊</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>雇主名稱</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <label id="txt_Cust_Name" />
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>勞工姓名</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <label id="txt_Labor_Name" />
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>勞工編號</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <label id="txt_Labor_ID" />
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>聯絡電話</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div data-toggle="tooltip" title="必填，不能超過１０個字元，並且只能填數字">
                                        <input type="text" id="txt_TEL" name="txt_TEL" class="form-control" placeholder="聯絡電話" maxlength="10"
                                            style="Font-Size: 18px; width: 100%; background-color: #ffffbb" onkeyup="value=value.replace(/[^\d]/g,'') " />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;" colspan="2">
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="Edit_TEL()">
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
    <div class="table-responsive" style="width: 1280px; height: 100%; margin: 10px 20px">
        <h2><strong>勞工電話管理</strong></h2>
        <select id="DropOwner" name="DropOwner" onchange="DropOwnerChanged()" style="Font-Size: 16px">
            <option value="">顯示全部廠商</option>
        </select>
        <br />
        <br />
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center; width: 10%">雇主編號</th>
                    <th style="text-align: center; width: 9%">雇主名稱</th>
                    <th style="text-align: center; width: 9%">勞工姓名</th>
                    <th style="text-align: center; width: 9%">勞工編號</th>
                    <th style="text-align: center; width: 9%">護照號碼</th>
                    <th style="text-align: center; width: 9%">居留證號</th>
                    <th style="text-align: center; width: 9%">職工編號</th>
                    <th style="text-align: center; width: 9%">連絡電話 </th>
                    <th style="text-align: center; width: 9%">國籍</th>
                    <th style="text-align: center; width: 9%">狀態 </th>
                    <th style="text-align: center; width: 9%">選擇</th>
                </tr>
            </thead>
        </table>
        <br />
        <br />
        <br />
    </div>
</asp:Content>
