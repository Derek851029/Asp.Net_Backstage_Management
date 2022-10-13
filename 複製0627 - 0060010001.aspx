<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="複製 - 0060010001.aspx.cs" Inherits="_0060010001" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            bindTable();
            ShowTime();
        });

        function bindTable() {
            $.ajax({
                url: '0060010001.aspx/GetPartnerList',
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
                                { data: "PID" },
                                { data: "APP_OTEL" },
                                { data: "BUSINESSNAME" },
                                { data: "ID" },
                                { data: "SetupDate" },
                                { data: "UpdateDate" },
                                
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

                    $('#data tbody').unbind('click').
                       // on('click', '#button', function () {
                            //var table = $('#data').DataTable();
                            //var PID = table.row($(this).parents('tr')).data().PID;
                            //Button(PID);
                            //var ROLE_ID = table.row($(this).parents('tr')).data().ROLE_ID;
                            //var ROLE_NAME = table.row($(this).parents('tr')).data().ROLE_NAME;
                            //document.getElementById("txt_title").innerHTML = '【' + ROLE_NAME + '】選單設定';
                            //List_PROGLIST(ROLE_ID);
                        //}).
                        on('click', '#edit', function () {
                            var table = $('#data').DataTable();
                            var PID = table.row($(this).parents('tr')).data().PID;
                            //alert(PID);
                            Load_Modal(PID);
                        });
                }
            });
        }

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
            //document.getElementById('EstimatedFinishTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;

        }

        function List_PROGLIST(ROLE_ID) {
            $.ajax({
                url: '0060010001.aspx/List_PROGLIST',
                type: 'POST',
                data: JSON.stringify({ ROLE_ID: ROLE_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    if (obj.data[0].TREE_ID == "NULL") {
                        alert("查無此權限代碼，，請詢問管理人員，謝謝。");
                        return;
                    }
                    var table = $('#data2').DataTable({
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
                        "aLengthMenu": [[25, 50, 100], [25, 50, 100]],
                        "iDisplayLength": 25,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                                { data: "TREE_ID" },
                                { data: "M_TREE_NAME" },
                                { data: "TREE_NAME" },
                                { data: "Agent_Name" },
                                { data: "UpDateDate" },
                                {
                                    data: "NowStatus", render: function (data, type, row, meta) {
                                        var checked = 'checked/>'
                                        if (data == '0') {
                                            checked = '/>'
                                        }
                                        return "<div class='checkbox'><label>" +
                                            "<input type='checkbox' style='width: 30px; height: 30px;' id=check " +
                                            checked + "</label></div>";
                                    }
                                }]
                    });
                    //================================

                    $('#data2 tbody').unbind('click').
                        on('click', '#check', function () {
                            var table = $('#data2').DataTable();
                            var Flag = table.row($(this).parents('tr')).data().NowStatus;
                            var TREE_ID = table.row($(this).parents('tr')).data().TREE_ID;
                            //Check(Flag, TREE_ID, ROLE_ID.toString());
                        });
                }
            });
        }

        function Check(Flag, TREE_ID, ROLE_ID) {
            $.ajax({
                //url: '0060010001.aspx/Check_Menu',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    TREE_ID: TREE_ID,
                    ROLE_ID: ROLE_ID,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                }
            });
            List_PROGLIST(ROLE_ID);
        }
        //==============================
        function Xin_De() {     //按新增客戶資料後
            Load_Modal("0");        
            //alert('新增');
        }    

        function Load_Modal(PID) {                                          // 讀資料
            //alert(PID);
           if (PID == 0) {
                //alert('檢查中1');
                document.getElementById("btn_new").style.display = "";
                document.getElementById("btn_update").style.display = "none";
                document.getElementById("title_modal").innerHTML = '客戶資料（新增）';                
            } else {
                //alert('檢查中2');
                //document.getElementById("txt_ROLE_ID").disabled = true;
                document.getElementById("btn_update").style.display = "";                               //顯示修改鈕
                document.getElementById("btn_new").style.display = "none";                          //隱藏新增鈕
                document.getElementById("title_modal").innerHTML = '客戶資料（修改）';
                Load_Data(PID);                
            }   //else 結束
        }

        // 預定修改執行部分
        function Load_Data(PID) {
            //alert('Load_Data');
            $.ajax({
                url: '0060010001.aspx/Load_Data',
                type: 'POST',
                data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);

                    document.getElementById("business_name").value = obj.data[0].BUSINESSNAME;
                    document.getElementById("business_id").value = obj.data[0].BUSINESSID;
                    document.getElementById("id").value = obj.data[0].ID;
                    document.getElementById("datetimepicker01").value = obj.data[0].BUS_CREATE_DATE;
                    document.getElementById("Text1").value = obj.data[0].APPNAME;
                    document.getElementById("Text2").value = obj.data[0].APP_SUBTITLE;
                    document.getElementById("Text3").value = obj.data[0].APP_MTEL;
                    document.getElementById("Text4").value = obj.data[0].APP_EMAIL;
                    document.getElementById("Text5").value = obj.data[0].APPNAME_2;
                    document.getElementById("Text6").value = obj.data[0].APP_SUBTITLE_2;
                    document.getElementById("Text7").value = obj.data[0].APP_MTEL_2;
                    document.getElementById("Text8").value = obj.data[0].APP_EMAIL_2;
                    document.getElementById("Text9").value = obj.data[0].REGISTER_ADDR;
                    document.getElementById("Text10").value = obj.data[0].CONTACT_ADDR;
                    document.getElementById("Text11").value = obj.data[0].APP_OTEL;
                    document.getElementById("Text12").value = obj.data[0].APP_FTEL;
                    document.getElementById("Text13").value = obj.data[0].INVOICENAME;
                    document.getElementById("Text14").value = obj.data[0].Inads;
                    document.getElementById("Text15").value = obj.data[0].HardWare;
                    document.getElementById("Text16").value = obj.data[0].SoftwareLoad;
                    document.getElementById("Text17").value = obj.data[0].Mail_Type;
                    document.getElementById("Text18").value = obj.data[0].OE_Number;
                    document.getElementById("Text19").value = obj.data[0].SalseAgent;
                    document.getElementById("Text20").value = obj.data[0].Salse;
                    document.getElementById("Text21").value = obj.data[0].Salse_TEL;
                    document.getElementById("Text22").value = obj.data[0].SID;
                    document.getElementById("Text23").value = obj.data[0].Serial_Number;
                    document.getElementById("Text24").value = obj.data[0].License_Host;
                    document.getElementById("Text25").value = obj.data[0].Licence_Name;
                    document.getElementById("Text26").value = obj.data[0].LAC;
                    document.getElementById("Text27").value = obj.data[0].Our_Reference;
                    document.getElementById("Text28").value = obj.data[0].Your_Reference;
                    document.getElementById("Text29").value = obj.data[0].Auth_File_ID;
                    document.getElementById("Text30").value = obj.data[0].Telecomm_ID;
                    document.getElementById("Text31").value = obj.data[0].FL;
                    document.getElementById("Text32").value = obj.data[0].Group_Name_ID;
                    document.getElementById("Text33").value = obj.data[0].SED;
                    document.getElementById("Text34").value = obj.data[0].SERVICEITEM;
                    document.getElementById("datetimepicker02").value = obj.data[0].Warranty_Date;
                    document.getElementById("Text35").value = obj.data[0].Warr_Time;
                    document.getElementById("datetimepicker03").value = obj.data[0].Protect_Date;
                    document.getElementById("Text36").value = obj.data[0].Prot_Time;
                    document.getElementById("datetimepicker04").value = obj.data[0].Receipt_Date;
                    document.getElementById("Text37").value = obj.data[0].Receipt_PS;
                    document.getElementById("datetimepicker05").value = obj.data[0].Close_Out_Date;
                    document.getElementById("Text38").value = obj.data[0].Close_Out_PS;
                    document.getElementById("Text39").value = obj.data[0].Account_PS;
                    document.getElementById("Text40").value = obj.data[0].Information_PS;
                    document.getElementById("time_06").innerHTML = obj.data[0].SetupDate;
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }
        //================ 新增【使用者權限】===============
        function New(Flag) {
            document.getElementById("btn_update").disabled = true;
            document.getElementById("btn_new").disabled = true;
            var Flag = Flag;           
            var BUSINESSNAME = document.getElementById("business_name").value;
            var BUSINESSID = document.getElementById("business_id").value;

            var ID = document.getElementById("id").value ; 
            var BUS_CREATE_DATE = document.getElementById("datetimepicker01").value ; 
            var APPNAME = document.getElementById("Text1").value ; 
            var APP_SUBTITLE = document.getElementById("Text2").value ; 
            var APP_MTEL = document.getElementById("Text3").value ; 
            var APP_EMAIL = document.getElementById("Text4").value ; 
            var APPNAME_2 = document.getElementById("Text5").value ; 
            var APP_SUBTITLE_2 = document.getElementById("Text6").value ; 
            var APP_MTEL_2 = document.getElementById("Text7").value ; 
            var APP_EMAIL_2 = document.getElementById("Text8").value ; 
            var REGISTER_ADDR = document.getElementById("Text9").value ; 
            var CONTACT_ADDR = document.getElementById("Text10").value ; 
            var APP_OTEL = document.getElementById("Text11").value ; 
            var APP_FTEL = document.getElementById("Text12").value ; 
            var INVOICENAME = document.getElementById("Text13").value ; 
            var Inads = document.getElementById("Text14").value ; 
            var HardWare = document.getElementById("Text15").value ; 
            var SoftwareLoad = document.getElementById("Text16").value ; 
            var Mail_Type = document.getElementById("Text17").value ; 
            var OE_Number = document.getElementById("Text18").value ; 
            var SalseAgent = document.getElementById("Text19").value ; 
            var Salse = document.getElementById("Text20").value ; 
            var Salse_TEL = document.getElementById("Text21").value ; 
            var SID = document.getElementById("Text22").value ; 
            var Serial_Number = document.getElementById("Text23").value ; 
            var License_Host = document.getElementById("Text24").value ; 
            var Licence_Name = document.getElementById("Text25").value ; 
            var LAC = document.getElementById("Text26").value ; 
            var Our_Reference = document.getElementById("Text27").value ; 
            var Your_Reference = document.getElementById("Text28").value ; 
            var Auth_File_ID = document.getElementById("Text29").value ; 
            var Telecomm_ID = document.getElementById("Text30").value ; 
            var FL = document.getElementById("Text31").value ; 
            var Group_Name_ID = document.getElementById("Text32").value ; 
            var SED =  document.getElementById("Text33").value ; 
            var SERVICEITEM = document.getElementById("Text34").value ; 
            var Warranty_Date = document.getElementById("datetimepicker02").value ; 
            var Warr_Time = document.getElementById("Text35").value ; 
            var Protect_Date = document.getElementById("datetimepicker03").value ; 
            var Prot_Time = document.getElementById("Text36").value ; 
            var Receipt_Date = document.getElementById("datetimepicker04").value ; 
            var Receipt_PS = document.getElementById("Text37").value ; 
            var Close_Out_Date = document.getElementById("datetimepicker05").value ; 
            var Close_Out_PS = document.getElementById("Text38").value ; 
            var Account_PS = document.getElementById("Text39").value ; 
            var Information_PS = document.getElementById("Text40").value ; 
            var UpDateDate = document.getElementById("LoginTime").innerHTML;
            alert('安安');
            $.ajax({
                url: '0060010001.aspx/New',
                alert: ("新增完成！"),
                type: 'POST',
                data: JSON.stringify({
                    
                    Flag: Flag,
                    BUSINESSNAME: business_name,          BUSINESSID: business_id,
                    ID: id, BUS_CREATE_DATE: datetimepicker01,
                    APPNAME:Text1,                                        APP_SUBTITLE:Text2,     
                    APP_MTEL:Text3,                                        APP_EMAIL:Text4,     
                    APPNAME_2:Text5,                                    APP_SUBTITLE_2 :Text6,     
                    APP_MTEL_2:Text7,                                   APP_EMAIL_2:Text8,     
                    REGISTER_ADDR:Text9,                            CONTACT_ADDR :Text10,     
                    APP_OTEL:Text11,                                     APP_FTEL :Text12,     
                    INVOICENAME: Text13,                            Inads: Text14,
                    HardWare: Text15,                                    SoftwareLoad: Text16,
                    Mail_Type: Text17,                                   OE_Number: Text18,
                    SalseAgent: Text19,                                 Salse: Text20,
                    Salse_TEL: Text21,                                    SID: Text22,
                    Serial_Number: Text23,                           License_Host: Text24,
                    Licence_Name: Text25,                            LAC: Text26,
                    Our_Reference: Text27,                           Your_Reference: Text28,
                    Auth_File_ID: Text29,                               Telecomm_ID: Text30,
                    FL: Text31,                                                 Group_Name_ID: Text32,
                    SED: Text33,                                              SERVICEITEM: Text34,
                    Warranty_Date: datetimepicker02,        Warr_Time: Text35,
                    Protect_Date: datetimepicker03,           Prot_Time: Text36,
                    Receipt_Date: datetimepicker04,          Receipt_PS: Text37,
                    Close_Out_Date: datetimepicker05,     Close_Out_PS: Text38,
                    Account_PS: Text39,                                Information_PS: Text40,
                    UpDateDate: LoginTime,
                    SetupDate: LoginTime
                    // 共讀取 49 個

                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert("新增完成！")
                        bindTable();
                    }
                    else if (json.status == "update") {
                        alert("修改完成！");
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

        //==================    新增與修改 Upload   參考用
        function Btn_New_Click(Flag) {
            document.getElementById("Btn_New").disabled = true;
            $("#Div_Loading").modal();
            
            var PostCode = $("#hid_PostCode").val();
            var Location = document.getElementById("txt_Location").innerHTML;  //地址
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
                url: '0030010099.aspx/Check_Form',
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
        };
        //==================
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

        #data2 td:nth-child(6), #data2 td:nth-child(5), #data2 td:nth-child(4),
        #data2 td:nth-child(3), #data2 td:nth-child(2), #data2 td:nth-child(1),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <!-- ====== Modal ====== -->
    <!--
    <div class="modal fade" id="myModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1000px;">

            

            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="txt_title"></label>
                    </strong></h2>
                </div>
                <div class="modal-body">
                    
                    <table id="data2" class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center;">選單編號</th>
                                <th style="text-align: center;">選單分類</th>
                                <th style="text-align: center;">選單名稱</th>
                                <th style="text-align: center;">異動者</th>
                                <th style="text-align: center;">異動日期</th>
                                <th style="text-align: center;">維護</th>
                            </tr>
                        </thead>
                    </table>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal">
                        <span class="glyphicon glyphicon-remove"></span>
                        &nbsp;關閉</button>
                </div>
            </div>

            

        </div>
    </div>
        -->
    <!-- ====== Modal ====== -->
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
                                    <span style="font-size: 20px"><strong>客戶資料</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>客戶名稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填">
                                        <input type="text" id="business_name" name="business_name" class="form-control" placeholder="中文名稱"
                                             maxlength="20" style="Font-Size: 18px; background-color: #ffffbb" title="必填，不能超過２５個字元"/>
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>英文名稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，不能超過２５個字元">
                                        <input type="text" id="business_id" name="business_id" class="form-control" placeholder="英文名稱"
                                            maxlength="8" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>統一編號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，應填8位數字">
                                        <input type="text" id="id" name="id" class="form-control" placeholder="統一編號"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>公司成立時間</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker01" name="time_01" style="background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>

                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>聯絡人1</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text1" name="txt_Agent_Name" class="form-control" placeholder="聯絡人1"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>職稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text2" name="txt_Agent_Name" class="form-control" placeholder="職稱"
                                            maxlength="20" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>行動電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text3" name="txt_Agent_Name" class="form-control" placeholder="行動電話"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>E-mail</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text4" name="txt_Agent_Name" class="form-control" placeholder="E-mail"
                                            maxlength="30" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>

                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>聯絡人2</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text5" name="txt_Agent_Name2" class="form-control" placeholder="聯絡人2"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>職稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text6" name="txt_Agent_Name2" class="form-control" placeholder="職稱"
                                            maxlength="20" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>行動電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text7" name="txt_Agent_Name2" class="form-control" placeholder="行動電話"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>E-mail</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text8" name="txt_Agent_Name2" class="form-control" placeholder="E-mail"
                                            maxlength="30" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                           
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>註冊地址</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text9" name="txt_Agent_Name" class="form-control" placeholder="登記地址"
                                            maxlength="30" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>通訊地址</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text10" name="txt_Agent_Name" class="form-control" placeholder="通訊地址"
                                            maxlength="30" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>公司電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填">
                                        <input type="text" id="Text11" name="txt_Agent_Name" class="form-control" placeholder="公司電話"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>傳真電話</strong>
                                </th>
                                <th style="text-align: center; width:35%">
                                    <div data-toggle="tooltip" title="必填">
                                        <input type="text" id="Text12" name="txt_Agent_Name" class="form-control" placeholder="傳真電話"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>   
                            </tr> 
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>註冊公司</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text13" name="R_C_Name_ID" class="form-control" placeholder="註冊公司"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Inads</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text14" name="Inads" class="form-control" placeholder="Inads"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Hardware</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填">
                                        <input type="text" id="Text15" name="Hardware" class="form-control" placeholder="Hardware"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Software Load</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text16" name="Software_Load" class="form-control" placeholder="Software Load"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Mail Type </strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text17" name="Mail_Type " class="form-control" placeholder="Mail Type "
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>OE號碼</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text18" name="OE_Number" class="form-control" placeholder="OE號碼"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>經銷商</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text19" name="txt_Agent_Name" class="form-control" placeholder="經銷商"
                                            maxlength="20" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>經銷商聯絡人</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text20" name="txt_Agent_Name2" class="form-control" placeholder="經銷商聯絡人"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>

                            <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>聯絡電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text21" name="txt_Agent_Phone" class="form-control" placeholder="聯絡電話"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>SID</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text22" name="SID" class="form-control" placeholder="SID"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>序列號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="Text23" name="Serial_Number" placeholder="序列號"
                                            style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>License Host</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="Text24" name="Serial_Number" placeholder="License Host" 
                                            style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>許可證名稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text25" name="Licence_Name" class="form-control" placeholder="許可證名稱"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>LAC</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text26" name="LAC" class="form-control" placeholder="LAC"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>我方參考</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="我方參考">
                                        <input type="text" class="form-control" id="Text27" name="Our_Reference" placeholder="我方參考"
                                            style="Font-Size: 18px; background-color: #ffffbb" />                                        
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>對方參考</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="對方參考">
                                        <input type="text" class="form-control" id="Text28" name="Your_Reference" placeholder="對方參考"
                                            style="Font-Size: 18px; background-color: #ffffbb" />                                        
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>認證檔號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text29" name="Auth_File_ID" class="form-control" placeholder="認證檔號"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>電信廠商</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text30" name="txt_Agent_Name" class="form-control" placeholder="電信廠商"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>


                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>FL</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text31" name="FL" class="form-control" placeholder="FL"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Group Name-ID</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text32" name="Group_Name_D" class="form-control" placeholder="Group Name-ID"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>SED</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text33" name="SED" class="form-control" placeholder="SED"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>合約狀態</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text34" name="R_C_Name_ID" class="form-control" placeholder="合約狀態"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>保固開始日</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker02" name="time_02" style="background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>保固時間(月)</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text35" name="" class="form-control" placeholder="以月來記錄"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                             <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>維護開始日</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker03" name="time_03" style="background-color: #ffffbb" />
                                    </div>
                                </th>                           
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>維護時間(月)</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text36" name="" class="form-control" placeholder="以月來記錄"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>收款日期</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker04" name="time_04" style="background-color: #ffffbb" />
                                    </div>
                                </th>                           
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>收款備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text37" name="" class="form-control" placeholder="收款備註"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>結案日期</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker05" name="time_05" style="background-color: #ffffbb" />
                                    </div>
                                </th>                           
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>備結案註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text38" name="" class="form-control" placeholder="結案備註"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>顧客帳密備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text39" name="" class="form-control" placeholder="顧客帳密備註"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>顧客資訊備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <input type="text" id="Text40" name="" class="form-control" placeholder="顧客資訊備註"
                                            maxlength="10" style="Font-Size: 18px; background-color: #ffffbb" />
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
                                        
                                        <input type="text" class="form-control" id="LoginTime" name="LoginTime" style="background-color: #ffffbb" value=""/>
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 65px;">
                                    <strong>建檔日期</strong>
                                </th>
                                <th>
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <label id="time_06"></label>
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;"></th>
                                <th style="text-align: center; width: 35%; height: 65px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="New(0)" style="width:110px; height:65px"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
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

            <!-- =========== Modal content =========== -->

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
    <!--===================================================-->

    <div class="table-responsive" style="width: 1280px; margin: 10px 20px">
        <h2><strong>客戶資料維護&nbsp; &nbsp;
                <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#newModal" style="Font-Size: 20px;" onclick="Xin_De()">
                    <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增客戶資料</button>
        </strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center;">客戶代號</th>
                    <th style="text-align: center;">客戶電話</th>
                    <th style="text-align: center;">客戶名稱</th>
                    <th style="text-align: center;">統一編號</th>
                    <th style="text-align: center;">建檔日期</th>
                    <!--<th style="text-align: center;">異動者</th>-->
                    <th style="text-align: center;">異動日期</th>
                    <th style="text-align: center;">修改</th>
                </tr>
            </thead>
        </table>

    </div>
</asp:Content>
