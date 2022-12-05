-- Search Claims


--1. Search Claims - Asserted Claim Amount
Select isNull(tblPayee.AssertedClaimAmount,0) as F0,
isNull(tblPayee.ClaimedAmount,0) as F1,
isNull(tblPayee.ClaimID,0) as F2,
isNull(tblPayee.PayeeLevel,0) as F3,
isNull(tblCaseData.CaseNumber,'') as F4,
isNull(tblCloseCode.CaseDisposition,'') as F5,
isNull(tblCreditorType.CreditorTypeID,0) as F6,
isNull(tblCreditorType.Description,'') as F7,
isNull(tblNoCheck.NoCheckID,0) as F8,
isNull(tblName.LongName,'') as F9 
FROM tblPayee 
LEFT OUTER JOIN tblCaseData F0 ON tblPayee.CaseID = F0.CaseID 
LEFT OUTER JOIN tblCloseCode F1 ON F0.CloseCodeID = F1.CloseCodeID 
LEFT OUTER JOIN tblCreditorType F2 ON tblPayee.CreditorTypeID = F2.CreditorTypeID 
LEFT OUTER JOIN tblNoCheck F3 ON tblPayee.NoCheckID = F3.NoCheckID 
LEFT OUTER JOIN tblCaseName F4 ON tblPayee.CaseNameID = F4.CaseNameID 
LEFT OUTER JOIN tblName F5 ON F4.NameID = F5.NameID 
    WHERE isNull(F1.CaseDisposition,'') <> 'c' 
    And (isNull(F2.CreditorTypeID,0) = '10' 
    Or isNull(F2.CreditorTypeID,0) = '44' 
    Or isNull(F2.CreditorTypeID,0) = '45' 
    Or isNull(F2.CreditorTypeID,0) = '50' 
    Or isNull(F2.CreditorTypeID,0) = '86' 
    Or isNull(F2.CreditorTypeID,0) = '88' 
    Or isNull(F2.CreditorTypeID,0) = '89' 
    Or isNull(F2.CreditorTypeID,0) = '90' ) 
    And isNull(tblPayee.AssertedClaimAmount,0) <> 0 
    And isNull(F3.NoCheckID,0) = '1' 
    Order By isNull(F2.CreditorTypeID,0) Asc,isNull(F0.CaseNumber,'') Asc


    Tables: 
    tblPayee
    tblCaseData
    tblCloseCode
    tblCreditorType
    tblNoCheck
    tblCaseName
    tblName

--2. Search Claim - By Creditor 
Select isNull(tblPayee.ClaimedAmount,0) as F0,
isNull(tblPayee.PayeeLevel,0) as F1,
isNull(tblPayee.PrincipalPaid,0) as F2,
isNull(F0.CaseNumber,'') as F3,
isNull(F0.ConfirmationDate,'') as F4,
isNull(F1.CaseDisposition,'') as F5,
isNull(F3.LongName,'') as F6 
FROM tblPayee 
LEFT OUTER JOIN tblCaseData F0 ON tblPayee.CaseID = F0.CaseID 
LEFT OUTER JOIN tblCloseCode F1 ON F0.CloseCodeID = F1.CloseCodeID 
LEFT OUTER JOIN tblCaseName F2 ON tblPayee.CaseNameID = F2.CaseNameID 
LEFT OUTER JOIN tblName F3 ON F2.NameID = F3.NameID 
WHERE isNull(F1.CaseDisposition,'') <> 'c' 
And isNull(F3.LongName,'') Like '%United States%' 
Order By isNull(F0.CaseNumber,'') Asc


Tables: 
tblPayee
tblCaseData
tblCloseCode
tblCaseName
tblName

Fields: 
tblPayee -> Claimed Amount, Payee Level, Principal Paid
tblCaseData -> CaseNumber, ConfirmationDate
tblCloseCode -> CaseDisposition
tblCaseName -> not used 
tblName -> LongName 

Filters: tblCloseCode <> 'c'    tblName.LongName like PF_Parameter 

Sort: tblCaseData.CaseNumber ASC 

--3. Search Claims - Creditor Description 
Select isNull(tblPayee.ClaimID,0) as F0,
isNull(F0.CaseNumber,'') as F1,
isNull(F0.DateAdded,'') as F2,
isNull(F1.CaseDisposition,'') as F3,
isNull(F2.Description,'') as F4,
isNull(F4.LongName,'') as F5 
FROM tblPayee 
LEFT OUTER JOIN tblCaseData F0 ON tblPayee.CaseID = F0.CaseID 
LEFT OUTER JOIN tblCloseCode F1 ON F0.CloseCodeID = F1.CloseCodeID 
LEFT OUTER JOIN tblCreditorType F2 ON tblPayee.CreditorTypeID = F2.CreditorTypeID 
LEFT OUTER JOIN tblCaseName F3 ON tblPayee.CaseNameID = F3.CaseNameID 
LEFT OUTER JOIN tblName F4 ON F3.NameID = F4.NameID 
WHERE isNull(F4.LongName,'') Like '%department of revenue%' 
And isNull(F0.DateAdded,'') >= '3/8/2016' 

