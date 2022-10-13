<%@ Page Language="C#" AutoEventWireup="true" CodeFile="sign.aspx.cs" Inherits="sign_001" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../css/bootstrap.min.css" rel="stylesheet" />
    <link href="../css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="../css/bootstrap-responsive.min.css" rel="stylesheet" />
    <link href="../bootstrap-chosen-master/bootstrap-chosen.css" rel="stylesheet" />
    <link href="../DataTables/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script type="text/javascript">
        var str_CNo = '<%= seqno %>';
        //var str_view = '<%= Session["view"] %>';
        var str_sign = '<%= Session["sign"] %>';
        $(function () {
            //alert("CNo=" + str_CNo + "  Sign=" + str_sign + "  view=" + str_view);
            //Check_Sign
            Switch(str_sign)
            document.getElementById('CNo_ID').innerHTML = str_CNo;
        });

        function Check_Sign() {
            if (str_view == "1")    //結案詳情過來的看不到 返回查詢
            {
                document.getElementById('Button5').style.display = "";
            }
            else {
                document.getElementById('Button5').style.display = "none";
            }
        }

        function RE() {
            var s = document.getElementById("select_Company");
            var str_value = s.options[s.selectedIndex].value;
            window.location.href = '/Report/Report_001.aspx?seqno=' + str_CNo + '&view=' + str_view + '&company=' + str_value;
        }

        function Service_Type() {
            window.location.href = '/Report/Report_001_Picture.aspx?seqno=' + str_CNo;
        }

        function SignResult() {
            window.location.reload();
        }

        function Switch(a) {
            if (a == '1'){
                document.getElementById('Title1').innerHTML = "客戶";
                document.getElementById('sig-submitBtn').style.display = "";
                document.getElementById('sig-submitBtn2').style.display = "none";
                document.getElementById('sig-submitBtn3').style.display = "none";
                document.getElementById('sig-submitBtn5').style.display = "none";
            }
            /*else if (a == '2') {
                document.getElementById('Title1').innerHTML = "雇主";
                document.getElementById('sig-submitBtn').style.display = "none";
                document.getElementById('sig-submitBtn2').style.display = "";
                document.getElementById('sig-submitBtn3').style.display = "none";
                document.getElementById('sig-submitBtn5').style.display = "none";
            }
            else if (a == '3') {
                document.getElementById('Title1').innerHTML = "勞工";
                document.getElementById('sig-submitBtn').style.display = "none";
                document.getElementById('sig-submitBtn2').style.display = "none";
                document.getElementById('sig-submitBtn3').style.display = "";
                document.getElementById('sig-submitBtn5').style.display = "none";
            }
            else if (a == '5') {
                document.getElementById('Title1').innerHTML = "評鑑 服務人員";
                document.getElementById('sig-submitBtn').style.display = "none";
                document.getElementById('sig-submitBtn2').style.display = "none";
                document.getElementById('sig-submitBtn3').style.display = "none";
                document.getElementById('sig-submitBtn5').style.display = "";
            }//*/
        }

        function URL2() {
            $("#Div_Loading").modal();
            window.location.href = "/Report/Report_001.aspx?seqno=" + str_CNo ;
        }
        function URL3() {
            $("#Div_Loading").modal();
            window.location.href = "/Report_012.aspx";
        }

    </script>
    <style type="text/css">
        body {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 22px;
            padding-top: 20px;
            padding-bottom: 20px;
        }

        #sig-canvas {
            border: 2px dotted #CCCCCC;
            border-radius: 5px;
            cursor: crosshair;
        }
    </style>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <!-- ====== Modal ====== -->
        <div style="text-align: center; width: 970px; height: 40px">
            <h2 class="modal-title"><strong ><label id="Title1"></label>簽名板<font color="red"> (請簽在虛線框框之內)</font>
                <label id="CNo_ID" hidden="hidden"></label>
            </strong></h2>
            <div class="modal-body">
                <!-- ========================================== -->
                <div class="row" style="margin: 5px 5px">
                    <div class="col-md-12">
                        <canvas id="sig-canvas" width="900" height="360">Get a better browser, bro.
                        </canvas>
                    </div>
                </div>
                <div class="row" style="text-align: center; height: 40px">
                    <div class="col-md-12">
                        <button type="button" class="btn btn-primary btn-lg" id="sig-submitBtn" hidden="hidden">客戶簽名完成</button>&nbsp;&nbsp;
                                <button type="button" class="btn btn-primary btn-lg" id="sig-submitBtn2" hidden="hidden">雇主簽名完成</button>&nbsp;&nbsp;
                                <button type="button" class="btn btn-primary btn-lg" id="sig-submitBtn3" hidden="hidden">勞工簽名完成</button>&nbsp;&nbsp;
                                <button type="button" class="btn btn-primary btn-lg" id="sig-submitBtn5" hidden="hidden">評鑑 服務簽名完成</button>&nbsp;&nbsp;
                                <button type="button" class="btn btn-default btn-lg" id="sig-clearBtn">重新簽名</button>&nbsp;&nbsp;
                                <button type="button" class="btn btn-default btn-lg" id="sig-close" onclick="URL2()">關閉簽名板</button>
                    </div>
                </div>
                <!-- ========================================== -->
            </div>
        </div>
        <!-- ====== Modal ====== -->
        <!--
        <div>
            &nbsp;&nbsp;&nbsp;
            仲介公司：                       
            <select id="select_Company" name="select_Company" class="chosen-select" style="width: 25%">
                <option value="">請選擇仲介公司…</option>
            </select>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <button id="Btn_Refresh" type="button" onclick="RE();" class="btn btn-success btn-lg ">
                  <span class="glyphicon glyphicon-refresh"></span>
                  &nbsp;&nbsp;重新產生表單
              </button><br />
            &nbsp;&nbsp;&nbsp;
            <button id="Button1" type="button" class="btn btn-primary btn-lg " data-toggle="modal" data-target="#Div_Signature" onclick="Switch('1')"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;服務人員簽名</button>&nbsp;&nbsp;
            <button id="Button2" type="button" class="btn btn-primary btn-lg " data-toggle="modal" data-target="#Div_Signature" onclick="Switch('2')"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;雇主簽名</button>&nbsp;&nbsp;
            <button id="Button3" type="button" class="btn btn-primary btn-lg " data-toggle="modal" data-target="#Div_Signature" onclick="Switch('3')"><span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;勞工簽名</button>&nbsp;&nbsp;
            <button id="Button4" type="button" class="btn btn-default btn-lg " data-toggle="modal" data-target="" onclick="URL2()"><span class="glyphicon glyphicon-share-alt"></span>&nbsp;&nbsp;返回詳情</button>
            <button id="Button5" type="button" class="btn btn-default btn-lg " data-toggle="modal" data-target="" onclick="URL3()" ><span class="glyphicon glyphicon-share-alt" ></span>&nbsp;&nbsp;返回查詢</button>
            <%--<button id="Button1" type="button" onclick="Service_Type();" class="btn btn-primary btn-lg "><span class="glyphicon glyphicon-search"></span>&nbsp;&nbsp;電子簽核表單</button>--%>
        </div>
        <br />
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server" />
            <rsweb:ReportViewer ID="rptviewer" runat="server" Width="100%" Height="2000px" />
        </div>-->
        <script>
            $(function () {

                // Get a regular interval for drawing to the screen
                window.requestAnimFrame = (function (callback) {
                    return window.requestAnimationFrame ||
                                window.webkitRequestAnimationFrame ||
                                window.mozRequestAnimationFrame ||
                                window.oRequestAnimationFrame ||
                                window.msRequestAnimaitonFrame ||
                                function (callback) {
                                    window.setTimeout(callback, 1000 / 100);//1000 /120
                                };
                })();

                // Set up the canvas
                var canvas = document.getElementById("sig-canvas");
                var ctx = canvas.getContext("2d");
                ctx.fillStyle = "white";
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                ctx.strokeStyle = "#222222";
                ctx.lineWidth = 2;

                // Set up the UI
                var clearBtn = document.getElementById("sig-clearBtn");
                clearBtn.addEventListener("click", function (e) {
                    clearCanvas();
                }, false);

                //========================================
                
                var submitBtn = document.getElementById("sig-submitBtn");
                submitBtn.addEventListener("click", function (e) {
                    var Pic = canvas.toDataURL("image/png");
                    var CNo = document.getElementById("CNo_ID").innerHTML;
                    Pic = Pic.replace(/^data:image\/(png|jpg);base64,/, "")
                    $.ajax({
                        type: 'POST',
                        url: 'sign.aspx/UploadPic',
                        //data: '{ "imageData" : "' + Pic + '" }',
                        data: '{ "imageData" : "' + Pic + '", "CNo" : "' + CNo + '" }',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function (doc) {
                            var json = JSON.parse(doc.d.toString());
                            if (json.flag == "0") {
                                alert("簽名完成。");
                                window.location.href = json.txt;
                            } else { alert(json.txt); }
                        }
                    });
                }, false
                );
                var submitBtn_2 = document.getElementById("sig-submitBtn2");
                submitBtn_2.addEventListener("click", function (e) {
                    var Pic = canvas.toDataURL("image/png");
                    var CNo = document.getElementById("CNo_ID").innerHTML;
                    Pic = Pic.replace(/^data:image\/(png|jpg);base64,/, "")
                    $.ajax({
                        type: 'POST',
                        url: 'sign.aspx/UploadPic2',
                        //data: '{ "imageData" : "' + Pic + '" }',
                        data: '{ "imageData" : "' + Pic + '", "CNo" : "' + CNo + '" }',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function (doc) {
                            var json = JSON.parse(doc.d.toString());
                            if (json.flag == "0") {
                                alert("簽名完成。");
                                window.location.href = json.txt;
                            } else { alert(json.txt); }
                        }
                    });
                }, false
                );
                var submitBtn_3 = document.getElementById("sig-submitBtn3");
                submitBtn_3.addEventListener("click", function (e) {
                    var Pic = canvas.toDataURL("image/png");
                    var CNo = document.getElementById("CNo_ID").innerHTML;
                    Pic = Pic.replace(/^data:image\/(png|jpg);base64,/, "")
                    $.ajax({
                        type: 'POST',
                        url: 'sign.aspx/UploadPic3',
                        data: '{ "imageData" : "' + Pic + '", "CNo" : "' + CNo + '" }',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function (doc) {
                            var json = JSON.parse(doc.d.toString());
                            if (json.flag == "0") {
                                alert("簽名完成。");
                                window.location.href = json.txt;
                            } else { alert(json.txt); }
                        }
                    });
                }, false
                );
                var submitBtn_5 = document.getElementById("sig-submitBtn5");
                submitBtn_5.addEventListener("click", function (e) {
                    var Pic = canvas.toDataURL("image/png");
                    var CNo = document.getElementById("CNo_ID").innerHTML;
                    Pic = Pic.replace(/^data:image\/(png|jpg);base64,/, "")
                    $.ajax({
                        type: 'POST',
                        url: 'sign.aspx/UploadPic5',
                        data: '{ "imageData" : "' + Pic + '", "CNo" : "' + CNo + '" }',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function (doc) {
                            var json = JSON.parse(doc.d.toString());
                            if (json.flag == "0") {
                                alert("簽名完成。");
                                window.location.href = json.txt;
                            } else { alert(json.txt); }
                        }
                    });
                }, false
                );
                //====================================================================

                var drawing = false;
                var mousePos = { x: 0, y: 0 };
                var lastPos = mousePos;
                canvas.addEventListener("mousedown", function (e) { drawing = true; lastPos = getMousePos(canvas, e); }, false);
                canvas.addEventListener("mouseup", function (e) { drawing = false; }, false); canvas.addEventListener("mousemove", function (e) { mousePos = getMousePos(canvas, e); }, false);
                canvas.addEventListener("touchstart", function (e) {
                    mousePos = getTouchPos(canvas, e); var touch = e.touches[0]; var mouseEvent = new MouseEvent("mousedown", { clientX: touch.clientX, clientY: touch.clientY });
                    canvas.dispatchEvent(mouseEvent);
                }, false);
                canvas.addEventListener("touchend", function (e) { var mouseEvent = new MouseEvent("mouseup", {}); canvas.dispatchEvent(mouseEvent); }, false);
                canvas.addEventListener("touchmove", function (e) {
                    var touch = e.touches[0]; var mouseEvent = new MouseEvent("mousemove", { clientX: touch.clientX, clientY: touch.clientY });
                    canvas.dispatchEvent(mouseEvent);
                }, false);

                // Prevent scrolling when touching the canvas
                document.body.addEventListener("touchstart", function (e) {
                    if (e.target == canvas) {
                        e.preventDefault();
                    }
                }, false);
                document.body.addEventListener("touchend", function (e) {
                    if (e.target == canvas) {
                        e.preventDefault();
                    }
                }, false);
                document.body.addEventListener("touchmove", function (e) {
                    if (e.target == canvas) {
                        e.preventDefault();
                    }
                }, false);

                // Get the position of the mouse relative to the canvas
                function getMousePos(canvasDom, mouseEvent) {
                    var rect = canvasDom.getBoundingClientRect();
                    return {
                        x: mouseEvent.clientX - rect.left,
                        y: mouseEvent.clientY - rect.top
                    };
                }

                // Get the position of a touch relative to the canvas
                function getTouchPos(canvasDom, touchEvent) {
                    var rect = canvasDom.getBoundingClientRect();
                    return {
                        x: touchEvent.touches[0].clientX - rect.left,
                        y: touchEvent.touches[0].clientY - rect.top
                    };
                }

                // Draw to the canvas
                function renderCanvas() {
                    if (drawing) {
                        ctx.moveTo(lastPos.x, lastPos.y);
                        ctx.lineTo(mousePos.x, mousePos.y);
                        ctx.stroke();
                        lastPos = mousePos;
                    }
                }

                function clearCanvas() {
                    canvas.width = canvas.width;
                    ctx.fillStyle = "white";
                    ctx.fillRect(0, 0, canvas.width, canvas.height);
                    ctx.strokeStyle = "#222222";
                    ctx.lineWidth = 2;
                }

                // Allow for animation
                (function drawLoop() {
                    requestAnimFrame(drawLoop);
                    renderCanvas();
                })();

            });

        </script>
    </form>
</body>
</html>
