/*<info serverAlias="DBEXT-bodb02"></info>*/
/*
	Created: 20251014@Kelvin
	DB: DBEXT-bodb02
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

--DB053/DB052
USE bodb02
GO
sp_rename 'Lrf_Rpt_CasinoTurnover','DEL_Lrf_Rpt_CasinoTurnover'
GO
sp_rename 'Lrf_Rpt_WinLoss','DEL_Lrf_Rpt_WinLoss'
GO

USE bodb_PlaytechCS
GO
sp_rename 'Lrf_Rpt_AGCasinoBalance_bak','DEL_Lrf_Rpt_AGCasinoBalance_bak'
GO
sp_rename 'Lrf_Verify_AGCasinoBalance','DEL_Lrf_Verify_AGCasinoBalance'

