/*
	Created: 20191028@Helen
	Tasks: Hold key match quarterly report - https://nexdev.net/issues/122713
	DB: DBLOG/bodb02
	
	Notes:
	exec NAP_Set_SettlementStatusUpd @MatchId=99000122,@Type=5,@IsEnabled=1,@AdminId=8
	Main match and having turn on MTD or Undecided or Pending
	"81002,81003,81004,81005     
	+ 1: IsPending - 81002
	+ 2: IsUndecided - 81003
	+ 3: IsUnderSettlement  - 81004       
	+ 4: IsSystemSettlement
	+ 5: IsMTDHold - 81005"

*/
-- dblog
USE bodb02

GO
USE bodb02

GO
DECLARE @startdate DATETIME = '01-01-2019'
CREATE TABLE #match_preparation (matchid INT, actionID INT)
CREATE TABLE #match_CalAction (matchid INT, actionID INT)

INSERT INTO #match_CalAction (matchid,actionID)
SELECT MatchID, ActionID
FROM bodb_CustomerLog.dbo.UserLog_Settle  WITH (NOLOCK)
WHERE ActionID IN (100,101,102) AND LogDate <=  '12-01-2019'
GROUP BY MatchID, ActionID
UNION ALL 
SELECT MatchID, ActionID
FROM bodb_CustomerLog_Archive.dbo.UserLog_Settle  WITH (NOLOCK)
WHERE LogDate >= @startdate AND ActionID IN (100,101,102)
GROUP BY MatchID, ActionID

INSERT INTO #match_preparation (matchid,actionID)
SELECT MatchID, ActionID
FROM bodb_CustomerLog.dbo.UserLog_Settle  WITH (NOLOCK)
WHERE ActionID IN (81002,81003,81005) AND LogDate <= '12-01-2019'
GROUP BY MatchID, ActionID
UNION ALL 
SELECT MatchID, ActionID
FROM bodb_CustomerLog_Archive.dbo.UserLog_Settle  WITH (NOLOCK)
WHERE LogDate >= @startdate AND ActionID IN (81002,81003,81005)
GROUP BY MatchID, ActionID

SELECT DISTINCT m1.matchid
INTO #match_list
FROM #match_preparation m1
	INNER JOIN #match_CalAction m2 ON m1.matchid = m2.matchid


SELECT d.matchid,l.leagueid, l.leaguename, m.homeid, m.awayid, m.kickofftime, m.globalshowtime, m.AutoSetting
	,case when isnull(l.[Group],'')=''  then 'Others' else l.[Group] end LeagueGroup
	, m.eventdate	
INTO #match_details
FROM #match_list d
	CROSS APPLY (
		SELECT	matchid, leagueid, homeid, awayid, kickofftime, globalshowtime, m.AutoSetting, m.eventdate
		FROM	dbarc.bodb_archive.dbo.match_bk m WITH (NOLOCK)
		WHERE	sporttype = 1
				AND matchid = d.matchid
				AND matchcode not like '%hedge%'
			
		UNION ALL
		SELECT  matchid, leagueid, homeid, awayid, kickofftime, globalshowtime, m.AutoSetting, m.eventdate
		FROM	dbo.match14 m WITH (NOLOCK)
		WHERE	sporttype = 1
				AND matchid = d.matchid
				AND matchcode not like '%hedge%'

		UNION ALL
		SELECT  matchid, leagueid, homeid, awayid, kickofftime, globalshowtime, m.AutoSetting, m.eventdate
		FROM	dbo.match m WITH (NOLOCK)
		WHERE	sporttype = 1
				AND matchid = d.matchid	
				AND matchcode not like '%hedge%'	
	) m
	INNER JOIN dbo.League l WITH (NOLOCK) ON m.leagueid = l.leagueid AND l.isTest = 0 AND ISNULL(l.[Group],'') NOT IN ('Specials')
	
--- FINAL results

SELECT m1.matchid,m2.leagueid,m2.LeagueGroup, m2.leaguename, m2.homeid, m2.awayid, m2.kickofftime, m2.globalshowtime, m2.AutoSetting, m2.eventdate
	, MAX(CASE WHEN m1.actionID = 81002 THEN 1 ELSE 0 END) AS Pending
	, MAX(CASE WHEN m1.actionID = 81003 THEN 1 ELSE 0 END) AS Undecided
	, MAX(CASE WHEN m1.actionID = 81005 THEN 1 ELSE 0 END) AS MTD
INTO #Final_Result	
FROM #match_preparation m1
	INNER JOIN #match_details m2 ON m1.matchid = m2.matchid
GROUP BY m1.matchid,m2.leagueid,m2.LeagueGroup, m2.leaguename, m2.homeid, m2.awayid, m2.kickofftime, m2.globalshowtime, m2.AutoSetting, m2.eventdate

SELECT kickofftime,Year(eventdate), Month(eventdate), r.eventdate,r.leagueid, r.leaguename,r.LeagueGroup, r.matchid, h.teamname AS Home, a.teamname AS Away, CASE WHEN 1 & r.AutoSetting = 1 THEN 1 ELSE 0 END AS IsautoPayOut, r.MTD, r.Undecided, r.Pending
FROM #Final_Result r
	INNER JOIN dbo.team h WITH (NOLOCK) ON r.homeid = h.teamid
	INNER JOIN dbo.team a WITH (NOLOCK) ON r.awayid = a.teamid
ORDER BY LeagueGroup, leaguename	
	
DROP TABLE #Final_Result
DROP TABLE #match_CalAction
DROP TABLE #match_details
DROP TABLE #match_list
DROP TABLE #match_preparation	
