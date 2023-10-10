/*<info serverAlias="DBEXT-bodb02"></info>*/
USE bodb02
GO

/*
	Created: 20230925@Evan
	Task: Drop Sps report exchange winlost [RedmineID: #193954]
	DB: Run on DB052-DB053
*/
USE bodb02

GO
sp_rename 'Lrf_Rpt_ExchangeWinloss_ByResettledDate', 'DEL_Lrf_Rpt_ExchangeWinloss_ByResettledDate'
GO
sp_rename 'Lrf_Rpt_ExchangeWinloss_ByResettledDate_Ag', 'DEL_Lrf_Rpt_ExchangeWinloss_ByResettledDate_Ag'
GO
sp_rename 'Lrf_Rpt_ExchangeWinloss_ByResettledDate_Mem', 'DEL_Lrf_Rpt_ExchangeWinloss_ByResettledDate_Mem'

GO

DROP PROCEDURE	Lrf_Rpt_ExchangeWinloss_ByResettledDate_Ag_xpre
DROP PROCEDURE	Lrf_Rpt_ExchangeWinloss_ByResettledDate_Ag_xtest

DROP PROCEDURE	Lrf_Rpt_ExchangeWinloss_ByResettledDate_Mem_xpre
DROP PROCEDURE	Lrf_Rpt_ExchangeWinloss_ByResettledDate_Mem_xtest

DROP PROCEDURE	Lrf_Rpt_ExchangeWinloss_ByResettledDate_xpre
DROP PROCEDURE	Lrf_Rpt_ExchangeWinloss_ByResettledDate_xtest