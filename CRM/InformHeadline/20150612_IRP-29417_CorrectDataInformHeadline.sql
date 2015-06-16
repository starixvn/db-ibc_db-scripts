USE bodb_CRM --Run on DB054
/*
	Created: Elodie
	Date: 20150611
	Task: Migrate old data to new structure InformHeadline
*/
SET IDENTITY_INSERT crmInformHeadline_New ON

INSERT INTO crmInformHeadline_New (InformHeadlineID, HeadlineID, TitleID, InformHeadlineStatusID, GroupID, UpdatedTime, Remark, Handler, Extension, ProductStatus, IsInform)
SELECT	InformID, HeadlineID, TitleID, 
		StatusID + 44999, 
		556 AS GroupID,
		UpdatedTime, 
		CASE WHEN Remark IS NULL THEN '' ELSE REPLACE(Remark, '&amp;gt;', '&gt;') END, 
		CASE WHEN UpdatedBy IS NULL THEN 0 ELSE UpdatedBy END, 
		Extension, ProductStatus, 1 AS IsInform
FROM crmInformHeadline ih WITH (NOLOCK)
	LEFT JOIN bodb02.dbo.CustAccount c ON c.CustID = ih.HeadlineID
WHERE TitleID = 19 AND c.IsGroupHeadLine = 0
	AND HeadlineID = 2087760

SET IDENTITY_INSERT crmInformHeadline_New OFF