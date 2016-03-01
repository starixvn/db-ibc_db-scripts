/*
	Created: 20160229@Billy
	Task: Arrange DB Structure for Targeted Margin Management [Redmine: #53086]
	DB: DBTGRS\bodb_TGRS
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBTGRS\bodb_TGRS	--
----------------------------------------------------------

TRUNCATE TABLE dbo.TargetedMargin_History

TRUNCATE TABLE dbo.Spread_History

DELETE	dbo.Spread
WHERE	LeagueId NOT IN (
			3			-- *ENGLISH PREMIER LEAGUE
		,	4			-- *ITALY SERIE A
		,	5			-- *GERMANY-BUNDESLIGA I
		,	8			-- FRANCE LIGUE 1
		,	43			-- *SPAIN PRIMERA LALIGA
		)