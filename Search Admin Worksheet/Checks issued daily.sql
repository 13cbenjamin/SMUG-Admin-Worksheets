--Checks issued daily


Select isNull(tblCheck.CheckAmount,0) as F0,
isNull(tblCheck.CheckDate,'') as F1,
isNull(tblCheck.CheckNumber,0) as F2,
isNull(F0.LongName,'') as F3 FROM tblCheck 
LEFT OUTER JOIN tblName F0 ON tblCheck.NameID = F0.NameID 
WHERE isNull(tblCheck.CheckDate,'') >= '7/7/2015' 
And isNull(tblCheck.CheckDate,'') <= '7/7/2015' 
Order By isNull(tblCheck.CheckNumber,0) Asc

      

