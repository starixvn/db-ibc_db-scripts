/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250107@Lewis	
	Task: In-House
	DB: DBCUST-CustDB
	
	Revisions:
		- 20250107@Lewis: Created [RedmineID: #215883]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplExchangeDailyOanda] AS TABLE (
	[ExchangeDate] [SMALLDATETIME] NOT NULL
	,[ExchangeId] [INT] NOT NULL
	,[Code] [VARCHAR](12) NULL
	,[MYR] [FLOAT] NULL
	,[USD] [FLOAT] NULL
	,[EUR] [FLOAT] NULL
	,[CNY] [FLOAT] NULL
	,[IDR] [FLOAT] NULL
	,[AUD] [FLOAT] NULL
	,[CHF] [FLOAT] NULL
	,[GBP] [FLOAT] NULL
	,[SGD] [FLOAT] NULL
	,[THB] [FLOAT] NULL
	,[VND] [FLOAT] NULL
	,[ActualRate] [FLOAT] NULL
	,[KRW] [FLOAT] NULL
	,[JPY] [FLOAT] NULL
	,[HKD] [FLOAT] NULL
	,[TWD] [FLOAT] NULL
	,[PHP] [FLOAT] NULL
	,[BDT] [FLOAT] NULL
	,[INR] [FLOAT] NULL
	,[TRY] [FLOAT] NULL
	,[NPR] [FLOAT] NULL
	,[MXN] [FLOAT] NULL
	,[NGN] [FLOAT] NULL
	,[BRL] [FLOAT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplExchangeDailyOanda] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/
CREATE TYPE [dbo].[TVP_ReplExchangeDaily_Crypto] AS TABLE (
	[ExchangeDate] [SMALLDATETIME] NOT NULL
	,[ExchangeId] [INT] NOT NULL
	,[USDT] [FLOAT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplExchangeDaily_Crypto] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/





