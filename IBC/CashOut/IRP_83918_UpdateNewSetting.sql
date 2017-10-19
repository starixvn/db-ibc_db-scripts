
DECLARE @cutoffdate			SMALLDATETIME
	,@newHouseDeductionRate	SMALLMONEY -- odds
	,@newHousePT			MONEY -- oddsspread

DECLARE @tmpNewTransId TABLE (transid BIGINT, matchid INT)

SELECT	@cutoffdate = '2017-11-01'
		,@newHouseDeductionRate = 0.03
		,@newHousePT = 1

INSERT INTO @tmpNewTransId(transid, matchid)
SELECT	transid, matchid
FROM	dbo.bettrans b WITH(NOLOCK)
WHERE	b.winlostdate >= @cutoffdate
		AND bettype BETWEEN 912 AND 913
		AND 1 = CASE
					WHEN b.bettype = 912 AND oddsspread <> @newHousePT THEN 1
					WHEN b.bettype = 913 AND odds <> @newHouseDeductionRate THEN 1 					
					ELSE 0
				END
IF @@ROWCOUNT = 0
	RETURN

-- update 912.oddsspread
UPDATE b WITH(ROWLOCK, UPDLOCK)
	SET oddsspread = @newHousePT
FROM	dbo.bettrans b
	INNER JOIN @tmpNewTransId t
		ON	b.transid = t.transid
			AND b.bettype = 912
WHERE	b.oddsspread <> @newHousePT

-- update 913.odds, 913.winlost
UPDATE b WITH(ROWLOCK, UPDLOCK)
	SET odds = @newHouseDeductionRate
		,winlost = CASE WHEN b.statusID BETWEEN 111 AND 113 THEN @newHouseDeductionRate * b912.actual_stake ELSE b.winlost END
FROM	dbo.bettrans b
	INNER JOIN @tmpNewTransId t
		ON	b.transid = t.transid
			AND b.bettype = 913
	INNER JOIN dbo.bettrans b912 WITH(NOLOCK)
		ON	b.refno = b912.refno
			AND b.matchid = b912.matchid
			AND b912.bettype = 912
WHERE	b.odds <> @newHouseDeductionRate

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
	WHERE	EXISTS (SELECT TOP 1 1 FROM @tmpNewTransId t WHERE t.matchid = b.matchid)
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