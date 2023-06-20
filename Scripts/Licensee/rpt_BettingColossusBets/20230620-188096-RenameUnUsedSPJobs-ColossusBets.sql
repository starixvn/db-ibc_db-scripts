/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20230620@Evan
	DB: DBLIC-bodb_LicenseeReport
	Task: Rename un-used SP [Redmine: #188096]
	Remark: Run on pair DB052-DB053 (Step 2)
*/
USE bodb_LicenseeReport
GO
sp_rename 'Task_rptBettingColossusBets_CheckData', 'DEL_Task_rptBettingColossusBets_CheckData'
GO
sp_rename 'GEN_rptBetting_ColossusBets', 'DEL_GEN_rptBetting_ColossusBets'
GO
sp_rename 'GEN_rptBetting_ColossusBets14', 'DEL_GEN_rptBetting_ColossusBets14'
GO
