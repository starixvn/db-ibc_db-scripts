/*<info serverAlias="DBARC-bodb_Archive" ></info>*/

/*
	Created by: Razor
	Date: 20211112
	Task: GRANT PERMISSION to SELECT VSOutright_bk
	DB: DBARC.bodb_Archive
*/
GRANT SELECT ON VSOutright_bk TO bodbAdminNet;
GRANT SELECT ON VSOutright_bk TO bodbLicenseeNet;
GO