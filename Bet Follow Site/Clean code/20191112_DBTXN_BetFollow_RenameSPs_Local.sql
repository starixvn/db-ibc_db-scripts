use bodb02
go

/*
	Created: 20191112@Percy
	DB: DBTXN.bodb02
	Task: Bet Follow - Rename SPs (local)
*/
sp_rename 'Task_FollowBet_Step1', 'DEL_Task_FollowBet_Step1'
go
sp_rename 'Task_FollowBet_Step1_UAT4', 'DEL_Task_FollowBet_Step1_UAT4'
go
sp_rename 'Task_FollowBet_Step1_xpre', 'DEL_Task_FollowBet_Step1_xpre'
go
sp_rename 'Task_FollowBet_Step1_xtest', 'DEL_Task_FollowBet_Step1_xtest'
go
sp_rename 'Task_FollowBet_Step2', 'DEL_Task_FollowBet_Step2'
go
sp_rename 'Task_FollowBet_Step2_PlaceBet', 'DEL_Task_FollowBet_Step2_PlaceBet'
go
sp_rename 'Task_FollowBet_Step2_PlaceBet_xpre', 'DEL_Task_FollowBet_Step2_PlaceBet_xpre'
go
sp_rename 'Task_FollowBet_Step2_PlaceBet_xtest', 'DEL_Task_FollowBet_Step2_PlaceBet_xtest'
go
sp_rename 'Task_FollowBet_Step2_xpre', 'DEL_Task_FollowBet_Step2_xpre'
go
sp_rename 'Task_FollowBet_Step2_xtest', 'DEL_Task_FollowBet_Step2_xtest'
go