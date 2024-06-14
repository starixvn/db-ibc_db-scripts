/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20240614@EVAN
	DB: DBLIC-bodb_LicenseeReport
	Task: Regen deposit data rptBetting_Parlay
*/
USE bodb_LicenseeReport

GO

SET NOCOUNT ON

EXEC dbo.GEN_rptBetting_Parlay14 @datefrom ='2024-06-06', @dateto = '2024-06-07'
GO
EXEC dbo.GEN_rptBetting_Parlay14 @datefrom ='2024-06-09', @dateto = '2024-06-09'
GO
