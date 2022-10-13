<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0030010097.aspx.cs" Inherits="_0030010097" %>

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
            //List_Dispatch_Team();   //選部門
            //Change_Dispatch();
            //Client_Code_Search();       //選客戶
            //ShowTime();             //抓時間         
            document.getElementById('Button4').style.display = "none";
            document.getElementById('Button5').style.display = "none";
            if (seqno != '0') {
                document.getElementById("str_title").innerHTML = "個人派工單";
                Load_Data();                
            }
            else {
                alert('案件編號錯誤');
            }
            OE_Main_List();
            OE_Detail_List();
            bindTable();
            bindTable2();
        });

        //================ 讀取資訊 ===============
        function Load() {
            if (seqno == '0') {
                window.location.href = "/0030010000/0030010003.aspx?view=0";
                /*
                document.getElementById("str_sysid").value = new_mno; //【創造母單編號】
                $.ajax({
                    url: '0030010097.aspx/Load',
                    type: 'POST',
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        //document.getElementById('Text2').value = obj.data[0].Agent_Name;
                        //document.getElementById("str_name").innerHTML = obj.data[0].Agent_Name.trim();
                        //var A_T = obj.data[0].Agent_Team;  
                    }
                });*/
            } else {                
                document.getElementById("str_sysid").value = seqno;
                $.ajax({
                    url: '0030010097.aspx/Load',
                    type: 'POST',
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        var A_T = obj.data[0].Agent_Team;
                        var A_C = obj.data[0].Agent_Company;
                        if (A_C == "Engineer" && A_T == "Manager")
                            document.getElementById('Button5').style.display = "";
                        //alert("A" + A_C + "B" +A_T+ "C");
                    }
                });
            }
        }

        function ShowTime() {
            $.ajax({
                url: '0030010097.aspx/ShowTime',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    document.getElementById('LoginTime').value = doc.d;
                    //document.getElementById('EstimatedFinishTime').innerHTML = doc.d;
                }
            });
        }

        //================   Load_CaseData()       
        function Load_Data() {
            var Case_ID = document.getElementById("str_sysid").value;            
            //str_title = "修改";
            $.ajax({
                url: '0030010097.aspx/Load_Data',
                type: 'POST',
                data: JSON.stringify({ Case_ID: Case_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    
                    //document.getElementById("Textarea2").innerHTML = obj.data[0].Close_Out_PS;    //範例

                    //document.getElementById("str_sysid").value = obj.data[0].str_sysid ;      //已經有了
                    document.getElementById("str_sysid2").innerHTML = obj.data[0].Text0;
                    document.getElementById("Text1").innerHTML = obj.data[0].Text1;
                    document.getElementById("Text2").innerHTML = obj.data[0].Text2;     // 來電號碼+建單人            
                    document.getElementById("UpdateTime").innerHTML = obj.data[0].str_login_time; //時間會自動抓

                    document.getElementById("DropClientCode").innerHTML = obj.data[0].str_client_id;
                    //style('DropClientCode', obj.data[0].str_client_id);     //選項用?
                    //Client_Code_Search2();  //提取子公司選項
                    document.getElementById("str_id").innerHTML = obj.data[0].str_id;
                    document.getElementById("str_Client_Name").innerHTML = obj.data[0].str_B_Name;
                    document.getElementById("Service_Location").innerHTML = obj.data[0].str_addr;
                    document.getElementById("str_contact").innerHTML = obj.data[0].str_appname;
                    document.getElementById("str_mob_phone").innerHTML = obj.data[0].str_appmtel;
                    document.getElementById("str_telecomm_id").innerHTML = obj.data[0].str_T_ID;
                    document.getElementById("txt_Email").innerHTML = obj.data[0].str_appemail;
                    document.getElementById("str_hardware").innerHTML = obj.data[0].str_hardware;
                    document.getElementById("str_software").innerHTML = obj.data[0].str_software;
                    document.getElementById("str_serv_typ").innerHTML = obj.data[0].str_serviceitem;

                    document.getElementById("DropSubsidiaryCode").innerHTML = obj.data[0].str_pid_2;
                    //style('DropSubsidiaryCode', obj.data[0].str_pid_2);
                    document.getElementById("str_Client_Name_2").innerHTML = obj.data[0].str_Name_2;
                    document.getElementById("str_contact_2").innerHTML = obj.data[0].str_appname_2;
                    document.getElementById("str_ID_2").innerHTML = obj.data[0].str_id_2;
                    document.getElementById("str_mob_phone_2").innerHTML = obj.data[0].str_appmtel_2;
                    document.getElementById("str_C_addr_2").innerHTML = obj.data[0].str_addr_2;
                    document.getElementById("str_hardware_2").innerHTML = obj.data[0].str_hardware_2;
                    document.getElementById("str_software_2").innerHTML = obj.data[0].str_software_2;
                    
                    document.getElementById("SelectUrgency").innerHTML = obj.data[0].str_urgency;
                    //alert(obj.data[0].str_op_type)
                    //style('SelectUrgency', obj.data[0].str_urgency);
                    document.getElementById("Time01").innerHTML = obj.data[0].str_onspot_time;
                    document.getElementById("SelectOpinionType").innerHTML = obj.data[0].str_op_type;
                    //style('SelectOpinionType', obj.data[0].str_op_type);
                    document.getElementById("ReplyType").innerHTML = obj.data[0].str_rep_type;
                    //style('ReplyType', obj.data[0].str_rep_type);
                    document.getElementById("Opinion").value = obj.data[0].str_opinion;
                    //document.getElementById("Opinion2").innerHTML = obj.data[0].str_opinion;
                    document.getElementById("DealingProcess").innerHTML = obj.data[0].str_type;
                    if (obj.data[0].str_type != "已結案") document.getElementById('Button5').style.display = "none";

                    document.getElementById("A_ID").innerHTML = obj.data[0].str_A_ID;
                    document.getElementById("A_N").innerHTML = obj.data[0].str_Handle_Agent;
                    document.getElementById("PS").value = obj.data[0].str_ps;
                    document.getElementById("Reply").innerHTML = obj.data[0].str_rep;
                    document.getElementById("SetupTime").innerHTML = obj.data[0].str_S_Time;
                    document.getElementById("Label1").innerHTML = obj.data[0].str_R_Time;
                    document.getElementById("Label2").innerHTML = obj.data[0].str_F_Time;
                    //List_Record(obj.data[0].str_client_id);
                    //alert('a' + obj.data[0].Agent_ID + 'a');
                    //alert('b' + obj.data[0].str_A_ID + 'b');
                    if (obj.data[0].Agent_ID != obj.data[0].str_A_ID) {
                        document.getElementById('Button1').style.display = "none";  //隱藏
                        document.getElementById('Button2').style.display = "none";  //隱藏
                        document.getElementById('Button3').style.display = "none";  //隱藏
                        document.getElementById('Button4').style.display = "";  //顯示
                        document.getElementById('Button6').style.display = "none";  //隱藏
                        document.getElementById('Button7').style.display = "none";  //隱藏補到點鈕
                        document.getElementById('Button8').style.display = "none";  //隱藏補完成鈕
                    }

                    switch (obj.data[0].TV) {          //讀狀態隱藏按鈕
                        case '0':   //取消
                            document.getElementById('Button1').style.display = "none";  //隱藏到點鈕
                            document.getElementById('Button7').style.display = "none";  //隱藏補到點鈕
                            document.getElementById('Button2').style.display = "none";  //隱藏完成鈕
                            document.getElementById('Button8').style.display = "none";  //隱藏補完成鈕
                            break;
                        case '1':    //處理 
                            document.getElementById('Button2').style.display = "none";  //隱藏完成鈕
                            document.getElementById('Button8').style.display = "none";  //隱藏補完成鈕
                            //document.getElementById('Tr_upload').style.display = "none";  //隱藏完成鈕
                            //document.getElementById('Tr_upload2').style.display = "none";  //隱藏完成鈕
                            break;
                        case '2':    //到點
                            document.getElementById('Button1').style.display = "none";  //隱藏到點鈕
                            document.getElementById('Button7').style.display = "none";  //隱藏補到點鈕
                            break;
                        case '3':    //結案
                            document.getElementById('Button1').style.display = "none";  //隱藏到點鈕
                            document.getElementById('Button7').style.display = "none";  //隱藏補到點鈕
                            document.getElementById('Button2').style.display = "none";  //隱藏完成鈕
                            document.getElementById('Button8').style.display = "none";  //隱藏補完成鈕
                            break;
                        case '4':    //結案加簽核
                            document.getElementById('Button1').style.display = "none";  //隱藏到點鈕
                            document.getElementById('Button7').style.display = "none";  //隱藏補到點鈕
                            document.getElementById('Button2').style.display = "none";  //隱藏完成鈕
                            document.getElementById('Button8').style.display = "none";  //隱藏補完成鈕
                            break;
                        default: alert("Type_Value 出錯");
                            //break;
                    }
                }
            });
            //document.getElementById('button_01').style.display = "none";  //客戶地址    額外的按鈕          
            
            $("#Div_Loading").modal('hide');        // 功能??
        }

        function Esti_Fin_Time() { }

        function ServiceChanged() {
            var s = document.getElementById("DropService");
            var str_value = s.options[s.selectedIndex].value;
            $.ajax({
                url: '0030010097.aspx/ServiceName_List',
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
        }

        function Client_Code_Search() {     //選客戶
            $.ajax({
                url: '0030010097.aspx/Client_Code_Search',
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
            var str_index2 = document.getElementById("DropClientCode").value;
            //alert(str_index2);
            $.ajax({
                url: '0030010097.aspx/Client_Code_Search2',
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
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        function ShowClientData() {     //選顧客後抓資料
            var str_index = document.getElementById("DropClientCode").value;
            Client_Code_Search2();     //子公司選單
            //List_Record(str_index);
            $.ajax({
                url: '0030010097.aspx/Show_Client_Data',
                type: 'POST',
                data: JSON.stringify({ value: str_index }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
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
                url: '0030010097.aspx/Show_Client_Data2',
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
            //var id = document.getElementById("DropClientCode").innerHTML;
            //alert(id);
            $.ajax({
                url: '0030010097.aspx/List_Record',
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
                                 {
                                     data: "G", render: function (data, type, row, meta) {
                                         return "<button type='button' id='edit' class='btn btn-info btn-lg'>" +
                                 "<span class='glyphicon glyphicon-search'></span>&nbsp;明細</button>";
                                     }
                                 }
                        ]
                    });
                    $('#tab_Record tbody').unbind('click').
                        on('click', '#edit', function () {
                            var mno = table.row($(this).parents('tr')).data().G.toString();
                            URL2(mno);
                        });
                }
            });
        }

        function Reach(Flag) {      //原 Data_Save
            var str_sysid = document.getElementById("str_sysid").value;
            var time = document.getElementById("datetimepicker01").value;
            $.ajax({
                url: '0030010097.aspx/Reach',
                type: 'POST',
                data: JSON.stringify({
                    sysid: str_sysid,
                    time: time,
                    Flag: Flag
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "reach") {
                        //alert('已登記到點');
                        window.location.href = "/0030010000/0030010003.aspx?view=0";
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                },
            });
        }

        function Finish(Flag) {
            var str_sysid = document.getElementById("str_sysid").value;
            var str_C_Name = document.getElementById("str_Client_Name").innerHTML;
            var str_S_O_Type = document.getElementById("SelectOpinionType").innerHTML;
            var str_ps = document.getElementById("PS").value;
            var time = document.getElementById("datetimepicker01").value;
                $.ajax({
                    url: '0030010097.aspx/Finish',
                    type: 'POST',
                    data: JSON.stringify({
                        sysid: str_sysid,
                        ps: str_ps,
                        C_Name: str_C_Name,
                        S_O_Type: str_S_O_Type,
                        time: time,
                        Flag: Flag
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var json = JSON.parse(doc.d.toString());
                        if (json.status == "finish") {
                            //alert('完成結案');
                            window.location.href = "/0030010000/0030010003.aspx?view=0";
                        }                        
                        else {
                            alert(json.status);
                        }
                        $("#Div_Loading").modal('hide');
                    },
                    error: function () { alert("發生錯誤"); }
                });
            //}
        }

        //=============== 帶入【新增雇主及外勞】資訊 ===============
        function Labor_add(SYSID, Flag) {
            var MNo = new_mno;
            $.ajax({
                url: '0030010097.aspx/Labor_Value',
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
                            url: '0030010097.aspx/Btn_Add_Click',
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
                url: '0030010097.aspx/Labor_Delete',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function () {
                }
            });
            bindTable();
        }
        //=========================================
        function Load_MNo() {
            $("#Div_Loading").modal();
            $.ajax({
                url: '0030010097.aspx/Load_MNo',
                type: 'POST',
                data: JSON.stringify({ MNo: new_mno }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text); str_pid
                    if (obj.data[0].MNo == "NULL") {
                        alert("查無【" + new_mno + "】母單編號");
                        window.location.href = "/0030010000/0030010002.aspx";
                        return;
                    } else if (obj.data[0].MNo == "NO") {
                        //================ 判斷是否為該部門的單 =======================  
                        alert('您沒有訪問此頁面的權限，此需求單非您部門的需求單。');
                        window.location.href = "/0030010000/0030010002.aspx";
                        return;
                        //================ 判斷是否為該部門的單 =======================
                    }
                    //document.getElementById("str_name").innerHTML = obj.data[0].Create_Name;
                    document.getElementById("str_team").innerHTML = obj.data[0].Create_Team;
                    style('DropService', obj.data[0].Service);
                    ServiceChanged();
                    document.getElementById("txt_Cust_FullName").innerHTML = obj.data[0].Cust_FullName;
                    document.getElementById("txt_Labor_Team").innerHTML = obj.data[0].Labor_Team;
                    document.getElementById("txt_Labor_Name").innerHTML = obj.data[0].Labor_CName;
                    document.getElementById("txt_Labor_Country").innerHTML = obj.data[0].Labor_Country;
                    document.getElementById("txt_Labor_Language").innerHTML = obj.data[0].Labor_Language;
                    document.getElementById("txt_Labor_ID").innerHTML = obj.data[0].Labor_ID;
                    document.getElementById("txt_Labor_PID").innerHTML = obj.data[0].Labor_PID;
                    document.getElementById("txt_Labor_RID").innerHTML = obj.data[0].Labor_RID;
                    document.getElementById("txt_Labor_EID").innerHTML = obj.data[0].Labor_EID;
                    document.getElementById("txt_Labor_Phone").innerHTML = obj.data[0].Labor_Phone;
                    document.getElementById("txt_Labor_Address").innerHTML = obj.data[0].Labor_Address;
                    document.getElementById("txt_Labor_Valid").innerHTML = obj.data[0].Labor_Valid;
                    document.getElementById("Labor_Address2").innerHTML = obj.data[0].Labor_Address2;
                    //=====================================================

                    document.getElementById("txt_Location").innerHTML = obj.data[0].Location;
                    document.getElementById("LocationStart").value = obj.data[0].LocationStart;
                    document.getElementById("LocationEnd").value = obj.data[0].LocationEnd;
                    document.getElementById("ContactName").value = obj.data[0].ContactName;
                    document.getElementById("Agent_Phone_2").value = obj.data[0].ContactPhone2;
                    document.getElementById("Agent_Phone_3").value = obj.data[0].ContactPhone3;
                    document.getElementById("Agent_Co_TEL").value = obj.data[0].Contact_Co_TEL;
                    document.getElementById("txt_CarSeat").value = obj.data[0].CarSeat;
                    document.getElementById("Question").value = obj.data[0].Question;
                    document.getElementById("datetimepicker01").value = obj.data[0].Time_01.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_01.substr(11, 5);
                    document.getElementById("datetimepicker02").value = obj.data[0].Time_02.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_02.substr(11, 5);

                }
            });
            $("#Div_Loading").modal('hide');
        }

        //================ 【取消需求單】 ===============
        function Btn_Cancel_Click() {
            $("#Div_Loading").modal();
            var txt_cancel = document.getElementById("txt_cancel").value;
            $.ajax({
                url: '0030010097.aspx/Btn_Cancel_Click',
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

        //================== 【返回派工】 =================
        function Btn_Back_Click() {
            window.location.href = "/0030010000/0030010002.aspx";
        };

        //================== 【返回查單】 =================
        function Btn_Back_Click2() {
            window.location.href = "/0060010005.aspx";
        };

        //============= 顯示【地址】名單 =============沒在用
        function Add_Location(ID, Flag) {
            $.ajax({
                url: '0030010097.aspx/Add_Location',
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

        function List_Dispatch_Team() {     //選部門
            $.ajax({
                url: '0030010097.aspx/List_Dispatch_Team',
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

        function Change_Dispatch() {
            //var value = document.getElementById("Chose_Company").value;
            var value = "Engineer";
            $.ajax({
                url: '0030010097.aspx/List_Dispatch_Name',
                type: 'POST',
                data: JSON.stringify({ value: value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Dispatch_Name");     //派公人員
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇派工人員…" + "</option>");
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
                    
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        // ===================確認派工
        function Send() {
            var str_sysid = document.getElementById("str_sysid").value;
            var value = document.getElementById("Dispatch_Name").value;
            var PS = document.getElementById("Agent_PS").value;
            var C_Name = document.getElementById("str_Client_Name").innerHTML;
            var S_O_Type = document.getElementById("SelectOpinionType").value;
            //document.getElementById('Button5').style.display = "none";            
            if (confirm("確認要派工並通知嗎？")) {
                $.ajax({
                    url: '0030010097.aspx/Send',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ sysid: str_sysid, value: value, PS: PS, C_Name: C_Name, S_O_Type: S_O_Type }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {   
                            Show(value);          //顯示 處理人員                             
                            alert("派工成功");
                            //document.getElementById('Button4').style.display = "none";      //隱藏派工紐
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
            var PS = document.getElementById("Agent_PS").value;
            var C_Name = document.getElementById("str_Client_Name").innerHTML;
            var S_O_Type = document.getElementById("SelectOpinionType").value;
            var value2 = document.getElementById("A_ID").innerHTML;
            //alert(value2);
            if (confirm("確認要轉派工並發送通知嗎？")) {
                $.ajax({
                    url: '0030010097.aspx/Change',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({
                        sysid: str_sysid,
                        value: value,
                        PS: PS,
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

        function Show(value) {
            $.ajax({
                url: '0030010097.aspx/Show',
                type: 'POST',
                data: JSON.stringify({ value: value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {                    
                        var text = '{"data":' + doc.d + '}';
                        var obj = JSON.parse(text);                        
                        document.getElementById("A_ID").innerHTML = obj.data[0].B;      //data[0].
                        document.getElementById("A_N").innerHTML = "  " + obj.data[0].A;
                    //alert("A=" + A_ID);

                        //if (!A_ID.IsNullOrEmpty)
                            //document.getElementById('Button5').style.display = "";  //顯示轉派鍵
                }
            });
        }

        // ===================簽核
        function Signed() {
            var str_sysid = document.getElementById("str_sysid").value;
            var value = document.getElementById("A_ID").innerHTML;
            var C_Name = document.getElementById("str_Client_Name").innerHTML;
            var S_O_Type = document.getElementById("SelectOpinionType").innerHTML;
            //alert(value);
            if (confirm("確認要簽核並通知客服嗎？")) {
                $.ajax({
                    url: '0030010097.aspx/Signed',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ sysid: str_sysid, value: value, C_Name: C_Name, S_O_Type: S_O_Type }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "signed") {
                            //URL();
                            window.location.href = "/0030010000/0030010003.aspx?view=0";
                            //alert("簽核成功");
                            //document.getElementById('Button4').style.display = "none";      //隱藏派工紐
                        }
                        else alert(status);
                    }
                });
            }   //*/            
        };

        function URL() {
            var Case_ID = document.getElementById("str_sysid").value;
            $.ajax({
                url: '0030010097.aspx/URL',
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
        function URL2(mno) {
            $.ajax({
                url: '0030010097.aspx/URL2',
                type: 'POST',
                data: JSON.stringify({ mno: mno }),
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
        function URL4() {
            var Case_ID = document.getElementById("str_sysid").value;
            //alert(Case_ID);
            $.ajax({
                url: '0030010097.aspx/URL4',
                type: 'POST',
                data: JSON.stringify({ mno: Case_ID }),
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


        function U_PS() {      //原 Data_Save
            var str_sysid = document.getElementById("str_sysid").value;
            var str_ps = document.getElementById("PS").value;
            //if (confirm("確認修改完成備註嗎？")) {
                $.ajax({
                    url: '0030010097.aspx/U_PS',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({
                        sysid: str_sysid,
                        ps: str_ps
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {
                            alert('修改成功');
                        }
                        else alert(status);
                    }
                });
            //}
        }
        function R_add()
        {
            document.getElementById("Lable1").innerHTML = "到點";
            document.getElementById('Button10').style.display = "none";
        }        
        function F_add() {
            document.getElementById("Lable1").innerHTML = "完成";
            document.getElementById('Button9').style.display = "none";
        }

        function Btn_Report_Click() {
            $("#Div_Loading").modal();
            window.location.href = "/Re_Check.aspx?seqno=" + seqno;
        }
        function image_Click() {
            $.ajax({
                url: '0030010097.aspx/image_Click',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    location.href = doc.d;
                }
            });
        }

        //========================
        function bindTable() {            //案件 商品列表
            var Detail = document.getElementById("select_OE_Detail").value;
            $.ajax({
                url: '0030010005.aspx/GetOEList',   //用別頁的 code
                type: 'POST',
                data: JSON.stringify({ Detail: Detail }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#Table1').DataTable({
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
                                ///*{ data: "Price" },
                                {
                                    data: "ID", render: function (data, type, row, meta) {
                                        return "<input type='int' id='price_" + data + "' class='form-control' />";
                                    }   //onkeyup='this.value=this.value.replace(/\D/g,'')' onafterpaste='this.value=this.value.replace(/\D/g,'')'  //onkeyup沒作用
                                },  //*/
                                {
                                    data: "ID", render: function (data, type, row, meta) {
                                        return "<input type='int' id='txt_" + data + "' class='form-control' maxlength='3' onkeyup='value=value.replace(/[^\d]/g,'')'/>";
                                    }
                                },
                                {
                                    data: "", render: function (data, type, row, meta) {
                                        return "<button type='button' class='btn btn-success btn-lg' data-toggle='modal'  style='Font-Size: 20px;' id='edit' class='btn btn-info btn-lg'>" + //data-target='#newModal'
                                        " <span class='glyphicon glyphicon-plus'>訂貨</button>";
                                    }
                                }
                        ]
                    });
                    $('#Table1 tbody').unbind('click').   // ???
                        on('click', '#edit', function () {
                            var ID = table.row($(this).parents('tr')).data().ID.toString();
                            var Product_Name = table.row($(this).parents('tr')).data().Product_Name.toString();
                            var Main_Classified = table.row($(this).parents('tr')).data().Main_Classified.toString();
                            var Detail_Classified = table.row($(this).parents('tr')).data().Detail_Classified.toString();
                            //var Price = table.row($(this).parents('tr')).data().Price.toString();
                            var pri = ("price_" + ID);
                            var Price = document.getElementById(pri).value;
                            var txt = "txt_" + ID;
                            var Main = document.getElementById(txt).value;
                            //alert('數量' + Main + '商品ID' + ID);
                            Order(ID, Product_Name, Main_Classified, Detail_Classified, Price, Main);
                            bindTable2();
                        });
                }
            });
        }
        function Order(ID, Product_Name, Main_Classified, Detail_Classified, Price, Main) {            //訂貨儲存
            var Case_ID = document.getElementById("str_sysid").value;
            //if (Price <= 0) alert("價格錯誤" );
            //alert("A=" + Case_ID + " B=" + ID + " C=" + Product_Name + " D=" + Main_Classified);
            //alert("E=" + Detail_Classified + " F=" + Price + " G=" + Main );
            $.ajax({
                url: '0030010097.aspx/Order',
                type: 'POST',
                data: JSON.stringify({
                    Case_ID: Case_ID,
                    ID: ID,
                    Product_Name: Product_Name,
                    Main_Classified: Main_Classified,
                    Detail_Classified: Detail_Classified,
                    Main: Main,
                    Price: Price,
                    T_Price: Price * Main
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    //var text = '{"data":' + doc.d + '}';
                    //var obj = JSON.parse(text);
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new")
                        alert('完成訂貨');
                    else
                        alert(json.status);
                    //document.getElementById("Product_Name").value = obj.data[0].Product_Name;
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }

        function bindTable2() {            //案件 訂單列表
            var Case_ID = document.getElementById("str_sysid").value;
            //alert('a'+OE_Case_ID+'a');
            $.ajax({
                url: '0030010097.aspx/GetCaseOrder',
                type: 'POST',
                data: JSON.stringify({ Case_ID: Case_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#Table2').DataTable({
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
                                { data: "OE_ID" },
                                { data: "Case_ID" },
                                { data: "Product_Name" },
                                { data: "Quantity" },
                                { data: "Price" },
                                { data: "T_Price" },
                                {
                                    data: "Case_O_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' class='btn btn-danger btn-lg' id='delete'>" +
                                            "<span class='glyphicon glyphicon-remove'>" +
                                            "</span>&nbsp;刪除</button>";
                                    }
                                }
                        ]
                    });

                    $('#Table2 tbody').unbind('click')
                        .on('click', '#delete', function () {
                            var table = $('#Table2').DataTable();
                            var Case_O_ID = table.row($(this).parents('tr')).data().Case_O_ID;
                            //alert(Case_O_ID);
                            Delete(Case_O_ID);
                        });
                }
            });
            //OE_Total_Price(); //算總價 0030010005 才有 這頁沒加
        }
        //================ 刪除【新增多筆資訊 】資訊 ===============
        function Delete(Case_O_ID) {
            if (confirm("確定要刪除這商品嗎？")) {
                $.ajax({
                    url: '0030010097.aspx/Delete',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ Case_O_ID: Case_O_ID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {
                            bindTable2()
                        }
                    }
                });
            }
        };

        //==========================  OE 主分類
        function OE_Main_List() {
            $.ajax({
                url: '0030010005.aspx/OE_Main', //用別頁的 code
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
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }
        //==========================  OE 子分類
        function OE_Detail_List() {
            var Main = document.getElementById("select_OE_Main").value;
            //alert(Main);
            $.ajax({
                url: '0030010005.aspx/OE_Detail',   //用別頁的 code
                type: 'POST',
                data: JSON.stringify({ Main: Main }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_OE_Detail");
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value='all'>" + "全類別" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Detail_Classified + "'>" + obj.Detail_Classified + "</option>");
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
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
        <h2>
            <label id="str_title"></label>
                <button id='Btn_Report' type='button' class='btn btn-info btn-lg' onclick="Btn_Report_Click()">
                    <span class='glyphicon glyphicon-file'></span>
                    &nbsp;服務紀錄表預覽
                </button>
                &nbsp;
            <button type='button' class='btn btn-success btn-lg' onclick="image_Click()" hidden="">
                <span class='glyphicon glyphicon-picture'></span>
                &nbsp;圖片瀏覽
            </button>            
        </h2>        
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
                        <label id="str_sysid2"></label>
                        <input id="str_sysid" name="str_sysid" type="hidden" />
                        <strong><%= str_type %></strong>
                    </th>
                    <td style="text-align: center; width: 15%;">
                        <strong>來電號碼</strong>
                    </td>
                    <td>
                        <label id="Text1"></label><!-- 
                        <div style="float: left" data-toggle="tooltip" title="">
                            <input type="text" class="form-control" id="Text1" name="LoginTime"  value="" />
                        </div>--><!-- -->
                    </td>
                </tr>
                <tr id="tr_sysid" runat="server">
                    <td style="text-align: center">
                        <strong>最後修改日期</strong>
                    </td>
                    <td>
                        <label id="UpdateTime"></label>
                        <!-- 
                        <div style="float: left" data-toggle="tooltip" title="必填">
                            <input type="text" class="form-control" id="LoginTime" name="LoginTime" style="background-color: #ffffbb" value="" />
                        </div>-->
                    </td>
                    <td style="text-align: center">
                        <strong>登錄人員</strong>
                    </td>
                    <td>
                        <label id="Text2"></label>
                    <!-- 
                        <div style="float: left" data-toggle="tooltip" title="必填">
                            <input type="text" class="form-control" id="Text2" name="Text2" style="background-color: #ffffbb" value="" />
                        </div>-->
                    </td>
                </tr>
            </tbody>
        </table>
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
                        <strong>客戶代碼
                        </strong>
                    </th>
                    <th style="width: 35%">
                        <label id="DropClientCode"></label><!--     -->
                        <!--<div data-toggle="tooltip" title="必選" style="width: 100%">
                            <select id="DropClientCode" name="DropClientCode" class="chosen-select" onchange="ShowClientData()">
                                <option value="">請選擇客戶…</option>
                            </select>-->
                        </div>
                    </th>
                    <th style="text-align: center; width: 15%">統一編號</th>   <!-- 發送 E-Mail-->
                    <th style="width: 35%">
                        <label id="str_id"></label>
                        <!-- <input type="checkbox" name="e-mail" style="width: 25px; height: 25px;" value="1" />-->
                    </th>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center; width: 15%">
                        <strong>客戶名稱</strong>
                    </td>
                    <td style="width: 35%">
                        <label id="str_Client_Name"></label>

                    </td>

                    <th style="text-align: center; width: 15%">
                        <strong>叫修地址</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="Service_Location"></label><!--     
                        <div style="float: left" data-toggle="tooltip" title="必填">
                            <textarea id="Service_Location" name="Service_Location" class="form-control" cols="45" rows="1" placeholder="叫修地址" maxlength="40" onkeyup="cs(this);"
                                style="resize: none; background-color: #ffffbb"></textarea>
                        </div>-->
                    </th>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡人</strong>
                    </td>
                    <td>
                        <label id="str_contact"></label><!--     
                        <div style="float: left" data-toggle="tooltip" title="必填">
                            <input type="text" class="form-control" id="str_contact" name="Contact" style="background-color: #ffffbb" value="" />
                        </div>-->
                    </td>
                    <td style="text-align: center">
                        <strong>聯絡人電話</strong>
                    </td>
                    <td>
                        <label id="str_mob_phone"></label><!--     
                        <div style="float: left" data-toggle="tooltip" title="必填">
                            <input type="text" class="form-control" id="str_mob_phone" name="Contact_mob_phone" style="background-color: #ffffbb" value="" />
                        </div>-->
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>負責電信商</strong>
                    </td>
                    <td>
                        <label id="str_telecomm_id"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>客戶 E-mail</strong>
                    </td>
                    <td>
                        <label id="txt_Email"></label><!--    
                        <input type="text" class="form-control" id="txt_Email" name="txt_Email" value="" /> -->
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
                        <strong>合約狀態</strong>
                    </td>
                    <td>
                        <label id="str_serv_typ"></label>
                    </td>
                    <td style="text-align: center">
                        <strong><br />
                            </strong>    <!--（搭配經銷商） -->
                    </td>
                    <td>
                        <label id="Test"></label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
            </tbody>
        </table>

        <%--  =========== 子公司資料 表單三===========--%>
    <div style="text-align: center; width: 1280px; margin: 10px 20px">
        <table class="table table-bordered table-striped">                      
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>子公司資料</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>子公司</strong>
                    </th>
                    <th style="width: 35%">    
                        <label id="DropSubsidiaryCode"></label><!--            
                        <div data-toggle="tooltip" title="非必選" style="width: 100%">
                            <select id="DropSubsidiaryCode" name="DropSubsidiaryCode" class="chosen-select" onchange="ShowSubsidiaryData()">
                                <option value="">請選擇</option>
                            </select>
                        </div>  -->           
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>子公司名稱</strong>
                    </th>
                    <th style="text-align: center; width: 15%">                        
                        <label id="str_Client_Name_2"></label>
                    </th>
                </tr>
                <tr style="height: 55px;">                                                          <%--  Table 002-2  --%>
                    <td style="text-align: center">
                        <strong>(子)聯絡人</strong>
                    </td>
                    <td>
                        <label id="str_contact_2"></label><!--     
                        <input type="text" class="form-control" id="str_contact_2" name="str_contact"  value="(子)聯絡人"/>  -->
                    </td>
                    <td style="text-align: center">
                        <strong>(子)統一編號</strong>
                    </td>
                    <td>
                        <label id="str_ID_2"></label><br />
                    </td>                    
                </tr>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>(子)聯絡電話</strong>
                    </td>
                    <td>
                        <label id="str_mob_phone_2"></label><!--     
                        <input type="text" class="form-control" id="str_mob_phone_2" name="str_contact"  value="(子)聯絡電話"/>  -->
                    </td>
                    <td style="text-align: center; width: 15%">
                        <strong>(子)地址</strong>
                    </td>
                    <td style="width: 35%">                
                        <label id="str_C_addr_2"></label><!--                         
                        <div style="float: left" data-toggle="tooltip" title="不能超過150 個字元，並且含有不正確的符號">      
                                <textarea id="str_C_addr_2" name="str_C_addr_2" class="form-control" cols="45" rows="1" placeholder="地址" maxlength="150" onkeyup="cs(this);"
                                style="resize: none; background-color: #ffffbb"  ></textarea>
                        </div>-->     
                    </td>
                </tr>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>(子)硬體</strong>
                    </td>
                    <td>
                        <label id="str_hardware_2"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>(子)軟體</strong>
                    </td>
                    <td>
                        <label id="str_software_2"></label>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>


        <!--<h2><strong>客戶歷史紀錄</strong></h2>-->
        <table id="tab_Record" class="display table table-striped" style="width: 99%" hidden="hidden">
            <thead>
                <tr>
                    <th style="text-align: center;">案件編號</th>
                    <th style="text-align: center;">登單時間</th>
                    <th style="text-align: center;">客戶名稱</th>
                    <th style="text-align: center;">意見內容</th>
                    <th style="text-align: center;">處理回覆</th>
                    <th style="text-align: center;">案件狀態</th>
                    <th style="text-align: center;">詳情</th>
                </tr>
            </thead>
        </table>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>反應內容</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>緊急程度</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="SelectUrgency"></label><!--     
                        <div data-toggle="tooltip" title="必選" style="width: 100%">
                            <select id="SelectUrgency" name="SelectUrgency" class="chosen-select" onchange="Esti_Fin_Time()">
                                <option value="">請選擇緊急程度…</option>
                                <option value="維護">維護</option>
                                <option value="緊急故障">緊急故障</option>
                                <option value="重要故障">重要故障</option>
                                <option value="一般故障">一般故障</option>
                            </select>
                        </div>-->
                    </th>
                    <td style="text-align: center; width: 15%">
                        <strong>預計到點</strong>     <!--預定完成日期 -->
                    </td>
                    <td style="width: 35%">
                        <label id="Time01"></label><!--     
                        <div style="float: left" data-toggle="tooltip" title="">
                            <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01"  />
                        </div>-->
                    </td>

                </tr>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>意見類型</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="SelectOpinionType"></label><!--      
                        <div data-toggle="tooltip" title="必選" style="width: 100%">
                            <select id="SelectOpinionType" name="SelectOpinionType" class="chosen-select">
                                <option value="">請選擇意見類型…</option>
                                <option value="故障報修">故障報修</option>
                                <option value="軟體修改">軟體修改</option>
                                <option value="技術諮詢">技術諮詢</option>
                                <option value="其他服務">其他服務</option>
                                <option value="定期維護">定期維護</option>
                                <option value="測試">測試</option>
                                <option value="專案">專案</option>
                                <option value="設備擴充">設備擴充</option>
                                <option value="駐點服務">駐點服務</option>
                            </select>
                        </div>-->
                    </th>
                    <td style="text-align: center; width: 15%">
                        <strong>回覆方式</strong>
                    </td>
                    <td style="text-align: center; width: 35%">
                        <label id="ReplyType"></label><!--      
                        <div data-toggle="tooltip" title="必選" style="width: 100%">
                            <select id="ReplyType" name="ReplyType" class="chosen-select">
                                <option value="">請選擇回覆方式…</option>
                                <option>行動電話</option>
                                <option>市內電話</option>
                                <option>e-mail回覆</option>
                                <option>傳真回覆</option>
                            </select>
                        </div>-->
                    </td>
                </tr>
                <tr >
                    <td style="text-align: center; width: 15%">
                        <strong>意見內容</strong>
                    </td>
                    <td colspan="3">
                        <!--<label id="Opinion2" hidden=""></label>   -->
                        <div style="float: left" data-toggle="tooltip" title="重整後恢復原內容">
                            <textarea id="Opinion" name="Opinion" class="form-control" cols="120" rows="5" placeholder="重整後恢復原內容" maxlength="250" onkeyup="cs(this);"
                                style="resize: none;" hidden="hidden"></textarea>
                        </div> 
                    </td>                    
                </tr>
                <tr>
                    <td style="text-align: center; width: 15%">
                        <strong>處理狀態</strong>
                    </td>
                    <th>
                        <label id="DealingProcess"></label>
                    </th>
                </tr>                
                <tr style="height: 55px;">
                    <td style="text-align: center; width: 15%">
                        <strong>到點時間</strong><br />
                        <button id="Button7" type="button" class="btn btn-success" data-toggle="modal" data-target="#myModal" onclick="R_add()">補到點</button>
                    </td>
                    <td style="text-align: center; width: 35%">
                        <label id="Label1"></label>
                    </td>
                    <td style="text-align: center; width: 15%">
                        <strong>處理人員</strong>
                    </td>
                    <td style="text-align: center; width: 35%">
                         <%-- <strong>員工編號: </strong>--%>
                        <label id="A_ID"></label>  <label id="A_N"></label><br />
                        <%-- <label id="Handle_Agent"></label>             --%>           
                    </td>
                </tr>

                <tr style="height: 55px;">
                    <td style="text-align: center; width: 15%">
                        <strong>完成時間</strong><br />
                        <button id="Button8" type="button" class="btn btn-success" data-toggle="modal" data-target="#myModal" onclick="F_add()">補結案</button>
                    </td>
                    <td style="text-align: center; width: 35%">
                        <label id="Label2"></label>
                    </td>
                    <td style="text-align: center; width: 15%">
                        <strong>完成備註</strong><br />
                        <button id="Button6" type="button" onclick="U_PS();" class="btn btn-success "><span class="glyphicon glyphicon-pencil"></span>&nbsp;修改&nbsp;</button>
                    </td>
                    <td style="text-align: center; width: 35%">
                        <label  id="PS2"  hidden="hidden"></label>
                        <div style="float: left; width: 100%" data-toggle="tooltip" title="不能超過1000 個字">
                            <textarea id="PS" name="PS" class="form-control" cols="45" rows="3" placeholder="結案時工程師填" maxlength="1000" 
                                style="resize: none;" hidden=""></textarea>   <!--  onkeyup="cs(this);"  -->
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        
        <%--  =========== 表單四 OE 商品列表===========--%>
        <div style="text-align: center; width: 1280px; margin: 10px 20px">
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
                                <select id="select_OE_Main" name="select_OE_Main" class="chosen-select" onchange="OE_Detail_List()">
                                    <option value="all">全類別</option>
                                </select>
                            </div>
                        </th>
                        <th style="text-align: center; width: 15%">
                            <strong>子類別</strong>
                        </th>
                        <th style="width: 35%">
                            <div data-toggle="tooltip" title="" style="width: 100%">
                                <select id="select_OE_Detail" name="select_OE_Detail" class="chosen-select" onchange="bindTable()">
                                    <option value="all">全類別</option>
                                </select>
                            </div>
                        </th>
                    </tr>

                </tbody>
            </table>
        </div>
    <%--  =======表單四 OE 商品訂貨  table  id="data" === --%> 

    <h2><strong>&nbsp; &nbsp; 標地物列表&nbsp; &nbsp;</strong></h2>

    <!----------------------------------------------->

    <div class="table-responsive" style="width: 90%; margin: 10px 20px">
       <table  id="Table1" class="display table table-striped" style="width: 99%">            
            <thead>
                <tr>
                    <th style="text-align: center;" width: 8%;>
                        <strong>商品ID</strong>
                    </th>
                    <th style="text-align: center;" width: 24%;>商品名稱</th>
                    <th style="text-align: center;" width: 15%;>主分類</th>
                    <th style="text-align: center;" width: 15%;>子分類</th>
                    <th style="text-align: center;" width: 14%;>價格</th>                    
                    <th style="text-align: center;" width: 8%;>數量</th>
                    <th style="text-align: center;" width: 8%;>訂購</th>
                </tr>               
            </thead>
        </table>
    </div>
        

            <%--  =======表單五 已訂貨品  table  id="data" === --%>

    <h2><strong>&nbsp; &nbsp; 訂單列表&nbsp; &nbsp;
    <%--<button id="Button11" type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#Order_New" style="Font-Size: 20px;" onclick="Clear_New()">
        <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增新訂單商品</button> --%>
    </strong></h2>
    <!----------------------------------------------->

    <div class="table-responsive" style="width: 90%; margin: 10px 20px">
       <table  id="Table2" class="display table table-striped" style="width: 99%">            
            <thead>
                <tr>
                    <th style="text-align: center;" width: 8%;>
                        <strong>商品ID</strong>
                    </th>                    
                    <th style="text-align: center;" width: 16%;>OE單號</th>
                    <th style="text-align: center;" width: 30%;>商品名稱</th>                  
                    <th style="text-align: center;" width: 10%;>數量</th>
                    <th style="text-align: center;" width: 10%;>單價</th>
                    <th style="text-align: center;" width: 14%;>合計</th>
                    <th style="text-align: center;" width: 8%;>刪除</th>
                    <%--<th style="text-align: center;" width: 10%;>取消</th>--%>
                </tr>               
            </thead>
        </table>
    </div>
        <!-- --> 
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
                    <th style="width: 35%">
                        <label id="Reply"></label><!--     
                        <div style="float: left" data-toggle="tooltip" title="">
                            <textarea id="Reply" name="Reply" class="form-control" cols="45" rows="3" placeholder="客服處理 回覆內容" maxlength="400" onkeyup="cs(this);"
                                style="resize: none;"></textarea>
                        </div>-->
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>建單時間</strong>
                    </th>
                    <th style="text-align: center; width: 35%">
                        <label id="SetupTime"></label>
                    </th>
                </tr>
                <tr id="Tr_upload">
                    <th style="text-align: center;">選擇上傳檔案</th>
                    <th>
                        <!--<input type="file" id="myFile" name="myFile" runat="server" />-->
                        <asp:FileUpload ID="FileUpload1" runat="server" />
                    </th>
                    <th style="text-align: center;">檔案上傳</th>
                    <th>
                        <asp:Button ID="btnUpload" runat="server" OnClick="btnUpload_Click" Text="檔案上傳" class="btn btn-primary btn-lg" />
                    </th>
                </tr>
                <tr id="Tr_upload2">
                    <th style="text-align: center;">檔案下載</th>
                    <th>
                        <button id="Button11" type="button" class="btn btn-info btn-lg" data-toggle="modal" style="Font-Size: 20px;" onclick="URL4();">
                            <span class='glyphicon glyphicon-search'></span>&nbsp;&nbsp;上傳檔案清單</button>
                    </th>
                </tr>
            </tbody>
        </table>

       
  <%--       <table class="table table-bordered table-striped">
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
                        <strong>滿意度</strong>
                    </th>
                    <th style="width: 35%"></th>
                    <th style="text-align: center; width: 15%">
                        <strong>結案日期</strong>
                    </th>
                    <th style="width: 35%"></th>
                </tr>
            </tbody>
        </table>--%>
        <%--=========== 子單 ===========--%>

        <div style="text-align: center">
            <button id="Button1" type="button" onclick="Reach('0');" class="btn btn-primary btn-lg "><span class="glyphicon glyphicon-ok"></span>&nbsp;到點&nbsp;</button>&nbsp;&nbsp
            <button id="Button2" type="button" onclick="Finish('0');" class="btn btn-success btn-lg "><span class="glyphicon glyphicon-pencil"></span>&nbsp;結案&nbsp;</button>&nbsp;&nbsp
            <button id="Button5" type="button" onclick="Signed();" class="btn btn-success btn-lg "><span class="glyphicon glyphicon-pencil"></span>&nbsp;簽核&nbsp;</button>&nbsp;&nbsp
            <button id="Button3" type="button" onclick="Btn_Back_Click();" class="btn btn-default btn-lg ">&nbsp;取消&nbsp;<span class="glyphicon glyphicon-share-alt"></span></button>
            <button id="Button4" type="button" onclick="Btn_Back_Click2();" class="btn btn-default btn-lg ">&nbsp;返回&nbsp;<span class="glyphicon glyphicon-share-alt"></span></button>
        </div>
    <!--===================================================-->
    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 500px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>補<label id="Lable1"></label></strong></h2>
                </div>
                <div class="modal-body">
                    <table id="data2" class="table table-bordered table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="2">
                                    <span style="font-size: 20px"><strong>請選擇時間</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th>
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01" />
                                    </div>
                                </th>
                                <th>
                                    <button id="Button9" type="button" class="btn btn-success" data-dismiss="modal" onclick="Reach('1');">到點</button>
                                    <button id="Button10" type="button" class="btn btn-success" data-dismiss="modal" onclick="Finish('1');">完成</button>
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
