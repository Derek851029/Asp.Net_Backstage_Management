<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0030010003.aspx.cs" Inherits="_0030010003" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script type="text/javascript">
        var Work_List_array = []
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            bindTable();
            //bindTable_2();
            ShowTime();
            Main_List()
            Detail_List()

            Listener_event()  
        });

        function Listener_event() {
            $('#Add_Main_Detail').click(function () {
                Safe_Main_Detail()

                $('#txt_main').val('')
                $('#txt_detail').val('')
                //first to clean Text2 and list main
                $('#Text2').html('')
                Main_List()
                Detail_List()
            })

            $('#add').click(function () {
                let Main = $('#Text2').val()
                if (Main != '') {
                    $('#txt_main').val(Main)
                }
            })

            $('#Add_Work').click(function () {
                let Work_input = $('#Text5').val()
                if (Work_input == '') {
                    alert('工作事項未填。')
                    return
                }
                let Work_li_Count = $('#Work_li_Count').val()
                let Text5 = $('#Text5').val()
                Work_List_array.push(Text5)
                console.log(Work_List_array)
                $('#Work_List').append('<li id="li_' + Work_li_Count + '">' + Text5 + '<a id="Delete_' + Work_li_Count+'" style="margin-left:20px">刪除</a></li>')
                $('#Work_li_Count').val(parseInt(Work_li_Count) + 1)
                $('#Delete_' + Work_li_Count + '').click(function () {
                    $('#li_' + Work_li_Count + '').remove()
                    let location = Work_List_array.indexOf(Text5)
                    Work_List_array.splice(location,1)
                })
                $('#Text5').val('')
            })
        }

        function bindTable() {
            $.ajax({
                url: '0030010003.aspx/GetOEList',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#data').DataTable({
                        destroy: true,
                        data: eval(doc.d),
                        "oLanguage": {
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
                        columns: [                                      // 顯示資料列
                                { data: "OE_ID" },
                                { data: "Product_Name" },
                                { data: "Product_ID" },
                                { data: "Main_Classified" },
                                { data: "Detail_Classified" },
                                { data: "Price" },
                                {
                                    data: "OE_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-primary btn-lg' " +
                                            "data-toggle='modal' data-target='#newModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'>" +
                                            "</span>&nbsp;修改</button>";
                                    }
                                },
                                {
                                    data: "OE_T_ID", render: function (data, type, row, meta) {
                                        return "<button type='button' class='btn btn-danger btn-lg' id='delete'>" +
                                            "<span class='glyphicon glyphicon-remove'>" +
                                            "</span>&nbsp;刪除</button>";
                                    }
                                }
                        ]
                    });
                    $('#data tbody').unbind('click').
                       on('click', '#edit', function () {
                           var table = $('#data').DataTable();
                           var OE_ID = table.row($(this).parents('tr')).data().OE_ID;
                           //alert(PID);
                           
                           Load_Modal(OE_ID);
                       }).on('click', '#delete', function () {
                           var table = $('#data').DataTable();
                           var OE_ID = table.row($(this).parents('tr')).data().OE_ID;
                           Delete(OE_ID);
                       });
                }
            });
        }

        function Delete(OE_ID) {
            if (confirm("確定要刪除嗎？")) {
                $.ajax({
                    url: '0030010003.aspx/Delete',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ OE_ID: OE_ID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {
                            bindTable();
                        }
                    }
                });
            }
        };

        function URL(PID) {
            $.ajax({
                url: '0030010003.aspx/URL',
                type: 'POST',
                data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.type == "ok") {
                        window.location = json.status;
                    } else {
                        alert(json.status);
                    }
                }
            });
        }


        function bindTable_2(PID) {            // 子公司列表
            $.ajax({
                url: '0030010003.aspx/GetSubsidiaryList',
                type: 'POST',
                //data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#Table1').DataTable({
                        destroy: true,
                        data: eval(doc.d),
                        "oLanguage": {
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
                        columns: [                                      // 顯示資料列
                                { data: "PNumber" },
                                { data: "SalseAgent" },
                                { data: "BUSINESSNAME" },
                                { data: "Information_PS" },
                                { data: "SetupDate" },
                                { data: "UpdateDate" },

 /*                               {
                                    data: "SYSID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-primary btn-lg' " +
                                            "data-toggle='modal' data-target='#Div1' >" +
                                            "<span class='glyphicon glyphicon-pencil'>" +
                                            "</span>&nbsp;修改</button>";
                                    }
                                }       //*/
                        ]
                    });

/*                    $('#Table1 tbody').unbind('click').
                        on('click', '#edit', function () {
                            var table = $('#Table1').DataTable();
                            var PID = table.row($(this).parents('tr')).data().PID;
                            var PNumber = table.row($(this).parents('tr')).data().PNumber;
                            alert('修改子公司');
                            Load_Modal_02(PID, PNumber);     //未改完 1 要換 PNumber
                        });     //*/


                }
            });
        }

        function ShowTime() {                               //自動抓現在時間(實行指令時)
            var NowDate = new Date();
            var h = NowDate.getHours();
            var m = NowDate.getMinutes();
            var s = NowDate.getSeconds();
            var y = NowDate.getFullYear();
            var mon = NowDate.getMonth() + 1;
            var d = NowDate.getDate();
            <%--if (mon < 10) {
                if (d < 10) {
                    if (h < 10) {
                        document.getElementById('LoginTime').value = y + "/0" + mon + "/0" + d + " " + h + ":" + m;
                    }
                } else { document.getElementById('LoginTime').value = y + "/0" + mon + "/" + d + " " + h + ":" + m; }
            } else {
                if (d < 10) {
                    document.getElementById('LoginTime').value = y + "/" + mon + "/0" + d + " " + h + ":" + m;
                } else { document.getElementById('LoginTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m; }
                   }--%>
            //document.getElementById('LoginTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
            //document.getElementById('EstimatedFinishTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
        }

        function List_PROGLIST(ROLE_ID) {
            $.ajax({
                url: '0030010003.aspx/List_PROGLIST',
                type: 'POST',
                data: JSON.stringify({ ROLE_ID: ROLE_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    if (obj.data[0].TREE_ID == "NULL") {
                        alert("查無此權限代碼，，請詢問管理人員，謝謝。");
                        return;
                    }
                    var table = $('#data2').DataTable({
                        destroy: true,
                        data: eval(doc.d),
                        "oLanguage": {
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
                        "aLengthMenu": [[25, 50, 100], [25, 50, 100]],
                        "iDisplayLength": 25,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                                { data: "TREE_ID" },
                                { data: "M_TREE_NAME" },
                                { data: "TREE_NAME" },
                                { data: "Agent_Name" },
                                { data: "UpDateDate" },
                                {
                                    data: "NowStatus", render: function (data, type, row, meta) {
                                        var checked = 'checked/>'
                                        if (data == '0') {
                                            checked = '/>'
                                        }
                                        return "<div class='checkbox'><label>" +
                                            "<input type='checkbox' style='width: 30px; height: 30px;' id=check " +
                                            checked + "</label></div>";
                                    }
                                }]
                    });
                    //================================

                    $('#data2 tbody').unbind('click').
                        on('click', '#check', function () {
                            var table = $('#data2').DataTable();
                            var Flag = table.row($(this).parents('tr')).data().NowStatus;
                            var TREE_ID = table.row($(this).parents('tr')).data().TREE_ID;
                            //Check(Flag, TREE_ID, ROLE_ID.toString());
                        });
                }
            });
        }

        function Check(Flag, TREE_ID, ROLE_ID) {
            $.ajax({
                //url: '0030010003.aspx/Check_Menu',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    TREE_ID: TREE_ID,
                    ROLE_ID: ROLE_ID,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    alert(json.status);
                }
            });
            List_PROGLIST(ROLE_ID);
        }
        //==============================
        function Xin_De() {     //按新增客戶資料後
            Load_Modal(0);
            //alert('新增');
        }

        function Load_Modal(OE_ID) {                                          // 讀資料
            //alert(OE_ID);
            if (OE_ID == 0) {
                //alert('檢查中1');
                document.getElementById("btn_new").style.display = "";
                document.getElementById("btn_update").style.display = "none";
                document.getElementById("title_modal").innerHTML = '商品（新增）';

                document.getElementById("OE_ID").innerHTML = "";
                document.getElementById("Text1").value = "";
                document.getElementById("p_id").value = "";
                $('#Text2').val('')
                $('#Text3').val('')
                //style('Text2', '');
                //style('Text3', '');
                document.getElementById("Text4").value = "";
                //alert('檢查中2');
                Work_List_array = []
                $('#Work_li_Count').val(0)
                $('#Work_List').html('')
            } else {
                //
                //document.getElementById("txt_ROLE_ID").disabled = true;
                document.getElementById("btn_update").style.display = "";                               //顯示修改鈕
                document.getElementById("btn_new").style.display = "none";                          //隱藏新增鈕
                document.getElementById("title_modal").innerHTML = '商品（修改）';
                Load_Data(OE_ID);
            }   //else 結束
        }

        // 預定修改執行部分
        function Load_Data(OE_ID) {
            //alert('Load_Data');
            document.getElementById("OE_ID").innerHTML = OE_ID;
            $.ajax({
                url: '0030010003.aspx/Load_Data',
                type: 'POST',
                data: JSON.stringify({ OE_ID: OE_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    //document.getElementById("PID").innerHTML = obj.data[0].PID;   //沒用到要遮蔽
                    document.getElementById("Text1").value = obj.data[0].Product_Name;
                    document.getElementById("p_id").value = obj.data[0].P_ID;
                    //document.getElementById("Text2").value = obj.data[0].Main_Classified;
                    document.getElementById("Text2").value = obj.data[0].Main_Classified;
                    document.getElementById("Text3").value = obj.data[0].Detail_Classified;
                    //style('Text2', obj.data[0].Main_Classified);
                    //document.getElementById("Text3").value = obj.data[0].Detail_Classified;                    
                    //style('Text3', obj.data[0].Detail_Classified);
                    document.getElementById("Text4").value = obj.data[0].Unit_Price;
                    if (obj.data[0].Work_List != '') {
                        Work_List_array = obj.data[0].Work_List.split(',')
                    } else {
                        Work_List_array = []
                    }
                    
                    let Text5 = $('#Text5').val()
                    $('#Work_List').html('')
                    $.each(Work_List_array, function (index, value) {
                        let Work_li_Count = $('#Work_li_Count').val()
                        $('#Work_List').append('<li id="li_' + Work_li_Count + '">' + value + '<a id="Delete_' + Work_li_Count +'" style="margin-left:20px">刪除</a></li>')
                        $('#Work_li_Count').val(parseInt(Work_li_Count) + 1)
                        $('#Delete_' + Work_li_Count + '').click(function () {
                            $('#li_' + Work_li_Count + '').remove()
                            let location = Work_List_array.indexOf(Text5)
                            Work_List_array.splice(location, 1)
                        })
                    })
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }
        
        function Main_List() {     //選主分類
            $.ajax({
                url: '0030010003.aspx/Main_List',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Text2");
                    $select_elem.chosen("destroy")
                    $select_elem.append("<option value=''>" + "請選主分類…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.A + "'>" + obj.A + "</option>");
                    });
                    //$select_elem.chosen(
                    //{
                    //    width: "100%",
                    //    search_contains: true
                    //});
                    //$('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        function Detail_List() {     //選子分類
            var value = document.getElementById("Text2").value;
            //alert("a"+value+"b");
            $.ajax({
                url: '0030010003.aspx/Detail_List',
                type: 'POST',
                data: JSON.stringify({ Main: value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#Text3");
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選子分類…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.A + "'>" + obj.A + "</option>");
                    });
                    //$select_elem.chosen(
                    //{
                    //    width: "100%",
                    //    search_contains: true
                    //});
                    //$('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
        }

        //==============================子公司相關
        function Xin_De_02(PID) {     //按 新增子公司 後
            //alert('新增子公司'+PID);
            Load_Modal_02(PID, 0);            
        }

        function Load_Modal_02(PID, PNumber) {                                          // 讀資料
            //alert(PID);
            if (PNumber == 0) {
                //alert('檢查中1');
                document.getElementById("Button_new").style.display = "";
                document.getElementById("Button_update").style.display = "none";
                document.getElementById("Label1").innerHTML = '子公司（新增）';
                //Load_Data_02(PID, 0);  //還沒改
            } else {
                //alert('檢查中2');
                //document.getElementById("txt_ROLE_ID").disabled = true;
                document.getElementById("Button_update").style.display = "";                               //顯示修改鈕
                document.getElementById("Button_new").style.display = "none";                          //隱藏新增鈕
                document.getElementById("Label1").innerHTML = '子公司（修改）';
                //Load_Data_02(PID, PNumber);  //還沒改
            }   //else 結束
        }

        // 預定修改執行部分
        function Load_Data_02(PNumber) {
            //alert('Load_Data');
            $.ajax({
                url: '0030010003.aspx/Load_Data_02',    // 還沒弄Load_Data_02
                type: 'POST',
                data: JSON.stringify({ PNumber: PNumber }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    document.getElementById("Name").value = obj.data[0].Name;   //沒用到要遮蔽
                    document.getElementById("Text9_2").value = obj.data[0].ADDR;
                    document.getElementById("Text10_2").value = obj.data[0].CONTACT_ADDR;

                    //document.getElementById("PID_2").innerHTML = obj.data[0].PID;   //沒用到要遮蔽
                    document.getElementById("business_name_2").innerHTML = obj.data[0].BUSINESSNAME;
                    document.getElementById("business_id_2").innerHTML = obj.data[0].BUSINESSID;
                    document.getElementById("id_2").value = obj.data[0].ID;
                    //document.getElementById("datetimepicker01_2").value = obj.data[0].BUS_CREATE_DATE;
                    document.getElementById("Text1_2").value = obj.data[0].APPNAME;
                    document.getElementById("Text2_2").value = obj.data[0].APP_SUBTITLE;
                    document.getElementById("Text3_2").value = obj.data[0].APP_MTEL;
                    document.getElementById("Text4_2").value = obj.data[0].APP_EMAIL;
                    document.getElementById("Text5_2").value = obj.data[0].APPNAME_2;
                    document.getElementById("Text6_2").value = obj.data[0].APP_SUBTITLE_2;
                    document.getElementById("Text7_2").value = obj.data[0].APP_MTEL_2;
                    document.getElementById("Text8_2").value = obj.data[0].APP_EMAIL_2;
                    document.getElementById("Text11_2").value = obj.data[0].APP_OTEL;
                    document.getElementById("Text12_2").value = obj.data[0].APP_FTEL;
                    document.getElementById("Text13_2").value = obj.data[0].INVOICENAME;
                    document.getElementById("Text14_2").value = obj.data[0].Inads;
                    document.getElementById("Text15_2").value = obj.data[0].HardWare;
                    document.getElementById("Text16_2").value = obj.data[0].SoftwareLoad;
                    document.getElementById("Text17_2").value = obj.data[0].Mail_Type;
                    document.getElementById("Text18_2").value = obj.data[0].OE_Number;
                    document.getElementById("Text19_2").value = obj.data[0].SalseAgent;
                    document.getElementById("Text20_2").value = obj.data[0].Salse;
                    document.getElementById("Text21_2").value = obj.data[0].Salse_TEL;
                    document.getElementById("Text22_2").value = obj.data[0].SID;
                    document.getElementById("Text23_2").value = obj.data[0].Serial_Number;
                    document.getElementById("Text24_2").value = obj.data[0].License_Host;
                    document.getElementById("Text25_2").value = obj.data[0].Licence_Name;
                    document.getElementById("Text26_2").value = obj.data[0].LAC;
                    document.getElementById("Text27_2").value = obj.data[0].Our_Reference;
                    document.getElementById("Text28_2").value = obj.data[0].Your_Reference;
                    document.getElementById("Text29_2").value = obj.data[0].Auth_File_ID;
                    document.getElementById("Text30_2").value = obj.data[0].Telecomm_ID;
                    document.getElementById("Text31_2").value = obj.data[0].FL;
                    document.getElementById("Text32_2").value = obj.data[0].Group_Name_ID;
                    document.getElementById("Text33_2").value = obj.data[0].SED;
                    document.getElementById("Text34_2").value = obj.data[0].SERVICEITEM;
                    document.getElementById("datetimepicker02_2").value = obj.data[0].Warranty_Date;
                    document.getElementById("Text35_2").value = obj.data[0].Warr_Time;
                    document.getElementById("datetimepicker03_2").value = obj.data[0].Protect_Date;
                    document.getElementById("Text36_2").value = obj.data[0].Prot_Time;
                    document.getElementById("datetimepicker04_2").value = obj.data[0].Receipt_Date;
                    document.getElementById("Text37_2").value = obj.data[0].Receipt_PS;
                    document.getElementById("datetimepicker05_2").value = obj.data[0].Close_Out_Date;
                    document.getElementById("Text38_2").value = obj.data[0].Close_Out_PS;
                    document.getElementById("Text39_2").value = obj.data[0].Account_PS;
                    document.getElementById("Text40_2").value = obj.data[0].Information_PS;
                    document.getElementById("time_06_2").innerHTML = obj.data[0].SetupDate;
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
        }
        //================ 存新客戶資料用===============
        function Safe(Flag) {
            //document.getElementById("btn_update").disabled = true;
            //document.getElementById("btn_new").disabled = true;

            var OE_ID = document.getElementById("OE_ID").innerHTML;
            var Product_Name = document.getElementById("Text1").value;
            var P_ID = document.getElementById("p_id").value;
            var Main_Classified = document.getElementById("Text2").value;
            var Detail_Classified = document.getElementById("Text3").value;
            var Unit_Price = document.getElementById("Text4").value;
            var Work_List = Work_List_array.toString()
            
            $.ajax({
                url: '0030010003.aspx/Safe',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    OE_ID : OE_ID,
                    Product_Name: Product_Name,
                    P_ID: P_ID,
                    Main_Classified : Main_Classified,
                    Detail_Classified : Detail_Classified,
                    Unit_Price: Unit_Price,
                    Work_List: Work_List,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "商品新增成功。") {
                        alert(json.status)
                    }
                    else if (json.status == "商品修改成功") {
                        alert(json.status);
                    }
                    else {
                        alert(json.status);
                    }
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                    window.location.reload()
                },
                error: function () {
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                }
            });
        }

        //================ 新增【使用者權限】===============
        function New(Flag) {
            document.getElementById("btn_update").disabled = true;
            document.getElementById("btn_new").disabled = true;
            var Flag = Flag;
            var PID = document.getElementById("PID").innerHTML;
            var BUSINESSNAME = document.getElementById("business_name").value;
            var BUSINESSID = document.getElementById("business_id").value;

            var ID = document.getElementById("id").value;
            //var BUS_CREATE_DATE = document.getElementById("datetimepicker01").value;
            var APPNAME = document.getElementById("Text1").value;
            var APP_SUBTITLE = document.getElementById("Text2").value;
            var APP_MTEL = document.getElementById("Text3").value;
            var APP_EMAIL = document.getElementById("Text4").value;
            var APPNAME_2 = document.getElementById("Text5").value;
            var APP_SUBTITLE_2 = document.getElementById("Text6").value;
            var APP_MTEL_2 = document.getElementById("Text7").value;
            var APP_EMAIL_2 = document.getElementById("Text8").value;
            var REGISTER_ADDR = document.getElementById("Text9").value;
            var CONTACT_ADDR = document.getElementById("Text10").value;
            var APP_OTEL = document.getElementById("Text11").value;
            var APP_FTEL = document.getElementById("Text12").value;
            var INVOICENAME = document.getElementById("Text13").value;
            var Inads = document.getElementById("Text14").value;
            var HardWare = document.getElementById("Text15").value;
            var SoftwareLoad = document.getElementById("Text16").value;
            var Mail_Type = document.getElementById("Text17").value;
            var OE_Number = document.getElementById("Text18").value;
            var SalseAgent = document.getElementById("Text19").value;
            var Salse = document.getElementById("Text20").value;
            var Salse_TEL = document.getElementById("Text21").value;
            var SID = document.getElementById("Text22").value;
            var Serial_Number = document.getElementById("Text23").value;
            var License_Host = document.getElementById("Text24").value;
            var Licence_Name = document.getElementById("Text25").value;
            var LAC = document.getElementById("Text26").value;
            var Our_Reference = document.getElementById("Text27").value;
            var Your_Reference = document.getElementById("Text28").value;
            var Auth_File_ID = document.getElementById("Text29").value;
            var Telecomm_ID = document.getElementById("Text30").value;
            var FL = document.getElementById("Text31").value;
            var Group_Name_ID = document.getElementById("Text32").value;
            var SED = document.getElementById("Text33").value;
            var SERVICEITEM = document.getElementById("Text34").value;
            var Warranty_Date = document.getElementById("datetimepicker02").value;
            var Warr_Time = document.getElementById("Text35").value;
            var Protect_Date = document.getElementById("datetimepicker03").value;
            var Prot_Time = document.getElementById("Text36").value;
            var Receipt_Date = document.getElementById("datetimepicker04").value;
            var Receipt_PS = document.getElementById("Text37").value;
            var Close_Out_Date = document.getElementById("datetimepicker05").value;
            var Close_Out_PS = document.getElementById("Text38").value;
            var Account_PS = document.getElementById("Text39").value;
            var Information_PS = document.getElementById("Text40").value;
            var UpDateDate = document.getElementById("LoginTime").value;
            //alert(Warranty_Date);
            $.ajax({
                //alert: ("新增完成！"),
                url: '0030010003.aspx/New',
                //url: '0030010003.aspx/Safe2',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    PID: PID,
                    BUSINESSNAME: BUSINESSNAME, BUSINESSID: BUSINESSID,
                    ID: ID,         //BUS_CREATE_DATE: BUS_CREATE_DATE,
                    APPNAME: APPNAME, APP_SUBTITLE: APP_SUBTITLE,
                    APP_MTEL: APP_MTEL, APP_EMAIL: APP_EMAIL,
                    APPNAME_2: APPNAME_2, APP_SUBTITLE_2: APP_SUBTITLE_2,
                    APP_MTEL_2: APP_MTEL_2, APP_EMAIL_2: APP_EMAIL_2,
                    REGISTER_ADDR: REGISTER_ADDR, CONTACT_ADDR: CONTACT_ADDR,
                    APP_OTEL: APP_OTEL, APP_FTEL: APP_FTEL,
                    INVOICENAME: INVOICENAME, Inads: Inads,
                    HardWare: HardWare, SoftwareLoad: SoftwareLoad,
                    Mail_Type: Mail_Type, OE_Number: OE_Number,
                    SalseAgent: SalseAgent, Salse: Salse,
                    Salse_TEL: Salse_TEL, SID: SID,
                    Serial_Number: Serial_Number, License_Host: License_Host,
                    Licence_Name: Licence_Name, LAC: LAC,
                    Our_Reference: Our_Reference, Your_Reference: Your_Reference,
                    Auth_File_ID: Auth_File_ID, Telecomm_ID: Telecomm_ID,
                    FL: FL, Group_Name_ID: Group_Name_ID,
                    SED: SED, SERVICEITEM: SERVICEITEM,
                    Warranty_Date: Warranty_Date, Warr_Time: Warr_Time,
                    Protect_Date: Protect_Date, Prot_Time: Prot_Time,
                    Receipt_Date: Receipt_Date, Receipt_PS: Receipt_PS,
                    Close_Out_Date: Close_Out_Date, Close_Out_PS: Close_Out_PS,
                    Account_PS: Account_PS, Information_PS: Information_PS,
                    UpDateDate: UpDateDate
/*                    Flag: Flag,
                    PNumber: PID,
                    BUSINESSNAME: BUSINESSNAME, BUSINESSID: BUSINESSID,
                    ID: ID, BUS_CREATE_DATE: BUS_CREATE_DATE,
                    APPNAME: APPNAME, APP_SUBTITLE: APP_SUBTITLE,
                    APP_MTEL: APP_MTEL, APP_EMAIL: APP_EMAIL,
                    APPNAME_2: APPNAME_2, APP_SUBTITLE_2: APP_SUBTITLE_2,
                    APP_MTEL_2: APP_MTEL_2, APP_EMAIL_2: APP_EMAIL_2,
                    REGISTER_ADDR: REGISTER_ADDR, CONTACT_ADDR: CONTACT_ADDR,
                    APP_OTEL: APP_OTEL, APP_FTEL: APP_FTEL,
                    INVOICENAME: Text13, Inads: Text14,
                    HardWare: Text15, SoftwareLoad: Text16,
                    Mail_Type: Text17, OE_Number: Text18,
                    SalseAgent: Text19, Salse: Text20,
                    Salse_TEL: Text21, SID: Text22,
                    Serial_Number: Text23, License_Host: Text24,
                    Licence_Name: Text25, LAC: Text26,
                    Our_Reference: Text27, Your_Reference: Text28,
                    Auth_File_ID: Text29, Telecomm_ID: Text30,
                    FL: Text31, Group_Name_ID: Text32,
                    SED: Text33, SERVICEITEM: Text34,
                    Warranty_Date: datetimepicker02, Warr_Time: Text35,
                    Protect_Date: datetimepicker03, Prot_Time: Text36,
                    Receipt_Date: datetimepicker04, Receipt_PS: Text37,
                    Close_Out_Date: datetimepicker05, Close_Out_PS: Text38,
                    Account_PS: Text39, Information_PS: Text40,
                    UpDateDate: LoginTime,
                    SetupDate: LoginTime        //*/
                    // 共讀取 49 個

                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert("新增完成！")
                        bindTable();
                    }
                    else if (json.status == "update") {
                        alert("修改完成！");
                        bindTable();
                    }
                    else {
                        alert(json.status);
                    }
                    window.location.reload()
                },
                error: function () {
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                }
            });
        }

        function Safe_Main_Detail() {
            let Main = $('#txt_main').val()
            let Detail = $('#txt_detail').val()

            if (Main == '') {
                alert('請填選主分類。')
                return
            }
            if (Detail == '') {
                alert('請填選子分類。')
                return
            }

            $.ajax({
                url: '0030010003.aspx/Safe_Main_Detail',
                type: 'POST',
                data: JSON.stringify({
                    Main: Main,
                    Detail: Detail,         //Detail: Detail,                    
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    alert(json.status)
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
            $('.chosen-single').css({ 'background-color': '#ffffbb' });
        }

        //==================
    </script>
    <style>
        body
        {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 18px;
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

        #data2 td:nth-child(6), #data2 td:nth-child(5), #data2 td:nth-child(4),
        #data2 td:nth-child(3), #data2 td:nth-child(2), #data2 td:nth-child(1),
        #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5)
        {
            text-align: center;
        }
    </style>

    <!-- ====== 母資料新增修改表 ====== -->
    <div class="modal fade" id="newModal" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1600px;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="title_modal"></label>
                    </strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== 表格 -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>商品資料<label id="OE_ID"></label></strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>

                            <!--
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>PID</strong>
                                </th>      
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip"  style="width: 100%">
                                        <label id="PID" name="PID" ></label> 
                                                                  
                                    </div>
                                </th>                          
                            </tr>   -->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>商品名稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，不能超過１００個字元">
                                        <textarea id="Text1" name="Text1" class="form-control" cols="45" rows="3" placeholder="商品名稱" 
                                            maxlength="100" onkeyup="cs(this);" style="resize: none;width:100%" title="100 英文,數字 到 50 中文之間 "></textarea>
                                        <!--<input type="text" id="Text1" name="Text1" class="form-control" placeholder="商品名稱"
                                            maxlength="30" style="Font-Size: 18px; background-color: #ffffbb" title="必填，不能超過３０個字" />-->
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>主分類</strong>
                                </th>
                                <th style="text-align: left; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <select id="Text2" name="Text2" class="form-control-case" style="background-color:#ffffbb;width:70%" onchange="Detail_List()">
                                            <!--<option value="">請選擇主分類</option>    -->
                                        </select>
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>子分類</strong>
                                </th>
                                <th style="text-align: left; width: 35%">
                                    <div data-toggle="tooltip" title="">
                                        <select id="Text3" name="Text3" class="form-control-case" style="background-color:#ffffbb;width:70%" onchange="">
                                            <!--<option value="">請選擇子分類</option>>    -->
                                        </select>
                                        <button type='button' id='add' class='btn btn-primary' data-toggle='modal' data-target='#newModal2'>
                                        <span class='glyphicon glyphicon-plus'>新增主/子分類</span></button>
                                    </div>
                                </th>                              
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>工作事項</strong>
                                </th>
                                <th style="text-align: left; width: 35%">
                                    <div data-toggle="tooltip" title="必填，不能超過１００個字元">
                                        <input type="text" id="Text5" name="Text5" class="form-control" placeholder="工作事項" style="background-color: #ffffbb;width:70%" />
                                        <button type='button' id='Add_Work' class='btn btn-primary'><span class='glyphicon glyphicon-plus'>新增</span></button>
                                    </div>
                                    <div>
                                        <input type="number" id="Work_li_Count" value="0" style="display:none"/>
                                        <ol id="Work_List"></ol>
                                    </div>
                                </th>

                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>商品編號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過２０個字元，並且只能填英文或數字">
                                        <input type="text" id="p_id" name="Text4" class="form-control" placeholder="商品編號"/>
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>商品單價</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="商品單價">
                                        <input type="text" id="Text4" name="Text4" class="form-control" placeholder="商品單價" style="background-color: #ffffbb;" />
                                    </div>
                                </th>  
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 30%; height: 55px;"></th>
                                <th style="text-align: center; width: 100%; height: 65px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="Safe('0')"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="Safe('1')"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
                                    <!--New(0) New(1) 換 Safe -->
                                </th>
                                <th style="text-align: right; width: 35%; height: 65px;" colspan="2">  
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span>&nbsp;取消</button>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                    <!-- ========================================== -->
                </div>
            </div>


            <!-- =========== Modal content =========== -->

        </div>

        <script>
            $.datetimepicker.setLocale('ch');
            $('#datetimepicker01').datetimepicker({
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
    <!--===================================================-->

    <!--====================客戶資料維護========================-->
    <div class="table-responsive" style="width: 95%; margin: 10px 20px;display:inline-block">
        <h2><strong>商品維護&nbsp; &nbsp;
                <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#newModal" style="Font-Size: 20px;" onclick="Xin_De()">
                    <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增商品資料</button>
        </strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center; width: 10%;">號碼</th>
                    <th style="text-align: center; width: 20%;">商品名稱</th>
                    <th style="text-align: center; width: 12.5%;">商品編號</th>
                    <th style="text-align: center; width: 12.5%">主分類</th>
                    <th style="text-align: center; width: 12.5%">子分類</th>
                    <th style="text-align: center; width: 12.5%">單價</th>
                    <th style="text-align: center; width: 10%">修改</th>
                    <th style="text-align: center; width: 10%">刪除</th>
                    
                </tr>
            </thead>
        </table>
    </div>
    <div class="modal fade" id="newModal2" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1600px;">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="title">新增主/子分類</label>
                    </strong></h2>
                </div>
                <div class="modal-body">
                    <!-- ========================================== 表格 -->
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>分類資料<label id="oe_t_id"></label></strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>

                            <!--
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>PID</strong>
                                </th>      
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip"  style="width: 100%">
                                        <label id="PID" name="PID" ></label> 
                                                                  
                                    </div>
                                </th>                          
                            </tr>   -->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>主分類</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，不能超過２０個字">
                                        <input type="text" id="txt_main" name="business_name" class="form-control" placeholder="主分類"
                                            maxlength="20" style="Font-Size: 18px; background-color: #ffffbb " title="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>子分類</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０個字">
                                        <input type="text" id="txt_detail" name="business_id" class="form-control" placeholder="新增子分類"
                                            maxlength="20" style="Font-Size: 18px; " title=""/>
                                    </div>
                                </th>
                            </tr>                            
                            
                            <tr>
                                <th style="text-align: center; width: 30%; height: 55px;"></th>
                                <th style="text-align: center; width: 35%; height: 65px;" colspan="2">
                                    <button id="Add_Main_Detail" type="button" class="btn btn-success btn-lg"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    
                                </th>
                                <th style="text-align: right;">
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span>&nbsp;取消</button>
                                </th>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    <!--====================子公司清單=======================

    <div class="table-responsive" style="text-align: center; width: 95%; margin: 10px 20px">
        <h2><strong>子公司清單&nbsp; &nbsp;</strong></h2>
        <table id="Table1" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center; width: 10%;">子公司編號</th>
                    <th style="text-align: center; width: 20%">客戶名稱</th>
                    <th style="text-align: center; width: 10%">子公司名稱</th>
                    <th style="text-align: center; width: 20%">備註</th>
                    <th style="text-align: center; width: 15%">建檔日期</th>
                    <!--<th style="text-align: center;">異動者</th>
                    <th style="text-align: center; width: 15%">異動日期</th>
                    <!--<th style="text-align: center; width: 10%">修改</th>
                </tr>
            </thead>
        </table>
    </div>-->


</asp:Content>
