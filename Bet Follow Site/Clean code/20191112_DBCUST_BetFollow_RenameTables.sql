use CustDB
go

/*
	Created: 20191112@Percy
	DB: DBCUST.CustDB
	Task: Bet Follow - Rename tables
*/

-- remove table Cust_FollowBet from pubication CustDB_DR_sync first
sp_rename 'Cust_FollowBet', 'DEL_Cust_FollowBet'
go


-------- ========
sp_rename 'Cust_FollowBet_bk', 'DEL_Cust_FollowBet_bk'
go

sp_rename 'Cust_FollowBet_xtest', 'Cust_FollowBet_xtest'
go