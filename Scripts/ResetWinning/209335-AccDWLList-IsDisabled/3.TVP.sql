/*<info serverAlias="DBACC-bodb02,IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241106@Lewis	
	Task: In-House
	DB: DBACC-bodb02,IRS_DBTP-bodb02,DBCustRepl-ReplCustDB
	
	Revisions:
		- 20241106@Lewis: Created [RedmineID: #209319]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplAcc_DWLList] AS TABLE (
	[custid] [INT] NOT NULL
	,[product] [VARCHAR](50) NOT NULL
	,[seq] [TINYINT] NOT NULL
	,[ProductId] [TINYINT] NULL
	,[IsDisabled] [BIT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplAcc_DWLList] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/
CREATE TYPE [dbo].[TVP_ReplAcc_DWLList_ExtraPT] AS TABLE (
	[CustId] [INT] NOT NULL
	,[GroupId] [INT] NULL
	,[GroupName] [VARCHAR](50) NULL
	,[IsDisabled] [BIT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplAcc_DWLList_ExtraPT] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/
CREATE TYPE [dbo].[TVP_ReplAcc_DWLList_ExtraPT_xtest] AS TABLE (
	[CustId] [INT] NOT NULL
	,[GroupId] [INT] NULL
	,[GroupName] [VARCHAR](50) NULL
	,[IsDisabled] [BIT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplAcc_DWLList_ExtraPT_xtest] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/
CREATE TYPE [dbo].[TVP_ReplAcc_DWLList_xtest] AS TABLE (
	[custid] [INT] NOT NULL
	,[product] [VARCHAR](50) NOT NULL
	,[seq] [TINYINT] NOT NULL
	,[ProductId] [TINYINT] NULL
	,[IsDisabled] [BIT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplAcc_DWLList_xtest] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/




