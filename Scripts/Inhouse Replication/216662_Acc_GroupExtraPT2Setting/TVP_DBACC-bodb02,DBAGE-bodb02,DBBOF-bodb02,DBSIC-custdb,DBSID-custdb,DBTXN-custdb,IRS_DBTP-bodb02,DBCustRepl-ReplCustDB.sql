/*<info serverAlias="DBACC-bodb02,DBAGE-bodb02,DBBOF-bodb02,DBSIC-custdb,DBSID-custdb,DBTXN-custdb,IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: DBACC-bodb02,DBAGE-bodb02,DBBOF-bodb02,DBSIC-custdb,DBSID-custdb,DBTXN-custdb,IRS_DBTP-bodb02,DBCustRepl-ReplCustDB
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplAcc_GroupExtraPT2Setting] AS TABLE (
	[SuperId] [INT] NOT NULL
	,[GroupId] [INT] NOT NULL
	,[GroupName] [VARCHAR](50) NOT NULL
	,[ProductId] [TINYINT] NOT NULL
	,[Sporttype] [SMALLINT] NOT NULL
	,[SubProduct] [VARCHAR](500) NOT NULL
	,[ExtraPT] [DECIMAL](9,8) NOT NULL
	,[FromDate] [DATETIME] NOT NULL
	,[ToDate] [DATETIME] NOT NULL
	,[ID] [INT] NOT NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplAcc_GroupExtraPT2Setting] TO [repl_ap] AS [dbo]
GO


/***************************************************************************/


GRANT ALTER ON [dbo].Acc_GroupExtraPT2Setting TO [repl_ap];
GO

