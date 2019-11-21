/*
	Created by: Kos
	Date: 20190916
	Task: Alpha - Remove inactive products [Redmine ID: #119100]
	DB: DB052.bodb02
*/

USE [bodb02]
GO

EXEC sp_rename 'dbo.Age_BetList_SelAllByDateHR_Ag', 'DEL_Age_BetList_SelAllByDateHR_Ag'
EXEC sp_rename 'dbo.Age_BetList_SelAllByDateHR_MAg', 'DEL_Age_BetList_SelAllByDateHR_MAg'
EXEC sp_rename 'dbo.Age_BetList_SelAllByDateHR_SAg', 'DEL_Age_BetList_SelAllByDateHR_SAg'
EXEC sp_rename 'dbo.Age_BetList_SelMatchResultFinance', 'DEL_Age_BetList_SelMatchResultFinance'
EXEC sp_rename 'dbo.Age_BetList_SelMatchResultParlay', 'DEL_Age_BetList_SelMatchResultParlay'
EXEC sp_rename 'dbo.Age_BetList_SelMatchResultSS', 'DEL_Age_BetList_SelMatchResultSS'
EXEC sp_rename 'dbo.Age_BetList_SelRunning_Mem', 'DEL_Age_BetList_SelRunning_Mem'
EXEC sp_rename 'dbo.Age_BetList_SelParlayDetail', 'DEL_Age_BetList_SelParlayDetail'
EXEC sp_rename 'dbo.Age_BetList_SelRunningAll_API', 'DEL_Age_BetList_SelRunningAll_API'
EXEC sp_rename 'dbo.Age_BetList_SelRunningByBettype_Ag', 'DEL_Age_BetList_SelRunningByBettype_Ag'
EXEC sp_rename 'dbo.Age_BetList_SelRunningByBettype_MAg', 'DEL_Age_BetList_SelRunningByBettype_MAg'
EXEC sp_rename 'dbo.Age_BetList_SelRunningByBettype_SAg', 'DEL_Age_BetList_SelRunningByBettype_SAg'
EXEC sp_rename 'dbo.Age_BetList_SelRunningByBettypeMatch_Ag', 'DEL_Age_BetList_SelRunningByBettypeMatch_Ag'
EXEC sp_rename 'dbo.Age_BetList_SelRunningByBettypeMatch_MAg', 'DEL_Age_BetList_SelRunningByBettypeMatch_MAg'
EXEC sp_rename 'dbo.Age_BetList_SelRunningByBettypeMatch_SAg', 'DEL_Age_BetList_SelRunningByBettypeMatch_SAg'
EXEC sp_rename 'dbo.Age_BetList_SelRunningByDate_Mem', 'DEL_Age_BetList_SelRunningByDate_Mem'
EXEC sp_rename 'dbo.Age_BetList_SelWinlossByBettypeMatch_Ag', 'DEL_Age_BetList_SelWinlossByBettypeMatch_Ag'
EXEC sp_rename 'dbo.Age_BetList_SelWinlossByBettypeMatch_MAg', 'DEL_Age_BetList_SelWinlossByBettypeMatch_MAg'
EXEC sp_rename 'dbo.Age_BetList_SelWinlossByBettypeMatch_SAg', 'DEL_Age_BetList_SelWinlossByBettypeMatch_SAg'
EXEC sp_rename 'dbo.Age_BetList_SelWinLossByDate_Mem_Old', 'DEL_Age_BetList_SelWinLossByDate_Mem_Old'
EXEC sp_rename 'dbo.Age_Monitor_BetlistSel', 'DEL_Age_Monitor_BetlistSel'
EXEC sp_rename 'dbo.Age_Monitor_BetlistSel_Ag_AllBettypes', 'DEL_Age_Monitor_BetlistSel_Ag_AllBettypes'
EXEC sp_rename 'dbo.Age_Monitor_BetlistSel_Ag_HDP', 'DEL_Age_Monitor_BetlistSel_Ag_HDP'
EXEC sp_rename 'dbo.Age_Monitor_BetlistSel_Ag_OtherBettypes', 'DEL_Age_Monitor_BetlistSel_Ag_OtherBettypes'
EXEC sp_rename 'dbo.Age_Monitor_BetlistSel_Ag_OU', 'DEL_Age_Monitor_BetlistSel_Ag_OU'
EXEC sp_rename 'dbo.Age_Monitor_BetlistSoccerSel_Ag_AllBettypes', 'DEL_Age_Monitor_BetlistSoccerSel_Ag_AllBettypes'
EXEC sp_rename 'dbo.Age_Monitor_BetlistSoccerSel_Ag_HDP', 'DEL_Age_Monitor_BetlistSoccerSel_Ag_HDP'
EXEC sp_rename 'dbo.Age_Monitor_BetlistSoccerSel_Ag_OtherBettypes', 'DEL_Age_Monitor_BetlistSoccerSel_Ag_OtherBettypes'
EXEC sp_rename 'dbo.Age_Monitor_BetlistSoccerSel_Ag_OU', 'DEL_Age_Monitor_BetlistSoccerSel_Ag_OU'
EXEC sp_rename 'dbo.Age_Monitor_LeagueSelByGroup', 'DEL_Age_Monitor_LeagueSelByGroup'
EXEC sp_rename 'dbo.Age_Monitor_LeagueSelBySport', 'DEL_Age_Monitor_LeagueSelBySport'
EXEC sp_rename 'dbo.Age_Monitor_MatchSel', 'DEL_Age_Monitor_MatchSel'
EXEC sp_rename 'dbo.Age_Monitor_OutrightSel', 'DEL_Age_Monitor_OutrightSel'
EXEC sp_rename 'dbo.Age_Monitor_SportSel', 'DEL_Age_Monitor_SportSel'
EXEC sp_rename 'dbo.Age_BettransSelBetSlip', 'DEL_Age_BettransSelBetSlip'
EXEC sp_rename 'dbo.Age_Result_RaceSelByMeeting', 'DEL_Age_Result_RaceSelByMeeting'
EXEC sp_rename 'dbo.Age_Result_RBRaceSelByMeeting', 'DEL_Age_Result_RBRaceSelByMeeting'
EXEC sp_rename 'dbo.Agw_Rpt_ResultSelDate', 'DEL_Agw_Rpt_ResultSelDate'
EXEC sp_rename 'dbo.Agw_Rpt_ResultSelMatch', 'DEL_Agw_Rpt_ResultSelMatch'


