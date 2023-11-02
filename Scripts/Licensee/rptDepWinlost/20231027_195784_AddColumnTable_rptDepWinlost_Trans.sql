/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20231027@Evan
	DB: DBRPT-bodb_Report
	Task: Add column RawDrawGame, RawTurnOver  [Redmine: #195784]
		- Step 1: Add new column
*/

USE bodb_Report
GO

ALTER TABLE rptDepWinlost_Trans
ADD RawDrawGame MONEY, RawTurnover MONEY

GO
ALTER TABLE rptDepWinlostByProduct_SUM
ADD RawDrawGame MONEY, RawTurnover MONEY

GO
ALTER TABLE rptDepwinlost_SUM
ADD RawDrawGame MONEY, RawTurnover MONEY

GO
ALTER TABLE rptDepWinlost_bk
ADD RawDrawGame MONEY, RawTurnover MONEY

GO
ALTER TABLE rptDepWinlostByProduct_bk
ADD RawDrawGame MONEY, RawTurnover MONEY