Tables:
tblPayee
tblCaseData
tblCloseCode
tblCreditorType
tblCaseName
tblName


Fields:
tblPayee -> ClaimID, CaseNumber, DateAdded
tblCaseData -> 
tblCloseCode -> Case Disposition 
tblCreditorType -> Description 
tblCaseName -> NONE
tblName -> LongName 


Filters:
Parameter 1: Long Name Like PF_LongName 
Parameter 2: Date Case Added PF_DateCaseAddedandLater


Sort: NONE

--3. Search Claims - Tickets
Select 
isNull(tblPayee.ClaimID,0) as F0,
isNull(tblPayee.Comment,'') as F1,
isNull(tblCaseData.CaseNumber,'') as F2,
isNull(tblCaseData.FRCourtOrderDate,'') as F3,
isNull(tblCloseCode.CloseCodeID,0) as F4,
isNull(tblCloseCode.FinalReportCloseCodeCategory,0) as F5,
isNull(FtblName3.LastName,'') as F6,
isNull(tblCreditorType.CreditorTypeID,0) as F7,
isNull(tblName.LongName,'') as F8 
FROM tblPayee 
LEFT OUTER JOIN tblCaseData F0 ON tblPayee.CaseID = F0.CaseID 
LEFT OUTER JOIN tblCloseCode F1 ON F0.CloseCodeID = F1.CloseCodeID 
LEFT OUTER JOIN tblCaseName F2 ON F0.CaseID = F2.CaseID 
and F2.NameTypeID = 5 
LEFT OUTER JOIN tblName F3 ON F2.NameID = F3.NameID 
LEFT OUTER JOIN tblCreditorType F4 ON tblPayee.CreditorTypeID = F4.CreditorTypeID 
LEFT OUTER JOIN tblCaseName F5 ON tblPayee.CaseNameID = F5.CaseNameID 
LEFT OUTER JOIN tblName F6 ON F5.NameID = F6.NameID 
WHERE 
(isNull(F4.CreditorTypeID,0) = '49' 
    Or isNull(F4.CreditorTypeID,0) = '66' 
    Or isNull(F4.CreditorTypeID,0) = '26' 
    Or isNull(F4.CreditorTypeID,0) = '48' 
    Or isNull(F4.CreditorTypeID,0) = '53' 
    Or isNull(F4.CreditorTypeID,0) = '79' 
    Or isNull(tblPayee.Comment,'') Like '%ticket%' ) 
And isNull(F0.FRCourtOrderDate,'') >= '7/1/2018'
And (isNull(F1.CloseCodeID,0) = '15' 
Or isNull(F1.FinalReportCloseCodeCategory,0) = '6' ) 
Order By isNull(F3.LastName,'') Asc, isNull(tblPayee.ClaimID,0) Asc

      
--Tables and Fields :
    tblPayee -> ClaimID, COmment 
    tblCaseData -> CaseNumber, FRCourtORderDate  
    tblCloseCode -> CloseCodeID, FinalReportCloseCodeCategory
    tblCaseName NONE
    tblName -> LastName, LongName
    tblCreditorType, CreditorTypeID 

--Filters:
Parameter: 
FR Court Order Date: pf_date 

Sort: 

Select tblCaseData.CaseNumber, tblName.LongName, tblPayee.Comment, tblCaseName.NameTypeID, tblCreditorType.CreditorTypeID, tblCLoseCode.CloseCodeID, tblCloseCode.FinalReportCloseCodeCategory
from tblPayee 
LEFT OUTER JOIN tblCaseData F0 ON tblPayee.CaseID = F0.CaseID 
LEFT OUTER JOIN tblCloseCode F1 ON F0.CloseCodeID = F1.CloseCodeID 
LEFT OUTER JOIN tblCaseName F2 ON F0.CaseID = F2.CaseID 
and F2.NameTypeID = 5 
LEFT OUTER JOIN tblName F3 ON F2.NameID = F3.NameID 
LEFT OUTER JOIN tblCreditorType F4 ON tblPayee.CreditorTypeID = F4.CreditorTypeID 
LEFT OUTER JOIN tblCaseName F5 ON tblPayee.CaseNameID = F5.CaseNameID 
LEFT OUTER JOIN tblName F6 ON F5.NameID = F6.NameID 
WHERE 
(tblCloseCode.CloseCodeID = 15 OR
tblCloseCode.FinalReportCloseCodeCategory = 6) and
tblCreditorType.CreditorTypeID in (26, 48, 49, 53, 66, 79) and
tblCaseName.NameTypeID = 5 and
tblPayee.Comment like "*tickets*"




