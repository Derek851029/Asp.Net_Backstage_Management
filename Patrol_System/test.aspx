<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="Update" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script type="text/javascript">
        var year = 11;
        var str_start_salary = "";
        var str_bonus = "";
        var str_month = "";
        var str_year = "";
        var txt_Show = "";
        var food_buffet = "";
        var Space = "";

        function TEST() {
            txt_Show = "";
            str_start_salary = Number(document.getElementById("txt_Start_Salary").value);
            str_bonus = Number(document.getElementById("txt_Bonus").value) + 100;
            str_month = Number(document.getElementById("txt_Month").value);
            console.log(str_start_salary + str_start_salary)
            console.log(str_start_salary * (str_bonus / 100))
            for (i = 1; i < year; i++) {
                Space = "";
                if (i < 10) {
                    Space = "0";
                }
                str_year = Math.round(str_start_salary) * str_month;
                food_buffet = Math.round(Number(str_year) / 75);
                txt_Show += "<br/>" + "第 " + Space + i + " 年【月薪：" + Math.round(str_start_salary) + "，年薪：" + str_year + "】" + "約 " + food_buffet + " 個７５元便當";
                str_start_salary = Math.round(str_start_salary) * (str_bonus / 100);
            }

            document.getElementById("txt_Show").innerHTML = txt_Show;
        };
    </script>
    <style type="text/css">
        body {
            font-family: "Microsoft JhengHei",Helvetica,Arial,Verdana,sans-serif;
            font-size: 16px;
        }

        #IMG_1 {
            position: absolute;
            top: 20px;
            left: 100px;
            width: 800px;
            height: 600px;
            z-index: 2;
        }

        #IMG_2 {
            position: absolute;
            top: 20px;
            left: 100px;
            width: 800px;
            height: 600px;
            z-index: 1;
        }

        #IMG_3 {
            top: 175px;
            left: 175px;
            position: absolute;
            z-index: 3;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <table style="margin: 10px 10px">
            <thead>
                <tr>
                    <th>
                        <img src="004.png" id="IMG_2" />
                        <img src="5.png" id="IMG_3" />
                        <label id="IMG_4">ｏ</label>
                    </th>
                </tr>
                <tr>
                    <th style="text-align: center; height: 700px;"></th>
                </tr>
            </thead>
        </table>
        <table class="" style="width: 1024px; margin: 10px 20px">
            <thead>
                <tr>
                    <th style="text-align: center" colspan="1">
                        <span style="font-size: 24px"><strong>年薪計算機</strong></span>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th style="text-align: center; width: 50%">起薪　　　　　：
                        <input type="text" id="txt_Start_Salary" name="txt_Start_Salary" class="form-control" placeholder="起薪" style="Font-Size: 18px;" />
                    </th>
                </tr>
                <tr>
                    <th style="text-align: center; width: 50%">加薪幅度（％）：
                        <input type="text" id="txt_Bonus" name="txt_Bonus" class="form-control" placeholder="加薪幅度（％）" style="Font-Size: 18px;" />
                    </th>
                </tr>
                <tr>
                    <th style="text-align: center; width: 50%">年薪幾個月　　：
                        <input type="text" id="txt_Month" name="txt_Month" class="form-control" placeholder="年薪幾個月" style="Font-Size: 18px;" />
                    </th>
                </tr>
                <tr>
                    <th>
                        <button id="OK" type="button" onclick="TEST()">計算</button>
                    </th>
                </tr>
                <tr>
                    <th>＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
                        <label id="txt_Show"></label>
                    </th>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
