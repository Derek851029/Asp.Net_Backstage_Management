<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Login</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <table style="width: 100%;">
            <tr style="width: auto; height: 80px;">
                <td style="height: 70px; width: 1024px;">
                    <!--<a href="../Default.aspx">
                        <img align="left" src="/images/LOGO.png" style="height: 90px; width: 315px;"/>
                    </a>-->
                    <img align="left" src="../images/APEX_Health.png" class="auto-style1" style="height: 90px; width: 315px;" ;/>
                </td>
                <td style="width: auto; height: 80px;"></td>
            </tr>
        </table>
        <br />
        <br />
        <br />
        <br />
        <table class="TableStyle" cellspacing="1" align="center" style="width: 30%">
            <tr style="height: 40px">
                <td style="width: 30%" align="right">
                    <h3><strong>帳號：</strong></h3>
                </td>
                <td style="width: 200px" align="center">
                    <asp:TextBox ID="txt_id" runat="server" MaxLength="50" class="form-control" placeholder="帳號" type="text" autocomplete="off" Style="font-size: 18px;"></asp:TextBox>
                </td>
                <td style="width: 30%"></td>
            </tr>
            <tr style="height: 40px">
                <td style="width: 30%" align="right">
                    <h3><strong>密碼：</strong></h3>
                </td>
                <td style="width: 200px" align="center">
                    <asp:TextBox ID="txt_pwd" runat="server" MaxLength="50" class="form-control" TextMode="Password" placeholder="密碼" Style="font-size: 18px;"></asp:TextBox>
                </td>
                <td style="width: 30%"></td>
            </tr>
            <tr style="height: 40px">
                <td style="width: 30%"></td>
                <td style="width: 250px" align="center">
                    <asp:Button ID="UserLogin" runat="server" Text="登入" Style="font-size: 18px; font-family: Microsoft JhengHei;" class="btn btn-primary" />&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="Cancel" runat="server" Text="取消" Style="font-size: 18px; font-family: Microsoft JhengHei;" class="btn btn-default" OnClientClick="window.close();" />
                </td>
                <td style="width: 30%"></td>
            </tr>
        </table>
    </form>
</body>
</html>
