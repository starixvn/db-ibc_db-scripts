/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250115@Lewis	
	Task: In-House
	DB: DBCUST-CustDB
	
	Revisions:
		- 20250115@Lewis: Created [RedmineID: #215883]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplEaGroupHeadline] AS TABLE (
	[GroupHeadlineId] [INT] NOT NULL
	,[GroupId] [INT] NOT NULL
	,[GroupName] [VARCHAR](100) NOT NULL
	,[SiteId] [INT] NOT NULL
	,[ExchangeId] [INT] NOT NULL
	,[GroupTypeId] [TINYINT] NULL
	,[EffectiveDate] [DATETIME] NULL
	,[EndDate] [DATETIME] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplEaGroupHeadline] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/




