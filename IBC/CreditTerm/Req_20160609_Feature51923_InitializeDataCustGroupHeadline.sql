/*
	Created by: Elodie
	Date: 2016-06-09
	Task: Initialize data for CustGroupHeadline - [Redmine: #51923]
	DB: DBCUST/CustDB
*/
USE CustDB
GO

INSERT INTO CustGroupHeadline (CustID, GroupID, OwnerID, HeadlineType)
SELECT CustID, GroupID, NULL, 0
FROM dbo.custAccount WITH (NOLOCK)
WHERE IsGroupHeadLine = 1
