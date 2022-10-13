<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Image_Load.aspx.cs" Inherits="Report_Image_Load" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <link href="../css/bootstrap.min.css" rel="stylesheet" />
    <link href="../css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="../css/bootstrap-responsive.min.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            Load();
        });

        function Load() {
            $.ajax({
                url: 'Image_Load.aspx/Load',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    var obj = JSON.parse('{"data":' + doc.d + '}'); // 組合JSON 格式
                    if (obj.data[0].flag == "0") {
                        document.getElementById("table_image").innerHTML = obj.data[0].value;
                    }
                }
            });
        }

        function Back() {
            $.ajax({
                url: 'Image_Load.aspx/Back',
                type: 'POST',
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",
                success: function (doc) {
                    location.href = doc.d;
                }
            });
        }

        function image_List(id) {
            var a = document.getElementById("show_image");
            var b = document.getElementById("P_" + id);
            a.src = b.src;
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

        #data td:nth-child(7), #data td:nth-child(6), #data td:nth-child(5), #data td:nth-child(4),
        #data td:nth-child(3), #data td:nth-child(2), #data td:nth-child(1), #data th:nth-child(5) {
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- ====== Modal ====== -->
        <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog" style="width: 95%;">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-body">
                        <img id="show_image" src="../Patrol_System/NULL.png" style="text-align: center; width: 100%;" class="img-thumbnail" />
                    </div>
                </div>
            </div>
            <!-- Modal content-->
        </div>
        <!-- ====== Modal ====== -->
        <div style="width: 95%; margin: 10px 20px">
            <h2><strong>派工單服務上傳圖片（瀏覽）&nbsp;&nbsp;
                <button type="button" class="btn btn-default btn-lg" style="Font-Size: 20px;" onclick="Back()">
                    <span class='glyphicon glyphicon-arrow-left'></span>&nbsp;&nbsp;返回
                </button>
            </strong></h2>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th style="text-align: center">
                            <span style="font-size: 20px"><strong>圖片（瀏覽）</strong></span>
                        </th>
                    </tr>
                </thead>
                <tbody id="table_image">
                    <tr>
                        <th style="text-align: center; width: 100%;">
                            <img src="../Patrol_System/NULL.png" style="text-align: center; width: 24%;" class="img-thumbnail" data-toggle="modal" data-target="#myModal" />
                            <img src="../Patrol_System/NULL.png" style="text-align: center; width: 24%;" class="img-thumbnail" data-toggle="modal" data-target="#myModal" />
                            <img src="../Patrol_System/NULL.png" style="text-align: center; width: 24%;" class="img-thumbnail" data-toggle="modal" data-target="#myModal" />
                            <img src="../Patrol_System/NULL.png" style="text-align: center; width: 24%;" class="img-thumbnail" data-toggle="modal" data-target="#myModal" />
                        </th>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
