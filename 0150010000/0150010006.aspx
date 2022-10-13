<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0150010006.aspx.cs" Inherits="_0150010006" %>

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
    <div style="width: 600px; margin: 10px 20px">
        <h2><strong>&nbsp; &nbsp;配合廠商管理（修改）</strong></h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>配合廠商</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <!-------------第一行------------->
                <tr>
                    <td style="text-align: center; width: 35%;">
                        <strong>配合廠商</strong>
                    </td>
                    <td style="text-align: center; width: 65%">
                        <input type="hidden" id="hid_SysID" runat="server" />
                        <asp:TextBox ID="txt_Partner_Company" class="form-control" placeholder="請輸入配合廠商名稱" MaxLength="10" onkeyup="cs(this);"
                            Style="Font-Size: 18px; width: 50%; background-color: #ffffbb" runat="server"></asp:TextBox>
                    </td>

                </tr>
                <!-------------第一行------------->

                <!-------------第二行------------->
                <tr>
                    <td style="text-align: center">
                        <strong>駕駛</strong>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_Partner_Driver" class="form-control" placeholder="請輸入駕駛姓名" MaxLength="10" onkeyup="cs(this);"
                            Style="Font-Size: 18px; width: 50%; background-color: #ffffbb" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <!-------------第二行------------->

                <!-------------第二行------------->
                <tr>
                    <td style="text-align: center">
                        <strong>電話</strong>
                    </td>
                    <td>
                        <asp:TextBox ID="txt_Partner_Phone" class="form-control" placeholder="請輸入電話或手機" MaxLength="10" onkeyup="int(this);"
                            Style="Font-Size: 18px; width: 50%; background-color: #ffffbb" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <!-------------第二行------------->
                <tr>
                    <td colspan="4" style="text-align: center">
                        <asp:Button ID="Btn_Save" runat="server" Text="存檔" Width="100px" TabIndex="-1" Enabled="true" type="button" class="btn btn-success" OnClick="Btn_Save_Click" />
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</asp:Content>
