/*
	Created: 201603@Billy
	Task: Arrange DB Structure for Targeted Margin Management [Redmine: #53086]
	DB: DBTGRS\bodb_TGRS
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBTGRS\bodb_TGRS	--
----------------------------------------------------------

ALTER TABLE dbo.Staging_TraderPerformance
ADD Spread SMALLINT

ALTER TABLE dbo.TraderPerformance
ADD Spread SMALLINT

ALTER TABLE dbo.TraderPerformance_BK
ADD Spread SMALLINT