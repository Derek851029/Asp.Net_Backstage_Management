<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="MemberEdit.aspx.cs" Inherits="MemberEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head2" Runat="Server">
    
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="js/moment.min.js"></script>

    
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

        #data_company td:nth-child(2), #data_company td:nth-child(1),
        #data2 td:nth-child(3), #data2 td:nth-child(1),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1) {
            text-align: center;
        }
        .auto-style1 {
            width: 182px;
        }

        #data th, #data td{
            text-align:center;
        }
        #agent-data th, #agent-data td{
            text-align:center;
        }
        
        .familydata table , .familydata th, .familydata td{
            font-size:25px;
            width:20%;
            padding:5px;
            margin:auto;
            border:3px double #aaa;
        }
    </style>

    
    <div class="container">
        <div style="margin-top:20px;">
            <button type="button" class="btn btn-warning btn-lg" onclick="location.href='LineMemberList.aspx';">返回</button>

        </div>
        <div>
            <table class="familydata" style="margin-top:5px;width:100%;">
                <tr>
                    <th colspan="3">
                        人員資料
                        <input type="hidden" id="MID" data-addtype="f" />
                    </th>
                </tr>
                <tr>
                    <th colspan="3">
                        <input type="hidden" id="LMBID" />
                        LINE會員名稱: &nbsp;&nbsp;
                        <span id="LineName"></span>
                    </th>
                </tr>
                <tr>
                    <th colspan="3">
                        人員: &nbsp;&nbsp;
                        <select id="agentlist">

                        </select>
                    </th>
                </tr>
                <tr>
                    <th style="width:33%;">姓名</th>
                    <th style="width:33%;">公司</th>
                    <th style="width:33%;">手機</th>
                </tr>
                <tr>
                    <th id="Name">
                        
                    </th>
                    <th id="Company">
                        
                    </th>
                    <th id="Phone">
                        
                    </th>
                </tr>
            </table>
            <table class="familydata" style="width:100%;">
                <tr>
                    <th style="width:20%;">身分</th>
                    <th style="width:80%;" id="Team">
                        
                    </th>
                </tr>
                <tr>
                    <th>信箱</th>
                    <th id="Email">
                        
                    </th>
                </tr>
            </table>
            <table class="familydata" style="width:100%;">
                <tr>
                    <th style="text-align:center;">
                        <button type="button" class="btn btn-info btn-lg" onclick="EditUser();">儲存</button>
                    </th>
                </tr>
            </table>
        </div>

    </div>





    <script type="text/javascript">
        $(function () {
            bindata();

            $('#agentlist').change(function () {
                bindagent();
            });
        });

        function bindata() {
            $.ajax({
                type: 'post',
                url: 'MemberEdit.aspx/bindata',
                contentType: 'application/json;utf-8',
                data: JSON.stringify({}),
                dataType: 'json',
                success: function (doc) {
                    if (doc.d == '') {
                        alert('找不到此人');
                        location.href = 'LineMemberList.aspx';
                    }
                    let datas = JSON.parse(doc.d);
                    let linename = datas.LineName;
                    $('#LineName').text(linename);
                    let lmbid = datas.LMBID;
                    $('#LMBID').val(lmbid);
                    let data = datas.user;
                    if (data != null) {
                        $('#Name').text(data.Agent_Name);
                        $('#Company').text(data.Agent_Company);
                        $('#Phone').text(data.Agent_Phone_2);
                        $('#Team').text(data.Agent_Team);
                        $('#Email').text(data.Agent_Mail);
                        agentlist(data.SYSID);
                    }
                    else {
                        agentlist('');
                    }
                }
            })
        }

        function agentlist(id) {
            $.ajax({
                type: 'post',
                url: 'MemberEdit.aspx/agentlist',
                contentType: 'application/json;utf-8',
                data: JSON.stringify({}),
                dataType: 'json',
                success: function (doc) {
                    let data = JSON.parse(doc.d);
                    let txt = '';
                    for (let i = 0; i < data.length; i++) {
                        txt += '<option value="'+data[i].SYSID+'">' + data[i].Agent_Name + '</option>';
                    }
                    $('#agentlist').html(txt);
                    if (id != '') {
                        $('#agentlist').val(id);
                    }
                    else {
                        bindagent();
                    }
                }
            })
        }

        function bindagent() {
            $.ajax({
                type: 'post',
                url: 'MemberEdit.aspx/bindagent',
                contentType: 'application/json;utf-8',
                data: JSON.stringify({ id: $('#agentlist').val() }),
                dataType: 'json',
                success: function (doc) {
                    let data = JSON.parse(doc.d);
                    $('#Name').text(data.Agent_Name);
                    $('#Company').text(data.Agent_Company);
                    $('#Phone').text(data.Agent_Phone_2);
                    $('#Team').text(data.Agent_Team);
                    $('#Email').text(data.Agent_Mail);
                }
            })
        }

        function EditUser() {
            $.ajax({
                type: 'post',
                url: 'MemberEdit.aspx/EditUser',
                contentType: 'application/json;utf-8',
                data: JSON.stringify({
                    LMBID: $('#LMBID').val(),
                    ID: $('#agentlist').val()
                }),
                dataType: 'json',
                success: function (doc) {
                    alert(doc.d);
                }
            });
        }


    </script>

</asp:Content>

