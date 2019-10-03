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
sp_rename 'Age_Rpt_WinLossDetailPokerGames_Master','DEL_Age_Rpt_WinLossDetailPokerGames_Master'
go
sp_rename 'Age_Rpt_WinLossDetailPokerGames_Agent','DEL_Age_Rpt_WinLossDetailPokerGames_Agent'
go
sp_rename 'Age_Rpt_WinLossDetailPokerGames_Member','DEL_Age_Rpt_WinLossDetailPokerGames_Member'
go