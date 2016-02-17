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

CREATE TABLE dbo.TargetedMargin (
	TargetedMarginID		INT			NOT NULL IDENTITY (1, 1)
,	BetType					SMALLINT	NULL
,	Rate					MONEY		NULL
,	CONSTRAINT PK_TargetedMargin PRIMARY KEY CLUSTERED (TargetedMarginID) ON DATA
) ON DATA;
GO

CREATE TABLE dbo.TargetedMargin_History (
	TargetedMarginHistoryID	INT			NOT NULL IDENTITY (1, 1)
,	TargetedMarginID		INT			NOT NULL
,	BetType					SMALLINT	NULL
,	OldRate					MONEY		NULL
,	ModifiedDate			DATETIME	NOT NULL	CONSTRAINT DF_TargetedMargin_ModifiedDate DEFAULT GETDATE()
,	ModifiedBy				INT			NULL
,	CONSTRAINT PK_TargetedMargin_History PRIMARY KEY NONCLUSTERED (TargetedMarginHistoryID) ON DATA
) ON DATA;
GO
