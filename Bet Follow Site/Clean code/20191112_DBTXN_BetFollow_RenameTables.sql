use bodb02
go

/*
	Created: 20191112@Percy
	DB: DBTXN.bodb02
	Task: Bet Follow - Rename tables
*/

sp_rename 'Task_FollowBet_BA_From_DB054', 'DEL_Task_FollowBet_BA_From_DB054'
go
sp_rename 'Task_FollowBet_LastTransID', 'DEL_Task_FollowBet_LastTransID'
go
sp_rename 'Task_FollowBet_Details', 'DEL_Task_FollowBet_Details'
go