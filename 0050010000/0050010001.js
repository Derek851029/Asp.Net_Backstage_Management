let s_date = $("#datepicker01").val();
let e_date = $("#datepicker02").val();
let log = $("#txt_Search_Log").val();
let dataTableOption = {
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
}
let datepickerOption = {
    dayNames: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
    dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
    monthNames: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
    monthNamesShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
    prevText: "上一月",
    nextText: "下一月",
    weekHeader: "週"
}

$(function () {
    bindTable_and_btnEditor();
    bindSelect_ListCase();
    $('#btnInit_WorkLog_Model').unbind('click').click(init_New_Work_Log);

    // 隱藏 ： 登打工作日誌表單
    $('#div_WorkLogs_Form').hide();
    // 新增 ： 切換工作日誌表單畫面
    $('#btn_AddNewWorkLog').click({ Flag: 0 }, New);
    // 修改 ： 切換工作日誌表單畫面
    $('#btn_UpdateNewWorkLog').click({ Flag: 1 }, New);
    // 關閉 ： 切換工作日誌列表畫面
    $('#btn_CancelNewWorkLog').click(Cancel_Work_Log);

    $.datetimepicker.setLocale('ch');
    $('.chosen-select').chosen();
    $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
    $.datepicker.regional['zh-TW'] = datepickerOption;
    $.datepicker.setDefaults($.datepicker.regional["zh-TW"]);
    $('#datepicker01').datepicker({ dateFormat: "yy-mm-dd", changeYear: true, changeMonth: true });
    $('#datepicker02').datepicker({ dateFormat: "yy-mm-dd", changeYear: true, changeMonth: true });
    $('#title_modal').html('指定條件查詢');
    $('[data-toggle="tooltip"]').tooltip();

});

// 開啟：工作日誌
function Open_Work_Log() {
    $('#div_WorkLogs').hide();
    $('#div_WorkLogs_Form').show();
}

// 關閉：工作日誌
function Cancel_Work_Log() {
    // 移除ckeditor
    CKEDITOR.instances['txt_Work_Log'].destroy();
    CKEDITOR.remove('txt_Work_Log');
    $('#div_WorkLogs_Form').hide();
    $('#div_WorkLogs').show();
}

// 新增、修改 ： 日誌內容
function New(event) {
    let caseListID = $('#select_ListCase').val();
    let Flag = event.data.Flag; // 0:新增 1:修改
    // 取得ckeditor
    let work_log = CKEDITOR.instances.txt_Work_Log.getData();
        //$('#txt_Work_Log').val();
    let log_id = $("#Lab_Log_ID").html();

    //if (caseListID == "-1") {
    //    alert("請選擇案件");
    //    return;
    //}
    if (work_log == "") {
        alert("請輸入日誌內容");
        return;
    }
    $('#btn_AddNewWorkLog').hide();
    $('#btn_UpdateNewWorkLog').hide();

    // 儲存 ： 新增、修改工作日誌
    $.ajax({
        url: '0050010001.aspx/Add_Or_Edit_WorkLog',
        type: 'POST',
        data: JSON.stringify({
            caseListID: caseListID,
            Flag: Flag,
            work_log: work_log,
            log_id: log_id
        }),
        contentType: 'application/json; charset=UTF-8',
        dataType: "json",
        success: function (doc) {
            var json = JSON.parse(doc.d.toString());
            switch (json.status) {
                case "new":
                    alert("新增完成！")
                    bindTable_and_btnEditor();
                    Cancel_Work_Log();
                    break;
                case "update":
                    alert("修改完成！");
                    bindTable_and_btnEditor();
                    Cancel_Work_Log();
                    break;
                default:
                    alert(json.status);
                    break;
            }
            document.getElementById("btn_UpdateNewWorkLog").disabled = false;
            document.getElementById("btn_AddNewWorkLog").disabled = false;
        },
        error: function () {
            document.getElementById("btn_UpdateNewWorkLog").disabled = false;
            document.getElementById("btn_AddNewWorkLog").disabled = false;
        }
    });
}

