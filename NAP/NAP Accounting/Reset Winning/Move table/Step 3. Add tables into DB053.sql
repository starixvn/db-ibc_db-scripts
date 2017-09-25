USE [bodb02]
GO

/*
	Created by Percy
	Date: 2017-09-25
	DB: DBAGE.bodb02
	Task: Extra PT Setting - Add new tables
*/

--- Acc_GroupExtraPTSetting ---
CREATE TABLE [dbo].[Acc_GroupExtraPTSetting]
(
	[SuperId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[ProductId] [tinyint] NOT NULL,
	[Sporttype] [smallint] NOT NULL CONSTRAINT [DF_Acc_GroupExtraPTSetting_Sporttype]  DEFAULT ((0)),
	[SubProduct] [varchar](500) NOT NULL CONSTRAINT [DF_Acc_GroupExtraPTSetting_SubProduct]  DEFAULT (''),
	[ExtraPT] [decimal](9, 8) NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL CONSTRAINT [DF_Acc_GroupExtraPTSetting_ToDate] DEFAULT ('9999-12-31'),
 CONSTRAINT [PK_Acc_GroupExtraPTSetting] PRIMARY KEY NONCLUSTERED 
(
	[SuperId] ASC,
	[GroupId] ASC,
	[ProductId] ASC,
	[Sporttype] ASC,
	[SubProduct] ASC,
	[FromDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Data]
) ON [Data]