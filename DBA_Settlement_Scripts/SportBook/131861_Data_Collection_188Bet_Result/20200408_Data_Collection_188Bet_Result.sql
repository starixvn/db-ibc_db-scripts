/*	
	Created: 20200408@Sol
	Task: Data Collection - Get Results of 188Bet from Info Site - [Redmine:#131861]
	DB: DBARC/bodb_Archive
*/

USE bodb_Archive

GO 

SELECT l.leaguename,m1.MatchId, m1.SourceId, m1.CreatedDate AS [188Bet_conirm], m3.eventdate, m3.homeid, m3.awayid
		,CASE WHEN ISNULL(l.[Group],'')='' THEN 'Others' ELSE l.[Group] END LeagueGroup
		,l.leagueid
		,m1.HomeValue AS [188BetHomeScore] , m1.AwayValue AS [188BetAwayScore]
		,CASE WHEN m1.TypeId = 1 then m3.hthomescore ELSE m3.finalhomescore END AS OWHomeScore
		,CASE WHEN m1.TypeId = 1 then m3.htawayscore ELSE m3.finalawayscore END AS OWAwayScore
		,h.teamname AS Home, a.teamname AS Away
		,m1.TypeId
INTO #temp_MajorLeague188Bet																																														
FROM ProviderResultDetail_bk m1 WITH (NOLOCK)																									
	INNER JOIN match_bk m3 WITH (NOLOCK) ON m3.matchid = m1.MatchId	
	INNER JOIN bodb02.dbo.league l with (NOLOCK) ON l.leagueid = m3.leagueid AND l.istest = 0 AND ISNULL(l.[Group],'') NOT IN ('Specials')	
	INNER JOIN bodb02.dbo.team h WITH (NOLOCK) ON m3.homeid = h.teamid
	INNER JOIN bodb02.dbo.team a WITH (NOLOCK) ON m3.awayid = a.teamid
WHERE m1.TypeId IN (1,2) AND m1.CreatedDate >=  '2020-01-01' AND m1.SourceId = 2 -- 188bet																									
	

------------------

SELECT 
		a.leagueid, a.leaguename, a.LeagueGroup,
		a.eventdate, a.MatchId, a.Home, a.Away,
		a.TypeId,
		a.[188BetHomeScore] + ' - ' + a.[188BetAwayScore] AS [188BetScore],
		b.HomeValue + ' - ' + b.AwayValue AS [SBOScore],
		CAST(a.OWHomeScore AS VARCHAR(2)) + ' - ' + CAST(a.OWAwayScore AS VARCHAR(2)) AS [OWScore],
		DATEDIFF (SECOND,a.[188Bet_conirm], b.CreatedDate) AS Diff_Seconds
FROM #temp_MajorLeague188Bet a
	OUTER APPLY 
	(
		SELECT * 
		FROM ProviderResultDetail_bk m1 WITH (NOLOCK)		
		WHERE m1.CreatedDate >=  '2020-01-01' AND m1.SourceId = 1 -- sbo
			AND a.MatchId = m1.MatchId AND a.typeid = m1.TypeId
	) b 
ORDER BY a.eventdate, a.MatchId

SELECT COUNT(1) AS TotalRow188Bet
FROM #temp_MajorLeague188Bet

SELECT COUNT(1) AS TotalRowSBO
FROM ProviderResultDetail_bk m1 WITH (NOLOCK)																									
	INNER JOIN match_bk m3 WITH (NOLOCK) ON m3.matchid = m1.MatchId	
	INNER JOIN bodb02.dbo.league l with (NOLOCK) ON l.leagueid = m3.leagueid AND l.istest = 0 AND ISNULL(l.[Group],'') NOT IN ('Specials')	
	INNER JOIN bodb02.dbo.team h WITH (NOLOCK) ON m3.homeid = h.teamid
	INNER JOIN bodb02.dbo.team a WITH (NOLOCK) ON m3.awayid = a.teamid
WHERE m1.TypeId IN (1,2) AND m1.CreatedDate >=  '2020-01-01' AND m1.SourceId = 1 -- sbo

DROP TABLE #temp_MajorLeague188Bet