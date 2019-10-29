--db061.bodb_archive
------------[UserLog_P_SuspenderConfirm]: 2018-12-08 00:01:25.297 - >	2019-05-09 23:54:48.533
------ Major league
select	l.leaguename,m1.MatchId, m1.SourceId, m2.StatusId,m2.CalculationType
		, m1.CreatedDate as SBO_conirm, m3.eventdate, m3.homeid, m3.awayid
		,case when isnull(l.[Group],'')=''  then 'Others' else l.[Group] end LeagueGroup
		,l.leagueid
into #temp_MajorLeague																																														
from ProviderResultDetail_bk m1 WITH (NOLOCK)																									
	INNER JOIN AutoPayoutResult_bk m2 WITH (NOLOCK) ON m1.MatchId = m2.MatchId  
										AND m1.TypeId = m2.CalculationType	
										AND m1.SourceId = m2.SourceId																							
	INNER JOIN match_bk m3 WITH (NOLOCK) ON m3.matchid = m1.MatchId	
	INNER JOIN bodb02.dbo.league l with (nolock) ON l.leagueid = m3.leagueid and l.istest = 0 AND ISNULL(l.[Group],'') NOT IN ('Specials')	
																								
WHERE m2.CalculationType in (1,2) and m1.CreatedDate >=  '2019-01-01' and  m1.SourceId = 1 -- SBO																									
	AND m2.StatusId = 2 -- complete	
	-- major league
	AND l.leaguename in ('*ENGLISH PREMIER LEAGUE','*GERMANY-BUNDESLIGA I','*ITALY SERIE A','*SPAIN PRIMERA LALIGA')
	
------- minor League
select	l.leaguename,m1.MatchId, m1.SourceId, m2.StatusId,m2.CalculationType
		, m1.CreatedDate as SBO_conirm, m3.eventdate, m3.homeid, m3.awayid
		,case when isnull(l.[Group],'')=''  then 'Others' else l.[Group] end LeagueGroup
		,l.leagueid
into #temp_MinorLeague																																														
from ProviderResultDetail_bk m1 WITH (NOLOCK)																									
	INNER JOIN AutoPayoutResult_bk m2 WITH (NOLOCK) ON m1.MatchId = m2.MatchId  
										AND m1.TypeId = m2.CalculationType	
										AND m1.SourceId = m2.SourceId																							
	INNER JOIN match_bk m3 WITH (NOLOCK) ON m3.matchid = m1.MatchId	
	INNER JOIN bodb02.dbo.league l with (nolock) ON l.leagueid = m3.leagueid and l.istest = 0 AND ISNULL(l.[Group],'') NOT IN ('Specials')		
																								
WHERE m2.CalculationType in (1,2) and m1.CreatedDate >=  '2019-01-01'  and m1.SourceId = 1 -- SBO																									
	AND m2.StatusId = 2 -- complete	
	-- minor league 1
	AND l.leaguename in ('AUSTRALIA A-LEAGUE','BELGIUM FIRST DIVISION A','BRAZIL SERIE A','DENMARK SUPER LEAGUE','English League Championship','FINLAND VEIKKAUSLIIGA','FRANCE LIGUE 1','France Ligue 2','GERMANY BUNDESLIGA 2','HOLLAND EREDIVISIE'
						,'Italy Serie B','JAPAN J-LEAGUE DIVISION 1','Japan J-League Division 2','NORWAY ELITESERIEN','PORTUGAL SUPER LIGA','SCOTLAND PREMIERSHIP','Spain Segunda Division','SWEDEN ALLSVENSKAN','SWITZERLAND SUPER LEAGUE'	)


SELECT * 
INTO #SuspenderConfirm
FROM dbdw2.bodb_Adhoc.dbo.UserLog_P_SuspenderConfirm WITH (NOLOCK)

--  major league result
SELECT 'Major League' Type_Leage
	, Year(eventdate) as Year_eventdate
	, month(eventdate) as Month_eventdate
	, eventdate
	, m1.leagueid, m1.leaguename,m1.LeagueGroup, m1.matchid, h.teamname AS Home, a.teamname AS Away
	, m1.sourceid, m1.statusid, m1.calculationType
	, sus.logdate as Suspender_confirm, DATEDIFF (SECOND,sus.logdate, m1.SBO_conirm) as Diff_Seconds
FROM #temp_MajorLeague m1
	inner join #SuspenderConfirm sus WITH (NOLOCK) ON m1.MatchId = sus.matchid and m1.CalculationType = sus.ActionID
	INNER JOIN bodb02.dbo.team h WITH (NOLOCK) ON m1.homeid = h.teamid
	INNER JOIN bodb02.dbo.team a WITH (NOLOCK) ON m1.awayid = a.teamid			
union all
--  major league result

SELECT 'Minor League 1' Type_Leage
	, Year(eventdate) as Year_eventdate
	, month(eventdate) as Month_eventdate
	, eventdate

	, m1.leagueid, m1.leaguename,m1.LeagueGroup, m1.matchid, h.teamname AS Home, a.teamname AS Away
	, m1.sourceid, m1.statusid, m1.calculationType
	
	, sus.logdate as Suspender_confirm, DATEDIFF (SECOND,sus.logdate, m1.SBO_conirm) as Diff_Seconds
FROM #temp_MinorLeague m1
	inner join #SuspenderConfirm sus WITH (NOLOCK) ON m1.MatchId = sus.matchid and m1.CalculationType = sus.ActionID
	INNER JOIN bodb02.dbo.team h WITH (NOLOCK) ON m1.homeid = h.teamid
	INNER JOIN bodb02.dbo.team a WITH (NOLOCK) ON m1.awayid = a.teamid	
order by 	eventdate				


drop table #temp_MajorLeague
drop table #temp_MinorLeague