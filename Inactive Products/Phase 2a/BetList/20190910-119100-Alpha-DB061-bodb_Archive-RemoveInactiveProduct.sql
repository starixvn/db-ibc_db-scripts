/*
	Created by: Kos
	Date: 20190916
	Task: Alpha - Remove inactive products [Redmine ID: #119100]
	DB: DB061.bodb_Archive
*/

USE [bodb_Archive]
GO

EXEC sp_rename 'dbo.Age_BettransSelBetSlip_Old', 'DEL_Age_BettransSelBetSlip_Old'
EXEC sp_rename 'dbo.Age_CoreBetList_BetTicket_SelDetail', 'DEL_Age_CoreBetList_BetTicket_SelDetail'
EXEC sp_rename 'dbo.Age_CoreBetList_BetTicket_SelMainInfo', 'DEL_Age_CoreBetList_BetTicket_SelMainInfo'


GO
DROP PROCEDURE dbo.Age_BettransSelBetSlip_Old_xpre;
DROP PROCEDURE dbo.Age_CoreBetList_BetTicket_SelBettransArc_XPerf;
DROP PROCEDURE dbo.Age_CoreBetList_BetTicket_SelDetail_xtest;
DROP PROCEDURE dbo.Age_CoreBetList_BetTicket_SelMainInfo_xtest;
DROP PROCEDURE dbo.Acc_BetsSelBetList_Old_Patrick;