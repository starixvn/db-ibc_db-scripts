/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250717@Kelvin
	DB: DBCUST-CustDB
	Task : LAP - Support based ZAR (RedmineID: #232973)

*/

IF @@SERVERNAME NOT IN ('DBCust')
OR DB_NAME() NOT IN ('CustDB')
BEGIN
	PRINT ('ServerName or Database is wrong')
	RETURN
END

/******************************ExchangeDailyOanda*********************************************/
----------------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM RepInfo WITH (NOLOCK)
			WHERE [name]='ExchangeDailyOanda' AND active=0)
BEGIN
	--Drop sp_put
	DROP PROCEDURE IF EXISTS DR_Repl_PutExchangeDailyOanda_Dist;

	--Drop TVP
	DROP TYPE IF EXISTS [dbo].[TVP_ReplExchangeDailyOanda];
END

----------------------------------------------------------------------------------
--Create TVP: include new column
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
	,[PKR] [FLOAT] NULL
	,[ZAR] [FLOAT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplExchangeDailyOanda] TO [repl_ap] AS [dbo]
GO