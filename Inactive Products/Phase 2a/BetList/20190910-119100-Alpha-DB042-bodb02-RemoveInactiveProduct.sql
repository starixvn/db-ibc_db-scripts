/*
	Created by: Kos
	Date: 20190916
	Task: Alpha - Remove inactive products [Redmine ID: #119100]
	DB: DB042.bodb02
*/

USE [bodb02]
GO

EXEC sp_rename 'dbo.Age_BetList_TotalBets_BF_Ag', 'DEL_Age_BetList_TotalBets_BF_Ag'
EXEC sp_rename 'dbo.Age_BetList_TotalBets_BF_MAg', 'DEL_Age_BetList_TotalBets_BF_MAg'
EXEC sp_rename 'dbo.Age_BetList_TotalBets_BF_SAg', 'DEL_Age_BetList_TotalBets_BF_SAg'
EXEC sp_rename 'dbo.Age_CoreBetList_BetTicket_SelBettrans', 'DEL_Age_CoreBetList_BetTicket_SelBettrans'
EXEC sp_rename 'dbo.Age_CoreBetList_BetTicket_SelBettrans14', 'DEL_Age_CoreBetList_BetTicket_SelBettrans14'
EXEC sp_rename 'dbo.Age_CoreBetList_BetTicket_SelDetail', 'DEL_Age_CoreBetList_BetTicket_SelDetail'
EXEC sp_rename 'dbo.Age_CoreBetList_BetTicket_SelMainInfo', 'DEL_Age_CoreBetList_BetTicket_SelMainInfo'
EXEC sp_rename 'dbo.Age_CoreBetList_BetTicket_SelTranslog', 'DEL_Age_CoreBetList_BetTicket_SelTranslog'
EXEC sp_rename 'dbo.Age_CoreBetList_SMABettype_SelBetTicket', 'DEL_Age_CoreBetList_SMABettype_SelBetTicket'
EXEC sp_rename 'dbo.Age_CoreBetList_SMAEventBettype_SelBetTicket', 'DEL_Age_CoreBetList_SMAEventBettype_SelBetTicket'


GO
DROP PROCEDURE dbo.Age_BetList_SelRunning_Mem_DanielBK20180706_0732;
DROP PROCEDURE dbo.Age_BetList_SelRunning_Mem_Don_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunning_Mem_Lukas;
DROP PROCEDURE dbo.Age_BetList_SelRunning_Mem_Patrick_UAT3;
DROP PROCEDURE dbo.Age_BetList_SelRunning_Mem_Patrick_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunning_Mem_Patrick2_UAT3;
DROP PROCEDURE dbo.Age_BetList_SelRunning_Mem_Viet;

