/*<info serverAlias="DBARC-bodb_Archive"></info>*/
/*
	Created : 20220413@Kos
	DB: DBARC-bodb_Archive
	Task: GRANT PERMISSION on table CashOutSelling_bk [RedmineID: #169007]
*/

USE [bodb_Archive]
GO

GRANT	SELECT	ON	CashOutSelling_bk	TO	bodbLicenseeNet
GRANT	SELECT	ON	CashOutSelling_bk	TO	bodbAdminNet
GRANT	SELECT	ON	CashOutSelling_bk	TO	bodbDownlineNetView
GRANT	SELECT	ON	CashOutSelling_bk	TO	bodbDownlineNet

GO