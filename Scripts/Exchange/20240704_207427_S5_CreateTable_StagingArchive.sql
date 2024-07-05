/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240704@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange - Archive data before 2022 [RedmineID: #207427]		
*/


USE [bodb_3rdProduct]
GO

/****** Object:  Table [dbo].[Sum_winloss_Exchange_Archive_Staging]    Script Date: 7/4/2024 11:23:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sum_winloss_Exchange_Archive_Staging]
(
	settledDate datetime, userId varchar(16), eventID int, marketID varchar(50), isfinished bit default(0)
)

GO

/****** Object:  Table [dbo].[Bettrans_Exchange_Archive_Staging]    Script Date: 7/4/2024 11:23:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bettrans_Exchange_Archive_Staging]
(
	betID bigint, isfinished bit default(0)
)

