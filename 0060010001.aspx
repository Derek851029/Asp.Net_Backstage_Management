<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0060010001.aspx.cs" Inherits="_0060010001" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script type="text/javascript">
        var image_name_array = [];
        var image_array = [];
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
            bindTable();
            bindTable_2();
            ShowTime();
            List_Agent(0); //抓工程師下拉
            Listener_event()
        });

        function Listener_event() {
            $('#file').change(function () {
                $('#file_Name').html('')
                image_name_array = []
                image_array = []
                //console.log($(this).get(0).files)
                $.map($(this).get(0).files, function (file, index) {
                    let type = file.type.split('/')
                    type = type[0]
                    if (type != 'image') {
                        alert("請上傳圖片類型。");
                        $('#file').val('')
                        $('#file_Name').html('')
                        return false;
                    }
                    else {
                        $('#file_Name').append(
                            '<li id="li_'+index+'"><button type="button" id="view_' + index + '" style="color:#337ab7;background-color:white;border:none;" data-toggle="modal" data-target="#dialog1">' + file.name + '</button>'+
                            '<button type="button" id = "delete_' + index +'" style = "color:red;background-color:white;border:none;"> 刪除</button ></li >'
                        )
                        image_name_array.push(file.name)

                        if (file) {
                            var reader = new FileReader();
                            reader.readAsDataURL(file);
                            reader.onload = function (e) {
                                var urlData = reader.result;
                                image_array.push(urlData)
                            };
                        }
                    }
                });
                console.log(image_array)
            })

            $('#file_Name').on('click', 'button[id^="view_"]', function () {
                $('#img').html('')
                let index = $(this).attr('id').split('_')[1]
                //let file = $('#file')[0].files
                $('#img').append('<img src="' + image_array[index] + '" width=750 heigth:600></img>')
            })

            $('#file_Name').on('click', 'button[id^="delete_"]', function () {
                let file = $('#file').val()
                let index = $(this).attr('id').split('_')[1]

                file = file.split(',')
                file.splice(index, 1)

                $('#li_' + index + '').remove()
                image_name_array.splice(index, 1)
                image_array.splice(index, 1)
                console.log(image_name_array)
                console.log(image_array)
            })
        }

        function bindTable() {
            $.ajax({
                url: '0060010001.aspx/GetPartnerList',
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
                                { data: "PID" },
                                { data: "BUSINESSNAME" },
                                { data: "SalseAgent" },
                                { data: "Warr_Time" },
                                { data: "Prot_Time" },
                                { data: "CycleTime" },
                                /*{
                                    data: "Flag", render: function (data, type, row, meta) {
                                        var checked = 'checked/>'
                                        if (data == '0') {
                                            checked = '/>'
                                        }
                                        return "<div class='checkbox'><label>" +
                                            "<input id='Flag' type='checkbox' style='width: 30px; height: 30px;' " + checked +
                                            "</label></div>";
                                    }
                                },*/
                                {
                                    data: "SYSID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit' class='btn btn-primary btn-lg' " +
                                            "data-toggle='modal' data-target='#newModal' >" +
                                            "<span class='glyphicon glyphicon-pencil'>" +
                                            "</span>&nbsp;修改</button>";
                                    }
                                },
                                /*{
                                    data: "PID", render: function (data, type, row, meta) {
                                        return "<button type='button' id='edit02' class='btn btn-info btn-lg'>" +
                                "<span class='glyphicon glyphicon-search'></span>&nbsp;查看</button>";
                                    }
                                },//*/
                                {
                                    data: "PID", render: function (data, type, row, meta) {
                                        return "<button type='button' class='btn btn-danger btn-lg' id='delete'>" +
                                            "<span class='glyphicon glyphicon-remove'>" +
                                            "</span>&nbsp;刪除</button>";

                                    }
                                }
                                
                        ]
                    });
                    $('#data tbody').unbind('click').
                       on('click', '#edit02', function () {
                           var table = $('#data').DataTable();
                           var PID = table.row($(this).parents('tr')).data().PID;
                           //alert(PID + '查看子公司');
                           URL(PID);                           
                       }).on('click', '#edit', function () {
                           var table = $('#data').DataTable();
                           var PID = table.row($(this).parents('tr')).data().PID;
                           //alert(PID);
                           Load_Modal(PID);
                           List_Eva(PID);
                       }).on('click', '#delete', function () {
                           var table = $('#data').DataTable();
                           var PID = table.row($(this).parents('tr')).data().PID;
                           Delete(PID);
                       })
                       /*.on('click', '#Flag', function () {
                           var table = $('#data').DataTable();
                           var id = table.row($(this).parents('tr')).data().PID;
                           var flag = table.row($(this).parents('tr')).data().Flag;
                           Open_Flag(id, flag);
                       })*/
                    ;
                }
            });
        }
        function Delete(PID) {
            if (confirm("確定要刪除嗎？")) {
                $.ajax({
                    url: '0060010001.aspx/Delete',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ PID: PID }),
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
                url: '0060010001.aspx/URL',
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
        function URL2() {
            window.location.href = "/0060010001.aspx";
        }

        function bindTable_2(PID) {            // 子公司列表
            $.ajax({
                url: '0060010001.aspx/GetSubsidiaryList',
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
            document.getElementById('LoginTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
            //document.getElementById('EstimatedFinishTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
        }

        function List_Agent(Team) {
            var $select_elem = $("#New_Agent");
            $.ajax({
                url: '0060010001.aspx/List_Agent',
                type: 'POST',
                data: JSON.stringify({ Team: Team }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇工程師…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_ID + "'>" + obj.Agent_Name + "</option>");
                    });
                }
            });
        }

        function List_PROGLIST(ROLE_ID) {
            $.ajax({
                url: '0060010001.aspx/List_PROGLIST',
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
                //url: '0060010001.aspx/Check_Menu',
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
            Load_Modal("0");
            //alert('新增');
        }

        function Load_Modal(PID) {                                          // 讀資料
            //alert(PID);
            if (PID == 0) {
                //alert('檢查中1');
                document.getElementById("btn_new").style.display = "";
                document.getElementById("btn_update").style.display = "none";
                document.getElementById("title_modal").innerHTML = '客戶資料（新增）';

                document.getElementById("PID").innerHTML = "";
                document.getElementById("business_name").value = "";
                document.getElementById("business_id").value = "";
                document.getElementById("id").value = "";
                document.getElementById("Text1").value = "";
                //document.getElementById("Text2").value = "";
                document.getElementById("Text3").value = "";
                document.getElementById("Text4").value = "";
                document.getElementById("Text5").value = "";
                //document.getElementById("Text6").value = "";
                document.getElementById("Text7").value = "";
                document.getElementById("Text8").value = "";
                document.getElementById("Text9").value = "";
                document.getElementById("New_CycleTime").value = "";
                document.getElementById("Text10").value = "";
                document.getElementById("Text11").value = "";
                document.getElementById("Text12").value = "";
                document.getElementById("Text13").value = "";
                document.getElementById("Text14").value = "";
                document.getElementById("Text15").value = "";
                document.getElementById("Text16").value = "";
                document.getElementById("Text17").value = "";
                //document.getElementById("Text18").value = "";
                document.getElementById("Text19").value = "";
                document.getElementById("Text20").value = "";
                document.getElementById("Text21").value = "";
                document.getElementById("Text22").value = "";
                document.getElementById("Text23").value = "";
                document.getElementById("Text24").value = "";
                //document.getElementById("Text25").value = "";
                document.getElementById("Text26").value = "";
                //document.getElementById("Text27").value = "";
                //document.getElementById("Text28").value = "";
                //document.getElementById("Text29").value = "";
                style('Text30', '');
                document.getElementById("T_ID").value = "";
                document.getElementById("Text31").value = "";
                document.getElementById("Text32").value = "";
                //document.getElementById("Text33").value = "";
                document.getElementById("Text34").value = "";
                document.getElementById("datetimepicker02").value = "";
                document.getElementById("Text35").value = "";
                document.getElementById("datetimepicker03").value = "";
                document.getElementById("Text36").value = "";
                //document.getElementById("datetimepicker04").value = "";
                //document.getElementById("Text37").value = "";
                document.getElementById("datetimepicker05").value = "";
                document.getElementById("Text38").value = "";
                document.getElementById("Text39").value = "";
                document.getElementById("Text40").value = "";
                document.getElementById("time_06").innerHTML = "";  //*/

                document.getElementById("Table2").style.display = "none";
                document.getElementById("Add_Eva").style.display = "none";
                document.getElementById("Check_Saturday").checked = "checked";
                document.getElementById("Check_Sunday").checked = "checked";
                $('#file').val('')
                $('#file_Name').html('')
                image_array = []
                image_name_array = []
            } else {
                //alert('檢查中2');
                //document.getElementById("txt_ROLE_ID").disabled = true;
                document.getElementById("btn_update").style.display = "";                               //顯示修改鈕
                document.getElementById("btn_new").style.display = "none";                          //隱藏新增鈕
                document.getElementById("title_modal").innerHTML = '客戶資料（修改）';
                document.getElementById("Table2").style.display = "";
                document.getElementById("Add_Eva").style.display = "";
                $('#file').val('')
                $('#file_Name').html('')
                image_array = []
                image_name_array = []
                Load_Data(PID);
            }   //else 結束
        }

        // 預定修改執行部分
        function Load_Data(PID) {
            //alert('Load_Data');
            document.getElementById("PID").innerHTML = PID;
            $.ajax({
                url: '0060010001.aspx/Load_Data',
                type: 'POST',
                data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    //document.getElementById("PID").innerHTML = obj.data[0].PID;   //沒用到要遮蔽
                    document.getElementById("business_name").value = obj.data[0].BUSINESSNAME;
                    document.getElementById("business_id").value = obj.data[0].BUSINESSID;
                    document.getElementById("id").value = obj.data[0].ID;
                    //document.getElementById('LoginTime').value = y + "/" + mon + "/" + d + " " + h + ":" + m;
                    //document.getElementById("datetimepicker01").value = obj.data[0].BUS_CREATE_DATE;
                    document.getElementById("Text1").value = obj.data[0].APPNAME;
                    //document.getElementById("Text2").value = obj.data[0].APP_SUBTITLE;
                    document.getElementById("Text3").value = obj.data[0].APP_MTEL;
                    document.getElementById("Text4").value = obj.data[0].APP_EMAIL;
                    document.getElementById("Text5").value = obj.data[0].APPNAME_2;
                    //document.getElementById("Text6").value = obj.data[0].APP_SUBTITLE_2;
                    document.getElementById("Text7").value = obj.data[0].APP_MTEL_2;
                    document.getElementById("Text8").value = obj.data[0].APP_EMAIL_2;
                    document.getElementById("Text9").value = obj.data[0].REGISTER_ADDR;;
                    document.getElementById("New_CycleTime").value = obj.data[0].CycleTime;
                    document.getElementById("Text10").value = obj.data[0].CONTACT_ADDR;
                    document.getElementById("Text11").value = obj.data[0].APP_OTEL;
                    document.getElementById("Text12").value = obj.data[0].APP_FTEL;
                    document.getElementById("Text13").value = obj.data[0].INVOICENAME;
                    document.getElementById("Text14").value = obj.data[0].Inads;
                    document.getElementById("Text15").value = obj.data[0].HardWare;
                    document.getElementById("Text16").value = obj.data[0].SoftwareLoad;
                    document.getElementById("Text17").value = obj.data[0].Mail_Type;
                    //document.getElementById("Text18").value = obj.data[0].OE_Number;
                    document.getElementById("Text19").value = obj.data[0].SalseAgent;
                    document.getElementById("Text20").value = obj.data[0].Salse;
                    document.getElementById("Text21").value = obj.data[0].Salse_TEL;
                    document.getElementById("Text22").value = obj.data[0].SID;
                    document.getElementById("Text23").value = obj.data[0].Serial_Number;
                    document.getElementById("Text24").value = obj.data[0].License_Host;
                    //document.getElementById("Text25").value = obj.data[0].Licence_Name;
                    document.getElementById("Text26").value = obj.data[0].LAC;
                    //document.getElementById("Text27").value = obj.data[0].Our_Reference;
                    //document.getElementById("Text28").value = obj.data[0].Your_Reference;
                    //document.getElementById("Text29").value = obj.data[0].Auth_File_ID;
                    if (obj.data[0].Telecomm_ID != "中華電信" && obj.data[0].Telecomm_ID != "遠傳" && obj.data[0].Telecomm_ID != "德瑪") {
                        style('Text30', '其他');
                        document.getElementById("T_ID").value = obj.data[0].Telecomm_ID;
                    }
                    else {
                        style('Text30', obj.data[0].Telecomm_ID);
                        document.getElementById("T_ID").value = "";
                    }                        
                    document.getElementById("Text31").value = obj.data[0].FL;
                    document.getElementById("Text32").value = obj.data[0].Group_Name_ID;
                    //document.getElementById("Text33").value = obj.data[0].SED;
                    document.getElementById("Text34").value = obj.data[0].SERVICEITEM;
                    document.getElementById("datetimepicker02").value = obj.data[0].Warranty_Date;
                    document.getElementById("Text35").value = obj.data[0].Warr_Time;
                    document.getElementById("datetimepicker03").value = obj.data[0].Protect_Date;
                    document.getElementById("Text36").value = obj.data[0].Prot_Time;
                    //document.getElementById("datetimepicker04").value = obj.data[0].Receipt_Date;
                    //document.getElementById("Text37").value = obj.data[0].Receipt_PS;
                    document.getElementById("datetimepicker05").value = obj.data[0].Close_Out_Date;
                    document.getElementById("Text38").value = obj.data[0].Close_Out_PS;
                    document.getElementById("Text39").value = obj.data[0].Account_PS;
                    document.getElementById("Text40").value = obj.data[0].Information_PS;
                    document.getElementById("time_06").innerHTML = obj.data[0].SetupDate;
                    //alert("Saturday=" + obj.data[0].Check_Saturday + "  Sunday=" + obj.data[0].Check_Sunday);
                    document.getElementById("Check_Saturday").checked = obj.data[0].Check_Saturday;
                    document.getElementById("Check_Sunday").checked = obj.data[0].Check_Sunday;

                    if (obj.data[0].Card_Name != '' && obj.data[0].Card_Name != null) {
                        image_name_array = obj.data[0].Card_Name.split(',')
                        let Card_Base64 = obj.data[0].Card_Base64.split(',')

                        $.each(Card_Base64, function (index, value) {
                            let location = value.indexOf('base64')
                            if (location != -1) {
                                let urlData = value + ',' + Card_Base64[index + 1]
                                image_array.push(urlData)
                            }
                            else {
                                return
                            }
                        })

                        $.each(image_name_array, function (index, value) {
                            $('#file_Name').append(
                                '<li id="li_' + index + '"><button type="button" id="view_' + index + '" style="color:#337ab7;background-color:white;border:none;" data-toggle="modal" data-target="#dialog1">' + value + '</button>' +
                                '<button type="button" id = "delete_' + index + '" style = "color:red;background-color:white;border:none;"> 刪除</button ></li >'
                            )
                        })
                    }
                }
            });
            $("#Div_Loading").modal('hide');        // 功能??
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
                url: '0060010001.aspx/Load_Data_02',    // 還沒弄Load_Data_02
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
            document.getElementById("btn_update").disabled = true;
            document.getElementById("btn_new").disabled = true;

            var Flag = Flag;
            var BUSINESSNAME = document.getElementById("business_name").value;
            var BUSINESSID = document.getElementById("business_id").value;
            var ID = document.getElementById("id").value;
            //var BUS_CREATE_DATE = document.getElementById("datetimepicker01").value;
            var APPNAME = document.getElementById("Text1").value;
            //var APP_SUBTITLE = document.getElementById("Text2").value;
            var APP_MTEL = document.getElementById("Text3").value;
            var APP_EMAIL = document.getElementById("Text4").value;
            var APPNAME_2 = document.getElementById("Text5").value;
            //var APP_SUBTITLE_2 = document.getElementById("Text6").value;
            var APP_MTEL_2 = document.getElementById("Text7").value;
            var APP_EMAIL_2 = document.getElementById("Text8").value;
            var REGISTER_ADDR = document.getElementById("Text9").value;;
            var CycleTime = document.getElementById("New_CycleTime").value;
            var CONTACT_ADDR = document.getElementById("Text10").value;
            var APP_OTEL = document.getElementById("Text11").value;
            var APP_FTEL = document.getElementById("Text12").value;
            var INVOICENAME = document.getElementById("Text13").value;
            var Inads = document.getElementById("Text14").value;
            var HardWare = document.getElementById("Text15").value;
            var SoftwareLoad = document.getElementById("Text16").value;
            var Mail_Type = document.getElementById("Text17").value;
            //var OE_Number = document.getElementById("Text18").value;
            var SalseAgent = document.getElementById("Text19").value;
            var Salse = document.getElementById("Text20").value;
            var Salse_TEL = document.getElementById("Text21").value;
            var SID = document.getElementById("Text22").value;
            var Serial_Number = document.getElementById("Text23").value;
            var License_Host = document.getElementById("Text24").value;
            //var Licence_Name = document.getElementById("Text25").value;
            var LAC = document.getElementById("Text26").value;
            //var Our_Reference = document.getElementById("Text27").value;
            //var Your_Reference = document.getElementById("Text28").value;
            //var Auth_File_ID = document.getElementById("Text29").value;
            var Telecomm_ID = document.getElementById("Text30").value;
            if (Telecomm_ID == "其他")
                Telecomm_ID = document.getElementById("T_ID").value;
            var FL = document.getElementById("Text31").value;
            var Group_Name_ID = document.getElementById("Text32").value;
            //var SED = document.getElementById("Text33").value;
            var SERVICEITEM = document.getElementById("Text34").value;
            var Warranty_Date = document.getElementById("datetimepicker02").value;
            var Warr_Time = document.getElementById("Text35").value;
            var Protect_Date = document.getElementById("datetimepicker03").value;
            var Prot_Time = document.getElementById("Text36").value;
            //var Receipt_Date = document.getElementById("datetimepicker04").value;
            //var Receipt_PS = document.getElementById("Text37").value;
            var Close_Out_Date = document.getElementById("datetimepicker05").value;
            var Close_Out_PS = document.getElementById("Text38").value;
            var Account_PS = document.getElementById("Text39").value;
            var Information_PS = document.getElementById("Text40").value;
            var UpDateDate = document.getElementById("LoginTime").value;
            var SetupDate = document.getElementById("LoginTime").value;
            var C_Saturday = document.getElementById("Check_Saturday").checked;
            var C_Sunday = document.getElementById("Check_Sunday").checked;
            let Card_Name = image_name_array.toString()
            let Card_Base64 = image_array.toString()
            //alert("Save Saturday=" + C_Saturday + "  Sunday=" + C_Sunday);
            //alert(PID);
            $.ajax({
                url: '0060010001.aspx/Safe',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag, BUSINESSNAME: BUSINESSNAME, BUSINESSID: BUSINESSID, ID: ID, APPNAME: APPNAME, //BUS_CREATE_DATE: BUS_CREATE_DATE, APP_SUBTITLE: APP_SUBTITLE, APP_SUBTITLE_2: APP_SUBTITLE_2,                     
                    APP_MTEL: APP_MTEL, APP_EMAIL: APP_EMAIL, APPNAME_2: APPNAME_2, APP_MTEL_2: APP_MTEL_2, APP_EMAIL_2: APP_EMAIL_2,
                    REGISTER_ADDR: REGISTER_ADDR, CONTACT_ADDR: CONTACT_ADDR, CycleTime: CycleTime, APP_OTEL: APP_OTEL, APP_FTEL: APP_FTEL,                    
                    INVOICENAME: INVOICENAME, Inads: Inads, HardWare: HardWare, SoftwareLoad: SoftwareLoad, Mail_Type: Mail_Type, //OE_Number: OE_Number,
                    SalseAgent: SalseAgent, Salse: Salse, Salse_TEL: Salse_TEL, SID: SID, Serial_Number: Serial_Number,
                    License_Host: License_Host, LAC: LAC, Telecomm_ID: Telecomm_ID, FL: FL, Group_Name_ID: Group_Name_ID,
                    SERVICEITEM: SERVICEITEM, Warranty_Date: Warranty_Date, Warr_Time: Warr_Time ,Protect_Date: Protect_Date, Prot_Time: Prot_Time,
                    Close_Out_Date: Close_Out_Date, Close_Out_PS: Close_Out_PS, Account_PS: Account_PS, Information_PS: Information_PS, UpDateDate: UpDateDate,
                    SetupDate: SetupDate, C_Saturday: C_Saturday, C_Sunday: C_Sunday, Card_Name: Card_Name, Card_Base64: Card_Base64
                    //Licence_Name: Licence_Name, Our_Reference: Our_Reference, Your_Reference: Your_Reference,Auth_File_ID: Auth_File_ID, SED: SED, Receipt_Date: Receipt_Date, Receipt_PS: Receipt_PS,
                    // 共讀取 41 個 含Flag

                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert("新增完成！")
                        window.location.reload()
                        //$("#newModal").modal('hide');
                    }
                    else if (json.status == "update") {
                        alert("修改完成！");
                        $("#newModal").modal('hide');
                        window.location.reload()
                    }
                    else {
                        alert(json.status);
                    }
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
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
            //var APP_SUBTITLE = document.getElementById("Text2").value;
            var APP_MTEL = document.getElementById("Text3").value;
            var APP_EMAIL = document.getElementById("Text4").value;
            var APPNAME_2 = document.getElementById("Text5").value;
            //var APP_SUBTITLE_2 = document.getElementById("Text6").value;
            var APP_MTEL_2 = document.getElementById("Text7").value;
            var APP_EMAIL_2 = document.getElementById("Text8").value;
            var REGISTER_ADDR = document.getElementById("Text9").value;
            var CycleTime = document.getElementById("New_CycleTime").value;
            var CONTACT_ADDR = document.getElementById("Text10").value;
            var APP_OTEL = document.getElementById("Text11").value;
            var APP_FTEL = document.getElementById("Text12").value;
            var INVOICENAME = document.getElementById("Text13").value;
            var Inads = document.getElementById("Text14").value;
            var HardWare = document.getElementById("Text15").value;
            var SoftwareLoad = document.getElementById("Text16").value;
            var Mail_Type = document.getElementById("Text17").value;
            //var OE_Number = document.getElementById("Text18").value;
            var SalseAgent = document.getElementById("Text19").value;
            var Salse = document.getElementById("Text20").value;
            var Salse_TEL = document.getElementById("Text21").value;
            var SID = document.getElementById("Text22").value;
            var Serial_Number = document.getElementById("Text23").value;
            var License_Host = document.getElementById("Text24").value;
            //var Licence_Name = document.getElementById("Text25").value;
            var LAC = document.getElementById("Text26").value;
            //var Our_Reference = document.getElementById("Text27").value;
            //var Your_Reference = document.getElementById("Text28").value;
            //var Auth_File_ID = document.getElementById("Text29").value;
            var Telecomm_ID = document.getElementById("Text30").value;
            if (Telecomm_ID == "其他")
                Telecomm_ID = document.getElementById("T_ID").value;
            var FL = document.getElementById("Text31").value;
            var Group_Name_ID = document.getElementById("Text32").value;
            //var SED = document.getElementById("Text33").value;
            var SERVICEITEM = document.getElementById("Text34").value;
            var Warranty_Date = document.getElementById("datetimepicker02").value;
            var Warr_Time = document.getElementById("Text35").value;
            var Protect_Date = document.getElementById("datetimepicker03").value;
            var Prot_Time = document.getElementById("Text36").value;
            //var Receipt_Date = document.getElementById("datetimepicker04").value;
            //var Receipt_PS = document.getElementById("Text37").value;
            var Close_Out_Date = document.getElementById("datetimepicker05").value;
            var Close_Out_PS = document.getElementById("Text38").value;
            var Account_PS = document.getElementById("Text39").value;
            var Information_PS = document.getElementById("Text40").value;
            var UpDateDate = document.getElementById("LoginTime").value;
            var C_Saturday = document.getElementById("Check_Saturday").checked;
            var C_Sunday = document.getElementById("Check_Sunday").checked;
            //alert("Update Saturday=" + C_Saturday + "  Sunday=" + C_Sunday);
            //alert(Warranty_Date);
            let Card_Name = image_name_array.toString()
            let Card_Base64 = image_array.toString()
            $.ajax({
                //alert: ("新增完成！"),
                url: '0060010001.aspx/New',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag, PID: PID, BUSINESSNAME: BUSINESSNAME, BUSINESSID: BUSINESSID, ID: ID,         //BUS_CREATE_DATE: BUS_CREATE_DATE,
                    APPNAME: APPNAME, APP_MTEL: APP_MTEL, APP_EMAIL: APP_EMAIL, APPNAME_2: APPNAME_2,  APP_MTEL_2: APP_MTEL_2,
                    APP_EMAIL_2: APP_EMAIL_2, REGISTER_ADDR: REGISTER_ADDR, CycleTime: CycleTime, CONTACT_ADDR: CONTACT_ADDR, APP_OTEL: APP_OTEL,
                    APP_FTEL: APP_FTEL, INVOICENAME: INVOICENAME, Inads: Inads, HardWare: HardWare, SoftwareLoad: SoftwareLoad,
                    Mail_Type: Mail_Type, SalseAgent: SalseAgent, Salse: Salse, Salse_TEL: Salse_TEL, SID: SID,
                    Serial_Number: Serial_Number, License_Host: License_Host, LAC: LAC, Telecomm_ID: Telecomm_ID, FL: FL, 
                      //Licence_Name: Licence_Name, OE_Number: OE_Number,//APP_SUBTITLE_2: APP_SUBTITLE_2,APP_SUBTITLE: APP_SUBTITLE,
                    //Our_Reference: Our_Reference, Your_Reference: Your_Reference,Auth_File_ID: Auth_File_ID, SED: SED,                     
                    Group_Name_ID: Group_Name_ID, SERVICEITEM: SERVICEITEM, Warranty_Date: Warranty_Date, Warr_Time: Warr_Time, Protect_Date: Protect_Date, 
                    Prot_Time: Prot_Time, Close_Out_Date: Close_Out_Date, Close_Out_PS: Close_Out_PS, Account_PS: Account_PS, Information_PS: Information_PS,
                    //Receipt_Date: Receipt_Date, Receipt_PS: Receipt_PS,    
                    UpDateDate: UpDateDate, C_Saturday: C_Saturday, C_Sunday: C_Sunday, Card_Base64: Card_Base64, Card_Name: Card_Name
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
                        window.location.reload()
                        //bindTable();
                        //List_Eva(PID)
                    }
                    else {
                        alert(json.status);
                    }
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
                },
                error: function () {
                    document.getElementById("btn_update").disabled = false;
                    document.getElementById("btn_new").disabled = false;
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
            //$('.chosen-single').css({ 'background-color': '#ffffbb' });
        }
        
        //==================    新增與修改 Upload   參考用
        function Btn_New_Click(Flag) {
            document.getElementById("Btn_New").disabled = true;
            $("#Div_Loading").modal();

            var PostCode = $("#hid_PostCode").val();
            var Location = document.getElementById("txt_Location").innerHTML;  //地址
            var Service_ID = document.getElementById("DropServiceName").value;  //服務內容
            var time_01 = document.getElementById("datetimepicker01").value;    //預定起始時間
            var time_02 = document.getElementById("datetimepicker02").value;    //預定終止時間
            var LocationStart = document.getElementById("LocationStart").value;  //行程起點 
            var LocationEnd = document.getElementById("LocationEnd").value;     //行程終點
            var CarSeat = document.getElementById("txt_CarSeat").value;                //搭車人數
            var ContactName = document.getElementById("ContactName").value;    //聯絡人
            var ContactPhone2 = document.getElementById("Agent_Phone_2").value;  //手機簡碼
            var ContactPhone3 = document.getElementById("Agent_Phone_3").value;  //手機號碼
            var Contact_Co_TEL = document.getElementById("Agent_Co_TEL").value; //公司電話
            var HospitalName = document.getElementById("HospitalName").value;   //醫療院所
            var HospitalClass = document.getElementById("HospitalClass").value;       //就醫類型
            var Question = document.getElementById("Question").value;                       //狀況說明

            $.ajax({
                url: '0030010099.aspx/Check_Form',
                type: 'POST',
                data: JSON.stringify({
                    Flag: Flag,
                    Service_ID: Service_ID,
                    Time_01: time_01,
                    Time_02: time_02,
                    PostCode: PostCode,
                    Location: Location,
                    LocationStart: LocationStart,
                    LocationEnd: LocationEnd,
                    CarSeat: CarSeat,
                    ContactName: ContactName,
                    ContactPhone2: ContactPhone2,
                    ContactPhone3: ContactPhone3,
                    Contact_Co_TEL: Contact_Co_TEL,
                    Hospital: HospitalName,
                    HospitalClass: HospitalClass,
                    Question: Question
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d.toString());
                    if (json.status == "new") {
                        alert('新增完成');
                        window.location.href = "/0030010000/0030010002.aspx";
                    }
                    else if (json.status == "update") {
                        alert('修改完成');
                        window.location.href = "/0030010000/0030010002.aspx";
                    }
                    else {
                        alert(json.status);
                    }
                    $("#Div_Loading").modal('hide');
                    document.getElementById("Btn_New").disabled = false;
                }
            });
        };

        function List_Eva(PID) {  //列出該公司的維護資料
            $.ajax({
                url: '0060010001.aspx/List_Eva',
                type: 'POST',
                data: JSON.stringify({
                    PID: PID
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    var table = $('#Table2').DataTable({
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
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                           { data: "SYSID" },
                            { data: "Bus_Name" },
                            { data: "Addr" },
                            { data: "T_id" },
                            { data: "Cycle_Name" },
                            { data: "Agent_Name" },
                            {
                                data: "SYSID", render: function (data, type, row, meta) {
                                    return "<button id='edit' type='button' class='btn btn-primary btn-lg' >" +
                                        "<span class='glyphicon glyphicon-pencil'></span>&nbsp;修改</button>" +
                                        "<button type='button' class='btn btn-danger btn-lg' id='delete'>" +
                                        "<span class='glyphicon glyphicon-remove'></span>&nbsp;刪除</button>";
                                }
                            },
                            {
                                data: "Flag", render: function (data, type, row, meta) {
                                    var checked = 'checked/>'
                                    if (data == '0') {
                                        checked = '/>'
                                    }
                                    return "<div class='checkbox'><label>" +
                                        "<input id='Flag' type='checkbox' style='width: 30px; height: 30px;' " + checked +
                                        "</label></div>";
                                }
                            }
                        ]
                    });
                    //==========================
                    $('#Table2 tbody').unbind('click').
                        on('click', '#edit', function () {
                            var table = $('#Table2').DataTable();
                            var id = table.row($(this).parents('tr')).data().SYSID;
                            Get_info(id);
                        })
                        .on('click', '#delete', function () {
                            var table = $('#Table2').DataTable();
                            var id = table.row($(this).parents('tr')).data().SYSID;
                            //alert(id);
                            Delete_M_T(id);
                        }).
                       on('click', '#Flag', function () {
                           var table = $('#Table2').DataTable();
                           var id = table.row($(this).parents('tr')).data().SYSID;
                           var flag = table.row($(this).parents('tr')).data().Flag;
                           //alert("flag =" +flag);
                           Open_Flag(id, flag);
                       });
                }
            });
        };
        function Get_info(SYS_ID) {     //轉跳第二頁
            $.ajax({
                url: '0060010001.aspx/Get_info',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        window.location = json.status;
                    } else {
                        alert(json.status);
                    }
                }
            });
        };
        function Delete_M_T(SYS_ID) { //刪除維護任務
            var PID=document.getElementById("PID").innerHTML
            if (confirm("確定要刪除維護任務嗎？")) {
                $.ajax({
                    url: '0250010001.aspx/Delete_M_T',
                    ache: false,
                    type: 'POST',
                    //async: false,
                    data: JSON.stringify({ SYSID: SYS_ID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (data) {
                        var json = JSON.parse(data.d.toString());
                        if (json.status == "success") {
                            List_Eva(PID);
                        }
                        else
                            alert(json.status);
                    }
                });
            }
        };
        function Open_Flag(SYS_ID, Flag) {  //啟用與否的 Flag
            var PID = document.getElementById("PID").innerHTML
            $.ajax({
                url: '0060010001.aspx/Open_Flag',
                type: 'POST',
                data: JSON.stringify({ SYS_ID: SYS_ID, Flag: Flag }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        List_Eva(PID);
                    }

                    alert(json.status);
                }
            });
        };
        function Add_New() {    //新增清空格子
            //style('New_PID', '');
            //document.getElementById("New_PID").value = '';
            //document.getElementById("New_PID2").value = '';
            
            document.getElementById("C_Name").value = document.getElementById("business_name").value
            document.getElementById("New_T_ID").value = document.getElementById("Text30").value;
            document.getElementById("New_ADDR").value = document.getElementById("Text9").value;
            document.getElementById("New_Name").value = document.getElementById("Text1").value;
            document.getElementById("New_MTEL").value = document.getElementById("Text3").value;
            document.getElementById("New_CycleTime2").value = document.getElementById("New_CycleTime").value;
            document.getElementById("New_Agent").value = '';//*/
            Set_Month('0');
        }
        function New_Title() {  //存新增維護任務
            var PID = document.getElementById("PID").innerHTML;
            //var PID2 = document.getElementById("New_PID2").value;
            var T_ID = document.getElementById("New_T_ID").value;
            var ADDR = document.getElementById("New_ADDR").value;
            var Name = document.getElementById("New_Name").value;
            var MTEL = document.getElementById("New_MTEL").value;
            var CycleTime = document.getElementById("New_CycleTime2").value;
            var Agent = document.getElementById("New_Agent").value;
            var C_Name = document.getElementById("C_Name").value;

            var Check_1 = document.getElementById("Checkbox1").checked;
            var Check_2 = document.getElementById("Checkbox2").checked;
            var Check_3 = document.getElementById("Checkbox3").checked;
            var Check_4 = document.getElementById("Checkbox4").checked;
            var Check_5 = document.getElementById("Checkbox5").checked;
            var Check_6 = document.getElementById("Checkbox6").checked;
            var Check_7 = document.getElementById("Checkbox7").checked;
            var Check_8 = document.getElementById("Checkbox8").checked;
            var Check_9 = document.getElementById("Checkbox9").checked;
            var Check_10 = document.getElementById("Checkbox10").checked;
            var Check_11 = document.getElementById("Checkbox11").checked;
            var Check_12 = document.getElementById("Checkbox12").checked;
            $.ajax({
                url: '0060010001.aspx/New_Title',
                type: 'POST',
                data: JSON.stringify({
                    PID: PID,
                    //PID2: PID2,
                    T_ID: T_ID,
                    ADDR: ADDR,
                    Name: Name,
                    MTEL: MTEL,
                    CycleTime: CycleTime,
                    Agent: Agent,
                    C_Name: C_Name,
                    C_1: Check_1,
                    C_2: Check_2,
                    C_3: Check_3,
                    C_4: Check_4,
                    C_5: Check_5,
                    C_6: Check_6,
                    C_7: Check_7,
                    C_8: Check_8,
                    C_9: Check_9,
                    C_10: Check_10,
                    C_11: Check_11,
                    C_12: Check_12
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        List_Eva();
                        window.location = "/0060010001.aspx"
                    }
                    alert(json.status);
                }
            });
        }
        function Set_Month(Flag) {
            //alert("Flag = "+Flag);
            var CycleTime = document.getElementById("New_CycleTime").value;
            if (Flag == 1)
                CycleTime = document.getElementById("New_CycleTime2").value;
            //alert("Flag == 1");
            //alert("CycleTime = " + CycleTime);
            if (CycleTime == '0') {
                document.getElementById("Checkbox1").checked = "True";
                document.getElementById("Checkbox2").checked = "True";
                document.getElementById("Checkbox3").checked = "True";
                document.getElementById("Checkbox4").checked = "True";
                document.getElementById("Checkbox5").checked = "True";
                document.getElementById("Checkbox6").checked = "True";
                document.getElementById("Checkbox7").checked = "True";
                document.getElementById("Checkbox8").checked = "True";
                document.getElementById("Checkbox9").checked = "True";
                document.getElementById("Checkbox10").checked = "True";
                document.getElementById("Checkbox11").checked = "True";
                document.getElementById("Checkbox12").checked = "True";
            }
            else if (CycleTime == '1') {
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "True";
                document.getElementById("Checkbox3").checked = "";
                document.getElementById("Checkbox4").checked = "True";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "True";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "True";
                document.getElementById("Checkbox9").checked = "";
                document.getElementById("Checkbox10").checked = "True";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "True";
            }
            else if (CycleTime == '2') {
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "";
                document.getElementById("Checkbox3").checked = "True";
                document.getElementById("Checkbox4").checked = "";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "True";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "";
                document.getElementById("Checkbox9").checked = "True";
                document.getElementById("Checkbox10").checked = "";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "True";
            }
            else if (CycleTime == '3') {
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "";
                document.getElementById("Checkbox3").checked = "";
                document.getElementById("Checkbox4").checked = "";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "True";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "";
                document.getElementById("Checkbox9").checked = "";
                document.getElementById("Checkbox10").checked = "";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "True";
            }
            else if (CycleTime == '4') {
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "";
                document.getElementById("Checkbox3").checked = "";
                document.getElementById("Checkbox4").checked = "";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "";
                document.getElementById("Checkbox9").checked = "";
                document.getElementById("Checkbox10").checked = "";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "True";
            }
            else{
                document.getElementById("Checkbox1").checked = "";
                document.getElementById("Checkbox2").checked = "";
                document.getElementById("Checkbox3").checked = "";
                document.getElementById("Checkbox4").checked = "";
                document.getElementById("Checkbox5").checked = "";
                document.getElementById("Checkbox6").checked = "";
                document.getElementById("Checkbox7").checked = "";
                document.getElementById("Checkbox8").checked = "";
                document.getElementById("Checkbox9").checked = "";
                document.getElementById("Checkbox10").checked = "";
                document.getElementById("Checkbox11").checked = "";
                document.getElementById("Checkbox12").checked = "";
            }   //*/
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
        input[type=file]::file-selector-button {
          border: 2px solid #6c5ce7;
          padding: .2em .4em;
          border-radius: .2em;
          background-color: #a29bfe;
          transition: 1s;
        }

        input[type=file]::file-selector-button:hover {
          background-color: #81ecec;
          border: 2px solid #00cec9;
        }
    </style>

    <!-- ====== 母資料新增修改表 ====== -->
    <div class="modal fade" id="newModal" role="dialog" data-backdrop="static" data-keyboard="false" style="overflow: auto">
        <div class="modal-dialog" style="width: 1200px;">
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
                                    <span style="font-size: 20px"><strong>客戶資料<label id="PID"></label></strong></span>
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
                                    <strong>客戶名稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，不能超過５０個字">
                                        <!--<input type="text" id="business_name" name="business_name" class="form-control" placeholder="中文名稱"
                                            maxlength="50" style="Font-Size: 18px; background-color: #ffffbb " title="" />-->
                                        <textarea id="business_name" name="business_name" class="form-control" cols="45" rows="2" placeholder="中文名稱" 
                                            maxlength="50" style="resize: none; background-color: #ffffbb "></textarea>
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>英文名稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <!--<input type="text" id="business_id" name="business_id" class="form-control" placeholder="英文名稱"
                                            maxlength="50" style="Font-Size: 18px; " title=""/>-->
                                        <textarea id="business_id" name="business_id" class="form-control" cols="45" rows="2" placeholder="英文名稱" 
                                            maxlength="50" style="resize: none;"></textarea>
                                    </div>
                                </th>
                            </tr>
                            <!-- ========================================== -->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>統一編號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必填，應填8位數字">
                                        <input type="text" id="id" name="id" class="form-control" placeholder="統一編號"
                                            maxlength="8" style="Font-Size: 18px; background-color: #ffffbb" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>通訊地址</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <textarea id="Text10" name="Text10" class="form-control" cols="45" rows="3" placeholder="通訊地址" 
                                            maxlength="200" style="resize: none;"></textarea>
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>聯絡人1</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <!--<div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text1" name="txt_Agent_Name" class="form-control" placeholder="聯絡人1"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>-->
                                    <textarea id="Text1" name="Text1" class="form-control" cols="45" rows="2" placeholder="聯絡人1" 
                                            maxlength="50" style="resize: none; background-color: #ffffbb;"></textarea>
                                </th>
                                <!--<th style="text-align: center; width: 15%; height: 55px;" hidden="hidden">
                                    <strong>職稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%;" hidden="hidden">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text2" name="txt_Agent_Name" class="form-control" placeholder="職稱"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>-->
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>行動電話1</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text3" name="txt_Agent_Name" class="form-control" placeholder="行動電話"
                                            maxlength="50" style="Font-Size: 18px; background-color: #ffffbb;" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>E-mail</strong>
                                </th>
                                <th style="text-align: center; width: 35%" colspan="3">
                                    <div data-toggle="tooltip" title="不能超過１００個字">
                                        <!--<input type="text" id="Text4" name="txt_Agent_Name" class="form-control" placeholder="E-mail"
                                            maxlength="100" style="Font-Size: 18px; " />-->
                                        <textarea id="Text4" name="Text4" class="form-control" cols="100" rows="1" placeholder="E-mail" 
                                            maxlength="100" style="resize: none;"></textarea>
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 60px;">
                                    <strong>名片上傳</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <input type="file" id="file" class="form-control" style="height:auto" multiple="multiple" />
                                </th>
                                <th>
                                    <div style="width:500px">
                                        <ol id="file_Name"></ol>
                                    </div>
                                </th>
                            </tr>

                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>聯絡人2</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <!--<input type="text" id="Text5" name="txt_Agent_Name2" class="form-control" placeholder="聯絡人2"
                                            maxlength="50" style="Font-Size: 18px; " />-->
                                    <textarea id="Text5" name="Text5" class="form-control" cols="45" rows="2" placeholder="聯絡人2" 
                                            maxlength="50" style="resize: none;"></textarea>
                                    </div>
                                </th>
                                <!--<th style="text-align: center; width: 15%; height: 55px;" hidden="hidden">
                                    <strong>職稱</strong>
                                </th>
                                <th style="text-align: center; width: 35%" hidden="hidden">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text6" name="txt_Agent_Name2" class="form-control" placeholder="職稱"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>-->
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>行動電話2</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text7" name="txt_Agent_Name2" class="form-control" placeholder="行動電話"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>E-mail</strong>
                                </th>
                                <th style="text-align: center; width: 35%" colspan="3">
                                    <div data-toggle="tooltip" title="不能超過１００個字">
                                        <!--<input type="text" id="Text8" name="txt_Agent_Name2" class="form-control" placeholder="E-mail"
                                            maxlength="100" style="Font-Size: 18px; " />-->
                                        <textarea id="Text8" name="Text8" class="form-control" cols="100" rows="2" placeholder="E-mail" 
                                            maxlength="100" style="resize: none;"></textarea>
                                    </div>
                                </th>
                            </tr>
                            
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>公司電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text11" name="txt_Agent_Name" class="form-control" placeholder="公司電話"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>傳真電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text12" name="txt_Agent_Name" class="form-control" placeholder="傳真電話"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>註冊公司</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <!--<input type="text" id="Text13" name="R_C_Name_ID" class="form-control" placeholder="註冊公司"
                                            maxlength="50" style="Font-Size: 18px; " />-->
                                        <textarea id="Text13" name="Text13" class="form-control" cols="45" rows="2" placeholder="註冊公司" 
                                            maxlength="50" style="resize: none;"></textarea>
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Inads</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" id="Text14" name="Inads" class="form-control" placeholder="Inads"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>硬體</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <!--<input type="text" id="Text15" name="Hardware" class="form-control" placeholder="Hardware"
                                            maxlength="200" style="Font-Size: 18px; " />-->
                                    <textarea id="Text15" name="Text15" class="form-control" cols="45" rows="5" placeholder="硬體相關資訊" 
                                            maxlength="200" style="resize: none;"></textarea>
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>軟體</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        
                                        <textarea id="Text16" name="Text16" class="form-control" cols="45" rows="5" placeholder="軟體相關資訊" 
                                            maxlength="200" onkeyup="" style="resize: none;"></textarea>
                                    
                                        <!--<input type="text" id="Text16" name="Software_Load" class="form-control" placeholder="Software Load"
                                            maxlength="200" style="Font-Size: 18px; " />    -->
                                    </div>
                                </th>
                            </tr>
                            
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>語音信箱類別</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" id="Text17" name="Mail_Type " class="form-control" placeholder="語音信箱類別"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <!--<th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Authentication ID</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" id="Text29" name="Auth_File_ID" class="form-control" placeholder="Authentication ID"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>-->
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>LAC</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" id="Text26" name="LAC" class="form-control" placeholder="LAC"
                                            maxlength="200" style="Font-Size: 18px;" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>經銷商</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text19" name="txt_Agent_Name" class="form-control" placeholder="經銷商"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>經銷商聯絡人</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text20" name="txt_Agent_Name2" class="form-control" placeholder="經銷商聯絡人"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>聯絡電話</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text21" name="txt_Agent_Phone" class="form-control" placeholder="聯絡電話"
                                            maxlength="50" style="Font-Size: 18px;" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>SID</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" id="Text22" name="SID" class="form-control" placeholder="SID"
                                            maxlength="200" style="Font-Size: 18px;" />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>序列號</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" class="form-control" id="Text23" name="Serial_Number" placeholder="序列號"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>License Host</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" class="form-control" id="Text24" name="Serial_Number" placeholder="License Host"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <!--<th style="text-align: center; width: 15%; height: 55px;">
                                <strong>許可證名稱</strong>
                            </th>
                            <th style="text-align: center; width: 35%">
                                <div data-toggle="tooltip" title="不能超過２００個字">
                                    <input type="text" id="Text25" name="Licence_Name" class="form-control" placeholder="許可證名稱"
                                        maxlength="200" style="Font-Size: 18px; " />
                                </div>
                            </th>-->
                            <tr>                                
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>維護廠商</strong>
                                </th>
                                <td style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="必選" style="width: 60%">
                                        <select id="Text30" name="txt_Telecomm_ID" class="chosen-select" onchange="">
                                            <option value="">請選擇維護廠商…</option>
                                            <option value="中華電信">中華電信</option>
                                            <option value="遠傳">遠傳</option>
                                            <option value="德瑪">德瑪</option>
                                            <option value="其他">其他</option>
                                        </select>
                                    </div>
                                </td>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>其他</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="T_ID" name="txt_Telecomm_ID2" class="form-control" placeholder="維護廠商選其他時填"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>裝機地址</strong>
                                </th>
                                <th style="text-align: center; width: 35%" colspan="3">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <!--<input type="text" id="Text9" name="txt_Agent_Name" class="form-control" placeholder="裝機地址"
                                            maxlength="200" style="Font-Size: 18px; " />-->
                                        <textarea id="Text9" name="Text9" class="form-control" cols="100" rows="2" placeholder="裝機地址" 
                                            maxlength="200" style="resize: none; background-color: #ffffbb;"></textarea>
                                    </div>
                                </th>                                
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%">
                                    <strong>維護週期</strong></th>
                                <th style="width: 35%">
                                    <select id="New_CycleTime" name="New_CycleTime" class="form-control"
                                        style="width: 60%; Font-Size: 18px; color: #333333;">
                                        <option value="">請選擇維護週期…</option>
                                        <option value="0">單月</option>
                                        <option value="1">雙月</option>
                                        <option value="2">每季</option>
                                        <option value="3">半年</option>
                                        <option value="4">每年</option>
                                        <option value="5">遠端維護</option>
                                        <option value="6">無合約</option>
                                    </select>
                                </th>
                                <!--<th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>SED</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" id="Text33" name="SED" class="form-control" placeholder="SED"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>-->
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>合約狀態</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" id="Text34" name="R_C_Name_ID" class="form-control" placeholder="合約狀態"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <!--<tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Our Reference</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" class="form-control" id="Text27" name="Our_Reference" placeholder="Our Reference"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Your Reference</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" class="form-control" id="Text28" name="Your_Reference" placeholder="Your Reference"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>-->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>FL</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" id="Text31" name="FL" class="form-control" placeholder="FL"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>Group Name-ID</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２００個字">
                                        <input type="text" id="Text32" name="Group_Name_D" class="form-control" placeholder="Group Name-ID"
                                            maxlength="200" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            

                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>保固開始日</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker02" name="time_02" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>保固終止日</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text35" name="" class="form-control" placeholder="以月來記錄"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>維護開始日</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker03" name="time_03" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>維護終止日</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過５０個字">
                                        <input type="text" id="Text36" name="" class="form-control" placeholder="以月來記錄"
                                            maxlength="50" style="Font-Size: 18px; " />
                                    </div>
                                </th>
                            </tr>
                            <!--<tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>收款日期</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker04" name="time_04" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>收款備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０００個字">
                                        <textarea id="Text37" name="Text37" class="form-control" cols="45" rows="3" placeholder="收款備註" 
                                            maxlength="2000" onkeyup="cs(this);" style="resize: none;"></textarea>
                                    </div>
                                </th>
                            </tr>-->
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>結案日期</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker05" name="time_05" style="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>結案備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０００個字">
                                        <textarea id="Text38" name="Text38" class="form-control" cols="45" rows="3" placeholder="備結案註" 
                                            maxlength="2000" onkeyup="" style="resize: none;"></textarea><!--
                                        <input type="text" id="Text38" name="" class="form-control" placeholder="結案備註"
                                            maxlength="2000" style="Font-Size: 18px; " />-->
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>顧客帳密備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０００個字">
                                        <textarea id="Text39" name="Text39" class="form-control" cols="45" rows="3" placeholder="顧客帳密備註" 
                                            maxlength="2000" onkeyup="" style="resize: none;"></textarea><!---->
                                        <!--<input type="text" id="Text39" name="" class="form-control" placeholder="顧客帳密備註"
                                            maxlength="2000" style="Font-Size: 18px; " />-->
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 55px;">
                                    <strong>顧客資訊備註</strong>
                                </th>
                                <th style="text-align: center; width: 35%">
                                    <div data-toggle="tooltip" title="不能超過２０００個字">
                                        <textarea id="Text40" name="Text40" class="form-control" cols="45" rows="3" placeholder="顧客資訊備註" 
                                            maxlength="2000" onkeyup="" style="resize: none;"></textarea>
                                        <!--<input type="text" id="Text40" name="" class="form-control" placeholder="顧客資訊備註"
                                            maxlength="2000" style="Font-Size: 18px; " />-->
                                    </div>
                                </th>
                            </tr>
                            <tr>
                                <td  style="text-align: center; ">
                                    <strong>工作日</strong>
                                </td>
                                <td  style="text-align: center; ">
                                    <strong>星期六</strong>
                                    <input id='Check_Saturday' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                    <strong>星期日</strong>
                                    <input id='Check_Sunday' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                </td>
                                <td colspan="2">
                                    <strong>打勾代表六日照常計算服務單的工作日</strong>
                                </td>
                            </tr>
                            <tr>
                                <th style="text-align: center; width: 15%; height: 65px;">
                                    <strong>最後修檔日期</strong>
                                </th>
                                <th>
                                    <div style="float: left" data-toggle="tooltip" title="自動抓時間">

                                        <input type="text" class="form-control" id="LoginTime" name="LoginTime" style="" value="" />
                                    </div>
                                </th>
                                <th style="text-align: center; width: 15%; height: 65px;">
                                    <strong>建檔日期</strong>
                                </th>
                                <th>
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <label id="time_06"></label>
                                    </div>
                                </th>
                            </tr>
                            <!--<tr>
                                <th style="text-align: center; width: 15%; height: 55px;"></th>
                                <th style="text-align: center; width: 35%; height: 65px;" colspan="2">
                                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="Safe(0)" style="width: 110px; height: 65px"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="New(1)"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
                                    <!--New(0) New(1) 換 Safe 
                                </th>
                            </tr>-->
                        </tbody>
                    </table>
                    <h2><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;維護任務名單</strong></h2>
                    <table id="Table2" class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center;">編號</th>
                                <th style="text-align: center;">客戶名稱</th>
                                <th style="text-align: center;">維護地址</th>
                                <th style="text-align: center;">維護廠商</th>
                                <th style="text-align: center;">維護週期</th>
                                <th style="text-align: center;">負責工程師</th>
                                <th style="text-align: center;">設定</th>
                                <th style="text-align: center;">啟用</th>
                            </tr>
                        </thead>
                    </table>
                    <!-- ========================================== -->
                </div>
                <div class="modal-footer">
                    <button id="Add_Eva" type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#data02" style="Font-Size: 20px;" onclick="Add_New()">
                        <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增維護任務</button>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <button id="btn_new" type="button" class="btn btn-success btn-lg" onclick="Safe(0)" data-dismiss="modal"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                    <button id="btn_update" type="button" class="btn btn-primary btn-lg" onclick="New(1)" data-dismiss="modal"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改</button>
                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal">
                        <span class="glyphicon glyphicon-remove"></span> 
                        &nbsp;取消</button>
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
            $('#datetimepicker05').datetimepicker({
                allowTimes: [
                    '00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30',
                    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
                    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30'
                ]
            });

            $('#New_StartTime,#txt_CALL_Time').datetimepicker({
                datepicker: false,
                useSeconds: false,
                format: 'H:i',
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
    <div class="table-responsive" style="width: 95%; margin: 10px 20px">
        <h2><strong>客戶資料維護&nbsp; &nbsp;
                <button type="button" class="btn btn-success btn-lg" data-toggle="modal" data-target="#newModal" style="Font-Size: 20px;" onclick="Xin_De()">
                    <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增客戶資料</button>
        </strong></h2>
        <table id="data" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center; width: 10%;">客戶代號</th>
                    <th style="text-align: center; width: 10%;">客戶名稱</th>
                    <th style="text-align: center; width: 10%">經銷商</th>
                    <!--<th style="text-align: center; width: 10%">客戶備註</th>-->
                    <th style="text-align: center; width: 10%">保固終止日</th>
                    <!--<th style="text-align: center;">異動者</th>-->
                    <th style="text-align: center; width: 10%">維護終止日</th>
                    <th style="text-align: center; width: 10%">維護週期</th>
                    <th style="text-align: center; width: 10%">修改</th>
                    <!--<th style="text-align: center; width: 10%">子公司</th>-->
                    <th style="text-align: center; width: 10%">刪除</th>
                </tr>
            </thead>
        </table>
    </div>

    <!--====================子公司清單=======================-->

    <div class="table-responsive" style="text-align: center; width: 95%; margin: 10px 20px" hidden="hidden">
        <h2><strong>子公司清單&nbsp; &nbsp;</strong></h2>
        <table id="Table1" class="display table table-striped" style="width: 99%">
            <thead>
                <tr>
                    <th style="text-align: center; width: 10%;">子公司編號</th>
                    <th style="text-align: center; width: 20%">客戶名稱</th>
                    <th style="text-align: center; width: 10%">子公司名稱</th>
                    <th style="text-align: center; width: 20%">備註</th>
                    <th style="text-align: center; width: 15%">建檔日期</th>
                    <!--<th style="text-align: center;">異動者</th>-->
                    <th style="text-align: center; width: 15%">異動日期</th>
                    <!--<th style="text-align: center; width: 10%">修改</th>-->
                </tr>
            </thead>
        </table>
    </div>

    <!-- ====== 新增維護資料 ====== -->
    <div class="modal fade" id="data02" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width:  1200px;">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" onclick="URL2();"><span class="glyphicon glyphicon-remove"></span>&nbsp;關閉</button>
                    <h2 class="modal-title"><strong>維護任務（新增）</strong></h2>

                </div>
                <div class="modal-body">
                    <!-- ========================================== -->
                    <div style="height: 20px;"></div>
                    <div>
                        <table class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th style="text-align: center" colspan="4">
                                        <span style="font-size: 20px"><strong>維護設定</strong></span>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <!--<tr style="height: 55px;">
                                    <th style="text-align: center; width: 15%">
                                        <strong>客戶選擇</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <select id="New_PID" name="New_PID" class="form-control" style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" onchange="Show_PID()">
                                            <option value="">請選擇客戶…</option>
                                        </select>
                                    </th>
                                    <th style="text-align: center; width: 15%">
                                        <strong>子公司選擇</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <select id="New_PID2" name="New_PID2" class="form-control" style="width: 100%; Font-Size: 18px;" onchange="Show_PID2()">
                                            <option value="">請選擇子公司…</option>
                                        </select>
                                    </th>
                                </tr>-->
                                <tr style="height: 55px;">
                                    <th style="text-align: center; width: 15%">
                                        <strong>客戶名稱</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <input id="C_Name" class="form-control" value="" maxlength="50" onkeyup=""
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                                    </th>
                                </tr>
                                <tr style="height: 55px;">
                                    <th style="text-align: center; width: 15%">
                                        <strong>維護廠商</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <select id="New_T_ID" name="New_T_ID" class="form-control" style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;">
                                            <option value="">請選擇維護廠商…</option>
                                            <option value="中華電信">中華電信</option>
                                            <option value="遠傳">遠傳</option>
                                            <option value="德瑪">德瑪</option>
                                            <option value="其他">其他</option>
                                        </select>
                                    </th>
                                    <th style="text-align: center; width: 15%">
                                        <strong>維護地址</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <input id="New_ADDR" class="form-control" value="" maxlength="200" onkeyup="cs(this);"
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                                    </th>
                                </tr>
                                <tr style="height: 55px;">
                                    <th style="text-align: center; width: 15%">
                                        <strong>聯絡人</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <input id="New_Name" class="form-control" value="" maxlength="15" onkeyup="cs(this);"
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                                    </th>
                                    <th style="text-align: center; width: 15%">
                                        <strong>聯絡電話</strong>
                                    </th>
                                    <th style="width: 35%">
                                        <input id="New_MTEL" class="form-control" value="" maxlength="25" onkeyup=""
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                                    </th>
                                </tr>
                                
                                <tr style="height: 55px;">
                                    <th style="text-align: center; width: 15%">
                                        <strong>維護週期</strong></th>
                                    <th style="width: 35%">
                                        <select id="New_CycleTime2" name="New_CycleTime2" class="form-control" onchange="Set_Month('1')"
                                            style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;">
                                            <option value="">請選擇維護週期…</option>
                                            <option value="0">單月</option>
                                            <option value="1">雙月</option>
                                            <option value="2">每季</option>
                                            <option value="3">半年</option>
                                            <option value="4">每年</option>
                                            <option value="5">不維護</option>
                                        </select>
                                    </th>
                                    <th style="text-align: center;">
                                        <strong>負責工程師</strong>
                                    </th>
                                    <th>
                                        <select id="New_Agent" name="New_Agent" class="form-control" style="width: 100%; Font-Size: 18px; color: #333333;">
                                            <option value="">請選擇工程師…</option>
                                        </select>
                                    </th>
                                </tr>
                                <tr style="height: 55px;">
                                    <th style="text-align: center;">
                                        <strong>維護月份</strong>
                                    </th>
                                </tr>
                                <tr style="height: 55px;">
                                    <td colspan="4"  style="text-align: center;">
                                        <strong>一月</strong>
                                        <input id='Checkbox1' type='checkbox' style='width: 30px; height: 30px;'  />&nbsp;<!--   onclick="CheckFlag();"     -->
                                        <strong>二月</strong>
                                        <input id='Checkbox2' type='checkbox' style='width: 30px; height: 30px;'  />&nbsp;
                                        <strong>三月</strong>
                                        <input id='Checkbox3' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>四月</strong>
                                        <input id='Checkbox4' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>五月</strong>
                                        <input id='Checkbox5' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>六月</strong>
                                        <input id='Checkbox6' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>七月</strong>
                                        <input id='Checkbox7' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>八月</strong>
                                        <input id='Checkbox8' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>九月</strong>
                                        <input id='Checkbox9' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>十月</strong>
                                        <input id='Checkbox10' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>十一月</strong>
                                        <input id='Checkbox11' type='checkbox' style='width: 30px; height: 30px;' />&nbsp;
                                        <strong>十二月</strong>
                                        <input id='Checkbox12' type='checkbox' style='width: 30px; height: 30px;' />
                                    </td>
                                </tr>
                                <tr>
                                    <th style="text-align: center;" colspan="4">
                                        <button type="button" class="btn btn-success btn-lg" onclick="New_Title()">
                                            <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增</button>
                                    </th>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--===========================照片預覽dialog=======================================--%>
<div class="modal fade" id="dialog1" role="dialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" style="width: 800px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <div id="img"></div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-remove" >關閉</span></button>
            </div>
        </div>
    </div>
</div>
    <%--===========================案件狀態更改dialog=======================================--%>

</asp:Content>
