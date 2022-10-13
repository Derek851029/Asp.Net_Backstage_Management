<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="~/0250010004.aspx.cs" Inherits="_0250010004" %>

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
        var SYSID = '<%= Session["SYSID"] %>';
        $(function () {
            //Get_Title();  //傳圖與巡邏點
            //List_PID(); //抓公司下拉
            //List_PID2(0);

            Load();   //讀取維護單資料
            Creat_Table();  //  創建 12個 問題選單頁面
            //Show_Title();  //抓 Title 資料
            //alert(SYSID);
        });

        //================ 讀取資訊 ===============
        function Load() {
            if (SYSID == '0') {
                alert("維護單編號錯誤");
                window.location.href = "/0030010000/0030010008.aspx?view=0";
            } else {
                document.getElementById("str_sysid").innerHTML = SYSID;
                $.ajax({
                    url: '0250010004.aspx/Load_Data',
                    type: 'POST',
                    data: JSON.stringify({ Case_ID: SYSID }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",       //如果要回傳值，請設成 json
                    success: function (doc) {
                        var text = '{"data":' + doc.d + '}';
                        var obj = JSON.parse(text);

                        document.getElementById("Creat_Agent").innerHTML = obj.data[0].A;
                        document.getElementById("LoginTime").innerHTML = obj.data[0].B;
                        //document.getElementById("Title_ID").innerHTML = obj.data[0].C;
                        document.getElementById("T_ID").innerHTML = obj.data[0].D;
                        document.getElementById("ADDR").innerHTML = obj.data[0].E;
                        document.getElementById("Name").innerHTML = obj.data[0].F;
                        document.getElementById("MTEL").innerHTML = obj.data[0].G;
                       
                            switch (obj.data[0].H)
                            {
                                case "0": document.getElementById("CycleTime").innerHTML = "單月";
                                    break;
                                case "1": document.getElementById("CycleTime").innerHTML = "雙月";
                                    break;
                                case "2": document.getElementById("CycleTime").innerHTML = "每季";
                                    break;
                                case "3": document.getElementById("CycleTime").innerHTML = "半年";
                                    break;
                                case "4": document.getElementById("CycleTime").innerHTML = "每年";
                                    break;
                                case "5": document.getElementById("CycleTime").innerHTML = "不維護";
                                    break;
                                default:                                   
                                    break;
                            };
                        //document.getElementById("CycleTime").innerHTML = obj.data[0].H;
                        document.getElementById("Agent").innerHTML = obj.data[0].I;
                        document.getElementById("OnSpotTime").innerHTML = obj.data[0].J;
                        document.getElementById("Type").innerHTML = obj.data[0].K;
                        document.getElementById("ReachTime").innerHTML = obj.data[0].L;
                        document.getElementById("FinishTime").innerHTML = obj.data[0].M;
                        document.getElementById("Title_Name").innerHTML = obj.data[0].N;
                        //alert("U_ID=" + obj.data[0].U_ID + "  O=" + obj.data[0].O)    //登入者檢查
                        if (obj.data[0].O != obj.data[0].U_ID) {
                            document.getElementById('Button1').style.display = "none";
                            document.getElementById('Button2').style.display = "none";
                            document.getElementById('Button3').style.display = "none";
                        }   
                        if (obj.data[0].K == "未到點") {
                            document.getElementById('Button2').style.display = "none";
                            document.getElementById('Button3').style.display = "none";
                        }
                        else if (obj.data[0].K == "維護中") {
                            document.getElementById('Button1').style.display = "none";
                        }
                        else {
                            document.getElementById('Button1').style.display = "none";
                            document.getElementById('Button2').style.display = "none";
                            document.getElementById('Button3').style.display = "none";
                        }
                    }
                });
                $("#Div_Loading").modal('hide');        // 讀取中 圖示
            }
        }

        //======================================
        //  讀取 巡查設定
        function Get_Title() {      //沒在用
            $("#MAP div[id='MAP']").remove();
            $.ajax({
                url: '0250010004.aspx/Get_Title',
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
            var str_PID = document.getElementById("New_PID").value;
            var str_PID2 = document.getElementById("New_PID2").value;
            var str_T_ID = document.getElementById("New_T_ID").value;
            var str_ADDR = document.getElementById("New_ADDR").value;
            var str_Name = document.getElementById("New_Name").value;
            var str_MTEL = document.getElementById("New_MTEL").value;
            var str_CycleTime = document.getElementById("New_CycleTime").value;
            var str_Agent = document.getElementById("New_Agent").value;
            $.ajax({
                url: '0250010004.aspx/Update_Title',
                type: 'POST',
                data: JSON.stringify({
                    PID: str_PID,
                    PID2: str_PID2,
                    T_ID: str_T_ID,
                    ADDR: str_ADDR,
                    Name: str_Name,
                    MTEL: str_MTEL,
                    CycleTime: str_CycleTime,
                    Agent: str_Agent
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
                                 "<th style='width: 75%'>" +
                                //"<input id='title_" + b + "' class='form-control' value='' maxlength='25' onkeyup='cs(this);'" +
                                //"style='width: 100%; Font-Size: 18px; background-color: #ffffbb; color: #333333;' />" +
                                "<label id='title_" + b + "' Font-Size: 18px;></label>" +
                                 "</th>" +
                                 "</tr>";
                //=====================================================================

                //======= 五個題目 =======
                var q = 1;
                for (q = 1; q < 6; q++) {
                    tab += "<tr>" +
                                   "<th style='text-align: center; width: 25%; height: 55px;'><strong>" + q + ". 檢查內容</strong></th>" +
                                   "<th style='width: 75%' title='檢查內容'>" +
                                   //"<label id='txt_" + b + q + "' Font-Size: 18px;></label>" +
                                   "<textarea id='txt_" + b + q + "' class='form-control' cols='100' rows='3' value='' maxlength='500' onkeyup='' " +  //cs(this);
                                   " placeholder='無' style='max-width: 100%; width: 100%; Font-Size: 18px;' ></textarea> " +
                                   "</th>" +
                                   "</tr>" +
                                   //=====================================================================
                                   "<tr hidden='hidden'>" + //
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
                                   "</tr>" +    //*/
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
                    //"<th style='text-align: center; width: 50%; height: 55px;' colspan='4'>" +
                    //"<button type='button' class='btn btn-primary btn-lg' onclick=Update_Answers('" + b + "')>" +
                    //"<span class='glyphicon glyphicon-pencil'></span>&nbsp;&nbsp;紀錄 " + b + " 項目</button>" +
                    //"</th>" +
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
            Get_info(); //把資料放入 12項中
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
                url: '0250010004.aspx/Update_Location',
                type: 'POST',
                data: JSON.stringify({ Top: top_value, Left: left_value }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    alert(doc.d);
                }
            });
        }

        function Update_ALL() {
            Update_Answers('A');
            Update_Answers('B');
            Update_Answers('C');
            Update_Answers('D');
            Update_Answers('E');
            Update_Answers('F');
            Update_Answers('G');
            Update_Answers('H');
            Update_Answers('I');
            Update_Answers('J');
            Update_Answers('K');
            Update_Answers('L');
        }

        function Update_Answers(ID) {
            //alert(SYSID);
            var title = document.getElementById("title_" + ID).innerHTML;
            var question = [];
            var option = [];
            var type = [];
            var answer = [];    //
            var txt = "";
            var select = "";
            var Q = "";
            var ans = "";   //
            for (i = 1; i < 6; i++) {
                txt = document.getElementById("txt_" + ID + i).value;
                select = document.getElementById("select_" + ID + i).value;
                ans = document.getElementById("Ans_" + ID + i).value;
                /*if (ans == "其他") {
                    ans = document.getElementById("Ans_" + ID + i + "2").value;
                    alert("ans == '其他'" + ans);
                }   // 未來 維護填其他時抓字用的*/
                if (select == "1") { Q = ""; } else { Q = ""; };  //document.getElementById("Q_" + ID + i).value;
                question.push(txt);
                type.push(select);
                option.push(Q);
                answer.push(ans);
            }
            //$("#Div_Loading").modal();    //開啟轉轉圖
            $.ajax({
                url: '0250010004.aspx/Update_Answers',
                type: 'POST',
                data: JSON.stringify({ alphabet: ID, title: title, question: question, option: option, type: type, answer: answer, caseid: SYSID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        //$("#Div_Loading").modal('hide');關閉轉轉圖
                        //alert(json.status);
                    } else {
                        //$("#Div_Loading").modal('hide');
                        alert(json.status);
                    }
                }
            });
            //$("#Div_Loading").modal('hide');
        }

        function Update_Answers02(ID) {     //未來 改成一次全紀錄要用的
            //alert(SYSID);
            var title = document.getElementById("title_" + ID).innerHTML;
            var question = [12,5];
            var option = [12, 5];
            var type = [12, 5];
            var answer = [12, 5];    //
            var txt = "";
            var select = "";
            var Q = "";
            var ans = "";   //
            for (i = 1; i < 6; i++) {
                txt = document.getElementById("txt_" + ID + i).value;
                select = document.getElementById("select_" + ID + i).value;
                ans = document.getElementById("Ans_" + ID + i).value;
                if (ans == "其他") {
                    ans = document.getElementById("Ans_" + ID + i + "2").value;
                    alert("ans == '其他'" + ans);
                }
                if (select == "1") { Q = ""; } else { Q = ""; };  //document.getElementById("Q_" + ID + i).value;
                question.push(txt);
                type.push(select);
                option.push(Q);
                answer.push(ans);
            }
            //$("#Div_Loading").modal();    //開啟轉轉圖
            $.ajax({
                url: '0250010004.aspx/Update_Answers02',
                type: 'POST',
                data: JSON.stringify({ alphabet: ID, title: title, question: question, option: option, type: type, answer: answer, caseid: SYSID }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var json = JSON.parse(doc.d);
                    if (json.Flag == "1") {
                        //$("#Div_Loading").modal('hide');關閉轉轉圖
                        //alert(json.status);
                    } else {
                        //$("#Div_Loading").modal('hide');
                        alert(json.status);
                    }
                }
            });
            //$("#Div_Loading").modal('hide');
        }

        function Get_info() {   //抓項目 或新增項目
            $.ajax({
                url: '0250010004.aspx/Get_info',
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
                            document.getElementById("title_" + b).innerHTML = obj.data[i].name;
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
            //alert("測試次數");
            //Get_Ans();
        }

        function Change_Type(ID, option) {  //會執行60次
            //alert( 'ID=' +ID+', option=' + option);
            $.ajax({
                url: '0250010004.aspx/Check',
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
                        //document.getElementById("Q_" + a).innerHTML = option;
                    }
                }
            });
        }
        function Get_Ans() {   //抓項目 或新增項目
            $.ajax({
                url: '0250010004.aspx/Get_Ans',
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
                            b = obj.data[i].bit;    //讀取的英文字母
                            //======= 五個答案 =======
                            var q = 1;
                            var answer = "";
                            var a = "";
                            for (q = 1; q < 6; q++) {
                                switch (q) {
                                    case 1:
                                        answer = obj.data[i].a_1;
                                        break;
                                    case 2:
                                        answer = obj.data[i].a_2;
                                        break;
                                    case 3:
                                        answer = obj.data[i].a_3;
                                        break;
                                    case 4:
                                        answer = obj.data[i].a_4;
                                        break;
                                    default:
                                        answer = obj.data[i].a_5;
                                }
                                a = b + q;
                                document.getElementById("Ans_" + a).value = answer;
                            }
                            //======= 五個題目 =======
                        }
                    }
                }
            })
        }

        function From_Add(ID, type) {
            //alert("From_Add  ID = " + ID + ", type = " + type);
            var a = "<div id='" + ID + "_2'>"
            if (type == 0) {
                a +=
                    "<th style='text-align: center;'>" +
                    "<select id='Ans_" + ID + "' class='form-control' value='' ; " + //onchange=Change_Type('" + b + q + "',0) 
                    " style='Font-Size: 18px; background-color: #ffffbb;' >" +
                    "<option value=''>請選擇</option>" +
                    "<option value='正常'>正常</option>" +
                    "<option value='異常'>異常</option>" +
                    "<option value='無此設備/機能'>無此設備/機能</option>" +
                    "</select></th>" +
                    "</tr>";

                    /*"<th style='text-align: center;'>" +
                    "<select id='Ans_" + ID + "' class='form-control' value='' ; " + //onchange=Change_Type('" + b + q + "',0) 
                    " style='Font-Size: 38px; background-color: #ffffbb;' >" +
                    "<option value=''>請選擇</option>" +
                    "<option value='正常'>正常</option>" +
                    "<option value='異常'>異常</option>" +
                    "<option value='無此設備/機能'>無此設備/機能</option>" +
                    "</select></th>" +
                    "</tr>";//*/
            }
            else if (type == 1)
            {
                a += "<div style='float: left' data-toggle='tooltip' title='不能超過200 個字'> " +
                    "<textarea id='Ans_" + ID + "' name='Ans_" + ID + "' class='form-control' cols='100' rows='3' placeholder='填寫內容' maxlength='200' onkeyup='' " +
                    "style='resize: none; background-color: #ffffbb'></textarea></div>";
            }
            else if (type == 2) {
                a +=
                    "<th style='text-align: center;'>" +
                    "<select id='Ans_" + ID + "' class='form-control' value='' ; " + //onchange=Change_Type('" + b + q + "',0) 
                    " style='Font-Size: 18px; background-color: #ffffbb;' >" +
                    "<option value=''>請選擇</option>" +
                    "<option value='正常'>正常</option>" +
                    "<option value='異常'>異常</option>" +
                    "</select></th>" +
                    "</tr>";
            }
            else if (type == 3) {
                a +=
                    "<th style='text-align: center;'>" +
                    "<select id='Ans_" + ID + "' class='form-control' value='' ; " + //onchange=Change_Type('" + b + q + "',0) 
                    " style='Font-Size: 18px; background-color: #ffffbb;' >" +
                    "<option value=''>請選擇</option>" +
                    "<option value='UPS'>UPS</option>" +
                    "<option value='SMR'>SMR</option>" +
                    "<option value='不斷電電池組'>不斷電電池組</option>" +
                    "<option value='無此設備/機能'>無此設備/機能</option>" +
                    "</select></th>" +
                    "</tr>";
            }
            else if (type == 4) {
                a +=
                    "<th style='text-align: center;'>" +
                    "<select id='Ans_" + ID + "' class='form-control' value='' ; " + //onchange=Change_Type('" + b + q + "',0) 
                    " style='Font-Size: 18px; background-color: #ffffbb;' >" +
                    "<option value=''>請選擇</option>" +
                    "<option value='已完成清潔'>已完成清潔</option>" +
                    "</select></th>" +
                    "</tr>";
            }
            else if (type == 5) {
                a +=
                    "<th style='text-align: center;'>" +
                    "<select id='Ans_" + ID + "' class='form-control' value='' ; " + //onchange=Change_Type('" + b + q + "',0) 
                    " style='Font-Size: 18px; background-color: #ffffbb;' >" +
                    "<option value=''>請選擇</option>" +
                    "<option value='保固'>保固</option>" +
                    "<option value='合約'>合約</option>" +
                    "<option value='租約'>租約</option>" +
                    "<option value='定期維護'>定期維護</option>" +
                    "<option value='其他'>其他</option>" +
                    "</select></th>" +
                    //"其他內容<input id='Ans_" + ID + "2' class='form-control' maxlength='10' " +
                    //"style='width: 50%; background-color: #ffffbb; Font-Size: 18px;' /> " +
                    "</tr>";
            }
            else {
                a +=
                    "<th style='text-align: center; hidden=hidden;'>" +
                    "<input id='Ans_" + ID + "' class='form-control' maxlength='2' type='hidden' " +
                    "style='width: 10%; background-color: #ffffbb; Font-Size: 18px;' /></th>" +
                    "</tr>";
            }
            Get_Ans2(ID, type);
            return a + "</div>";
        }
        function Get_Ans2(ID, type) {   //抓項目 或新增項目  9/14 失敗作
            var caseid = document.getElementById("str_sysid").innerHTML;    
            var num =0;
            var eng = "";
            if(ID=="A1"||ID=="B1"||ID=="C1"||ID=="D1"||ID=="E1"||ID=="F1"||ID=="G1"||ID=="H1"||ID=="I1"||ID=="J1"||ID=="K1"||ID=="L1"){
                num = 1; //alert("Get_Ans2  ID = " + ID+a);
            }
            else if(ID=="A2"||ID=="B2"||ID=="C2"||ID=="D2"||ID=="E2"||ID=="F2"||ID=="G2"||ID=="H2"||ID=="I2"||ID=="J2"||ID=="K2"||ID=="L2"){
                num = 2; //alert("Get_Ans2  ID = " + ID + a);
            }
            else if(ID=="A3"||ID=="B3"||ID=="C3"||ID=="D3"||ID=="E3"||ID=="F3"||ID=="G3"||ID=="H3"||ID=="I3"||ID=="J3"||ID=="K3"||ID=="L3"){
                num = 3; //alert("Get_Ans2  ID = " + ID+a);
            }
            else if(ID=="A4"||ID=="B4"||ID=="C4"||ID=="D4"||ID=="E4"||ID=="F4"||ID=="G4"||ID=="H4"||ID=="I4"||ID=="J4"||ID=="K4"||ID=="L4"){
                num = 4; //alert("Get_Ans2  ID = " + ID + a);
            }
            else {
                num = 5; //alert("Get_Ans2  ID = " + ID + a);
            }

            if (ID == "A1" || ID == "A2" || ID == "A3" || ID == "A4" || ID == "A5" ) {
                eng = "A";
            }
            else if (ID == "B1" || ID == "B2" || ID == "B3" || ID == "B4" || ID == "B5") {
                eng = "B";
            }
            else if (ID == "C1" || ID == "C2" || ID == "C3" || ID == "C4" || ID == "C5") {
                eng = "C";
            }
            else if (ID == "D1" || ID == "D2" || ID == "D3" || ID == "D4" || ID == "D5") {
                eng = "D";
            }
            else if (ID == "E1" || ID == "E2" || ID == "E3" || ID == "E4" || ID == "E5") {
                eng = "E";
            }
            else if (ID == "F1" || ID == "F2" || ID == "F3" || ID == "F4" || ID == "F5") {
                eng = "F";
            }
            else if (ID == "G1" || ID == "G2" || ID == "G3" || ID == "G4" || ID == "G5") {
                eng = "G";
            }
            else if (ID == "H1" || ID == "H2" || ID == "H3" || ID == "H4" || ID == "H5") {
                eng = "H";
            }
            else if (ID == "I1" || ID == "I2" || ID == "I3" || ID == "I4" || ID == "I5") {
                eng = "I";
            }
            else if (ID == "J1" || ID == "J2" || ID == "J3" || ID == "J4" || ID == "J5") {
                eng = "J";
            }
            else if (ID == "K1" || ID == "K2" || ID == "K3" || ID == "K4" || ID == "K5") {
                eng = "K";
            }
            else {
                eng = "L";
            }
            //alert("Get_Ans2  ID= " + ID + " num=" + num + " eng=" + eng);            
            $.ajax({
                url: '0250010004.aspx/Get_Ans2',
                type: 'POST',
                data: JSON.stringify({ ID: caseid, Eng: eng }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var text = '{"data":' + doc.d + '}';
                    var obj = JSON.parse(text);
                    switch (num) {
                        case 1:
                            if (type == 0)
                                style("Ans_" + ID, obj.data[0].a_1);
                            else
                                document.getElementById("Ans_" + ID).value = obj.data[0].a_1;
                            break;
                        case 2:
                            if (type == 0)
                                style("Ans_" + ID, obj.data[0].a_2);
                            else
                                document.getElementById("Ans_" + ID).value = obj.data[0].a_2;
                            break;
                        case 3:
                            if (type == 0)
                                style("Ans_" + ID, obj.data[0].a_3);
                            else
                                document.getElementById("Ans_" + ID).value = obj.data[0].a_3;
                            break;
                        case 4:
                            if (type == 0)
                                style("Ans_" + ID, obj.data[0].a_4);
                            else
                                document.getElementById("Ans_" + ID).value = obj.data[0].a_4;
                            break;
                        default:
                            //alert("Ans_" + ID + "   " + obj.data[0].a_1 + "   " + num);
                            if (type == 0)
                                style("Ans_" + ID, obj.data[0].a_5);
                            else
                                document.getElementById("Ans_" + ID).value = obj.data[0].a_5;
                    }
                }
            })//*/
        }

        function Show_Title() {
            $.ajax({
                url: '0250010004.aspx/Show_Title',
                type: 'POST',
                data: JSON.stringify({ }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    //document.getElementById("New_T_ID").value = obj.data[0].A;

                    style('New_PID', obj.data[0].A);
                    //document.getElementById("New_PID").value = '';
                    style('New_PID2', obj.data[0].B);
                    //document.getElementById("New_PID2").value = '';
                    if (obj.data[0].C == "中華電信" || obj.data[0].C == "遠傳" || obj.data[0].C == "德瑪")
                        document.getElementById("New_T_ID").value = obj.data[0].C;
                    else
                        document.getElementById("New_T_ID").value = "其他";
                    document.getElementById("New_ADDR").value = obj.data[0].D;
                    document.getElementById("New_Name").value = obj.data[0].E;
                    document.getElementById("New_MTEL").value = obj.data[0].F;
                    document.getElementById("New_CycleTime").value = obj.data[0].G;
                    document.getElementById("New_Agent").value = obj.data[0].H;
                }
            });
        }

        function Reach(Flag) {      //原 Data_Save
            //alert("A"+Flag+"A");
            var str_sysid = document.getElementById("str_sysid").innerHTML;
            //var time = document.getElementById("datetimepicker01").value;
            if (Flag == "0") {
                //alert("123");
                $.ajax({
                    url: '0250010004.aspx/Reach',
                    type: 'POST',
                    data: JSON.stringify({
                        sysid: str_sysid,
                        //time: time,
                        Flag: Flag
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var json = JSON.parse(doc.d.toString());
                        if (json.status == "reach") {
                            //alert('已登記到點');
                            window.location.href = "/0250010004.aspx?seqno=" + str_sysid;
                        }
                        else {
                            alert(json.status);
                        }
                        $("#Div_Loading").modal('hide');
                    },
                });
            }
            else if (Flag == "1") {
                Update_ALL();
                $.ajax({
                    url: '0250010004.aspx/Reach',
                    type: 'POST',
                    data: JSON.stringify({
                        sysid: str_sysid,
                        Flag: Flag
                        //time: time,
                    }),
                    contentType: 'application/json; charset=UTF-8',
                    dataType: "json",
                    success: function (doc) {
                        var json = JSON.parse(doc.d.toString());
                        if (json.status == "reach") {
                            //alert('已登記完成');
                            window.location.href = "/0250010004.aspx?seqno=" + str_sysid;
                        }
                        else {
                            alert(json.status);
                        }
                        $("#Div_Loading").modal('hide');
                    },
                });
            }
        }

        function URL2() {  //返回
            window.location.href = "/0030010000/0030010008.aspx?view=0";
        }   //*/
        function URL_Report() {  //返回
            var T_Name = document.getElementById("T_ID").innerHTML
            var seqno = document.getElementById("str_sysid").innerHTML
            //alert(seqno);
            if (T_Name == "遠傳" || T_Name == "德瑪") {
                //alert("開 FET 報表")
                window.location.href = "/Report02/Report_FET.aspx?seqno=" + seqno;
            }
            else if (T_Name == "中華電信") {
                //alert("開 中華報表")
                window.location.href = "/Report02/Report_CHT.aspx?seqno=" + seqno;
            }
            else
                alert("此維護廠商並無對應報表")
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
    <!-- ====== Loading ====== -->
    <div style="width: 1280px; margin: 10px 20px">
        <h2>
            <strong>個人維護單</strong>
            <button id='Btn_Report' type='button' class='btn btn-info btn-lg' onclick="URL_Report();" >
                <span class='glyphicon glyphicon-file'"></span>
                &nbsp;服務紀錄表預覽
            </button>
            <!--&nbsp;
            <button type='button' class='btn btn-success btn-lg' onclick="image_Click()" hidden="hidden">
                <span class='glyphicon glyphicon-picture' hidden="hidden"></span>
                &nbsp;圖片瀏覽
            </button>-->
        </h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>案件資料紀錄</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 15%;">
                        <strong>服務單編號</strong><br />   
                    </th>
                    <th style="width: 35%">
                        <label id="str_sysid"></label>
                    </th>
                    <td style="text-align: center">
                        <strong>建單人員</strong>
                    </td>
                    <td>
                        <label id="Creat_Agent" style="Font-Size: 18px;"></label>
                    </td>
                </tr>
                <tr id="tr_sysid" runat="server">
                    <td style="text-align: center">
                        <strong>建單日期</strong>
                    </td>
                    <td>
                        <label id="LoginTime" style="Font-Size: 18px;"></label>
                    </td>
                     <th style="text-align: center; width: 15%">
                        <strong>維護客戶</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="Title_Name" style="Font-Size: 18px;"></label>
                    </th>
                </tr>                
                <tr>
                    <th style="text-align: center; width: 15%">
                        <strong>維護廠商</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="T_ID" style="Font-Size: 18px;"></label>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>維護地址</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="ADDR" style="Font-Size: 18px;"></label>
                    </th>
                </tr>
                <tr>
                    <th style="text-align: center; width: 15%">
                        <strong>聯絡人</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="Name" style="Font-Size: 18px;"></label>
                    </th>
                    <th style="text-align: center; width: 15%">
                        <strong>聯絡電話</strong>
                    </th>
                    <th style="width: 35%">
                        <label id="MTEL" style="Font-Size: 18px;"></label>
                    </th>
                </tr>

                <tr>
                    <th style="text-align: center; width: 15%">
                        <strong>維護週期</strong></th>
                    <th style="width: 35%">
                        <label id="CycleTime" style="Font-Size: 18px;"></label>
                    </th>
                    <th style="text-align: center;">
                        <strong>負責工程師</strong>
                    </th>
                    <th>
                        <label id="Agent" style="Font-Size: 18px;"></label>
                    </th>
                </tr>
                <tr>
                    <th style="text-align: center; width: 15%">
                        <strong>預定維護日期</strong></th>
                    <td style="width: 35%">
                        <label id="OnSpotTime" style="Font-Size: 18px;"></label>
                    </td>
                    <th style="text-align: center; width: 15%">
                        <strong>案件狀態</strong></th>
                    <td style="width: 35%">
                        <label id="Type" style="Font-Size: 18px;"></label>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: center; width: 15%" hidden="hidden">
                        <strong>維護月份</strong></th>
                    <th style="width: 35%"hidden="hidden">
                        <input id="Months" class="form-control" value="" maxlength="20" onkeyup=";"
                            style="width: 100%; Font-Size: 18px; " />
                    </th>
                    <th style="text-align: center; width: 15%" hidden="hidden">
                        <strong>維護月份</strong></th>
                    <th style="width: 35%"hidden="hidden">
                        <input id="Text5" class="form-control" value="" maxlength="20" onkeyup=";"
                            style="width: 100%; Font-Size: 18px; " />
                    </th>
                </tr>
            </tbody>
        </table>
    </div>

    <!--=======================巡查地圖等  隱藏沒再用 到維護狀態才開始用======================-->
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
    <!--=====================維護狀態==========================-->
    <div style="width: 1280px; margin: 10px 20px">
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="4">
                        <span style="font-size: 20px"><strong>維護狀態</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr style="height: 55px;">
                    <td style="text-align: center; width: 15%">
                        <strong>到點時間</strong>
                    </td>
                    <td style="text-align: center; width: 35%">
                        <label id="ReachTime"></label>
                    </td>
                     <td style="text-align: center; width: 15%">
                        <strong>完成時間</strong>                   
                    </td>
                    <td style="text-align: center; width: 35%">
                        <label id="FinishTime"></label>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: center;"colspan="2">
                        <button type="button" class="btn btn-primary btn-lg" id="Button3" onclick="Update_ALL();">
                            <span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;所有項目紀錄</button>
                    </th>
                    <th style="text-align: center;" colspan="2">
                        <button type="button" class="btn btn-primary btn-lg " id="Button1" onclick="Reach('0');">
                            <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;到點</button>
                        <button type="button" class="btn btn-success btn-lg" id="Button2" onclick="Reach('1');">
                            <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;完成</button>
                        <button type="button" class="btn btn-default btn-lg" id="" onclick="URL2()">
                            <span class="glyphicon glyphicon-share-alt"></span>&nbsp;&nbsp;返回</button>
                    </th>
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