GO
DROP PROCEDURE dbo.Age_BetList_SelAllByDateHR_Ag_xtest;
DROP PROCEDURE dbo.Age_BetList_SelAllByDateHR_MAg_xtest;
DROP PROCEDURE dbo.Age_BetList_SelAllByDateHR_SAg_xtest;
DROP PROCEDURE dbo.Age_BetList_SelMatchResultFinance_xpre;
DROP PROCEDURE dbo.Age_BetList_SelMatchResultParlay_xpre;
DROP PROCEDURE dbo.Age_BetList_SelMatchResultParlay_xtest;
DROP PROCEDURE dbo.Age_BetList_SelMatchResultSS_xpre;
DROP PROCEDURE dbo.Age_BetList_SelParlayDetail_xpre;
DROP PROCEDURE dbo.Age_BetList_SelParlayDetail_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunningAll_API_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettype_Ag_xpre;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettype_Ag_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettype_MAg_xpre;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettype_MAg_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettype_SAg_xpre;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettype_SAg_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettypeMatch_Ag_xpre;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettypeMatch_Ag_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettypeMatch_MAg_xpre;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettypeMatch_MAg_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettypeMatch_SAg_xpre;
DROP PROCEDURE dbo.Age_BetList_SelRunningByBettypeMatch_SAg_xtest;
DROP PROCEDURE dbo.Age_BetList_SelRunningByDate_Mem_xpre;
DROP PROCEDURE dbo.Age_BetList_SelRunningByDate_Mem_xtest;
DROP PROCEDURE dbo.Age_BetList_SelWinlossByBettypeMatch_Ag_xpre;
DROP PROCEDURE dbo.Age_BetList_SelWinlossByBettypeMatch_Ag_xtest;
DROP PROCEDURE dbo.Age_BetList_SelWinlossByBettypeMatch_MAg_xpre;
DROP PROCEDURE dbo.Age_BetList_SelWinlossByBettypeMatch_MAg_xtest;
DROP PROCEDURE dbo.Age_BetList_SelWinlossByBettypeMatch_SAg_xpre;
DROP PROCEDURE dbo.Age_BetList_SelWinlossByBettypeMatch_SAg_xtest;
DROP PROCEDURE dbo.Age_BetList_SelWinLossByDate_Mem_Old_xtest;
DROP PROCEDURE dbo.Age_Monitor_BetlistSel_Ag_AllBettypes_xtest;
DROP PROCEDURE dbo.Age_Monitor_BetlistSel_Ag_HDP_xtest;
DROP PROCEDURE dbo.Age_Monitor_BetlistSel_Ag_OtherBettypes_xtest;
DROP PROCEDURE dbo.Age_Monitor_BetlistSel_Ag_OU_xtest;
DROP PROCEDURE dbo.Age_Monitor_BetlistSel_xtest;
DROP PROCEDURE dbo.Age_Monitor_BetlistSoccerSel_Ag_AllBettypes_xtest;
DROP PROCEDURE dbo.Age_Monitor_BetlistSoccerSel_Ag_HDP_xtest;
DROP PROCEDURE dbo.Age_Monitor_BetlistSoccerSel_Ag_OtherBettypes_xtest;
DROP PROCEDURE dbo.Age_Monitor_BetlistSoccerSel_Ag_OU_xtest;
DROP PROCEDURE dbo.Age_Monitor_MatchSel_xtest;
DROP PROCEDURE dbo.Age_BettransSelBetSlip_xpre;
DROP PROCEDURE dbo.Age_BettransSelBetSlip_xtest;
DROP PROCEDURE dbo.Age_Result_RaceSelByMeeting_xpre;
DROP PROCEDURE dbo.Age_Result_RaceSelByMeeting_xtest;
