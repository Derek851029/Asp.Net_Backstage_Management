<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="0050010001.aspx.cs" Inherits="_0050010001" %>

<asp:Content ID="Content" ContentPlaceHolderID="head2" runat="Server">

    <div id="div_WorkLogs" class="table-responsive container" style="width:98%">
        <h2>
            <strong>工作日誌清單</strong>
            <button id="btnInit_WorkLog_Model" type="button" class="btn btn-success btn-lg">  
                <span class='glyphicon glyphicon-plus'></span>&nbsp;&nbsp;新增日誌
            </button>
            <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#newModal02">
                <span class='glyphicon glyphicon-search'></span>&nbsp;&nbsp;搜尋日誌
            </button>
        </h2>
        <table id="dataTable_WorkLogs" class="display table table-bordered table-striped">
            <thead>
                <tr>
                    <th style="text-align: center;">建立日期</th>
                    <th style="text-align: center;">建立者</th>
                    <th style="text-align: center;">案件</th>
                    <th style="text-align: center;">日誌內容</th>
                    <th style="text-align: center;">修改</th>
                </tr>
            </thead>
        </table>
    </div>

    <div id="div_WorkLogs_Form" class="container" style="width: 99%">
        <h2>
            <label id="Lab_Title">工作日誌</label>
        </h2>
        <table id="table_WorkLogs_Form" class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th colspan="4">
                        <span style="font-size: 20px"><strong>工作日誌</strong></span>
                        &nbsp;&nbsp;&nbsp;&nbsp;<label id="Lab_Log_ID"></label>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th>選擇案件</th>
                    <th colspan="3">
                        <select id="select_ListCase"  onchange="" style="background-color:#ffffbb;width:100%"></select>
                    </th>
                </tr>
                <tr>
                    <th>日誌內容</th>
                    <th colspan="3">
                        <div align="left" data-toggle="tooltip" title="必填，不能超過１０００個字元">
                            <textarea id="txt_Work_Log" class="form-control" cols="90" rows="5" placeholder="日誌內容"
                                style="width: 100%" onkeyup='' ></textarea>
                        </div>
                    </th>
                </tr>
                <tr>
                    <th style="width:10%">建立時間／建立者</th>
                    <th style="width:40%">
                        <label id="Lab_Create_Time"></label>&nbsp;&nbsp;<label id="Lab_Create_Agent"></label>
                    </th>
                    <th style="width:10%">修改時間／修改者</th>
                    <th style="width:40%">
                        <label id="Lab_Update_Time"></label>&nbsp;&nbsp;<label id="Lab_Update_Agent"></label>
                    </th>
                </tr>
                <tr>
                    <th colspan="4" style="text-align:center">
                        <button id="btn_AddNewWorkLog" type="button" class="btn btn-success btn-lg" style="">
                            <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;新增
                        </button>
                        <button id="btn_UpdateNewWorkLog" type="button" class="btn btn-primary btn-lg" style="">
                            <span class="glyphicon glyphicon-pencil"></span>&nbsp;&nbsp;修改
                        </button>
                        <button id="btn_CancelNewWorkLog" type="button" class="btn btn-danger btn-lg" data-dismiss="modal">
                            <span class="glyphicon glyphicon-remove"></span>&nbsp;關閉
                        </button>
                    </th>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- ====== 隱藏式 查詢表 ====== -->
    <div class="modal fade" id="newModal02" role="dialog" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="width: 1100px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h2 class="modal-title"><strong>
                        <label id="title_modal"></label></strong></h2>
                </div>
                <div class="modal-body">
                    <table class="display table table-striped" style="width: 99%">
                        <thead>
                            <tr>
                                <th style="text-align: center" colspan="4">
                                    <span style="font-size: 20px"><strong>查詢條件</strong></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr style="height: 55px;">
                                <th style="text-align: center; width: 15%">
                                    <strong>起點日期</strong>
                                </th>
                                <td style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                        <input type="text" id="datepicker01" name="datepicker01" style="width: 95%;" maxlength="16" 
                            placeholder="yyyy-MM-dd"onkeypress="EnterPress(event)" />
                                    </div>
                                </td> 
                                <td style="text-align: center; width: 15%">
                                    <strong>終點日期</strong>
                                </td>
                                <td style="width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                        <input type="text" id="datepicker02" name="datepicker02" style="width: 95%;" maxlength="16" 
                            placeholder="yyyy-MM-dd"onkeypress="EnterPress(event)" />
                                    </div>
                                </td>
                            </tr>     
                            <tr>
                                <td style="text-align: center; width: 15%">
                                    <strong>搜尋日誌內容</strong>
                                </td>
                                <td style="text-align: center; width: 85%" colspan="3">
                                    <input type="text" class="form-control" id="txt_Search_Log" name="txt_Search_Log" 
                                        style="width: 85%;" onkeyup="" />
                                </td>
                            </tr>
                           <!-- <tr style="height: 55px;">
                                <th style="text-align: center; width: 15%">
                                    <strong>起點時間</strong>
                                </th>
                                <td style="text-align: center; width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker01" name="datetimepicker01"  placeholder=""  />
                                    </div>
                                </td> 
                                <td style="text-align: center; width: 15%">
                                    <strong>終點時間</strong>
                                </td>
                                <td style="width: 35%">
                                    <div style="float: left" data-toggle="tooltip" title="">
                                        <input type="text" class="form-control" id="datetimepicker02" name="datetimepicker02" />
                                    </div>
                                </td>
                            </tr>                            
                            <tr>
                                <th style="text-align: center; width: 15%">
                                    <strong>選擇客戶</strong>
                                </th>
                                <th style="width: 35%">
                                    <div data-toggle="tooltip" title="" style="width: 100%">
                                        <select id="DropClientCode" name="DropClientCode" class="chosen-select" onchange="">
                                            <option value="">請選擇客戶…</option>
                                        </select>
                                    </div>
                                </th>
                            </tr>-->
                            <tr>
                                <td style="text-align: center; width: 50%" colspan="2">
                                    <button id="Button1" type="button" onclick="bindTable();" class="btn btn-success btn-lg " data-dismiss="modal"><span class="glyphicon glyphicon-search"></span>尋找&nbsp;&nbsp;</button>        
                                </td>
                                <td style="text-align: center; width: 50%" colspan="2">
                                    <button type="button" class="btn btn-danger btn-lg" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span>&nbsp;取消</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <link href="../2021_case/0010010005.css" rel="stylesheet" />
    <link href="../css/jquery.datetimepicker.min.css" rel="stylesheet" />
    <link href="../js/jquery-ui.min.css" rel="stylesheet" />
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../js/jquery.datetimepicker.full.min.js"></script>
    <script src="../js/jquery-ui.min.js"></script>
    <script src="../chosen/chosen.jquery.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script src="../DataTables/jquery.dataTables.min.js"></script>
    <script src="../fullcalendar-2.8.0/lib/moment.min.js"></script>
    <script src="../Scripts/ckeditor/ckeditor.js"></script>
    <script src="0050010001.js"></script>
</asp:Content>
