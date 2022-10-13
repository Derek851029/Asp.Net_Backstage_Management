<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0020010001.aspx.cs" Inherits="_0020010001" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            ALL();
            style('Dispatch_Name', '');
        });

        function New_Page() {
            document.getElementById("btn_new").style.display = "";
            document.getElementById("btn_update").style.display = "none";
            document.getElementById("Add_Name").value = "";
            document.getElementById("TEL_Table").innerHTML = "";
            document.getElementById("Add_Note").value = "";
            document.getElementById("txt_hid_id").value = "0";
            style("TEL_value", "4");
            change_TEL();
            List_Service();
        }

        function List_Service() {
            $.ajax({
                url: '0020010001.aspx/List_Service',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Add_ID");
                    $select_elem.chosen("destroy");
                    $select_elem.empty();
                    $select_elem.append("<option value=''>請選擇通訊群組…</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Group_ID + "'>" + obj.Group_Name + "</option>");
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb', 'font-size': '18px' });
                }
            });
        }

        function Lift_Menu_List(value) {
            $.ajax({
                url: '0020010001.aspx/Lift_Menu_List',
                type: 'POST',
                data: JSON.stringify({ value: value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    document.getElementById("Left_Menu").innerHTML = doc.d;
                }
            });
        }

        function ALL() {
            document.getElementById("hid_Search").value = "";
            document.getElementById("txt_Search").value = "";
            Lift_Menu_List("");
            List_Table("65535");
        }

        function List_Table(flag) {
            var search = document.getElementById("hid_Search").value;
            $.ajax({
                url: '0020010001.aspx/List_Table',
                type: 'POST',
                data: JSON.stringify({ flag: flag, search: search }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    if (obj.data[0].A01 == "NULL") {
                        alert("該群組無任何資訊。");
                        return;
                    }
                    document.getElementById("table_title").innerHTML = "【群組】：" + obj.data[0].A01;
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
                        //"aaSorting": [[4, 'desc']],   //依第五項 倒排
                        "aaSorting": [[4, 'desc']],
                        "aLengthMenu": [[10, 25, 50, 100], [10, 25, 50, 100]],
                        "iDisplayLength": 50,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false,
                        }],
                        columns: [
                            { data: "A02" },
                            { data: "A03" },
                            { data: "A04" },
                            { data: "A05" },
                            { data: "A06" },
                            {
                                data: "A08", render: function (data, type, row, meta) {
                                    var a = "<button id='phone' type='button' class='btn btn-danger btn-lg' >" +
                                         "<span class='glyphicon glyphicon-earphone'></span>&nbsp;撥號</button>";
                                    if (data == "0") {
                                        a += "&nbsp;&nbsp;" +
                                            "<button id='edit' type='button' class='btn btn-primary btn-lg' data-toggle='modal' data-target='#New_Modal'>" +
                                            "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>";
                                    }
                                    return a;
                                }
                            },
                            { data: "A07" },
                            { data: "A10" }
                            ,{
                                data: "A09", render: function (data, type, row, meta) {
                                    return "<button type='button' id='M_C' class='btn btn-primary btn-lg' " +
                                        "data-toggle='modal' data-target='#newModal' >" +
                                        "<span class='glyphicon glyphicon-pencil'>" +
                                        "</span>&nbsp;新增/查看</button>";
                                }
                            }   /*//*/
                        ]
                    });
                    //================================================
                    $('#data tbody').unbind('click').
                    on('click', '#phone', function () {
                        var table = $('#data').DataTable();
                        var SYSID = table.row($(this).parents('tr')).data().A05;
                        TEL(SYSID);
                    }).
                     on('click', '#edit', function () {
                         var table = $('#data').DataTable();
                         var SYSID = table.row($(this).parents('tr')).data().A02;
                         List_Agent(SYSID);
                     }).
                     on('click', '#M_C', function () {
                         var table = $('#data').DataTable();
                         var phone = table.row($(this).parents('tr')).data().A09;
                         var name = table.row($(this).parents('tr')).data().A04;
                         var phone02 = table.row($(this).parents('tr')).data().A05;
                         //alert(phone);
                         List_M_C(phone, name, phone02);
                     });
                }
            });
        }
        function List_M_C(phone, name, phone02) {
            document.getElementById("Phone").innerHTML = phone;
            document.getElementById("Phone02").innerHTML = phone02;
            document.getElementById("txt_Name").value = name;
            document.getElementById("select_Type").value = '';
            document.getElementById("datetimepicker01").value = '';
            document.getElementById("txt_Ext_Num").value = '';
            document.getElementById("select_days").value = '1';
            $.ajax({
                url: '0020010001.aspx/List_M_C',
                type: 'POST',
                data: JSON.stringify({ phone: phone }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var table = $('#Table2').DataTable({
                        searching: false,
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
                        "aLengthMenu": [[5], [5]],
                        "iDisplayLength": 5,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false,
                        }],
                        columns: [
                            { data: "B01" },
                            { data: "B02" },
                            { data: "B03" },
                            { data: "B04" },
                            { data: "B05" },
                            {
                                data: "B01", render: function (data, type, row, meta) {
                                    var a = "<button id='update' type='button' class='btn btn-primary btn-lg' data-toggle='modal' data-target='#updateModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>";
                                    return a;
                                }
                            },
                            {
                                data: "B01", render: function (data, type, row, meta) {
                                        return "<button type='button' class='btn btn-danger btn-lg' id='delete'>" +
                                            "<span class='glyphicon glyphicon-remove'>" +
                                            "</span>&nbsp;刪除</button>";
                                }
                            }
                        ]
                    });
                    //================================================
                    $('#Table2 tbody').unbind('click').
                        on('click', '#delete', function () {
                            var table = $('#Table2').DataTable();
                            var MC_ID = table.row($(this).parents('tr')).data().B01;
                            //alert("Delete(" + MC_ID + ")");
                            Delete(MC_ID);
                        }).
                     on('click', '#update', function () {
                         var table = $('#Table2').DataTable();
                         var MC_ID = table.row($(this).parents('tr')).data().B01;
                         //alert("Edit_Group(" + MC_ID + ")");//
                         Update(MC_ID);
                     });
                }
            });
        }
        function Update(MC_ID) {
            $.ajax({
                url: '0020010001.aspx/Update',
                type: 'POST',
                data: JSON.stringify({ id: MC_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    //alert("Upadte 執行成功" + obj.data[0].A);
                    document.getElementById("M_C_ID").innerHTML = obj.data[0].A;
                    document.getElementById("txt_Name2").value = obj.data[0].B;
                    document.getElementById("datetimepicker03").value = obj.data[0].C;
                    document.getElementById("txt_Ext_Num2").value = obj.data[0].D;
                    document.getElementById("select_Type2").value = obj.data[0].E;
                }, error: function () {
                    alert("Update()失敗");
                }
            });
        }
        function Update_M_C(MC_ID) {
            var id2 = document.getElementById("M_C_ID").innerHTML;
            var type2 = document.getElementById("select_Type2").value;
            var name2 = document.getElementById("txt_Name2").value;
            var time03 = document.getElementById("datetimepicker03").value;
            var ext_num2 = document.getElementById("txt_Ext_Num2").value;
            //var dial_C2 = document.getElementById("txt_DIAL_Count2").value;

            var phone = document.getElementById("Phone").innerHTML;
            var phone02 = document.getElementById("Phone02").innerHTML;
            $.ajax({
                url: '0020010001.aspx/Update_M_C',
                type: 'POST',
                data: JSON.stringify({ id: id2, name2: name2, time03: time03, ext_num2: ext_num2, type2: type2 }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                    List_M_C(phone, name2, phone02);
                }, error: function () {
                    alert("修改失敗");
                }
            });
        }
        function Delete(MC_ID) {
            var phone = document.getElementById("Phone").innerHTML;
            var phone02 = document.getElementById("Phone02").innerHTML;
            var name = document.getElementById("txt_Name").value;
            $.ajax({
                url: '0020010001.aspx/Delete',
                type: 'POST',
                data: JSON.stringify({ id: MC_ID}),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                    List_M_C(phone, name, phone02);
                }, error: function () {
                    alert("刪除失敗");
                }
            });
        }
        //===========================================
        function TEL(tel) {
            $.ajax({
                url: '0020010001.aspx/TEL',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                data: JSON.stringify({ tel: tel }),
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                }, error: function () {
                    alert("撥號失敗");
                }
            });
        }
        //===========================================
        function List_Agent(ID) {
            List_Service();
            style("TEL_value", "");
            document.getElementById("btn_new").style.display = "none";
            document.getElementById("btn_update").style.display = "";
            $.ajax({
                url: '0020010001.aspx/List_Agent',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                data: JSON.stringify({ ID: ID }),
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    style('Add_ID', obj.data[0].Group_ID);
                    style("TEL_value", obj.data[0].Phone_Type);
                    document.getElementById("Add_Name").value = obj.data[0].Agent_Name;
                    document.getElementById("TEL_Table").innerHTML = obj.data[0].Agent_Phone;
                    document.getElementById("Add_Note").value = obj.data[0].Agent_Note;
                    document.getElementById("txt_hid_id").value = obj.data[0].SYSID;
                }
            });
        }
        //===========================================
        function search_btn() {
            var search = document.getElementById("txt_Search").value;
            document.getElementById("hid_Search").value = search;
            Lift_Menu_List(search);
        }
        //===========================================
        function List_Group_Table() {
            $.ajax({
                url: '0020010001.aspx/List_Group_Table',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var table = $('#table_group').DataTable({
                        searching: false,
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
                        "aLengthMenu": [[5], [5]],
                        "iDisplayLength": 5,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false,
                        }],
                        columns: [
                            { data: "A01" },
                            {
                                data: "A02", render: function (data, type, row, meta) {
                                    var a = "<input type='text' style='font-size: 18px' class='form-control' id='txt_" + row.A01 + "' placeholder=" + data + " value=" + data + " maxlength='10' onkeyup='cs(this);' />"
                                    return a;
                                }
                            },
                            {
                                data: "A03", render: function (data, type, row, meta) {
                                    var a = "<button id='open' type='button' class='btn btn-success btn-lg' >已啟用</button>";
                                    if (data == "0") {
                                        a = "<button id='open' type='button' class='btn btn-lg ' >已停用</button>";
                                    }
                                    return a;
                                }
                            },
                            {
                                data: "A03", render: function (data, type, row, meta) {
                                    var a = "<button id='edit' type='button' class='btn btn-primary btn-lg'>" +
                                            "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>";
                                    return a;
                                }
                            }
                        ]
                    });
                    //================================================
                    $('#table_group tbody').unbind('click').
                    on('click', '#open', function () {
                        var table = $('#table_group').DataTable();
                        var SYSID = table.row($(this).parents('tr')).data().A01;
                        var Value = table.row($(this).parents('tr')).data().A02;
                        var Flag = table.row($(this).parents('tr')).data().A03;
                        Open_Group(SYSID, Value, Flag);
                    }).
                     on('click', '#edit', function () {
                         var table = $('#table_group').DataTable();
                         var SYSID = table.row($(this).parents('tr')).data().A01;
                         Edit_Group(SYSID);
                     });
                }
            });
        }
        //===========================================
        function Open_Group(SYSID, Value, Flag) {
            $.ajax({
                url: '0020010001.aspx/Open_Group',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                data: JSON.stringify({ SYSID: SYSID, Flag: Flag }),
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "0") {
                        List_Group_Table();
                        alert("群組【" + Value + "】" + json.back);
                    }
                    else {
                        alert(json.status);
                    }
                }
            });
        }
        //===========================================
        function Edit_Group(SYSID) {
            var id = "txt_" + SYSID;
            var value = document.getElementById(id).value;
            $("#modal_group").css({ "display": "" });
            $("#Div_Loading").modal();
            $.ajax({
                url: '0020010001.aspx/Edit_Group',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                data: JSON.stringify({ SYSID: SYSID, Value: value }),
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "0") {
                        ALL();
                        alert("修改完成。");
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    $("#modal_group").css({ "display": "block", "padding-right": "21px" });
                }, error: function () {
                    $("#Div_Loading").modal('hide');
                    $("#modal_group").css({ "display": "block", "padding-right": "21px" });
                }
            });
        }
        //===========================================
        function Add_Group() {
            var value = document.getElementById("txt_add").value;
            $("#modal_group").css({ "display": "" });
            $("#Div_Loading").modal();
            $.ajax({
                url: '0020010001.aspx/Add_Group',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                data: JSON.stringify({ Value: value }),
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "0") {
                        ALL();
                        List_Group_Table();
                        alert("新增完成。");
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    $("#modal_group").css({ "display": "block", "padding-right": "21px" });
                }, error: function () {
                    $("#Div_Loading").modal('hide');
                    $("#modal_group").css({ "display": "block", "padding-right": "21px" });
                }
            });
        }
        //===========================================
        function Check_Value() {
            var id = document.getElementById("Add_ID").value;
            var t = document.getElementById("TEL_value").value;
            var name = document.getElementById("Add_Name").value;
            var note = document.getElementById("Add_Note").value;
            var sysid = document.getElementById("txt_hid_id").value;
            var phone = txt_TEL(t);
            $("#New_Modal").css({ "display": "" });
            $("#Div_Loading").modal();
            $.ajax({
                url: '0020010001.aspx/Check_Value',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                data: JSON.stringify({ id: id, name: name, phone: phone, note: note, sysid: sysid, t: t }),
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.flag == "0") {
                        ALL();
                        alert(json.status);
                    } else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    $("#New_Modal").css({ "display": "block", "padding-right": "21px" });
                }, error: function () {
                    $("#Div_Loading").modal('hide');
                    $("#New_Modal").css({ "display": "block", "padding-right": "21px" });
                }
            });
        }

        function txt_TEL(val) {
            var phone = "";
            switch (val) {
                case "0":
                    phone = document.getElementById("Add_Phone").value;
                    break;
                case "1":
                    phone = document.getElementById("Add_Phone").value + " " +
                        document.getElementById("Add_Phone2").value + " " +
                        document.getElementById("Add_Phone3").value;
                    break;
                case "2":
                    phone = document.getElementById("Add_Phone").value + " " +
                        document.getElementById("Add_Phone2").value;
                    break;
                case "3":
                    phone = document.getElementById("Add_Phone").value;
                    break;
                case "4":
                    phone = document.getElementById("Add_Phone").value;
                    break;
                case "5":
                    phone = document.getElementById("Add_Phone").value;
                    break;
                default:
                    phone = "";
            }
            return phone;
        }
        //===========================================
        function change_TEL() {
            var value = document.getElementById("TEL_value").value;
            $.ajax({
                url: '0020010001.aspx/change_TEL',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                data: JSON.stringify({ value: value }),
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    document.getElementById("TEL_Table").innerHTML = json.status;
                    $('[data-toggle="tooltip"]').tooltip();
                }
            });
        }
        //================
        function New_M_C() {
            var phone = document.getElementById("Phone").innerHTML;
            var phone02 = document.getElementById("Phone02").innerHTML;

            var type = document.getElementById("select_Type").value;
            var time01 = document.getElementById("datetimepicker01").value;
            var name = document.getElementById("txt_Name").value;
            var ext_num = document.getElementById("txt_Ext_Num").value;
            var days = document.getElementById("select_days").value;
            //alert("A=" + phone + "  B=" + time01 + "  C=" + time02 + "  D=" + name + "  E=" + dial_C);
            $.ajax({
                url: '0020010001.aspx/New_M_C',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                data: JSON.stringify({ phone: phone, type: type, time01: time01, ext_num: ext_num, name: name, days: days }),
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.flag == "0") {
                        //alert(json.status);
                        List_M_C(phone, name, phone02)
                        //document.getElementById("datetimepicker01").value = "";
                        //document.getElementById("datetimepicker02").value = "";
                        //document.getElementById("txt_DIAL_Count").value = "";
                    } else {
                        alert(json.status);
                    }
                }
            });
        }
        //================【下拉選單】 CSS 修改 ================
        function style(Name, value) {
            var $select_elem = $("#" + Name);
            $select_elem.chosen("destroy")
            document.getElementById(Name).value = value;
            $select_elem.chosen({
                width: "100%",
                search_contains: true
            });
            $('.chosen-single').css({ 'background-color': '#ffffbb', 'font-size': '18px' });
        }
    </script>
    <style>
        body
        {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 18px;
            background-color: #2E3039;
        }

        #main-menu
        {
            background-color: #2E3039;
        }

        .list-group-item
        {
            background-color: #2E3039;
            border: none;
        }

        a.list-group-item
        {
            color: #FFF;
        }

            a.list-group-item:hover,
            a.list-group-item:focus
            {
                background-color: #EAA333;
            }

            a.list-group-item.active,
            a.list-group-item.active:hover,
            a.list-group-item.active:focus
            {
                color: #FFF;
                background-color: #EAA333;
                border: none;
            }

        .list-group-item:first-child,
        .list-group-item:last-child
        {
            border-radius: 0;
        }

        .list-group-level1 .list-group-item
        {
            padding-left: 30px;
        }

        .list-group-level2 .list-group-item
        {
            padding-left: 60px;
        }

        thead th
        {
            background-color: #666666;
            color: white;
        }

        tr td:first-child,
        tr th:first-child
        {
            border-top-left-radius: 8px;
            border-bottom-left-radius: 8px;
        }

        tr td:last-child,
        tr th:last-child
        {
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
        }

        #table_group td:nth-child(4), #table_group td:nth-child(3),
        #table_group td:nth-child(2), #table_group td:nth-child(1),
        #data td:nth-child(7), #data td:nth-child(6),
        #data td:nth-child(5), #data td:nth-child(4), #data td:nth-child(3),
        #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5)
        {
            text-align: center;
        }
    </style>
    <!-- ====== Loading ====== -->
    <div class="modal fade" id="Div_Loading" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 350px;">
            <div class="modal-content" style="margin-top: 100%; margin-left: 25%;">
                <div style="text-align: center">
                    <br />
                    <img src="img/ajax-loader.gif" />
                    <h3>Loading...</h3>
                    <br />
                </div>
            </div>
        </div>
    </div>
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="New_Modal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 600px;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <input id="txt_hid_id" name="txt_hid_id" type="hidden" />
                    <h2 class="modal-title"><strong>
                        <label id="txt_Top">新增通訊人員</label>
                    </strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table class="display table table-bordered table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="2">
                                    <span style="font-size: 20px"><strong>新增通訊人員</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>通訊群組</strong>
                                </th>
                                <th style="width: 65%">
                                    <select id="Add_ID" name="Add_ID" class="form-control">
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>人員姓名</strong>
                                </th>
                                <th style="width: 65%;">
                                    <div align="center" data-toggle="tooltip" title="必填，不能超過１０個字元，並且含有不正確的符號">
                                        <input type="text" class="form-control" id="Add_Name" placeholder="人員姓名"
                                            style="width: 98%; background-color: #ffffbb; Font-Size: 18px;" maxlength="10" onkeyup="cs(this);" />
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>電話類型</strong>
                                </th>
                                <th style="width: 65%;">
                                    <select id="TEL_value" name="TEL_value" class="form-control" onchange="change_TEL()">
                                        <option value=''>請選擇電話類型…</option>
                                        <option value='4'>社區分機</option>
                                        <!--<option value='0'>行動電話</option>
                                        <option value='1'>一般市話</option>
                                        <option value='2'>服務專線</option>
                                        <option value='3'>院區簡碼</option>
                                        <option value='5'>院區分機</option>-->
                                    </select>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>人員電話</strong>
                                </th>
                                <th style="width: 65%;" id="TEL_Table"></th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 35%; height: 55px;">
                                    <strong>備註</strong>
                                </th>
                                <th style="width: 65%;">
                                    <div align="center" data-toggle="tooltip" title="不能超過５０個字元">
                                        <textarea id="Add_Note" name="Add_Note" class="form-control" cols="30" rows="3" placeholder="備註"
                                            style="resize: none; Font-Size: 18px;" maxlength="50" onkeyup="cs(this);"></textarea>
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="Check_Value()"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增人員</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="Check_Value()"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改人員</button>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                    <!-- ========================================== -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">關閉</button>
                </div>
            </div>
        </div>
    </div>
    <!-- ====== Modal ====== -->
    <div class="modal fade" id="modal_group" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 650px;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>設定群組</strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <table id="table_group" class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center; width: 15%">群組編號</th>
                                <th style="text-align: center; width: 45%">群組名稱</th>
                                <th style="text-align: center; width: 20%">狀態</th>
                                <th style="text-align: center; width: 20%">功能</th>
                            </tr>
                        </thead>
                    </table>
                    <br />
                    <table class="display table table-bordered table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>新增群組</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 25%;">
                                    <strong>群組名稱</strong>
                                </th>
                                <th style="width: 50%">
                                    <input type="text" style="font-size: 18px" class='form-control' id="txt_add" maxlength='10' onkeyup='cs(this);' />
                                </th>
                                <th style="text-align: center; width: 25%">
                                    <button type="button" class="btn btn-success btn-lg" onclick="Add_Group();"><span class="glyphicon glyphicon-plus"></span>&nbsp;新增</button>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; height: 55px;" colspan="3">
                                    <button type="button" class="btn btn-default btn-lg" data-dismiss="modal">返回&nbsp;<span class="glyphicon glyphicon-share-alt"></span></button>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                    <!-- ========================================== -->
                </div>
            </div>
        </div>
    </div>
    <!-- ====== Modal ====== -->
    <div style="display: inline; float: left; width: 15%">
        <table style="width: 100%;">
            <tr>
                <td>
                    <div>
                        <!-- 大頭貼 -->
                        <div style="background-color: #2E3039; text-align: center;">
                            <img src="../images/Icon_002.png" class="img-rounded" style="margin: 10px;" />
                        </div>
                        <!-- 大頭貼 -->
                        <!-- 使用者訊息 -->
                        <div style="background-color: #2E3039; color: #FFF; text-align: center; font-size: 24px;">
                            <label>通訊錄系統</label>
                        </div>
                        <div align="center">
                            <input type="text" class="form-control" id="txt_Search" placeholder="搜尋人員" />
                            <input id="hid_Search" name="hid_Search" type="hidden" />
                            <div style="height: 10px"></div>
                            <button type="button" class="btn btn-info" onclick="search_btn();"><span class='glyphicon glyphicon-search'></span>&nbsp;搜尋人員</button>&nbsp;
                            <button type="button" class="btn btn-primary" onclick="ALL();"><span class='glyphicon glyphicon-repeat'></span>&nbsp;顯示全部</button>
                            <div style="height: 10px"></div>
                            <button type="button" class="btn btn-success " data-toggle="modal" data-target="#New_Modal" onclick="New_Page();"><span class='glyphicon glyphicon-pencil'></span>&nbsp;新增人員</button>&nbsp;
                            <button type="button" class="btn btn-warning " data-toggle="modal" data-target="#modal_group" onclick="List_Group_Table();"><span class='glyphicon glyphicon-cog'></span>&nbsp;設定群組</button>
                            <div style="height: 10px"></div>
                        </div>
                        <!-- 使用者訊息 -->
                        <div id="Left_Menu">
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div style="float: left; background-color: #fff; width: 85%; height: 100%">
        <div style="width: 95%; margin: 10px 10px;">
            <h2>
                <label id="table_title"></label>
            </h2>
            <table id="data" class="display table table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center; width: 8%">編號</th>
                        <th style="text-align: center; width: 8%">群組</th>
                        <th style="text-align: center; width: 8%">姓名</th>
                        <th style="text-align: center; width: 16%">電話</th>
                        <th style="text-align: center; width: auto">備註</th>
                        <th style="text-align: center; width: auto">功能</th>
                        <th style="text-align: center; width: 10%">建立時間</th>
                        <th style="text-align: center; width: auto">留言通數</th>
                        <th style="text-align: center; width: auto">電話提醒</th><!---->
                    </tr>
                </thead>
            </table>
        </div>
    </div>

    <!-- ====== 上下班表 ====== -->
    <div class="modal fade" id="newModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1100px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>新增 來電提醒&nbsp;&nbsp;&nbsp;&nbsp;<label id="Phone02"></label>&nbsp;
                        <label id="Phone" hidden="hidden"></label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== 表格 -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>提醒設定</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>提醒類別</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <select id="select_Type" name="select_Type" class="chosen-select" title="必選" style="background-color: #ffffbb">
                                        <option value="">請選擇類別</option>
                                        <option value="1">Morning Call</option>
                                        <option value="3">館內門診通知</option>
                                        <option value="4">用藥通知(早)</option>
                                        <option value="5">用藥通知(中)</option>
                                        <option value="6">用藥通知(晚)</option>
                                        <option value="7">流感疫苗注射通知</option>
                                        <option value="8">老人健檢通知</option>
                                        <option value="9">打針通知</option>
                                        <!--<option value="4408">設定時間已到</option>
                                        <option value="4409">結束請按#字鍵</option>-->
                                    </select>
                                </td>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>提醒時間</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="必選">
                                        <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01" placeholder="" style="background-color: #ffffbb" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>對方稱謂</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="必填">
                                        <input type="text" class="form-control" id="txt_Name" name="txt_Name" placeholder="" style="background-color: #ffffbb" />
                                    </div>
                                </td>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>連續提醒天數</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <select id="select_days" name="select_days" class="chosen-select" title="必選" style="background-color: #ffffbb">
                                        <option value="1">一天</option>
                                        <option value="2">兩天</option>
                                        <option value="3">三天</option>
                                        <option value="4">四天</option>
                                        <option value="5">五天</option>
                                        <option value="6">六天</option>
                                        <option value="7">七天</option>
                                    </select>
                                </td>
                            </tr>
                            <tr hidden="hidden">
                                <th style="text-align: center; width: 20%">
                                    <strong>分機號碼</strong>
                                </th>
                                <td style="width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="非必填">
                                        <input id="txt_Ext_Num" class="form-control" placeholder="" maxlength="10" onkeyup="value=value.replace(/[^\d]/g,'') "
                                            style="" data-toggle="tooltip" title="只能填數字" />
                                    </div>
                                </td><!---->
                            </tr>
                            <tr>
                                <th style="text-align: center;" colspan="4">
                                    <button id="Button4" type="button" class="btn btn-primary btn-lg" onclick="New_M_C()"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;新增</button>
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span>&nbsp;取消</button>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                    <h2><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;提醒預約一覽</strong></h2>
                    <table id="Table2" class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center;">編號</th>
                                <th style="text-align: center;">類別</th>
                                <th style="text-align: center;">提醒時間</th>
                                <th style="text-align: center;">對方稱謂</th>
                                <th style="text-align: center;">分機號碼</th>
                                <th style="text-align: center;">修改</th>
                                <th style="text-align: center;">取消</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
                    <!-- ========================================== 修改用表格 -->
        <div class="modal fade" id="updateModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1100px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>修改 來電提醒&nbsp;&nbsp;&nbsp;&nbsp;<label id="M_C_ID"></label></strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== 表格 -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>提醒設定</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>提醒類別</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <select id="select_Type2" name="select_Type2" class="chosen-select" title="必選" style="background-color: #ffffbb">
                                        <option value="">請選擇類別</option>
                                        <option value="1">Morning Call</option>
                                        <option value="3">館內門診通知</option>
                                        <option value="4">用藥通知(早)</option>
                                        <option value="5">用藥通知(中)</option>
                                        <option value="6">用藥通知(晚)</option>
                                        <option value="7">流感疫苗注射通知</option>
                                        <option value="8">老人健檢通知</option>
                                        <option value="9">打針通知</option>
                                        <!--<option value="4408">設定時間已到</option>
                                        <option value="4409">結束請按#字鍵</option>-->
                                    </select>
                                </td>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>提醒時間</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="必選">
                                        <input type="text" class="form-control" id="datetimepicker03" name="datetimepicker03" placeholder="" style="background-color: #ffffbb" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 20%; height: 55px;">
                                    <strong>對方稱謂</strong>
                                </th>
                                <td style="text-align: center; width: 30%">
                                    <div style="float: left" data-toggle="tooltip" title="必填">
                                        <input type="text" class="form-control" id="txt_Name2" name="txt_Name2" placeholder="" style="background-color: #ffffbb" />
                                    </div>
                                </td>
                                <th style="text-align: center; width: 20%" hidden="hidden">
                                    <strong>分機號碼</strong>
                                </th>
                                <td style="width: 30%" hidden="hidden">
                                    <div style="float: left" data-toggle="tooltip" title="非必填">
                                        <input id="txt_Ext_Num2" class="form-control" placeholder="" maxlength="10" onkeyup="value=value.replace(/[^\d]/g,'') "
                                            style="" data-toggle="tooltip" title="只能填數字" />
                                    </div>
                                </td>
                                <!---->
                            </tr>
                            <tr>
                                <th style="text-align: center;" colspan="4">
                                    <button id="Button1" type="button" class="btn btn-primary btn-lg" onclick="Update_M_C()"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span>&nbsp;取消</button>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <script  type="text/javascript">
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
            $(function () {
                $('.chosen-select').chosen();
                $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
                $('.chosen-single').css({ 'background-color': '#ffffbb' });
            });
        </script>
    </div>
</asp:Content>