Select F0.CaseNumber, F3.LongName, tblPayee.Comment, F2.NameTypeID, F4.CreditorTypeID, F1.CloseCodeID, F1.FinalReportCloseCodeCategory
from tblPayee 
LEFT OUTER JOIN tblCaseData F0 ON tblPayee.CaseID = F0.CaseID 
LEFT OUTER JOIN tblCloseCode F1 ON F0.CloseCodeID = F1.CloseCodeID 
LEFT OUTER JOIN tblCaseName F2 ON F0.CaseID = F2.CaseID 
LEFT OUTER JOIN tblName F3 ON F2.NameID = F3.NameID 
LEFT OUTER JOIN tblCreditorType F4 ON tblPayee.CreditorTypeID = F4.CreditorTypeID 
LEFT OUTER JOIN tblCaseName F5 ON tblPayee.CaseNameID = F5.CaseNameID 
LEFT OUTER JOIN tblName F6 ON F5.NameID = F6.NameID 
WHERE 
F2.NameTypeID = 5 and
(F4.CreditorTypeID in (26, 48, 49, 53, 66, 79) OR tblPayee.Comment like '%ticket%') and
F0.FRCourtOrderDate >= '07/18/2018' AND
(F1.CloseCodeID = 15 OR
F1.FinalReportCloseCodeCategory = 6)


Select F0.CaseNumber, F3.LongName, tblPayee.Comment, F2.NameTypeID, F4.CreditorTypeID, F1.CloseCodeID, F1.FinalReportCloseCodeCategory
from tblPayee 
LEFT OUTER JOIN tblCaseData F0 ON tblPayee.CaseID = F0.CaseID 
LEFT OUTER JOIN tblCloseCode F1 ON F0.CloseCodeID = F1.CloseCodeID 
LEFT OUTER JOIN tblCaseName F2 ON F0.CaseID = F2.CaseID 
LEFT OUTER JOIN tblName F3 ON F2.NameID = F3.NameID 
LEFT OUTER JOIN tblCreditorType F4 ON tblPayee.CreditorTypeID = F4.CreditorTypeID 
LEFT OUTER JOIN tblCaseName F5 ON tblPayee.CaseNameID = F5.CaseNameID 
LEFT OUTER JOIN tblName F6 ON F5.NameID = F6.NameID 
WHERE 
F2.NameTypeID = 5 and
(F4.CreditorTypeID in (26, 48, 49, 53, 66, 79) OR tblPayee.Comment like '%ticket%') and
F0.FRCourtOrderDate >= '07/18/2018' AND
(F1.CloseCodeID = 15 OR
F1.FinalReportCloseCodeCategory = 6)




Select isNull(tblPayee.ClaimID,0) as F0,
isNull(tblPayee.Comment,'') as F1,
isNull(F0.CaseNumber,'') as F2,
isNull(F0.FRCourtOrderDate,'') as F3,
isNull(F1.CloseCodeID,0) as F4,
isNull(F1.FinalReportCloseCodeCategory,0) as F5,
isNull(F3.LastName,'') as F6,
isNull(F4.CreditorTypeID,0) as F7,
isNull(F6.LongName,'') as F8 
FROM tblPayee 
LEFT OUTER JOIN tblCaseData F0 ON tblPayee.CaseID = F0.CaseID 
LEFT OUTER JOIN tblCloseCode F1 ON F0.CloseCodeID = F1.CloseCodeID 
LEFT OUTER JOIN tblCaseName F2 ON F0.CaseID = F2.CaseID and F2.NameTypeID = 5 
LEFT OUTER JOIN tblName F3 ON F2.NameID = F3.NameID 
LEFT OUTER JOIN tblCreditorType F4 ON tblPayee.CreditorTypeID = F4.CreditorTypeID 
LEFT OUTER JOIN tblCaseName F5 ON tblPayee.CaseNameID = F5.CaseNameID 
LEFT OUTER JOIN tblName F6 ON F5.NameID = F6.NameID 
WHERE 

(   
    isNull(F4.CreditorTypeID,0) = '49' 
    Or isNull(F4.CreditorTypeID,0) = '66'
    Or isNull(F4.CreditorTypeID,0) = '26' 
    Or isNull(F4.CreditorTypeID,0) = '48' 
    Or isNull(F4.CreditorTypeID,0) = '53' 
    Or isNull(F4.CreditorTypeID,0) = '79' 
    Or isNull(tblPayee.Comment,'') Like '%ticket%' 
 ) 
 And isNull(F0.FRCourtOrderDate,'') >= '7/1/2018' 
 And (
        isNull(F1.CloseCodeID,0) = '15' 
     Or 
         isNull(F1.FinalReportCloseCodeCategory,0) = '6' 
     ) 
     Order By isNull(F3.LastName,'') Asc, IsNull(tblPayee.ClaimID,0) Asc


     F2.NameTypeID = 5 and
(F4.CreditorTypeID in (26, 48, 49, 53, 66, 79) OR tblPayee.Comment like '%ticket%') and
F0.FRCourtOrderDate >= '07/18/2018' AND
(F1.CloseCodeID = 15 OR
F1.FinalReportCloseCodeCategory = 6)