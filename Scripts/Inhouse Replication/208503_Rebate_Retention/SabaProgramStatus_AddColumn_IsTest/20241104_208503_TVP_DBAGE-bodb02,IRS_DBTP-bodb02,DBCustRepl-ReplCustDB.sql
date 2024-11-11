/*<info serverAlias="DBAGE-bodb02,IRS_DBTP-bodb02,DBRepl-ReplDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241104@Lewis	
	Task: In-House
	DB: DBAGE-bodb02,IRS_DBTP-bodb02,DBRepl-ReplDB
	
	Revisions:
		- 20241104@Lewis: Created [RedmineID: #208503]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplSabaProgramStatus] AS TABLE (
	[SId] [INT] NOT NULL
	,[ProgramId] [SMALLINT] NOT NULL
	,[SiteDBGroupId] [SMALLINT] NOT NULL
	,[StatusId] [TINYINT] NULL
	,[IsNotified] [BIT] NULL
	,[CreatedDate] [DATETIME] NULL
	,[IsTest] [BIT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplSabaProgramStatus] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/




