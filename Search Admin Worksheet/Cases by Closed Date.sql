-- Cases by Closed Date


Select isNull(tblCaseData.CaseNumber,'') as F0,
isNull(tblCaseData.ClosedDate,'') as F1,
isNull(F0.CloseCodeDescription,'') as F2,
isNull(F2.LastName,'') as F3 FROM tblCaseData 
LEFT OUTER JOIN tblCloseCode F0 ON tblCaseData.CloseCodeID = F0.CloseCodeID 
LEFT OUTER JOIN tblCaseName F1 ON tblCaseData.CaseID = F1.CaseID and F1.NameTypeID = 5 
LEFT OUTER JOIN tblName F2 ON F1.NameID = F2.NameID WHERE isNull(tblCaseData.ClosedDate,'') >= '10/1/2014' 
Order By isNull(tblCaseData.ClosedDate,'') Asc,
isNull(F0.CloseCodeDescription,'') Desc


Tables:
tblCaseData -> CaseNumber, CloseDate
tblCaseName -> (added for filtering by NameTypeID of 5)
tbl.CloseCode -> CloseCodeDescription
tblName -> LastName 

Filters:
NameTypeID = 5
tblCaseData.CloseDate >= ClosingOrderDate reprot Parameter 

JOINS: 
tblCloseCode.CloseCodeID <-> tblCaseData.CloseCodeID
tblCaseName.CaseID <-> tblCaseData.CaseID 
tblName.NameID <-> tblCaseName.NameID 

Order: 
tblCaseData.CloseDate ASC and CloseCodeDesc DESC 

