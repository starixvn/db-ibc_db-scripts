
DECLARE @cutoffdate			SMALLDATETIME
	,@oldHouseDeductionRate	SMALLMONEY
	,@oldHousePT			MONEY

DECLARE @tmpOldTransId TABLE (transid BIGINT, matchid INT)

SELECT	@cutoffdate = '2017-11-01'		
		,@oldHouseDeductionRate = 0.015
		,@oldHousePT = 0.5

INSERT INTO @tmpOldTransId(transid, matchid)
SELECT	transid, matchid
FROM	dbo.bettrans b WITH(NOLOCK)
WHERE	b.winlostdate < @cutoffdate
		AND bettype BETWEEN 912 AND 913
		AND 1 = CASE
					WHEN b.bettype = 912 AND oddsspread <> @oldHousePT THEN 1
					WHEN b.bettype = 913 AND odds <> @oldHouseDeductionRate THEN 1 					
					ELSE 0
				END

IF @@ROWCOUNT = 0
	RETURN

-- update 912.oddsspread
UPDATE b WITH(ROWLOCK, UPDLOCK)
	SET oddsspread = @oldHousePT
FROM	dbo.bettrans b
	INNER JOIN @tmpOldTransId t
		ON	b.transid = t.transid
			AND b.bettype = 912
WHERE	b.oddsspread <> @oldHousePT

-- update 913.odds, 913.winlost
UPDATE b WITH(ROWLOCK, UPDLOCK)
	SET odds = @oldHouseDeductionRate
		,winlost = CASE WHEN b.statusID BETWEEN 111 AND 113 THEN @oldHouseDeductionRate * b912.actual_stake ELSE b.winlost END
FROM	dbo.bettrans b
	INNER JOIN @tmpOldTransId t
		ON	b.transid = t.transid
			AND b.bettype = 913
	INNER JOIN dbo.bettrans b912 WITH(NOLOCK)
		ON	b.refno = b912.refno
			AND b.matchid = b912.matchid
			AND b912.bettype = 912
WHERE	b.odds <> @oldHouseDeductionRate

;WITH cteCashOutWLSharing
AS(
	SELECT	b.matchid
			,b.custid
			,SUM((b.winlost - b.actual_stake + cob.winlost - cob.actual_stake) * b.oddsspread) AS winlost
	FROM	dbo.bettrans b WITH(NOLOCK)
		INNER JOIN dbo.bettrans cob WITH(NOLOCK) 
			ON	cob.matchid = b.matchid 
				AND cob.custid = b.custid
				AND cob.refno = b.refno 
				AND cob.bettype NOT BETWEEN 912 AND 914 --normal bettype tickets			
	WHERE	EXISTS (SELECT TOP 1 1 FROM @tmpOldTransId t WHERE t.matchid = b.matchid)
			AND b.bettype = 912
			AND cob.statusID <> 0 --NOT running ticket
	GROUP BY b.matchid, b.custid
)
UPDATE	b WITH(ROWLOCK, UPDLOCK)
	SET winlost = CASE WHEN bt.winlost < 0 THEN ABS(bt.winlost) ELSE 0 END
		,actual_stake = CASE WHEN bt.winlost > 0 THEN bt.winlost ELSE 0 END
		,[status] = CASE 
						WHEN bt.Winlost < 0 THEN 'WON'
						WHEN bt.Winlost = 0 THEN 'DRAW'
						WHEN bt.Winlost > 0 THEN 'LOSE'
						ELSE [b].[status]
					END
		,statusID = CASE
						WHEN bt.Winlost < 0 THEN 112
						WHEN bt.Winlost = 0 THEN 111
						WHEN bt.Winlost > 0 THEN 113
						ELSE b.statusID
					END
FROM	dbo.bettrans b 
	INNER JOIN cteCashOutWLSharing bt
		ON	b.matchid = bt.MatchId
			AND b.custid = bt.CustId
			AND b.bettype = 914