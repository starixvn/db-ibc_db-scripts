/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
Created: 
Task : Create new table [RedmineID: #147430]
DB: DBTXN/bodb02
 
*/

DECLARE @Tmp TABLE 
(
	CustID			INT
	,Username		VARCHAR(30)
	,Recommend		INT
	,Mrecommend		INT
	,Srecommend		INT
	,StatusId		VARCHAR(20)
)

INSERT INTO @Tmp (Username, StatusId)
VALUES ('wpgmyikhunchiu01'	,'0,1,2')
,('twpgmyikhunchiu02'		,'0,2')
,('twpgmenid.lin'			,'0,1,2')
,('twpgmjaye.chen'			,'0,2')
,('twpgmjaye.chen1'			,'0,2')
,('twpgmryan.lu'			,'0,1,2')
,('twpgmlynnlu'				,'0,1,2')
,('twpgmneil.hsieh'			,'0,1,2')
,('twpgmweiliu'				,'0,2')
,('twpgmweiliu01'			,'0,1')
,('twpgmzoelee'				,'0,1,2')
,('twpgmzoelee1'			,'0,1,2')
,('twpgmbert.chang2'		,'0,1,2')
,('twpgmjessica.chen'		,'0,1,2')
,('twpgmcolachen'			,'0,1,2')
,('twpgmleolee'				,'0,2')
,('twpgmeric.hsu'			,'0,2')
,('twpgmandrewlan'			,'0,2')
,('twpgmderi.chen'			,'0,2')
,('twpgmnabifan'			,'0,2')
,('twpgmbily.chang'			,'0,2')
,('twpgmjerry.chen'			,'0,1,2')
,('twpgmrita.chang1'		,'0,1,2')
,('twpgmrita.chang2'		,'0,2')
,('twpgmwinnielin01'		,'0,1,2')
,('twpgmwinnielin02'		,'0,2')
,('twpgmjacobhuang01'		,'0,1,2')
,('twpgmjacobhuang02'		,'0,2')

UPDATE t
	SET t.CustID  = c.custid
		,t.Recommend = c.recommend
		,t.Mrecommend = c.mrecommend
		,t.Srecommend = c.srecommend
FROM @Tmp t
CROSS APPLY (
	SELECT c.custid, c.recommend, c.mrecommend, c.srecommend
	FROM CustDB.dbo.Customer c WITH(NOLOCK) 
	WHERE c.username = t.Username
) AS C

INSERT INTO dbo.BonusTrans(CustID,Recommend,Mrecommend,Srecommend,Amount,StatusId,Creator,CreatedDate,PaymentDate,IsComplained)
SELECT t.CustID, t.Recommend, t.Mrecommend, t.Srecommend, 10000, m.StatusId, 8, GETDATE(), NULL, 0
FROM @Tmp t
CROSS APPLY(
	SELECT l.val AS StatusId
	FROM dbo.f_SplitString(t.StatusId, ',') l
) AS m