/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	Database: DBCUST/CustDB
	
	Local Test: D:\DB233\IBC_DB\CustDB
	Local Dev: D:\SQLSERVER2008R2\IBC_DB\CustDB
	Production: H:\USER_DB\CustDB
		
*/
USE CustDB
GO
sp_RENAME 'WinLimit_ProductSettingDetail.BetTypeID' , 'GroupID', 'COLUMN'
GO
sp_RENAME 'WinLimit_CustGameSetting.BetTypeID' , 'GroupID', 'COLUMN'

GO
ALTER TABLE WinLimit_ProductSettingDetail ADD MaxWinLimit_RM MONEY 
GO
ALTER TABLE WinLimit_CustGameSetting ADD MaxWinLimit_RM MONEY 
GO
ALTER TABLE [dbo].[WinLimit_ProductSettingDetail] ADD CONSTRAINT [DF_WinLimit_ProductSettingDetail_MaxWinLimit_RM] DEFAULT ((0)) FOR [MaxWinLimit_RM]
go
ALTER TABLE [dbo].[WinLimit_CustGameSetting] ADD CONSTRAINT [DF_WinLimit_CustGameSetting_MaxWinLimit_RM] DEFAULT ((0)) FOR [MaxWinLimit_RM]
go
ALTER TABLE [dbo].WinLimit_CustGameMonitoring ADD MaxWinLimitSetting XML

go
ALTER TABLE [dbo].WinLimit_CustGameMonitoring ADD MaxWinLimitSetting XML
GO
ALTER TABLE [dbo].WinLimit_CustGameMonitoring ADD TotalWinAmt_RM MONEY
GO

ALTER TABLE [dbo].WinLimit_CustGameMonitoring_History ADD MaxWinLimitSetting XML
go
ALTER TABLE [dbo].WinLimit_CustGameMonitoring_History ADD TotalWinAmt_RM MONEY
GO


CREATE TABLE [dbo].[Winlimit_Group](
	[GroupID] [int] NOT NULL,
	[GroupName] [varchar](200) NOT NULL
	
 CONSTRAINT [PK_Winlimit_Group] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
CREATE TABLE [dbo].[Winlimit_GameGroupSetting](
	[ProductID] [tinyint] NOT NULL,
	[BetTypeID] [smallint] NOT NULL,
	[GroupID] [int] NOT NULL,
	[BetTypeRefID] [smallint] NOT NULL
	
 CONSTRAINT [PK_Winlimit_GroupSetting] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[BetTypeID]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
/* DBTXN/bodb02
ALTER TABLE dbo.BalancePendingDebitGame ADD GameTypeID smallint
ALTER TABLE dbo.BalancePendingCreditGame ADD GameTypeID smallint
*/