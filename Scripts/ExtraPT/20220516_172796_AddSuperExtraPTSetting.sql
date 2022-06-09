/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20220516@Percy
	DB: DBCUST-CustDB
	Task: Add Athena000 super Extra PT setting
		https://nexdev.net/issues/172796
*/

USE CustDB
GO

UPDATE dbo.Acc_GroupExtraPT_Product WITH (ROWLOCK)
SET FromDate = '2022-05-16'
WHERE GroupName = 'ACCAthena000' AND ProductId = 6 AND ToDate = '2022-05-31'
GO

INSERT INTO dbo.Acc_GroupExtraPTSetting (SuperId,GroupId,GroupName,ProductId,Sporttype,SubProduct,ExtraPT,FromDate,ToDate)
SELECT 10063437 AS SuperId,GroupId,GroupName,ProductId,Sporttype,SubProduct,ExtraPT,FromDate,ToDate
FROM dbo.Acc_GroupExtraPT_Product WITH (NOLOCK)
WHERE GroupName = 'ACCAthena000' AND ProductId = 6 AND ToDate = '2022-05-31'
GO