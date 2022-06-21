/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20220614@Percy
	DB: DBTXN-bodb02
	Task: Manually correct epositiontaking data on bettrans
	https://nexdev.net/issues/172944
*/

USE bodb02
GO

-- bettrans: 2 rows
UPDATE b WITH (ROWLOCK)
SET b.epositiontaking = e.ExtraPT
FROM dbo.bettrans b
	CROSS APPLY (
		SELECT SUM(e.ExtraPT) AS ExtraPT
		FROM (SELECT DISTINCT ProductId, BetType FROM dbo.SportBettypeMatrix WITH (NOLOCK)) s
			INNER JOIN DBCUST.CustDB.dbo.Acc_GroupExtraPTSetting e WITH (NOLOCK) ON s.ProductId = e.ProductId
		WHERE b.bettype = s.BetType
			AND b.transdate BETWEEN e.FromDate AND e.ToDate
			AND e.Sporttype = 0 AND e.SubProduct = ''
			AND b.srecommend = e.SuperId
	) e
WHERE b.transid IN (115572455081, 115575953331)
	--AND b.bettype NOT IN (911,912,913,914)