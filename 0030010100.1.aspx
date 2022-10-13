<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0030010100.aspx.cs" Inherits="_0030010100" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        var seqno = '<%= seqno %>';
        var new_mno = '<%= new_mno %>';
        var Agent_Mail = '<%= Session["Agent_Mail"] %>';
        //====================================================
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            Load();
            //Service_List();  //帶入【服務分類 】資訊
            Select_Telecomm();
            Eng_Name_Search();
            Eng_Name_Search_Reg();
            //Owner_List();   //帶入【廠商 】資訊
            //Hospital_List();  //帶入【醫療院所 】資訊
            //Cust_Table();  //顯示【客戶地址】名單
            //ShowTime();  //抓現在時間
            //SwitchOption();
            if (seqno != '0') {
                Load_CaseData();
            } else {
                bindTable();  //顯示【新增多筆資訊（瀏覽）】名單
                Labor_Table();  //顯示【新增雇主及外勞】名單
            }
        });

        //================ 讀取資訊 ===============
        function Load() {
            //document.getElementById('tab_Location').style.display = "none";  //隱藏地址
            //document.getElementById('Hospital_Table_1').style.display = "none";  //隱藏醫療院所、就醫類型
            if (seqno == '0') {
                document.getElementById("str_sysid").innerHTML = new_mno; //【創造母單編號】
                document.getElementById('Btn_Update').style.display = "none";  //隱藏修改按鈕
                //document.getElementById('table_cancel').style.display = 'none';  //隱藏【取消需求單】
                $.ajax({
                    url: '0030010100.aspx/Load',
                    type: 'POST',
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        document.getElementById("str_name").innerHTML = obj.data[0].Agent_Name.trim();
                        //document.getElementById("str_team").innerHTML = obj.data[0].Agent_Team.trim();
                        //document.getElementById("ContactName").value = obj.data[0].Agent_Name.trim();
                        //document.getElementById("Agent_Phone_2").value = obj.data[0].Agent_Phone_2;
                        //document.getElementById("Agent_Phone_3").value = obj.data[0].Agent_Phone_3;
                        //document.getElementById("Agent_Co_TEL").value = obj.data[0].Agent_Co_TEL;
                    }
                });
            } else {
                new_mno = seqno;
                document.getElementById("str_sysid").innerHTML = new_mno;
                //document.getElementById('table_modal').style.display = "none";  //隱藏【選擇雇主或外勞】
                //document.getElementById('Btn_New').style.display = "none";  //隱藏送出按鈕
                //document.getElementById('Add_Table_2').style.display = 'none';  //隱藏【新增多筆資訊】
            }
        }

        //=============

        function ShowTime() {
            var NowDate = new Date();
            var h = NowDate.getHours();
            var m = NowDate.getMinutes();
            var s = NowDate.getSeconds();
            var y = NowDate.getFullYear();
            var mon = NowDate.getMonth()+1;
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
            document.getElementById('Show_U_Time').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
            //document.getElementById('EstimatedFinishTime').innerHTML = y + "/" + mon + "/" + d + " " + h + ":" + m;             // 估計完成時間
            
        }
      
        //================ 帶入【服務分類 】資訊 ===============
        function Service_List() {
            $.ajax({
                url: '0030010100.aspx/Service_List',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropService");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Service + "'>" + obj.Service + "</option>");
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

        //function Esti_Fin_Time() { }

        function ServiceChanged() {
            document.getElementById('tab_Location').style.display = "none";  //隱藏地址

            var s = document.getElementById("DropService");
            var str_value = s.options[s.selectedIndex].value;
            $.ajax({
                url: '0030010100.aspx/ServiceName_List',            // ???
                type: 'POST',
                data: JSON.stringify({ service: str_value }),
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

            if (str_value == "醫療") {
                document.getElementById('Hospital_Table_1').style.display = "";  //顯示醫療院所、就醫類型
                style("HospitalName", "");
                style("HospitalClass", "");
            }
            else {
                document.getElementById('Hospital_Table_1').style.display = "none";  //隱藏醫療院所、就醫類型
            }
        }


        function ServiceNameChanged() {
            document.getElementById('button_01').style.display = "none";  //客戶地址
            document.getElementById('button_02').style.display = "none";  //單位地址
            document.getElementById("txt_Location").innerHTML = "";
            document.getElementById("hid_PostCode").value = "";
            var str_index = document.getElementById("DropServiceName").selectedIndex;
            var v = document.getElementById("DropServiceName").options[str_index].value;
            $.ajax({
                url: '0030010100.aspx/ServiceName_Flag',
                type: 'POST',
                data: JSON.stringify({ Service_ID: v }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "A") {
                        document.getElementById('button_02').style.display = "";  //單位地址
                    } else if (json.status == "B") {
                        v = "39";
                        document.getElementById('button_02').style.display = "";  //單位地址
                    } else if (json.status == "C") {
                        document.getElementById('button_01').style.display = "";  //客戶地址
                    }
                    Location(v);
                    document.getElementById('tab_Location').style.display = "";  //顯示地址
                }
            });
        }

        function Select_Telecomm() {
            $.ajax({
                url: '0030010100.aspx/Select_Telecomm',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#SelectTelecomm");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.B + "'>" + obj.A + "</option>");    // 選擇電信商,  obj.A 來自 Telecomm 資料
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
        

 /*       function Client_Code_Search() {
            $.ajax({
                url: '0030010100.aspx/Client_Code_Search',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropClientCode");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.B + "'>[" + obj.B + "]" + obj.A + "</option>");     // 顯示客戶代碼選單
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }   */

        function ShowClientData() {                     // 提出客戶代碼
            var str_index = document.getElementById("DropClientCode").value;
            $.ajax({
                url: '0030010100.aspx/Show_Client_Data',
                type: 'POST',
                data: JSON.stringify({ value: str_index }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    document.getElementById("str_Client_Name").innerHTML = obj.data[0].C;
                    document.getElementById("str_contact").innerHTML = obj.data[0].D;
                    //document.getElementById("str_com_tel").innerHTML = "("+ obj.data[0].E + ")" + obj.data[0].F;
                    document.getElementById("str_mob_phone").innerHTML = obj.data[0].G;
                    document.getElementById("str_hardware").innerHTML = obj.data[0].H;
                    document.getElementById("str_software").innerHTML = obj.data[0].I;
                    document.getElementById("str_serv_typ").innerHTML = obj.data[0].J;
                }
            });
        }

 /*       function ShowCaseData() {
            var str_index = document.getElementById("DropClientCode").value;
            $.ajax({
                url: '0030010099.aspx/Show_Client_Data',
                type: 'POST',
                data: JSON.stringify({ value: str_index }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    document.getElementById("str_Client_Name").innerHTML = obj.data[0].C;
                    document.getElementById("str_contact").innerHTML = obj.data[0].D;
                    document.getElementById("str_com_tel").innerHTML = "(" + obj.data[0].E + ")" + obj.data[0].F;
                    document.getElementById("str_mob_phone").innerHTML = obj.data[0].G;
                    document.getElementById("str_hardware").innerHTML = obj.data[0].H;
                    document.getElementById("str_software").innerHTML = obj.data[0].I;
                    document.getElementById("str_serv_typ").innerHTML = obj.data[0].J;
                }
            });
        }           */

        function Eng_Name_Search() {
            $.ajax({
                url: '0030010100.aspx/Eng_Name_Search',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropEngName");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.B + "'>[" + obj.B + "]" + obj.A + "</option>");
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

        function Eng_Name_Search_Reg() {
            $.ajax({
                url: '0030010100.aspx/Eng_Name_Search_Reg',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropEngNameReg");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.B + "'>[" + obj.B + "]" + obj.A + "</option>");
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

        function Data_Save_Maintenance() {                  //右方 存入 左方
            
            var str_sysid = document.getElementById("str_sysid").innerHTML;
            var str_maintenance_eng_id = document.getElementById("DropEngName").value;
            
            
            $.ajax({
                url: '0030010100.aspx/Case_Save_Maintenance',
                type: 'POST',
                data: JSON.stringify({
                    sysid: str_sysid,
                    maintenance_eng_id: str_maintenance_eng_id,
                    maintenance_case_status : 0,
                    
                    
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert('新增完成');
                        window.location.href = "/0030010000/0030010100.aspx";
                    }
                    else if (json.status == "update") {
                        alert('修改完成');
                        window.location.href = "/0030010000/0030010100.aspx";
                    }
                    else {
                       
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    document.getElementById("Btn_New").disabled = false;
                }, error: function () { alert("請選擇處理人員"); }
            });
        }   
        
        function Data_Save_Reg_Check() {

            var str_sysid = document.getElementById("str_sysid").innerHTML;
            var str_maintenance_eng_id = document.getElementById("Select_Reg_Check_Eng").value;

            $.ajax({
                url: '0030010100.aspx/Case_Save_Reg_Check',
                type: 'POST',
                data: JSON.stringify({
                    sysid: str_sysid,
                    
                    reg_check_eng_id: str_reg_check_eng_id,

                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert('新增完成');
                        window.location.href = "/0030010000/0030010100.aspx";
                    }
                    else if (json.status == "update") {
                        alert('修改完成');
                        window.location.href = "/0030010000/0030010100.aspx";
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    document.getElementById("Btn_New").disabled = false;
                }, error: function () { alert("請填完所有必填欄位"); }
            });
        }
        
        function Owner_List() {
            $.ajax({
                url: '0030010100.aspx/Owner_List',
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

        //================ 帶入【客戶地址】資訊 ===============
        function Cust_Table() {
            $("#Cust_Table").dataTable({
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
                "sAjaxSource": "../WebService.asmx/Cust_System",
                "sServerMethod": "POST",
                "contentType": "application/json; charset=UTF-8",
                "sPaginationType": "full_numbers",
                "bDeferRender": true,
                "fnServerParams": function (aoData) {
                    aoData.push(
                        { "name": "iParticipant", "value": $("#participant").val() },
                        { "name": "Cust_ID", "value": "" }
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
                                $("#Cust_System").show();
                            }
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
                url: '0030010100.aspx/Hospital_List',
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
                url: '0030010100.aspx/GetCNoList',
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
            var MNo = new_mno;
            $.ajax({
                url: '0030010100.aspx/Labor_Value',
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
                            url: '0030010100.aspx/Btn_Add_Click',
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
                url: '0030010100.aspx/Labor_Delete',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function () {
                }
            });
            bindTable();
        }

       //================   Load_CaseData()      讀取 00000
        function Load_CaseData() {                        
            $.ajax({
                url: '0030010100.aspx/Load_CaseData',
                type: 'POST',
                data: JSON.stringify({ CaseData: new_mno }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                   
                    //ServiceChanged();
// alert(obj.data[0].OpinionSubject);       // 跳出視窗 測試用
                    //document.getElementById("txt_SYS_ID").innerHTML = obj.data[0].SYS_ID;                       
                    //document.getElementById("Show_C_ID").innerHTML = obj.data[0].Case_ID;
                    //document.getElementById("Show_T_ID").innerHTML = obj.data[0].K;
                    //document.getElementById("Show_TValue").innerHTML = obj.data[0].Type_Value;
                    //document.getElementById("Show_T").innerHTML = obj.data[0].Type;
                    //document.getElementById("Show_CName").innerHTML = obj.data[0].Cust_Name;
                    //document.getElementById("Show_U").innerHTML = obj.data[0].Urgency;
                    //document.getElementById("Show_O_Source").innerHTML = obj.data[0].OpinionSource;
                    //document.getElementById("Show_O_Type").innerHTML = obj.data[0].OpinionType;                  
                    //document.getElementById("Show_O_Subject").innerHTML = obj.data[0].OpinionSubject;
                    document.getElementById("Show_R_T").innerHTML = obj.data[0].ReplyType;
                    document.getElementById("Show_PS").innerHTML = obj.data[0].PS;
                    document.getElementById("Show_DProcess").value = obj.data[0].DealingProcess;
                    document.getElementById("Show_Reply").innerHTML = obj.data[0].Reply;                    
                    document.getElementById("Show_U_Time").innerHTML = obj.data[0].Upload_Time;
                    //document.getElementById("DropClientCode").innerHTML = obj.data[0].ID;                    
                    document.getElementById("Show_O_Content").innerHTML = obj.data[0].OpinionContent;
                    document.getElementById("picker02").innerHTML = obj.data[0].EstimatedFinishTime;                    
                    document.getElementById("picker01").innerHTML = obj.data[0].OnSpotTime;                    
                    
                    document.getElementById("DropClientCode").innerHTML = obj.data[0].B;
                    document.getElementById("str_Client_Name").innerHTML = obj.data[0].C;
                    document.getElementById("str_contact").innerHTML = obj.data[0].D;
                    //document.getElementById("str_com_tel").innerHTML = "(" + obj.data[0].E + ")" + obj.data[0].F;
                    document.getElementById("str_mob_phone").innerHTML = obj.data[0].G;
                    document.getElementById("str_hardware").innerHTML = obj.data[0].H;
                    document.getElementById("str_software").innerHTML = obj.data[0].I;
                    document.getElementById("str_serv_typ").innerHTML = obj.data[0].J;

                    //alert(obj.data[0].Telecomm_ID);                    
                    //style("Show_T_ID", "obj.data[0].Telecomm_ID");                    
                    //document.getElementById("datetimepicker01").value = obj.data[0].OnSpotTime.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_01.substr(11, 5);
                    //document.getElementById("datetimepicker02").value = obj.data[0].EstimatedFinishTime.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_02.substr(11, 5);
                    //alert(obj.data[0].Telecomm_ID);
                    
                    switch (obj.data[0].Telecomm_ID) {          //負責電信商
                        case "1": document.getElementById("Show_T_ID").innerHTML = "中華電信"; break;
                        case "2": document.getElementById("Show_T_ID").innerHTML = "遠傳電信"; break;
                        case "3": document.getElementById("Show_T_ID").innerHTML = "德瑪科技"; break;
                        default:   document.getElementById("Show_T_ID").innerHTML = "無負責電信商";
                            //break;
                    }
                    switch (obj.data[0].Urgency) {          //緊急程度
                        case "0": document.getElementById("Show_U").innerHTML = "維護"; break;
                        case "1": document.getElementById("Show_U").innerHTML = "緊急故障"; break;
                        case "2": document.getElementById("Show_U").innerHTML = "重要故障"; break;
                        case "3": document.getElementById("Show_U").innerHTML = "一般故障"; break;
                        default: document.getElementById("Show_U").innerHTML = "未紀錄";
                            break;
                    } 
                   //switch (obj.data[0].OpinionSource) {          //意見來源
                       //case "0": document.getElementById("Show_O_Source").innerHTML = "電話"; break;
                       //case "1": document.getElementById("Show_O_Source").innerHTML = "e-mail"; break;
                      // case "2": document.getElementById("Show_O_Source").innerHTML = "傳真"; break;
                      // case "3": document.getElementById("Show_O_Source").innerHTML = "合約"; break;
                       //case "4": document.getElementById("Show_O_Source").innerHTML = "保固"; break;
                       //default: document.getElementById("Show_O_Source").innerHTML = "未紀錄";
                            //break;
                   // }
                   switch (obj.data[0].OpinionType) {          //意見類型
                       case "0": document.getElementById("Show_O_Type").innerHTML = "故障報修"; break;
                       case "1": document.getElementById("Show_O_Type").innerHTML = "軟體修改"; break;
                       case "2": document.getElementById("Show_O_Type").innerHTML = "技術諮詢"; break;
                       case "3": document.getElementById("Show_O_Type").innerHTML = "其他服務"; break;
                       case "4": document.getElementById("Show_O_Type").innerHTML = "定期維護"; break;
                       case "1": document.getElementById("Show_O_Type").innerHTML = "測試"; break;
                       case "2": document.getElementById("Show_O_Type").innerHTML = "專案"; break;
                       case "3": document.getElementById("Show_O_Type").innerHTML = "設備擴充"; break;
                       case "4": document.getElementById("Show_O_Type").innerHTML = "駐點服務"; break;
                       default: document.getElementById("Show_O_Type").innerHTML = "未紀錄";
                           break;
                   }
 /*                  if (obj.data[0].DealingProcess != "") {                       
                       style("Show_DProcess ", "1");
                       alert(obj.data[0].DealingProcess);
                   }    */
                    //alert(12345);      跳出提醒訊息(測試用)
                   switch (obj.data[0].DealingProcess) {          //處理狀態
                       case "0": document.getElementById("Show_DProcess").innerHTML = "處理中"; break;
                       case "1": document.getElementById("Show_DProcess").innerHTML = "結案"; break;
                       default: document.getElementById("Show_DProcess").innerHTML = "未紀錄";
                           break;
                   }
                   //style("HospitalName", "");
                }
            });
            //document.getElementById('button_01').style.display = "none";  //客戶地址    額外的按鈕          
            //document.getElementById('button_02').style.display = "none";  //單位地址
            //document.getElementById('tab_Location').style.display = "";  //顯示地址
            $("#Div_Loading").modal('hide');        // 功能??
        }

        //================ 【取消需求單】 ===============
        function Btn_Cancel_Click() {
            $("#Div_Loading").modal();
            var txt_cancel = document.getElementById("txt_cancel").value;
            $.ajax({
                url: '0030010100.aspx/Btn_Cancel_Click',
                type: 'POST',
                data: JSON.stringify({ txt_cancel: txt_cancel }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "success") {
                        alert('需求單【' + json.mno + '】已取消');
                        window.location.href = "/0030010000/0030010002.aspx";
                    }
                    else {
                        alert(json.status);
                    }
                }
            });
            $("#Div_Loading").modal('hide');
        };

        //================== 【返回】 =================
        function Btn_Back_Click() {
            window.location.href = "/0030010002.aspx";
        };

        //============= 顯示【地址】名單 =============
        function Location(Type) {
            $.ajax({
                url: '0030010100.aspx/Location_List',
                type: 'POST',
                data: JSON.stringify({ Type: Type }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#Location_Table').DataTable({
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
                        "aLengthMenu": [[10, 25, 50, 100], [10, 25, 50, 100]],
                        "iDisplayLength": 50,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                            { data: "Postcode" },
                            { data: "Location" },
                            { data: "Name" },
                            { data: "Address" },
                            { data: "TEL" },
                            {
                                data: "SYS_ID", render: function (data, type, row, meta) {
                                    return "<button id='edit' type='button' class='btn btn-success btn-lg' data-dismiss='modal'>" +
                                        "<span class='glyphicon glyphicon-ok'></span>&nbsp;&nbsp;選擇</button>"
                                }
                            }
                        ]
                    });
                    //================================================
                    $('#Location_Table tbody').unbind('click').
                    on('click', '#edit', function () {
                        var table = $('#Location_Table').DataTable();
                        var SYS_ID = table.row($(this).parents('tr')).data().SYS_ID;
                        Add_Location(SYS_ID, "0");
                    });
                }
            });
        }

        function Add_Location(ID, Flag) {
            $.ajax({
                url: '0030010100.aspx/Add_Location',
                type: 'POST',
                data: JSON.stringify({ ID: ID, Flag: Flag }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    document.getElementById("txt_Location").innerHTML = "名稱：【" + obj.data[0].Name + " - " + obj.data[0].Location +
                        "】地址：【" + obj.data[0].Postcode + "】【" + obj.data[0].Address + "】";
                    document.getElementById("hid_PostCode").value = obj.data[0].Postcode;
                }
            });
        }
        //style("SelectOpinionType_chosen", "8");
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

        #Location_Table td:nth-child(6), #Location_Table td:nth-child(5), #Location_Table td:nth-child(4),
        #Location_Table td:nth-child(3), #Location_Table td:nth-child(2), #Location_Table td:nth-child(1),
        #Cust_Table td:nth-child(7), #Cust_Table td:nth-child(6), #Cust_Table td:nth-child(5),
        #Cust_Table td:nth-child(4), #Cust_Table td:nth-child(3), #Cust_Table td:nth-child(2), #Cust_Table td:nth-child(1),
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
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="MyCust" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 95%;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>選擇客戶地址</strong></h2>

                </div>
                <div class="modal-body">
                    <%-- ========================================== --%>
                    <table id="Cust_Table" class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center; width: 15%">客戶編號</th>
                                <th style="text-align: center; width: 15%">客戶名稱</th>
                                <th style="text-align: center; width: 15%">郵遞區號</th>
                                <th style="text-align: center; width: 15%">客戶地址</th>
                                <th style="text-align: center; width: 15%">客戶電話</th>
                                <th style="text-align: center; width: 15%">統一編號</th>
                                <th style="text-align: center; width: 10%">選擇</th>
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
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="Modal_1" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 95%;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>選擇單位地址</strong></h2>
                </div>
                <div class="modal-body">
                    <%-- ========================================== --%>
                    <table id="Location_Table" class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center; width: 17%">郵遞區號</th>
                                <th style="text-align: center; width: 17%">區域名稱</th>
                                <th style="text-align: center; width: 17%">單位名稱</th>
                                <th style="text-align: center; width: 17%">地址</th>
                                <th style="text-align: center; width: 17%">電話</th>
                                <th style="text-align: center; width: 15%">選擇</th>
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
    <!--=========================================-->  <%-- 表格 Table 000--%>
    <div style="width: 1280px; margin: 10px 20px">
        <h2><strong>(<%= str_title %>)服務作業單</strong></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>案件資料紀錄</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%;">
                        <strong>案件編號</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="str_sysid"></label>
                        <strong><%= str_type %></strong>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>負責電信商</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="Show_T_ID" name="Show_T_ID" ></label>                        
                    </th>
                </tr>
                <%--  =========== 登錄日期 ===========--%>
                <tr id="tr_sysid" runat="server">                                                       <%--  Table 001--%>
                    <td style="text-align: center">
                        <strong>登錄日期</strong>
                    </td>
                    <td>
                        <label id="Show_U_Time"  ></label>
  <%--                       <div style="float: left" data-toggle="tooltip" title="必填">
                            <input type="text" class="form-control" id="Show_U_Time" name="Show_U_Time" style="background-color: #ffffbb" value=""/>
                        </div>      --%>     
                    </td>
                    <td style="text-align: center">
                        <strong>登錄人員</strong>
                    </td>
                    <td>
                        <strong>系統管理者</strong>
                        <!-- id待建立 -->
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center">
                        <strong>來電號碼</strong>
                    </td>
                    <td>
                        <label id="str_name"></label>
                    </td>
                    <td style="text-align: center">
                        <strong></strong>
                    </td>
                    <td>
                        <%-- <label id="str_team"></label>--%>
                    </td>
                </tr>

        <%--  =========== 勞工資料 ===========--%>
        <table class="table table-bordered table-striped">                      <%--  Table 002-1  --%>
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
                        <strong>客戶代碼(*)
                            <br>
                            <input type="checkbox" name="e-mail" value="1">發送email
                        </strong>
                    </th>
                    <th style="width: 35%">
                        
                        <div data-toggle="tooltip" style="width: 100%">
                            <label id="DropClientCode"></label>
                            <%--  title="必選" 
                            <select id="DropClientCode" name="DropClientCode" class="chosen-select" onchange="ShowClientData()">
                                <option value="">請選擇</option>
                            </select>       --%>
                        </div>
                    </th>
                    <td style="text-align: center; width: 15%">
                        <strong>客戶名稱</strong>
                    </td>
                    <td style="width: 35%">
                        <label id="str_Client_Name"></label>

                    </td>
                </tr>
                <%--  =========== 客戶資料 ===========--%>
                <tr style="height: 55px;">                                                          <%--  Table 002-2  --%>
                    
                    <td style="text-align: center; width: 15%">
                        <strong>聯絡人</strong>
                    </td>
                    <td style="width: 35%">
                        <label id="str_contact"></label>
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

                <%--  =========== 勞工資料 ===========--%>

               
                <%--  =========== 勞工資料 ===========--%>
                <tr>
                    <td colspan="4" style="text-align: center">
                        <input id="hid_PostCode" name="hid_PostCode" type="hidden" />
                         <%--
                        <button id="Btn_Update" type="button" onclick="Btn_New_Click('1');" class="btn btn-primary btn-lg "><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>&nbsp; &nbsp;
                        --%>
                    </td>
                </tr>
            </tbody>
        </table>

        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">                                                             <%--  Table 003  --%>
                        <span style="font-size: 20px"><strong>反應內容</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>緊急程度(*)</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip"  style="width: 100%">
                            <label id="Show_U" name="Show_U" ></label>  
                            <%--    title="必選"
                            <select id="Show_U" name="Show_U" class="chosen-select" style="background-color: #ffffbb">
                                --<option value="">請選擇緊急程度...</option>
                                <option value="0">維護</option>
                                <option value="1">緊急故障</option>
                                <option value="2">重要故障</option>
                                <option value="3">一般故障</option>
                            </select>--%>
                        </div>
                    </th>
                    <td style="text-align: center; width: 15%">
                        <strong>預定完成日(*)</strong>
                    </td>
                    <td style="width: 35%"> 
                            <label id="picker02"  ></label>
                        
                    </td>
                    
                </tr>
                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    
                    <th style="text-align: center; width: 15%">
                        <strong>意見類型(*)</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip"  style="width: 100%">
                            <label id="Show_O_Type" name="Show_O_Type" ></label> 
                            
                        </div>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>意見內容</strong>
                    </th>
                    <th style="width: 35%">
                        
                        <div data-toggle="tooltip"  style="width: 100%">
                            <label id="Show_O_Content" name="Show_T_ID" ></label>  
                           
                        </div>
                    </th>
                    
                </tr>

                <%--  =========== 勞工資料 ===========--%>
                
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>回覆方式</strong>
                    </td>
                    <td>
                        <label id="Show_R_T"  ></label>
                    </td>
                    <td style="text-align: center">
                        <strong>到點時間</strong>
                    </td>
                    <td>
                        <label id="picker01"  ></label>
                    </td>
                </tr>

                <%--  =========== 勞工資料 ===========--%>
                
                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>處理日期</strong>
                    </td>
                    <td>
                        <label id="Label7"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>處理人員</strong>
                    </td>
                    <td>
                        <strong>系統管理員</strong>
                    </td>
                </tr>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>備註</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="">
                            <label id="Show_PS"  ></label>
                            <%--
                            <textarea id="Show_PS" name="Show_PS" class="form-control" cols="45" rows="3" placeholder="備註" maxlength="400" onkeyup="cs(this);"
                                style="resize: none;"></textarea>--%>
                        </div>
                    </td>
                    <td style="text-align: center">
                        <strong>處理狀態(*)</strong>
                    </td>
                    <td>
                        <div data-toggle="tooltip" " style="width: 100%">
                            <label id="Show_DProcess" name="Show_DProcess" ></label>        
<%-- title="必選    
                                <select id="Show_DProcess" name="Show_DProcess" class="chosen-select" style="background-color: #ffffbb">
                                <option value="">-請選擇</option>
                                <option value="0">處理中</option>
                                <option value="1">結案</option>--%>

                            </select>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>客服處理</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>客服處理<br />
                            回覆內容</strong>
                    </th>
                    <th style="width: 85%">
                        <div style="float: left" data-toggle="tooltip" title="">
                            <textarea id="Show_Reply" name="Show_Reply" class="form-control" cols="45" rows="3" placeholder="客服處理 回覆內容" maxlength="400" onkeyup="cs(this);"
                                style="resize: none;"></textarea>
                        </div>
                    </th>

                </tr>

            </tbody>
        </table>

                <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>新增維護單或保養單</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center;  line-height:60px; width: 15%">
                        <strong >新增維護單</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip"  style="width: 100%">
                            <!--<select id="Select_Maintenance_Eng" name="SelectUrgency" class="chosen-select" onchange="">
                                <option value="">請選擇處理人員.</option>
                                <option value="0"></option>
                                <option value="1">甲</option>
                                <option value="2">乙</option>
                                <option value="3">丙</option>
                            </select>-->
                            <select id="DropEngName" name="DropEngName" class="chosen-select">
                                <option value="">請選擇處理人員</option>
                            </select>

                        </div>
                        <button  style="float:right" id="Button2" type="button" onclick="Data_Save_Maintenance()" class="btn btn-success btn-lg ">&nbsp;&nbsp;新增維護單</button>
                    </th>
                    <th style="text-align: center; width: 15%; line-height:60px;" >
                        <strong>新增保養單</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip"  style="width: auto">
                            <select id="DropEngNameReg" name="DropEngName" class="chosen-select">
                                <option value="">請選擇處理人員</option>
                            </select>
                            <button style="float:right" id="Button4" type="button" onclick="Data_Save_Reg_Check()" class="btn btn-success btn-lg ">&nbsp;&nbsp;新增月保養單</button>
                        </div>
                        
                    </th>
                </tr>

            </tbody>
        </table>

        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>結案資料</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>滿意度(*)</strong>
                    </th>
                    <th style="width: 35%"></th>
                    <th style="text-align: center; width: 15%">
                        <strong>結案日期</strong>
                    </th>
                    <th style="width: 35%"></th>

                </tr>

            </tbody>
        </table>
         <%--       
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>案件歷史紀錄</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>客戶名稱</strong>
                    </th>
                    <th style="width: 85%">
                        <input name="client_search" type="text" maxlength="20" id="client_search" title="客戶名稱" class="form-control" style="float: left; margin-right: 10px;" />&nbsp;
                        <button id="Button2" type="button" class="btn btn-success btn-lg " style="float: left">搜尋</button>
                    </th>

                </tr>

            </tbody>
        </table>        --%>

        <%--=========== 子單 ===========--%>

        <div style="text-align: center">
            <%--
            <button id="Button1" type="button" onclick="Data_Save();" class="btn btn-success btn-lg "><span class="glyphicon glyphicon-ok"></span>確定&nbsp;&nbsp;</button>
            --%>
            
            <!--<button id="Button2" type="button" onclick="self.location.href='0030010002.aspx;'" class="btn btn-success btn-lg ">&nbsp;&nbsp;新增月保養單</button>-->
            <button id="Button3" type="button" onclick="Btn_Back_Click();" class="btn btn-default btn-lg ">&nbsp;&nbsp;返回<span class="glyphicon glyphicon-share-alt"></span></button>
            
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
            $('#datetimepicker03').datetimepicker({
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
