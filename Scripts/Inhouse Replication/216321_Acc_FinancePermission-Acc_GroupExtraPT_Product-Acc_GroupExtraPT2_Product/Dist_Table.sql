/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: 
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_FinancePermission')
BEGIN
	CREATE TABLE [dbo].[Acc_FinancePermission]
	(
		[GroupId] [SMALLINT] NOT NULL
		,[FinanceCode] [VARCHAR](50) NOT NULL
		,[RoleId] [TINYINT] NULL
		,[IsView] [BIT] NOT NULL
		,[ID] [INT] IDENTITY(1,1) NOT NULL
		,[RepUpdateTime] [DATETIME2](7) NULL
		,[isDeleted] [BIT] NULL
		,CONSTRAINT [PK_Acc_FinancePermission] PRIMARY KEY NONCLUSTERED (ID) ON [DATA]
	) ON [DATA]

	ALTER TABLE [dbo].[Acc_FinancePermission] ADD CONSTRAINT [DF_Acc_FinancePermission_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
	
	ALTER TABLE [dbo].[Acc_FinancePermission] ADD CONSTRAINT [DF_Acc_FinancePermission_RepUpdateTime]  DEFAULT (SYSDATETIME()) FOR [RepUpdateTime]
	
	CREATE NONCLUSTERED INDEX [IX_Acc_FinancePermission_RepUpdateTime] ON [dbo].[Acc_FinancePermission] 
	(
	  [RepUpdateTime] ASC
	)ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_FinancePermission exists!!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_GroupExtraPT_Product')
BEGIN
	CREATE TABLE [dbo].[Acc_GroupExtraPT_Product]
	(
		[GroupId] [INT] NOT NULL
		,[GroupName] [VARCHAR](50) NOT NULL
		,[ProductID] [TINYINT] NOT NULL
		,[Sporttype] [SMALLINT] NOT NULL
		,[SubProduct] [VARCHAR](500) NOT NULL
		,[FromDate] [DATETIME] NOT NULL
		,[ToDate] [DATETIME] NOT NULL
		,[ExtraPT] [DECIMAL](9,8) NOT NULL
		,[ID] [INT] IDENTITY(1,1) NOT NULL
		,[RepUpdateTime] [DATETIME2](7) NULL
		,[isDeleted] [BIT] NULL
		,CONSTRAINT [PK_Acc_GroupExtraPT_Product] PRIMARY KEY NONCLUSTERED (ID) ON [DATA]
	) ON [DATA]

	ALTER TABLE [dbo].[Acc_GroupExtraPT_Product] ADD CONSTRAINT [DF_Acc_GroupExtraPT_Product_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
	
	ALTER TABLE [dbo].[Acc_GroupExtraPT_Product] ADD CONSTRAINT [DF_Acc_GroupExtraPT_Product_RepUpdateTime]  DEFAULT (SYSDATETIME()) FOR [RepUpdateTime]
	
	CREATE NONCLUSTERED INDEX [IX_Acc_GroupExtraPT_Product_RepUpdateTime] ON [dbo].[Acc_GroupExtraPT_Product] 
	(
	  [RepUpdateTime] ASC
	)ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_GroupExtraPT_Product exists!!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'Acc_GroupExtraPT2_Product')
BEGIN
	CREATE TABLE [dbo].[Acc_GroupExtraPT2_Product]
	(
		[GroupId] [INT] NOT NULL
		,[GroupName] [VARCHAR](50) NOT NULL
		,[ProductID] [TINYINT] NOT NULL
		,[Sporttype] [SMALLINT] NOT NULL
		,[SubProduct] [VARCHAR](500) NOT NULL
		,[FromDate] [DATETIME] NOT NULL
		,[ToDate] [DATETIME] NOT NULL
		,[ExtraPT] [DECIMAL](9,8) NOT NULL
		,[ID] [INT] IDENTITY(1,1) NOT NULL
		,[RepUpdateTime] [DATETIME2](7) NULL
		,[isDeleted] [BIT] NULL
		,CONSTRAINT [PK_Acc_GroupExtraPT2_Product] PRIMARY KEY NONCLUSTERED (ID) ON [DATA]
	) ON [DATA]

	ALTER TABLE [dbo].[Acc_GroupExtraPT2_Product] ADD CONSTRAINT [DF_Acc_GroupExtraPT2_Product_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
	
	ALTER TABLE [dbo].[Acc_GroupExtraPT2_Product] ADD CONSTRAINT [DF_Acc_GroupExtraPT2_Product_RepUpdateTime]  DEFAULT (SYSDATETIME()) FOR [RepUpdateTime]
	
	CREATE NONCLUSTERED INDEX [IX_Acc_GroupExtraPT2_Product_RepUpdateTime] ON [dbo].[Acc_GroupExtraPT2_Product] 
	(
	  [RepUpdateTime] ASC
	)ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table Acc_GroupExtraPT2_Product exists!!!'
END
GO
/***************************************************************************/




