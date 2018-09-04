USE [Affiliate_12BET]
GO

/*
	Created: 20180904@Percy
	DB: DBAFF12BET.Affiliate_12BET
	Task: Step 1: Create temp table
*/

CREATE TABLE [dbo].[ClickStatisticsSum_tmp]
(
	[AffID] [int] NOT NULL,
	[TrackingID] [int] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[IsForMonth] [bit] NOT NULL,
	[TotalClick] [int] NULL,
	[UniqueClick] [int] NULL,
 CONSTRAINT [PK_Affiliate_ClickStatisticsSum_tmp] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[AffID] ASC,
	[TrackingID] ASC,
	[IsForMonth] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [StatData]
) ON [StatData]

GO