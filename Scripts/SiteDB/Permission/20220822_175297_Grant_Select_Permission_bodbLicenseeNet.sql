/*<info serverAlias="DBSIG-CustDB"></info>*/
USE [bodb02]
GO
/*
	Created: 20220822@Sol
	DB: DBSIG-CustDB
	Task: grant permisson to bodbLicenseeNet - [RedmineID: #175297]
*/

Use CustDB

GO

GRANT SELECT ON ExchangeDailyOanda TO bodbLicenseeNet
GRANT SELECT ON CustInfo TO bodbLicenseeNet
GRANT SELECT ON Customer TO bodbLicenseeNet

GO