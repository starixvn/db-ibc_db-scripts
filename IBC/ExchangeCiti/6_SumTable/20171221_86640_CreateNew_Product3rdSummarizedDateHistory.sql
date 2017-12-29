USE [bodb_3rdProduct]
GO

/*
	Created: 20171220@Harper
	Description: Create new table to support save affected date when sum data from API to Raw table 
					and the date that data had been sum to sum report table [RedmineID: #86640]
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Product3rd_SummarizedDateHistory](
	[ID] [BIGINT] NOT NULL,
	[ProductID] [INT] NULL,
	[CreatedDate] [SMALLDATETIME] NULL,
	[SummarizedDate] [SMALLDATETIME] NULL,
	[SettledDate] [DATETIME] NULL,
	[SummarizedBy] [TINYINT] NULL,
	[SummarizedFor] [VARCHAR](200) NULL,
 CONSTRAINT [PK_Product3rd_SummarizedDateHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [3rdProduct_Data]

GO

CREATE NONCLUSTERED INDEX [CIX_SettledDate] ON [dbo].[Product3rd_SummarizedDateHistory]
(
	[SettledDate] ASC	
) ON [3rdProduct_Data]
GO


