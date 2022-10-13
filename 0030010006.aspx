<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0030010006.aspx.cs" Inherits="_0030010006" %>

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
            //Select_Telecomm();    //電信商選項
            Client_Code_Search();
            //Owner_List();   //帶入【廠商 】資訊
            //Hospital_List();  //帶入【醫療院所 】資訊
            //Cust_Table();  //顯示【客戶地址】名單
            ShowTime();  //抓現在時間
            OE_Main_List();
            bindTable2();
            //ALL();            //忘了要做啥用的 0701
            if (seqno != '0') {
                Load_OE_Data();      //讀取
            } else {
                //alert('seqno = ' + seqno);
                document.getElementById("str_title").innerHTML = "(新增)OE單";
                document.getElementById("txt_Type").innerHTML = "尚未審查";
            }
        });

        //================ 讀取資訊 ===============
        /*        function ALL() {
                    $.ajax({
                        url: '0030010015.aspx/ALL',
                        type: 'POST',
                        contentType: 'application/json; charset=UTF-8',
                        dataType: "json",
                        success: function (doc) {
                            var i = obj.data[0].i;
                            alert(i)
                        }
                    });         
                }   //*/


        function Load() {
            if (seqno == '0') {
                document.getElementById("str_sysid").innerHTML = new_mno; //【創造母單編號】
                document.getElementById('Button2').style.display = "none";  //隱藏修改按鈕
                document.getElementById('Button4').style.display = "none";  //隱藏修改按鈕

                //document.getElementById('table_cancel').style.display = 'none';  //隱藏【取消需求單】
                $.ajax({
                    url: '0030010015.aspx/Load',
                    type: 'POST',
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var obj = JSON.parse('{"data":' + doc.d + '}');
                        //document.getElementById("str_name").innerHTML = obj.data[0].Agent_Name.trim();
                        //document.getElementById("str_team").innerHTML = obj.data[0].Agent_Team.trim();
                        //document.getElementById("ContactName").value = obj.data[0].Agent_Name.trim();
                        //document.getElementById("Agent_Phone_2").value = obj.data[0].Agent_Phone_2;
                        //document.getElementById("Agent_Phone_3").value = obj.data[0].Agent_Phone_3;
                        //document.getElementById("Agent_Co_TEL").value = obj.data[0].Agent_Co_TEL;
                    }
                });
            } else {
                //new_mno = seqno;
                document.getElementById("str_sysid").innerHTML = seqno;
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
            //document.getElementById('EstimatedFinishTime').innerHTML = y + "/" + mon + "/" + d + " " + h + ":" + m;             // 估計完成時間

        }

        //================ 帶入【服務分類 】資訊 ===============
        /*       function Service_List() {
                   $.ajax({
                       url: '0030010015.aspx/Service_List',
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
               }       //*/

        //function Esti_Fin_Time() { }

        /*       function ServiceChanged() {
                   document.getElementById('tab_Location').style.display = "none";  //隱藏地址
       
                   var s = document.getElementById("DropService");
                   var str_value = s.options[s.selectedIndex].value;
                   $.ajax({
                       url: '0030010015.aspx/ServiceName_List',            // ???
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
               }       //*/


        function ServiceNameChanged() {
            document.getElementById('button_01').style.display = "none";  //客戶地址
            document.getElementById('button_02').style.display = "none";  //單位地址
            document.getElementById("txt_Location").innerHTML = "";
            document.getElementById("hid_PostCode").value = "";
            var str_index = document.getElementById("DropServiceName").selectedIndex;
            var v = document.getElementById("DropServiceName").options[str_index].value;
            $.ajax({
                url: '0030010015.aspx/ServiceName_Flag',
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

        /*       function Select_Telecomm() {
                   $.ajax({
                       url: '0030010015.aspx/Select_Telecomm',
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
               }   //*/

        function Client_Code_Search() {
            $.ajax({
                url: '0030010015.aspx/Client_Code_Search',
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

        function Client_Code_Search2() {
            var str_index2 = document.getElementById("DropClientCode").value;
            //alert(str_index2);
            $.ajax({
                url: '0030010015.aspx/Client_Code_Search2',
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

        //==========================  OE 主分類
        function OE_Main_List() {

            $.ajax({
                url: '0030010015.aspx/OE_Main',
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
                url: '0030010015.aspx/OE_Detail',
                type: 'POST',
                data: JSON.stringify({ Main: Main }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#select_OE_Detail");
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇子分類" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Detail_Classified + "'>" + obj.Detail_Classified + "</option>");
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        //========================
        function bindTable() {            //案件列表程式
            var Detail = document.getElementById("select_OE_Detail").value;
            $.ajax({
                url: '0030010015.aspx/GetOEList',
                type: 'POST',
                data: JSON.stringify({ Detail: Detail }),
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
                                { data: "Price" },
                                {
                                    data: "ID", render: function (data, type, row, meta) {
                                        return "<input type='int' id='txt_" + data + "' class='form-control' maxlength='3' />";
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
                            var Product_Name = table.row($(this).parents('tr')).data().Product_Name.toString();
                            var Main_Classified = table.row($(this).parents('tr')).data().Main_Classified.toString();
                            var Detail_Classified = table.row($(this).parents('tr')).data().Detail_Classified.toString();
                            var Price = table.row($(this).parents('tr')).data().Price.toString();
                            var txt = "txt_" + ID;
                            var Main = document.getElementById(txt).value;
                            //alert('數量' + Main + '商品ID' + ID);
                            //alert('單價' + Price);
                            //alert('單價' + Price * Main);
                            Order(ID, Product_Name, Main_Classified, Detail_Classified, Price, Main);
                            bindTable2();
                        });
                }
            });
        }

        function Order(ID, Product_Name, Main_Classified, Detail_Classified, Price, Main) {            //訂貨儲存
            var OE_Case_ID = document.getElementById("str_sysid").innerHTML;
            $.ajax({
                url: '0030010015.aspx/Order',
                type: 'POST',
                data: JSON.stringify({
                    OE_Case_ID: OE_Case_ID,
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
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    alert('完成訂貨');
                    //document.getElementById("Product_Name").value = obj.data[0].Product_Name;
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }
        //========================
        function bindTable2() {            //案件列表程式
            var OE_Case_ID = document.getElementById("str_sysid").innerHTML;
            //alert('a'+OE_Case_ID+'a');
            $.ajax({
                url: '0030010015.aspx/GetOEOrder',
                type: 'POST',
                data: JSON.stringify({ OE_Case_ID: OE_Case_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data2').DataTable({
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
                                { data: "OE_Case_ID" },
                                { data: "Product_Name" },
                                { data: "Quantity" },
                                { data: "Price" },
                                { data: "T_Price" },
                                {
                                    data: "OE_O_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' class='btn btn-danger btn-lg' id='delete'>" +
                                            "<span class='glyphicon glyphicon-remove'>" +
                                            "</span>&nbsp;刪除</button>";
                                    }
                                }
                        ]
                    });

                    $('#data2 tbody').unbind('click')
                        .on('click', '#delete', function () {
                            var table = $('#data2').DataTable();
                            var OE_O_ID = table.row($(this).parents('tr')).data().OE_O_ID;
                            alert(OE_O_ID);
                            Delete(OE_O_ID);
                        });
                }
            });
            OE_Total_Price();
            //alert('T_Price');
        }

        //================ 刪除【新增多筆資訊 】資訊 ===============
        function Delete(OE_O_ID) {
            if (confirm("確定要刪除這商品嗎？")) {
                $.ajax({
                    url: '0030010015.aspx/Delete',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ OE_O_ID: OE_O_ID }),
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

        function OE_Total_Price() {
            var OE_Case_ID = document.getElementById("str_sysid").innerHTML;
            //alert(Main);
            $.ajax({
                url: '0030010015.aspx/OE_Total_Price',
                type: 'POST',
                data: JSON.stringify({ OE_Case_ID: OE_Case_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    //style('DropService', obj.data[0].Service);
                    //ServiceChanged();
                    document.getElementById("Total_Price").innerHTML = obj.data[0].Total_Price;
                }
            });
            $('.chosen-single').css({ 'background-color': '#ffffbb' });
        }

        function ShowClientData() {
            var str_index = document.getElementById("DropClientCode").value;
            Client_Code_Search2();     //子公司選單
            $.ajax({
                url: '0030010015.aspx/Show_Client_Data',
                type: 'POST',
                data: JSON.stringify({ value: str_index }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    document.getElementById("str_Client_Name").innerHTML = "統編:" + obj.data[0].B + " 名稱:" + obj.data[0].C;
                    document.getElementById("str_contact").value = obj.data[0].D;
                    document.getElementById("str_C_addr").value = obj.data[0].E;
                    document.getElementById("str_fax_phone").value = obj.data[0].F;
                    document.getElementById("str_mob_phone").value = obj.data[0].G;
                    document.getElementById("str_hardware").innerHTML = obj.data[0].H;
                    document.getElementById("str_software").innerHTML = obj.data[0].I;
                    //document.getElementById("str_serv_typ").innerHTML = obj.data[0].J;

                    //document.getElementById("str_com_tel").innerHTML = "("+ obj.data[0].E + ")" + obj.data[0].F;
                }
            });
        }

        function ShowSubsidiaryData() {
            var str_index_2 = document.getElementById("DropSubsidiaryCode").value;
            $.ajax({
                url: '0030010015.aspx/Show_Client_Data2',
                type: 'POST',
                data: JSON.stringify({ value_2: str_index_2 }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    document.getElementById("str_Client_Name_2").innerHTML = "統編:" + obj.data[0].B + " 名稱:" + obj.data[0].C;
                    document.getElementById("str_contact_2").value = obj.data[0].D;
                    document.getElementById("str_C_addr_2").value = obj.data[0].E;
                    document.getElementById("str_fax_phone_2").value = obj.data[0].F;
                    document.getElementById("str_mob_phone_2").value = obj.data[0].G;
                    document.getElementById("str_hardware_2").innerHTML = obj.data[0].H;
                    document.getElementById("str_software_2").innerHTML = obj.data[0].I;

                }
            });
        }

        /*       function ShowCaseData() {
                   var str_index = document.getElementById("DropClientCode").value;
                   $.ajax({
                       url: '0030010015.aspx/Show_Client_Data',
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

        function Data_Save() {                  //右方 存入 左方

            var str_sysid = document.getElementById("str_sysid").innerHTML;
            var OE_PS = document.getElementById("Textarea1").value;
            var Con_Name = document.getElementById("Text1").value;
            var Con_Phone = document.getElementById("Text2").value;
            //var SetupDate = document.getElementById("LoginTime").innerHTML;
            var UpdateDate = document.getElementById("LoginTime").value;
            var Type_Value = document.getElementById("txt_Type_Value").value;
            var Type = document.getElementById("txt_Type").innerHTML;

            var PID = document.getElementById("DropClientCode").value;
            var BUSINESSNAME = document.getElementById("str_Client_Name").innerHTML;
            var APPNAME = document.getElementById("str_contact").value;
            var CONTACT_ADDR = document.getElementById("str_C_addr").value;
            var APP_FTEL = document.getElementById("str_fax_phone").value;
            var APP_MTEL = document.getElementById("str_mob_phone").value;
            var HardWare = document.getElementById("str_hardware").innerHTML;
            var SoftwareLoad = document.getElementById("str_software").innerHTML;

            var PNumber = document.getElementById("DropSubsidiaryCode").value;
            var Name = document.getElementById("str_Client_Name_2").innerHTML;
            var S_APPNAME = document.getElementById("str_contact_2").value;
            var S_CONTACT_ADDR = document.getElementById("str_C_addr_2").value;
            var S_APP_FTEL = document.getElementById("str_fax_phone_2").value;
            var S_APP_MTEL = document.getElementById("str_mob_phone_2").value;
            var S_HardWare = document.getElementById("str_hardware_2").innerHTML;
            var S_SoftwareLoad = document.getElementById("str_software_2").innerHTML;

            var Final_Price = document.getElementById("Final_Price").value;
            var Warranty_Date = document.getElementById("datetimepicker01").value;
            var Warr_Time = document.getElementById("Text11").value;
            var Protect_Date = document.getElementById("datetimepicker02").value;
            var Prot_Time = document.getElementById("Text12").value;
            var Receipt_Date = document.getElementById("datetimepicker03").value;
            var Receipt_PS = document.getElementById("Text13").value;
            var Close_Out_Date = document.getElementById("datetimepicker04").value;
            var Close_Out_PS = document.getElementById("Textarea2").value;

            $.ajax({
                url: '0030010015.aspx/Case_Save',
                type: 'POST',
                data: JSON.stringify({
                    sysid: str_sysid,
                    OE_PS: OE_PS,
                    Con_Name: Con_Name,
                    Con_Phone: Con_Phone,
                    //SetupDate: SetupDate , 
                    UpdateDate: UpdateDate,
                    Type_Value: Type_Value,
                    Type: Type,

                    PID: PID,
                    BUSINESSNAME: BUSINESSNAME,
                    APPNAME: APPNAME,
                    CONTACT_ADDR: CONTACT_ADDR,
                    APP_FTEL: APP_FTEL,
                    APP_MTEL: APP_MTEL,
                    HardWare: HardWare,
                    SoftwareLoad: SoftwareLoad,

                    PNumber: PNumber,
                    Name: Name,
                    S_APPNAME: S_APPNAME,
                    S_CONTACT_ADDR: S_CONTACT_ADDR,
                    S_APP_FTEL: S_APP_FTEL,
                    S_APP_MTEL: S_APP_MTEL,
                    S_HardWare: S_HardWare,
                    S_SoftwareLoad: S_SoftwareLoad,

                    Final_Price: Final_Price,
                    Warranty_Date: Warranty_Date,
                    Warr_Time: Warr_Time,
                    Protect_Date: Protect_Date,
                    Prot_Time: Prot_Time,
                    Receipt_Date: Receipt_Date,
                    Receipt_PS: Receipt_PS,
                    Close_Out_Date: Close_Out_Date,
                    Close_Out_PS: Close_Out_PS
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert('新增完成');
                        //window.location.href = "/0030010000/0030010004.aspx";
                    }
                    else if (json.status == "update") {
                        alert('修改完成');
                        //window.location.href = "/0030010000/0030010015.aspx";
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    //document.getElementById("Button1").disabled = "none";
                },
                //error: function () { alert("請填完所有必填欄位"); }
            });
        }
        //=================更新
        function Data_Update() {                  //右方 存入 左方

            var str_sysid = document.getElementById("str_sysid").innerHTML;
            var OE_PS = document.getElementById("Textarea1").value;
            var Con_Name = document.getElementById("Text1").value;
            var Con_Phone = document.getElementById("Text2").value;
            var UpdateDate = document.getElementById("LoginTime").value;
            var Type_Value = document.getElementById("txt_Type_Value").value;
            var Type = document.getElementById("txt_Type").innerHTML;

            var PID = document.getElementById("DropClientCode").value;
            var BUSINESSNAME = document.getElementById("str_Client_Name").innerHTML;
            var APPNAME = document.getElementById("str_contact").value;
            var CONTACT_ADDR = document.getElementById("str_C_addr").value;
            var APP_FTEL = document.getElementById("str_fax_phone").value;
            var APP_MTEL = document.getElementById("str_mob_phone").value;
            var HardWare = document.getElementById("str_hardware").innerHTML;
            var SoftwareLoad = document.getElementById("str_software").innerHTML;

            var PNumber = document.getElementById("DropSubsidiaryCode").value;
            var Name = document.getElementById("str_Client_Name_2").innerHTML;
            var S_APPNAME = document.getElementById("str_contact_2").value;
            var S_CONTACT_ADDR = document.getElementById("str_C_addr_2").value;
            var S_APP_FTEL = document.getElementById("str_fax_phone_2").value;
            var S_APP_MTEL = document.getElementById("str_mob_phone_2").value;
            var S_HardWare = document.getElementById("str_hardware_2").innerHTML;
            var S_SoftwareLoad = document.getElementById("str_software_2").innerHTML;

            var Final_Price = document.getElementById("Final_Price").value;
            var Warranty_Date = document.getElementById("datetimepicker01").value;
            var Warr_Time = document.getElementById("Text11").value;
            var Protect_Date = document.getElementById("datetimepicker02").value;
            var Prot_Time = document.getElementById("Text12").value;
            var Receipt_Date = document.getElementById("datetimepicker03").value;
            var Receipt_PS = document.getElementById("Text13").value;
            var Close_Out_Date = document.getElementById("datetimepicker04").value;
            var Close_Out_PS = document.getElementById("Textarea2").value;

            $.ajax({
                url: '0030010015.aspx/Case_Save2',
                type: 'POST',
                data: JSON.stringify({
                    sysid: str_sysid,
                    OE_PS: OE_PS,
                    Con_Name: Con_Name,
                    Con_Phone: Con_Phone,
                    //SetupDate: SetupDate , 
                    UpdateDate: UpdateDate,
                    Type_Value: Type_Value,
                    Type: Type,

                    PID: PID,
                    BUSINESSNAME: BUSINESSNAME,
                    APPNAME: APPNAME,
                    CONTACT_ADDR: CONTACT_ADDR,
                    APP_FTEL: APP_FTEL,
                    APP_MTEL: APP_MTEL,
                    HardWare: HardWare,
                    SoftwareLoad: SoftwareLoad,

                    PNumber: PNumber,
                    Name: Name,
                    S_APPNAME: S_APPNAME,
                    S_CONTACT_ADDR: S_CONTACT_ADDR,
                    S_APP_FTEL: S_APP_FTEL,
                    S_APP_MTEL: S_APP_MTEL,
                    S_HardWare: S_HardWare,
                    S_SoftwareLoad: S_SoftwareLoad,

                    Final_Price: Final_Price,
                    Warranty_Date: Warranty_Date,
                    Warr_Time: Warr_Time,
                    Protect_Date: Protect_Date,
                    Prot_Time: Prot_Time,
                    Receipt_Date: Receipt_Date,
                    Receipt_PS: Receipt_PS,
                    Close_Out_Date: Close_Out_Date,
                    Close_Out_PS: Close_Out_PS
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert('新增完成');
                        //window.location.href = "/0030010000/0030010004.aspx";Data_Save
                    }
                    else if (json.status == "update") {
                        alert('修改完成');
                        //window.location.href = "/0030010000/0030010015.aspx";
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    //document.getElementById("Button1").disabled = "none";
                },
                //error: function () { alert("請填完所有必填欄位"); }
            });
        }

        //================審核
        function Review() {                  //右方 存入 左方
            var Type = "已經審查";
            var str_sysid = document.getElementById("str_sysid").innerHTML;
            //alert('a' + Type + 'a');
            $.ajax({
                url: '0030010015.aspx/Review',
                type: 'POST',
                data: JSON.stringify({
                    str_sysid: str_sysid,
                    Type: Type,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert('新增完成');
                        //window.location.href = "/0030010000/0030010004.aspx";
                    }
                    else if (json.status == "update") {
                        alert('已經審查');
                        //window.location.href = "/0030010000/0030010015.aspx";
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    //document.getElementById("Button1").disabled = "none";
                },
                //error: function () { alert("請填完所有必填欄位"); }
            });
        }
        //================ 帶入【廠商】資訊 ===============
        function Owner_List() {
            $.ajax({
                url: '0030010015.aspx/Owner_List',
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
            //Labor_Table();
        }
        //================ 帶入【醫療院所 】資訊 ===============
        function Hospital_List() {
            $.ajax({
                url: '0030010015.aspx/Hospital_List',
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
                url: '0030010015.aspx/Labor_Value',
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
                            url: '0030010015.aspx/Btn_Add_Click',
                            type: 'POST',
                            data: JSON.stringify({ Cust_ID: obj.data[0].Cust_ID, Labor_ID: obj.data[0].Labor_ID }),
                            contentType: 'application/json; charset=UTF-8',
                            dataType: "json",
                            success: function (doc) {
                                var json = JSON.parse(doc.d.toString());
                                alert(json.status);
                            }
                        });
                        //bindTable();
                        //=============== 帶入【已選擇的雇主或外勞（瀏覽）】資訊 ===============
                    }
                }
            });
        }       //*/

        //================ 【Flag = 0 新增需求單】 ===============
        //================ 【Flag = 1 修改需求單】 ===============
        /*       function Btn_New_Click(Flag) {
                   document.getElementById("Btn_New").disabled = true;
                   $("#Div_Loading").modal();
                   if (Agent_Mail == '0') {
                       alert('【您為新進人員或是沒有E-MAIL資料所以無法新增需求單，請尋求管理人員協助新增，謝謝】');
                       document.getElementById("Btn_New").disabled = false;
                       $("#Div_Loading").modal('hide');
                       return;
                   }
                   var PostCode = $("#hid_PostCode").val();
                   var Location = document.getElementById("txt_Location").innerHTML;  //地址
                   var Service_ID = document.getElementById("DropServiceName").value;  //服務內容
                   var time_01 = document.getElementById("datetimepicker01").value;    //預定起始時間
                   var time_02 = document.getElementById("datetimepicker02").value;    //預定終止時間
                   var time_03 = document.getElementById("datetimepicker03").value;    //登錄日期
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
                       url: '0030010015.aspx/Check_Form',
                       type: 'POST',
                       data: JSON.stringify({
                           Flag: Flag,
                           Service_ID: Service_ID,
                           Time_01: time_01,
                           Time_02: time_02,
                           PostCode: PostCode,
                           Location: Location,
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
                           else if (json.status == "update") {
                               alert('修改完成');
                               window.location.href = "/0030010000/0030010002.aspx";
                           }
                           else {
                               alert(json.status);
                           }
                           $("#Div_Loading").modal('hide');
                           document.getElementById("Btn_New").disabled = false;
                       }
                   });
               };*/

        //=========================================
        /*        function Load_MNo() {
                    $("#Div_Loading").modal();
                    $.ajax({
                        url: '0030010015.aspx/Load_MNo',
                        type: 'POST',
                        data: JSON.stringify({ MNo: new_mno }),
                        contentType: 'application/json; charset=UTF-8',
                        dataType: "json",       //如果要回傳值，請設成 json
                        success: function (doc) {
                            var text = '{"data":' + doc.d + '}';
                            var obj = JSON.parse(text);
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
                            document.getElementById("str_name").innerHTML = obj.data[0].Create_Name;
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
                            document.getElementById("HospitalClass").value = obj.data[0].HospitalClass;
                            document.getElementById("txt_CarSeat").value = obj.data[0].CarSeat;
                            document.getElementById("Question").value = obj.data[0].Question;
                            document.getElementById("datetimepicker01").value = obj.data[0].Time_01.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_01.substr(11, 5);
                            document.getElementById("datetimepicker02").value = obj.data[0].Time_02.replace(/-/g, '/').substr(0, 10) + ' ' + obj.data[0].Time_02.substr(11, 5);
        
                        }
                    });
                    document.getElementById('button_01').style.display = "none";  //客戶地址
                    document.getElementById('button_02').style.display = "none";  //單位地址
                    document.getElementById('tab_Location').style.display = "";  //顯示地址
                    $("#Div_Loading").modal('hide');
                }
                */
        //================   Load_CaseData()       
        function Load_OE_Data() {
            var OE_Case_ID = document.getElementById("str_sysid").innerHTML;
            document.getElementById("str_title").innerHTML = "(審查)OE單";
            document.getElementById('Button1').style.display = "none";  //隱藏修改按鈕
            document.getElementById('Button2').style.display = "";  //顯示 Modal_1
            document.getElementById('Button4').style.display = "";
            //str_title = "修改";
            $.ajax({
                url: '0030010015.aspx/Load_OEData',
                type: 'POST',
                data: JSON.stringify({ OE_Case_ID: OE_Case_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    document.getElementById("Textarea1").value = obj.data[0].OE_PS;
                    document.getElementById("Text1").value = obj.data[0].Con_Name;
                    document.getElementById("Text2").value = obj.data[0].Con_Phone;
                    document.getElementById("LoginTime2").innerHTML = obj.data[0].SetupDate;
                    document.getElementById("txt_Type_Value").value = obj.data[0].Type_Value;
                    document.getElementById("txt_Type").innerHTML = obj.data[0].Type;

                    style('DropClientCode', obj.data[0].PID);
                    document.getElementById("str_Client_Name").innerHTML = obj.data[0].BUSINESSNAME;    //客戶資料
                    document.getElementById("str_contact").value = obj.data[0].APPNAME;
                    document.getElementById("str_C_addr").value = obj.data[0].CONTACT_ADDR;
                    document.getElementById("str_fax_phone").value = obj.data[0].APP_FTEL;
                    document.getElementById("str_mob_phone").value = obj.data[0].APP_MTEL;
                    document.getElementById("str_hardware").innerHTML = obj.data[0].HardWare;
                    document.getElementById("str_software").innerHTML = obj.data[0].SoftwareLoad;

                    style('DropSubsidiaryCode', obj.data[0].PNumber);
                    document.getElementById("str_Client_Name_2").innerHTML = obj.data[0].Name;    //子公司資料
                    document.getElementById("str_contact_2").value = obj.data[0].S_APPNAME;
                    document.getElementById("str_C_addr_2").value = obj.data[0].S_CONTACT_ADDR;
                    document.getElementById("str_fax_phone_2").value = obj.data[0].S_APP_FTEL;
                    document.getElementById("str_mob_phone_2").value = obj.data[0].S_APP_MTEL;
                    document.getElementById("str_hardware_2").innerHTML = obj.data[0].S_HardWare;
                    document.getElementById("str_software_2").innerHTML = obj.data[0].S_SoftwareLoad;

                    document.getElementById("str_software_2").innerHTML = obj.data[0].S_SoftwareLoad;
                    document.getElementById("str_software_2").innerHTML = obj.data[0].S_SoftwareLoad;

                    document.getElementById("Final_Price").value = obj.data[0].Final_Price;
                    document.getElementById("datetimepicker01").value = obj.data[0].Warranty_Date;
                    document.getElementById("Text11").value = obj.data[0].Warr_Time;
                    document.getElementById("datetimepicker02").value = obj.data[0].Protect_Date;
                    document.getElementById("Text12").value = obj.data[0].Prot_Time;
                    document.getElementById("datetimepicker03").value = obj.data[0].Receipt_Date;
                    document.getElementById("Text13").value = obj.data[0].Receipt_PS;
                    document.getElementById("datetimepicker04").value = obj.data[0].Close_Out_Date;
                    document.getElementById("Textarea2").value = obj.data[0].Close_Out_PS;
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
                url: '0030010015.aspx/Btn_Cancel_Click',
                type: 'POST',
                data: JSON.stringify({ txt_cancel: txt_cancel }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "success") {
                        alert('需求單【' + json.mno + '】已取消');
                        window.location.href = "/0030010000/0030010004.aspx";
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
            window.location.href = "/0030010000/0030010004.aspx";
        };

        //============= 顯示【地址】名單 =============
        function Location(Type) {
            $.ajax({
                url: '0030010015.aspx/Location_List',
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
                url: '0030010015.aspx/Add_Location',
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
        }       //*/

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

    <!--===========================================表單一 無id==-->
    <div style="text-align: center; width: 1280px; margin: 10px 20px">
        <h2><label id="str_title"></label></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>資料紀錄</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%;">
                        <strong>OE編號</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="str_sysid"></label>
                        <strong><%= str_type %></strong>
                    </th>
                    <td style="text-align: center">
                        <strong>建單備註</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="不能超過150 個字元，並且含有不正確的符號">      
                                <textarea id="Textarea1" name="OpinionSubject" class="form-control" cols="45" rows="1" placeholder="建單備註" maxlength="150" onkeyup="cs(this);"
                                style="resize: none; background-color: #ffffbb"  ></textarea>
                        </div>
<!--<input type="text" class="form-control" id="Text2" name="LoginTime" style="background-color: #ffffbb" value=""/>-->
                    </td>                    
                </tr>
                
                <tr id="tr_sysid" runat="server">                                                     
                    <th style="text-align: center; width: 15%">
                        <strong>承辦人員</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip" title="必填" style="width: 100%">
                            <input type="text" class="form-control" id="Text1" name="datetimepicker01" style="background-color: #ffffbb" />
                        </div>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>連絡電話</strong>
                    </th>
                    <th style="width: 35%">
                        <div data-toggle="tooltip" title="必填" style="width: 100%">
                            <input type="text" class="form-control" id="Text2" name="Text2" style="background-color: #ffffbb" />
                        </div>
                    </th>
                </tr>                
                <tr id="tr1" runat="server">                       
                    <td style="text-align: center">
                        <strong>建單日期</strong>
                    </td>
                    <td>
                        <label id ="LoginTime2"></label>
                    </td>
                    <td style="text-align: center">
                        <strong>最後修改日</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="">
                            <input type="text" class="form-control" id="LoginTime" name="LoginTime" style="background-color: #ffffbb" value=""/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center">
                        <strong>OE單號</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="">
                            <input type="text" class="form-control" id="txt_Type_Value" name="txt_Type_Value"  style="background-color: #ffffbb" value="" />
                        </div>
                    </td> 
                    <td style="text-align: center">
                        <strong>表單狀態</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="暫訂 尚未領料:1,尚未完工:2,已經完工:3,已經驗收:4,已經結案:5 也可另行決定">
                            <label id="txt_Type"></label>
                        </div>
                    </td>                    
                </tr>                
            </tbody>
        </table>
    </div>
    <!--===========================================表單二 也無id==-->
    <div style="text-align: center; width: 1280px; margin: 10px 20px">
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
                        <strong>客戶選擇
                            <br>(以名稱或統編搜尋)</br>                            
                        </strong>
                    </th>
                    <th style="width: 35%">                        
                        <div data-toggle="tooltip" title="必選" style="width: 100%">
                            <select id="DropClientCode" name="DropClientCode" class="chosen-select" onchange="ShowClientData()">
                                <option value="">請選擇</option>
                            </select>
                        </div>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>客戶名稱</strong>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <label id="str_Client_Name"></label>
                    </th>
                </tr>
                <%--  =========== 客戶資料 ===========--%>
                <tr style="height: 55px;">                                                          <%--  Table 002-2  --%>
                    <td style="text-align: center; width: 15%">
                        <strong>聯絡人</strong>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="str_contact" name="str_contact" style="background-color: #ffffbb" value=""/>  
                    </td>
                    <td style="text-align: center; width: 15%">
                        <strong>地址</strong>
                    </td>
                    <td style="width: 35%">                                         
                        <div style="float: left" data-toggle="tooltip" title="不能超過150 個字元，並且含有不正確的符號">      
                                <textarea id="str_C_addr" name="str_C_addr" class="form-control" cols="45" rows="1" placeholder="地址" maxlength="150" onkeyup="cs(this);"
                                style="resize: none; background-color: #ffffbb"  ></textarea>
                        </div>
                    </td>
                </tr>

                <%--  =========== 勞工資料 ===========--%>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡電話</strong>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="str_mob_phone" name="str_contact" style="background-color: #ffffbb" value=""/>  
                    </td>
                    <td style="text-align: center">
                        <strong>傳真電話</strong>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="str_fax_phone" name="str_mob_phone" style="background-color: #ffffbb" value=""/>  
                    </td>
                </tr>
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
            </tbody>
        </table>
    </div>
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
                        <strong>子公司選擇
                            <br>(以名稱搜尋)</br>                            
                        </strong>
                    </th>
                    <th style="width: 35%">                        
                        <div data-toggle="tooltip" title="非必選" style="width: 100%">
                            <select id="DropSubsidiaryCode" name="DropSubsidiaryCode" class="chosen-select" onchange="ShowSubsidiaryData()">
                                <option value="">請選擇</option>
                            </select>
                        </div>
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
                        <input type="text" class="form-control" id="str_contact_2" name="str_contact" style="background-color: #ffffbb" value=""/>  
                    </td>
                    <td style="text-align: center; width: 15%">
                        <strong>(子)地址</strong>
                    </td>
                    <td style="width: 35%">                                         
                        <div style="float: left" data-toggle="tooltip" title="不能超過150 個字元，並且含有不正確的符號">      
                                <textarea id="str_C_addr_2" name="str_C_addr_2" class="form-control" cols="45" rows="1" placeholder="地址" maxlength="150" onkeyup="cs(this);"
                                style="resize: none; background-color: #ffffbb"  ></textarea>
                        </div>
                    </td>
                </tr>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>(子)聯絡電話</strong>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="str_mob_phone_2" name="str_contact" style="background-color: #ffffbb" value=""/>  
                    </td>
                    <td style="text-align: center">
                        <strong>(子)傳真電話</strong>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="str_fax_phone_2" name="str_mob_phone" style="background-color: #ffffbb" value=""/>  
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
<%--  =========== 表單一~三 結束 ===========--%>

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
        </div>
    <%--  =======表單四 OE 商品訂貨  table  id="data" === --%> 

    <h2><strong>&nbsp; &nbsp; 標地物列表&nbsp; &nbsp;</strong></h2>

    <!----------------------------------------------->

    <div class="table-responsive" style="width: 90%; margin: 10px 20px">
       <table  id="data" class="display table table-striped" style="width: 99%">            
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

    <h2><strong>&nbsp; &nbsp; 訂單列表&nbsp; &nbsp;</strong></h2>

    <!----------------------------------------------->

    <div class="table-responsive" style="width: 90%; margin: 10px 20px">
       <table  id="data2" class="display table table-striped" style="width: 99%">            
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
<%--  =========== 表單六 =開關               ========--%>
    <div style="text-align: center; width: 1280px; margin: 10px 20px">
        <h2><label id="Label1"></label></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>總價(未稅)</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%;">
                        <strong>商品合計</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="Total_Price"></label>
                    </th>
                    <th style="text-align: center; width: 15%;">
                        <strong>最終總價</strong>
                    </th>
                    <th style="text-align: center; width: 35%">
                        <div data-toggle="tooltip" title="未稅">
                            <input type="text" id="Final_Price" name="Final_Price" class="form-control" placeholder="收據總價"
                                maxlength="" style="Font-Size: 18px; background-color: #ffffbb" />
                        </div>
                    </th>
            </tbody>
            </table>
        </div>

<%--  =========== 表單六 其他資料               ========--%>
        <div style="text-align: center; width: 1280px; margin: 10px 20px">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center" colspan="4">
                            <span style="font-size: 20px"><strong>其他資料紀錄</strong></span>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th style="text-align: center; width: 15%;">
                            <strong>保固開始日</strong>
                        </th>
                        <th style="width: 35%">
                            <div style="float: left" data-toggle="tooltip" title="">
                                <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01" style="background-color: #ffffbb" />
                            </div>
                        </th>
                        <td style="text-align: center">
                            <strong>保固時間(月)</strong>
                        </td>
                        <td>
                            <div data-toggle="tooltip" title="">
                                <input type="text" id="Text11" name="Text11" class="form-control" placeholder="以月來記錄"
                                    maxlength="" style="Font-Size: 18px; background-color: #ffffbb" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: center; width: 15%; height: 55px;">
                            <strong>維護開始日</strong>
                        </th>
                        <th style="text-align: center; width: 35%">
                            <div style="float: left" data-toggle="tooltip" title="">
                                <input type="text" class="form-control" id="datetimepicker02" name="datetimepicker02" style="background-color: #ffffbb" />
                            </div>
                        </th>
                        <th style="text-align: center; width: 15%; height: 55px;">
                            <strong>維護時間(月)</strong>
                        </th>
                        <th style="text-align: center; width: 35%">
                            <div data-toggle="tooltip" title="">
                                <input type="text" id="Text12" name="Text12" class="form-control" placeholder="以月來記錄"
                                    maxlength="" style="Font-Size: 18px; background-color: #ffffbb" />
                            </div>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center; width: 15%; height: 55px;">
                            <strong>收款日期</strong>
                        </th>
                        <th style="text-align: center; width: 35%">
                            <div style="float: left" data-toggle="tooltip" title="">
                                <input type="text" class="form-control" id="datetimepicker03" name="datetimepicker03" style="background-color: #ffffbb" />
                            </div>
                        </th>
                        <th style="text-align: center; width: 15%; height: 55px;">
                            <strong>收款備註</strong>
                        </th>
                        <th style="text-align: center; width: 35%">
                            <div data-toggle="tooltip" title="">
                                <input type="text" id="Text13" name="Text13" class="form-control" placeholder="收款備註"
                                    maxlength="" style="Font-Size: 18px; background-color: #ffffbb" />
                            </div>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center; width: 15%; height: 55px;">
                            <strong>結案日期</strong>
                        </th>
                        <th style="text-align: center; width: 35%">
                            <div style="float: left" data-toggle="tooltip" title="">
                                <input type="text" class="form-control" id="datetimepicker04" name="datetimepicker04" style="background-color: #ffffbb" />
                            </div>
                        </th>
                        <th style="text-align: center; width: 15%; height: 55px;">
                            <strong>備結案註</strong>
                        </th>
                        <th style="text-align: center; width: 35%">
                            <div style="float: left" data-toggle="tooltip" title="結案備註">      
                                <textarea id="Textarea2" name="OpinionSubject" class="form-control" cols="45" rows="1" placeholder="結案備註" maxlength="150" onkeyup="cs(this);"
                                style="resize: none; background-color: #ffffbb"  ></textarea>
                        </div>
                        </th>
                    </tr>                    
                </tbody>
            </table>
        </div>



        



  <%--       <table class="table table-bordered table-striped">
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
                            <textarea id="Reply" name="Reply" class="form-control" cols="45" rows="3" placeholder="客服處理 回覆內容" maxlength="400" onkeyup="cs(this);"
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

            <button id="Button1" type="button" onclick="Data_Save();" class="btn btn-success btn-lg "><span class="glyphicon glyphicon-ok"></span>確定&nbsp;&nbsp;</button>
            <button id="Button2" type="button" onclick="Data_Update();" class="btn btn-primary btn-lg "><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>&nbsp; &nbsp;
            <button id="Button4" type="button" onclick="Review();" class="btn btn-primary btn-lg "><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;審核</button>&nbsp; &nbsp;                        
            <button id="Button3" type="button" onclick="Btn_Back_Click();" class="btn btn-default btn-lg ">&nbsp;&nbsp;取消<span class="glyphicon glyphicon-share-alt"></span></button>

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
            $('#datetimepicker04').datetimepicker({
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
