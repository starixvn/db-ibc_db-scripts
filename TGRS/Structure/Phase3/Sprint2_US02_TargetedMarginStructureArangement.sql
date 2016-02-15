/*
	Created: 20160122@Billy
	Task: Arrange DB Structure for Targeted Margin Management [Redmine: #52167]
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

CREATE TABLE dbo.TargetMargin (
	TargetMarginID	INT			NOT NULL
,	BetType				SMALLINT	NULL
,	Rate				MONEY		NULL
,	CONSTRAINT PK_TargetMargin PRIMARY KEY CLUSTERED (TargetMarginID) ON DATA
) ON DATA;
GO

CREATE TABLE dbo.TargetMargin_History (
	TargetMarginID	INT			NOT NULL
,	BetType				SMALLINT	NULL
,	OldRate				MONEY		NULL
,	ModifiedDate		DATETIME	NOT NULL	CONSTRAINT DF_TargetMargin_ModifiedDate DEFAULT GETDATE()
,	ModifiedBy			INT			NULL
,	CONSTRAINT PK_TargetMargin_History PRIMARY KEY CLUSTERED (TargetMarginID, ModifiedDate) ON DATA
) ON DATA;
GO
