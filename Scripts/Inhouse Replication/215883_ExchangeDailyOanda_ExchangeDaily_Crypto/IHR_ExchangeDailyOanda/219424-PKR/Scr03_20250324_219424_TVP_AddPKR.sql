/*<info serverAlias="IRS_DBAGE-bodb02,IRS_DBBOF-bodb02,IRS_DBACC-bodb02,IRS_DBSIC-CustDB,IRS_DBSID-CustDB,IRS_DBCTG-CustDB,IRS_DBTP-bodb02,DBCustRepl-ReplCustDB,IRS_DBWH-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250324@Tacy	
	Task: In-House add column [PKR] (RedmineID: #219424)
	DB: IRS_DBAGE-bodb02,IRS_DBBOF-bodb02,IRS_DBACC-bodb02,IRS_DBSIC-CustDB,IRS_DBSID-CustDB,IRS_DBCTG-CustDB,IRS_DBTP-bodb02,DBCustRepl-ReplCustDB,IRS_DBWH-bodb02
*/


/******************************ExchangeDailyOanda*********************************************/
----------------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM RepInfo WITH (NOLOCK)
			WHERE [name]='ExchangeDailyOanda' AND active=0)
BEGIN
	--Drop sp_put
	IF @@SERVERNAME IN ('IHRDISTC1','DBTP10C'	--PROD
						,'SIT_IHRDISTC1'		--SIT
						) -- on DBTP and Dist
		DROP PROCEDURE IF EXISTS Repl_PutExchangeDailyOanda_Dist;
	ELSE
		DROP PROCEDURE IF EXISTS Repl_PutExchangeDailyOanda;

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
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplExchangeDailyOanda] TO [repl_ap] AS [dbo]
GO