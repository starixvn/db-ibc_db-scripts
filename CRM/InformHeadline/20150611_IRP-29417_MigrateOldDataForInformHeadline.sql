USE bodb_CRM --Run on DB054
/*
	Created: Elodie
	Date: 20150611
	Task: Migrate old data to new structure InformHeadline
*/
GO
TRUNCATE TABLE crmInformTitle_New

GO
TRUNCATE TABLE crmInformHeadline_New

GO
SET IDENTITY_INSERT crmInformTitle_New ON

INSERT INTO crmInformTitle_New (TitleID, Title, CreatedDate, Creator, StatusID, Filter)
SELECT ID, Title, CreatedDate, 1504774 AS Creator, 11002 AS StatusID, 
	'<Filters Site="6004,6006,6014,6016,6019,6023,6024,6025,6026,6027,6028,6029,6037,6055,6294" Position="4,3,2,1" Currency="1,2,3,4,5,6,9,12,13,15,16,17,20,21,22,27,28,30,31,32,33,34,35,36,37,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,61,62,63,64,65,66,67" DirectAccount="1" />' AS Filter
FROM crmInformTitle WITH (NOLOCK)
WHERE ID IN (5,6,11,19)

SET IDENTITY_INSERT crmInformTitle_New OFF

SET IDENTITY_INSERT crmInformHeadline_New ON

INSERT INTO crmInformHeadline_New (InformHeadlineID, HeadlineID, TitleID, InformHeadlineStatusID, GroupID, UpdatedTime, Remark, Handler, Extension, ProductStatus, IsInform)
SELECT	InformID, HeadlineID, TitleID, 
		StatusID + 44999, 
		CASE WHEN c.CustID IS NULL THEN 0 ELSE c.GroupID END AS GroupID,
		UpdatedTime, 
		CASE WHEN Remark IS NULL THEN '' ELSE Remark END, 
		CASE WHEN UpdatedBy IS NULL THEN 0 ELSE UpdatedBy END, 
		Extension, ProductStatus, 1 AS IsInform
FROM crmInformHeadline ih WITH (NOLOCK)
	LEFT JOIN bodb02.dbo.CustAccount c ON c.CustID = ih.HeadlineID
WHERE TitleID IN (5,6,11,19) AND c.IsGroupHeadLine = 1

SET IDENTITY_INSERT crmInformHeadline_New OFF
GO

