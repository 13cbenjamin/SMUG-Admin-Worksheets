<div class="well"> 
    <h4>TNG Views Admin Worksheet</h4> 
    <strong>Please choose only 1 Debtor or Employer and only 1 AKA or DBA </br> 
    Enter search query of at least 3 characters then click Search </br>
    Employer requires NameID number </br>
    Note: Employer only supports search by AKA </strong> </br>
    <table class="table table-bordered" style="width:auto;background:#FFFFFF;"> 
        <thead> 
            <tr> 
                <td>Search Options</td> 
                <td>Search Query</td> 
                <td></td> 
            </tr> 
            <tr> 
                <td>Search Query:</br>
                Debtor [CheckBox1]
                Employer [CheckBox2]</br>
                AKA [CheckBox3]
                DBA [CheckBox4]
                </td> 
                <td>[TextBox1.200]</td> 
                <td><a onclick="WCgoToApp('CaseWorksheet.aspx?xwin=&amp;wstype=43&amp;standalone=1&amp;cid=-8888888')" title="Search" class="btn btn-success" style="color: #FFFFFF" tabindex="1">Search</a></td>
            </tr> 
        </thead> 
    </table> 
    </br>
    <table id="table_id" class="table table-striped table-bordered" style="width:auto;background:#FFFFFF;"> 
        <thead> 
            <tr> 
                <th style="width:200px">AKA / DBA / CaseID</th> 
                <th style="width:200px">LongName / CaseNameID</th> 
                <th style="width:200px">ShortName / NameID</th> 
            </tr> 
        </thead> 
            <tbody>
            |~SELECT (CASE
             WHEN dbo.udfGetWorksheetData(-8888888,190,'TextBox',1,0) = '' 
				then 
				'<tr><td>Error No Search Query Entered</td></tr>'
			WHEN dbo.udfGetWorksheetData(-8888888,190,'CheckBox',1,0) = CAST(1 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',3,0) = CAST(1 AS BIT) 
				AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',2,0) = CAST(0 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',4,0) = CAST(0 AS BIT)
			then 
			(SELECT TOP 1 '<tr>' + (Select '<td>' + AKA + '</td>','<td>' + LongName + '</td>', '<td>' + ShortName + '</td></tr>'
			from tblName 
			where tblName.AKA IN 
			(Select AKA
            FROM tblCaseName LEFT OUTER JOIN tblName ON tblCaseName.NameID = tblName.NameID
			WHERE AKA Like '%' + (SELECT dbo.udfGetWorksheetData(-8888888,190,'TextBox', 1,0)) + '%') FOR XML PATH(''),TYPE).value('.', 'VARCHAR(MAX)')
			AS FIELDDATA
			FROM tblName)

			WHEN dbo.udfGetWorksheetData(-8888888,190,'CheckBox',1,0) = CAST(1 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',4,0) = CAST(1 AS BIT)
				and  dbo.udfGetWorksheetData(-8888888,190,'CheckBox',2,0) = CAST(0 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',3,0) = CAST(0 AS BIT) 
			then 
			(SELECT TOP 1 '<tr>' + (Select '<td>' + DBA + '</td>','<td>' + LongName + '</td>', '<td>' + ShortName + '</td></tr>'
			from tblName 
			where tblName.DBA IN 
			(Select DBA
            FROM tblCaseName LEFT OUTER JOIN tblName ON tblCaseName.NameID = tblName.NameID
			WHERE DBA Like '%' + (SELECT dbo.udfGetWorksheetData(-8888888,190,'TextBox', 1,0)) + '%') FOR XML PATH(''),TYPE).value('.', 'VARCHAR(MAX)')
			AS FIELDDATA
			FROM tblName)

				WHEN dbo.udfGetWorksheetData(-8888888,190,'CheckBox',2,0) = CAST(1 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',3,0) = CAST(1 AS BIT) 
					and dbo.udfGetWorksheetData(-8888888,190,'CheckBox',1,0) = CAST(0 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',4,0) = CAST(0 AS BIT) 
				then 
				(SELECT TOP 1 '<tr>' + (Select '<td>' + CONVERT(varchar,tblCaseName.CaseID) + '</td>','<td>' + convert(varchar,tblCaseName.CaseNameID) + '</td>','<td>' + convert(varchar,tblCaseName.NameID) + '</td></tr>'
				from tblCaseName 
				where tblCaseName.NameID IN 
				(Select tblcasename.NameID
				FROM tblCaseName LEFT OUTER JOIN tblName ON tblCaseName.NameID = tblName.NameID
				WHERE tblCaseName.NameID Like '%12345%') FOR XML PATH(''),TYPE).value('.', 'VARCHAR(MAX)')
				AS FIELDDATA
				FROM tblCaseName) 

				WHEN dbo.udfGetWorksheetData(-8888888,190,'CheckBox',2,0) = CAST(1 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',4,0) = CAST(1 AS BIT) 
				and dbo.udfGetWorksheetData(-8888888,190,'CheckBox',1,0) = CAST(0 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',3,0) = CAST(0 AS BIT) 
				then 
				'<tr><td>Error Employers cannot be searched by DBA</td></tr>'
				WHEN dbo.udfGetWorksheetData(-8888888,190,'CheckBox',1,0) = CAST(1 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',2,0) = CAST(1 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',3,0) = CAST(1 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',4,0)= CAST(1 AS BIT) 
				then 
				'<tr><td>Error Please you cannot search by all options</td></tr>'
				WHEN dbo.udfGetWorksheetData(-8888888,190,'CheckBox',1,0) = CAST(1 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',2,0) = CAST(1 AS BIT) 
				then 
				'<tr><td>Error Please choose only one box for Debtor or Employer</td></tr>'
				WHEN dbo.udfGetWorksheetData(-8888888,190,'CheckBox',3,0) = CAST(1 AS BIT) AND dbo.udfGetWorksheetData(-8888888,190,'CheckBox',4,0) = CAST(1 AS BIT) 
				then 
				'<tr><td>Error Please choose only one AKA or DBA</td></tr>'
				ELSE 
                '<tr bgcolor="yellow"><td>No Results Found, ensure you are using Letters for Creditor Names and Numbers for Creditors</td></tr>' end)
				As FieldData~|
            </tbody> 

        </table>
        </div>