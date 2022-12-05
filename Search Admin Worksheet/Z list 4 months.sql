Select 
    isNull(isNull((Select Flag from tblCh13Flags Where LinkTableCodeID = '1000' and FlagCodesID = '1032' and LinkTableKey = tblCaseData.CaseID), ''),'') as F0,
    isNull(isNull((Select Flag from tblCh13Flags Where LinkTableCodeID = '1000' and FlagCodesID = '3' and LinkTableKey = tblCaseData.CaseID), ''),'') as F1,
    isNull(isNull((Select Flag from tblCh13Flags Where LinkTableCodeID = '1000' and FlagCodesID = '4' and LinkTableKey = tblCaseData.CaseID), ''),'') as F2,
    isNull(tblCaseData.CaseNumber,'') as F3,
    isNull(tblCaseData.ConfirmationDate,'') as F4,
    isNull(tblCaseData.MonthsRemainingInPlan,0) as F5,
    isNull(F0.CaseDisposition,'') as F6,
    isNull(F0.CloseCode,'') as F7,
    isNull(F2.LongName,'') as F8 
FROM tblCaseData 
    LEFT OUTER JOIN tblCloseCode F0 ON tblCaseData.CloseCodeID = F0.CloseCodeID 
    LEFT OUTER JOIN tblCaseName F1 ON tblCaseData.CaseID = F1.CaseID and F1.NameTypeID = 5 
    LEFT OUTER JOIN tblName F2 ON F1.NameID = F2.NameID 
WHERE isNull(F0.CaseDisposition,'') <> 'C' 
    And isNull(tblCaseData.MonthsRemainingInPlan,0) <= '4' 
    And isNull(tblCaseData.ConfirmationDate,'') <> '1/1/1900' 
    And isNull(F0.CloseCode,'') = 'Z'
Order By isNull(tblCaseData.MonthsRemainingInPlan,0) Asc



Tables:
tblCh13Flags
tblCasedata 
tblCloseCode
tblCaseName
tblName


Fields: 
tblCaseData.CaseNumber
tblName.LongName
comment 1, Comment 2? 
Z List: Select Flag from tblCh13Flags Where LinkTableCodeID = '1000' and FlagCodesID = '1032' and LinkTableKey = tblCaseData.CaseID 
Months Remaining in plan: tblCaseData.MonthsRemainingInPlan

Parmater: pf_Months = How many months remaining Plan. 