// 新增：工作日誌
function init_New_Work_Log() {   
    document.getElementById("btn_AddNewWorkLog").style.display = "";
    document.getElementById("btn_UpdateNewWorkLog").style.display = "none";
    document.getElementById("Lab_Title").innerHTML = '工作日誌（新增）';
    document.getElementById("Lab_Log_ID").innerHTML = '';
    document.getElementById("txt_Work_Log").value = '';
    document.getElementById("Lab_Create_Time").innerHTML = '';
    document.getElementById("Lab_Create_Agent").innerHTML = '';
    document.getElementById("Lab_Update_Time").innerHTML = '';
    document.getElementById("Lab_Update_Agent").innerHTML = '';
    Open_Work_Log();
    // 綁定ckeditor
    initCkeditor();
};

// 修改：工作日誌
function Load_Work_Log(dataTable_rowData) {
    $('#btn_AddNewWorkLog').hide();
    $('#btn_UpdateNewWorkLog').show();
    $('#Lab_Title').html('工作日誌（修改）');
    $('#select_ListCase').val(dataTable_rowData.caseListID);
    $('#Lab_Log_ID').html(dataTable_rowData.SYSID)
    $('#txt_Work_Log').val(dataTable_rowData.Work_Log)
    $('#Lab_Create_Time').html(moment(dataTable_rowData.Create_Time).format('YYYY-MM-DD<br/>HH:mm:ss'))
    $('#Lab_Create_Agent').html(dataTable_rowData.Create_Agent)
    $('#Lab_Update_Time').html(moment(dataTable_rowData.Update_Time).format('YYYY-MM-DD<br/>HH:mm:ss'))
    $('#Lab_Update_Agent').html(dataTable_rowData.Update_Agent)
    // 綁定ckeditor
    initCkeditor();
};

//================【下拉選單】 CSS 修改 ================
function style(Name, value) {
    var $select_elem = $("#" + Name);
    $select_elem.chosen("destroy")
    document.getElementById(Name).value = value;
    $select_elem.chosen({
        width: "100%",
        search_contains: true
    });
    $('.chosen-single').css({});
}

// 查詢 : 工作日誌所有內容，並且綁定修改按鈕
function bindTable_and_btnEditor() {
    $.ajax({
        url: '0050010001.aspx/GetWorkLogs',
        type: 'POST',
        //data: JSON.stringify({ s_date: s_date, e_date: e_date, log: log }),
        contentType: 'application/json; charset=UTF-8',
        dataType: "json",
        success: function (doc) {
            var table = $('#dataTable_WorkLogs').DataTable({
                destroy: true,
                data: eval(doc.d),
                columns: [
                    {
                        data: "Create_Time",
                        width: "11%",
                        render: function (data, type, row, meta) {
                            return moment(data).format('YYYY-MM-DD HH:mm:ss');
                        }
                    },
                    {
                        data: "Create_Agent",
                        width: "5%"
                    },
                    { data: "caseListName" },
                    {
                        data: "Work_Log",
                        width: "50%",
                        render: function (data, type, row, meta) {
                            return `<div style="width:100%;height:200px;overflow:auto;" >${data}</div>`;
                        }
                    },
                    {
                        data: "null",
                        render: function (data, type, row, meta) {
                            return `<button type='button' id='edit'
                                            class='btn btn-primary btn-lg'>
                                        <span class='glyphicon glyphicon-pencil'></span>&nbsp;修改
                                    </button>`;
                        }
                    }
                ],
                "oLanguage":dataTableOption,
                "Sorting": [[0, "desc"]],
                "LengthMenu": [[10, 25, 50], [10, 25, 50]],
                "DisplayLength": 10
            });
            
            $('#dataTable_WorkLogs tbody')
                .unbind('click')
                .on('click', '#edit', function () {
                    let rowData = table.row($(this).parents('tr')).data();
                    Load_Work_Log(rowData);
                    Open_Work_Log();
                });
        }
    });
}

