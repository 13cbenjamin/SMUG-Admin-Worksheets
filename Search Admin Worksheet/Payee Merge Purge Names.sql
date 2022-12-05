-- Payee Merge Purge Names

Select isNull(tblName.AddressLine1,'') as F0,
isNull(tblName.AddressLine2,'') as F1,
isNull(tblName.AddressLine3,'') as F2,
isNull(tblName.City,'') as F3,
isNull(tblName.FirstName,'') as F4,
isNull(tblName.LastName,'') as F5,
isNull(tblName.LongName,'') as F6,
isNull(tblName.NameID,0) as F7,
isNull(tblName.State,'') as F8,
isNull(tblName.ZipCode,'000000000') as F9 
FROM tblName Order By isNull(tblName.AddressLine1,'') Asc

      