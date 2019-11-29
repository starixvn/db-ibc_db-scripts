use CustDB
go

/*
	Created: 20191112@Percy
	DB: DBCUST.CustDB
	Task: Bet Follow - Rename tables
*/

sp_rename 'Cust_FollowBet', 'DEL_Cust_FollowBet'
go