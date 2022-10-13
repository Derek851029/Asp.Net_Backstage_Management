<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Menu.ascx.vb" Inherits="UserControl_Menu" %>
<div>
    <table id="bar" style="width: 100%;">
        <tr>
            <td style="height: 70px; width: 1024px;">
                <a href="../Default.aspx">
                    <img align="left" src="../images/LOGO.png" style="height: 90px; width: 315px;" /></a>
            </td>
            <td style="background-color: ; width: auto;"></td>
        </tr>
    </table>
    <nav id="navbar-example" class="navbar navbar-inverse navbar-static-top" role="navigation">
        <div class="container-fluid">
            <div class="collapse navbar-collapse bs-example-js-navbar-collapse">
                <div id="the_Menu" runat="server"></div>
                <ul class="nav navbar-nav navbar-right">
                    <li id="fat-menu" class="dropdown">
                        <a id="agent_info" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" role="button" aria-expanded="false" runat="server"></a>
                        <ul class="dropdown-menu" role="menu" aria-labelledby="agent_info">
                            <li id="user_li" runat="server"></li>
                            <li role="presentation" class="divider"></li>
                            <li>&nbsp;&nbsp;
                                <button id="Btn_Default" type="button" class="btn btn-success" onserverclick="Logout" runat="server">
                                    <span class="glyphicon glyphicon-home"></span>&nbsp;登出</button>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
            <!-- /.nav-collapse -->
        </div>
        <!-- /.container-fluid -->
    </nav>
    <style type="text/css">
        body {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 16px;
        }

        .dropdown:hover .dropdown-menu {
            display: block;
        }
    </style>
</div>
