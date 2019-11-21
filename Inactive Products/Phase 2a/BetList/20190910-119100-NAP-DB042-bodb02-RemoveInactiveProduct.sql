/*
	Created by: Kos
	Date: 20190916
	Task: NAP - Remove inactive products [Redmine ID: #119100]
	DB: DB042.bodb02
*/

USE [bodb02]
GO

EXEC sp_rename 'dbo.Acc_BetListByDayAll', 'DEL_Acc_BetListByDayAll'
EXEC sp_rename 'dbo.Acc_BetListByDayAllIP', 'DEL_Acc_BetListByDayAllIP'
EXEC sp_rename 'dbo.Acc_BetsSelBetList', 'DEL_Acc_BetsSelBetList'
