<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0060010001.aspx.cs" Inherits="_0060010001" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            bindTable();
            ShowTime();
        });

        function bindTable() {
            $.ajax({
                url: '0060010001.aspx/GetPartnerList',
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
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                                { data: "BUSINESSID" },
                                { data: "APP_OTEL" },
                                { data: "BUSINESSNAME" },
                                { data: "ID" },
                                { data: "SetupDate" },
                                { data: "UpdateDate" },
                                
                                {
                                    data: "SYSID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-primary btn-lg' " +
                                            "data-toggle='modal' data-target='#newModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'>" +
                                            "</span>&nbsp;修改</button>";
                                    }
                                }
                        ]
                    });

                    $('#data tbody').unbind('click').
                        on('click', '#button', function () {
                            var table = $('#data').DataTable();
                            var ROLE_ID = table.row($(this).parents('tr')).data().ROLE_ID;
                            var ROLE_NAME = table.row($(this).parents('tr')).data().ROLE_NAME;
                            document.getElementById("txt_title").innerHTML = '【' + ROLE_NAME + '】選單設定';
                            List_PROGLIST(ROLE_ID);
                        }).
                        on('click', '#edit', function () {
                            var table = $('#data').DataTable();
                            var ROLE_ID = table.row($(this).parents('tr')).data().ROLE_ID;
                            Load_Modal(ROLE_ID);
                        });
                }
            });
        }

        function ShowTime() {
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
            document.getElementById('EstimatedFinishTime').innerHTML = y + "/" + mon + "/" + d + " " + h + ":" + m;

        }

        function List_PROGLIST(ROLE_ID) {
            $.ajax({
                url: '0060010001.aspx/List_PROGLIST',
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
                            Check(Flag, TREE_ID, ROLE_ID.toString());
                        });
                }
            });
        }

        function Check(Flag, TREE_ID, ROLE_ID) {
            $.ajax({
                url: '0060010001.aspx/Check_Menu',
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

        //================ 新增【使用者權限】===============
        function New(Flag) {
            document.getElementById("btn_update").disabled = true;
            document.getElementById("btn_new").disabled = true;
            var Flag = Flag;
            var txt_ROLE_ID = document.getElementById("txt_ROLE_ID").value;
            var txt_ROLE_NAME = document.getElementById("txt_ROLE_NAME").value;

            $.ajax({
                url: '0060010001.aspx/New',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    ROLE_ID: txt_ROLE_ID,
                    ROLE_NAME: txt_ROLE_NAME,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert("新增完成！")
                        bindTable();
                    }
                    else if (json.status == "update") {
                        alert("修改完成！");
                        bindTable();
                    }
                    else {
                        alert(json.status);
                    }
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                },
                error: function () {
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                }
            });
        }

        function Xin_De() {
            Load_Modal(0);
        }

        function Load_Modal(Flag) {
            
            var time_01 = document.getElementById("datetimepicker01").value;
            var time_01 = document.getElementById("datetimepicker02").value;
            var time_01 = document.getElementById("datetimepicker03").value;
            var time_01 = document.getElementById("datetimepicker04").value;
            document.getElementById("txt_ROLE_ID").disabled = false;
            document.getElementById("title_modal").innerHTML = '';
            document.getElementById("txt_ROLE_ID").value = '';
            document.getElementById("txt_ROLE_NAME").value = '';
            document.getElementById("btn_new").style.display = "none";
            document.getElementById("btn_update").style.display = "none";
            document.getElementById("datetimepicker01").value = obj.data[0].Time_01.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_01.substr(11, 5);
            document.getElementById("datetimepicker02").value = obj.data[0].Time_02.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_02.substr(11, 5);
            document.getElementById("datetimepicker03").value = obj.data[0].Time_03.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_03.substr(11, 5);
            document.getElementById("datetimepicker04").value = obj.data[0].Time_04.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_04.substr(11, 5);
            if (Flag == 0) {
                document.getElementById("btn_new").style.display = "";
                document.getElementById("title_modal").innerHTML = '客戶資料（新增）';
            } else {
                document.getElementById("txt_ROLE_ID").disabled = true;
                document.getElementById("btn_update").style.display = "";
                document.getElementById("title_modal").innerHTML = '使用者權限（修改）';
                $.ajax({
                    url: '0060010001.aspx/Load_ROLELIST',
                    type: 'POST',
                    data: JSON.stringify({ ROLE_ID: Flag, }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        document.getElementById("txt_ROLE_ID").value = obj.data[0].ROLE_ID;
                        document.getElementById("txt_ROLE_NAME").value = obj.data[0].ROLE_NAME;
                    },
                    error: function () {

                    }
                });
            }
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

        #data2 td:nth-child(6), #data2 td:nth-child(5), #data2 td:nth-child(4),
        #data2 td:nth-child(3), #data2 td:nth-child(2), #data2 td:nth-child(1),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <!-- ====== Modal ====== -->
    <!--
    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1000px;">

            

            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="txt_title"></label>
                    </strong></h2>
                </div>
                <div class="modal-body">
                    
                    <table id="data2" class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center;">選單編號</th>
                                <th style="text-align: center;">選單分類</th>
                                <th style="text-align: center;">選單名稱</th>
                                <th style="text-align: center;">異動者</th>
                                <th style="text-align: center;">異動日期</th>
                                <th style="text-align: center;">維護</th>
                            </tr>
                        </thead>
                    </table>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal">
                        <span class="glyphicon glyphicon-remove"></span>
                        &nbsp;關閉</button>
                </div>
            </div>

            

        </div>
    </div>
        -->
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="newModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1200px;">

            <!-- Modal content-->

            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="title_modal"></label>
                    </strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>客戶資料</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>客戶代號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填">
                                        <input type="text" id="business_id" name="business_id" class="form-control" placeholder="客戶代號"
                                             maxlength="20" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>統一編號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，應填8位數字">
                                        <input type="text" id="id" name="id" class="form-control" placeholder="統一編號"
                                            maxlength="8" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>客戶名稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，不能超過2０個字元">
                                        <input type="text" id="business_name" name="business_name" class="form-control" placeholder="客戶名稱"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>公司成立時間</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01" style="background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>

                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>聯絡人</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text1" name="txt_Agent_Name" class="form-control" placeholder="聯絡人"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>職稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text5" name="txt_Agent_Name" class="form-control" placeholder="職稱"
                                            maxlength="20" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>行動電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text2" name="txt_Agent_Name" class="form-control" placeholder="行動電話"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>E-mail</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text6" name="txt_Agent_Name" class="form-control" placeholder="E-mail"
                                            maxlength="30" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>公司電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，不能超過8個字元">
                                        <input type="text" id="Text9" name="txt_Agent_Name" class="form-control" placeholder="公司電話"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>傳真電話</strong>
                                </th>
                                <th style="text-align: center; width:35%">
                                    <div data-toggle="tooltip" title="必填，不能超過8個字元">
                                        <input type="text" id="Text10" name="txt_Agent_Name" class="form-control" placeholder="傳真電話"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>登記地址</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text7" name="txt_Agent_Name" class="form-control" placeholder="登記地址"
                                            maxlength="30" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>通訊地址</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text8" name="txt_Agent_Name" class="form-control" placeholder="通訊地址"
                                            maxlength="30" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>合約有效日期</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker02" name="datetimepicker02" style="background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>業務員</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text12" name="txt_Agent_Name" class="form-control" placeholder="業務員"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Hardware</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填">
                                        <input type="text" id="Text13" name="txt_Agent_Name" class="form-control" placeholder="Hardware"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Software Load</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text14" name="txt_Agent_Name" class="form-control" placeholder="Software Load"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>經銷商</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text15" name="txt_Agent_Name" class="form-control" placeholder="經銷商"
                                            maxlength="20" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>訂單編號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填">
                                        <input type="text" id="Text16" name="txt_Agent_Name" class="form-control" placeholder="訂單編號"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>註冊序號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text17" name="txt_Agent_Name" class="form-control" placeholder="註冊序號"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>線路廠商</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text18" name="txt_Agent_Name" class="form-control" placeholder="線路廠商"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>裝機日期</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker03" name="datetimepicker03" style="background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>驗收日期</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker04" name="datetimepicker04" style="background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>服務類型</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text21" name="txt_Agent_Name" class="form-control" placeholder="服務類型"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>銷售類型</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text22" name="txt_Agent_Name" class="form-control" placeholder="銷售類型"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text23" name="txt_Agent_Name" class="form-control" placeholder="備註"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>客戶交代事項</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text24" name="txt_Agent_Name" class="form-control" placeholder="客戶交代事項"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 65px;">
                                    <strong>建檔日期</strong>
                                </th>
                                <th>
                                    <div style="float: left" data-toggle="tooltip" title="必填">
                                        <input type="text" class="form-control" id="LoginTime" name="LoginTime" style="background-color: #ffffbb" value=""/>
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    
                                </th>
                                <th style="text-align: center; width: 35%; height: 65px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New(0)" style="width:110px; height:65px"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <!--<button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="New(1)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button> -->
                                </th>
                            </tr>
                        </tbody>
                    </table>
                    <!-- ========================================== -->
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal">
                        <span class="glyphicon glyphicon-remove"></span>
                        &nbsp;取消</button>
                </div>
            </div>

            <!-- =========== Modal content =========== -->

        </div>

        <script>
            $.datetimepicker.setLocale('ch');
            $('#datetimepicker01').datetimepicker({
                allowTimes: [
                    '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
                ]
            });

            $('#datetimepicker02').datetimepicker({
                allowTimes: [
                    '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
                ]
            });
            $('#datetimepicker03').datetimepicker({
                allowTimes: [
                    '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
                ]
            });
            $('#datetimepicker04').datetimepicker({
                allowTimes: [
                    '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
                ]
            });

            $(function () {
                $('.chosen-select').chosen();
                $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
                $('.chosen-single').css({ 'background-color': '#ffffbb' });
            });
        </script>
    </div>
    <!--===================================================-->

    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
        <h2><strong>客戶資料維護&nbsp; &nbsp;
                <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#newModal" style="Font-Size: 20px;" onclick="Xin_De()">
                    <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增客戶資料</button>
        </strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">客戶代號</th>
                    <th style="text-align: center;">客戶電話</th>
                    <th style="text-align: center;">客戶名稱</th>
                    <th style="text-align: center;">統一編號</th>
                    <th style="text-align: center;">建檔日期</th>
                    <!--<th style="text-align: center;">異動者</th>-->
                    <th style="text-align: center;">異動日期</th>
                    <th style="text-align: center;">修改</th>
                </tr>
            </thead>
        </table>

    </div>
</asp:Content>
