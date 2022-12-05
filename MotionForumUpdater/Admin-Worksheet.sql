/*
####################################################
Worksheet ID: 187
This admin worksheet creates a table with 2 columns
The first column has case information (Case Number, Debtor, Attorney, Matters, Notes)
The second column as 2 text boxes (Who Appeared) and (Forum Note)
The Reset Worksheet button calls a method in the Worksheet Script that cleares boxes and creates Event to save to database 
#####################################################
*/ 
<div class="well"> 
    <h4>Motion Forum Updater</h4>  
    <table class="table table-bordered" style="width:auto;background:#FFFFFF;"> 
        <thead> 
            <tr> 
                <td>Current User:</td> 
                <td id="initials_187_1">|:UserInitials:|</td> 
                <td>|:UserName:|</td> 
            </tr> 
            <tr> 
                <td>Motion Calendar Date:</td> 
                <td>|:ShortDate:|</td> 
            </tr> 
        </thead> 
    </table> 
    </div> 
<div style="margin: 0;padding:0" >
                        <ul style="list-style-type:none;position:absolute;top:10px;right:20px;"> 
                            <li style="display: inline;"><a onclick="displayWorksheet()" title="Refresh Worksheet" class="btn btn-primary" style="color: #FFFFFF" tabindex="-1">Refresh</a></li>
                            <li style="display: inline;">|~Select '<a href="' + tblReportSetup.ReportServerHTTPAddress + 'PleaseWait.aspx?progskip=~&prog=getPSProg&&qs=uid=' + '|:UserCodeID:|' + '|id=573|trucode=' + tblReportSetup.TruCode + '|WinSuffix=1|windesc=WorksheetForm|AppServerName=' + tblTrusteeDefaults.ApplicationHTTPAddress + '|psprog=PrintForm.aspx|sucid=' + '|:UserCodeID:|' + '|cn=' + '-8888888' + '|' + '" target="_blank" class="btn btn-success" style="color: #FFFFFF;" tabindex="-1">Update Forum</a>' as FieldData From tblReportSetup, tblTrusteeDefaults Where tblReportSetup.TruCode = tblTrusteeDefaults.TrusteeCode~|</li>
                            <li style="display: inline;"><a onclick="if(!(confirm('Are you sure you want to remove all the data from this worksheet?  This action cannot be undone.')))return false;cleartextboxes();" title="WARNING: Reset Worksheet?" class="btn btn-danger" style="color:#FFFFFF;" tabindex="-1">Reset Worksheet</a></li>
                        </ul>
</div>
    <div style="width: auto;"> 
    <table id="table_id" class="table table-striped table-bordered" style="width:auto;background:#FFFFFF;"> 
        <thead> 
            <tr> 
                <th style="width:900px">Case Details</th> 
                <th style="width:300px">Forum Note</th>
            </tr> 
        </thead> 
            <tbody>
            |~Select DISTINCT '<tr><td>' +
                    '<h5><strong>Case Number: </strong>' + CD.DisplayCaseNumber + (Select 
                    ' <strong>Debtor Last Name: </strong>' + MC.DebtorLastName + '</br>' +
                    '<strong> Datty: </strong>' + MC.DebtorAttorneyName + '</h5>' +
                    '<h6><strong> Motion being heard: </strong>' + 
                    (
                        SELECT STUFF((select DISTINCT ' <br />' + MC2.Matter1
                        from tblMatterCalendar as MC2
                        Inner Join tblMatterCalendar as cal2 on MC2.MatterCalendarID = cal2.MatterCalendarID
                        WHere MC2.CaseNumber = MC.caseNumber and MC2.CalendarDate BETWEEN CONVERT(DATETIME,(CONVERT(char(10), GetDate(),126))) and DATEADD(day, 1, GETDATE()) and MC2.DispositionID = 12
                        Order By 1
                        For XML PATH('Matter1'), TYPE).value('.', 'VARCHAR(8000)'),1,0,'')
                    ) + '</h6></br>' +
                    '<h6><strong>Matter Notes: </strong>' +
     (
                        SELECT STUFF((select DISTINCT ' <br />&#8226;' + REPLACE(REPLACE(CONVERT(VARCHAR(8000),MC3.Notes),'[','&#91;'),']','&#93;')
                        from tblMatterCalendar as MC3
                        Inner Join tblMatterCalendar as cal3 on MC3.MatterCalendarID = cal3.MatterCalendarID
                        WHere MC3.CaseNumber = MC.caseNumber and MC3.CalendarDate BETWEEN CONVERT(DATETIME,(CONVERT(char(10), GetDate(),126))) and DATEADD(day, 1, GETDATE()) and MC3.DispositionID = 12
                        Order By 1
                        For XML PATH('Notes'), TYPE).value('.', 'VARCHAR(8000)'),1,0,'')
                    )  +
                '</h6></td>' +
               '<td>' + '<Strong>Who Appeared: </strong>' + '[TextBox' + CONVERT(VARCHAR, CD.CaseID) + '.600]' + '</br>' + '<strong>Forum Note</strong> [CommentBox' + CONVERT(VARCHAR, CD.CaseID) + '.1000]' + '</td>' +
             '</tr>') AS FieldData
            FROM tblMatterCalendar as MC
            JOIN tblCaseData as CD on MC.CaseNumber = CD.CaseNumber
            where MC.MatterCalendarType = 1
            and MC.CalendarDate BETWEEN CONVERT(DATETIME,(CONVERT(char(10), GetDate(),126))) and DATEADD(day, 1, GETDATE())
            and MC.DispositionID = 12~|

            </tbody> 

        </table>
        </div> 

