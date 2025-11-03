/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Created: 20241113@Kelvin
	DB: DBACC-bodb02
	Task : LAP - Integrate Betby (VS6) [RedmineID: #212446]
*/

--DB062
USE bodb02
GO

UPDATE dbo.SystemSettings
SET VValue = 0
WHERE VName IN ('isArchivingDEPdata', 'isSummaryingDEPdata')