USE bodb_RMS
GO

/*
	Created: 20200120@Percy
	DB: DBRMS.bodb_RMS
	Task: PRMS - Add new table for League Management
*/

CREATE TABLE dbo.rmLeague
(
	LeagueId	INT NOT NULL
	,GroupId	TINYINT
	,CONSTRAINT [PK_rmLeague] PRIMARY KEY CLUSTERED
	(
		LeagueId ASC
	) ON rmData
) ON rmData
GO

CREATE TABLE dbo.rmLeagueGroup
(
	GroupId		TINYINT NOT NULL
	,GroupName	VARCHAR(30)
	,OrderId	SMALLINT
	,CONSTRAINT [PK_rmLeagueGroup] PRIMARY KEY CLUSTERED
	(
		GroupId ASC
	) ON rmData
) ON rmData
GO