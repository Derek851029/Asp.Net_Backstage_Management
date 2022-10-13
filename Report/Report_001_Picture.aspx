<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Report_001_Picture.aspx.cs" Inherits="Report_Report_001_Picture" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
       <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server" />
            <rsweb:ReportViewer ID="rptviewer" runat="server" Width="100%" Height="1200px" />
        </div>
    </form>
</body>
</html>
