USE bodb02
GO

/*
Create : 20200320@Sophia
Task: Update epositiontaking of VirtualGames [redmine: #130807]
DB: DBTXN.bodb02

*/

CREATE TABLE #Extra (SuperID INT, ExtraPT Decimal (9,8))
INSERT INTO #Extra
SELECT DISTINCT SuperID , ExtraPT 
FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK) 
WHERE GROUPNAME IN ('ACCYEN789','ACCYEN889','ACCUT')
AND ProductID = 38



CREATE TABLE #Data (TransID BIGINT, ExtraPT decimal (9,8))
INSERT INTO #Data (TransID, e.ExtraPT)
SELECT b.TransID, e.ExtraPT
FROM Bettrans b WITH (NOLOCK) 
INNER JOIN Sportbettypematrix s WITH (NOLOCK) 
	ON s.Bettype = b.Bettype 
INNER JOIN #Extra e
	ON e.SuperID = b.srecommend
WHERE s.ProductID = 38
	and b.epositiontaking = 0
	and b.currency <> 20


UPDATE b
SET b.epositiontaking = t.ExtraPT
FROM Bettrans b WITH (ROWLOCK)
INNER JOIN #Data t 
ON t.TransID = b.TransID


