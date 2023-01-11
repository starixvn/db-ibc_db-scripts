/*<info serverAlias="DBARC-bodb_Archive"></info>*/
/*
	Created: 20220520@Kos
	DB: DBARC-bodb_Archive
	Task: Grant permission on table Match3rd_bk [Redmine: #160160]
*/

USE bodb_Archive
GO

GRANT	SELECT	ON	Match3rd_bk	TO	bodbLicenseeNet
GO

