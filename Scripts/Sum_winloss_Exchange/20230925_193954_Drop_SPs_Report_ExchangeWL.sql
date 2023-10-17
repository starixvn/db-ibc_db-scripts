/*<info serverAlias="DBEXT-bodb02"></info>*/
USE bodb02
GO

/*
	Created: 20231017@Evan
	Task: Delete Sps report exchange winlost [RedmineID: #193954]
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
