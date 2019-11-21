/*
	Created by: Kos
	Date: 20191121
	Task: NAP - Remove inactive products [Redmine ID: #119100]
	DB: DB052.bodb02
*/

USE [bodb02]
GO

DROP PROCEDURE dbo.DEL_Acc_BetList_HRResults;
DROP PROCEDURE dbo.DEL_Acc_BetList_SelWinloss_Mem2;
DROP PROCEDURE dbo.DEL_Acc_BetListByDayAllIP;
DROP PROCEDURE dbo.DEL_Acc_BetListByIP_OtherSports;
DROP PROCEDURE dbo.DEL_Acc_BetListByIP_Soccer;
DROP PROCEDURE dbo.DEL_Acc_BetListbyIP_Username;
DROP PROCEDURE dbo.DEL_Acc_BetList_LC_Detail;
DROP PROCEDURE dbo.DEL_Acc_BetList_RNG_Detail;
DROP PROCEDURE dbo.DEL_Acc_BetList_SelMatchResultSS;
DROP PROCEDURE dbo.DEL_Acc_BetsSelBetCheckM;
DROP PROCEDURE dbo.DEL_Acc_BetsSelBetList_ByTransID_Advance;
DROP PROCEDURE dbo.DEL_OAS_BetList_SelCombinationParlayDetail;
DROP PROCEDURE dbo.DEL_OAS_BetList_SelParlayDetail;
