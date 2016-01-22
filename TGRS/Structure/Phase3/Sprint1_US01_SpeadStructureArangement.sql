/*
	Created: 20160122@Billy
	Task: Arrange DB Structure for Spead Management [Redmine: #51281]
	DB: DBTGRS\bodb_TGRS
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBTGRS\bodb_TGRS	--
----------------------------------------------------------
USE bodb_TGRS;
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE dbo.Spread (
	LeagueId		INT			NOT NULL
,	BetType			SMALLINT	NOT NULL
,	Spread			SMALLINT	NULL
,	CONSTRAINT PK_Spread PRIMARY KEY CLUSTERED (LeagueID, BetType) ON DATA
) ON DATA;
GO

CREATE TABLE dbo.Spread_History (
	LeagueId		INT			NOT NULL
,	BetType			SMALLINT	NOT NULL
,	OldSpread		SMALLINT	NULL
,	ModifiedDate	DATE		NULL		CONSTRAINT DF_Spread_ModifiedDate DEFAULT GETDATE()
,	ModifiedBy		INT			NULL
,	CONSTRAINT PK_Spread_History PRIMARY KEY CLUSTERED (LeagueID, BetType) ON DATA
) ON DATA;
GO