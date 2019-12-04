/*
	Created: 20191112@Percy
	DB: DBTXN
	Task: Bet Follow - Rename SPs (SIT)
*/

use bodb02
go

sp_rename 'Task_FollowBet_InsertBet', 'DEL_Task_FollowBet_InsertBet'
go
sp_rename 'Task_FollowBet_InsertBet_xtest', 'DEL_Task_FollowBet_InsertBet_xtest'
go
sp_rename 'Task_FollowBet_ListBet', 'DEL_Task_FollowBet_ListBet'
go
sp_rename 'Task_FollowBet_ListBet_xtest', 'DEL_Task_FollowBet_ListBet_xtest'
go
sp_rename 'Task_FollowBet_Step1', 'DEL_Task_FollowBet_Step1'
go
sp_rename 'Task_FollowBet_Step1_xtest', 'DEL_Task_FollowBet_Step1_xtest'
go
sp_rename 'Task_FollowBet_Step2', 'DEL_Task_FollowBet_Step2'
go
sp_rename 'Task_FollowBet_Step2_PlaceBet', 'DEL_Task_FollowBet_Step2_PlaceBet'
go
sp_rename 'Task_FollowBet_Step2_PlaceBet_UAT2', 'DEL_Task_FollowBet_Step2_PlaceBet_UAT2'
go
sp_rename 'Task_FollowBet_Step2_PlaceBet_xpre', 'DEL_Task_FollowBet_Step2_PlaceBet_xpre'
go
sp_rename 'Task_FollowBet_Step2_PlaceBet_xtest', 'DEL_Task_FollowBet_Step2_PlaceBet_xtest'
go
sp_rename 'Task_FollowBet_Step2_xtest', 'DEL_Task_FollowBet_Step2_xtest'
go


use CustDB
go

sp_rename 'Convert_CustFollow_Bet', 'DEL_Convert_CustFollow_Bet'
go