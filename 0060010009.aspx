<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0060010009.aspx.cs" Inherits="_0060010009" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            bindTable();
        });

        function bindTable() {
            $.ajax({
                url: '0060010009.aspx/GetPartnerList',
                type: 'POST',
                //async: false,
                //data: JSON.stringify({ date: date.format("YYYY/MM/DD"), ClasstimeType: ClasstimeType }),
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
                                { data: "SYS_ID" },
                                { data: "HospitalName" },
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
                                        if (data == '0') { checked = '/>' }
                                        return "<div class='checkbox'><label>" +
                                            "<input id='Flag' type='checkbox' style='width: 30px; height: 30px;' " + checked +
                                            "</label></div>";
                                    }
                                }
                        ]
                    });
                    //====================
                    $('#data tbody').unbind('click').
                      on('click', '#Flag', function () {
                          var table = $('#data').DataTable();
                          var sys_id = table.row($(this).parents('tr')).data().SYS_ID;
                          var flag = table.row($(this).parents('tr')).data().Flag;
                          Open_Flag(sys_id, flag);
                      });
                }
            });
        }

        function Open_Flag(SYS_ID, Flag) {
            $.ajax({
                url: '0060010009.aspx/Open_Flag',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID, Flag: Flag }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status)
                    bindTable();
                }
            });
        };

        //================ 新增【醫療院所名稱】資訊 ===============
        function New_Service() {
            document.getElementById("btn_new").disabled = true;
            var HospitalName = document.getElementById("ServiceName").value;  //服務內容          
            $.ajax({
                url: '0060010009.aspx/New_Service',
                type: 'POST',
                data: JSON.stringify({
                    HospitalName: HospitalName.trim(),
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                    bindTable();
                    document.getElementById("btn_new").disabled = false;
                },
                error: function () {
                    document.getElementById("btn_new").disabled = false;
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

        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4), #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1),
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
                        <label id="txt_title">醫療院所（新增）</label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>醫療院所</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>醫療院所</strong>
                                </th>
                                <th style="text-align: center; width: 50%" data-toggle="tooltip" title="必填，不能超過１５個字元">
                                    <input type="text" id="ServiceName" name="ServiceName" class="form-control" placeholder="醫療院所名稱" maxlength="15"
                                        style="Font-Size: 18px; background-color: #ffffbb" />
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New_Service()"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
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
        <h2><strong>醫療院所管理&nbsp;&nbsp;
                <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#myModal" style="Font-Size: 20px;">
                    <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增醫療院所
                </button>
        </strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">編號</th>
                    <th style="text-align: center;">醫療院所</th>
                    <th style="text-align: center;">異動時間</th>
                    <th style="text-align: center;">異動人員</th>
                    <th style="text-align: center;">
                        <div data-toggle="tooltip" data-placement="bottom"
                            title="設定是否開放該【醫療院所】讓【填需求單】的人員可以選取">
                            開放設定
                        </div>
                    </th>
                </tr>
            </thead>
        </table>
    </div>
</asp:Content>
