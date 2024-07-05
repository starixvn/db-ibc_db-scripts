/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240704@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange - Archive data before 2022 [RedmineID: #207427]		
*/


USE [bodb_3rdProduct]
GO

/****** Object:  Table [dbo].[LOG_Archive_BettransExchange]    Script Date: 7/4/2024 11:23:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--DROP TABLE [LOG_Archive_BettransExchange]
CREATE TABLE [dbo].[LOG_Archive_BettransExchange]
(
	[settledDate] [date] NULL,
	[cnt_Sum_winloss] [int] NULL,
	[cnt_Sum_winloss_bk] [int] NULL,
	[cnt_Bettrans] [int] NULL,
	[cnt_Bettrans_bk] [int] NULL,
	[cnt_BettransM] [int] NULL,
	[cnt_BettransM_bk] [int] NULL,
	[CreatedDTS] [datetime] default getdate()
)


