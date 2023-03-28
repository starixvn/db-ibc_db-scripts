/*<info serverAlias="DBN88-bodb_N88_Archive"></info>*/
/*
	Created: 20230327@Kos
	DB: DBN88-bodb_N88_Archive
	Task: Grant permission on table TpBetRecord_bk [Redmine: #167823]
*/

USE bodb_N88_Archive
GO

GRANT	SELECT	ON	TpBetRecord_bk	TO	bodbLicenseeNet
GO

