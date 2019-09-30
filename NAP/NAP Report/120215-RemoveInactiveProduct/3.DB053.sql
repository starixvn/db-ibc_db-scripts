/*
	Task: Rename unused SPs to 'DEL_%'
	Redmine: #120215
	Server: DB053
	Database: bodb02
*/

USE bodb02

EXEC sp_rename 'Acc_Rpt_GamesActive_Products', 'DEL_Acc_Rpt_GamesActive_Products'
EXEC sp_rename 'Acc_Rpt_SMAs_TurnOver', 'DEL_Acc_Rpt_SMAs_TurnOver'
EXEC sp_rename 'Acc_Rpt_WinlostHRMS88_Details', 'DEL_Acc_Rpt_WinlostHRMS88_Details'

EXEC sp_rename 'Acc_Rpt_GamesActive_Products_UAT1', 'DEL_Acc_Rpt_GamesActive_Products_UAT1'
EXEC sp_rename 'Acc_Rpt_GamesActive_Products_UAT2', 'DEL_Acc_Rpt_GamesActive_Products_UAT2'
EXEC sp_rename 'Acc_Rpt_GamesActive_Products_xpre', 'DEL_Acc_Rpt_GamesActive_Products_xpre'
EXEC sp_rename 'Acc_Rpt_GamesActive_Products_xtest', 'DEL_Acc_Rpt_GamesActive_Products_xtest'
EXEC sp_rename 'Acc_Rpt_SMAs_TurnOver_xpre', 'DEL_Acc_Rpt_SMAs_TurnOver_xpre'
EXEC sp_rename 'Acc_Rpt_SMAs_TurnOver_xtest', 'DEL_Acc_Rpt_SMAs_TurnOver_xtest'
