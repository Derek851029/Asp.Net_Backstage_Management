<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../js/notiflix.js"></script>
    <link href="../js/notiflix.css" rel="stylesheet" />
    <script src="../fullcalendar-2.8.0/lib/moment.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/rowreorder/1.2.8/js/dataTables.rowReorder.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.2.9/js/dataTables.responsive.min.js"></script>
    <link href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/rowreorder/1.2.8/css/rowReorder.dataTables.min.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/responsive/2.2.9/css/responsive.dataTables.min.css" rel="stylesheet" />
    <%--<script src="2021_case/0010010005.js"></script>--%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <table id="dataTable_Case" class="display nowrap">
        <thead>
            <tr>
                <th style="text-align:center;">案件編號</th>
                <th style="text-align:center;">案件名稱</th>
                <th style="text-align:center;">客戶名稱</th>
                <th style="text-align:center;">客戶窗口</th>
                <th style="text-align:center;">窗口電話</th>
                <th style="text-align:center;">負責人</th>
                <th style="text-align:center;">創建日期</th>
                <th style="text-align:center;">案件狀態</th>
                <th style="text-align:center;">查詢</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>2</td>
                <td>2</td>
                <td>2</td>
                <td>2</td>
                <td>Tiger Nixon</td>
                <td>System Architect</td>
                <td>Edinburgh</td>
                <td>2011/04/25</td>
                <td>$320,800</td>
            </tr>
        </tbody>
    </table>
    
    <script type="text/javascript">
        var seqno = '<%= seqno %>';
        $(function () {
            $(document).ready(function () {
                bindtable("", "", "");

                var table2 = $('#example').DataTable({
                    rowReorder: {
                        selector: 'td:nth-child(2)'
                    },
                    responsive: true
                });
                
                var table = $('#dataTable_Case').DataTable({
                    rowReorder: {
                        selector: 'td:nth-child(2)'
                    },
                    responsive: true
                });
            });
        })
        function bindtable(Start_Date, End_Date, Personel) {
            $.ajax({
                url: '2021_case/0010010005.aspx/bindtable',
                type: 'POST',
                data: JSON.stringify({
                    Start_Date: Start_Date,
                    End_Date: End_Date,
                    Personel: Personel,
                }),
                contentType: 'application/json; charset=UTF-8',
                dataType: "json",       //如果要回傳值，請設成 json
                success: function (doc) {
                    //let data = eval(doc.d)
                    //let data_array = [];
                    //$.each(data, function (index, value) {
                    //    let location = data_array.indexOf(value.SYSID)
                    //    if (location != -1) {
                    //        data.splice(index, 1)
                    //        console.log(data)
                    //    }
                    //    data_array.push(value.SYSID)
                    //})
                    //console.log(data)
                    let table = $('#dataTable_Case').DataTable({
                        rowReorder: {
                            selector: 'td:nth-child(2)'
                        },
                        responsive: true,
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
                            //"data": null,
                            "searchable": false,
                            "paging": false,
                            "ordering": false,
                            "info": false
                        }],
                        columns: [
                            { data: "SYSID" },
                            { data: "Case_Name" },
                            { data: "BUSINESSNAME" },
                            { data: "Contact" },
                            { data: "Phone" },
                            { data: "Personnel" },
                            {
                                data: "updateDate",
                                render: function (data, type, row, meta) {
                                    return moment(data).format('YYYY-MM-DD HH:mm:ss');
                                }
                            },
                            {
                                data: "Status",
                                render: function (data, type, row, meta) {
                                    switch (data) {
                                        case '0':
                                            return '開發中'
                                        case '1':
                                            return '裝機中'
                                        case '2':
                                            return '維護中'
                                        case '3':
                                            return '結案'
                                    }
                                }
                            },
                            {
                                data: null,
                                render: function (data, type, row, meta) {
                                    return `<button type='button' id='info' class='btn btn-info btn-lg' data-toggle='modal' data-target='#newModal' >
                                        <span class='glyphicon glyphicon-search'></span>
                                    </button>`
                                        + "&nbsp&nbsp";
                                }
                            },
                            //{
                            //    data: null,
                            //    render: function (data, type, row, meta) {
                            //        return `<button type='button' id='assign' class='btn btn-danger btn-lg' data-toggle='modal' data-target='#dialog4' >
                            //                    <span class='glyphicon glyphicon-pencil'></span>
                            //                </button>`;
                            //    }
                            //}
                        ]
                    });
                    if (seqno != '') {
                        let data = eval(doc.d)
                        let num = 0
                        $.each(data, function (index, obj) {
                            let SYSID = obj.SYSID
                            if (SYSID == Case_SYSID) {
                                num = index
                                return false
                            }
                        })
                        $('#Service').show()
                        $('#btn_Change_Status').show()

                        Load_Case(data[num]);
                        GetWorkLogs(Case_SYSID)
                        Assign_Case_List(Case_SYSID)
                        List_Assign_title(Case_SYSID)
                        $('#info').click()
                    }

                    $('#dataTable_Case tbody')
                        .unbind('click')
                        .on('click', '#info', function () {
                            let dataTable_rowData = table.row($(this).parents('tr')).data();
                            let SYSID = dataTable_rowData.SYSID

                            $('#Service').show()
                            $('#btn_Change_Status').show()

                            Load_Case(dataTable_rowData);

                            GetWorkLogs(SYSID)
                            Assign_Case_List(SYSID)
                            List_Assign_title(SYSID)


                            //Get_Work_List(Product_Name_array)

                            Case_SYSID = SYSID //push case SYSID to var
                        })
                    //.on('click', '#assign', function () {
                    //    var SYSID = table.row($(this).parents('tr')).data().SYSID;
                    //    Case_SYSID = SYSID //push case SYSID to var
                    //});
                }
            });
        }
    </script>
    <table id="example" class="display nowrap" style="width:100%">
        <thead>
            <tr>
                <th>Seq.</th>
                <th>Name</th>
                <th>Position</th>
                <th>Office</th>
                <th>Start date</th>
                <th>Salary</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>2</td>
                <td>Tiger Nixon</td>
                <td>System Architect</td>
                <td>Edinburgh</td>
                <td>2011/04/25</td>
                <td>$320,800</td>
            </tr>
            <tr>
                <td>22</td>
                <td>Garrett Winters</td>
                <td>Accountant</td>
                <td>Tokyo</td>
                <td>2011/07/25</td>
                <td>$170,750</td>
            </tr>
            <tr>
                <td>6</td>
                <td>Ashton Cox</td>
                <td>Junior Technical Author</td>
                <td>San Francisco</td>
                <td>2009/01/12</td>
                <td>$86,000</td>
            </tr>
            <tr>
                <td>41</td>
                <td>Cedric Kelly</td>
                <td>Senior Javascript Developer</td>
                <td>Edinburgh</td>
                <td>2012/03/29</td>
                <td>$433,060</td>
            </tr>
            <tr>
                <td>55</td>
                <td>Airi Satou</td>
                <td>Accountant</td>
                <td>Tokyo</td>
                <td>2008/11/28</td>
                <td>$162,700</td>
            </tr>
            <tr>
                <td>21</td>
                <td>Brielle Williamson</td>
                <td>Integration Specialist</td>
                <td>New York</td>
                <td>2012/12/02</td>
                <td>$372,000</td>
            </tr>
            <tr>
                <td>46</td>
                <td>Herrod Chandler</td>
                <td>Sales Assistant</td>
                <td>San Francisco</td>
                <td>2012/08/06</td>
                <td>$137,500</td>
            </tr>
            <tr>
                <td>50</td>
                <td>Rhona Davidson</td>
                <td>Integration Specialist</td>
                <td>Tokyo</td>
                <td>2010/10/14</td>
                <td>$327,900</td>
            </tr>
            <tr>
                <td>26</td>
                <td>Colleen Hurst</td>
                <td>Javascript Developer</td>
                <td>San Francisco</td>
                <td>2009/09/15</td>
                <td>$205,500</td>
            </tr>
            <tr>
                <td>18</td>
                <td>Sonya Frost</td>
                <td>Software Engineer</td>
                <td>Edinburgh</td>
                <td>2008/12/13</td>
                <td>$103,600</td>
            </tr>
            <tr>
                <td>13</td>
                <td>Jena Gaines</td>
                <td>Office Manager</td>
                <td>London</td>
                <td>2008/12/19</td>
                <td>$90,560</td>
            </tr>
            <tr>
                <td>23</td>
                <td>Quinn Flynn</td>
                <td>Support Lead</td>
                <td>Edinburgh</td>
                <td>2013/03/03</td>
                <td>$342,000</td>
            </tr>
            <tr>
                <td>14</td>
                <td>Charde Marshall</td>
                <td>Regional Director</td>
                <td>San Francisco</td>
                <td>2008/10/16</td>
                <td>$470,600</td>
            </tr>
            <tr>
                <td>12</td>
                <td>Haley Kennedy</td>
                <td>Senior Marketing Designer</td>
                <td>London</td>
                <td>2012/12/18</td>
                <td>$313,500</td>
            </tr>
            <tr>
                <td>54</td>
                <td>Tatyana Fitzpatrick</td>
                <td>Regional Director</td>
                <td>London</td>
                <td>2010/03/17</td>
                <td>$385,750</td>
            </tr>
            <tr>
                <td>37</td>
                <td>Michael Silva</td>
                <td>Marketing Designer</td>
                <td>London</td>
                <td>2012/11/27</td>
                <td>$198,500</td>
            </tr>
            <tr>
                <td>32</td>
                <td>Paul Byrd</td>
                <td>Chief Financial Officer (CFO)</td>
                <td>New York</td>
                <td>2010/06/09</td>
                <td>$725,000</td>
            </tr>
            <tr>
                <td>35</td>
                <td>Gloria Little</td>
                <td>Systems Administrator</td>
                <td>New York</td>
                <td>2009/04/10</td>
                <td>$237,500</td>
            </tr>
            <tr>
                <td>48</td>
                <td>Bradley Greer</td>
                <td>Software Engineer</td>
                <td>London</td>
                <td>2012/10/13</td>
                <td>$132,000</td>
            </tr>
            <tr>
                <td>45</td>
                <td>Dai Rios</td>
                <td>Personnel Lead</td>
                <td>Edinburgh</td>
                <td>2012/09/26</td>
                <td>$217,500</td>
            </tr>
            <tr>
                <td>17</td>
                <td>Jenette Caldwell</td>
                <td>Development Lead</td>
                <td>New York</td>
                <td>2011/09/03</td>
                <td>$345,000</td>
            </tr>
            <tr>
                <td>57</td>
                <td>Yuri Berry</td>
                <td>Chief Marketing Officer (CMO)</td>
                <td>New York</td>
                <td>2009/06/25</td>
                <td>$675,000</td>
            </tr>
            <tr>
                <td>29</td>
                <td>Caesar Vance</td>
                <td>Pre-Sales Support</td>
                <td>New York</td>
                <td>2011/12/12</td>
                <td>$106,450</td>
            </tr>
            <tr>
                <td>56</td>
                <td>Doris Wilder</td>
                <td>Sales Assistant</td>
                <td>Sydney</td>
                <td>2010/09/20</td>
                <td>$85,600</td>
            </tr>
            <tr>
                <td>36</td>
                <td>Angelica Ramos</td>
                <td>Chief Executive Officer (CEO)</td>
                <td>London</td>
                <td>2009/10/09</td>
                <td>$1,200,000</td>
            </tr>
            <tr>
                <td>5</td>
                <td>Gavin Joyce</td>
                <td>Developer</td>
                <td>Edinburgh</td>
                <td>2010/12/22</td>
                <td>$92,575</td>
            </tr>
            <tr>
                <td>51</td>
                <td>Jennifer Chang</td>
                <td>Regional Director</td>
                <td>Singapore</td>
                <td>2010/11/14</td>
                <td>$357,650</td>
            </tr>
            <tr>
                <td>20</td>
                <td>Brenden Wagner</td>
                <td>Software Engineer</td>
                <td>San Francisco</td>
                <td>2011/06/07</td>
                <td>$206,850</td>
            </tr>
            <tr>
                <td>7</td>
                <td>Fiona Green</td>
                <td>Chief Operating Officer (COO)</td>
                <td>San Francisco</td>
                <td>2010/03/11</td>
                <td>$850,000</td>
            </tr>
            <tr>
                <td>1</td>
                <td>Shou Itou</td>
                <td>Regional Marketing</td>
                <td>Tokyo</td>
                <td>2011/08/14</td>
                <td>$163,000</td>
            </tr>
            <tr>
                <td>39</td>
                <td>Michelle House</td>
                <td>Integration Specialist</td>
                <td>Sydney</td>
                <td>2011/06/02</td>
                <td>$95,400</td>
            </tr>
            <tr>
                <td>40</td>
                <td>Suki Burks</td>
                <td>Developer</td>
                <td>London</td>
                <td>2009/10/22</td>
                <td>$114,500</td>
            </tr>
            <tr>
                <td>47</td>
                <td>Prescott Bartlett</td>
                <td>Technical Author</td>
                <td>London</td>
                <td>2011/05/07</td>
                <td>$145,000</td>
            </tr>
            <tr>
                <td>52</td>
                <td>Gavin Cortez</td>
                <td>Team Leader</td>
                <td>San Francisco</td>
                <td>2008/10/26</td>
                <td>$235,500</td>
            </tr>
            <tr>
                <td>8</td>
                <td>Martena Mccray</td>
                <td>Post-Sales support</td>
                <td>Edinburgh</td>
                <td>2011/03/09</td>
                <td>$324,050</td>
            </tr>
            <tr>
                <td>24</td>
                <td>Unity Butler</td>
                <td>Marketing Designer</td>
                <td>San Francisco</td>
                <td>2009/12/09</td>
                <td>$85,675</td>
            </tr>
            <tr>
                <td>38</td>
                <td>Howard Hatfield</td>
                <td>Office Manager</td>
                <td>San Francisco</td>
                <td>2008/12/16</td>
                <td>$164,500</td>
            </tr>
            <tr>
                <td>53</td>
                <td>Hope Fuentes</td>
                <td>Secretary</td>
                <td>San Francisco</td>
                <td>2010/02/12</td>
                <td>$109,850</td>
            </tr>
            <tr>
                <td>30</td>
                <td>Vivian Harrell</td>
                <td>Financial Controller</td>
                <td>San Francisco</td>
                <td>2009/02/14</td>
                <td>$452,500</td>
            </tr>
            <tr>
                <td>28</td>
                <td>Timothy Mooney</td>
                <td>Office Manager</td>
                <td>London</td>
                <td>2008/12/11</td>
                <td>$136,200</td>
            </tr>
            <tr>
                <td>34</td>
                <td>Jackson Bradshaw</td>
                <td>Director</td>
                <td>New York</td>
                <td>2008/09/26</td>
                <td>$645,750</td>
            </tr>
            <tr>
                <td>4</td>
                <td>Olivia Liang</td>
                <td>Support Engineer</td>
                <td>Singapore</td>
                <td>2011/02/03</td>
                <td>$234,500</td>
            </tr>
            <tr>
                <td>3</td>
                <td>Bruno Nash</td>
                <td>Software Engineer</td>
                <td>London</td>
                <td>2011/05/03</td>
                <td>$163,500</td>
            </tr>
            <tr>
                <td>31</td>
                <td>Sakura Yamamoto</td>
                <td>Support Engineer</td>
                <td>Tokyo</td>
                <td>2009/08/19</td>
                <td>$139,575</td>
            </tr>
            <tr>
                <td>11</td>
                <td>Thor Walton</td>
                <td>Developer</td>
                <td>New York</td>
                <td>2013/08/11</td>
                <td>$98,540</td>
            </tr>
            <tr>
                <td>10</td>
                <td>Finn Camacho</td>
                <td>Support Engineer</td>
                <td>San Francisco</td>
                <td>2009/07/07</td>
                <td>$87,500</td>
            </tr>
            <tr>
                <td>44</td>
                <td>Serge Baldwin</td>
                <td>Data Coordinator</td>
                <td>Singapore</td>
                <td>2012/04/09</td>
                <td>$138,575</td>
            </tr>
            <tr>
                <td>42</td>
                <td>Zenaida Frank</td>
                <td>Software Engineer</td>
                <td>New York</td>
                <td>2010/01/04</td>
                <td>$125,250</td>
            </tr>
            <tr>
                <td>27</td>
                <td>Zorita Serrano</td>
                <td>Software Engineer</td>
                <td>San Francisco</td>
                <td>2012/06/01</td>
                <td>$115,000</td>
            </tr>
            <tr>
                <td>49</td>
                <td>Jennifer Acosta</td>
                <td>Junior Javascript Developer</td>
                <td>Edinburgh</td>
                <td>2013/02/01</td>
                <td>$75,650</td>
            </tr>
            <tr>
                <td>15</td>
                <td>Cara Stevens</td>
                <td>Sales Assistant</td>
                <td>New York</td>
                <td>2011/12/06</td>
                <td>$145,600</td>
            </tr>
            <tr>
                <td>9</td>
                <td>Hermione Butler</td>
                <td>Regional Director</td>
                <td>London</td>
                <td>2011/03/21</td>
                <td>$356,250</td>
            </tr>
            <tr>
                <td>25</td>
                <td>Lael Greer</td>
                <td>Systems Administrator</td>
                <td>London</td>
                <td>2009/02/27</td>
                <td>$103,500</td>
            </tr>
            <tr>
                <td>33</td>
                <td>Jonas Alexander</td>
                <td>Developer</td>
                <td>San Francisco</td>
                <td>2010/07/14</td>
                <td>$86,500</td>
            </tr>
            <tr>
                <td>43</td>
                <td>Shad Decker</td>
                <td>Regional Director</td>
                <td>Edinburgh</td>
                <td>2008/11/13</td>
                <td>$183,000</td>
            </tr>
            <tr>
                <td>16</td>
                <td>Michael Bruce</td>
                <td>Javascript Developer</td>
                <td>Singapore</td>
                <td>2011/06/27</td>
                <td>$183,000</td>
            </tr>
            <tr>
                <td>19</td>
                <td>Donna Snider</td>
                <td>Customer Support</td>
                <td>New York</td>
                <td>2011/01/25</td>
                <td>$112,000</td>
            </tr>
        </tbody>
        <tfoot>
            <tr>
                <th>Seq.</th>
                <th>Name</th>
                <th>Position</th>
                <th>Office</th>
                <th>Start date</th>
                <th>Salary</th>
            </tr>
        </tfoot>
    </table>
</body>
</html>
