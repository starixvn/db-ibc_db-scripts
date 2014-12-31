USE [bodb_TGRS]
GO

SET NOCOUNT ON
	
DECLARE @fromdate DATE,@todate Date

SELECT @fromdate ='2014-01-01 00:00:00'
	,@todate =CONVERT(NVARCHAR(20),GETDATE(),101)
 
DELETE [dbo].[SummaryByTrader_Monthly] WHERE EventDate BETWEEN @fromdate AND @todate

INSERT INTO [dbo].[SummaryByTrader_Monthly](
	[Eventdate]
		,[CustId]
		,[Stake]
		,[WinLost]
		,[Comm]
		,[BetCount]
		,[MatchCount]
		)
SELECT CONVERT(NVARCHAR(10),YEAR([Eventdate])) + '/'+CONVERT(NVARCHAR(10),MONTH([Eventdate])) + '/01' [Eventdate]
		,[CustId]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) [BetCount]
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM [dbo].[TraderPerformance] WITH(NOLOCK)
	WHERE EventDate BETWEEN @fromdate AND @todate
	GROUP BY CONVERT(NVARCHAR(10),YEAR([Eventdate])) + '/'+CONVERT(NVARCHAR(10),MONTH([Eventdate])) + '/01' ,[CustId]

DELETE [dbo].[SummaryByBetType_Monthly]	WHERE EventDate BETWEEN @fromdate AND @todate

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
SELECT CONVERT(NVARCHAR(10),YEAR([Eventdate])) + '/'+CONVERT(NVARCHAR(10),MONTH([Eventdate]))+ '/01' [EventDate]
		,[LeagueId]
		,[BetType]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) BetCount
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM [dbo].[TraderPerformance] WITH(NOLOCK)
	WHERE EventDate BETWEEN @fromdate AND @todate
	GROUP BY CONVERT(NVARCHAR(10),YEAR([Eventdate])) + '/'+CONVERT(NVARCHAR(10),MONTH([Eventdate])) + '/01',[LeagueId]
	,[BetType]

DELETE [dbo].SummaryByLeague_Monthly	WHERE EventDate BETWEEN @fromdate AND @todate

INSERT INTO [dbo].SummaryByLeague_Monthly
	([EventDate]
		,[LeagueId]
		,[Stake]
		,[WinLost]
		,[Comm]
		,[BetCount]
		,[MatchCount]
	)
SELECT CONVERT(NVARCHAR(10),YEAR([Eventdate])) + '/'+CONVERT(NVARCHAR(10),MONTH([Eventdate])) + '/01' [EventDate]
		,[LeagueId]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) BetCount
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM [dbo].[TraderPerformance] WITH(NOLOCK)
	WHERE EventDate BETWEEN @fromdate AND @todate
	GROUP BY CONVERT(NVARCHAR(10),YEAR([Eventdate])) + '/'+CONVERT(NVARCHAR(10),MONTH([Eventdate])) + '/01',[LeagueId]

DELETE [dbo].SummaryByTeam_Monthly	WHERE EventDate BETWEEN @fromdate AND @todate

INSERT INTO [dbo].SummaryByTeam_Monthly
	([EventDate]
		,[TeamId]
		,[Stake]
		,[WinLost]
		,[Comm]
		,[BetCount]
		,[MatchCount]
	)
SELECT CONVERT(NVARCHAR(10),YEAR([Eventdate])) + '/'+CONVERT(NVARCHAR(10),MONTH([Eventdate])) + '/01' [EventDate]
		,[TeamId]
		,SUM([Stake]) [Stake]
		,SUM([WinLost]) [WinLost]
		,SUM([Comm]) [Comm]
		,SUM([BetCount]) BetCount
		,COUNT(DISTINCT [MatchId])[MatchCount]
	FROM [dbo].[TraderPerformance] WITH(NOLOCK)
	WHERE EventDate BETWEEN @fromdate AND @todate
	GROUP BY CONVERT(NVARCHAR(10),YEAR([Eventdate])) + '/'+CONVERT(NVARCHAR(10),MONTH([Eventdate])) + '/01',[TeamId]