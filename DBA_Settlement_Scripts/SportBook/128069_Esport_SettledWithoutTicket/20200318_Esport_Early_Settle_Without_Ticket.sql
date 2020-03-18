/*	
	Created: 20200318@Sol
	Task: Get match that settled without ticket - [Redmine:#128069]
	DB: DBTXN/bodb02
*/

WITH rs AS 
(
	SELECT DISTINCT r.matchid, r.ResourceID, BetID--, sp.BetType
	FROM  DBPRO.bodb02.dbo.ResultDetailES r WITH(NOLOCK)
			INNER JOIN match m WITH(NOLOCK)
				ON m.matchid = r.matchid
			INNER JOIN SettlementSpecialBettypeProfile sp WITH (NOLOCK) ON sp.ResourceID = r.Resourceid 
	WHERE SettlementStatusID = 4 AND ResultStatusID = 5
			AND m.eventdate >= '20200225'
			AND sp.SettleType = 'ear'
			AND sp.SportType = 43
)
SELECT  * 
FROM 
	rs
	OUTER APPLY 
	(
		SELECT bt.transid, bt.statusID
		FROM bettrans bt WITH (NOLOCK) 
		WHERE bt.matchid = rs.matchid
			--and bt.bettype = rs.BetType
			AND (rs.Betid = 0 OR rs.BetID = bt.BetID)
	) bt
WHERE bt.transid IS NULL 
GO