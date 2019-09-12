use bodb02
go

/*
	Created: 20190912@Percy
	DB: DBAGE.bodb02
	Task: Rename un-used SPs [RedmineID: #118699]
*/

sp_rename 'Age_Rpt_CommByBettype_HR_Master','DEL_Age_Rpt_CommByBettype_HR_Master'
go
sp_rename 'Age_Rpt_CommByBettype_HR_Agent','DEL_Age_Rpt_CommByBettype_HR_Agent'
go
sp_rename 'Age_Rpt_CommByBettype_HR_Member','DEL_Age_Rpt_CommByBettype_HR_Member'
go
sp_rename 'f_Get_ExcludeProduct_SiteCurrency','DEL_f_Get_ExcludeProduct_SiteCurrency'
go
sp_rename 'Age_ExcludeProduct_SiteCurrency_Sel','DEL_Age_ExcludeProduct_SiteCurrency_Sel'
go
sp_rename 'Age_Rpt_WinLossDetailPokerGames_Master','DEL_Age_Rpt_WinLossDetailPokerGames_Master'
go
sp_rename 'Age_Rpt_WinLossDetailPokerGames_Agent','DEL_Age_Rpt_WinLossDetailPokerGames_Agent'
go
sp_rename 'Age_Rpt_WinLossDetailPokerGames_Member','DEL_Age_Rpt_WinLossDetailPokerGames_Member'
go
sp_rename 'EAS_Rpt_WinLossDetailPokerGames_Com','DEL_EAS_Rpt_WinLossDetailPokerGames_Com'
go
sp_rename 'EAS_Rpt_WinLossDetailPokerGames_SAg','DEL_EAS_Rpt_WinLossDetailPokerGames_SAg'
go
sp_rename 'EAS_Rpt_WinLossDetailPokerGames_MAg','DEL_EAS_Rpt_WinLossDetailPokerGames_MAg'
go
sp_rename 'EAS_Rpt_WinLossDetailPokerGames_Ag','DEL_EAS_Rpt_WinLossDetailPokerGames_Ag'
go