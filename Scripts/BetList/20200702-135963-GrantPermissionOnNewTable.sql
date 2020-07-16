/*<info serverAlias="DBARC-bodb_Archive" isFunction="0" isNested=""></info>*/
/*
	Created: 20200702@Kos
	DB: DBARC.bodb_Archive
	Task: Grant permission on table VSRaceInfo_bk [Redmine: #135963]
*/


GRANT	SELECT	ON	VSRaceInfo_bk	TO	bodbDownlineNet
GRANT	SELECT	ON	VSRaceInfo_bk	TO	bodbDownlineNetView
GRANT	SELECT	ON	VSRaceInfo_bk	TO	bodbAdminNet
GRANT	SELECT	ON	VSRaceInfo_bk	TO	bodbLicenseeNet
GO