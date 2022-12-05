<div class="well"> 
    <h4>Payee Search by Comment</h4> 
    <strong>Please enter a value and click search to display results  </strong> </br>
    <table class="table table-bordered" style="width:auto;background:#FFFFFF;"> 
        <thead> 
            <tr> 
                <td>Search Options</td> 
                <td>Search Query</td> 
                <td></td> 
            </tr> 
            <tr> 
                <td>Search Query:</br>
                <td>[TextBox1.200]</td> 
                <td><a onclick="WCgoToApp('CaseWorksheet.aspx?xwin=&amp;wstype=59&amp;standalone=1&amp;cid=-8888888')" title="Search" class="btn btn-success" style="color: #FFFFFF" tabindex="1">Search</a></td>
            </tr> 
        </thead> 
    </table> 
    </br>
    <table id="table_id" class="table table-striped table-bordered" style="width:auto;background:#FFFFFF;"> 
        <thead> 
            <tr> 
                <th style="width:200px">Case #</th> 
                <th style="width:200px">Claim ID</th> 
                <th style="width:200px">Payee Name</th> 
                <th style="width:200px">Comment</th> 
                <th style="width:200px">Claim Amount</th> 
            </tr> 
        </thead> 
            <tbody>
                |~SELECT (CASE
                WHEN dbo.udfGetWorksheetData(-8888888,207,'TextBox',1,0) = '' 
                    then 
                    '<tr><td>Error No Search Query Entered</td></tr>'
                WHEN LEN(dbo.udfGetWorksheetData(-8888888,207,'TextBox',1,0)) < 3
                    then 
                    '<tr><td>Please Enter more Chracters</td></tr>'
                WHEN dbo.udfGetWorksheetData(-8888888,207,'TextBox',1,0) IS NOT NULL
                    then
                (SELECT TOP 1 '<tr>' + (Select '<td>' + CONVERT(varchar(max),CaseNumber) + '</td>','<td>' + ClaimNumber + '</td>','<td>' + LongName + '</td>','<td>' + Comment + '</td>', '<td>' + Convert(varchar(MAX),ClaimedAmount) + '</td></tr>'
                from vwCRMainPayee 
                where vwCRMainPayee.Comment IN (
                    Select Comment from vwCRMainPayee where comment Like '%' + (SELECT dbo.udfGetWorksheetData(-8888888,207,'TextBox', 1,0)) + '%') for XML PATH(''),TYPE).value('.', 'VARCHAR(MAX)')
                AS FIELDDATA)
                ELSE 
                    '<tr bgcolor="yellow"><td>No Results Found, ensure you are using Letters for Creditor Names and Numbers for Creditors</td></tr>' end)
                As FieldData~|
            </tbody> 

        </table>
        </div>