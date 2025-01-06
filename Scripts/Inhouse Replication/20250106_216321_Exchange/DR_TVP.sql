/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250106@Lewis	
	Task: In-House
	DB: DBCUST-CustDB
	
	Revisions:
		- 20250106@Lewis: Created [RedmineID: #215883]

	Example:			
*/
CREATE TYPE [dbo].[TVP_Repltblexchange] AS TABLE (
	[currency] [NVARCHAR](50) NOT NULL
	,[stakerate] [FLOAT] NULL
	,[actualrate] [FLOAT] NOT NULL
	,[commaxpayout] [FLOAT] NULL
	,[creator] [NVARCHAR](50) NOT NULL
	,[minbet] [FLOAT] NULL
	,[minbetlive] [FLOAT] NULL
	,[AUDRate] [FLOAT] NULL
	,[ZARRate] [FLOAT] NULL
	,[GBPRate] [FLOAT] NULL
	,[EURORate] [FLOAT] NULL
	,[US$Rate] [FLOAT] NULL
	,[Code] [VARCHAR](12) NULL
	,[Description] [VARCHAR](100) NULL
	,[MultipliedBy] [DECIMAL](19,8) NULL
	,[ExVirtualRate] [FLOAT] NULL
	,[IsActive] [BIT] NOT NULL
	,[OfferSite] [TINYINT] NOT NULL
	,[ExchangeId] [INT] NOT NULL
	,[CurrencyType] [TINYINT] NOT NULL
	,[CreditGroupID] [TINYINT] NULL
	,[LicenseeGroupID] [TINYINT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_Repltblexchange] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/




