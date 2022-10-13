<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0060010012.aspx.cs" Inherits="_0060010012" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../js/jquery.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        $(function () {
            List_Agent_Team();  //帶入【部門 】資訊
            bindTable();
        });

        function bindTable() {
            $.ajax({
                url: '0060010012.aspx/List_Team_Group',
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
                                { data: "Agent_Team" },
                                {
                                    data: "Flag_1", render: function (data, type, row, meta) {
                                        var checked = 'checked/>'
                                        if (data == '0') {
                                            checked = '/>'
                                        }
                                        return "<div class='checkbox'><label>" +
                                         "<input id='flag_1' type='checkbox' style='width: 30px; height: 30px;' " + checked + "</label></div>";
                                    }
                                },
                                 {
                                     data: "Flag_2", render: function (data, type, row, meta) {
                                         var checked = 'checked/>'
                                         if (data == '0') {
                                             checked = '/>'
                                         }
                                         return "<div class='checkbox'><label>" +
                                         "<input id='flag_2' type='checkbox' style='width: 30px; height: 30px;' " + checked + "</label></div>";
                                     }
                                 },
                                  {
                                      data: "Flag_3", render: function (data, type, row, meta) {
                                          var checked = 'checked/>'
                                          if (data == '0') {
                                              checked = '/>'
                                          }
                                          return "<div class='checkbox'><label>" +
                                         "<input id='flag_3' type='checkbox' style='width: 30px; height: 30px;' " + checked + "</label></div>";
                                      }
                                  },
                                  {
                                      data: "Flag_4", render: function (data, type, row, meta) {
                                          var checked = 'checked/>'
                                          if (data == '0') {
                                              checked = '/>'
                                          }
                                          return "<div class='checkbox'><label>" +
                                         "<input id='flag_4' type='checkbox' style='width: 30px; height: 30px;' " + checked + "</label></div>";
                                      }
                                  },
                                  {
                                      data: "Flag_5", render: function (data, type, row, meta) {
                                          var checked = 'checked/>'
                                          if (data == '0') {
                                              checked = '/>'
                                          }
                                          return "<div class='checkbox'><label>" +
                                         "<input id='flag_5' type='checkbox' style='width: 30px; height: 30px;' " + checked + "</label></div>";
                                      }
                                  },
                                  {
                                      data: "Flag_6", render: function (data, type, row, meta) {
                                          var checked = 'checked/>'
                                          if (data == '0') {
                                              checked = '/>'
                                          }
                                          return "<div class='checkbox'><label>" +
                                         "<input id='flag_6' type='checkbox' style='width: 30px; height: 30px;' " + checked + "</label></div>";
                                      }
                                  },
                                  {
                                      data: "SYS_ID", render: function (data, type, row, meta) {
                                          return "<button id='delete' type='button' class='btn btn-danger btn-lg' >" +
                                                "<span class='glyphicon glyphicon-remove'>" +
                                                "</span>&nbsp;刪除</button>";
                                      }
                                  }]
                    });

                    //==============================

                    $('#data tbody').unbind('click').
                     on('click', '#flag_1', function () {
                         var table = $('#data').DataTable();
                         var value = table.row($(this).parents('tr')).data().Flag_1;
                         var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                         Checkbox("1", value, SYS_ID);
                     }).
                     on('click', '#flag_2', function () {
                         var table = $('#data').DataTable();
                         var value = table.row($(this).parents('tr')).data().Flag_2;
                         var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                         Checkbox("2", value, SYS_ID);
                     }).
                      on('click', '#flag_3', function () {
                          var table = $('#data').DataTable();
                          var value = table.row($(this).parents('tr')).data().Flag_3;
                          var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                          Checkbox("3", value, SYS_ID);
                      }).
                      on('click', '#flag_4', function () {
                          var table = $('#data').DataTable();
                          var value = table.row($(this).parents('tr')).data().Flag_4;
                          var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                          Checkbox("4", value, SYS_ID);
                      }).
                      on('click', '#flag_5', function () {
                          var table = $('#data').DataTable();
                          var value = table.row($(this).parents('tr')).data().Flag_5;
                          var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                          Checkbox("5", value, SYS_ID);
                      }).
                      on('click', '#flag_6', function () {
                          var table = $('#data').DataTable();
                          var value = table.row($(this).parents('tr')).data().Flag_6;
                          var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                          Checkbox("6", value, SYS_ID);
                      }).
                      on('click', '#delete', function () {
                          var table = $('#data').DataTable();
                          var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                          Delete(SYS_ID);
                      });

                    //==============================
                }
            });
        }

        //================ 帶入【部門 】資訊 ===============
        function List_Agent_Team() {
            $.ajax({
                url: '0060010012.aspx/List_Agent_Team',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    $('#Select_Team').append().empty();
                    var listItems = "<option value=''>請選擇派工部門…</option>";
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    for (var i = 0; i < obj.data.length; i++) {
                        listItems += "<option value='" + obj.data[i].Agent_Team + "'>" + obj.data[i].Agent_Team + "</option>";
                    }
                    $('#Select_Team').append(listItems);
                }
            });
        };

        //================ 新增【服務】資訊 ===============
        function New_Agent_Team() {
            var Agent_Team = document.getElementById("Select_Team").value;
            $.ajax({
                url: '0060010012.aspx/New_Agent_Team',
                type: 'POST',
                data: JSON.stringify({
                    Agent_Team: Agent_Team.trim()
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                    List_Agent_Team();
                    bindTable();
                }
            });
        };

        //============= Checkbox 開關 =============
        function Checkbox(Flag, value, SYS_ID) {
            $.ajax({
                url: '0060010012.aspx/Checkbox',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    value: value,
                    SYS_ID: SYS_ID
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    bindTable();
                    alert(json.status);
                }
            });
        }

        //====================================
        function Delete(SYS_ID) {
            if (confirm("確定要刪除嗎？")) {
                $.ajax({
                    url: '0060010012.aspx/Delete',
                    type: 'POST',
                    data: JSON.stringify({ SYS_ID: SYS_ID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var json = JSON.parse(doc.d.toString());
                        List_Agent_Team();
                        bindTable();
                        alert(json.status);
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

        #data td:nth-child(9), #data td:nth-child(8),
        #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
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
                    <h2 class="modal-title"><strong>
                        <label id="txt_title">派工部門（新增）</label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>派工部門</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;">
                                    <strong>選擇派工部門</strong>
                                </th>
                                <th style="text-align: center; width: 50%">
                                    <select id="Select_Team" name="Select_Team" class="form-control" style="Font-Size: 18px; width: 100%">
                                        <option value="">請選擇派工部門…</option>
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 50%; height: 55px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New_Agent_Team()"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
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
        <h2><strong>派工部門區域管理&nbsp;&nbsp;
    <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#myModal" style="Font-Size: 20px;"><span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增派工部門</button></strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">編號</th>
                    <th style="text-align: center;">部門</th>
                    <th style="text-align: center;">北北基</th>
                    <th style="text-align: center;">桃竹苗</th>
                    <th style="text-align: center;">中彰投</th>
                    <th style="text-align: center;">雲嘉南</th>
                    <th style="text-align: center;">高高屏</th>
                    <th style="text-align: center;">宜花東</th>
                    <th style="text-align: center;">刪除</th>
                </tr>
            </thead>
        </table>
    </div>
</asp:Content>
