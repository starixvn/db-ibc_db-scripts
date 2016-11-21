/*
	Creator:	20161121@Billy
	Task:		Fix wrong definiton of computed SeqNo column of ProfileVirtualSetting table - [Redmine: #00000]
	Server:		DBCUST.CustDB
*/

ALTER TABLE dbo.ProfileVirtualSetting
	DROP COLUMN seqNo;

ALTER TABLE dbo.ProfileVirtualSetting
	ADD seqNo AS (profileID - 1) / 64 + 1;

