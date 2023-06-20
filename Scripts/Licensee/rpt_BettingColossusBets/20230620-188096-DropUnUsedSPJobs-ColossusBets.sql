/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20230620@Evan
	DB: DBLIC-bodb_LicenseeReport
	Task: Drop un-used SP [Redmine: #188096]
	Remark: Run on pair DB052-DB053 
*/
USE bodb_LicenseeReport
GO

DROP PROCEDURE DEL_Task_rptBettingColossusBets_CheckData
GO
DROP PROCEDURE DEL_GEN_rptBetting_ColossusBets
GO
DROP PROCEDURE DEL_GEN_rptBetting_ColossusBets14
GO
