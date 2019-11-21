/*
	Created by: Kos
	Date: 20190916
	Task: Alpha - Remove inactive products [Redmine ID: #119100]
	DB: DB061.bodb02
*/

USE [bodb02]
GO

EXEC sp_rename 'dbo.Age_BetList_SelParlayDetail_Old', 'DEL_Age_BetList_SelParlayDetail_Old'
EXEC sp_rename 'dbo.Age_BettransSelBetSlip', 'DEL_Age_BettransSelBetSlip'
EXEC sp_rename 'dbo.Age_BettransSelBetSlip_Old', 'DEL_Age_BettransSelBetSlip_Old'
EXEC sp_rename 'dbo.Age_BetList_SelByDayAll_Mem_Old', 'DEL_Age_BetList_SelByDayAll_Mem_Old'
EXEC sp_rename 'dbo.Age_BetList_SelByDayAll_Mem_Old', 'DEL_Age_BetList_SelWinLossByDate_Mem_Old'


GO
DROP PROCEDURE dbo.Age_BetList_SelAllByDate_Mem_xpre;
DROP PROCEDURE dbo.Age_BetList_SelByDayAll_Mem_Old_viettest;
DROP PROCEDURE dbo.Age_BetList_SelParlayDetail_Old_xtest;
DROP PROCEDURE dbo.Age_BettransSelBetSlip_Old_xpre;
DROP PROCEDURE dbo.Age_BettransSelBetSlip_Old_xtest;
DROP PROCEDURE dbo.Age_BetList_SelWinLossByDate_Mem_Old_xpre;
DROP PROCEDURE dbo.Age_BetList_SelWinLossByDate_Mem_Old_xtest;