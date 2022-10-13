<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0150010008.aspx.cs" Inherits="_0150010008" %>

<asp:Content ID="Content" ContentPlaceHolderID="head" runat="Server">
    <tr>
        <td>
            <link href="../js/jquery-ui.min.css" rel="stylesheet" />
            <script src="../DataTables/jquery-1.12.3.js"></script>
            <script src="../js/jquery-ui.min.js"></script>     
            <style>
                body {
                    font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
                    font-size: 14px;
                }
            </style>
            <!--===================================================-->
            <h2><strong>&nbsp; &nbsp;班次管理（修改）</strong></h2>
            <table class="table table-bordered table-striped" style="width: 1024px">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 150px;">項目</th>
                        <th style="width: 150px"></th>
                        <th style="width: 75px"></th>
                        <th style="width: 200px"></th>
                    </tr>
                </thead>
                <tbody>
                    <!-------------第一行------------->
                    <tr>
                        <td style="text-align: center">
                            <h5><strong>班次名稱</strong></h5>
                        </td>
                        <td>
                            <asp:TextBox ID="txt_class" class="form-control" placeholder="班次名稱" runat="server"></asp:TextBox>
                        </td>
                        <td style="text-align: center">
                            <h5><strong>班次時間</strong></h5>
                        </td>
                        <td>
                            <asp:DropDownList ID="drop_AM_PM_1" runat="server" class="form-control">
                                <asp:ListItem Value="上午">上午</asp:ListItem>
                                <asp:ListItem Value="下午">下午</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <!-------------第一行------------->

                    <!-------------第二行------------->
                    <tr>
                        <td style="text-align: center">
                            <h5><strong>班次日期</strong></h5>
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
                            <h5><strong>到班時間</strong></h5>
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
                        </td><td style="text-align: center">
                            <h5><strong>通知時間</strong></h5>
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
                            <h5><strong>駕駛</strong></h5>
                        </td>
                        <td colspan="3">
                            <div style="float: left;">
                                &nbsp; 
                                <asp:DropDownList ID="drop_company" runat="server" class="form-control" Style="float: right" DataTextField="Agent_Company" DataValueField="Agent_Company" AutoPostBack="true" OnSelectedIndexChanged="drop_company_SelectedIndexChanged">
                                    <asp:ListItem Value="0">請選擇所屬公司...</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div style="float: left;">
                                &nbsp; 所屬部門：
                                        <asp:DropDownList ID="drop_Team" runat="server" class="form-control" Style="float: right" OnSelectedIndexChanged="drop_Team_SelectedIndexChanged" AutoPostBack="true">
                                        </asp:DropDownList>
                            </div>
                            <div style="float: left;">
                                &nbsp; 負責司機：
                                        <asp:DropDownList ID="drop_Name" runat="server" class="form-control" Style="float: right">
                                        </asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                    <!-------------第三行------------->
                    <!-------------第二行------------->
                    <tr>
                        <td style="text-align: center">
                            <h5><strong>負責主管</strong></h5>
                        </td>
                        <td>
                            <asp:DropDownList ID="drop_managername" runat="server" class="form-control">
                            </asp:DropDownList>
                        </td>
                        <td style="text-align: center">
                            <h5><strong>部門主管</strong></h5>
                        </td>
                        <td colspan="3">
                            <asp:DropDownList ID="drop_agent_managername" runat="server" class="form-control">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <!-------------第二行------------->                
                    <tr>
                        <td colspan="4" style="text-align: center">
                            <input id="hid_seqno" runat="server" type="hidden" />
                            <asp:Button ID="Btn_Save" runat="server" Text="存檔" Width="100px" TabIndex="-1" Enabled="true" type="button" class="btn btn-success" OnClick="Btn_Save_Click" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <!--===================================================-->
        </td>

    </tr>
</asp:Content>
