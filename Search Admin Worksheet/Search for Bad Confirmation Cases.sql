--Search for Bad Confirmation Cases

Select 
    isNull(tblCaseData.BalanceOnHand,0) as F0,
    isNull(tblCaseData.CaseNumber,'') as F1,
    isNull(tblCaseData.ConfirmationDate,'') as F2,
    isNull(tblCaseData.PetitionFiledDate,'') as F3,
    isNull(tblCaseData.UnsecuredInterest,0) as F4,
    isNull(tblCaseData.UnsecuredPercent,0) as F5,
    isNull(F0.FirstName,'') as F6,
    isNull(F2.LastName,'') as F7 
FROM tblCaseData 
    LEFT OUTER JOIN tblUserTable F0 ON tblCaseData.CaseAdministrator = F0.UserCodeID 
    LEFT OUTER JOIN tblCaseName F1 ON tblCaseData.CaseID = F1.CaseID and F1.NameTypeID = 5 
    LEFT OUTER JOIN tblName F2 ON F1.NameID = F2.NameID 
WHERE isNull(tblCaseData.ConfirmationDate,'') > '9/2/2008' 
Order By isNull(F2.LastName,'') Asc

Tables:
tblCaseData
tblUserTable
tblCaseName
tblName

Fields:
tblCaseData -> Balance on Hand, Case Number, Confirmation Date, Petition Filed Date, Unsecured INterest, Unsecured Percent
tblUserTable -> FirstName
tblName -> Last Name 


Parameter:
Confirmation Date After 

Sort: 
tblName -> Last Name -> ASC 