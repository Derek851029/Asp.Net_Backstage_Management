<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0150010001.aspx.cs" Inherits="_0150010001" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
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
    <!--===================================================-->
    <div style="width: 1024px; margin: 10px 20px">
        <h2><strong>班次管理（<%= str_title %>）</strong></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>班次管理項目</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <!-------------第一行------------->
                <tr>
                    <td style="text-align: center; width: 15%;">
                        <strong>班次名稱</strong>
                    </td>
                    <td style="width: 35%">
                        <asp:TextBox ID="txt_class" class="form-control" placeholder="班次名稱" MaxLength="10" onkeyup="cs(this);"
                            Style="Font-Size: 18px; width: 50%; background-color: #ffffbb" runat="server"></asp:TextBox>
                    </td>
                    <th style="text-align: center; width: 15%">
                        <strong>班次時間</strong>
                    </th>
                    <th style="width: 35%">
                        <asp:DropDownList ID="drop_AM_PM_1" runat="server" class="form-control">
                            <asp:ListItem Value="上午">上午</asp:ListItem>
                            <asp:ListItem Value="下午">下午</asp:ListItem>
                        </asp:DropDownList>
                    </th>
                </tr>
                <!-------------第一行------------->

                <!-------------第二行------------->
                <tr>
                    <td style="text-align: center">
                        <strong>班次日期</strong>
                    </td>
                    <td colspan="3">
                        <label class="checkbox-inline">
                            <input type="checkbox" id="chk_Mon" runat="server" checked="checked" />星期一
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox" id="chk_Tue" runat="server" checked="checked" />星期二
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox" id="chk_Wed" runat="server" checked="checked" />星期三
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox" id="chk_Thu" runat="server" checked="checked" />星期四
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox" id="chk_Fri" runat="server" checked="checked" />星期五
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox" id="chk_Sat" runat="server" checked="checked" />星期六
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox" id="chk_Sun" runat="server" />星期日
                        </label>
                    </td>
                </tr>
                <!-------------第二行------------->

                <!-------------第二行------------->
                <tr>
                    <td style="text-align: center">
                        <strong>到班時間</strong>
                    </td>
                    <td>
                        <div style="float: left;">
                            &nbsp;&nbsp;
                                        <asp:DropDownList ID="drop_AM_PM" runat="server" class="form-control" Style="float: left">
                                            <asp:ListItem Value="上午">上午</asp:ListItem>
                                            <asp:ListItem Value="下午">下午</asp:ListItem>
                                        </asp:DropDownList>
                        </div>
                        <div style="float: left;">
                            &nbsp; 時 &nbsp; 
                                        <asp:DropDownList ID="drop_Hour" runat="server" class="form-control" Style="float: left">
                                            <asp:ListItem Value="01">01</asp:ListItem>
                                            <asp:ListItem Value="02">02</asp:ListItem>
                                            <asp:ListItem Value="03">03</asp:ListItem>
                                            <asp:ListItem Value="04">04</asp:ListItem>
                                            <asp:ListItem Value="05">05</asp:ListItem>
                                            <asp:ListItem Value="06">06</asp:ListItem>
                                            <asp:ListItem Value="07">07</asp:ListItem>
                                            <asp:ListItem Value="08">08</asp:ListItem>
                                            <asp:ListItem Value="09">09</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="11">11</asp:ListItem>
                                            <asp:ListItem Value="12">12</asp:ListItem>
                                        </asp:DropDownList>
                        </div>
                        <div style="float: left;">
                            &nbsp; 分 &nbsp; 
                                        <asp:DropDownList ID="drop_Minute" runat="server" class="form-control" Style="float: left">
                                            <asp:ListItem Value="00">00</asp:ListItem>
                                            <asp:ListItem Value="05">05</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="15">15</asp:ListItem>
                                            <asp:ListItem Value="20">20</asp:ListItem>
                                            <asp:ListItem Value="25">25</asp:ListItem>
                                            <asp:ListItem Value="30">30</asp:ListItem>
                                            <asp:ListItem Value="35">35</asp:ListItem>
                                            <asp:ListItem Value="40">40</asp:ListItem>
                                            <asp:ListItem Value="45">45</asp:ListItem>
                                            <asp:ListItem Value="50">50</asp:ListItem>
                                            <asp:ListItem Value="55">55</asp:ListItem>
                                        </asp:DropDownList>
                        </div>
                    </td>
                    <td style="text-align: center">
                        <strong>通知時間</strong>
                    </td>
                    <td>
                        <div style="float: left;">
                            &nbsp; 時 &nbsp; 
                                        <asp:DropDownList ID="drop_Hour_2" runat="server" class="form-control" Style="float: left">
                                            <asp:ListItem Value="01">01</asp:ListItem>
                                            <asp:ListItem Value="02">02</asp:ListItem>
                                            <asp:ListItem Value="03">03</asp:ListItem>
                                            <asp:ListItem Value="04">04</asp:ListItem>
                                            <asp:ListItem Value="05">05</asp:ListItem>
                                            <asp:ListItem Value="06">06</asp:ListItem>
                                            <asp:ListItem Value="07">07</asp:ListItem>
                                            <asp:ListItem Value="08">08</asp:ListItem>
                                            <asp:ListItem Value="09">09</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="11">11</asp:ListItem>
                                            <asp:ListItem Value="12">12</asp:ListItem>
                                        </asp:DropDownList>
                        </div>
                        <div style="float: left;">
                            &nbsp; 分 &nbsp; 
                                        <asp:DropDownList ID="drop_Minute_2" runat="server" class="form-control" Style="float: left">
                                            <asp:ListItem Value="00">00</asp:ListItem>
                                            <asp:ListItem Value="05">05</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="15">15</asp:ListItem>
                                            <asp:ListItem Value="20">20</asp:ListItem>
                                            <asp:ListItem Value="25">25</asp:ListItem>
                                            <asp:ListItem Value="30">30</asp:ListItem>
                                            <asp:ListItem Value="35">35</asp:ListItem>
                                            <asp:ListItem Value="40">40</asp:ListItem>
                                            <asp:ListItem Value="45">45</asp:ListItem>
                                            <asp:ListItem Value="50">50</asp:ListItem>
                                            <asp:ListItem Value="55">55</asp:ListItem>
                                        </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <!-------------第二行------------->

                <!-------------第三行------------->
                <tr>
                    <td style="text-align: center">
                        <strong>駕駛</strong>
                    </td>
                    <td colspan="3">
                        <div style="float: left;">
                            <asp:DropDownList ID="drop_company" runat="server" class="form-control" Style="float: right" DataTextField="Agent_Company" DataValueField="Agent_Company" AutoPostBack="true" OnSelectedIndexChanged="drop_company_SelectedIndexChanged">
                                <asp:ListItem Value="">請選擇所屬公司...</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div style="float: left;">
                            &nbsp; 所屬部門：
                                        <asp:DropDownList ID="drop_Team" runat="server" class="form-control" Style="float: right" OnSelectedIndexChanged="drop_Team_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="">請選擇所屬部門...</asp:ListItem>
                                        </asp:DropDownList>
                        </div>
                        <div style="float: left;">
                            &nbsp; 駕駛：
                                        <asp:DropDownList ID="drop_Name" runat="server" class="form-control" Style="float: right" OnSelectedIndexChanged="drop_Name_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="">請選擇駕駛...</asp:ListItem>
                                        </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <!-------------第三行------------->

                <!-------------第二行------------->
                <tr>
                    <td style="text-align: center">
                        <strong>駕駛電話</strong>
                    </td>
                    <td>
                        <asp:TextBox ID="MASTER_TEL" class="form-control" placeholder="駕駛電話" MaxLength="10" onkeyup="int(this);"
                            Style="float: left; Font-Size: 18px; width: 50%; background-color: #ffffbb" runat="server"></asp:TextBox>
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <!-------------第二行------------->

                <!-------------第二行------------->
                <tr>
                    <td style="text-align: center">
                        <strong>負責主管</strong>
                    </td>
                    <td>
                        <asp:DropDownList ID="drop_managername" runat="server" class="form-control">
                            <asp:ListItem Value="">請選擇負責主管…</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="text-align: center">
                        <strong>部門主管</strong>
                    </td>
                    <td>
                        <asp:DropDownList ID="drop_agent_managername" runat="server" class="form-control">
                            <asp:ListItem Value="">請選擇部門主管…</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <!-------------第二行------------->

                <!-------------第二行------------->
                <tr>
                    <td colspan="4" style="text-align: center">
                        <input id="hid_seqno" runat="server" type="hidden" />
                        <asp:Button ID="Btn_New" runat="server" Text="新增" Width="100px" TabIndex="-1" Enabled="true" type="button" class="btn btn-success" OnClick="Btn_New_Click" />
                        <asp:Button ID="Btn_Save" runat="server" Text="修改" Width="100px" TabIndex="-1" Enabled="true" type="button" class="btn btn-primary" OnClick="Btn_Save_Click" />
                        <asp:Button ID="Btn_Back" runat="server" Text="返回" Width="100px" TabIndex="-1" Enabled="true" type="button" class="btn btn-default" OnClick="Btn_Back_Click" />
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</asp:Content>
