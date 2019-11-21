/*
	Created by: Kos
	Date: 20190916
	Task: NAP - Remove inactive products [Redmine ID: #119100]
	DB: DB053.bodb02
*/

USE [bodb02]
GO

EXEC sp_rename 'dbo.Acc_BetList_HRResults', 'DEL_Acc_BetList_HRResults'
EXEC sp_rename 'dbo.Acc_BetList_LC_Detail', 'DEL_Acc_BetList_LC_Detail'
EXEC sp_rename 'dbo.Acc_BetList_RNG_Detail', 'DEL_Acc_BetList_RNG_Detail'
EXEC sp_rename 'dbo.Acc_BetList_SelMatchResultSS', 'DEL_Acc_BetList_SelMatchResultSS'
EXEC sp_rename 'dbo.Acc_BetList_SelWinloss_Mem2', 'DEL_Acc_BetList_SelWinloss_Mem2'
EXEC sp_rename 'dbo.Acc_BetListByDayAllIP', 'DEL_Acc_BetListByDayAllIP'
EXEC sp_rename 'dbo.Acc_BetsSelBetCheckM', 'DEL_Acc_BetsSelBetCheckM'
EXEC sp_rename 'dbo.Acc_BetsSelBetList_bk', 'DEL_Acc_BetsSelBetList_bk'
EXEC sp_rename 'dbo.Acc_BetsSelBetList_ByTransID_Advance', 'DEL_Acc_BetsSelBetList_ByTransID_Advance'
EXEC sp_rename 'dbo.Acc_Rpt_WinlostFOddsHRMS88_BetList_Details', 'DEL_Acc_Rpt_WinlostFOddsHRMS88_BetList_Details'
EXEC sp_rename 'dbo.Acc_Rpt_WinlostHRMS88_BetList_Details', 'DEL_Acc_Rpt_WinlostHRMS88_BetList_Details'


GO
DROP PROCEDURE dbo.Acc_BetList_HRResults_xpre;
DROP PROCEDURE dbo.Acc_BetList_HRResults_xtest;
DROP PROCEDURE dbo.Acc_BetList_LC_Detail_UAT3;
DROP PROCEDURE dbo.Acc_BetList_LC_Detail_xpre;
DROP PROCEDURE dbo.Acc_BetList_RNG_Detail_UAT3;
DROP PROCEDURE dbo.Acc_BetList_RNG_Detail_xpre;
DROP PROCEDURE dbo.Acc_BetList_RNG_Detail_xtest;
DROP PROCEDURE dbo.Acc_BetList_SelMatchResultSS_xpre;
DROP PROCEDURE dbo.Acc_BetList_SelMixParlay_xtest;
DROP PROCEDURE dbo.Acc_BetList_SelWinloss_Mem2_xtest;
DROP PROCEDURE dbo.Acc_BetListByIP_OtherSports_xtest;
DROP PROCEDURE dbo.Acc_BetListByIP_Soccer_xtest;
DROP PROCEDURE dbo.Acc_BetsSelBetCheckM_UAT3;
DROP PROCEDURE dbo.Acc_BetsSelBetCheckM_xpre;
DROP PROCEDURE dbo.Acc_BetsSelBetCheckM_xtest;
DROP PROCEDURE dbo.Acc_BetsSelBetList_ByTransID_Advance_UAT2;
DROP PROCEDURE dbo.Acc_BetsSelBetList_ByTransID_Advance_xpre;
DROP PROCEDURE dbo.Acc_BetsSelBetList_ByTransID_Advance_xtest;
DROP PROCEDURE dbo.Acc_BetsSelBetList_ByTransID_bk;
DROP PROCEDURE dbo.Acc_BetsSelBetList_Francis;
DROP PROCEDURE dbo.Acc_BetsSelBetList_lukas;
DROP PROCEDURE dbo.Acc_BetsSelBetList_Old_xtest;
