/*<info serverAlias="DBCustRepl-ReplCustDB,IRS_DBSIC-CustDB,IRS_DBSID-CustDB,IRS_DBCTG-CustDB,IRS_DBAGE-bodb02,IRS_DBBOF-bodb02,IRS_DBACC-bodb02,IRS_DBTP-bodb02,IRS_DBWH-bodb02"></info>*/
/*
	Created: 20250717@Kelvin
	DB: DBCustRepl-ReplCustDB,IRS_DBSIC-CustDB,IRS_DBSID-CustDB,IRS_DBCTG-CustDB,IRS_DBAGE-bodb02,IRS_DBBOF-bodb02,IRS_DBACC-bodb02,IRS_DBTP-bodb02,IRS_DBWH-bodb02
	Task : LAP - Support based ZAR (RedmineID: #232973)
*/

/*
USE CustDB
USE ReplCustDB
USE bodb02
*/

IF @@SERVERNAME NOT IN ('IHRDISTC1','DBDIST03C\Inst3','DBSITEC1','DBSITEC2\INST2','DBTRANS\INST2','DB053','DB052','DB055','DB054','DB061','DB062','DBKULC1','DBDW','DBDW2')
OR DB_NAME() NOT IN ('CustDB','ReplCustDB','bodb02')
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
	IF @@SERVERNAME IN (
						'IHRDISTC1','DBKULC1'			--PROD
						--'TESTDBCUST','DB92\TESTDBTP'	-- local
						,'SITIHRDISTC1'				--SIT
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
	,[ZAR] [FLOAT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplExchangeDailyOanda] TO [repl_ap] AS [dbo]
GO