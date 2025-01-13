/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: DBCUST-CustDB
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplAcc_FinancePermission] AS TABLE (
	[GroupId] [SMALLINT] NOT NULL
	,[FinanceCode] [VARCHAR](50) NOT NULL
	,[RoleId] [TINYINT] NULL
	,[IsView] [BIT] NOT NULL
	,[ID] [INT] NOT NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplAcc_FinancePermission] TO [repl_ap] AS [dbo]
GO

--Grant permission to set IDENTITY_INSERT on/off
GRANT ALTER ON dbo.Acc_FinancePermission TO [repl_ap];
GO

/***************************************************************************/
CREATE TYPE [dbo].[TVP_ReplAcc_GroupExtraPT_Product] AS TABLE (
	[GroupId] [INT] NOT NULL
	,[GroupName] [VARCHAR](50) NOT NULL
	,[ProductID] [TINYINT] NOT NULL
	,[Sporttype] [SMALLINT] NOT NULL
	,[SubProduct] [VARCHAR](500) NOT NULL
	,[FromDate] [DATETIME] NOT NULL
	,[ToDate] [DATETIME] NOT NULL
	,[ExtraPT] [DECIMAL](9,8) NOT NULL
	,[ID] [INT] NOT NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplAcc_GroupExtraPT_Product] TO [repl_ap] AS [dbo]
GO

--Grant permission to set IDENTITY_INSERT on/off
GRANT ALTER ON dbo.Acc_GroupExtraPT_Product TO [repl_ap];
GO

/***************************************************************************/
CREATE TYPE [dbo].[TVP_ReplAcc_GroupExtraPT2_Product] AS TABLE (
	[GroupId] [INT] NOT NULL
	,[GroupName] [VARCHAR](50) NOT NULL
	,[ProductID] [TINYINT] NOT NULL
	,[Sporttype] [SMALLINT] NOT NULL
	,[SubProduct] [VARCHAR](500) NOT NULL
	,[FromDate] [DATETIME] NOT NULL
	,[ToDate] [DATETIME] NOT NULL
	,[ExtraPT] [DECIMAL](9,8) NOT NULL
	,[ID] [INT] NOT NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplAcc_GroupExtraPT2_Product] TO [repl_ap] AS [dbo]
GO

--Grant permission to set IDENTITY_INSERT on/off
GRANT ALTER ON dbo.Acc_GroupExtraPT2_Product TO [repl_ap];
GO

/***************************************************************************/




