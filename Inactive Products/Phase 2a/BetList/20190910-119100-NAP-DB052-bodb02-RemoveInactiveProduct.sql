/*
	Created by: Kos
	Date: 20190916
	Task: NAP - Remove inactive products [Redmine ID: #119100]
	DB: DB052.bodb02
*/

USE [bodb02]
GO

EXEC sp_rename 'dbo.Acc_BetList_HRResults', 'DEL_Acc_BetList_HRResults'
EXEC sp_rename 'dbo.Acc_BetList_SelWinloss_Mem2', 'DEL_Acc_BetList_SelWinloss_Mem2'
EXEC sp_rename 'dbo.Acc_BetListByDayAllIP', 'DEL_Acc_BetListByDayAllIP'
EXEC sp_rename 'dbo.Acc_BetListByIP_OtherSports', 'DEL_Acc_BetListByIP_OtherSports'
EXEC sp_rename 'dbo.Acc_BetListByIP_Soccer', 'DEL_Acc_BetListByIP_Soccer'
EXEC sp_rename 'dbo.Acc_BetListbyIP_Username', 'DEL_Acc_BetListbyIP_Username'
EXEC sp_rename 'dbo.Acc_BetList_LC_Detail', 'DEL_Acc_BetList_LC_Detail'
EXEC sp_rename 'dbo.Acc_BetList_RNG_Detail', 'DEL_Acc_BetList_RNG_Detail'
EXEC sp_rename 'dbo.Acc_BetList_SelMatchResultSS', 'DEL_Acc_BetList_SelMatchResultSS'
EXEC sp_rename 'dbo.Acc_BetsSelBetCheckM', 'DEL_Acc_BetsSelBetCheckM'
EXEC sp_rename 'dbo.Acc_BetsSelBetList_ByTransID_Advance', 'DEL_Acc_BetsSelBetList_ByTransID_Advance'
EXEC sp_rename 'dbo.OAS_BetList_SelCombinationParlayDetail', 'DEL_OAS_BetList_SelCombinationParlayDetail'
EXEC sp_rename 'dbo.OAS_BetList_SelParlayDetail', 'DEL_OAS_BetList_SelParlayDetail'


GO
DROP PROCEDURE dbo.Acc_BetList_HRResults_xpre;
DROP PROCEDURE dbo.Acc_BetList_HRResults_xtest;
DROP PROCEDURE dbo.Acc_BetList_SelWinloss_Mem2_xtest;
DROP PROCEDURE dbo.Acc_BetListByIP_OtherSports_xtest;
DROP PROCEDURE dbo.Acc_BetListByIP_Soccer_xtest;
DROP PROCEDURE dbo.Acc_BetListbyIP_Username_xtest;
DROP PROCEDURE dbo.Acc_BetList_SelMatchResultSS_xpre;
DROP PROCEDURE dbo.Acc_BetList_SelMixParlay_xtest;
DROP PROCEDURE dbo.Acc_BetList_SelWinloss_Mem2_xtest;
DROP PROCEDURE dbo.Acc_BetsSelBetCheckM_xpre;
DROP PROCEDURE dbo.Acc_BetsSelBetCheckM_xtest;
DROP PROCEDURE dbo.Acc_BetsSelBetList_Old_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_12Bet_BetList_History_xpre;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_12Bet_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_12Bet_BetList_xpre;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_12Bet_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_AB88_BetList_History_xpre;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_AB88_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_AB88_BetList_xpre;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_AB88_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_ALog_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_ALog_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_Bezbet_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_Bezbet_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_Dela_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_Dela_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_M88_BetList_History_xpre;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_M88_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_M88_BetList_xpre;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_M88_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_MayFair_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_MayFair_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_Spondemo_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_Spondemo_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_SunCity_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_SunCity_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_TLC_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_TLC_BetList_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_Zzun88_BetList_History_xtest;
DROP PROCEDURE dbo.Acc_Rpt_Winloss_Zzun88_BetList_xtest;
DROP PROCEDURE dbo.Aff_BetList_RNG_Detail_xtest;
DROP PROCEDURE dbo.Aff_User_BetListResult_SelMatchNumberGame_xtest;
DROP PROCEDURE dbo.OAS_BetList_SelCombinationParlayDetail_xtest;
DROP PROCEDURE dbo.OAS_BetList_SelParlayDetail_xtest;
