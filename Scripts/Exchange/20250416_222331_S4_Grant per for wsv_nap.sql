/*<info serverAlias="DBCUST-bodb_CustomerLog"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBCUST-CustDB
	Task: Check and correct data ExchangeDailyOanda for today/tomorrow [RedmineID: #222331]
*/

USE bodb_CustomerLog;
GO
GRANT SELECT ON dbo.UserLog_Exchange to [wsv_nap]
GO


USE [msdb]
GO
IF DATABASE_PRINCIPAL_ID(N'wsv_nap') IS NULL
	CREATE USER [wsv_nap] FOR LOGIN [wsv_nap] WITH DEFAULT_SCHEMA = [dbo]
GRANT EXEC ON dbo.sp_send_dbmail TO [wsv_nap];