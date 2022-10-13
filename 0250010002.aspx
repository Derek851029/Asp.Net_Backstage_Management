<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0250010002.aspx.cs" Inherits="_0250010002" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">
    <link href="../js/jquery-ui.css" rel="stylesheet" />
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <script src="../js/jquery-ui.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        var seqno = '<%= seqno %>';
        $(function () {
            //alert("seqno=" + seqno);
            document.getElementById("Lab_SYSID").innerHTML = seqno;
            //alert("123");
            //Get_Title();  //傳圖與巡邏點
            List_PID(); //抓公司下拉
            //List_PID2(0);
            List_Agent(0); //抓工程師下拉
            Creat_Table();  //  創建 12個 問題選單頁面
            //Show_Title();  //抓 Title 資料
        });

        //======================================
        //  讀取 巡查設定
        function Get_Title() {
            $("#MAP div[id='MAP']").remove();
            $.ajax({
                url: '0250010002.aspx/Get_Title',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    document.getElementById("MAP").innerHTML = json.status;
                    document.getElementById("txt_title").innerHTML = "巡查地點：" + json.title + "（修改）";
                    //document.getElementById("New_Location").value = json.title;
                    //document.getElementById("New_CycleTime").value = json.cycle;
                    //document.getElementById("New_StartTime").value = json.start_time;
                    //document.getElementById("New_EndTime").value = json.end_time;
                    //document.getElementById("New_Team").value = json.team;
                    //======================================
                    //  讀取 巡查人員
                    //List_Agent(json.team, json.id);
                    //======================================
                    
                    
                }
            });
        }

        function Update_Title() {
            var sysid = document.getElementById("Lab_SYSID").innerHTML;
            var str_PID = document.getElementById("New_PID").value;
            //var str_PID2 = document.getElementById("New_PID2").value;
            var str_C_Name = document.getElementById("C_Name").value;
            var str_T_ID = document.getElementById("New_T_ID").value;
            var str_ADDR = document.getElementById("New_ADDR").value;
            var str_Name = document.getElementById("New_Name").value;
            var str_MTEL = document.getElementById("New_MTEL").value;
            var str_CycleTime = document.getElementById("New_CycleTime").value;
            var str_Agent = document.getElementById("New_Agent").value;
            //alert(str_PID + str_PID2 + str_T_ID + str_ADDR + str_Name + str_MTEL + str_CycleTime + str_Agent)
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
                url: '0250010002.aspx/Update_Title',
                type: 'POST',
                data: JSON.stringify({
                    sysid: sysid,
                    PID: str_PID,
                    //PID2: str_PID2,
                    T_ID: str_T_ID,
                    ADDR: str_ADDR,
                    Name: str_Name,
                    MTEL: str_MTEL,
                    CycleTime: str_CycleTime,
                    Agent: str_Agent,
                    C_Name: str_C_Name,
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
                        var a = document.getElementById("txt_title");
                        a.innerHTML = "維護設定 修改完成";
                    }
                    alert(json.status);
                }
            });
        }

        function Creat_Table() {
            document.getElementById("table_madal").innerHTML = "";
            var total = 12;
            var b = "";
            var bit = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
            var ul = "<ul id='Tab' class='nav nav-tabs'><li class='active'>";
            var tab = "<div class='tab-content'><div class='tab-pane active' ";
            var i = 0;
            for (i = 0; i < total; i++) {
                if (i != 0) { ul += "<li>" }
                if (i != 0) { tab += "<div class='tab-pane' " }
                b = bit[i];
                a = "<div id='D_" + b + "' class='drag'><img src='/Patrol_System/" + b + ".png' id='img_" + b + "' /></div>"
                ul += "<a href='#li_point_" + b + "' data-toggle='tab'>" + b + "</a></li>";
                tab += " id='li_point_" + b + "'>" +
                                "<table class='display table table-striped' style='width: 99%'>" +
                                "<thead>" +
                                "<tr>" +
                                "<th style='text-align: center' colspan='4'>" +
                                "<div class='col-lg-4 col-lg-offset-4'>" +
                                "<span style='font-size: 20px'><strong>各檢查項目設定</strong></span>" +
                                "</div>" +
                                "</th>" +
                                "</tr>" +
                                "</thead>" +
                                "<tbody>" +
                                 "<tr>" +
                                 "<th style='text-align: center; width: 25%; height: 55px;'><strong>項目名稱</strong></th>" +
                                 "<th style='text-align: center; width: 75%'>" +
                                "<input id='title_" + b + "' class='form-control' value='' maxlength='25' onkeyup='cs(this);'" +
                                "style='width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;' />" +
                                 "</th>" +
                                 "</tr>";
                //=====================================================================

                //======= 五個題目 =======
                var q = 1;
                for (q = 1; q < 6; q++) {
                    tab += "<tr>" +
                                   "<th style='text-align: center; width: 25%; height: 55px;'><strong>" + q + ". 檢查內容</strong></th>" +
                                   "<th style='text-align: center; width: 75%'>" +
                                   //"<input id='txt_" + b + q + "' class='form-control' value='' maxlength='' onkeyup='' " +  //cs(this);
                                   //" style='width: 100%; background-color: #ffffbb; Font-Size: 18px;' />" +
                                   "<textarea id='txt_" + b + q + "' class='form-control' cols='50' rows='3' value='' maxlength='500' onkeyup='' " +  //cs(this);
                                   " style='width: 100%; background-color: #ffffbb; Font-Size: 18px;' ></textarea> " +
                                   "</th>" +
                                   "</tr>" +
                                   //=====================================================================
                                   "<tr>" +
                                   "<th style='text-align: center; height: 55px;'>" +
                                   "<strong>" + q + ". 回答類型</strong>" +
                                   "</th>" +
                                   "<th style='text-align: center;'>" +
                                   "<select id='select_" + b + q + "' class='form-control' onchange=Change_Type('" + b + q + "',0) value='' ; " +
                                   " style='Font-Size: 18px; background-color: #ffffbb;' >" +
                                   "<option value='6'>無問題</option>" +
                                   "<option value='1'>填空</option>" +
                                   "<option value='2'>選(不含無)</option>" +
                                   "<option value='0'>選(含無)</option>" +
                                   "<option value='5'>選(維護種類)</option>" +
                                   "<option value='3'>選(不斷電)</option>" +
                                   "<option value='4'>選(清潔)</option>" +
                                   "</select></th>" +
                                   "</tr>" +
                                   //====================================================================
                                   "<tr>" +
                                   "<th style='text-align: center;'>" +
                                   "<strong>" + q + ". 回答內容</strong></th>" +
                                   "<th id='" + b + q + "_1'>" +
                                   "<div id='" + b + q + "_2'> </div>" +
                                   "</th>" +
                                   "</tr>";
                }
                //====================================================================
                tab += "<tr>" +
                    "<th style='text-align: center; width: 50%; height: 55px;' colspan='4'>" +
                    "<button type='button' class='btn btn-primary btn-lg' onclick=Update_Question('" + b + "')>" +
                    "<span class='glyphicon glyphicon-pencil'></span>&nbsp;&nbsp;修改 " + b + " 項目內容</button>" +
                    "</th>" +
                    "</tr>" +
                    "</tbody>" +
                    "</table>" +
                    "</div>";
                document.getElementById("MAP").innerHTML += a;  // 寫入藍色 icon
                var Div = document.getElementById("D_" + b);
                Div.style.top = "0px";
                Div.style.left = "0px";
            }
            document.getElementById("table_madal").innerHTML = ul + "</ul>" + tab + "</div>";  //寫入 table_madal
            $("#MAP div[id^='D_']").draggable(
                {
                    containment: "#MAP",
                    drag: function (event, ui) {
                        //console.log('A', ui.position.left);
                        //console.log('A', ui.position.top);
                        //$("#x").val(ui.position.left);
                        //$("#y").val(ui.position.top);
                    }
                });
            //=================================================================
            Get_info();
        }

        function Get_Location() {
            var id = ["D_A", "D_B", "D_C", "D_D", "D_E", "D_F", "D_G", "D_H", "D_I", "D_J", "D_K", "D_L"];
            var top_value = [];
            var left_value = [];
            var Div = "";
            for (i = 0; i < 12; i++) {
                Div = document.getElementById(id[i]);
                top_value.push(parseInt(Div.style.top, 12));
                left_value.push(parseInt(Div.style.left, 12));
            };

            $.ajax({
                url: '0250010002.aspx/Update_Location',
                type: 'POST',
                data: JSON.stringify({ Top: top_value, Left: left_value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    alert(doc.d);
                }
            });
        }

        function Update_Question(ID) {
            var sysid = document.getElementById("Lab_SYSID").innerHTML;
            var title = document.getElementById("title_" + ID).value;
            var question = [];
            var option = [];
            var type = [];
            var txt = "";
            var select = "";
            var Q = "";
            for (i = 1; i < 6; i++) {
                txt = document.getElementById("txt_" + ID + i).value;
                select = document.getElementById("select_" + ID + i).value;
                if (select == "1") { Q = document.getElementById("Q_" + ID + i).value; } else { Q = ""; };
                question.push(txt);
                type.push(select);
                option.push(Q);
            }
            //for (j = 0; j < 5; j++)   alert(type[j]);

            $.ajax({
                url: '0250010002.aspx/Update_Question',
                type: 'POST',
                data: JSON.stringify({ sysid: sysid, alphabet: ID, title: title, question: question, option: option, type: type }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        alert(json.status);
                    } else {
                        alert(json.status);
                    }
                }
            });
        }

        function Get_info() {   //抓項目 或新增項目
            $.ajax({
                url: '0250010002.aspx/Get_info',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}');
                    if (obj.data[0].status == '') {
                        var total = obj.data.length;
                        var b = "";
                        var i = 0;
                        for (i = 0; i < total; i++) {
                            b = obj.data[i].bit;
                            document.getElementById("title_" + b).value = obj.data[i].name;
                            var Div = document.getElementById("D_" + b);
                            Div.style.top = obj.data[i].x + "px";
                            Div.style.left = obj.data[i].y + "px";
                            //======= 五個題目 =======
                            var q = 1;
                            var value = "";
                            var type = "";
                            var option = "";
                            var a = "";
                            for (q = 1; q < 6; q++) {
                                switch (q) {
                                    case 1:
                                        value = obj.data[i].q_1;
                                        type = obj.data[i].t_1;
                                        option = obj.data[i].o_1;
                                        break;
                                    case 2:
                                        value = obj.data[i].q_2;
                                        type = obj.data[i].t_2;
                                        option = obj.data[i].o_2;
                                        break;
                                    case 3:
                                        value = obj.data[i].q_3;
                                        type = obj.data[i].t_3;
                                        option = obj.data[i].o_3;
                                        break;
                                    case 4:
                                        value = obj.data[i].q_4;
                                        type = obj.data[i].t_4;
                                        option = obj.data[i].o_4;
                                        break;
                                    default:
                                        value = obj.data[i].q_5;
                                        type = obj.data[i].t_5;
                                        option = obj.data[i].o_5;
                                }
                                a = b + q;
                                document.getElementById("txt_" + a).value = value;
                                document.getElementById("select_" + a).value = type;
                                Change_Type(a, option);
                            }
                            //======= 五個題目 =======
                        }
                    }
                }
            })
        }

        function Change_Type(ID, option) {
            //alert(ID + ' A ' + option+' A ');
            $.ajax({
                url: '0250010002.aspx/Check',
                type: 'POST',
                data: JSON.stringify({ ID: ID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var a = doc.d;
                    var b = document.getElementById("select_" + a).value;
                    $("#" + a + "_2").remove();
                    document.getElementById(a + "_1").innerHTML = From_Add(a, b);
                    if (b == "1") {
                        if (option == "0") { option = ""; }
                        document.getElementById("Q_" + a).value = option;
                    }
                }
            });
        }

        function From_Add(ID, type) {
            var a = "<div id='" + ID + "_2'>"
            if (type == 0) {
                a += "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "正常</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "異常</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "無此設備/機能</label></div>";
            }
            else if (type == 1) {
                a += "<div  hidden='hidden'>單位：<input id='Q_" + ID + "' class='form-control' maxlength='2' " +
                    "style='width: 10%; background-color: #ffffbb; Font-Size: 18px;' /></div>";
            }
            else if (type == 2) {
                a += "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "正常</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "異常</label></div>";
            }
            else if (type == 3) {
                a += "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "UPS</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "SMR</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "不斷電電池組</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "無此設備/機能</label></div>";
            }
            else if (type == 4) {
                a += "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "已完成清潔</label></div>"
            }
            else if (type == 5) {
                a += "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "保固</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "合約</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "租約</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "定期維護</label></div>" +
                    "<div class='form-check'>" +
                    "<label class='form-check-label'>" +
                    "<input type='radio' class='form-check-input' name='" + ID + "' disabled/>" +
                    "其他</label></div>";
            }
            return a + "</div>";
        }

        function Show_Title() {
            $.ajax({
                url: '0250010002.aspx/Show_Title',
                type: 'POST',
                data: JSON.stringify({ }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //document.getElementById("New_T_ID").value = obj.data[0].A;

                    style('New_PID', obj.data[0].A);
                    //document.getElementById("New_PID").value = '';
                    //style('New_PID2', obj.data[0].B);
                    if (obj.data[0].C == "中華電信" || obj.data[0].C == "遠傳" || obj.data[0].C == "德瑪")
                        document.getElementById("New_T_ID").value = obj.data[0].C;
                    else
                        document.getElementById("New_T_ID").value = "其他";
                    document.getElementById("New_ADDR").value = obj.data[0].D;
                    document.getElementById("New_Name").value = obj.data[0].E;
                    document.getElementById("New_MTEL").value = obj.data[0].F;
                    document.getElementById("New_CycleTime").value = obj.data[0].G;
                    document.getElementById("New_Agent").value = obj.data[0].H;
                    document.getElementById("C_Name").value = obj.data[0].I;
                    document.getElementById("Checkbox1").checked = obj.data[0].C1;
                    document.getElementById("Checkbox2").checked = obj.data[0].C2;
                    document.getElementById("Checkbox3").checked = obj.data[0].C3;
                    document.getElementById("Checkbox4").checked = obj.data[0].C4;
                    document.getElementById("Checkbox5").checked = obj.data[0].C5;
                    document.getElementById("Checkbox6").checked = obj.data[0].C6;
                    document.getElementById("Checkbox7").checked = obj.data[0].C7;
                    document.getElementById("Checkbox8").checked = obj.data[0].C8;
                    document.getElementById("Checkbox9").checked = obj.data[0].C9;
                    document.getElementById("Checkbox10").checked = obj.data[0].C10;
                    document.getElementById("Checkbox11").checked = obj.data[0].C11;
                    document.getElementById("Checkbox12").checked = obj.data[0].C12;
                }
            });
        }

        /*function List_Agent(Team, ID) {
            var $select_elem = $("#New_Agent");
            $.ajax({
                url: '0250010001.aspx/List_Agent',
                type: 'POST',
                data: JSON.stringify({ Team: Team }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇檢查人員…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.Agent_ID + "'>" + obj.Agent_Name + "</option>");
                    });
                    document.getElementById("New_Agent").value = ID;
                }
            });
        }//*/

        function List_PID() {   //客戶下拉
            $.ajax({
                url: '0250010001.aspx/List_PID',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#New_PID");
                    $select_elem.chosen("destroy")
                    //$select_elem.empty();
                    //$select_elem.append("<option value=''>" + "請選擇客戶…" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.PID + "'>" + obj.BUSINESSNAME + "</option>");
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    $('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
            Show_Title();  //抓 Title 資料
        }
        function Show_PID() {     //選顧客後抓資料
            var PID = document.getElementById("New_PID").value;
            //List_PID2(PID);     //子公司選單
            $.ajax({
                url: '0250010001.aspx/Show_PID',
                type: 'POST',
                data: JSON.stringify({ value: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //document.getElementById("Label1").innerHTML = obj.data[0].A;
                    //List_Record(obj.data[0].A);
                    document.getElementById("New_T_ID").value = obj.data[0].A;
                    document.getElementById("New_ADDR").value = obj.data[0].B;
                    document.getElementById("New_Name").value = obj.data[0].C;
                    document.getElementById("New_MTEL").value = obj.data[0].D;
                    document.getElementById("C_Name").value = obj.data[0].E;
                }
            });
        }
        function List_PID2(PID) {    //子公司下拉
            $.ajax({
                url: '0250010001.aspx/List_PID2',
                type: 'POST',
                data: JSON.stringify({ PID: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    var $select_elem = $("#New_PID2");
                    $select_elem.chosen("destroy")
                    $select_elem.empty();
                    $select_elem.append("<option value=''>" + "請選擇" + "</option>");
                    $.each(json, function (idx, obj) {
                        $select_elem.append("<option value='" + obj.A + "'>" + obj.B + "</option>");     // 顯示客戶代碼選單
                    });
                    $select_elem.chosen(
                    {
                        width: "100%",
                        search_contains: true
                    });
                    //$('.chosen-single').css({ 'background-color': '#ffffbb' });
                }
            });
            //Show_Title();  //抓 Title 資料
        }
        function Show_PID2() {     //選子公司後抓資料
            var PID = document.getElementById("New_PID2").value;
            //List_PID2(PID);     //子公司選單
            $.ajax({
                url: '0250010001.aspx/Show_PID2',
                type: 'POST',
                data: JSON.stringify({ value: PID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //document.getElementById("Label1").innerHTML = obj.data[0].A;
                    //List_Record(obj.data[0].A);
                    document.getElementById("New_T_ID").value = obj.data[0].A;
                    document.getElementById("New_ADDR").value = obj.data[0].B;
                    document.getElementById("New_Name").value = obj.data[0].C;
                    document.getElementById("New_MTEL").value = obj.data[0].D;
                }
            });
        }
        function List_Agent(Team) {
            var $select_elem = $("#New_Agent");
            $.ajax({
                url: '0250010001.aspx/List_Agent',
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
            Show_Title();  //抓 Title 資料
        }
        /*function Change_Team() {  //選部門後換下拉員工
            var str_value = document.getElementById("New_Team").value;
            List_Agent(str_value, "");
        }   //*/
        function Open_Month(ID) {  //各月份產單的判定
            var Flag = document.getElementById("Checkbox" + ID).checked;
            //alert('ID=' + ID + '  a=' + Flag);
            $.ajax({
                url: '0250010002.aspx/Open_Month',
                type: 'POST',
                data: JSON.stringify({ id: ID, Flag: Flag }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        //List_Location();
                    }
                    //alert(json.status);
                }
            });//*/
        };
        function Set_Month(Flag) {
            //alert("Flag = "+Flag);
            var CycleTime = document.getElementById("New_CycleTime").value;
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
            else {
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
    </script>
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

        #data td:nth-child(8), #data td:nth-child(7), #data td:nth-child(6),
        #data td:nth-child(5), #data td:nth-child(4), #data td:nth-child(3),
        #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }

        #img_MAP {
            position: absolute;
            border: 1px solid black;
        }

        .drag {
            width: 50px;
            height: 50px;
            top: 0px;
            left: 0px;
            cursor: pointer;
            z-index: 2;
        }
    </style>
    <!--===================================================-->
    <div style="width: 800px; margin: 10px 20px" hidden="hidden">
        <h2><strong>
            <label id="txt_title">巡查地點：</label>
        </strong></h2>
        <!-- ========================================== -->
        <div id="MAP" style="height: 600px; width: 800px;">
            <img src="Patrol_System/NULL.png" />
        </div>
        <div style="height: 20px;"></div>
        <div>

            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center" colspan="4">
                            <span style="font-size: 20px"><strong>巡檢地圖設定</strong></span>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th style="text-align: center;">巡檢地圖</th>
                        <th colspan="3">
                            <input type="file" id="myFile" name="myFile" runat="server" />
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center;">地圖上傳</th>
                        <th>
                            <button type="button" class="btn btn-info btn-lg" runat="server">
                                <span class="glyphicon glyphicon-picture"></span>&nbsp;&nbsp;巡檢地圖上傳</button>
                        </th>

                        <th style="text-align: center;">檢查點位置</th>
                        <th>
                            <button type="button" class="btn btn-primary btn-lg" onclick="Get_Location()"><span class="glyphicon glyphicon-map-marker"></span>&nbsp;&nbsp;檢查點位置修改</button>
                        </th>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div style="width: 1200px; margin: 10px 20px">
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>維護設定&nbsp;&nbsp;
                        <label id="Lab_SYSID"></label></strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <th style="text-align: center; width: 15%">
                        <strong>客戶名稱</strong>
                    </th>
                    <th style="width: 35%">
                        <select id="New_PID" name="New_PID" class="form-control" style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" onchange="Show_PID()">
                            <option value="">請選擇客戶…</option>
                        </select>
                    </th>
                    <!--<th style="text-align: center; width: 15%">
                        <strong>子公司名稱</strong>
                    </th>
                    <th style="width: 35%">
                        <select id="New_PID2" name="New_PID2" class="form-control" style="width: 100%; Font-Size: 18px;" onchange="Show_PID2()">
                            <option value="">請選擇子公司…</option>
                        </select>
                    </th>
                </tr>
                <tr style="height: 55px;">-->
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
                        <select id="New_CycleTime" name="New_CycleTime" class="form-control" onchange="Set_Month('1')"
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
                <tr>
                    <th style="text-align: center;" colspan="3">
                        <button type="button" class="btn btn-success btn-lg" onclick="Update_Title()">
                            <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;修改設定</button>
                    </th>
                    <th style="text-align: center;">
                        <button type="button" class="btn btn-default btn-lg" id="" onclick="history.back();">
                            <span class="glyphicon glyphicon-share-alt"></span>&nbsp;&nbsp;返回</button>
                    </th>
                </tr>
                <tr style="height: 55px;">
                    <th style="text-align: center;">
                        <strong>維護月份</strong>
                    </th>
                </tr>
                <tr style="height: 55px;">
                    <td colspan="4" style="text-align: center;">
                                        <strong>一月</strong>
                        <input id='Checkbox1' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(1);"/>&nbsp;<!--   onclick="CheckFlag();"  Open_Flag(   -->
                                        <strong>二月</strong>
                        <input id='Checkbox2' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(2);"/>&nbsp;
                                        <strong>三月</strong>
                        <input id='Checkbox3' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(3);"/>&nbsp;
                                        <strong>四月</strong>
                        <input id='Checkbox4' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(4);"/>&nbsp;
                                        <strong>五月</strong>
                        <input id='Checkbox5' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(5);"/>&nbsp;
                                        <strong>六月</strong>
                        <input id='Checkbox6' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(6);"/>&nbsp;
                                        <strong>七月</strong>
                        <input id='Checkbox7' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(7);"/>&nbsp;
                                        <strong>八月</strong>
                        <input id='Checkbox8' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(8);"/>&nbsp;
                                        <strong>九月</strong>
                        <input id='Checkbox9' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(9);"/>&nbsp;
                                        <strong>十月</strong>
                        <input id='Checkbox10' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(10);"/>&nbsp;
                                        <strong>十一月</strong>
                        <input id='Checkbox11' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(11);"/>&nbsp;
                                        <strong>十二月</strong>
                        <input id='Checkbox12' type='checkbox' style='width: 30px; height: 30px;' onclick="Open_Month(12);"/>
                    </td>
                </tr>
            </tbody>
        </table>
        <!--<table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center" colspan="4">
                            <span style="font-size: 20px"><strong>維護設定</strong></span>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr style="height: 55px;">
                        <th style="text-align: center; width: 15%">
                            <strong>巡查地點</strong>
                        </th>
                        <th style="width: 35%">
                            <input id="New_Location" class="form-control" value="" maxlength="15" onkeyup="cs(this);"
                                style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;" />
                        </th>
                        <th style="text-align: center; width: 15%">
                            <strong>巡查週期</strong></th>
                        <th style="width: 35%">
                            <select id="New_CycleTime" name="" class="form-control"
                                style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;">
                                <option value="">請選擇巡查週期…</option>
                                <option value="0">單月</option>
                                <option value="1">雙月</option>
                                <option value="2">季</option>
                                <option value="3">半年</option>
                            </select>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center; width: 15%">
                            <strong>起始時間</strong>
                        </th>
                        <th style="width: 35%">
                            <div class='input-group date'>
                                <input type="text" class="form-control" id="New_StartTime" name="New_StartTime"
                                    style="Font-Size: 18px; background-color: #ffffbb" />
                                <span class="input-group-addon">
                                    <span class="glyphicon glyphicon-time"></span>
                                </span>
                            </div>
                        </th>
                        <th style="text-align: center; width: 15%">
                            <strong>結束時間</strong>
                        </th>
                        <th style="width: 35%">
                            <div class='input-group date'>
                                <input type="text" class="form-control" id="New_EndTime" name="New_EndTime"
                                    style="Font-Size: 18px; background-color: #ffffbb" />
                                <span class="input-group-addon">
                                    <span class="glyphicon glyphicon-time"></span>
                                </span>
                            </div>
                        </th>
                    </tr>
                    <tr style="height: 55px;">
                        <th style="text-align: center;">
                            <strong>人員部門</strong>
                        </th>
                        <th>
                            <select id="New_Team" name="New_Team" class="form-control" onchange="Change_Team()"
                                style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;">
                                <option value="">請選擇部門…</option>
                            </select></th>
                        <th style="text-align: center;">
                            <strong>巡查人員</strong>
                        </th>
                        <th>
                            <select id="New_Agent" name="New_Agent" class="form-control"
                                style="width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;">
                                <option value="">請選擇檢查人員…</option>
                            </select>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center; width: 50%; height: 55px;" colspan="4">
                            <button type="button" class="btn btn-primary btn-lg" onclick="Update_Title()">
                                <span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改巡檢設定</button>
                        </th>
                    </tr>
            </table>
        </div>-->

        <div style="height: 20px;"></div>
        <div class="tabbable" id="table_madal">
        </div>
    </div>
    <script type="text/javascript">
        $.datetimepicker.setLocale('ch');
        $('#New_StartTime,#New_EndTime').datetimepicker({
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
    </script>
</asp:Content>
