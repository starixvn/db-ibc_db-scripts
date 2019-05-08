/*
	Created: 20190506@Kathy
	Task : Write User Action Logs to Prepare Keyscore Performance Report [Redmine:#104631]
	DB: DBTXN.bodb02

*/
USE bodb02
GO

CREATE TABLE dbo.SettlementPerformanceLog (
	LeagueId INT
	,MatchId INT
	,HomeId INT
	,AwayId INT
	,Kickofftime DATETIME
	,GlobalShowtime DATETIME
	,Action VARCHAR(20)
	,IsAuto BIT
	,AdminId INT
	,HomeScore INT
	,AwayScore INT
	,ConfirmScoreDate DATETIME
	,Starttime DATETIME
	,Exectime DATETIME
	,Duration INT
	,CreatedDate DATETIME
) ON DATA

