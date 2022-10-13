<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0060010000.aspx.cs" Inherits="_0060010000" %>

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
        var PID = '<%= new_mno %>';
        var Agent_Mail = '<%= Session["Agent_Mail"] %>';
        //====================================================

        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            ShowTime();
            if (seqno != '0') {
                //alert(PID+'PID');
                //alert(seqno + 'seqno');
                Load_BusData();
                bindTable_2();             //子公司列表
            } else {
                //bindTable();  //顯示【新增多筆資訊（瀏覽）】名單
                //Labor_Table();  //顯示【新增雇主及外勞】名單
                alert('無此子公司編號');                
                //alert(seqno);
            }
        }); //*/

        //================ 讀取資訊 ===============


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
            document.getElementById('LoginTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
            //document.getElementById('EstimatedFinishTime').innerHTML = y + "/" + mon + "/" + d + " " + h + ":" + m;             // 估計完成時間            
        }

        function bindTable_2() {            // 子公司列表
            //alert(seqno);
            //alert(PID);
            $.ajax({
                url: '0060010000.aspx/GetSubsidiaryList',
                type: 'POST',
                data: JSON.stringify({ PID: seqno }),
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
                                { data: "PNumber" },
                                { data: "SalseAgent" },
                                { data: "BUSINESSNAME" },
                                { data: "Information_PS" },
                                //{ data: "SetupDate" },
                                { data: "UpDateDate" },
                                {
                                    data: "SYSID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-primary btn-lg' " +
                                            "data-toggle='modal' data-target='#newModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'>" +
                                            "</span>&nbsp;修改</button>";
                                    }
                                }
                        ]
                    });
                    $('#Table1 tbody').unbind('click').
                        on('click', '#edit', function () {
                            //var PID = table.row($(this).parents('tr')).data().PID;
                            var table = $('#Table1').DataTable();
                            var PNumber = table.row($(this).parents('tr')).data().PNumber;
                            //alert("A"+PNumber+"A");
                            Load_Modal( PNumber);     //未改完 1 要換 PNumber
                        });
                }
            });
        }
        //==========
        function Load_Modal(PNumber) {                                          // 讀資料
            //alert(PID);
            if (PNumber == 0) {
                //alert('檢查中1');
                document.getElementById("Button_new").style.display = "";
                document.getElementById("Button_update").style.display = "none";
                document.getElementById("Label1").innerHTML = '子公司資料（新增）';

                document.getElementById("PNumber").innerHTML = "";
                document.getElementById("Name").value = "";
                document.getElementById("Text9_2").value = "";
                document.getElementById("Text10_2").value = "";
                document.getElementById("Text11_2").value = "";
                document.getElementById("Text12_2").value = "";
                document.getElementById("id").value = "";
                document.getElementById("Text1_2").value = "";
                document.getElementById("Text2_2").value = "";
                document.getElementById("Text3_2").value = "";
                document.getElementById("Text4_2").value = "";
                document.getElementById("Text5_2").value = "";
                document.getElementById("Text6_2").value = "";
                document.getElementById("Text7_2").value = "";
                document.getElementById("Text8_2").value = "";
                document.getElementById("Text13_2").value = "";
                document.getElementById("Text14_2").value = "";
                document.getElementById("Text15_2").value = "";
                document.getElementById("Text16_2").value = "";
                document.getElementById("Text17_2").value = "";
                document.getElementById("Text18_2").value = "";
                document.getElementById("Text19_2").value = "";
                document.getElementById("Text20_2").value = "";
                document.getElementById("Text21_2").value = "";
                document.getElementById("Text22_2").value = "";
                document.getElementById("Text23_2").value = "";
                document.getElementById("Text24_2").value = "";
                document.getElementById("Text25_2").value = "";
                document.getElementById("Text26_2").value = "";
                document.getElementById("Text27_2").value = "";
                document.getElementById("Text28_2").value = "";
                document.getElementById("Text29_2").value = "";
                style('Text30_2', '');
                document.getElementById("T_ID_2").value = "";
                document.getElementById("Text31_2").value = "";
                document.getElementById("Text32_2").value = "";
                document.getElementById("Text33_2").value = "";
                document.getElementById("Text34_2").value = "";
                document.getElementById("datetimepicker02").value = "";
                document.getElementById("Text35_2").value = "";
                document.getElementById("datetimepicker03").value = "";
                document.getElementById("Text36_2").value = "";
                document.getElementById("datetimepicker04").value = "";
                document.getElementById("Text37_2").value = "";
                document.getElementById("datetimepicker05").value = "";
                document.getElementById("Text38_2").value = "";
                document.getElementById("Text39_2").value = "";
                document.getElementById("Text40_2").value = "";
                document.getElementById("SetupDate").innerHTML = "";    //*/
            } else {
                //alert('檢查中2');
                //document.getElementById("txt_ROLE_ID").disabled = true;
                document.getElementById("Button_update").style.display = "";                               //顯示修改鈕
                document.getElementById("Button_new").style.display = "none";                          //隱藏新增鈕
                document.getElementById("Label1").innerHTML = '子公司資料（修改）';
                Load_Data(PNumber);
            }   //else 結束
        }
        //========
        function Load_Data(PNumber) {
            //alert('Load_Data');
            $.ajax({
                url: '0060010000.aspx/Load_Data',    // 還沒弄Load_Data_02
                type: 'POST',
                data: JSON.stringify({ PNumber: PNumber }),
                //data: JSON.stringify({ PID: seqno }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    document.getElementById("PNumber").innerHTML = obj.data[0].PNumber;
                    document.getElementById("Name").value = obj.data[0].Name;   //沒用到要遮蔽
                    document.getElementById("Text9_2").value = obj.data[0].ADDR;
                    document.getElementById("Text10_2").value = obj.data[0].CONTACT_ADDR;
                    document.getElementById("Text11_2").value = obj.data[0].APP_OTEL;
                    document.getElementById("Text12_2").value = obj.data[0].APP_FTEL;

                    //document.getElementById("PID_2").innerHTML = obj.data[0].PID;   //沒用到要遮蔽
                    //document.getElementById("business_name_2").innerHTML = obj.data[0].BUSINESSNAME;
                    //document.getElementById("business_id_2").innerHTML = obj.data[0].BUSINESSID;
                    //document.getElementById("id_2").value = obj.data[0].ID;
                    document.getElementById("id").value = obj.data[0].ID;
                    document.getElementById("Text1_2").value = obj.data[0].APPNAME;
                    document.getElementById("Text2_2").value = obj.data[0].APP_SUBTITLE;
                    document.getElementById("Text3_2").value = obj.data[0].APP_MTEL;
                    document.getElementById("Text4_2").value = obj.data[0].APP_EMAIL;
                    document.getElementById("Text5_2").value = obj.data[0].APPNAME_2;
                    document.getElementById("Text6_2").value = obj.data[0].APP_SUBTITLE_2;
                    document.getElementById("Text7_2").value = obj.data[0].APP_MTEL_2;
                    document.getElementById("Text8_2").value = obj.data[0].APP_EMAIL_2;
                    document.getElementById("Text13_2").value = obj.data[0].INVOICENAME;
                    document.getElementById("Text14_2").value = obj.data[0].Inads;
                    document.getElementById("Text15_2").value = obj.data[0].HardWare;
                    document.getElementById("Text16_2").value = obj.data[0].SoftwareLoad;
                    document.getElementById("Text17_2").value = obj.data[0].Mail_Type;
                    document.getElementById("Text18_2").value = obj.data[0].OE_Number;
                    document.getElementById("Text19_2").value = obj.data[0].SalseAgent;
                    document.getElementById("Text20_2").value = obj.data[0].Salse;
                    document.getElementById("Text21_2").value = obj.data[0].Salse_TEL;
                    document.getElementById("Text22_2").value = obj.data[0].SID;
                    document.getElementById("Text23_2").value = obj.data[0].Serial_Number;
                    document.getElementById("Text24_2").value = obj.data[0].License_Host;
                    document.getElementById("Text25_2").value = obj.data[0].Licence_Name;
                    document.getElementById("Text26_2").value = obj.data[0].LAC;
                    document.getElementById("Text27_2").value = obj.data[0].Our_Reference;
                    document.getElementById("Text28_2").value = obj.data[0].Your_Reference;
                    document.getElementById("Text29_2").value = obj.data[0].Auth_File_ID;
                    if (obj.data[0].Telecomm_ID != "中華電信" && obj.data[0].Telecomm_ID != "遠傳" && obj.data[0].Telecomm_ID != "德瑪") {
                        style('Text30_2', '其他');
                        document.getElementById("T_ID_2").value = obj.data[0].Telecomm_ID;
                    }
                    else {
                        style('Text30_2', obj.data[0].Telecomm_ID);
                        document.getElementById("T_ID_2").value = "";
                    }
                    document.getElementById("Text31_2").value = obj.data[0].FL;
                    document.getElementById("Text32_2").value = obj.data[0].Group_Name_ID;
                    document.getElementById("Text33_2").value = obj.data[0].SED;
                    document.getElementById("Text34_2").value = obj.data[0].SERVICEITEM;
                    document.getElementById("datetimepicker02").value = obj.data[0].Warranty_Date;
                    document.getElementById("Text35_2").value = obj.data[0].Warr_Time;
                    document.getElementById("datetimepicker03").value = obj.data[0].Protect_Date;
                    document.getElementById("Text36_2").value = obj.data[0].Prot_Time;
                    document.getElementById("datetimepicker04").value = obj.data[0].Receipt_Date;
                    document.getElementById("Text37_2").value = obj.data[0].Receipt_PS;
                    document.getElementById("datetimepicker05").value = obj.data[0].Close_Out_Date;
                    document.getElementById("Text38_2").value = obj.data[0].Close_Out_PS;
                    document.getElementById("Text39_2").value = obj.data[0].Account_PS;
                    document.getElementById("Text40_2").value = obj.data[0].Information_PS;
                    document.getElementById("SetupDate").innerHTML = obj.data[0].SetupDate;     //*/
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }

        //================ 存新子公司用===============
        function Safe(Flag) {
            document.getElementById("Button_update").disabled = true;
            document.getElementById("Button_new").disabled = true;
            PID = seqno;
            var Flag = Flag;
            var PNumber = document.getElementById("PNumber").innerHTML;
            var Name = document.getElementById("Name").value;
            var ADDR = document.getElementById("Text9_2").value;
            var Contact_ADDR = document.getElementById("Text10_2").value;
            //var BUSINESSID = document.getElementById("business_id").value;
            //var ID = document.getElementById("id").value;
            var ID = document.getElementById("id").value;
            var APPNAME = document.getElementById("Text1_2").value;
            var APP_SUBTITLE = document.getElementById("Text2_2").value;
            var APP_MTEL = document.getElementById("Text3_2").value;
            var APP_EMAIL = document.getElementById("Text4_2").value;
            var APPNAME_2 = document.getElementById("Text5_2").value;
            var APP_SUBTITLE_2 = document.getElementById("Text6_2").value;
            var APP_MTEL_2 = document.getElementById("Text7_2").value;
            var APP_EMAIL_2 = document.getElementById("Text8_2").value;
            var APP_OTEL = document.getElementById("Text11_2").value;
            var APP_FTEL = document.getElementById("Text12_2").value;
            var INVOICENAME = document.getElementById("Text13_2").value;
            var Inads = document.getElementById("Text14_2").value;
            var HardWare = document.getElementById("Text15_2").value;
            var SoftwareLoad = document.getElementById("Text16_2").value;
            var Mail_Type = document.getElementById("Text17_2").value;
            var OE_Number = document.getElementById("Text18_2").value;
            var SalseAgent = document.getElementById("Text19_2").value;
            var Salse = document.getElementById("Text20_2").value;
            var Salse_TEL = document.getElementById("Text21_2").value;
            var SID = document.getElementById("Text22_2").value;
            var Serial_Number = document.getElementById("Text23_2").value;
            var License_Host = document.getElementById("Text24_2").value;
            var Licence_Name = document.getElementById("Text25_2").value;
            var LAC = document.getElementById("Text26_2").value;
            var Our_Reference = document.getElementById("Text27_2").value;
            var Your_Reference = document.getElementById("Text28_2").value;
            var Auth_File_ID = document.getElementById("Text29_2").value;
            var Telecomm_ID = document.getElementById("Text30_2").value;
            if (Telecomm_ID == "其他")
                Telecomm_ID = document.getElementById("T_ID_2").value;
            var FL = document.getElementById("Text31_2").value;
            var Group_Name_ID = document.getElementById("Text32_2").value;
            var SED = document.getElementById("Text33_2").value;
            var SERVICEITEM = document.getElementById("Text34_2").value;
            var Warranty_Date = document.getElementById("datetimepicker02").value;
            var Warr_Time = document.getElementById("Text35_2").value;
            var Protect_Date = document.getElementById("datetimepicker03").value;
            var Prot_Time = document.getElementById("Text36_2").value;
            var Receipt_Date = document.getElementById("datetimepicker04").value;
            var Receipt_PS = document.getElementById("Text37_2").value;
            var Close_Out_Date = document.getElementById("datetimepicker05").value;
            var Close_Out_PS = document.getElementById("Text38_2").value;
            var Account_PS = document.getElementById("Text39_2").value;
            var Information_PS = document.getElementById("Text40_2").value;
            var UpDateDate = document.getElementById("LoginTime").value;
            var SetupDate = document.getElementById("LoginTime").value;
            //alert(PNumber);
            //alert(PID);
            $.ajax({
                url: '0060010000.aspx/Safe2',
                type: 'POST',
                //data: JSON.stringify({ PID: seqno }),
                data: JSON.stringify({
                    PID: PID,
                    PNumber: PNumber,
                    Flag: Flag,
                    Name: Name, 
                    ID: ID,
                    APPNAME: APPNAME, APP_SUBTITLE: APP_SUBTITLE,
                    APP_MTEL: APP_MTEL, APP_EMAIL: APP_EMAIL,
                    APPNAME_2: APPNAME_2, APP_SUBTITLE_2: APP_SUBTITLE_2,
                    APP_MTEL_2: APP_MTEL_2, APP_EMAIL_2: APP_EMAIL_2,
                    ADDR: ADDR, Contact_ADDR: Contact_ADDR,
                    APP_OTEL: APP_OTEL, APP_FTEL: APP_FTEL,
                    INVOICENAME: INVOICENAME, Inads: Inads,
                    HardWare: HardWare, SoftwareLoad: SoftwareLoad,
                    Mail_Type: Mail_Type, OE_Number: OE_Number,
                    SalseAgent: SalseAgent, Salse: Salse,
                    Salse_TEL: Salse_TEL, SID: SID,
                    Serial_Number: Serial_Number, License_Host: License_Host,
                    Licence_Name: Licence_Name, LAC: LAC,
                    Our_Reference: Our_Reference, Your_Reference: Your_Reference,
                    Auth_File_ID: Auth_File_ID, Telecomm_ID: Telecomm_ID,
                    FL: FL, Group_Name_ID: Group_Name_ID,
                    SED: SED, SERVICEITEM: SERVICEITEM,
                    Warranty_Date: Warranty_Date, Warr_Time: Warr_Time,
                    Protect_Date: Protect_Date, Prot_Time: Prot_Time,
                    Receipt_Date: Receipt_Date, Receipt_PS: Receipt_PS,
                    Close_Out_Date: Close_Out_Date, Close_Out_PS: Close_Out_PS,
                    Account_PS: Account_PS, Information_PS: Information_PS,
                    UpDateDate: UpDateDate, SetupDate: SetupDate
                    // 共讀取 51 個 含Flag

                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert("新增完成！")
                        bindTable_2();
                    }
                    else if (json.status == "update") {
                        alert("修改完成！");
                        bindTable_2();
                    }
                    else {
                        alert(json.status);
                    }
                    document.getElementById("Button_update").disabled = false;
                    document.getElementById("Button_new").disabled = false;
                },
                error: function () {
                    document.getElementById("Button_update").disabled = false;
                    document.getElementById("Button_new").disabled = false;
                }
            });
        }


       //================   Load_CaseData()      讀取 母公司資料
        function Load_BusData() {                        
            $.ajax({
                url: '0060010000.aspx/Load_BusData',
                type: 'POST',
                data: JSON.stringify({ PID: seqno }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                           
                    document.getElementById("PID").innerHTML = obj.data[0].PID;
                    document.getElementById("BUSINESSNAME").innerHTML = obj.data[0].BUSINESSNAME;
                    document.getElementById("ID").innerHTML = obj.data[0].ID;
                    document.getElementById("CONTACT_ADDR").value = obj.data[0].CONTACT_ADDR;
                    document.getElementById("APP_OTEL").innerHTML = obj.data[0].APP_OTEL;
                    document.getElementById("APP_FTEL").innerHTML = obj.data[0].APP_FTEL;
                    document.getElementById("APPNAME").innerHTML = obj.data[0].APPNAME;
                    document.getElementById("APP_SUBTITLE").innerHTML = obj.data[0].APP_SUBTITLE;
                    document.getElementById("APP_MTEL").innerHTML = obj.data[0].APP_MTEL;
                    document.getElementById("APP_EMAIL").innerHTML = obj.data[0].APP_EMAIL;

/*                   switch (obj.data[0].OpinionType) {          //意見類型
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
                   }    //*/

                    //alert(12345);      跳出提醒訊息(測試用)
                }
            });
            //document.getElementById('button_01').style.display = "none";  //客戶地址    額外的按鈕          
            //document.getElementById('button_02').style.display = "none";  //單位地址
            //document.getElementById('tab_Location').style.display = "";  //顯示地址
            $("#Div_Loading").modal('hide');        // 功能??
        }


        //==============================資料增改相關
        function Xin_De_02() {     //按 子公司新增 後
            //alert('新增子公司');
            Load_Modal("0");
        }

        //================ 【取消需求單】 ===============
        function Btn_Cancel_Click() {
            $("#Div_Loading").modal();
            var txt_cancel = document.getElementById("txt_cancel").value;
            $.ajax({
                url: '0060010000.aspx/Btn_Cancel_Click',
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

        //================== 【返回客戶資料維護】 =================
        function Btn_Back_Click() {
            window.location.href = "/0060010001.aspx";
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
            //  $('.chosen-single').css({ 'background-color': '#ffffbb' });
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
    <div class="modal fade" id="Lab1" role="dialog" data-backdrop="static" data-keyboard="false">
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

    <!--=========================================-->  <%-- 表格 子公司資料維護--%>
    <div style="width: 1280px; margin: 10px 20px">
        <h2><strong>子公司資料維護</strong></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>客戶資料</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%">
                        <strong>客戶名稱</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="BUSINESSNAME" ></label>
                    </th>
                    <th style="text-align: center; width: 15%;">
                        <strong>客戶編號</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="PID"></label>
                    </th>                    
                </tr> 
                <tr id="tr_sysid" runat="server">
                    <td style="text-align: center">
                        <strong>客戶統編</strong>
                    </td>
                    <td>
                        <label id="ID"></label> 
                    </td>
                    <td style="text-align: center">
                        <strong>通訊地址</strong>
                    </td>
                    <td>
                        <label id="CONTACT_ADDR"></label> 
                    </td>
                </tr>
                <tr id="tr1" runat="server">
                    <td style="text-align: center">
                        <strong>公司電話</strong>
                    </td>
                    <td>
                        <label id="APP_OTEL"></label> 
                    </td>
                    <td style="text-align: center">
                        <strong>傳真電話</strong>
                    </td>
                    <td>
                        <label id="APP_FTEL"></label> 
                    </td>
                </tr>
                <tr id="tr2" runat="server">
                    <td style="text-align: center">
                        <strong>聯絡人</strong>
                    </td>
                    <td>
                        <label id="APPNAME"></label> 
                    </td>
                    <td style="text-align: center">
                        <strong>職稱</strong>
                    </td>
                    <td>
                        <label id="APP_SUBTITLE"></label> 
                    </td>
                </tr>
                <tr id="tr3" runat="server">
                    <td style="text-align: center">
                        <strong>行動電話</strong>
                    </td>
                    <td>
                        <label id="APP_MTEL"></label> 
                    </td>
                    <td style="text-align: center">
                        <strong>E-mail</strong>
                    </td>
                    <td>
                        <label id="APP_EMAIL"></label> 
                    </td>
                </tr>
            </tbody>
        </table>

 <!--==================子公司資料列表==========================-->

        <div class="table-responsive" style="text-align: center; width: 95%; margin: 10px 20px">
            <h2><strong>子公司清單&nbsp; &nbsp;
                <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#newModal"
                    style="Font-Size: 20px;" onclick="Xin_De_02()">
                    <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增子公司</button>
            </strong></h2>
            <table id="Table1" class="display table table-striped" style="width: 99%">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 10%;">子公司編號</th>
                        <th style="text-align: center; width: 15%">經銷商</th>
                        <th style="text-align: center; width: 15%">子公司名稱</th>
                        <th style="text-align: center; width: 20%">備註</th>
                        <!--<th style="text-align: center; width: 15%">建檔日期</th>-->
                        <!--<th style="text-align: center;">異動者</th>-->
                        <th style="text-align: center; width: 15%">異動日期</th>
                        <th style="text-align: center; width: 10%">修改</th>
                    </tr>
                </thead>
            </table>
        </div>



        <%--=========== 子單 ===========--%>

        <div style="text-align: center">
            <%--
            <button id="Button1" type="button" onclick="Data_Save();" class="btn btn-success btn-lg "><span class="glyphicon glyphicon-ok"></span>確定&nbsp;&nbsp;</button>
            --%>
            <button id="Button3" type="button" onclick="Btn_Back_Click();" class="btn btn-default btn-lg ">&nbsp;&nbsp;返回<span class="glyphicon glyphicon-share-alt"></span></button>

        </div>
        <!--===================================================-->
           <!-- ====== 子資料新增修改表 ====== -->
    <div class="modal fade" id="newModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1200px;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="Label1"></label>
                    </strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== 表格 -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>

                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>子公司資料</strong><label id="PNumber"></label></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>子公司名稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <input type="text" id="Name" name="Name" class="form-control" placeholder=""
                                            maxlength="30" style="Font-Size: 18px; background-color: #ffffbb" />
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>統一編號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="id" name="id" style="background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->                            
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>聯絡人1</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text1_2" name="APPNAME" class="form-control" placeholder="聯絡人1"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>職稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text2_2" name="txt_Agent_Name" class="form-control" placeholder="職稱"
                                            maxlength="20" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>行動電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text3_2" name="txt_Agent_Name" class="form-control" placeholder="行動電話"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>E-mail</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text4_2" name="txt_Agent_Name" class="form-control" placeholder="E-mail"
                                            maxlength="30" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>

                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>聯絡人2</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text5_2" name="txt_Agent_Name2" class="form-control" placeholder="聯絡人2"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>職稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text6_2" name="txt_Agent_Name2" class="form-control" placeholder="職稱"
                                            maxlength="20" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>行動電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text7_2" name="txt_Agent_Name2" class="form-control" placeholder="行動電話"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>E-mail</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text8_2" name="txt_Agent_Name2" class="form-control" placeholder="E-mail"
                                            maxlength="30" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>

                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>維護地址</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text9_2" name="txt_Agent_Name" class="form-control" placeholder="維護地址"
                                            maxlength="30" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>通訊地址</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text10_2" name="txt_Agent_Name" class="form-control" placeholder="通訊地址"
                                            maxlength="30" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>公司電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text11_2" name="txt_Agent_Name" class="form-control" placeholder="公司電話"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>傳真電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text12_2" name="txt_Agent_Name" class="form-control" placeholder="傳真電話"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>註冊公司</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text13_2" name="R_C_Name_ID" class="form-control" placeholder="註冊公司"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Inads</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text14_2" name="Inads" class="form-control" placeholder="Inads"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Hardware</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text15_2" name="Hardware" class="form-control" placeholder="Hardware"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Software Load</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text16_2" name="Software_Load" class="form-control" placeholder="Software Load"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>維護廠商</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必選" style="width: 60%">
                                        <select id="Text30_2" name="txt_Telecomm_ID" class="chosen-select" onchange="">
                                            <option value="">請選擇維護廠商…</option>
                                            <option value="中華電信">中華電信</option>
                                            <option value="遠傳">遠傳</option>
                                            <option value="德瑪">德瑪</option>
                                            <option value="其他">其他</option>
                                        </select>
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>其他</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="T_ID_2" name="txt_Telecomm_ID2" class="form-control" placeholder="維護廠商選其他時填"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Mail Type </strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text17_2" name="Mail_Type " class="form-control" placeholder="Mail Type "
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>OE號碼</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text18_2" name="OE_Number" class="form-control" placeholder="OE號碼"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>經銷商</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text19_2" name="txt_Agent_Name" class="form-control" placeholder="經銷商"
                                            maxlength="20" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>經銷商聯絡人</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text20_2" name="txt_Agent_Name2" class="form-control" placeholder="經銷商聯絡人"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>

                            <th style="text-align: center; width: 15%; height: 55px;">
                                <strong>聯絡電話</strong>
                            </th>
                            <th style="text-align: center; width: 35%">
                                <div data-toggle="tooltip" title="不能超過５０個字">
                                    <input type="text" id="Text21_2" name="txt_Agent_Phone" class="form-control" placeholder="聯絡電話"
                                        maxlength="10" style="Font-Size: 18px; " />
                                </div>
                            </th>
                            <th style="text-align: center; width: 15%; height: 55px;">
                                <strong>SID</strong>
                            </th>
                            <th style="text-align: center; width: 35%">
                                <div data-toggle="tooltip" title="不能超過５０個字">
                                    <input type="text" id="Text22_2" name="SID" class="form-control" placeholder="SID"
                                        maxlength="10" style="Font-Size: 18px; " />
                                </div>
                            </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>序列號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" class="form-control" id="Text23_2" name="Serial_Number" placeholder="序列號"
                                            style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>License Host</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" class="form-control" id="Text24_2" name="Serial_Number" placeholder="License Host"
                                            style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <th style="text-align: center; width: 15%; height: 55px;">
                                <strong>許可證名稱</strong>
                            </th>
                            <th style="text-align: center; width: 35%">
                                <div data-toggle="tooltip" title="不能超過５０個字">
                                    <input type="text" id="Text25_2" name="Licence_Name" class="form-control" placeholder="許可證名稱"
                                        maxlength="10" style="Font-Size: 18px; " />
                                </div>
                            </th>
                            <th style="text-align: center; width: 15%; height: 55px;">
                                <strong>LAC</strong>
                            </th>
                            <th style="text-align: center; width: 35%">
                                <div data-toggle="tooltip" title="不能超過５０個字">
                                    <input type="text" id="Text26_2" name="LAC" class="form-control" placeholder="LAC"
                                        maxlength="10" style="Font-Size: 18px; " />
                                </div>
                            </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>我方參考</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" class="form-control" id="Text27_2" name="Our_Reference" placeholder="我方參考"
                                            style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>對方參考</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" class="form-control" id="Text28_2" name="Your_Reference" placeholder="對方參考"
                                            style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>認證檔號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text29_2" name="Auth_File_ID" class="form-control" placeholder="認證檔號"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>FL</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text31_2" name="FL" class="form-control" placeholder="FL"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Group Name-ID</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text32_2" name="Group_Name_D" class="form-control" placeholder="Group Name-ID"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>SED</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text33_2" name="SED" class="form-control" placeholder="SED"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>合約狀態</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text34_2" name="R_C_Name_ID" class="form-control" placeholder="合約狀態"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>

                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>保固開始日</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" class="form-control" id="datetimepicker02" name="time_02" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>保固時間(月)</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text35_2" name="" class="form-control" placeholder="以月來記錄"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>維護開始日</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" class="form-control" id="datetimepicker03" name="time_03" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>維護時間(月)</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text36_2" name="" class="form-control" placeholder="以月來記錄"
                                            maxlength="10" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>收款日期</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" class="form-control" id="datetimepicker04" name="time_04" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>收款備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０００個字">
                                        <textarea id="Text37_2" name="Text37_2" class="form-control" cols="45" rows="3" placeholder="收款備註" 
                                            maxlength="2000" onkeyup="cs(this);" style="resize: none;"></textarea>
                                        <!--<input type="text" id="Text37_2" name="" class="form-control" placeholder="收款備註"
                                            maxlength="10" style="Font-Size: 18px; " />-->
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>結案日期</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" class="form-control" id="datetimepicker05" name="time_05" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>備結案註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０００個字">
                                        <textarea id="Text38_2" name="Text38_2" class="form-control" cols="45" rows="3" placeholder="備結案註" 
                                            maxlength="2000" onkeyup="cs(this);" style="resize: none;"></textarea>
                                        <!--<input type="text" id="Text38_2" name="" class="form-control" placeholder="結案備註"
                                            maxlength="10" style="Font-Size: 18px; " />-->
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>顧客帳密備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０００個字">
                                        <textarea id="Text39_2" name="Text39_2" class="form-control" cols="45" rows="3" placeholder="顧客帳密備註" 
                                            maxlength="2000" onkeyup="cs(this);" style="resize: none;"></textarea>
                                        <!--<input type="text" id="Text39_2" name="" class="form-control" placeholder="顧客帳密備註"
                                            maxlength="10" style="Font-Size: 18px; " />-->
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>顧客資訊備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０００個字">
                                        <textarea id="Text40_2" name="Text40_2" class="form-control" cols="45" rows="3" placeholder="顧客資訊備註" 
                                            maxlength="2000" onkeyup="cs(this);" style="resize: none;"></textarea>
                                        <!--<input type="text" id="Text40_2" name="" class="form-control" placeholder="顧客資訊備註"
                                            maxlength="10" style="Font-Size: 18px; " />-->
                                    </div>
                                </th>
                            </tr>

                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 65px;">
                                    <strong>最後修檔日期</strong>
                                </th>
                                <th>
                                    <div style="float: left" data-toggle="tooltip" title="必填">

                                        <input type="text" class="form-control" id="LoginTime" name="LoginTime" style="" value="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 65px;">
                                    <strong>建檔日期</strong>
                                </th>
                                <th>
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <label id="SetupDate"></label>
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;"></th>
                                <th style="text-align: center; width: 35%; height: 65px;" colspan="2">
                                    <button id="Button_new" type="button" class="btn btn-success btn-lg" onclick="Safe(0)" ><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <button id="Button_update" type="button" class="btn btn-primary btn-lg" onclick="Safe(1)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal">
                        <span class="glyphicon glyphicon-remove"></span>
                        &nbsp;取消</button><!--New(0) New(1) 換 Safe -->
                                </th>
                            </tr>
                        </tbody>
                    </table>
                    <!-- ========================================== -->
                </div>

                <div class="modal-footer">
                    
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
            $('#datetimepicker04').datetimepicker({
                allowTimes: [
                    '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
                ]
            });
            $('#datetimepicker05').datetimepicker({
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
