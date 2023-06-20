/*<info serverAlias="DBEXT-bodb02"></info>*/
/*
	Created: 20230620@Evan
	DB: DBEXT-bodb02
	Task: Drop un-used SP [Redmine: #188096]
	Remark: Run on pair DB052-DB053 
*/
USE bodb02
GO

DROP PROCEDURE DEL_Lrf_Rpt_ColossusBetsWinloss
GO
DROP PROCEDURE DEL_Lrf_Rpt_ColossusBetsWinloss_Detail 
GO