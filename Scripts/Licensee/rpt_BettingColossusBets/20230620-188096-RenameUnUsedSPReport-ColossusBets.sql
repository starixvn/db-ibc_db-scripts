/*<info serverAlias="DBEXT-bodb02"></info>*/
/*
	Created: 20230620@Evan
	DB: DBEXT-bodb02
	Task: Rename un-used SP [Redmine: #188096]
	Remark: Run on pair DB052-DB053 (Step 3)
*/
USE bodb02
GO

sp_rename 'Lrf_Rpt_ColossusBetsWinloss', 'DEL_Lrf_Rpt_ColossusBetsWinloss'
GO
sp_rename 'Lrf_Rpt_ColossusBetsWinloss_Detail', 'DEL_Lrf_Rpt_ColossusBetsWinloss_Detail'
GO

DROP PROCEDURE Lrf_Rpt_ColossusBetsWinloss_UAT3
GO
DROP PROCEDURE Lrf_Rpt_ColossusBetsWinloss_Detail_UAT3 
GO
DROP PROCEDURE Lrf_Rpt_ColossusBetsWinloss_xtest
GO
DROP PROCEDURE Lrf_Rpt_ColossusBetsWinloss_Detail_xtest
GO