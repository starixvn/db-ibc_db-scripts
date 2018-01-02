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
	[ID]  [BIGINT] IDENTITY(1,1) NOT NULL,
	[ProductID] [INT] NOT NULL,
	[CreatedDate] [SMALLDATETIME] NOT NULL,	
	[WinlostDate] [DATE] NOT NULL,
	[SumToThirdPartyDate] [SMALLDATETIME] NULL,
	[SumToBettingProductDate] [SMALLDATETIME] NULL,
 CONSTRAINT [PK_Product3rd_SummarizedDateHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)) ON [3rdProduct_Data]

GO

CREATE NONCLUSTERED INDEX [CIX_WinlostDate] ON [dbo].[Product3rd_SummarizedDateHistory]
(
	[WinlostDate] ASC	
) ON [3rdProduct_Data]
GO


