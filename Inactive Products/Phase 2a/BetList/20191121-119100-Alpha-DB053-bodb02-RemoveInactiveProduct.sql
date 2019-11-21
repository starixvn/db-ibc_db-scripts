/*
	Created by: Kos
	Date: 20191121
	Task: Alpha - Remove inactive products [Redmine ID: #119100]
	DB: DB053.bodb02
*/

USE [bodb02]
GO

DROP PROCEDURE dbo.DEL_Age_BetList_SelAllByDateHR_Ag;
DROP PROCEDURE dbo.DEL_Age_BetList_SelAllByDateHR_MAg;
DROP PROCEDURE dbo.DEL_Age_BetList_SelAllByDateHR_SAg;
DROP PROCEDURE dbo.DEL_Age_BetList_SelMatchResultFinance;
DROP PROCEDURE dbo.DEL_Age_BetList_SelMatchResultParlay;
DROP PROCEDURE dbo.DEL_Age_BetList_SelMatchResultSS;
DROP PROCEDURE dbo.DEL_Age_BetList_SelParlayDetail;
DROP PROCEDURE dbo.DEL_Age_BetList_SelRunning_API;
DROP PROCEDURE dbo.DEL_Age_BetList_SelRunning_Mem;
DROP PROCEDURE dbo.DEL_Age_BetList_SelRunningAll_API;
DROP PROCEDURE dbo.DEL_Age_BetList_SelRunningByBettype_Ag;
DROP PROCEDURE dbo.DEL_Age_BetList_SelRunningByBettype_MAg;
DROP PROCEDURE dbo.DEL_Age_BetList_SelRunningByBettype_SAg;
DROP PROCEDURE dbo.DEL_Age_BetList_SelRunningByBettypeMatch_Ag;
DROP PROCEDURE dbo.DEL_Age_BetList_SelRunningByBettypeMatch_MAg;
DROP PROCEDURE dbo.DEL_Age_BetList_SelRunningByBettypeMatch_SAg;
DROP PROCEDURE dbo.DEL_Age_BetList_SelWinlossByBettypeMatch_Ag;
DROP PROCEDURE dbo.DEL_Age_BetList_SelWinlossByBettypeMatch_MAg;
DROP PROCEDURE dbo.DEL_Age_BetList_SelWinlossByBettypeMatch_SAg;
DROP PROCEDURE dbo.DEL_Age_BetList_TotalBets_BF_Ag;
DROP PROCEDURE dbo.DEL_Age_BetList_TotalBets_BF_MAg;
DROP PROCEDURE dbo.DEL_Age_BetList_TotalBets_BF_SAg;
DROP PROCEDURE dbo.DEL_Age_Result_MatchSelGoalHistory;
DROP PROCEDURE dbo.DEL_Age_Result_RaceSelByMeeting;
DROP PROCEDURE dbo.DEL_Age_Result_RaceSelHRSCR;
DROP PROCEDURE dbo.DEL_Age_Result_RBRaceSelByMeeting;
DROP PROCEDURE dbo.DEL_Age_Result_SelAvaiDate;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSel;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSel_Ag_AllBettypes;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSel_Ag_HDP;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSel_Ag_OtherBettypes;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSel_Ag_OU;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSelAllSports;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSelByOtherSports;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSelBySoccer;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSoccerSel_Ag_AllBettypes;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSoccerSel_Ag_HDP;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSoccerSel_Ag_OtherBettypes;
DROP PROCEDURE dbo.DEL_Age_Monitor_BetlistSoccerSel_Ag_OU;
DROP PROCEDURE dbo.DEL_Age_Monitor_LeagueSelByGroup;
DROP PROCEDURE dbo.DEL_Age_Monitor_LeagueSelBySport;
DROP PROCEDURE dbo.DEL_Age_Monitor_MatchSel;
DROP PROCEDURE dbo.DEL_Age_Monitor_MatchSelByID;
DROP PROCEDURE dbo.DEL_Age_Monitor_OutrightSel;
DROP PROCEDURE dbo.DEL_Age_Monitor_SportSel;
DROP PROCEDURE dbo.DEL_Age_BettransSelBetSlip;
DROP PROCEDURE dbo.DEL_Agw_Rpt_ResultSelDate;
DROP PROCEDURE dbo.DEL_Agw_Rpt_ResultSelMatch;
