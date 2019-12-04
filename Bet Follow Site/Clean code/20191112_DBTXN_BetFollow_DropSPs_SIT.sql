/*
	Created: 20191112@Percy
	DB: DBTXN
	Task: Bet Follow - Drop SPs (SIT)
*/

use bodb02
go

drop procedure DEL_Task_FollowBet_InsertBet
go
drop procedure DEL_Task_FollowBet_InsertBet_xtest
go
drop procedure DEL_Task_FollowBet_ListBet
go
drop procedure DEL_Task_FollowBet_ListBet_xtest
go
drop procedure DEL_Task_FollowBet_Step1
go
drop procedure DEL_Task_FollowBet_Step1_xtest
go
drop procedure DEL_Task_FollowBet_Step2
go
drop procedure DEL_Task_FollowBet_Step2_PlaceBet
go
drop procedure DEL_Task_FollowBet_Step2_PlaceBet_UAT2
go
drop procedure DEL_Task_FollowBet_Step2_PlaceBet_xpre
go
drop procedure DEL_Task_FollowBet_Step2_PlaceBet_xtest
go
drop procedure DEL_Task_FollowBet_Step2_xtest
go


use CustDB
go

drop procedure DEL_Convert_CustFollow_Bet
go