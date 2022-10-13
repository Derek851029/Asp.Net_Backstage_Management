<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0030010096.aspx.cs" Inherits="_0030010096" %>

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
            if (seqno != '0') {
                //alert(seqno + 'seqno');
                Load_CaseData();
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
                url: '0030010096.aspx/GetSubsidiaryList',
                type: 'POST',
                data: JSON.stringify({  }),
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
                                { data: "A" },
                                { data: "B" },
                                { data: "C" },
                                { data: "D" },
                                { data: "E" },
                                {
                                    data: "F", render: function (data, type, row, meta) {
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
        function Load_Modal(Flag) {                                          // 讀資料
            //alert(PID);
            if (Flag == 0) {
                //alert(Flag'檢查中1');
                document.getElementById("Label1").innerHTML = '1';
                document.getElementById("Button_new").style.display = "";
                document.getElementById("Button_update").style.display = "none";
                document.getElementById("Handle_Agent").value = document.getElementById("A_N").innerHTML;
                document.getElementById("C_PS").value = "";
                $.ajax({
                    url: '0030010096.aspx/Load_Time',
                    type: 'POST',
                    data: JSON.stringify({ Case_ID: seqno }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var text = '{"data":' + doc.d + '}';
                        var obj = JSON.parse(text);
                        document.getElementById("datetimepicker02").value = obj.data[0].R_T;
                    }
                });
                $.ajax({
                    url: '0030010096.aspx/Count',
                    type: 'POST',
                    data: JSON.stringify({ Case_ID: seqno }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var text = '{"data":' + doc.d + '}';
                        var obj = JSON.parse(text);
                        document.getElementById("datetimepicker02").value = obj.data[0].R_T;
                    }
                });

            } else {
                //alert('檢查中2');
                //document.getElementById("txt_ROLE_ID").disabled = true;
                document.getElementById("Button_update").style.display = "";                               //顯示修改鈕
                document.getElementById("Button_new").style.display = "none";                          //隱藏新增鈕
                document.getElementById("Label1").innerHTML = '子公司資料（修改）';
                Load_Data(PNumber);
            }   //else 結束
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
                url: '0030010096.aspx/Safe2',
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
        function Load_CaseData() {                        
            $.ajax({
                url: '0030010096.aspx/Load_CaseData',
                type: 'POST',
                data: JSON.stringify({ C_ID2: seqno }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);                           
                    document.getElementById("C_ID2").innerHTML = obj.data[0].C_ID2;
                    document.getElementById("BUSINESSNAME").innerHTML = obj.data[0].BUSINESSNAME;
                    document.getElementById("Urgency").innerHTML = obj.data[0].Urgency;
                    document.getElementById("OpinionType").innerHTML = obj.data[0].OpinionType;
                    document.getElementById("Opinion").value = obj.data[0].Opinion;
                    document.getElementById("A_N").innerHTML = obj.data[0].A_N;
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }


        //==============================資料增改相關
        function Xin_De_02() {     //按 新增 連續派工後
            Load_Modal("0");
        }

        //================ 【取消需求單】 ===============
        function Btn_Cancel_Click() {
            $("#Div_Loading").modal();
            var txt_cancel = document.getElementById("txt_cancel").value;
            $.ajax({
                url: '0030010096.aspx/Btn_Cancel_Click',
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

        //================== 【返回個人派工單】 =================
        function URL2() {
            $.ajax({
                url: '0030010096.aspx/URL',
                type: 'POST',
                data: JSON.stringify({ mno: seqno }),
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

    <!--=========================================-->  <%-- 表格 多天處理紀錄--%>
    <div style="width: 1280px; margin: 10px 20px">
        <h2><strong>多日處理紀錄</strong></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>案件資料</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%;">
                        <strong>案件編號</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="C_ID2"></label>
                    </th>                    
                    <th style="text-align: center; width: 15%">
                        <strong>客戶名稱</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="BUSINESSNAME" ></label>
                    </th>
                </tr> 
                <tr>
                    <td style="text-align: center">
                        <strong>緊急程度</strong>
                    </td>
                    <td>
                        <label id="Urgency"></label> 
                    </td>
                    <td style="text-align: center">
                        <strong>意見類型</strong>
                    </td>
                    <td>
                        <label id="OpinionType"></label> 
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center">
                        <strong>意見內容</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="">
                            <textarea id="Opinion" name="Opinion" class="form-control" cols="44" rows="3" placeholder="意見內容" maxlength="1000" onkeyup=""
                                style="resize: none;"></textarea>
                        </div> 
                    </td>
                    <td style="text-align: center">
                        <strong>處理人員</strong>
                    </td>
                    <td>
                        <label id="A_N"></label>
                    </td>
                </tr>                
            </tbody>
        </table>

 <!--==================子公司資料列表==========================-->

        <div class="table-responsive" style="text-align: center; width: 95%; margin: 10px 20px">
            <h2><strong>多日派工清單&nbsp; &nbsp;
                <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#newModal"
                    style="Font-Size: 20px;" onclick="Xin_De_02()">
                    <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增連續派工紀錄</button>
            </strong></h2>
            <table id="Table1" class="display table table-striped" style="width: 99%">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 10%;">第幾天</th>
                        <th style="text-align: center; width: 15%">離開時間</th>
                        <th style="text-align: center; width: 15%">今日工程師</th>
                        <th style="text-align: center; width: 20%">今日備註</th>
                        <th style="text-align: center; width: 15%">下次到點時間</th>
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
            <button id="Button3" type="button" onclick="URL2();" class="btn btn-default btn-lg ">&nbsp;&nbsp;返回<span class="glyphicon glyphicon-share-alt"></span></button>

        </div>
        <!--===================================================-->
           <!-- ====== 子資料新增修改表 ====== -->
    <div class="modal fade" id="newModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1000px;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>第 <label id="Label1"></label> 天</strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== 表格 -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>

                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>內容</strong><label id="PNumber"></label></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>                            
                            <tr>                                
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>今日到點時間</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker02" name="datetimepicker02" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>處裡工程師</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Handle_Agent" name="Handle_Agent" class="form-control" placeholder=""
                                            maxlength="20" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>今日離開時間</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>當日備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５００個字">
                                        <textarea id="C_PS" name="C_PS" class="form-control" cols="45" rows="3" placeholder="" 
                                            maxlength="500" onkeyup="" style="resize: none;"></textarea>
                                        <!--<input type="text" id="Text37_2" name="" class="form-control" placeholder="收款備註"
                                            maxlength="10" style="Font-Size: 18px; " />-->
                                    </div>
                                </th>                                
                            </tr>                            
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;"></th>
                                <th style="text-align: center; width: 35%; height: 65px;" colspan="2">
                                    <button id="Button_new" type="button" class="btn btn-success btn-lg" onclick="Safe(0)"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <button id="Button_update" type="button" class="btn btn-primary btn-lg" onclick="Safe(1)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
                                </th>
                                <th>
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal">
                                        <span class="glyphicon glyphicon-remove"></span>
                                        &nbsp;取消</button><!--New(0) New(1) 換 Safe -->
                                </th>
                            </tr>
                        </tbody>
                    </table>
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
