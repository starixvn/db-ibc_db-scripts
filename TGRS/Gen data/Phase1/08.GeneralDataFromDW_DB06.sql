--DB06
USE [bodb_TGRS]
GO

SET NOCOUNT ON

DECLARE @fromdate datetime,@todate datetime

SELECT @fromdate ='2013-1-01 00:00:00'
SELECT @todate = DATEADD(DAY,-1,DATEADD(YEAR,1,@fromdate))

IF OBJECT_ID('tempdb..#tmpMatch') IS NOT NULL    DROP TABLE #tmpMatch

CREATE TABLE #tmpMatch(matchid INT,matchcode VARCHAR(100),leagueid INT,homeid INT,awayid INT)

DECLARE @SQL NVARCHAR(MAX) 

SET @SQL = 'INSERT INTO #tmpMatch(matchid,matchcode,leagueid,homeid,awayid)
SELECT matchid,matchcode,leagueid,homeid,awayid FROM OPENQUERY(DBDW2,''SELECT matchid,matchcode,leagueid,homeid,awayid
FROM bodb_Staging.dbo.match m WITH (NOLOCK)
WHERE m.eventdate between ''''' + CONVERT(NVARCHAR(20), @fromdate,101) +''''' and ''''' + CONVERT(NVARCHAR(20), @todate,101) +''''' 
	and m.sporttype = 1 and m.matchcode not like ''''%hedge%'''''')'

EXEC(@SQL) 

IF OBJECT_ID('tempdb..#tmpTraderPer') IS NOT NULL    DROP TABLE #tmpTraderPer

CREATE TABLE #tmpTraderPer(CustID INT,matchid INT,
	bettype INT,
	OUtype INT,
	matchcode varchar(100),
	TeamID INT,
	Grade INT)

INSERT INTO #tmpTraderPer(CustID,matchid,bettype,OUtype,matchcode,TeamID,Grade)
select a.operatorid CustID, m.matchID,  
    case when (a.bettype = 1 or a.bettype =5)  and (a.operatortype = 1) then 1   
      when (a.bettype = 1 and a.operatortype = 2) then 7
      when (a.bettype = 2 and a.operatortype = 1) then 3
      when (a.bettype = 2 and a.operatortype = 2) then 8
      when (a.bettype = 3 and a.operatortype = 1) then 5
      when (a.bettype = 3 and a.operatortype = 2) then 15
      --when (a.bettype = 4 and a.operatortype = 1) then 22 -- Next Goal
      when (a.bettype = 4 and a.operatortype = 1) then 2
      when (a.bettype = 4 and a.operatortype = 2) then 12
    else 0  end bettype, 
	case
		when leaguename LIKE '%SPECIFIC 15 MINS NUMBER OF CORNERS%' THEN 6
		when leaguename LIKE '%SPECIFIC 15 MINS%' AND t.teamname LIKE '%No. of Corners%' THEN 6
		when t.teamname LIKE '%No.of Corners%' then 1
		when t.teamname LIKE '%Total Bookings' then 3
		when t.teamname LIKE '%Booking' then 5
		--when a.bettype=5 then 4
		when t.teamname LIKE '%Corner%' then 4
		when leaguename LIKE '%SPECIFIC 15 MINS TOTAL BOOKINGS%' then 7
		when leaguename LIKE '%SPECIFIC 15 MINS%' AND t.teamname LIKE '%TOTAL BOOKINGS%' then 7
		when leaguename LIKE '%SPECIFIC 15 MINS%' then 2
		when leaguename LIKE '%SPECIFIC 10 MINS%' then 8
		when leaguename LIKE '%SPECIALS' and (t.teamname LIKE '%Over' or t.teamname LIKE '%Under') THEN 9 
	   else 0  
  end  OUtype,
	m.matchcode,
	td.TeamId,
	td.Grade
  from [bodb_archive].[dbo].[Dot_Admin_Assignment_Operator_bk]  a WITH (NOLOCK)
  INNER JOIN #tmpMatch m  on a.matchid=m.matchid
  LEFT JOIN bodb02.dbo.Team t with(nolock) on t.teamid=m.homeid
  LEFT JOIN bodb02.dbo.league l with(nolock) on m.leagueid=l.leagueid
  LEFT JOIN [bodb_TGRS].dbo.Trader td with(nolock) on a.OperatorID = td.CustId
  where   a.operatortype < 3 

DELETE #tmpTraderPer WHERE TeamId IS NULL OR Grade IS NULL

IF OBJECT_ID('tempdb..#tmpTraderPerformance') IS NOT NULL    DROP TABLE #tmpTraderPerformance

CREATE TABLE [dbo].#tmpTraderPerformance(
	[CustId] [int] NULL,
	[MatchId] [int] NULL,
	matchcode VARCHAR(100) NULL,
	[EventDate] [date] NULL,
	[SportType] [tinyint] NULL,
	[BetType] [smallint] NULL,
	[LeagueId] [int] NULL,
	TurnoverIBC [money] NULL,
	WinlossIBC [money] NULL,
	[Comm] [money] NULL,
	[BetCount] [int] NULL,
	Grade [int] NULL,
	TeamID [int] NULL
) 

INSERT INTO #tmpTraderPerformance([CustId],[MatchId],BetType,LeagueId,Grade,TeamID,TurnoverIBC,WinlossIBC,[Comm],BetCount)
SELECT 
	cm.custid,
	b.[MatchId],
    CASE  
		when b.bettype =15 then 1 
		when b.bettype =5 and cm.OUtype =0 then 2
		when b.bettype =5 and cm.OUtype =2 then 3
		WHEN b.BetType =5 AND cm.OUtype =8 THEN 22		--10mins 1x2
		when b.bettype =7 then 4
		when b.bettype =1 and cm.OUtype =0 then 5
		WHEN b.BetType =1 AND cm.OUtype =8 THEN 23		--10mins HDP
		when b.bettype =1 and cm.OUType =2 then 6
		when b.bettype =8 and cm.OUtype =0 then 7
		when b.bettype =3 and cm.OUtype =0 then 8
		when b.bettype =3 and cm.OUType =2 then 9
		when b.bettype =3 and cm.OUtype =8 then 10
		when b.bettype IN (3,8) and OUtype = 9 then 11
		when b.bettype =8 and cm.OUtype =1 then 12
		when b.bettype =3 and cm.OUType =1 then 13
		when b.bettype =3 and cm.OUtype =6 then 14
		when b.bettype =1 and cm.OUtype =4 then 15
		when b.bettype =8 and cm.OUType =3 then 16
		when b.bettype =3 and cm.OUType =3 then 17
		when b.bettype =3 and cm.OUtype =7 then 18
		when b.bettype =1 and cm.OUtype =5 then 19
		when b.bettype =12 then 20
		when b.bettype =2 then 21
		else b.bettype
		end BetType,
	b.[LeagueId],
	cm.Grade,
	cm.TeamId,
	SUM(CASE WHEN b.status in (12,13) THEN 0.5*b.TurnoverIBCVirtual ELSE b.TurnoverIBCVirtual END) TurnoverIBC,
	SUM(b.winlossibcvirtual-b.CommissionVirtual) WinlossIBC,
	SUM(-b.CommissionVirtual) Commission,
	SUM(b.betcount) BetCount
   from DBDW2.bodb_account.dbo.rptMatch b with(nolock)   
    INNER JOIN #tmpTraderPer cm 
		ON b.matchid=cm.matchid and b.bettype = cm.bettype
   where 
	b.rptdate between @fromdate and @todate  AND
	b.isLive =  1 and
	b.status NOT IN  (-1,18,9,10,14,3) AND 
	(b.CustomerCategory not in (30) OR (b.CustomerCategory = 30 AND b.turnoverIBC <> 0)) 
   group by
	cm.custid,
	b.[MatchId],
    CASE  
		when b.bettype =15 then 1 
		when b.bettype =5 and cm.OUtype =0 then 2
		when b.bettype =5 and cm.OUtype =2 then 3
		WHEN b.BetType =5 AND cm.OUtype =8 THEN 22		--10mins 1x2
		when b.bettype =7 then 4
		when b.bettype =1 and cm.OUtype =0 then 5
		WHEN b.BetType =1 AND cm.OUtype =8 THEN 23		--10mins HDP
		when b.bettype =1 and cm.OUType =2 then 6
		when b.bettype =8 and cm.OUtype =0 then 7
		when b.bettype =3 and cm.OUtype =0 then 8
		when b.bettype =3 and cm.OUType =2 then 9
		when b.bettype =3 and cm.OUtype =8 then 10
		when b.bettype IN (3,8) and OUtype = 9 then 11
		when b.bettype =8 and cm.OUtype =1 then 12
		when b.bettype =3 and cm.OUType =1 then 13
		when b.bettype =3 and cm.OUtype =6 then 14
		when b.bettype =1 and cm.OUtype =4 then 15
		when b.bettype =8 and cm.OUType =3 then 16
		when b.bettype =3 and cm.OUType =3 then 17
		when b.bettype =3 and cm.OUtype =7 then 18
		when b.bettype =1 and cm.OUtype =5 then 19
		when b.bettype =12 then 20
		when b.bettype =2 then 21
		else b.bettype
		end,
	b.[LeagueId],
	cm.Grade,
	cm.TeamId
		 
	DELETE #tmpTraderPerformance WHERE  TurnoverIBC IS NULL

	IF OBJECT_ID('tempdb..#tmpBetType') IS NOT NULL    DROP TABLE #tmpBetType	

	CREATE TABLE #tmpBetType(BetType SMALLINT,TypeName VARCHAR(100),MapBetType SMALLINT)

	INSERT INTO #tmpBetType(BetType,TypeName,MapBetType)
	VALUES (1,'1st 1X2',15),
		(2,'1X2',5),
		(3,'15mins 1X2',-4),
		(4,'1st HDP',7),
		(5,'HDP',1),
		(6,'15mins HDP',-1),
		(7,'1st O/U',8),
		(8,'O/U',3),
		(9,'15mins O/U',-5),
		(10,'10mins O/U',-6),
		(11,'Single Team O/U',-11),
		(12,'1st No. of Corner',-12),
		(13,'No. of Corner',-13),
		(14,'Corners 15mins O/U',-7),
		(15,'Next Corner',-2),
		(16,'1st TotalBookings',-9),
		(17,'Total Bookings',-8),
		(18,'Total Bookings 15mins O/U',-10),
		(19,'Next Booking',-3),
		(20,'1st O/E',12),
		(21,'O/E',2),
		(22,'10mins 1X2',-14),
		(23,'10mins HDP',-15)

IF OBJECT_ID('tempdb..#SUMTraderPerformance') IS NOT NULL    DROP TABLE #SUMTraderPerformance

SELECT 
	td.custid,
	td.matchid,
	--td.EventDate,
	td.SportType,		
	bt.MapBetType [BetType],
	td.LeagueId,
	td.TeamId,
	td.Grade,
	SUM(td.TurnoverIBC) [Stake],
	SUM(td.WinlossIBC) [WinLost],
	SUM(td.[Comm]) [Comm],
	SUM(td.BetCount) BetCount 
INTO #SUMTraderPerformance
FROM #tmpTraderPerformance td  WITH(NOLOCK)
LEFT JOIN #tmpBetType bt  WITH(NOLOCK)
	ON td.BetType = bt.BetType
GROUP BY 
	td.custid,
	td.matchid,
	--td.EventDate,
	td.SportType,		
	bt.MapBetType,
	td.LeagueId,
	td.TeamId,
	td.Grade

DELETE [SummaryByBetType_Monthly]
WHERE [EventDate] BETWEEN @fromdate AND @todate

INSERT INTO [dbo].[SummaryByBetType_Monthly]
	([EventDate]
	,[LeagueId]
	,[BetType]
	,[Stake]
	,[WinLost]
	,[Comm]
	,[BetCount]
	,[MatchCount]
	)

SELECT @fromdate [EventDate]
	,[LeagueId]
	,[BetType]
	,SUM([Stake]) [Stake]
	,SUM([WinLost]) [WinLost]
	,SUM([Comm]) [Comm]
	,SUM([BetCount]) BetCount
	,COUNT(DISTINCT [MatchId])[MatchCount]
FROM #SUMTraderPerformance
GROUP BY [LeagueId],[BetType]

DELETE SummaryByLeague_Monthly
WHERE [EventDate] BETWEEN @fromdate AND @todate

INSERT INTO [dbo].SummaryByLeague_Monthly
	([EventDate]
		,[LeagueId]
		,[Stake]
		,[WinLost]
		,[Comm]
		,[BetCount]
		,[MatchCount]
	)
SELECT @fromdate [EventDate]
		,[LeagueId]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) BetCount
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM #SUMTraderPerformance
	GROUP BY [LeagueId]

DELETE SummaryByTeam_Monthly
WHERE [EventDate] BETWEEN @fromdate AND @todate

INSERT INTO [dbo].SummaryByTeam_Monthly
	([EventDate]
		,[TeamId]
		,[Stake]
		,[WinLost]
		,[Comm]
		,[BetCount]
		,[MatchCount]
	)
SELECT @fromdate   [EventDate]
		,[TeamId]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) BetCount
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM #SUMTraderPerformance
	GROUP BY [TeamId]

DELETE [SummaryByTrader_Monthly]
WHERE [EventDate] BETWEEN @fromdate AND @todate

INSERT INTO [dbo].[SummaryByTrader_Monthly](
	 [Eventdate]
      ,[CustId]
      ,[Stake]
      ,[WinLost]
      ,[Comm]
      ,[BetCount]
      ,[MatchCount]
)

SELECT @fromdate   [EventDate]
		,[CustId]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) BetCount
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM #SUMTraderPerformance
	GROUP BY [CustId]

