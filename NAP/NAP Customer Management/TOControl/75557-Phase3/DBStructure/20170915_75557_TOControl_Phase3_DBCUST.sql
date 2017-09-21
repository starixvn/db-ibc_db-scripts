/*
	Created: 20170915@Helen
	Task: SMA Turnover Control - Enhancement requests from phase 2 [RedmineID:75557]
	DB: DBCUST/CUSTDB
*/
USE CustDB
GO
----------------------- TOControl_GlobalSetting ----------------
ALTER TABLE dbo.TOControl_GlobalSetting
	DROP CONSTRAINT PK_TO_ControlglobalSetting
GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ADD Sporttype SMALLINT

GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ADD IsGroupHeadLine BIT
GO

UPDATE TOControl_GlobalSetting SET Sporttype = 1, IsGroupHeadline = 0

GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ALTER COLUMN Sporttype SMALLINT NOT NULL

GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ALTER COLUMN IsGroupHeadLine BIT NOT NULL

GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ADD CONSTRAINT PK_TO_ControlglobalSetting PRIMARY KEY (CustID,Sporttype,IsGroupHeadLine)


GO
------------------------ TOControl_Setting ------------------------
ALTER TABLE dbo.TOControl_Setting
	DROP CONSTRAINT PK_TOControl_Setting
GO

ALTER TABLE dbo.TOControl_Setting 
ADD IsGroupHeadLine BIT

GO
UPDATE dbo.TOControl_Setting SET IsGroupHeadLine = 0
GO

ALTER TABLE dbo.TOControl_Setting 
ALTER COLUMN IsGroupHeadLine BIT NOT NULL
GO
ALTER TABLE dbo.TOControl_Setting 
ADD CONSTRAINT PK_TOControl_Setting PRIMARY KEY (CustID,matchid,IsGroupHeadLine)
GO
---------------------- TOControl_LevelSetting --------------------
CREATE TABLE dbo.TOControl_LevelSetting
(
	PercentLevel TINYINT
	, PercentValue TINYINT
	, CONSTRAINT [PK_TOControl_LevelSetting] PRIMARY KEY CLUSTERED ([PercentLevel] ASC) ON [DATA]
) ON [DATA]


GO
-------------------- Acc_GroupExtraPTSetting -----------------------
CREATE TABLE [dbo].[Acc_GroupExtraPTSetting](
	[SuperId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[ProductId] [tinyint] NOT NULL,
	[Sporttype] [smallint] NOT NULL,
	[SubProduct] [varchar](500) NOT NULL,
	[ExtraPT] [decimal](9, 8) NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NULL,
	CONSTRAINT [PK_Acc_GroupExtraPTSetting] PRIMARY KEY NONCLUSTERED 
	(
		[SuperId] ASC,
		[GroupId] ASC,
		[ProductId] ASC,
		[Sporttype] ASC,
		[SubProduct] ASC,
		[FromDate] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[Acc_GroupExtraPTSetting] ADD  CONSTRAINT [DF_Acc_GroupExtraPTSetting_Sporttype]  DEFAULT ((0)) FOR [Sporttype]
GO

ALTER TABLE [dbo].[Acc_GroupExtraPTSetting] ADD  CONSTRAINT [DF_Acc_GroupExtraPTSetting_SubProduct]  DEFAULT ('') FOR [SubProduct]
GO


