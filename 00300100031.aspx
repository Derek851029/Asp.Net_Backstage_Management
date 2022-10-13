<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="00300100031.aspx.cs" Inherits="_00300100031" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            bindTable();
            bindTable_2();
            //ShowTime();
        });

        function bindTable() {
            $.ajax({
                url: '00300100031.aspx/GetMainList',
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
                        columns: [                                      // 顯示資料列
                                { data: "Main" },
                                {
                                    data: "OE_T_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-primary btn-lg' " +
                                            "data-toggle='modal' data-target='#newModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'>" +
                                            "</span>&nbsp;修改</button>";
                                    }
                                },
                                {
                                    data: "Main", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit02' class='btn btn-info btn-lg' " +
                                            "data-toggle='modal' data-target='#newModal' >" +
                                            "<span class='glyphicon glyphicon-search'>" +
                                            "</span>&nbsp;新增子分類</button>";
                                    }
                                },
                                {
                                    data: "OE_T_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' class='btn btn-danger btn-lg' id='delete'>" +
                                            "<span class='glyphicon glyphicon-remove'>" +
                                            "</span>&nbsp;刪除</button>";
                                    }
                                }
                        ]
                    });
                    $('#data tbody').unbind('click').
                        on('click', '#edit', function () {
                        var table = $('#data').DataTable();
                        var OE_T_ID = table.row($(this).parents('tr')).data().OE_T_ID;
                        var Main = table.row($(this).parents('tr')).data().Main;
                        //alert(OE_T_ID + Main);
                        Load_Modal(OE_T_ID,Main);
                    }).on('click', '#edit02', function () {
                        var table = $('#data').DataTable();
                        var Main = table.row($(this).parents('tr')).data().Main;
                        //alert("B" + Main );
                        Xin_De_02(Main);
                    }).on('click', '#delete', function () {
                        var table = $('#data').DataTable();
                        var OE_T_ID = table.row($(this).parents('tr')).data().OE_T_ID;
                        //alert(OE_T_ID);
                        Delete(OE_T_ID);
                    });
                }
            });
        }
        function Delete(OE_T_ID) {
            if (confirm("確定要刪除嗎？")) {
                $.ajax({
                    url: '00300100031.aspx/Delete',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ OE_T_ID: OE_T_ID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {
                            bindTable();
                        }
                    }
                });
            }
        };
        function URL(PID) {
            $.ajax({
                url: '00300100031.aspx/URL',
                type: 'POST',
                data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.type == "ok") {
                        window.location = json.status;
                    } else {
                        alert(json.status);
                    }
                }
            });
        }


        function bindTable_2(PID) {            // 子公司列表
            $.ajax({
                url: '00300100031.aspx/GetDetailList',
                type: 'POST',
                //data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#Table1').DataTable({
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
                        columns: [                                      // 顯示資料列
                                { data: "Main" },
                                { data: "Detail" },
                                {
                                    data: "OE_T_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-primary btn-lg' " +
                                            "data-toggle='modal' data-target='#newModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'>" +
                                            "</span>&nbsp;修改</button>";
                                    }
                                },
                                {
                                    data: "OE_T_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' class='btn btn-danger btn-lg' id='delete'>" +
                                            "<span class='glyphicon glyphicon-remove'>" +
                                            "</span>&nbsp;刪除</button>";
                                    }
                                }
                        ]
                    });
                    $('#Table1 tbody').unbind('click')
                        .on('click', '#edit', function () {
                            var table = $('#Table1').DataTable();
                            var OE_T_ID = table.row($(this).parents('tr')).data().OE_T_ID;
                            var Main = table.row($(this).parents('tr')).data().Main;
                            var Detail = table.row($(this).parents('tr')).data().Detail;
                            //alert(OE_T_ID+Main+Detail);
                            Load_Modal_02(OE_T_ID, Main, Detail);
                            //alert("2");
                        }).on('click', '#delete', function () {
                            var table = $('#Table1').DataTable();
                            var OE_T_ID = table.row($(this).parents('tr')).data().OE_T_ID;
                            Delete(OE_T_ID);
                        });;
                }
            });
        }

        function ShowTime() {                               //自動抓現在時間(實行指令時)
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
            //document.getElementById('EstimatedFinishTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
        }

        //==============================
        function Xin_De() {     //按新增母分類後
            Load_Modal("0","0");
            //alert('新增');
        }

        function Load_Modal(OE_T_ID, Main) {                                          // 讀資料
            //alert(PID);
            if (OE_T_ID == 0) {
                //alert('檢查中1');
                document.getElementById("btn_new").style.display = "";
                document.getElementById("btn_update").style.display = "none";
                document.getElementById("Button1").style.display = "none";
                document.getElementById("Button2").style.display = "none";
                document.getElementById("title_modal").innerHTML = '主分類（新增）';

                document.getElementById("oe_t_id").innerHTML = "0";
                document.getElementById("txt_main").value = "";
                document.getElementById("txt_detail").value = "";
                
            } else {
                //alert('檢查中2');
                document.getElementById("btn_update").style.display = "";                               //顯示修改鈕
                document.getElementById("btn_new").style.display = "none";                          //隱藏新增鈕
                document.getElementById("Button1").style.display = "none";
                document.getElementById("Button2").style.display = "none";
                document.getElementById("title_modal").innerHTML = '主分類（修改）';

                document.getElementById("oe_t_id").innerHTML = OE_T_ID;
                document.getElementById("txt_main").value = Main;
                document.getElementById("txt_detail").value = "";
            }   //else 結束
        }

        // 預定修改執行部分
        function Load_Data(PID) {
            //alert('Load_Data');
            document.getElementById("PID").innerHTML = PID;
            $.ajax({
                url: '00300100031.aspx/Load_Data',
                type: 'POST',
                data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    //document.getElementById("PID").innerHTML = obj.data[0].PID;   //沒用到要遮蔽
                    document.getElementById("business_name").value = obj.data[0].BUSINESSNAME;
                    document.getElementById("business_id").value = obj.data[0].BUSINESSID;
                    document.getElementById("id").value = obj.data[0].ID;
                    //document.getElementById('LoginTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
                    //document.getElementById("datetimepicker01").value = obj.data[0].BUS_CREATE_DATE;                    
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }

        //==============================子公司相關
        function Xin_De_02(Main) {     //按 新增子分類 後
            Load_Modal_02(0, Main, 0);
        }

        function Load_Modal_02(OE_T_ID, Main, Detail) {                                          // 讀資料
            //alert(PID);
            if (OE_T_ID == 0) {
                //alert('檢查中1');
                document.getElementById("btn_new").style.display = "none";
                document.getElementById("btn_update").style.display = "none";
                document.getElementById("Button1").style.display = "";
                document.getElementById("Button2").style.display = "none";
                document.getElementById("title_modal").innerHTML = '子分類（新增）';

                document.getElementById("oe_t_id").innerHTML = "0";
                document.getElementById("txt_main").value = Main;
                document.getElementById("txt_detail").value = "";
            } else {
                //alert("1");
                document.getElementById("btn_new").style.display = "none";
                document.getElementById("btn_update").style.display = "none";
                document.getElementById("Button1").style.display = "none";
                document.getElementById("Button2").style.display = "";
                document.getElementById("title_modal").innerHTML = '子分類（修改）';
                
                document.getElementById("oe_t_id").innerHTML = OE_T_ID;
                document.getElementById("txt_main").value = Main;
                document.getElementById("txt_detail").value = Detail;
            }   //else 結束
        }

        // 預定修改執行部分
        function Load_Data_02(PNumber) {
            //alert('Load_Data');
            $.ajax({
                url: '00300100031.aspx/Load_Data_02',    // 還沒弄Load_Data_02
                type: 'POST',
                data: JSON.stringify({ PNumber: PNumber }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    document.getElementById("Name").value = obj.data[0].Name;   //沒用到要遮蔽
                    document.getElementById("Text9_2").value = obj.data[0].ADDR;
                    document.getElementById("Text10_2").value = obj.data[0].CONTACT_ADDR;

                    //document.getElementById("PID_2").innerHTML = obj.data[0].PID;   //沒用到要遮蔽
                    
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }
        //================ 新增修改(主)用===============
        function Safe(Flag) {
            //document.getElementById("btn_update").disabled = true;
            //document.getElementById("btn_new").disabled = true;
            
            var T_ID = document.getElementById("oe_t_id").innerHTML;
            var Main = document.getElementById("txt_main").value;
            //var Detail = document.getElementById("txt_detail").value;       
            //alert("a"+Flag +"b"+ T_ID +"c"+ Main);
            $.ajax({
                url: '00300100031.aspx/Safe',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    OE_T_ID: T_ID,
                    Main: Main,         //Detail: Detail,                    
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert("新增(主)完成！")
                        bindTable();
                    }
                    else if (json.status == "update") {
                        alert("修改(主)完成！");
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

        //================ 新增修改(子)用===============
        function New(Flag) {
            var T_ID = document.getElementById("oe_t_id").innerHTML;
            var Main = document.getElementById("txt_main").value;
            var Detail = document.getElementById("txt_detail").value;

            $.ajax({
                url: '00300100031.aspx/New',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    OE_T_ID: T_ID,
                    Main: Main,
                    Detail: Detail,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert("新增(子)完成！")
                        bindTable_2();
                    }
                    else if (json.status == "update") {
                        alert("修改(子)完成！");
                        bindTable_2();
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
        
        //==================
    </script>
    <style>
        body
        {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 18px;
        }

        thead th
        {
            background-color: #666666;
            color: white;
        }

        tr td:first-child,
        tr th:first-child
        {
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }

        tr td:last-child,
        tr th:last-child
        {
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
        }

        #data2 td:nth-child(6), #data2 td:nth-child(5), #data2 td:nth-child(4),
        #data2 td:nth-child(3), #data2 td:nth-child(2), #data2 td:nth-child(1),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5)
        {
            text-align: center;
        }
    </style>

    <!-- ====== 母資料新增修改表 ====== -->
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
                    <!-- ========================================== 表格 -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>分類資料<label id="oe_t_id"></label></strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>

                            <!--
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>PID</strong>
                                </th>      
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip"  style="width: 100%">
                                        <label id="PID" name="PID" ></label> 
                                                                  
                                    </div>
                                </th>                          
                            </tr>   -->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>主分類</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，不能超過２０個字">
                                        <input type="text" id="txt_main" name="business_name" class="form-control" placeholder="主分類"
                                            maxlength="20" style="Font-Size: 18px; background-color: #ffffbb " title="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>子分類</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０個字">
                                        <input type="text" id="txt_detail" name="business_id" class="form-control" placeholder="新增子分類時用"
                                            maxlength="20" style="Font-Size: 18px; " title=""/>
                                    </div>
                                </th>
                            </tr>                            
                            
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;"></th>
                                <th style="text-align: center; width: 35%; height: 65px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="Safe('0')" data-dismiss="modal"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="Safe('1')"data-dismiss="modal"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
                                    <button id="Button1" type="button" class="btn btn-success btn-lg" onclick="New('0')" data-dismiss="modal"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增(子)</button>
                                    <button id="Button2" type="button" class="btn btn-primary btn-lg" onclick="New('1')"data-dismiss="modal"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改(子)</button>
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span>&nbsp;取消</button>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
<!-- =========== Modal content =========== -->
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

            $(function () {
                $('.chosen-select').chosen();
                $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
                $('.chosen-single').css({ 'background-color': '#ffffbb' });
            });
        </script>
    </div>
    <!--===================================================-->

    <!--====================客戶資料維護========================-->
    <div class="table-responsive" style="width: 95%; margin: 10px 20px">
        <h2><strong>分類維護&nbsp; &nbsp;
                <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#newModal" style="Font-Size: 20px;" onclick="Xin_De()">
                    <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增主分類</button>
        </strong></h2>
        <table id="data" class="display table table-striped" style="width: 600px">
            <thead>
                <tr>
                    <th style="text-align: center; width: 25%;">主分類</th>
                    <th style="text-align: center; width: 25%;">修改</th>
                    <th style="text-align: center; width: 25%;">子分類</th>
                    <th style="text-align: center; width: 25%;">刪除</th>
                </tr>
            </thead>
        </table>
    </div>

    <!--====================子公司清單=======================-->

    <div class="table-responsive" style="text-align: center; width: 95%; margin: 10px 20px">
        <h2><strong>子公司清單&nbsp; &nbsp;</strong></h2>
        <table id="Table1" class="display table table-striped" style="width: 600px">
            <thead>
                <tr>
                    <th style="text-align: center; width: 25%;">主分類</th>
                    <th style="text-align: center; width: 25%;">子分類</th>
                    <th style="text-align: center; width: 25%;">修改</th>
                    <th style="text-align: center; width: 25%;">刪除</th>
                </tr>
            </thead>
        </table>
    </div>


</asp:Content>
