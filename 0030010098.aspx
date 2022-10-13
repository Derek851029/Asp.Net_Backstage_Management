<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0030010098.aspx.cs" Inherits="_0030010098" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        var new_mno = '<%= new_mno %>';
        var Agent_Mail = '<%= Session["Agent_Mail"] %>';
        //====================================================
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            Load();
            ServiceChanged();  //帶入【服務分類 】資訊
            Owner_List();   //帶入【廠商 】資訊
            Hospital_List();  //帶入【醫療院所 】資訊
            bindTable();  //顯示【新增多筆資訊（瀏覽）】名單
            Labor_Table();  //顯示【新增雇主及外勞】名單
        });

        //================ 讀取資訊 ===============
        function Load() {
            document.getElementById('Hospital_Table_1').style.display = "none";  //隱藏醫療院所、就醫類型
            document.getElementById("str_sysid").innerHTML = new_mno; //【創造母單編號】
            $.ajax({
                url: '0030010099.aspx/Load',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    document.getElementById("str_name").innerHTML = obj.data[0].Agent_Name.trim();
                    document.getElementById("str_team").innerHTML = obj.data[0].Agent_Team.trim();
                    document.getElementById("ContactName").value = obj.data[0].Agent_Name.trim();
                    document.getElementById("Agent_Phone_2").value = obj.data[0].Agent_Phone_2;
                    document.getElementById("Agent_Phone_3").value = obj.data[0].Agent_Phone_3;
                    document.getElementById("Agent_Co_TEL").value = obj.data[0].Agent_Co_TEL;
                }
            });
        }

        //=================================================
        function ServiceChanged() {
            $.ajax({
                url: '0030010098.aspx/ServiceName_List',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropServiceName");
                    $select_elem.chosen("destroy");
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇服務內容…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Service_ID + "'>" + obj.ServiceName + "</option>");
                    });
                    $select_elem.chosen({
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        //==========================================        
        function ServiceNameChanged() {
            var s = document.getElementById("DropServiceName");
            var str_value = s.options[s.selectedIndex].value;
            if (str_value == "60") {
                document.getElementById('Hospital_Table_1').style.display = "";  //顯示醫療院所、就醫類型
                style("HospitalName", "");
                style("HospitalClass", "");
            }
            else {
                document.getElementById('Hospital_Table_1').style.display = "none";  //隱藏醫療院所、就醫類型
            }
        }

        //================ 帶入【廠商】資訊 ===============
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
        //================ 帶入【醫療院所 】資訊 ===============
        function Hospital_List() {
            $.ajax({
                url: '0030010099.aspx/Hospital_List',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var listItems = "";
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    for (var i = 0; i < obj.data.length; i++) {
                        listItems += "<option value='" + obj.data[i].HospitalName + "'>" + obj.data[i].HospitalName + "</option>";
                    }
                    $('#HospitalName').append(listItems);
                }
            });
        }

        //============= 顯示【新增多筆資訊（瀏覽）】名單 =============
        function bindTable() {
            $("#Div_Loading").modal();
            $.ajax({
                url: '0030010099.aspx/GetCNoList',
                type: 'POST',
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
                            "info": false
                        }],
                        columns: [
                            { data: "Cust_FullName" },
                            { data: "Labor_CName" },
                            { data: "Labor_ID" },
                            { data: "Labor_PID" },
                            { data: "Labor_RID" },
                            { data: "Labor_EID" },
                            { data: "Labor_Phone" },
                            { data: "Labor_Country" },
                            { data: "Labor_Valid" },
                            {
                                data: "SYS_ID", render: function (data, type, row, meta) {
                                    return "<button id='delete' type='button' class='btn btn-danger btn-lg' ><span class='glyphicon glyphicon-remove'></span>&nbsp;取消</button>"
                                }
                            }
                        ]
                    });
                    //=========================================
                    $('#data tbody').unbind('click').
                    on('click', '#delete', function () {
                        var table = $('#data').DataTable();
                        var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                        Labor_Delete(SYS_ID);
                    });

                    $("#Div_Loading").modal('hide');
                }, error: function () {
                    $("#Div_Loading").modal('hide');
                }
            });
        }

        //=============== 顯示【新增雇主及外勞】名單 ===============
        function Labor_Table() {
            $("#Labor_Table").dataTable({
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
                        { "name": "Flag", "value": "A" }
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
                                //var json = JSON.parse(msg.d);
                                var json = jQuery.parseJSON(msg.d);
                                fnCallback(json);
                                $("#Labor_Table").show();
                            }
                    });
                }
            });
        }

        //=============== 帶入【新增雇主及外勞】資訊 ===============
        function Labor_add(SYSID, Flag) {
            $.ajax({
                url: '0030010099.aspx/Labor_Value',
                type: 'POST',
                data: JSON.stringify({ SYSID: SYSID, Flag: Flag }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status != "null") {
                        var text = '{"data":' + doc.d + '}';
                        var obj = JSON.parse(text);
                        document.getElementById("txt_Cust_FullName").innerHTML = obj.data[0].Cust_FullName;
                        document.getElementById("txt_Labor_Team").innerHTML = obj.data[0].Labor_Team;
                        document.getElementById("txt_Labor_Name").innerHTML = obj.data[0].Labor_CName;
                        document.getElementById("txt_Labor_Country").innerHTML = obj.data[0].Labor_Country;
                        document.getElementById("txt_Labor_ID").innerHTML = obj.data[0].Labor_ID;
                        document.getElementById("txt_Labor_PID").innerHTML = obj.data[0].Labor_PID;
                        document.getElementById("txt_Labor_RID").innerHTML = obj.data[0].Labor_RID;
                        document.getElementById("txt_Labor_EID").innerHTML = obj.data[0].Labor_EID;
                        document.getElementById("txt_Labor_Phone").innerHTML = obj.data[0].Labor_Phone;
                        document.getElementById("txt_Labor_Address").innerHTML = obj.data[0].Labor_Address;
                        document.getElementById("Labor_Address2").innerHTML = obj.data[0].Labor_Address2;
                        document.getElementById("txt_Labor_Valid").innerHTML = obj.data[0].Labor_Valid;
                        document.getElementById("txt_Labor_Language").innerHTML = obj.data[0].Language;

                        //=============== 帶入【已選擇的雇主或外勞（瀏覽）】資訊 ===============
                        $.ajax({
                            url: '0030010099.aspx/Btn_Add_Click',
                            type: 'POST',
                            data: JSON.stringify({ Cust_ID: obj.data[0].Cust_ID, Labor_ID: obj.data[0].Labor_ID }),
                            contentType: 'application/json; charset=UTF-8',
                            dataType: "json",
                            success: function (doc) {
                                var json = JSON.parse(doc.d.toString());
                                alert(json.status);
                            }
                        });
                        bindTable();
                        //=============== 帶入【已選擇的雇主或外勞（瀏覽）】資訊 ===============
                    }
                }
            });
        }

        //================ 刪除【新增多筆資訊 】資訊 ===============
        function Labor_Delete(SYS_ID) {
            $.ajax({
                url: '0030010099.aspx/Labor_Delete',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function () {
                }
            });
            bindTable();
        }

        //================ 【Flag = 0 新增需求單】 ===============
        //================ 【Flag = 1 修改需求單】 ===============
        function Btn_New_Click(Flag) {
            document.getElementById("Btn_New").disabled = true;
            $("#Div_Loading").modal();
            if (Agent_Mail == '0') {
                alert('【您為新進人員或是沒有E-MAIL資料所以無法新增需求單，請尋求管理人員協助新增，謝謝】');
                document.getElementById("Btn_New").disabled = false;
                $("#Div_Loading").modal('hide');
                return;
            }
            var Service_ID = document.getElementById("DropServiceName").value;  //服務內容
            var time_01 = document.getElementById("datetimepicker01").value;    //預定起始時間
            var time_02 = document.getElementById("datetimepicker02").value;    //預定終止時間
            var LocationStart = document.getElementById("LocationStart").value;  //行程起點 
            var LocationEnd = document.getElementById("LocationEnd").value;     //行程終點
            var CarSeat = document.getElementById("txt_CarSeat").value;                //搭車人數
            var ContactName = document.getElementById("ContactName").value;    //聯絡人
            var ContactPhone2 = document.getElementById("Agent_Phone_2").value;  //手機簡碼
            var ContactPhone3 = document.getElementById("Agent_Phone_3").value;  //手機號碼
            var Contact_Co_TEL = document.getElementById("Agent_Co_TEL").value; //公司電話
            var HospitalName = document.getElementById("HospitalName").value;   //醫療院所
            var HospitalClass = document.getElementById("HospitalClass").value;       //就醫類型
            var Question = document.getElementById("Question").value;                       //狀況說明

            $.ajax({
                url: '0030010098.aspx/Check_Form',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    Service_ID: Service_ID,
                    Time_01: time_01,
                    Time_02: time_02,
                    LocationStart: LocationStart,
                    LocationEnd: LocationEnd,
                    CarSeat: CarSeat,
                    ContactName: ContactName,
                    ContactPhone2: ContactPhone2,
                    ContactPhone3: ContactPhone3,
                    Contact_Co_TEL: Contact_Co_TEL,
                    Hospital: HospitalName,
                    HospitalClass: HospitalClass,
                    Question: Question
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert('新增完成');
                        window.location.href = "/0030010000/0030010002.aspx";
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    document.getElementById("Btn_New").disabled = false;
                }
            });
        };

        //================== 【返回】 =================
        function Btn_Back_Click() {
            window.location.href = "/0030010000/0030010002.aspx";
        };

        //================【下拉選單】 CSS 修改 ================
        function style(Name, value) {
            var $select_elem = $("#" + Name);
            $select_elem.chosen("destroy")
            document.getElementById(Name).value = value;
            $select_elem.chosen({
                width: "100%",
                search_contains: true
            });
            $('.chosen-single').css({ 'background-color': '#ffffbb' });
        }

        //================================================
    </script>
    <style type="text/css">
        body {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 16px;
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

        #Labor_Table td:nth-child(12), #Labor_Table td:nth-child(11), #Labor_Table td:nth-child(10), #Labor_Table td:nth-child(9),
        #Labor_Table td:nth-child(8), #Labor_Table td:nth-child(7), #Labor_Table td:nth-child(6), #Labor_Table td:nth-child(5),
        #Labor_Table td:nth-child(4), #Labor_Table td:nth-child(3), #Labor_Table td:nth-child(2), #Labor_Table td:nth-child(1),
        #data td:nth-child(10), #data td:nth-child(9), #data td:nth-child(8), #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5),
        #data td:nth-child(4), #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }

        .auto-style1 {
            height: 47px;
        }
    </style>

    <!-- ====== Loading ====== -->
    <div class="modal fade" id="Div_Loading" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 350px;">
            <div class="modal-content" style="margin-top: 100%; margin-left: 25%;">
                <div style="text-align: center">
                    <br />
                    <img src="img/ajax-loader.gif" />
                    <h3>Loading...</h3>
                    <br />
                </div>
            </div>
        </div>
    </div>
    <!-- ====== Modal ====== -->

    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 95%;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>雇主及外勞資料</strong></h2>
                    <select id="DropOwner" name="DropOwner" onchange="DropOwnerChanged()" style="Font-Size: 16px">
                        <option value="">顯示全部廠商</option>
                    </select>
                </div>
                <div class="modal-body">
                    <%-- ========================================== --%>
                    <table id="Labor_Table" class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center; width: 8%">雇主編號</th>
                                <th style="text-align: center; width: 8%">雇主名稱</th>
                                <th style="text-align: center; width: 8%">勞工姓名</th>
                                <th style="text-align: center; width: 9%">勞工編號</th>
                                <th style="text-align: center; width: 9%">護照號碼</th>
                                <th style="text-align: center; width: 9%">居留證號</th>
                                <th style="text-align: center; width: 9%">職工編號</th>
                                <th style="text-align: center; width: 8%">連絡電話 </th>
                                <th style="text-align: center; width: 8%">國籍</th>
                                <th style="text-align: center; width: 8%">狀態 </th>
                                <th style="text-align: center; width: 8%">選擇</th>
                                <th style="text-align: center; width: 8%">選擇</th>
                            </tr>
                        </thead>
                    </table>
                    <%-- ========================================== --%>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">關閉</button>
                </div>
            </div>
        </div>
    </div>
    <!--===================================================-->
    <div style="width: 1280px; margin: 10px 20px">
        <h2><strong>外包商需求單（新增）</strong></h2>
        <h4 style="color: #D50000;"><strong>&#8251;外包商需求單送出後將會直接結案，不會經過派工程序。</strong></h4>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>服務需求內容</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%;">
                        <strong>需求單狀態</strong>
                    </th>
                    <th style="width: 35%">
                        <strong>新增外包商需求單</strong>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>結案日期</strong>
                    </th>
                    <th style="width: 35%"></th>
                </tr>
                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr id="tr_sysid" runat="server">
                    <td style="text-align: center">
                        <strong>需求單編號</strong>
                    </td>
                    <td>
                        <label id="str_sysid"></label>
                    </td>
                    <td style="text-align: center"></td>
                    <td></td>
                </tr>
                <tr>
                    <td style="text-align: center">
                        <strong>填單人</strong>
                    </td>
                    <td>
                        <label id="str_name"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>填單人部門</strong>
                    </td>
                    <td>
                        <label id="str_team"></label>
                    </td>
                </tr>
                <%--  ========== 服務人員資料 ===========--%>

                <%--  ========== 服務項目 ===========--%>
                <tr>
                    <td style="text-align: center; color: #D50000;">
                        <strong>服務分類</strong>
                    </td>
                    <td>
                        <div data-toggle="tooltip" title="必選" style="width: 100%">
                            <select id="DropService" name="DropService" class="chosen-select">
                                <option value="外包商">外包商</option>
                            </select>
                        </div>
                    </td>
                    <td style="text-align: center; color: #D50000;">
                        <strong>服務內容</strong>
                    </td>
                    <td>
                        <div data-toggle="tooltip" title="必選">
                            <select id="DropServiceName" name="DropServiceName" class="chosen-select" onchange="ServiceNameChanged()">
                                <option value="">請選擇服務內容…</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <%--  ========== 服務項目 ===========--%>

                <%--  ========== 需求日期 ===========--%>
                <tr>
                    <td style="text-align: center; color: #D50000;">
                        <strong>預定起始時間</strong>
                    </td>
                    <td style="text-align: center">
                        <div style="float: left" data-toggle="tooltip" title="必填">
                            <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01" style="background-color: #ffffbb" />
                        </div>
                    </td>
                    <td style="text-align: center; color: #D50000;">
                        <strong>預定終止時間</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="必填">
                            <input type="text" class="form-control" id="datetimepicker02" name="datetimepicker02" style="background-color: #ffffbb" />
                        </div>
                    </td>
                </tr>
                <%--  ========== 需求日期 ===========--%>

                <%--  =========== 行程= ===========--%>
                <tr id="PathTable">
                    <td style="text-align: center">
                        <strong>行程起點</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="不能超過１００個字元，並且含有不正確的符號">
                            <textarea id="LocationStart" name="LocationStart" class="form-control" cols="45" rows="3" placeholder="行程起點" style="resize: none" maxlength="100" onkeyup="cs(this);"></textarea>
                        </div>
                    </td>
                    <td style="text-align: center">
                        <strong>行程終點</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="不能超過１００個字元，並且含有不正確的符號">
                            <textarea id="LocationEnd" name="LocationEnd" class="form-control" cols="45" rows="3" placeholder="行程終點" style="resize: none" maxlength="100" onkeyup="cs(this);"></textarea>
                        </div>
                    </td>
                </tr>
                <%--  =========== 行程 ============--%>
                <tr id="tab_CarSeat">
                    <td style="text-align: center; color: #D50000; width: 15%">
                        <strong>搭車人數</strong>
                    </td>
                    <td>
                        <div data-toggle="tooltip" title="搭車人數，預設為０人" style="width: 100%">
                            <select id="txt_CarSeat" name="txt_CarSeat" class="chosen-select">
                                <option value="0">０人</option>
                                <option value="1">１人</option>
                                <option value="2">２人</option>
                                <option value="3">３人</option>
                                <option value="4">４人</option>
                                <option value="5">５人</option>
                                <option value="6">６人</option>
                                <option value="7">７人</option>
                                <option value="8">８人</option>
                                <option value="9">９人</option>
                                <option value="10">１０人</option>
                            </select>
                        </div>
                    </td>
                    <td style="text-align: center"></td>
                    <td></td>
                </tr>

                <%--  =========== 聯絡人 ===========--%>

                <tr>
                    <td style="text-align: center">
                        <strong>聯絡人</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="預設為填單人員的姓名，不能超過１０個字元">
                            <input id="ContactName" class="form-control" placeholder="連絡人" maxlength="10" onkeyup="cs(this);" />
                        </div>
                    </td>
                    <td style="text-align: center">
                        <strong>手機簡碼</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="預設為填單人員的手機簡碼，不能超過１０個字元，並且只能填數字">
                            <input id="Agent_Phone_3" class="form-control" placeholder="手機簡碼" maxlength="10" onkeyup="value=value.replace(/[^\d]/g,'') " />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center">
                        <strong>公司手機號碼</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="預設為填單人員的手機號碼，不能超過１０個字元，並且只能填數字">
                            <input id="Agent_Phone_2" class="form-control" placeholder="手機號碼" maxlength="10" onkeyup="value=value.replace(/[^\d]/g,'') " />
                        </div>
                    </td>
                    <td style="text-align: center">
                        <strong>公司電話</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="預設為填單人員的公司電話，不能超過２０個字元，格式為【06-123#123】或【06-123】或【0800-000-000】">
                            <input id="Agent_Co_TEL" class="form-control" placeholder="公司電話" maxlength="20" />
                        </div>
                    </td>
                </tr>

                <%--  =========== 聯絡人 ===========--%>

                <%--  ========== 醫療院所 ===========--%>

                <tr id="Hospital_Table_1">
                    <td style="text-align: center; color: #D50000;">
                        <strong>醫療院所</strong>
                    </td>
                    <td>
                        <div data-toggle="tooltip" title="必選" style="width: 100%">
                            <select id="HospitalName" name="HospitalName" class="chosen-select">
                                <option value="">請選擇醫療院所…</option>
                            </select>
                        </div>
                    </td>
                    <td style="text-align: center; color: #D50000;">
                        <strong>就醫類型</strong>
                    </td>
                    <td>
                        <div data-toggle="tooltip" title="必選" style="width: 100%">
                            <select id="HospitalClass" name="HospitalClass" class="chosen-select">
                                <option value="">請選擇就醫類型…</option>
                                <option value="上班就醫">上班就醫</option>
                                <option value="上班就醫 ( 需診斷書 )">上班就醫 ( 需診斷書 )</option>
                                <option value="下班就醫">下班就醫</option>
                                <option value="下班就醫 ( 需診斷書 )">下班就醫 ( 需診斷書 ) </option>
                            </select>
                        </div>
                    </td>
                </tr>

                <%--  ========== 醫療院所 ===========--%>

                <tr>
                    <td style="text-align: center; color: #D50000;">
                        <strong>狀況說明</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="必填，不能超過２５０個字元，並且含有不正確的符號">
                            <textarea id="Question" name="Question" class="form-control" cols="45" rows="3" placeholder="狀況說明" maxlength="250" onkeyup="cs(this);"
                                style="resize: none; background-color: #ffffbb"></textarea>
                        </div>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
            </tbody>
        </table>
        <%--  =========== 勞工資料 ===========--%>
        
        <!-- ===========  Mail 表格 ============== -->
        <div style="font-family:'Microsoft JhengHei';">
            <table class="table table-bordered table-striped">
                <thead>
                <tr>
                    <th style="text-align: center" colspan="11">
                        <span style="font-size: 20px;"><strong>抱怨單內容</strong></span>
                    </th>
                </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="text-align: center;"><strong>建立日期</strong></td>
                        <td style="text-align: center;"><strong>客服單號</strong></td>
                        <td style="text-align: center;"><strong>客服人員</strong></td>
                        <td style="text-align: center;"><strong>報修人</strong></td>
                        <td style="text-align: center;"><strong>客戶電話</strong></td>
                        <td style="text-align: center;"><strong>狀態</strong></td>
                        <td style="text-align: center;"><strong>產品別</strong></td>
                        <td style="text-align: center;"><strong>抱怨內容</strong></td>
                        <td style="text-align: center;"><strong>原因</strong></td>
                        <td style="text-align: center;"><strong>對策</strong></td>
                        <td style="text-align: center;"><strong>反應類別</strong></td>
                        <td style="text-align: center;"><strong>緊急程度</strong></td>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td style="text-align: center;"><strong>來源</strong></td>
                        <td style="text-align: center;"><strong>處理完成時間</strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>建立日期AA</strong></td>
                        <td style="text-align: center;"><strong>客服單號BB</strong></td>
                        <td style="text-align: center;"><strong>客服人員CC</strong></td>
                        <td style="text-align: center;"><strong>報修人DD</strong></td>
                        <td style="text-align: center;"><strong>客戶電話EE</strong></td>
                        <td style="text-align: center;"><strong>狀態FF</strong></td>
                        <td style="text-align: center;"><strong>產品別GG</strong></td>
                        <td style="text-align: center;"><strong>抱怨內容HH</strong></td>
                        <td style="text-align: center;"><strong>原因II</strong></td>
                        <td style="text-align: center;"><strong>對策JJ</strong></td>
                        <td style="text-align: center;"><strong>反應類別KK</strong></td>
                        <td style="text-align: center;"><strong>緊急程度LL</strong></td>
                        <td style="text-align: center;"><strong>品牌MM</strong></td>
                        <td style="text-align: center;"><strong>來源NN</strong></td>
                        <td style="text-align: center;"><strong>處理完成時間OO</strong></td>
                    </tr>
                </tbody>
            </table>
            <br />
            <table>
                <thead>
                    <tr>
                        <th style="text-align: center; font-size: 20px;" colspan="2"><strong>搜尋條件</strong></th>
                    </tr>
                </thead>
                <tbody> 
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>緊急程度</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>品牌</strong></td>
                        <td ><strong></strong></td>
                    </tr>

                </tbody>
            </table>
        </div>

        <%--  =========== 勞工資料 ===========--%>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>雇主及外勞資料</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>事業部門</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="txt_Labor_Team"></label>
                    </th>
                    <th style="text-align: center; color: #D50000; width: 15%">
                        <div data-toggle="tooltip" title="請點選下方【選擇雇主或外勞】來選取">
                            <strong>客戶、雇主</strong>
                        </div>
                    </th>
                    <th style="width: 35%">
                        <label id="txt_Cust_FullName"></label>
                    </th>
                </tr>
                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>勞工姓名</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Name"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>勞工國籍</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Country"></label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>勞工狀態</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Valid"></label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>勞工編號</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_ID"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>護照號碼</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_PID"></label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>居留證號</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_RID"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>職工編號</strong><br />
                        <strong>（長工號）</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_EID"></label>
                    </td>
                </tr>

                <%--  =========== 勞工資料 ===========--%>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>連絡電話</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Phone"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>翻譯國籍</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Language"></label>
                    </td>
                </tr>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡地址</strong>
                    </td>
                    <td>
                        <label id="txt_Labor_Address"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>接送地址</strong>
                    </td>
                    <td>
                        <label id="Labor_Address2"></label>
                    </td>
                </tr>
                <tr id="table_modal">
                    <td colspan="4" style="text-align: center">
                        <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">
                            <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;選擇雇主或外勞</button>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr>
                    <td colspan="4" style="text-align: center">
                        <button id="Btn_New" type="button" onclick="Btn_New_Click('0');" class="btn btn-success btn-lg "><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;送出</button>&nbsp;&nbsp;
                        <button id="Btn_Back" type="button" onclick="Btn_Back_Click();" class="btn btn-default btn-lg ">返回&nbsp;&nbsp;<span class="glyphicon glyphicon-share-alt"></span></button>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center">
                        <h4 style="color: #D50000;"><strong>&#8251;外包商需求單送出後將會直接結案，不會經過派工程序。</strong></h4>
                    </td>
                </tr>
            </tbody>
        </table>
        
        <div id="Add_Table_2">
            <div class="table-responsive">
                <h2><strong>已選擇的雇主或外勞（瀏覽）A</strong>
                </h2>
                <table id="data" class="display table table-striped" style="width: 99%">
                    <thead>
                        <tr>
                            <th style="text-align: center;">雇主</th>
                            <th style="text-align: center;">姓名</th>
                            <th style="text-align: center;">勞工編號</th>
                            <th style="text-align: center;">護照號碼</th>
                            <th style="text-align: center;">居留證號</th>
                            <th style="text-align: center;">職工編號</th>
                            <th style="text-align: center;">連絡電話</th>
                            <th style="text-align: center;">國籍</th>
                            <th style="text-align: center;">狀態</th>
                            <th style="text-align: center;">功能</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
        
        <!--===================================================-->
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

            $(function () {
                $('.chosen-select').chosen();
                $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
                $('.chosen-single').css({ 'background-color': '#ffffbb' });
            });
        </script>
    </div>
</asp:Content>
