<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="0030010004.aspx.cs" Inherits="_0030010004" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery-1.12.3.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <link href="../fullcalendar-2.8.0/fullcalendar.css" rel="stylesheet" />
    <link href="../fullcalendar-2.8.0/fullcalendar.print.css" rel="stylesheet" media="print" />
    <link href="../fullcalendar-2.8.0/fullcalendar.min.css" rel="stylesheet" />
    <script src="../fullcalendar-2.8.0/lib/moment.min.js"></script>
    <script src="../fullcalendar-2.8.0/fullcalendar.min.js"></script>
    <script src="../fullcalendar-2.8.0/lang-all.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>

    <!------------------------------------------------------------------------------------>
    
    <script>
        var str_time = '<%= str_time %>';
        $(document).ready(function () {
            //renderCalendar();
            Client_Code_Search();
            OE_Main_List()
            bindTable();
        });

        //產生行事曆
        function renderCalendar() {
            $('#calendar').fullCalendar({
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: '' //'month,agendaWeek,agendaDay'
                },
                editable: false,
                defaultDate: new Date(),
                lang: 'zh-tw',
                eventClick: function (calEvent, jsEvent, view) {
                    bindTable(calEvent.start, calEvent.type, calEvent.id);
                },
                eventAfterRender: function (calEvent, jsEvent, view) {
                    //  類型  1：尚未審核  2：尚未派工  3：尚未結案    4：已經結案    5：退單
                    if (calEvent.value == '1') {
                        jsEvent.css('background-color', '#9E9E9E');
                    } else if (calEvent.value == '2') {
                        jsEvent.css('background-color', '#43A047');
                    } else if (calEvent.value == '3') {
                        jsEvent.css('background-color', '#3F51B5');
                    } else if (calEvent.value == '4') {
                        jsEvent.css('background-color', '#424242');
                    } else if (calEvent.value == '5') {
                        jsEvent.css('background-color', '#FF0000');
                    } else if (calEvent.value == '0') {
                        jsEvent.css('background-color', '#FF0000');
                    }
                },
                events: function (start, end, timezone, callback) {
                    $.ajax({
                        url: '0030010004.aspx/GetClassGroup',
                        type: 'POST',
                        //async: false,
                        data: JSON.stringify({
                            start: start.format("YYYY/MM/DD"),
                            end: end.format("YYYY/MM/DD"),
                            time: str_time
                        }),
                        contentType: 'application/json; charset=UTF-8',
                        dataType: "json",       //如果要回傳值，請設成 json
                        success: function (doc) {
                            var events = [];
                            $(eval(doc.d)).each(function () {
                                events.push({
                                    title: this.title,
                                    start: this.start,
                                    type: this.type,
                                    value: this.value,
                                    id: this.id
                                });
                            });
                            callback(events);
                        }
                    });
                }
            });
        }

        //==========================  OE 主分類
        function OE_Main_List() {
            $.ajax({
                url: '0030010004.aspx/OE_Main',
                //url: '0030010101.aspx/OE_Main',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_OE_Main");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Main_Classified + "'>" + obj.Main_Classified + "</option>");
                    });
                    //$select_elem.chosen({
                    //    width: "100%",
                    //    search_contains: true
                    //});
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });

                }
            });
        }

        function OE_Detail_List(OE_Detail, ID) {     // Product_Name, ID
            var s = document.getElementById("select_OE_Main");
            var str_value = s.options[s.selectedIndex].value;
            $.ajax({
                url: '0030010004.aspx/OE_Detail',
                type: 'POST',
                data: JSON.stringify({ value: str_value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_OE_Detail");
                    $select_elem.chosen("destroy");
                    $select_elem.empty();
                    //$select_elem.append("<option value=''>" + "請選擇車輛保管人…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Detail_Classified + "'>" + obj.Detail_Classified + "</option>");
                    });
                    if (OE_Detail != '0') {
                        document.getElementById("select_OE_Detail").value = Detail_Classified;
                    };

                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                    if (ID != '0') {
                        alert('跳出商品單');
                        //Product_Name_List(ID);
                    }
                }
            });
            if (ID == '0') {
                var $select_elem = $("#select_ID");
                $select_elem.chosen("destroy")
                $select_elem.empty();
                $select_elem.append("<option value=''>" + "請選擇車牌號碼…" + "</option>");
                $select_elem.chosen({
                    width: "100%",
                    search_contains: true
                });
                $('.chosen-single').css({ 'background-color': '#ffffbb' });
            }
        }

        //=============== 客戶資料
        function Client_Code_Search() {
            $.ajax({
                url: '0030010099.aspx/Client_Code_Search',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropClientCode");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.C + "'>[" + obj.B + "]" + obj.A + "</option>");     // 顯示客戶代碼選單
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }
        //顯示客戶資料
        function ShowClientData() {
            var str_index = document.getElementById("DropClientCode").value;
            $.ajax({
                url: '0030010004.aspx/Show_Client_Data',
                type: 'POST',
                data: JSON.stringify({ value: str_index }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    document.getElementById("str_PID").innerHTML = obj.data[0].C;
                    document.getElementById("str_Client_Name").innerHTML = obj.data[0].C;
                    document.getElementById("str_contact").innerHTML = obj.data[0].D;
                    document.getElementById("str_com_tel").innerHTML = "(" + obj.data[0].E + ")" + obj.data[0].F;
                    document.getElementById("str_mob_phone").innerHTML = obj.data[0].G;
                    document.getElementById("str_hardware").innerHTML = obj.data[0].H;
                    document.getElementById("str_software").innerHTML = obj.data[0].I;
                    document.getElementById("str_serv_typ").innerHTML = obj.data[0].J;
                }
            });
        }

        //========================
        function bindTable() {            //案件列表程式
            $.ajax({
                url: '0030010004.aspx/GetOEList',
                type: 'POST',
                //async: false,
                data: JSON.stringify({

                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data').DataTable({
                        destroy: true,
                        data: eval(doc.d), "oLanguage": {
                            "sLengthMenu": "顯示 _MENU_ 項商品",
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
                            "defaultContent": "<button type='button' id='edit' class='btn btn-info btn-lg'>" +
                                "<span class='glyphicon glyphicon-search'></span>&nbsp;明細</button>"
                        }],
                        columns: [
                                { data: "ID" },
                                { data: "Product_Name" },
                                { data: "Main_Classified" },
                                { data: "Detail_Classified" },
                                {
                                    data: "Price"
                                },
                       {
                           data: "ID", render: function (data, type, row, meta) {
                               return "<input type='text' id='txt_" + data + "ID"; "' class='form-control' maxlength='3' style='Font-Size: 18px;' />";
                           }
                       },
                                {
                                    data: "", render: function (data, type, row, meta) {
                                        return "<button type='button' class='btn btn-success btn-lg' data-toggle='modal' data-target='#newModal' style='Font-Size: 20px;' id='edit' class='btn btn-info btn-lg'>" +
                                " <span class='glyphicon glyphicon-plus'>訂貨</button>";

                                    }
                                }
                        ]
                    });

                    $('#data tbody').unbind('click').   // ???
                        on('click', '#edit', function () {
                            var ID = table.row($(this).parents('tr')).data().ID.toString();
                            URL(ID);
                        });
                }
            });
        }

        function URL(ID) {
            //alert('Load_Data');
            document.getElementById("title_modal").innerHTML = '標的物訂購';
            $.ajax({
                url: '0030010004.aspx/URL',
                type: 'POST',
                data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);

                    document.getElementById("Product_Name").value = obj.data[0].Product_Name;
                    document.getElementById("Price").value = obj.data[0].Price;
                    //document.getElementById("id").value = obj.data[0].ID;

                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }
        //=======================
        function Wai_Bau() {
            window.location = "../0030010098.aspx"
        }

        function Xin_De() {
            URL("0");
        }
    </script>
    <style>
        #calendar .fc-content
        {
            font-size: 18px;
        }

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

        #data td:nth-child(8), #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5),
        #data td:nth-child(4), #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1),
        #data th:nth-child(5)
        {
            text-align: center;
        }
    </style>
    <!--------------------------------------- 客戶資料 -------->
    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th style="text-align: center" colspan="4">
                    <span style="font-size: 20px"><strong>客戶資料</strong></span>
                </th>
            </tr>
        </thead>
        <tbody>
            <tr style="height: 55px;">
                <th style="text-align: center; width: 15%">
                    <strong>客戶選擇(以統編或名稱搜尋)</strong>
                </th>
                <th style="width: 35%">
                    <div data-toggle="tooltip" title="必選" style="width: 100%">
                        <select id="DropClientCode" name="DropClientCode" class="chosen-select" onchange="ShowClientData()">
                            <option value="">請選擇</option>
                        </select>
                    </div>
                </th>
                <th>
                    <strong>客戶編號</strong>
                </th>
                <th>
                    <label id="str_PID"></label>
                </th>
            </tr>
            <%--  =========== 客戶資料 ===========--%>
            <tr style="height: 55px;">
                <%--  Table 002-2  --%>
                <td style="text-align: center; width: 15%">
                    <strong>客戶名稱</strong>
                </td>
                <td style="width: 35%">
                    <label id="str_Client_Name"></label>

                </td>
                <td style="text-align: center; width: 15%">
                    <strong>聯絡人</strong>
                </td>
                <td style="width: 35%">
                    <label id="str_contact"></label>
                </td>
            </tr>

            <%--  =========== 勞工資料 ===========--%>

            <tr style="height: 55px;">
                <td style="text-align: center">
                    <strong>公司電話</strong>
                </td>
                <td>
                    <label id="str_com_tel"></label>
                </td>
                <td style="text-align: center">
                    <strong>行動電話</strong>
                </td>
                <td>
                    <label id="str_mob_phone"></label>
                </td>
            </tr>

            <%--  =========== 勞工資料 ===========--%>
            <tr style="height: 55px;">
                <td style="text-align: center">
                    <strong>硬體</strong>
                </td>
                <td>
                    <label id="str_hardware"></label>
                </td>
                <td style="text-align: center">
                    <strong>軟體</strong>
                </td>
                <td>
                    <label id="str_software"></label>
                </td>
            </tr>
            <%--  =========== 勞工資料 ===========--%>

            <%--  =========== 勞工資料 ===========--%>
            <tr style="height: 55px;">
                <td style="text-align: center">
                    <strong>服務類型</strong>
                </td>
                <td>
                    <label id="str_serv_typ"></label>
                </td>
                <td style="text-align: center">
                    <strong></strong>
                    <br />
                    <strong></strong>
                </td>
                <td>
                    <label id="txt_Labor_EID"></label>
                </td>
            </tr>
        </tbody>
    </table>

    <%--  ========== OE 商品單 ===========--%>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>標的物類別選擇</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%;">
                        <strong>主類別</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip" title="" style="width: 100%">
                            <select id="select_OE_Main" name="select_OE_Main" class="chosen-select" onchange="OE_Detail_List('0','0')">
                                <option value="">請選擇主分類</option>
                            </select>
                        </div>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>子類別</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip" title="" style="width: 100%">
                            <select id="select_OE_Detail" name="select_OE_Detail" class="chosen-select" onchange="bindTable()">
                                <option value="">請選擇子分類</option>
                            </select>
                        </div>
                    </th>
                </tr>

            </tbody>
            </table>
    <%--  ========== --%> 


    <h2><strong>&nbsp; &nbsp; 標地物列表&nbsp; &nbsp;</strong></h2>

    <!----------------------------------------------->

    <div class="table-responsive" style="width: 90%; margin: 10px 20px">
       <table  id="data" class="display table table-striped" style="width: 99%">            
            <thead>
                <tr>
                    <th style="text-align: center;" width: 8%;>
                        <strong>商品ID</strong>
                    </th>
                    <th style="text-align: center;" width: 40%;>商品名稱</th>
                    <th style="text-align: center;" width: 15%;>主分類</th>
                    <th style="text-align: center;" width: 15%;>子分類</th>
                    <th style="text-align: center;" width: 15%;>價格</th>                    
                    <th style="text-align: center;" width: 10%;>數量</th>
                    <th style="text-align: center;" width: 10%;>訂購</th>
                </tr>               
            </thead>
        </table>
    </div>
                <%--  =========== 勞工資料 ===========--%>

        <div class="modal fade" id="newModal" role="dialog" data-backdrop="static" data-keyboard="false"></div>
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
                                    <span style="font-size: 20px"><strong>標的物資料</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>標的物名稱</strong>
                                </th>
                                <th style="text-align: center; width: 80%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <label id="Product_Name"></label>
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>商品價格</strong>
                                </th>
                                <th style="text-align: center; width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <label id="Price"></label>
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>訂購數量</strong>
                                </th>
                                <th style="text-align: center; width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type ="text" id="Text1" name="" class="form-control" placeholder="請填寫訂購數量"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->                            
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;"></th>
                                <th style="text-align: center; width: 35%; height: 65px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New(0)" ><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;訂購</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="New(1)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button> 
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
            <div id="calendar"></div>
        </div>
            </div>
 
</asp:Content>



