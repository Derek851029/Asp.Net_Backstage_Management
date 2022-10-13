<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0020010009.aspx.cs" Inherits="_0020010008" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="../js/jquery.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        var str_Name = '<%= Session["UserIDNAME"] %>';
        var str_ID = '<%= Session["UserID"] %>';
        var str_CNo = '<%= seqno %>';
        var str_Array = [];
        $(function () {
            CNo_List();
        });

        function CNo_List() {
            $.ajax({
                url: '0020010009.aspx/CNo_List',
                type: 'POST',
                data: JSON.stringify({ CNo: str_CNo }),
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
                            { data: "CNo" },
                            { data: "StartTime" },
                            { data: "Type" },
                            { data: "ServiceName" },
                            { data: "Cust_Name" },
                            { data: "Labor_CName" },
                            { data: "Question" },
                            { data: "Agent_Name" },
                            {
                                data: "SYSID", render: function (data, type, row, meta) {
                                    return "<div class='checkbox'><label>" +
                                        "<input type='checkbox' style='width: 30px; height: 30px;' id='chack' />" +
                                        "</label></div>"
                                }
                            }]
                    });
                    //==========================================================

                    $('#data tbody').on('click', '#chack', function () {
                        var table = $('#data').DataTable();
                        var cno = table.row($(this).parents('tr')).data().SYSID;
                        var a = this.checked;
                        if (a == true) {
                            str_Array.push(cno);
                            console.log(cno, '勾選了', '共 ' + str_Array.length + ' 筆', a);
                        }
                        else {
                            str_Array.splice($.inArray(cno, str_Array), 1);
                            console.log(cno, '取消了', '共 ' + str_Array.length + ' 筆', a);
                        }
                        console.log(str_Array);
                    });

                    //==========================================================
                }
            });

        }

        function Btn_A_Click() {
            document.getElementById("Btn_A").disabled = true;
            $.ajax({
                url: '0020010009.aspx/Btn_A_Click',
                type: 'POST',
                data: JSON.stringify({ Agent_Name: str_Name, Agent_ID: str_ID, CNo: str_CNo, Array: str_Array }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    window.location.href = "/0020010000/0020010005.aspx";
                }
            });
            document.getElementById("Btn_A").disabled = false;
        }
    </script>
    <style type="text/css">
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

        #data td:nth-child(9), #data td:nth-child(8), #data td:nth-child(7),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1),
        #data th:nth-child(5) {
            text-align: center;
        }
    </style>
    <div style="width: 95%; margin: 10px 20px;">
        <!--===================================================-->
        <h2><strong>個人派工及結案管理（瀏覽）</strong>
            <button id='Btn_Report' type='button' class='btn btn-info btn-lg' onserverclick="Btn_Report_Click" runat="server"><span class='glyphicon glyphicon-file'></span>&nbsp;服務紀錄表預覽</button>
        </h2>
        <table class="table table-bordered table-striped">
            <thead>
                <%--  ========== 服務人員資料 ===========--%>
                <tr style="height: 55px;">
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 22px"><strong>服務需求內容</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <!--========== 服務項目 ===========-->
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%;">
                        <strong>需求單狀態</strong>
                    </th>
                    <th style="width: 35%">
                        <strong>尚未結案</strong>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>結案日期</strong>
                    </th>
                    <th style="width: 35%"></th>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr id="tr_sysid" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>需求單編號</strong>
                    </td>
                    <td>
                        <asp:Label ID="str_sysid" runat="server"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>派工單編號</strong>
                    </td>
                    <td>
                        <asp:Label ID="str_cno" runat="server"></asp:Label>
                    </td>
                </tr>
                <%--  ========= 填單人資訊 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>填單人</strong>
                    </td>
                    <td>
                        <asp:Label ID="str_name" runat="server"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>填單人部門</strong>
                    </td>
                    <td>
                        <asp:Label ID="str_Create_Team" runat="server"></asp:Label>
                    </td>
                </tr>
                <%--  ========== 服務項目 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>服務分類</strong>
                    </td>
                    <td>
                        <asp:Label ID="DropService" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>服務內容</strong>
                    </td>
                    <td>
                        <asp:Label ID="DropServiceName" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
                <%--  ========== 需求日期 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>預定起始時間</strong>
                    </td>
                    <td>
                        <asp:Label ID="Time_01" runat="server" Text=""></asp:Label>
                    </td>

                    <td style="text-align: center">
                        <strong>預定終止時間</strong>
                    </td>
                    <td>
                        <asp:Label ID="Time_02" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
                <%--  ========== 需求日期 ===========--%>

                <%--  =========== 行程= ===========--%>
                <tr id="PathTable" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>行程起點</strong>
                    </td>
                    <td>
                        <asp:Label ID="LocationStart" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>行程終點</strong>
                    </td>
                    <td>
                        <asp:Label ID="LocationEnd" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
                <%--  =========== 行程 ============--%>

                <%--  ========== 起始地點 ===========--%>
                <tr id="PathStartTable" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>起始地點</strong>
                    </td>
                    <td>
                        <asp:Label ID="Location" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>搭車人數</strong>
                    </td>
                    <td>
                        <asp:Label ID="txt_CarSeat" runat="server" Text=""></asp:Label>
                    </td>
                </tr>

                <%--  ========== 起始地點 ===========--%>

                <%--  =========== 聯絡人 ===========--%>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡人</strong>
                    </td>
                    <td>
                        <asp:Label ID="ContactName" runat="server" Text="聯絡人"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>聯絡電話</strong>
                    </td>
                    <td>
                        <asp:Label ID="ContactPhone" runat="server" Text="連絡電話"></asp:Label>
                    </td>
                </tr>

                <%--  =========== 聯絡人 ===========--%>

                <%--  ========== 醫療院所 ===========--%>

                <tr id="Hospital_Table_1" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>醫療院所</strong>
                    </td>
                    <td>
                        <div style="float: left;">
                            <asp:Label ID="DropHospitalName" runat="server" Text="醫療院所"></asp:Label>
                        </div>
                    </td>
                    <td style="text-align: center">
                        <strong>就醫類型</strong>
                    </td>
                    <td>
                        <asp:Label ID="HospitalClass" runat="server" Text="就醫類型"></asp:Label>
                    </td>
                </tr>

                <!--========== 醫療院所 ===========-->

                <tr style="height: 80px;">
                    <td style="text-align: center">
                        <strong>狀況說明</strong>
                    </td>
                    <td>
                        <asp:Label ID="Question" runat="server" Text="狀況說明"></asp:Label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
            </tbody>
        </table>

        <!--==============================-->

        <table class="table table-bordered table-striped">
            <thead>
                <tr style="height: 55px;">
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 22px"><strong>雇主及外勞資料</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <td style="text-align: center; width: 15%;">
                        <strong>事業部門</strong>
                    </td>
                    <td style="width: 35%">
                        <asp:Label ID="Labor_Team" runat="server" Text="事業部門"></asp:Label>
                    </td>
                    <td style="text-align: center; width: 15%;">
                        <strong>客戶（雇主）</strong>
                    </td>
                    <td style="width: 35%">
                        <asp:Label ID="Cust_Name" runat="server" Text="客戶（雇主）"></asp:Label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>勞工姓名</strong>
                    </td>
                    <td>
                        <asp:Label ID="Select_Labor" runat="server" Text="勞工姓名"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>勞工國籍</strong>
                    </td>
                    <td>
                        <asp:Label ID="Labor_Country" runat="server" Text="勞工國籍"></asp:Label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>勞工編號</strong>
                    </td>
                    <td>
                        <asp:Label ID="label_labor_id" runat="server"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>護照號碼</strong>
                    </td>
                    <td>
                        <asp:Label ID="label_Labor_PID" runat="server"></asp:Label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>居留證號</strong>
                    </td>
                    <td>
                        <asp:Label ID="label_Labor_RID" runat="server"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>職工編號</strong><br />
                        <strong>（長工號）</strong>
                    </td>
                    <td>
                        <asp:Label ID="label_Labor_EID" runat="server"></asp:Label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>連絡電話</strong>
                    </td>
                    <td>
                        <asp:Label ID="Labor_Phone" runat="server" Text="連絡電話"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>翻譯國籍</strong>
                    </td>
                    <td>
                        <asp:Label ID="Labor_Language" runat="server" Text="翻譯國籍"></asp:Label>
                    </td>
                </tr>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡地址</strong>
                    </td>
                    <td>
                        <asp:Label ID="Labor_Address" runat="server" Text="聯絡地址"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>接送地址</strong>
                    </td>
                    <td>
                        <asp:Label ID="Labor_Address2" runat="server" Text="接送地址"></asp:Label>
                    </td>
                </tr>
            </tbody>
        </table>
        <%--  =========== 勞工資料 ===========--%>
        <table class="table table-bordered table-striped">
            <thead>
                <tr style="height: 55px;">
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 22px"><strong>派工單內容</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <%--  ========== 第四行 ===========--%>

                <%--  ========== 需求日期 ===========--%>

                <tr style="height: 55px;">
                    <td style="text-align: center; width: 15%;">
                        <strong>排定日期</strong>
                    </td>
                    <td style="width: 35%;">
                        <asp:Label ID="Time_03" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center; width: 15%;">
                        <strong>排定終止時間</strong>
                    </td>
                    <td style="width: 35%;">
                        <asp:Label ID="Time_04" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
                <%--  ========== 需求日期 ===========--%>

                <%--  ========== 服務人員 ===========--%>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>緊急程度</strong>
                    </td>
                    <td>
                        <asp:Label ID="Danger" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>預定完成時間</strong>
                    </td>
                    <td>
                        <asp:Label ID="OverTime" runat="server"></asp:Label>
                    </td>
                </tr>
                <%--  ========== 被派人員 ===========--%>

                <%--  ========== 被派人員 ===========--%>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>被派人員所屬公司</strong>
                    </td>
                    <td>
                        <asp:Label ID="drop_company" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>被派人員所屬部門</strong>
                    </td>
                    <td>
                        <asp:Label ID="drop_Team" runat="server"></asp:Label>
                    </td>
                </tr>

                <%--  ========== 被派人員 ===========--%>

                <%--  ========== 被派人員 ===========--%>

                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>被派人員</strong>
                    </td>
                    <td>
                        <asp:Label ID="drop_Name" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center"></td>
                    <td></td>
                </tr>

                <%--  ========== 被派人員 ===========--%>

                <%--  ========== 服務車輛 ===========--%>
                <tr id="Tr3" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>車輛保管人部門</strong>
                    </td>
                    <td>
                        <asp:Label ID="CarAgent_Team" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>車輛保管人</strong>
                    </td>
                    <td>
                        <asp:Label ID="CarAgent_Name" runat="server"></asp:Label>
                    </td>
                </tr>

                <%--  ========== 服務車輛 ===========--%>

                <%--  ========== 服務車輛 ===========--%>

                <tr id="Tr4" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>車輛分類</strong>
                    </td>
                    <td>
                        <asp:Label ID="CarNameList" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>車牌號碼</strong>
                    </td>
                    <td>
                        <asp:Label ID="CarNumberList" runat="server" Text=""></asp:Label></td>
                </tr>

                <%--  ========== 服務車輛 ===========--%>

                <tr style="height: 80px;">
                    <td style="text-align: center">
                        <strong>派工說明</strong>
                    </td>
                    <td>
                        <asp:Label ID="Answer2" runat="server" Text="派工說明"></asp:Label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <tr id="Answer3_Table" runat="server" style="height: 80px;">
                    <td style="text-align: center; width: 15%;">
                        <strong>暫結案說明<br />
                            （後續處理說明）</strong>
                    </td>
                    <td style="width: 35%;">
                        <textarea id="Answer3" name="Answer3" class="form-control" cols="60" rows="3" placeholder="暫結案說明（後續處理說明）" style="resize: none"><%= Answer3 %></textarea>
                    </td>
                    <td style="width: 15%;"></td>
                    <td style="width: 35%;"></td>
                </tr>
                <tr id="Torna_Table" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>是否回診</strong>
                    </td>
                    <td>
                        <div style="float: left;">
                            <asp:DropDownList ID="Torna" runat="server" class="form-control" Style="float: right">
                                <asp:ListItem Value="0">不回診</asp:ListItem>
                                <asp:ListItem Value="1">回診</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <tr id="Tr1" runat="server" style="height: 80px;">
                    <td style="text-align: center">
                        <strong>暫結案說明<br />
                            （後續處理說明）</strong>
                    </td>
                    <td>
                        <asp:Label ID="Label1" runat="server"></asp:Label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <tr id="Tr2" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>是否回診</strong>
                    </td>
                    <td>
                        <asp:Label ID="Label2" runat="server"></asp:Label>
                    </td>
                    <td></td>
                    <td></td>
                </tr>

            </tbody>
        </table>
        <!--===================================================-->
        <h2><strong>派工單多選處理（瀏覽）&nbsp; &nbsp;</strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center; width: 10%;">派工單編號</th>
                    <th style="text-align: center; width: 10%;">排定日期</th>
                    <th style="text-align: center; width: 10%;">案件狀態</th>
                    <th style="text-align: center; width: 10%;">服務內容</th>
                    <th style="text-align: center; width: 10%;">客戶</th>
                    <th style="text-align: center; width: 10%;">勞工姓名</th>
                    <th style="text-align: center; width: 20%;">狀況說明</th>
                    <th style="text-align: center; width: 10%;">被派人員</th>
                    <th style="text-align: center; width: 10%;">功能</th>
                </tr>
            </thead>
        </table>
        <br />
        <table class="table table-bordered table-striped">
            <tbody>
                <tr>
                    <td style="text-align: center;" colspan="4">
                        <input id="hid_seqno" runat="server" type="hidden" />
                        <input id="hid_type" runat="server" type="hidden" />
                        <button id="Btn_A" type="button" class="btn btn-primary btn-lg " onclick="Btn_A_Click()">
                            <h1>
                                <span class="glyphicon glyphicon-ok"></span>
                                <br />
                                &nbsp;到點&nbsp;
                            </h1>
                        </button>
                        <button id="Btn_B" type="button" onserverclick="Btn_B_Click" class="btn btn-success btn-lg " runat="server">
                            <h1>
                                <span class="glyphicon glyphicon-ok"></span>
                                <br />
                                &nbsp;完成&nbsp;
                            </h1>
                        </button>
                        <button id="Btn_C" type="button" onserverclick="Btn_C_Click" class="btn btn-warning btn-lg " runat="server">
                            <h1>
                                <span class="glyphicon glyphicon-ok"></span>
                                <br />
                                &nbsp;暫結案&nbsp;
                            </h1>
                        </button>
                        &nbsp; &nbsp;                        
                        <button id="Btn_Back" type="button" onserverclick="Btn_Back_Click" class="btn btn-default btn-lg " runat="server">
                            <h1>
                                <span class="glyphicon glyphicon-share-alt"></span>
                                <br />
                                &nbsp;返回&nbsp;
                            </h1>
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>
        <%--  ========== 第四行 ===========--%>
    </div>
</asp:Content>