// 查詢 ： 案件清單選項
function bindSelect_ListCase() {
    $.ajax({
        url: "0050010001.aspx/bindSelect_ListCase",
        type: 'POST',
        contentType: 'application/json; charset=UTF-8',
        dataType: "json",
        success: function (data) {
            var jsonParse = JSON.parse(data.d);
            let select_ListCase = $("#select_ListCase");
            select_ListCase.append(`<option value='-1'>請選擇案件</option>`);
            $.each(jsonParse, function (index, value) {
                select_ListCase.append(`<option value='${value.SYSID}'>${value.Case_Name}</option>`);
            });
        }
    });
}

// 小功能 ： 縮短字串長度
function makeStringShort(value = "",cut_length = 50) {
    let string_Output = "";
    let string_Length = value.length;
    let paragraph_Count = (string_Length / cut_length);
    if (string_Length > cut_length) {
        for (var i = 0; i <= paragraph_Count; i++) {
            string_Output += `${value.substring(i * cut_length, (i + 1) * cut_length - 1)} <br/>`;
        }
    }
    else {
        string_Output = value;
    }
    return string_Output;
}

function URL(Case_ID) {
    var newwin = window.open(); //另開視窗用 要放 $.ajax({ 前
    $.ajax({
        url: '0050010001.aspx/URL',
        type: 'POST',
        data: JSON.stringify({ Case_ID: Case_ID }),
        contentType: 'application/json; charset=UTF-8',
        dataType: "json",
        success: function (doc) {
            var json = JSON.parse(doc.d.toString());
            if (json.type == "ok") {
                newwin.location = json.status;  //另開視窗指令
            } else {
                alert(json.status);
            }
        }
    });
}

function URL2(Case_ID) {
    var newwin = window.open(); //另開視窗用 要放 $.ajax({ 前
    $.ajax({
        url: '0050010001.aspx/URL2',
        type: 'POST',
        data: JSON.stringify({ Case_ID: Case_ID }),
        contentType: 'application/json; charset=UTF-8',
        dataType: "json",
        success: function (doc) {
            var json = JSON.parse(doc.d.toString());
            if (json.type == "ok") {
                newwin.location = json.status;  //另開視窗指令
            } else {
                alert(json.status);
            }
        }
    });
}

function initCkeditor() {
    // CKEDITOR設定
    CKEDITOR.replace('txt_Work_Log', {
        uiColor: '#0034FF',
        height: 500,
        extraPlugins: 'editorplaceholder',
        editorplaceholder: '請在此輸入服務內容....',
    });
    CKEDITOR.config.toolbarGroups = [
        { name: 'basicstyles', groups: ['basicstyles', 'cleanup'] },
        { name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi', 'paragraph'] },
        { name: 'links', groups: ['links'] },
        { name: 'insert', groups: ['insert', 'Table'] },
        '/',
        { name: 'document', groups: ['mode', 'document', 'doctools'] },
        { name: 'clipboard', groups: ['clipboard', 'undo'] },
        { name: 'editing', groups: ['find', 'selection', 'spellchecker', 'replace'] },
        { name: 'forms', groups: ['forms'] },
        { name: 'styles', groups: ['styles'] },
        { name: 'colors', groups: ['colors'] },
        { name: 'tools', groups: ['tools'] },
        { name: 'others', groups: ['others'] },
    ];
    CKEDITOR.config.removeButtons = 'Image,Form,Smiley,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,Source,Templates,Scayt,CopyFormatting,CreateDiv,Language,Anchor,Flash,HorizontalRule,PageBreak,Iframe,Maximize,ShowBlocks,About,Save,NewPage,ExportPdf,Preview,Print,Paste,PasteText,PasteFromWord';
}