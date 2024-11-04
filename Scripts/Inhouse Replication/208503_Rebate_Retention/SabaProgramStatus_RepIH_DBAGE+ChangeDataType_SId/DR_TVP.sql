/*<info serverAlias="DBSIC-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241021@Lewis	
	Task: In-House
	DB: DBSIC-bodb02
	
	Revisions:
		- 20241021@Lewis: Created [RedmineID: #208503]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplSabaProgramStatus] AS TABLE (
	[SId] [INT] NOT NULL
	,[ProgramId] [SMALLINT] NOT NULL
	,[SiteDBGroupId] [SMALLINT] NOT NULL
	,[StatusId] [TINYINT] NULL
	,[IsNotified] [BIT] NULL
	,[CreatedDate] [DATETIME] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplSabaProgramStatus] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/




