/*<info serverAlias="DBACC-bodb02,DBRepl-ReplDB,DBBOF-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241223@Lewis	
	Task: In-House
	DB: DBACC-bodb02,DBRepl-ReplDB,DBBOF-bodb02
	
	Revisions:
		- 20241223@Lewis: Created [RedmineID: #215667]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplLeagueSetting] AS TABLE (
	[Leagueid] [INT] NOT NULL
	,[Series] [TINYINT] NULL
	,[LeagueType] [TINYINT] NULL
	,[ParentLeagueID] [INT] NULL
	,[ChildLeagueType] [INT] NULL
	,[stamp] [DATETIME] NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplLeagueSetting] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/




