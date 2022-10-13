<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0250010000.aspx.cs" Inherits="_0250010000" %>

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
        var new_mno2 = '<%= mno3 %>';
        var Agent_Mail = '<%= Session["Agent_Mail"] %>';
        //====================================================
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            Load();
            Select_Title_ID();      //維護客戶號 下拉
            List_Agent();           //員工 下拉
            //Load_Data //讀取速度問題 移到 List_Agent 末了
            //Client_Code_Search();       //選客戶
                document.getElementById('Tr_Cancel').style.display = "none";  //隱藏 取消原因
                document.getElementById('Button4').style.display = "none";  //隱藏取消鈕
            if (seqno != '0') {
                document.getElementById('Button1').style.display = "none";  //隱藏確定鈕
                document.getElementById('Button5').style.display = "none";  //隱藏 補單號 鈕
                document.getElementById("str_title").innerHTML = "(修改)維護單作業";
                //Load_Data();
                //document.getElementById('Tr_Cancel').style.display = "";  //顯示取消鈕
            }
            else {
                document.getElementById("str_title").innerHTML = "(新增)維護單作業";
                document.getElementById('Button2').style.display = "none";  //隱藏修改鈕
                document.getElementById('Button5').style.display = "none";  //隱藏 補單號 鈕
                ShowTime();             //抓時間         
            }
        });

        //================ 讀取資訊 ===============
        function Load() {
            if (seqno == '0') {
                document.getElementById("str_sysid").value = new_mno; //【創造母單編號】
                document.getElementById("str_sysid2").innerHTML = new_mno2; //【假母單編號】
                $.ajax({
                    url: '0250010000.aspx/Load',
                    type: 'POST',
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        document.getElementById('Text2').value = obj.data[0].Agent_Name;
                        var Agent_ID = obj.data[0].Agent_ID;                        
                    }
                });
            } else {
                document.getElementById("str_sysid").value = seqno; //隱藏看不見的
                document.getElementById("str_sysid2").innerHTML = seqno;
            }
        }

        function ShowTime() {
            $.ajax({
                url: '0250010000.aspx/ShowTime',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    document.getElementById('LoginTime').innerHTML = doc.d;
                }
            });
        }

        function Creat_ID() {
            var time = document.getElementById("datetimepicker02").value;
            document.getElementById('LoginTime').innerHTML = document.getElementById("datetimepicker02").value;
            $.ajax({
                url: '0250010000.aspx/Creat_ID',
                type: 'POST',
                data: JSON.stringify({ time: time }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    document.getElementById("str_sysid").value = json.Int2;
                    document.getElementById("str_sysid2").innerHTML = json.Int1;
                }
            });
        }

        //================   Load_CaseData()       
        function Load_Data() {
            var Case_ID = document.getElementById("str_sysid").value;
            //alert(Case_ID);
            //str_title = "修改";
            $.ajax({
                url: '0250010000.aspx/Load_Data',
                type: 'POST',
                data: JSON.stringify({ Case_ID: Case_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    
                    document.getElementById("Text2").value = obj.data[0].A;
                    document.getElementById("LoginTime").innerHTML = obj.data[0].B;
                    style('Title_ID', obj.data[0].C);
                    if (obj.data[0].D == "中華電信" || obj.data[0].D == "遠傳" || obj.data[0].D == "德瑪")
                        document.getElementById("New_T_ID").value = obj.data[0].D;
                    else
                        document.getElementById("New_T_ID").value = "其他";
                    document.getElementById("New_ADDR").value = obj.data[0].E;
                    document.getElementById("New_Name").value = obj.data[0].F;
                    document.getElementById("New_MTEL").value = obj.data[0].G;
                    document.getElementById("New_CycleTime").value = obj.data[0].H;
                    //document.getElementById("New_Agent").value = obj.data[0].I;
                    style('New_Agent', obj.data[0].I);
                    document.getElementById("datetimepicker01").value = obj.data[0].J;
                    document.getElementById("Type").innerHTML = obj.data[0].K;
                    document.getElementById("Reply").value = obj.data[0].L;

                    if (obj.data[0].K == "取消") { //obj.data[0].Agent_Team=="客服"
                        document.getElementById('Tr_Cancel').style.display = "";  //顯示取消原因
                        document.getElementById('Button2').style.display = "none";  //隱藏修改鈕
                    }
                    else if (obj.data[0].K == "已完成") { //obj.data[0].Agent_Team=="客服"
                        document.getElementById('Button2').style.display = "none";  //隱藏修改鈕
                    }
                    else if (obj.data[0].Agent_Company == "客服" && obj.data[0].K == "未到點"){
                        document.getElementById('Tr_Cancel').style.display = "";  //顯示取消原因
                        document.getElementById('Button4').style.display = "";  //顯示取消鈕
                    }
                }
            });
            $("#Div_Loading").modal('hide');        // 讀取中 圖示
        }
        
        function Select_Title_ID() {
            $.ajax({
                url: '0250010000.aspx/Select_Title_ID',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Title_ID");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.A + "'>【" + obj.A +"】"+ obj.C + "</option>");
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
            if (seqno != '0')
                Load_Data();
        }
        function Show_Title() {     //選Title_ID後抓資料
            var ID = document.getElementById("Title_ID").value;
            $.ajax({
                url: '0250010000.aspx/Show_Title',
                type: 'POST',
                data: JSON.stringify({ value: ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    if (obj.data[0].A == "中華電信" || obj.data[0].A == "遠傳" || obj.data[0].A == "德瑪")
                        document.getElementById("New_T_ID").value = obj.data[0].A;
                    else
                        document.getElementById("New_T_ID").value = "其他";
                    document.getElementById("New_ADDR").value = obj.data[0].B;
                    document.getElementById("New_Name").value = obj.data[0].C;
                    document.getElementById("New_MTEL").value = obj.data[0].D;
                    document.getElementById("New_CycleTime").value = obj.data[0].E;
                    style("New_Agent", obj.data[0].F);
                    //document.getElementById("New_Agent").value = obj.data[0].E;
                    ShowMonths(obj.data[0].E);
                }
            });
        }
        function ShowMonths(Cycle) {
            //alert(Cycle);
            $.ajax({
                url: '0250010000.aspx/ShowMonths',
                type: 'POST',
                data: JSON.stringify({ value: Cycle }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    document.getElementById('Months').value = doc.d;
                }
            });
        }


        function Client_Code_Search() {     //選客戶
            $.ajax({
                url: '0250010000.aspx/Client_Code_Search',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropClientCode");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.C + "'>【" + obj.B + "】" + obj.A + "</option>");
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

        function Client_Code_Search2() {    //選子公司
            var str_index2 = document.getElementById("Label1").innerHTML;
            //alert(str_index2);
            $.ajax({
                url: '0250010000.aspx/Client_Code_Search2',
                type: 'POST',
                data: JSON.stringify({ PID: str_index2 }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#DropSubsidiaryCode");
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.B + "'>" + obj.A + "</option>");     // 顯示客戶代碼選單
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    //$('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        function ShowClientData() {     //選顧客後抓資料
            var str_index = document.getElementById("DropClientCode").value;
            Client_Code_Search2();     //子公司選單
            //List_Record(str_index);
            $.ajax({
                url: '0250010000.aspx/Show_Client_Data',
                type: 'POST',
                data: JSON.stringify({ value: str_index }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    document.getElementById("Label1").innerHTML = obj.data[0].A;
                    List_Record(obj.data[0].A);
                    document.getElementById("str_Client_Name").innerHTML = obj.data[0].C;
                    document.getElementById("str_contact").value = obj.data[0].D;//顯示成可更改的欄位
                    document.getElementById("str_mob_phone").value = obj.data[0].G;//顯示成可更改的欄位
                    document.getElementById("str_hardware").innerHTML = obj.data[0].H;
                    document.getElementById("str_software").innerHTML = obj.data[0].I;
                    document.getElementById("str_serv_typ").innerHTML = obj.data[0].J;
                    document.getElementById("str_telecomm_id").innerHTML = obj.data[0].K;
                    document.getElementById("Service_Location").value = obj.data[0].L;
                    //document.getElementById("txt_memo").innerHTML = obj.data[0].M;
                    document.getElementById("txt_Email").value = obj.data[0].N;
                    document.getElementById("str_id").innerHTML = obj.data[0].O;
                }
            });
        }

        function ShowSubsidiaryData() {
            var str_index_2 = document.getElementById("DropSubsidiaryCode").value;
            $.ajax({
                url: '0250010000.aspx/Show_Client_Data2',
                type: 'POST',
                data: JSON.stringify({ value_2: str_index_2 }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    document.getElementById("str_ID_2").innerHTML = obj.data[0].B;
                    document.getElementById("str_Client_Name_2").innerHTML =  obj.data[0].C;
                    document.getElementById("str_contact_2").value = obj.data[0].D;
                    document.getElementById("str_C_addr_2").value = obj.data[0].E;
                    //document.getElementById("str_fax_phone_2").value = obj.data[0].F;
                    document.getElementById("str_mob_phone_2").value = obj.data[0].G;
                    document.getElementById("str_hardware_2").innerHTML = obj.data[0].H;
                    document.getElementById("str_software_2").innerHTML = obj.data[0].I;
                }
            });
        }

        function List_Record(id) {  //列出顧客案件
            $.ajax({
                url: '0250010000.aspx/List_Record',
                type: 'POST',
                data: JSON.stringify({ id: id }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#tab_Record').DataTable({
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
                        "aLengthMenu": [[10,25, 50, 100], [10,25, 50, 100]],
                        "iDisplayLength": 10,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                                { data: "A" },
                                { data: "B" },
                                { data: "C" },
                                { data: "D" },
                                { data: "E" },
                                { data: "F" },
                                { data: "G" }
                        ]
                    });
                }
            });
        }

        function Data_Save() {

            //var str_sysid = document.getElementById("str_sysid").value;
            var str_sysid2 = document.getElementById("str_sysid2").innerHTML;
            var Text2 = document.getElementById("Text2").value;     // 建單人            
            var str_login_time = document.getElementById("LoginTime").innerHTML;

            var str_id = document.getElementById("Title_ID").value;     //             
            var str_t_id = document.getElementById("New_T_ID").value;     //             
            var str_addr = document.getElementById("New_ADDR").value;     //             
            var str_name = document.getElementById("New_Name").value;     //             
            var str_mtel = document.getElementById("New_MTEL").value;     //             
            var str_cycletime = document.getElementById("New_CycleTime").value;     //             
            var str_agent = document.getElementById("New_Agent").value;     //             
            var str_spottime = document.getElementById("datetimepicker01").value;     //             
           
            //$("#Div_Loading").modal();
            $.ajax({
                url: '0250010000.aspx/Case_Save',
                type: 'POST',
                data: JSON.stringify({
                    //sysid: str_sysid,
                    sysid2: str_sysid2,
                    Creat_Agent: Text2,
                    login_time: str_login_time,
                    spottime: str_spottime,

                    id: str_id,
                    t_id:     str_t_id,
                    addr: str_addr,
                    name: str_name,
                    mtel: str_mtel,
                    cycletime: str_cycletime,
                    agent: str_agent,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        //alert('新增完成');
                        window.location.href = "/0030010000/0030010007.aspx";     //
                    }
                    else if (json.status == "update") {
                        //alert('修改完成');
                        window.location.href = "/0030010000/0030010007.aspx";
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                },
                error: function () { alert("新增服務單發生錯誤"); }
                //error: function () { alert("請填完所有必填欄位"); }
            });
        }

        function Data_Update() {

            var str_sysid2 = document.getElementById("str_sysid2").innerHTML;
            var Text2 = document.getElementById("Text2").value;     // 建單人            
            var str_spottime = document.getElementById("datetimepicker01").value;     //        
            var str_id = document.getElementById("Title_ID").value;     //             
            var str_t_id = document.getElementById("New_T_ID").value;     //             
            var str_addr = document.getElementById("New_ADDR").value;     //             
            var str_name = document.getElementById("New_Name").value;     //             
            var str_mtel = document.getElementById("New_MTEL").value;     //             
            var str_cycletime = document.getElementById("New_CycleTime").value;     //             
            var str_agent = document.getElementById("New_Agent").value;     //                  
            $.ajax({
                url: '0250010000.aspx/Case_Update',
                type: 'POST',
                data: JSON.stringify({
                    sysid2: str_sysid2,
                    Creat_Agent: Text2,
                    spottime: str_spottime,
                    id: str_id,
                    t_id: str_t_id,
                    addr: str_addr,
                    name: str_name,
                    mtel: str_mtel,
                    cycletime: str_cycletime,
                    agent: str_agent,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert('新增完成');
                        window.location.href = "/0030010000/0030010007.aspx";
                    }
                    else if (json.status == "update") {
                        alert('修改完成');
                        //URL();
                        window.location.href = "/0030010000/0030010007.aspx";
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                },
                error: function () { alert("修改維護單發生錯誤"); }
            });
        }

        //=============== 帶入【新增雇主及外勞】資訊 ===============
        function Labor_add(SYSID, Flag) {
            var MNo = new_mno;
            $.ajax({
                url: '0250010000.aspx/Labor_Value',
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
                            url: '0250010000.aspx/Btn_Add_Click',
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
                url: '0250010000.aspx/Labor_Delete',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function () {
                }
            });
            bindTable();
        }
        
        //================ 【取消服務單】 ===============
        function Cancel() {
            $("#Div_Loading").modal();
            var str_sysid = document.getElementById("str_sysid2").innerHTML;
            var str_rep = document.getElementById("Reply").value;
            $.ajax({
                url: '0250010000.aspx/Cancel',
                type: 'POST',
                data: JSON.stringify({ sysid: str_sysid,rep: str_rep}),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "success") {
                        alert('維護單單【' + json.mno + '】已取消');
                        window.location.href = "/0030010000/0030010007.aspx";
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
            window.location.href = "/0030010000/0030010007.aspx";
        };

        //============= 顯示【地址】名單 =============
        function Add_Location(ID, Flag) {
            $.ajax({
                url: '0250010000.aspx/Add_Location',
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

        function List_Dispatch_Team() {     //選派工部門選項(停用)
            $.ajax({
                url: '0250010000.aspx/List_Dispatch_Team',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Chose_Company");
                    $select_elem.chosen("destroy")
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.A + "'>" + obj.A + "</option>");
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

        function List_Agent() {
            $.ajax({
                url: '0250010000.aspx/List_Agent',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#New_Agent");     //派公人員選項
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇維護人員…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.B + "'>" + obj.A + "</option>");
                        //document.getElementById("A_ID").value = obj.B;      //data[0].
                        //document.getElementById("Handle_Agent").value = obj.A;      //data[0].
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });                                        
                    $('.chosen-single').css({ });// 'background-color': '#ffffbb'
                }
            });
            if (seqno != '0')
                Load_Data();
        }

        // ===================確認新增頁面派工
        function Send_Save() {
            var str_sysid = document.getElementById("str_sysid").value;
            var value = document.getElementById("Dispatch_Name").value;
            //var PS = document.getElementById("Agent_PS").value;
            var C_Name = document.getElementById("str_Client_Name").innerHTML;
            var S_O_Type = document.getElementById("SelectOpinionType").value;
            //document.getElementById('Button5').style.display = "none";

            if (confirm("確認要派工並通知工程師嗎？"+"\n"+"(即使取消新增也會發送mail)")) {
                $.ajax({
                    url: '0250010000.aspx/Send_Save',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ sysid: str_sysid, value: value, C_Name: C_Name, S_O_Type: S_O_Type }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {
                            Show(value);          //顯示 處理人員                             
                            alert("派工成功");
                            document.getElementById('Button6').style.display = "none";      //隱藏派工紐
                        }
                        else alert(status);
                    }
                });
            }   //*/            
        };

        // ===================確認派工
        function Send() {
            var str_sysid = document.getElementById("str_sysid").value;
            var value = document.getElementById("Dispatch_Name").value;
            //var PS = document.getElementById("Agent_PS").value;
            var C_Name = document.getElementById("str_Client_Name").innerHTML;
            var S_O_Type = document.getElementById("SelectOpinionType").value;
            //document.getElementById('Button5').style.display = "none";
            
            if (confirm("確認要派工並通知工程師嗎？")) {
                $.ajax({
                    url: '0250010000.aspx/Send',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ sysid: str_sysid, value: value, C_Name: C_Name, S_O_Type: S_O_Type }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {   
                            Show(value);          //顯示 處理人員                             
                            alert("派工成功");
                            //document.getElementById('Button4').style.display = "none";      //隱藏派工紐
                            //document.getElementById('Button5').style.display = "none";
                        }
                        else alert(status);
                    }
                });
            }   //*/            
        };

        // ===================確認 轉派
        function Change() {
            var str_sysid = document.getElementById("str_sysid").value;
            var value = document.getElementById("Dispatch_Name").value;
            //var PS = document.getElementById("Agent_PS").value;
            var C_Name = document.getElementById("str_Client_Name").innerHTML;
            var S_O_Type = document.getElementById("SelectOpinionType").value;
            var value2 = document.getElementById("A_ID").innerHTML;
            //alert(value2);
            if (confirm("確認要轉派工並發送通知嗎？")) {
                $.ajax({
                    url: '0250010000.aspx/Change',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({
                        sysid: str_sysid,
                        value: value,
                        //PS: PS,
                        C_Name: C_Name,
                        S_O_Type: S_O_Type,
                        value2: value2
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {
                            //bindTable();
                            Show(value);    //顯示 處理人員                            
                            alert("轉派工完畢");
                        }
                        else alert(status);
                    }
                });
            }   //*/            
        };

        //============ 確認轉派公
        /*       function Change() {
                   if (confirm("確認轉派工並通知嗎？")) {
                       $.ajax({
                           url: '0060010004.aspx/Delete',
                           ache: false,
                           type: 'POST',
                           //async: false,
                           data: JSON.stringify({ Agent_ID: Agent_ID }),
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
               };      //*/

        function URL() {
            var Case_ID = document.getElementById("str_sysid").value;
            $.ajax({
                url: '0250010000.aspx/URL',
                type: 'POST',
                data: JSON.stringify({ Case_ID: Case_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.type == "ok") {
                        window.location = json.status;      //跳到status 紀錄的網址
                    } else {
                        alert(json.status);     //顯示status 紀錄的訊息
                    }
                }
            });
        }

        function Show(value) {
            $.ajax({
                url: '0250010000.aspx/Show',
                type: 'POST',
                data: JSON.stringify({ value: value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {                    
                        var text = '{"data":' + doc.d + '}';
                        var obj = JSON.parse(text);                        
                        document.getElementById("A_N").innerHTML = obj.data[0].A;
                        document.getElementById("A_ID").innerHTML = obj.data[0].B;      //data[0].
                        document.getElementById("UserID").value = obj.data[0].C;
                        //alert("A=" + A_ID);
                        //if (!A_ID.IsNullOrEmpty) document.getElementById('Button5').style.display = "";  //顯示轉派鍵                           
                }
            });
        }       
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
    <!-- ====== Loading ====== -->
    <div style="width: 1280px; margin: 10px 20px">
        <h2><label id="str_title"></label>
            <button id="Button5" type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#myModal" 
                style="Font-Size: 20px;" onclick="">產生補單編號</button> 
        </h2>
                                
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>維護單資料紀錄</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%;">
                        <strong>服務單編號</strong><br />   
                    </th>
                    <th style="width: 35%">
                        <label id="str_sysid2"></label>
                        <input id="str_sysid" name="str_sysid" type="hidden" />
                        <strong><%= str_type %></strong>
                    </th>
                    <td style="text-align: center">
                        <strong>建單人員</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="必填">
                            <input type="text" class="form-control" id="Text2" name="Text2" maxlength="20" style="background-color: #ffffbb" value="" />
                        </div>
                    </td>
                </tr>
                <tr id="tr_sysid" runat="server">
                    <td style="text-align: center">
                        <strong>建單日期</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="更改日期時間請用上方補單鈕">
                            <label id="LoginTime" name="LoginTime" ></label>
                        </div>
                    </td>
                     <th style="text-align: center; width: 15%">
                        <strong>維護客戶</strong>
                    </th>
                    <th style="width: 35%">
                        <select id="Title_ID" name="Title_ID" class="form-control" style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" onchange="Show_Title()">
                            <option value="">請選擇維護客戶…</option>
                        </select>
                    </th>
                </tr>                
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>維護廠商</strong>
                    </th>
                    <th style="width: 35%">
                        <select id="New_T_ID" name="New_T_ID" class="form-control" style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;">
                            <option value="">請選擇維護廠商…</option>
                            <option value="中華電信">中華電信</option>
                            <option value="遠傳">遠傳</option>
                            <option value="德瑪">德瑪</option>
                            <option value="其他">其他</option>
                        </select>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>維護地址</strong>
                    </th>
                    <th style="width: 35%">
                        <input id="New_ADDR" class="form-control" value="" maxlength="200" onkeyup="cs(this);"
                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                    </th>
                </tr>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>聯絡人</strong>
                    </th>
                    <th style="width: 35%">
                        <input id="New_Name" class="form-control" value="" maxlength="15" onkeyup="cs(this);"
                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>聯絡電話</strong>
                    </th>
                    <th style="width: 35%">
                        <input id="New_MTEL" class="form-control" value="" maxlength="25" onkeyup=""
                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                    </th>
                </tr>

                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>維護週期</strong></th>
                    <th style="width: 35%">
                        <select id="New_CycleTime" name="New_CycleTime" class="form-control"
                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;">
                            <option value="">請選擇維護週期…</option>
                            <option value="0">單月</option>
                            <option value="1">雙月</option>
                            <option value="2">每季</option>
                            <option value="3">半年</option>
                        </select>
                    </th>
                    <th style="text-align: center;">
                        <strong>負責工程師</strong>
                    </th>
                    <th>
                        <select id="New_Agent" name="New_Agent" class="form-control" style="width: 100%; Font-Size: 18px; color: #333333;">
                            <option value="">請選擇工程師…</option>
                        </select>
                    </th>
                </tr>
                <tr>
                    <th style="text-align: center; width: 15%">
                        <strong>預定維護日期</strong></th>
                    <td style="width: 35%">
                        <div style="float: left" data-toggle="tooltip" title="">
                            <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01" />
                        </div>
                    </td>
                    <th style="text-align: center; width: 15%">
                        <strong>案件狀態</strong></th>
                    <td style="width: 35%">
                        <label id="Type" style="Font-Size: 18px;"></label>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: center; width: 15%" hidden="hidden">
                        <strong>維護月份</strong></th>
                    <th style="width: 35%"hidden="hidden">
                        <input id="Months" class="form-control" value="" maxlength="20" onkeyup=";"
                            style="width: 100%; Font-Size: 18px; " />
                    </th>
                    <th style="text-align: center; width: 15%" hidden="hidden">
                        <strong>維護月份</strong></th>
                    <th style="width: 35%"hidden="hidden">
                        <input id="Text3" class="form-control" value="" maxlength="20" onkeyup=";"
                            style="width: 100%; Font-Size: 18px; " />
                    </th>
                </tr>
                <tr style="height: 55px;" id="Tr_Cancel">
                        <th style="text-align: center; width: 15%"><strong>取消原因</strong>
                        </th>
                        <th style="width: 85%"colspan="3">
                            <div style="float: left" data-toggle="tooltip" title="必填，不能超過250 個字元，並且含有不正確的符號">
                                <textarea id="Reply" name="Reply" class="form-control" cols="120" rows="3" placeholder="取消原因" maxlength="250" onkeyup="cs(this);"
                                    style="resize: none; background-color: #ffffbb"></textarea>
                            </div>
                        </th>
                    </tr>
            </tbody>
        </table>
          <!--===================================================-->      
        <div style="text-align: center">
            <button id="Button1" type="button" onclick="Data_Save();" class="btn btn-success btn-lg "><span class="glyphicon glyphicon-ok"></span>確定&nbsp;&nbsp;</button>&nbsp;&nbsp
            <button id="Button2" type="button" onclick="Data_Update();" class="btn btn-success btn-lg "><span class="glyphicon glyphicon-pencil"></span>修改&nbsp;&nbsp;</button>&nbsp;&nbsp
            <button id="Button3" type="button" onclick="history.back();" class="btn btn-default btn-lg ">&nbsp;&nbsp;返回<span class="glyphicon glyphicon-share-alt"></span></button>
            <!--Btn_Back_Click();-->
            <button id="Button4" type="button" onclick="Cancel();" class="btn btn-danger btn-lg " hidden="hidden"><span class="glyphicon glyphicon-remove"></span>&nbsp;&nbsp;取消維護單</button>
        </div>

        <!--=================================================== hidden="hidden"-->
        <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog" style="width: 500px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h2 class="modal-title"><strong>補單</strong></h2>
                    </div>
                    <div class="modal-body">
                        <table id="data2" class="table table-bordered table-striped" style="width: 99%">
                            <thead>
                                <tr>
                                    <th style="text-align: center" colspan="2">
                                        <span style="font-size: 20px"><strong>請填入補單時間</strong></span>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>
                                        <div style="float: left" data-toggle="tooltip" title="">
                                            <input type="text" class="form-control" id="datetimepicker02" name="datetimepicker02" />
                                        </div>
                                    </th>
                                    <th>
                                        <button type="button" class="btn btn-success"  data-dismiss="modal" onclick="Creat_ID()">確定</button>
                                        <button type="button" class="btn btn-default" data-dismiss="modal">關閉</button>
                                    </th>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
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

            $(function () {
                $('.chosen-select').chosen();
                $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
                $('.chosen-single').css({ 'background-color': '#ffffbb' });
            });
        </script>
    </div>
</asp:Content>
