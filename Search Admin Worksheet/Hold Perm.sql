# Hold Perm

Select isNull(tblCaseData.BalanceOnHand,0) as F0,
isNull(tblCaseData.CaseNumber,'') as F1,
isNull(tblCaseData.HoldPermanent,0) as F2,
isNull(F0.FirstName,'') as F3,
isNull(F1.CaseDisposition,'') as F4,
isNull(F3.LastName,'') as F5 FROM tblCaseData 
LEFT OUTER JOIN tblUserTable F0 ON tblCaseData.CaseAdministrator = F0.UserCodeID 
LEFT OUTER JOIN tblCloseCode F1 ON tblCaseData.CloseCodeID = F1.CloseCodeID 
LEFT OUTER JOIN tblCaseName F2 ON tblCaseData.CaseID = F2.CaseID and F2.NameTypeID = 5 
LEFT OUTER JOIN tblName F3 ON F2.NameID = F3.NameID WHERE isNull(F1.CaseDisposition,'') <> 'c' 
And isNull(tblCaseData.HoldPermanent,0) <> 999999.00 
And isNull(F0.FirstName,'') = 'elizabeth' 
And isNull(tblCaseData.HoldPermanent,0) <> 0 

tblCaseName.NameTypeID = 5
tblCloseCode.CaseDisposition <> 'c'
tblCaseData.HoldPermanent <> 999999.00
tblCaseData.HoldPermenant <> 0
tblUserTable.F0 = *PARAMATER* 



tblCaseData -> BalanceOnHand, CaseNumber, HoldPermanent
tblUserTable -> FirstName
tblCloseCode -> Case CaseDisposition
tblName -> Last Name 
tblCaseName 

Parameter -> Firstname on tblCaseData 


Form Code 2083
Form Type Abbr: TAC-RPT-HOLD-PERM 
Report ID: 577
Report Name on Mneu: Report Hold Perm
Report Location on Disk: G:\\13software_print_tac\\rpt\\TAC_Report_HoldPerm_CB.rpt

PleaseWait.aspx?prog=SetForm&qs=rpt=TAC_Report_HoldPerm_CB