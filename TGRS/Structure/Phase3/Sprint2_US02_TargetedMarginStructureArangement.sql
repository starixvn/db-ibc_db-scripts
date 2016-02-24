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
	TargetedMarginID		INT			NOT NULL
										IDENTITY (1, 1)
,	BetType					SMALLINT	NULL
,	Rate					MONEY		NULL
,	CONSTRAINT PK_TargetedMargin PRIMARY KEY CLUSTERED (TargetedMarginID ASC) ON [DATA]
) ON DATA;
GO

CREATE TABLE dbo.TargetedMargin_History (
	TargetedMarginHistoryID	INT			NOT NULL 
										IDENTITY (1, 1)
,	TargetedMarginID		INT			NOT NULL
,	BetType					SMALLINT	NULL
,	OldRate					MONEY		NULL
,	ModifiedDate			DATETIME	NOT NULL 
										CONSTRAINT DF_TargetedMargin_ModifiedDate DEFAULT GETDATE()
,	ModifiedBy				INT			NULL
,	CONSTRAINT PK_TargetedMargin_History PRIMARY KEY NONCLUSTERED (TargetedMarginHistoryID ASC) ON DATA
) ON DATA;
GO


-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBTGRS\bodb_TGRS	--
----------------------------------------------------------
INSERT INTO	TargetedMargin 
	(	Bettype, Rate)
SELECT	Bettype, NULL 
FROM	dbo.BetType AS bt WITH (NOLOCK)


-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBTGRS\bodb_TGRS --
----------------------------------------------------------
INSERT INTO	dbo.LogAction (
				ActionId
			,	ActionTypeId
			,	SPName
			,	ActionName
			,	Items
			,	SubItems
			,	IsInternal
			)
VALUES		(
				700
			,	7
			,	'TGRS_TargetMargin_Update'
			,	'Update Target Margin'
			,	'<root><xml path="r/z" /><row item="TargetedMarginId" alias="l" /><row item="BetType" alias="b" /><row item="OldRate" alias="v" /></root>'
			,	''
			,	0
			)