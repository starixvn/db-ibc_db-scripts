/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Created: 20210720@Kos
	DB: DBACC-bodb02
	Task: Grant permission [Redmine: #151151]
*/

USE bodb02
GO

GRANT	SELECT	ON	League	TO	bodbLicenseeNet
GO

GRANT	SELECT	ON	f_GroupBettype	TO	bodbLicenseeNet
GO
