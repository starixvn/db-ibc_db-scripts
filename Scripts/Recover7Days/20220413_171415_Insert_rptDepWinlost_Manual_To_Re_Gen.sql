/*<info serverAlias="DBRPT-bodb_report"></info>*/
/*
	Create: 20220413@Sol
	Task: re-gen data by insert into rptDepWinlost_Manual table - [Redmine: #171415] 
	DB: DBRPT-bodb_report
*/ 
 
USE bodb_Report

GO

INSERT INTO dbo.rptDepWinlost_Manual (Winlostdate)
VALUES ('2022-04-07')

GO