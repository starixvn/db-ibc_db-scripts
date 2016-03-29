----DBTGRS / bodb_TGRS

select CustId,
MatchId,
EventDate,
SportType,
BetType,
LeagueId,
Stake,
WinLost,
Comm,
BetCount,
HomeId,
AwayId,
MatchCode,
WorkShift 
INTO #T
FROM TraderPerformance WITH (NOLOCK)
GROUP BY  CustId,
MatchId,
EventDate,
SportType,
BetType,
LeagueId,
Stake,
WinLost,
Comm,
BetCount,
HomeId,
AwayId,
MatchCode,
WorkShift 
having count (*) > 1


SELECT P.* 
INTO #DupData
FROM TraderPerformance P WITH (NOLOCK)  
INNER JOIN #T T
	ON P.CustID = T.CustID 
	AND P.MatchID = T.MatchID 
	AND P.Bettype = T.bettype 


SELECT D.*
INTO #ValidData
FROM #DupData D
INNER JOIN TraderGrade_History H
	On D.CustID = H.CustID 
	AND D.Grade = H.Grade
	AND D.EventDate BETWEEN BeginDate AND ISNULL(EndDate,'9999-12-31')






DELETE T
---SELECT  T.*
FROM TraderPerformance  T
INNER JOIN

( 
	SELECT * FROM #DupData D
	EXCEPT 
	SELECT * FROM #ValidData V 
	) D 
	ON D.CustID = T.CustID 
	AND D.MatchID = T.MatchID 
	AND D.Bettype = T.bettype 
	AND D.Grade = T.Grade
	AND D.EventDate = T.EventDate
	AND D.Winlost = T.WinLost

 