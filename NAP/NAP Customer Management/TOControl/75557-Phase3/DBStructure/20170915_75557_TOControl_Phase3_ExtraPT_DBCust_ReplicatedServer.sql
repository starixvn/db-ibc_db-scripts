/*
	Created: 20170915@Helen
	Task: SMA Turnover Control - Enhancement requests from phase 2 [RedmineID:75557]
	DB: DBCUST& REPLICATED SERVER
*/
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


