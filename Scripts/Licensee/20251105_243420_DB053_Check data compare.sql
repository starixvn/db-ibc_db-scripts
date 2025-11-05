/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20251105@Kelvin
	DB: DBLIC-bodb_LicenseeReport
	Task : Check data  [RedmineID: #243420]
*/

--DB053
USE bodb_LicenseeReport
GO

EXEC dbo.Task_DepositDataCompare @Date = '2025-10-29', @DrawFilter = 1