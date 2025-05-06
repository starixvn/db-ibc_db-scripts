/*<info serverAlias="DBLOG-bodb_CustomerLog"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLOG-bodb_CustomerLog
	Task: Check and correct data ExchangeDailyOanda for today/tomorrow [RedmineID: #222331]
*/

USE bodb_CustomerLog;
GO
IF DATABASE_PRINCIPAL_ID(N'wsv_nap') IS NULL
	CREATE USER [wsv_nap] FOR LOGIN [wsv_nap] WITH DEFAULT_SCHEMA = [dbo]

GRANT SELECT ON dbo.UserLog_Exchange to [wsv_nap]
GO
