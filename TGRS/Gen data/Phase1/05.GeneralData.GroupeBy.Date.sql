USE [bodb_TGRS]
GO

SET NOCOUNT ON

DECLARE @fromdate datetime,@todate datetime

SELECT @fromdate ='2014-01-01 00:00:00'
	,@todate =CONVERT(NVARCHAR(20),GETDATE(),101)
 
DELETE [dbo].[SummaryByBetType_Daily]	WHERE EventDate BETWEEN @fromdate AND @todate 

INSERT INTO [dbo].[SummaryByBetType_Daily]
	([EventDate]
		,[LeagueId]
		,[BetType]
		,[Stake]
		,[WinLost]
		,[Comm]
		,[BetCount]
		,[MatchCount]
	)
SELECT [EventDate]
		,[LeagueId]
		,[BetType]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) BetCount
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM [dbo].[TraderPerformance] WITH(NOLOCK)
	WHERE EventDate BETWEEN @fromdate AND @todate 
	GROUP BY [EventDate],
		[LeagueId],
		[BetType]

DELETE [dbo].[SummaryByLeague_Daily]	WHERE EventDate BETWEEN @fromdate AND @todate 

INSERT INTO [dbo].[SummaryByLeague_Daily]
	([EventDate]
		,[LeagueId]
		,[Stake]
		,[WinLost]
		,[Comm]
		,[BetCount]
		,[MatchCount]
	)
SELECT [EventDate]
		,[LeagueId]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) BetCount
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM [dbo].[TraderPerformance] WITH(NOLOCK)
	WHERE EventDate BETWEEN @fromdate AND @todate 
	GROUP BY [EventDate],[LeagueId]

DELETE [dbo].[SummaryByTeam_Daily]	WHERE EventDate BETWEEN @fromdate AND @todate 

INSERT INTO [dbo].[SummaryByTeam_Daily]
	([EventDate]
		,[TeamId]
		,[Stake]
		,[WinLost]
		,[Comm]
		,[BetCount]
		,[MatchCount]
	)
SELECT [EventDate]
		,[TeamId]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) BetCount
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM [dbo].[TraderPerformance] WITH(NOLOCK)
	WHERE EventDate BETWEEN @fromdate AND @todate 
	GROUP BY [EventDate],[TeamId]
