--db061.bodb_archive
------------[UserLog_P_SuspenderConfirm]: 2018-12-08 00:01:25.297 - >	2019-05-09 23:54:48.533
------ Major league

select	l.leaguename,m1.MatchId, m1.SourceId, 0 StatusId,m1.TypeId
		, m1.CreatedDate as SBO_conirm, m3.eventdate, m3.homeid, m3.awayid
		,case when isnull(l.[Group],'')=''  then 'Others' else l.[Group] end LeagueGroup
		,l.leagueid
into #temp_MinorLeague																																														
from ProviderResultDetail_bk m1 WITH (NOLOCK)																									
	--INNER JOIN AutoPayoutResult_bk m2 WITH (NOLOCK) ON m1.MatchId = m2.MatchId  
	--									AND m1.TypeId = m2.CalculationType	
	--									AND m1.SourceId = m2.SourceId																							
	INNER JOIN match_bk m3 WITH (NOLOCK) ON m3.matchid = m1.MatchId	
	INNER JOIN bodb02.dbo.league l with (nolock) ON l.leagueid = m3.leagueid and l.istest = 0 AND ISNULL(l.[Group],'') NOT IN ('Specials')		
																								
WHERE m1.CreatedDate >=  '2019-01-01'  and m1.SourceId = 1 -- SBO																									

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
	, sus.logdate as Suspender_confirm,m1.SBO_conirm,DATEDIFF (SECOND,sus.logdate, m1.SBO_conirm) as Diff_Seconds
FROM #temp_MajorLeague m1
	inner join #SuspenderConfirm sus WITH (NOLOCK) ON m1.MatchId = sus.matchid and m1.CalculationType = sus.ActionID
	INNER JOIN bodb02.dbo.team h WITH (NOLOCK) ON m1.homeid = h.teamid
	INNER JOIN bodb02.dbo.team a WITH (NOLOCK) ON m1.awayid = a.teamid			
union all
--  major league result

SELECT 
	 Year(eventdate) as Year_eventdate
	, month(eventdate) as Month_eventdate
	, eventdate

	, m1.leagueid, m1.leaguename,m1.LeagueGroup, m1.matchid, h.teamname AS Home, a.teamname AS Away
	, m1.sourceid, m1.statusid, m1.TypeId
	
	, sus.logdate as Suspender_confirm, m1.SBO_conirm,DATEDIFF (SECOND,sus.logdate, m1.SBO_conirm) as Diff_Seconds
FROM #temp_MinorLeague m1
	inner join #SuspenderConfirm sus WITH (NOLOCK) ON m1.MatchId = sus.matchid and m1.TypeId = sus.ActionID
	INNER JOIN bodb02.dbo.team h WITH (NOLOCK) ON m1.homeid = h.teamid
	INNER JOIN bodb02.dbo.team a WITH (NOLOCK) ON m1.awayid = a.teamid	
order by 	eventdate				

select count(1) from #temp_MinorLeague

drop table #temp_MinorLeague
