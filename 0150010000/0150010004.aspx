<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0150010004.aspx.cs" Inherits="_0150010004" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery-1.12.3.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        $(function () {
            bindTable();
        });
        function bindTable() {
            $.ajax({
                url: '0150010004.aspx/GetPartnerList',
                type: 'POST',
                //async: false,
                //data: JSON.stringify({ date: date.format("YYYY/MM/DD"), ClasstimeType: ClasstimeType }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data').DataTable({
                        destroy: true,
                        searching: false,
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
                        "iDisplayLength": 50,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false,
                            "defaultContent": "<button type='button' id='edit' class='btn btn-primary btn-lg'>修改</button>" +
                                "&nbsp;&nbsp;" +
                                "<button  id='del'  class='btn btn-danger btn-lg'>刪除</button>"
                        }],
                        columns: [
                                { data: "SYS_ID" },
                                { data: "ClassName" },
                                { data: "WORK_Time" },
                                { data: "DIAL_Time" },
                                { data: "MASTER_Name" },
                                { data: "MASTER1_NAME" },
                                { data: "UPDATE_TIME" },
                                { data: "" }
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
                                    dataType: "json",       //如果要回傳值，請設成 json
                                    success: function (data) {
                                        var json = JSON.parse(data.d.toString());
                                        if (json.status == "success") {
                                            alert("刪除完成。");
                                            bindTable();
                                        }
                                        else {
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

        #data td:nth-child(8), #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5),
        #data td:nth-child(4), #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1),
        #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <!--===================================================-->
    <h2><strong>&nbsp; &nbsp;班次管理（瀏覽）&nbsp; &nbsp;</strong>
        <a href="0150010001.aspx?seqno=99999999" class="btn btn-success btn-lg">
            <span class='glyphicon glyphicon-plus'></span>
            &nbsp;新增
        </a>
    </h2>
    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
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
                    <th style="text-align: center;">維護</th>
                </tr>
            </thead>
        </table>
    </div>
</asp:Content>
