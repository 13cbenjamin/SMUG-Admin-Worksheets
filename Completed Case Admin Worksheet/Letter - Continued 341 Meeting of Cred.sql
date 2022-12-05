--Letter - Continued 341 Meeting of Creditors	LTR-CONT-341

DELETE FROM tblch13Dates WHERE DatesCodeID = 2 AND LinkTableCodeId = 1000 AND
LinkTableKey = {CaseID};
INSERT INTO tblch13Dates(LinkTableCodeID, LinkTableKey,DatesCodeID,EventDate)
VALUES (1000,{CaseID},2,'{UserInput3}');

-- Report - 180 Day Review	180RPT	
DELETE tblCh13Dates 
WHERE ( DatesCodeID = 16 ) 
AND ( LinkTableKey = {CaseID} ); 
INSERT tblCh13Dates (LinkTableCodeID, LinkTableKey, DatesCodeID, EventDate) 
VALUES ( 1000, {CaseID}, 16, CAST(GetDate() AS DATE)); 

INSERT tblForum ( CaseID, Header, UserCodeID, EventDate, LinkForumID, ForumHeadingID, InitialUserID ) 
SELECT {CaseID}, tblForumHeading.Description, {UserInput1}, GetDate(), 0, tblForumHeading.ForumHeadingID, 1 
FROM tblForumHeading 
WHERE tblForumHeading.ForumHeadingID = 8 
AND NOT EXISTS 
( SELECT tblForum.ForumID 
FROM tblForum 
WHERE tblForum.CaseID = {CaseID} 
AND tblForum.LinkForumID = 0 
AND tblForum.ForumHeadingID = tblForumHeading.ForumHeadingID );

INSERT tblForum ( CaseID, Header, Detail, UserCodeID, EventDate, LinkForumID, ForumHeadingID, InitialUserID ) 
SELECT {CaseID},'180 Day Review',(CASE WHEN dbo.udfGetWorksheetData(CaseID, 126, 'CommentBox',1,0) = '' THEN '180 Day Review Complete.' ELSE dbo.udfGetWorksheetData(CaseID, 126, 'CommentBox',1,0) END), {UserInput1}, GetDate(), F.ForumID, F.ForumHeadingID, {UserInput1} 
FROM tblForum F 
WHERE F.CaseID = {CaseID} 
AND F.ForumHeadingID = 8 
AND F.LinkForumID = 0; 

INSERT tblDocumentKeys ( DocumentID, DocumentKey, KeyTable ) 
VALUES ({DocumentID}, (SELECT SCOPE_IDENTITY()), 1077); 

INSERT tblForum ( CaseID, Header, UserCodeID, EventDate, LinkForumID, ForumHeadingID, InitialUserID ) 
SELECT {CaseID}, tblForumHeading.Description, {UserInput1}, GetDate(), 0, tblForumHeading.ForumHeadingID, 1 
FROM tblForumHeading 
WHERE tblForumHeading.ForumHeadingID = 10  
AND NOT EXISTS 
( SELECT tblForum.ForumID 
FROM tblForum 
WHERE tblForum.CaseID = {CaseID} 
AND tblForum.LinkForumID = 0 
AND tblForum.ForumHeadingID = tblForumHeading.ForumHeadingID )
AND dbo.udfGetWorksheetData({CaseID}, 125, 'CommentBox',1,0) <> '';

INSERT tblForum ( CaseID, Header, Detail, UserCodeID, EventDate, LinkForumID, ForumHeadingID, InitialUserID ) 
SELECT {CaseID},'Amended Base',dbo.udfGetWorksheetData({CaseID}, 125, 'CommentBox',1,0), {UserInput1}, GetDate(), F.ForumID, F.ForumHeadingID, {UserInput1} 
FROM tblForum F 
WHERE F.CaseID = {CaseID} 
AND F.ForumHeadingID = 10 
AND F.LinkForumID = 0
AND dbo.udfGetWorksheetData({CaseID}, 125, 'CommentBox',1,0) <> '';







-- WORKING Report Update Script 

--Letter - BAPCPA Close to Completion && BAPCPA Completed
DELETE FROM tblch13Dates WHERE DatesCodeID = 31 AND LinkTableCodeId = 1000 AND
LinkTableKey = {CaseID} and {UserInput1} = CAST(1 AS BIT)
INSERT tblch13Dates(LinkTableCodeID, LinkTableKey,DatesCodeID,EventDate)
SELECT 1000,{CaseID},31,GetDate() where {UserInput1} = CAST(1 AS BIT)

DELETE FROM tblch13Dates WHERE DatesCodeID = 30 AND LinkTableCodeId = 1000 AND
LinkTableKey = {CaseID}  and {UserInput2} = CAST(1 AS BIT)
INSERT tblch13Dates(LinkTableCodeID, LinkTableKey,DatesCodeID,EventDate)
SELECT 1000,{CaseID},30,GetDate() where {UserInput2} = CAST(1 AS BIT)



