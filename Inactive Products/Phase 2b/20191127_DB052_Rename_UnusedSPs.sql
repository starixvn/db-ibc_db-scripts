use bodb02
go
/*
	Created: 20191127@Percy
	DB: DB052
	Task: Rename unused SPs - already renamed on DB053
*/
sp_rename 'Age_Rpt_CommByBettype_Ag', 'DEL_Age_Rpt_CommByBettype_Ag'
go
sp_rename 'Age_Rpt_CommByBettype_Ag_xpre', 'DEL_Age_Rpt_CommByBettype_Ag_xpre'
go
sp_rename 'Age_Rpt_CommByBettype_Ag_xtest', 'DEL_Age_Rpt_CommByBettype_Ag_xtest'
go
sp_rename 'Age_Rpt_CommByBettype_MAg', 'DEL_Age_Rpt_CommByBettype_MAg'
go
sp_rename 'Age_Rpt_CommByBettype_MAg_xpre', 'DEL_Age_Rpt_CommByBettype_MAg_xpre'
go
sp_rename 'Age_Rpt_CommByBettype_MAg_xtest', 'DEL_Age_Rpt_CommByBettype_MAg_xtest'
go
sp_rename 'Age_Rpt_CommByBettype_SAg', 'DEL_Age_Rpt_CommByBettype_SAg'
go
sp_rename 'Age_Rpt_CommByBettype_SAg_xpre', 'DEL_Age_Rpt_CommByBettype_SAg_xpre'
go
sp_rename 'Age_Rpt_CommByBettype_SAg_xtest', 'DEL_Age_Rpt_CommByBettype_SAg_xtest'
go
sp_rename 'EAS_Rpt_WinLossDetailPokerGames_Com', 'DEL_EAS_Rpt_WinLossDetailPokerGames_Com'
go
sp_rename 'EAS_Rpt_WinLossDetailPokerGames_Com_UAT3', 'DEL_EAS_Rpt_WinLossDetailPokerGames_Com_UAT3'
go
sp_rename 'EAS_Rpt_WinLossDetailPokerGames_Com_xtest', 'DEL_EAS_Rpt_WinLossDetailPokerGames_Com_xtest'
go