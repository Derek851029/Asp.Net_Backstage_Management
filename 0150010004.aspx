<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0150010004.aspx.cs" Inherits="_0150010004" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            bindTable();
        });

        function bindTable() {
            $.ajax({
                url: '0150010004.aspx/GetPartnerList',
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
                                { data: "SYS_ID" },
                                { data: "ClassName" },
                                { data: "WORK_Time" },
                                { data: "DIAL_Time" },
                                { data: "MASTER_Name" },
                                { data: "MASTER1_NAME" },
                                { data: "UPDATE_TIME" },
                                {
                                    data: "", render: function (data, type, row, meta) {
                                        return "<button id='edit' type='button' class='btn btn-primary btn-lg' data-toggle='modal' data-target='#myModal'>" +
                                            "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>"
                                    }
                                },
                                {
                                    data: "", render: function (data, type, row, meta) {
                                        return "<button id='del' type='button' class='btn btn-danger btn-lg' >" +
                                            "<span class='glyphicon glyphicon-remove'></span>&nbsp;刪除</button>"
                                    }
                                }
                        ]
                    });
                    $('#data tbody').unbind('click').
                        on('click', '#del', function () {
                            if (confirm("確定要刪除嗎？")) {
                                var table = $('#data').DataTable();
                                var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                                $.ajax({
                                    url: '0150010004.aspx/DelPartner',
                                    ache: false,
                                    type: 'POST',
                                    data: JSON.stringify({ seqno: SYS_ID }),
                                    contentType: 'application/json; charset=UTF-8',
                                    dataType: "json",
                                    success: function (data) {
                                        var json = JSON.parse(data.d.toString());
                                        if (json.status == "success") {
                                            alert("刪除完成。");
                                            bindTable();
                                        } else {
                                            alert(json.status);
                                        }
                                    }
                                });
                            }
                        }).
                        on('click', '#edit', function () {
                            var table = $('#data').DataTable();
                            var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                            var URL = "../0150010000/0150010001.aspx?seqno=" + SYS_ID;
                            location.href = (URL);
                        });
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

        #data td:nth-child(9), #data td:nth-child(8), #data td:nth-child(7),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
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
                    <h2 class="modal-title"><strong>
                        <label id="txt_title">班次管理（新增）</label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 25px"><strong>班次管理項目</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>班次名稱</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div data-toggle="tooltip" title="必填，不能超過１０個字元">
                                        <asp:TextBox type="text" ID="txt_class" name="txt_Name" class="form-control" placeholder="班次名稱" MaxLength="10" onkeyup="cs(this);"
                                            Style="Font-Size: 18px; width: 100%; background-color: #ffffbb" runat="server"></asp:TextBox>
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>班次時間</strong>
                                </th>
                                <th style="width: 65%">
                                    <div data-toggle="tooltip" title="必選">
                                        <asp:DropDownList ID="drop_AM_PM_1" runat="server" class="form-control" Style="Font-Size: 18px">
                                            <asp:ListItem Value="上午">上午</asp:ListItem>
                                            <asp:ListItem Value="下午">下午</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>班次日期</strong>
                                </th>
                                <th style="text-align: left; width: 65%">
                                    <label>
                                        <input type="checkbox" id="chk_Mon" style='width: 20px; height: 20px; text-align: left' runat="server" checked="checked" />&nbsp;&nbsp;星期一
                                    </label>
                                    <br />
                                    <label>
                                        <input type="checkbox" id="chk_Tue" style='width: 20px; height: 20px;' runat="server" checked="checked" />&nbsp;&nbsp;星期二
                                    </label>
                                    <br />
                                    <label>
                                        <input type="checkbox" id="chk_Wed" style='width: 20px; height: 20px;' runat="server" checked="checked" />&nbsp;&nbsp;星期三
                                    </label>
                                    <br />
                                    <label>
                                        <input type="checkbox" id="chk_Thu" style='width: 20px; height: 20px;' runat="server" checked="checked" />&nbsp;&nbsp;星期四
                                    </label>
                                    <br />
                                    <label>
                                        <input type="checkbox" id="chk_Fri" style='width: 20px; height: 20px;' runat="server" checked="checked" />&nbsp;&nbsp;星期五
                                    </label>
                                    <br />
                                    <label>
                                        <input type="checkbox" id="chk_Sat" style='width: 20px; height: 20px;' runat="server" checked="checked" />&nbsp;&nbsp;星期六
                                    </label>
                                    <br />
                                    <label>
                                        <input type="checkbox" id="chk_Sun" style='width: 20px; height: 20px;' runat="server" />&nbsp;&nbsp;星期日
                                    </label>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>到班時間</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div style="float: left;">
                                        &nbsp;&nbsp;
                                        <asp:DropDownList ID="drop_AM_PM" runat="server" class="form-control" Style="float: left; Font-Size: 18px;">
                                            <asp:ListItem Value="上午">上午</asp:ListItem>
                                            <asp:ListItem Value="下午">下午</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div style="float: left;">
                                        &nbsp; 時 &nbsp; 
                                        <asp:DropDownList ID="drop_Hour" runat="server" class="form-control" Style="float: left; Font-Size: 18px;">
                                            <asp:ListItem Value="01">01</asp:ListItem>
                                            <asp:ListItem Value="02">02</asp:ListItem>
                                            <asp:ListItem Value="03">03</asp:ListItem>
                                            <asp:ListItem Value="04">04</asp:ListItem>
                                            <asp:ListItem Value="05">05</asp:ListItem>
                                            <asp:ListItem Value="06">06</asp:ListItem>
                                            <asp:ListItem Value="07">07</asp:ListItem>
                                            <asp:ListItem Value="08">08</asp:ListItem>
                                            <asp:ListItem Value="09">09</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="11">11</asp:ListItem>
                                            <asp:ListItem Value="12">12</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div style="float: left;">
                                        &nbsp; 分 &nbsp; 
                                        <asp:DropDownList ID="drop_Minute" runat="server" class="form-control" Style="float: left; Font-Size: 18px;">
                                            <asp:ListItem Value="00">00</asp:ListItem>
                                            <asp:ListItem Value="05">05</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="15">15</asp:ListItem>
                                            <asp:ListItem Value="20">20</asp:ListItem>
                                            <asp:ListItem Value="25">25</asp:ListItem>
                                            <asp:ListItem Value="30">30</asp:ListItem>
                                            <asp:ListItem Value="35">35</asp:ListItem>
                                            <asp:ListItem Value="40">40</asp:ListItem>
                                            <asp:ListItem Value="45">45</asp:ListItem>
                                            <asp:ListItem Value="50">50</asp:ListItem>
                                            <asp:ListItem Value="55">55</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>通知時間</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <div style="float: left;">
                                        &nbsp; 時 &nbsp; 
                                        <asp:DropDownList ID="drop_Hour_2" runat="server" class="form-control" Style="float: left; Font-Size: 18px;">
                                            <asp:ListItem Value="01">01</asp:ListItem>
                                            <asp:ListItem Value="02">02</asp:ListItem>
                                            <asp:ListItem Value="03">03</asp:ListItem>
                                            <asp:ListItem Value="04">04</asp:ListItem>
                                            <asp:ListItem Value="05">05</asp:ListItem>
                                            <asp:ListItem Value="06">06</asp:ListItem>
                                            <asp:ListItem Value="07">07</asp:ListItem>
                                            <asp:ListItem Value="08">08</asp:ListItem>
                                            <asp:ListItem Value="09">09</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="11">11</asp:ListItem>
                                            <asp:ListItem Value="12">12</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div style="float: left;">
                                        &nbsp; 分 &nbsp; 
                                        <asp:DropDownList ID="drop_Minute_2" runat="server" class="form-control" Style="float: left; Font-Size: 18px;">
                                            <asp:ListItem Value="00">00</asp:ListItem>
                                            <asp:ListItem Value="05">05</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="15">15</asp:ListItem>
                                            <asp:ListItem Value="20">20</asp:ListItem>
                                            <asp:ListItem Value="25">25</asp:ListItem>
                                            <asp:ListItem Value="30">30</asp:ListItem>
                                            <asp:ListItem Value="35">35</asp:ListItem>
                                            <asp:ListItem Value="40">40</asp:ListItem>
                                            <asp:ListItem Value="45">45</asp:ListItem>
                                            <asp:ListItem Value="50">50</asp:ListItem>
                                            <asp:ListItem Value="55">55</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>駕駛名稱</strong>
                                </th>
                                <th style="text-align: center; width: 65%">
                                    <asp:UpdatePanel ID="UpdatePanel_1" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="drop_Name" runat="server" class="form-control" Style="float: left; Font-Size: 18px; width: 45%;"
                                                OnSelectedIndexChanged="Changed_1" AutoPostBack="true">
                                                <asp:ListItem Value="">請選擇駕駛...</asp:ListItem>
                                            </asp:DropDownList>
                                            <div data-toggle="tooltip" title="必填，不能超過１０個字元，並且只能填數字">
                                                <asp:TextBox ID="MASTER_TEL" class="form-control" placeholder="駕駛電話" MaxLength="10" onkeyup="int(this);"
                                                    Style="float: right; Font-Size: 18px; width: 50%; background-color: #ffffbb" runat="server"></asp:TextBox>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>負責主管</strong>
                                </th>
                                <th>
                                    <asp:UpdatePanel ID="UpdatePanel_2" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="drop_managername" runat="server" class="form-control" Style="float: left; Font-Size: 18px; width: 45%;"
                                                OnSelectedIndexChanged="Changed_2" AutoPostBack="true">
                                                <asp:ListItem Value="">請選擇負責主管…</asp:ListItem>
                                            </asp:DropDownList>
                                            <div data-toggle="tooltip" title="必填，不能超過１０個字元，並且只能填數字">
                                                <asp:TextBox ID="MASTER_TEL_2" class="form-control" placeholder="負責主管電話" MaxLength="10" onkeyup="int(this);"
                                                    Style="float: right; Font-Size: 18px; width: 50%; background-color: #ffffbb" runat="server"></asp:TextBox>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>部門主管</strong>
                                </th>
                                <th>
                                    <asp:UpdatePanel ID="UpdatePanel_3" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="drop_agent_managername" runat="server" class="form-control" Style="float: left; Font-Size: 18px; width: 45%;"
                                                OnSelectedIndexChanged="Changed_3" AutoPostBack="true">
                                                <asp:ListItem Value="">請選擇部門主管…</asp:ListItem>
                                            </asp:DropDownList>
                                            <div data-toggle="tooltip" title="必填，不能超過１０個字元，並且只能填數字">
                                                <asp:TextBox ID="MASTER_TEL_3" class="form-control" placeholder="部門主管電話" MaxLength="10" onkeyup="int(this);"
                                                    Style="float: right; Font-Size: 18px; width: 50%; background-color: #ffffbb" runat="server"></asp:TextBox>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
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
    <h2><strong>&nbsp; &nbsp;班次管理（瀏覽）&nbsp; &nbsp;</strong>
        <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#myModal">
            <span class='glyphicon glyphicon-plus'></span>&nbsp;新增
        </button>
    </h2>
    <div class="table-responsive" style="width: 1280px; margin: 10px 25px">
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">編號</th>
                    <th style="text-align: center;">班次名稱</th>
                    <th style="text-align: center;">到班時間</th>
                    <th style="text-align: center;">通知時間</th>
                    <th style="text-align: center;">駕駛</th>
                    <th style="text-align: center;">負責主管</th>
                    <th style="text-align: center;">更新日期</th>
                    <th style="text-align: center;">修改</th>
                    <th style="text-align: center;">刪除</th>
                </tr>
            </thead>
        </table>
    </div>
</asp:Content>
