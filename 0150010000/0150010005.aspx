<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0150010005.aspx.cs" Inherits="_0150010005" %>

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
                url: '0150010005.aspx/GetPartnerList',
                type: 'POST',
                //async: false,
                //data: JSON.stringify({ date: date.format("YYYY/MM/DD"), ClasstimeType: ClasstimeType }),
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
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false,
                            "defaultContent": "<button type='button' id='edit' class='btn btn-primary btn-lg'>修改</button>" + "&nbsp; &nbsp;" + "<button  id='del'  class='btn btn-danger btn-lg'>刪除</button>"
                        }],
                        columns: [
                                { data: "SYS_ID" },
                                { data: "Partner_Company" },
                                { data: "Partner_Driver" },
                                { data: "Partner_Phone" },
                                { data: "" }
                        ]
                    });
                    // $('.del').unbind('click');
                    $('#data tbody').unbind('click').
                        on('click', '#del', function () {
                        if (confirm("確定要刪除嗎？")) {
                            var data = table.row($(this).parents('tr')).data();
                            $.ajax({
                                url: '0150010005.aspx/DelPartner',
                                ache: false,
                                type: 'POST',
                                //async: false,
                                data: JSON.stringify({ seqno: table.row($(this).parents('tr')).data().SYS_ID }),
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
                    });

                    $('#data tbody').on('click', '#edit', function () {
                        var str_sys_id = table.row($(this).parents('tr')).data().SYS_ID;
                        var URL = "../0150010000/0150010006.aspx?seqno=" + str_sys_id;
                        location.href = (URL);
                    });
                }
            });
        }
    </script>

    <style>
        #calendar .fc-content {
            font-size: 18px;
        }

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

        #data td:nth-child(5), #data td:nth-child(4), #data td:nth-child(3),
        #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <!--===================================================-->
    <div class="table-responsive" style="width: 1024px; margin: 10px 20px">
        <h2><strong>配合廠商管理（瀏覽）&nbsp; &nbsp;</strong><a href="0150010007.aspx" class="btn btn-success btn-lg"><span class='glyphicon glyphicon-plus'></span>&nbsp;新增</a></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">編號</th>
                    <th style="text-align: center;">配合廠商</th>
                    <th style="text-align: center;">司機</th>
                    <th style="text-align: center;">電話</th>
                    <th style="text-align: center;">維護</th>
                </tr>
            </thead>
        </table>
    </div>
</asp:Content>
