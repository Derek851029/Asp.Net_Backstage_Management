<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0020010007.aspx.cs" Inherits="_0020010007" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <script src="../js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
        });
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
    </style>
    <div>
        <!--===================================================-->
        <h2><strong>&nbsp; &nbsp; 需求單審核（<%= title %>）</strong></h2>
        <table class="table table-bordered table-striped" style="width: 95%; margin: 10px 20px">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>服務需求內容</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%;">
                        <strong>需求單狀態</strong>
                    </th>
                    <th style="width: 35%">
                        <strong><%= str_type %></strong>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>結案日期</strong>
                    </th>
                    <th style="width: 35%"></th>
                </tr>
                <%--  =========== 勞工資料 ===========--%>

                <%--  =========== 勞工資料 ===========--%>
                <tr id="tr_sysid" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>需求單編號</strong>
                    </td>
                    <td>
                        <asp:Label ID="str_sysid" runat="server" Text="需求單編號"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>填單人</strong>
                    </td>
                    <td>
                        <asp:Label ID="str_name" runat="server" Text="填單人"></asp:Label>
                    </td>
                </tr>
                <%--  =========== 勞工資料 ===========--%>

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
                <%--  ========== 服務項目 ===========--%>

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
                        <asp:Label ID="ContactName" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>手機簡碼</strong>
                    </td>
                    <td>
                        <asp:Label ID="ContactPhone3" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>手機號碼</strong>
                    </td>
                    <td>
                        <asp:Label ID="ContactPhone" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>手機號碼</strong>
                    </td>
                    <td>
                        <asp:Label ID="ContactPhone2" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
                <tr style="height: 55px;">
                    <td style="text-align: center">
                        <strong>聯絡電話</strong>
                    </td>
                    <td>
                        <asp:Label ID="Contact_TEL" runat="server" Text=""></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>公司電話</strong>
                    </td>
                    <td>
                        <asp:Label ID="Contact_Co_TEL" runat="server" Text=""></asp:Label>
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

                <%--  ========== 醫療院所 ===========--%>

                <tr style="height: 55px;">
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
        <%--  =========== 勞工資料 ===========--%>

        <table class="table table-bordered table-striped" style="width: 95%; margin: 10px 20px">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>雇主及外勞資料</strong></span>
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
                        <asp:Label ID="Select_Labor" runat="server"></asp:Label>
                    </td>
                    <td style="text-align: center">
                        <strong>勞工國籍</strong>
                    </td>
                    <td>
                        <asp:Label ID="Labor_Country" runat="server"></asp:Label>
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
                <%--  =========== 勞工資料 ===========--%>

                <tr id="Back_Table_1" runat="server">
                    <td style="text-align: center; color: #D50000;">
                        <strong>退單原因</strong>
                    </td>
                    <td>
                        <div style="float: left" data-toggle="tooltip" title="不能超過１００個字元，並且含有不正確的符號">
                            <textarea id="Back" name="Back" class="form-control" cols="45" rows="3" placeholder="退單原因" style="resize: none; background-color: #ffffbb" maxlength="100" onkeyup="cs(this);"><%= Back %></textarea>
                        </div>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <tr id="Back_Table_2" runat="server" style="height: 55px;">
                    <td style="text-align: center">
                        <strong>退單原因</strong>
                    </td>
                    <td colspan="3">
                        <asp:Label ID="Chargeback" runat="server" Text="退單原因"></asp:Label>
                    </td>
                </tr>
                <tr style="height: 55px;">
                    <td colspan="4" style="text-align: center">
                        <input id="hid_seqno" runat="server" type="hidden" />
                        <button id="Btn_Update" type="button" onserverclick="Btn_Update_Click" class="btn btn-primary btn-lg " runat="server"><span class="glyphicon glyphicon-ok"></span>&nbsp;審核</button>&nbsp; &nbsp;
                        <button id="Btn_Back" type="button" onserverclick="Btn_Back_Click" class="btn btn-default btn-lg " runat="server">返回  <span class="glyphicon glyphicon-share-alt"></span></button>
                        &nbsp; &nbsp; 
                        <button id="Btn_Del" type="button" onserverclick="Btn_Del_Click" class="btn btn-danger btn-lg " runat="server"><span class="glyphicon glyphicon-remove"></span>&nbsp;退單</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <!--===================================================-->
    </div>
</asp:Content>
