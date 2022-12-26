/*<info serverAlias="DBGRP01L-bodb02"></info>*/
USE bodb02
GO
/*
	Created: 20221226@Evan
	DB: DBGRP01L-bodb02 (run on SiteDB1)
	Task: Update rate for tickets on siteDB01 that missed ex rate [RedmineID: #182005]
*/

DECLARE @TbTransId TABLE (TransId BIGINT)
INSERT INTO @TbTransId 
VALUES	(65055319880892432),
		(65055538924224550),
		(65055560399061030),
		(65055560399061031),
		(65055543219191845);

CREATE TABLE #bettrans (transid BIGINT, actualrate FLOAT, virtualrate FLOAT)

-- update for SB's tickets (without virtualrate)
INSERT INTO #bettrans(transid, actualrate, virtualrate)
SELECT transid, e.actualrate, e.actualrate
FROM dbo.bettrans b WITH(NOLOCK) 
	,CustDB.dbo.exchange e WITH (NOLOCK)
WHERE b.currency = e.exchangeid AND b.actualrate <> e.actualrate 
	AND (b.bettype <= 30 OR b.bettype BETWEEN 50 AND 19998) 
	AND b.actualrate = b.virtualrate
	AND b.TransId IN (SELECT TransId FROM @TbTransId)

UPDATE b WITH(ROWLOCK, UPDLOCK)
SET b.actualrate = t.actualrate,
	b.virtualrate = t.virtualrate
FROM #bettrans t 
	INNER JOIN dbo.bettrans b ON t.transid = b.transid 

DROP TABLE #bettrans
GO

