/*<info serverAlias="DBCUST-CUSTDB"></info>*/
/*
	Create: 20200701@Sol
	DB : DBCUST.CustDB
	Task: Script to add new table for Extra PT 2 [redmine: #136320]
*/

USE [CustDB]

GO

CREATE TABLE [dbo].Acc_GroupExtraPT2Setting(
	[SuperId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[ProductId] [tinyint] NOT NULL,
	[Sporttype] [smallint] NOT NULL,
	[SubProduct] [varchar](500) NOT NULL,
	[ExtraPT] [decimal](9, 8) NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Acc_GroupExtraPT2Setting] PRIMARY KEY NONCLUSTERED 
(
	[SuperId] ASC,
	[GroupId] ASC,
	[ProductId] ASC,
	[Sporttype] ASC,
	[SubProduct] ASC,
	[FromDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]
GO

ALTER TABLE [dbo].Acc_GroupExtraPT2Setting ADD  CONSTRAINT [DF_Acc_GroupExtraPT2Setting_Sporttype]  DEFAULT ((0)) FOR [Sporttype]
GO

ALTER TABLE [dbo].Acc_GroupExtraPT2Setting ADD  CONSTRAINT [DF_Acc_GroupExtraPT2Setting_SubProduct]  DEFAULT ('') FOR [SubProduct]

GO