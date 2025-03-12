/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House 
	DB: 
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_FinancePermission_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[Acc_FinancePermission_Del_InHouse]
	(
		[ID] [INT] NOT NULL
		) ON [DATA]

	ALTER TABLE [dbo].[Acc_FinancePermission_Del_InHouse] ADD [RepUpdateTime] DATETIME2(7) CONSTRAINT [DF_Acc_FinancePermission_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME())

	CREATE CLUSTERED INDEX [CIX_Acc_FinancePermission_Del_InHouse_RepUpdateTime] ON [dbo].[Acc_FinancePermission_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_FinancePermission_Del_InHouse exists!!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_GroupExtraPT_Product_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[Acc_GroupExtraPT_Product_Del_InHouse]
	(
		[ID] [INT] NOT NULL
		) ON [DATA]

	ALTER TABLE [dbo].[Acc_GroupExtraPT_Product_Del_InHouse] ADD [RepUpdateTime] DATETIME2(7) CONSTRAINT [DF_Acc_GroupExtraPT_Product_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME())

	CREATE CLUSTERED INDEX [CIX_Acc_GroupExtraPT_Product_Del_InHouse_RepUpdateTime] ON [dbo].[Acc_GroupExtraPT_Product_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_GroupExtraPT_Product_Del_InHouse exists!!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_GroupExtraPT2_Product_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[Acc_GroupExtraPT2_Product_Del_InHouse]
	(
		[ID] [INT] NOT NULL
		) ON [DATA]

	ALTER TABLE [dbo].[Acc_GroupExtraPT2_Product_Del_InHouse] ADD [RepUpdateTime] DATETIME2(7) CONSTRAINT [DF_Acc_GroupExtraPT2_Product_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME())

	CREATE CLUSTERED INDEX [CIX_Acc_GroupExtraPT2_Product_Del_InHouse_RepUpdateTime] ON [dbo].[Acc_GroupExtraPT2_Product_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_GroupExtraPT2_Product_Del_InHouse exists!!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_GroupExtraPT2Setting_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[Acc_GroupExtraPT2Setting_Del_InHouse]
	(
		ID [INT] NOT NULL
		) ON [DATA]

	ALTER TABLE [dbo].[Acc_GroupExtraPT2Setting_Del_InHouse] ADD [RepUpdateTime] DATETIME2(7) CONSTRAINT [DF_Acc_GroupExtraPT2Setting_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME())

	CREATE CLUSTERED INDEX [CIX_Acc_GroupExtraPT2Setting_Del_InHouse_RepUpdateTime] ON [dbo].[Acc_GroupExtraPT2Setting_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_GroupExtraPT2Setting_Del_InHouse exists!!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_GroupExtraPTSetting_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[Acc_GroupExtraPTSetting_Del_InHouse]
	(
		ID [INT] NOT NULL
		) ON [DATA]

	ALTER TABLE [dbo].[Acc_GroupExtraPTSetting_Del_InHouse] ADD [RepUpdateTime] DATETIME2(7) CONSTRAINT [DF_Acc_GroupExtraPTSetting_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME())

	CREATE CLUSTERED INDEX [CIX_Acc_GroupExtraPTSetting_Del_InHouse_RepUpdateTime] ON [dbo].[Acc_GroupExtraPTSetting_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_GroupExtraPTSetting_Del_InHouse exists!!!'
END
GO
/***************************************************************************/


IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'EaGroupHeadline_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[EaGroupHeadline_Del_InHouse]
	(
		[GroupHeadlineId] [INT] NOT NULL
		,[GroupId] [INT] NOT NULL
		,[GroupName] [VARCHAR](100) NOT NULL
		,[SiteId] [INT] NOT NULL
		,[ExchangeId] [INT] NOT NULL
		) ON [DATA]

	ALTER TABLE [dbo].[EaGroupHeadline_Del_InHouse] ADD [RepUpdateTime] DATETIME2(7) CONSTRAINT [DF_EaGroupHeadline_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME())

	CREATE CLUSTERED INDEX [CIX_EaGroupHeadline_Del_InHouse_RepUpdateTime] ON [dbo].[EaGroupHeadline_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table EaGroupHeadline_Del_InHouse exists!!!'
END
GO
/***************************************************************************/

--index repupdatetime for dbcust.custdb

alter table EaGroupHeadline add [RepUpdateTime] [DATETIME2]
create nonclustered index IX_EaGroupHeadline_RepUpdateTime on EaGroupHeadline([RepUpdateTime]) on [DATA]
