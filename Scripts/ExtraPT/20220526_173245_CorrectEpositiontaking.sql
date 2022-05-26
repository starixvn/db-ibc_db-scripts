/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20220526@Percy
	DB: DBTXN-bodb02
	Task: Manually correct epositiontaking data on bettrans/bettransRnG
	https://nexdev.net/issues/173245
*/

USE bodb02
GO

-- bettransRnG
UPDATE b WITH (ROWLOCK)
SET b.epositiontaking = e.ExtraPT
FROM dbo.bettransRnG b
	CROSS APPLY (
		SELECT SUM(e.ExtraPT) AS ExtraPT
		FROM (SELECT DISTINCT ProductId, BetType FROM dbo.SportBettypeMatrix WITH (NOLOCK)) s
			INNER JOIN DBCUST.CustDB.dbo.Acc_GroupExtraPTSetting e WITH (NOLOCK) ON s.ProductId = e.ProductId
		WHERE b.gameID = s.BetType
			AND b.transdate BETWEEN e.FromDate AND e.ToDate
			AND e.Sporttype = 0 AND e.SubProduct = ''
			AND b.srecommend = e.SuperId
	) e
WHERE b.transid IN (104361508430,104361771563,104361626025,104361572702,104361511241)

-- Update sum ticket on bettrans from bettransRnG
DECLARE @bettransDetail TABLE (transid BIGINT, refno BIGINT, epositiontaking SMALLMONEY)

INSERT INTO @bettransDetail (transid, refno, epositiontaking)
SELECT transid, refno, epositiontaking
FROM dbo.bettransRnG WITH (NOLOCK)
WHERE transid IN (104361508430,104361771563,104361626025,104361572702,104361511241)

INSERT INTO @bettransDetail (transid, refno, epositiontaking)
SELECT b.transid, b.refno, b.epositiontaking
FROM dbo.bettransRnG b WITH (NOLOCK)
	LEFT JOIN @bettransDetail bt ON b.transid = bt.transid
WHERE bt.transid IS NULL
	AND b.RefNo IN (SELECT t.refno FROM @bettransDetail t)

UPDATE b WITH (ROWLOCK)
SET b.epositiontaking = t.epositiontaking
FROM dbo.bettrans b
	INNER JOIN (
		SELECT refno, AVG(epositiontaking) AS epositiontaking
		FROM @bettransDetail
		GROUP BY refno
	) t ON b.transid = t.refno