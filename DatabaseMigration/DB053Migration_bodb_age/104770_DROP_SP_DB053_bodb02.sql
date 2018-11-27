/*
	Created: 20181002@Helen
	Task: DB052.bodb_NAP migration - [Redmine:104770]
	SERVER: DB053/bodb02
*/
USE bodb02

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('Age_Rpt_DailyWLFoobet '),
('DBA_ReInit_bettrans_forecast_agent '),
('Task_Delete_bettrans_running '),
('Acc_Rpt_Winloss_12Bet'),
('Acc_Rpt_Winloss_12Bet_BetList'),
('Acc_Rpt_Winloss_12Bet_BetList_History'),
('Acc_Rpt_Winloss_12Bet_BetList_History_xtest'),
('Acc_Rpt_Winloss_12Bet_BetList_xpre'),
('Acc_Rpt_Winloss_12Bet_BetList_xtest'),
('Acc_Rpt_Winloss_12Bet_Details_Agent'),
('Acc_Rpt_Winloss_12Bet_Details_Agent_xpre'),
('Acc_Rpt_Winloss_12Bet_Details_Member'),
('Acc_Rpt_Winloss_12Bet_Details_Member_xpre'),
('Acc_Rpt_Winloss_12Bet_xpre'),
('Acc_Rpt_Winloss_AB88'),
('Acc_Rpt_Winloss_AB88_BetList'),
('Acc_Rpt_Winloss_AB88_BetList_History'),
('Acc_Rpt_Winloss_AB88_BetList_History_xtest'),
('Acc_Rpt_Winloss_AB88_BetList_xpre'),
('Acc_Rpt_Winloss_AB88_BetList_xtest'),
('Acc_Rpt_Winloss_AB88_Details'),
('Acc_Rpt_Winloss_AB88_Details_Agent'),
('Acc_Rpt_Winloss_AB88_Details_Member'),
('Acc_Rpt_Winloss_AB88_Details_xpre'),
('Acc_Rpt_Winloss_AB88_xpre'),
('Acc_Rpt_Winloss_ALog'),
('Acc_Rpt_Winloss_ALog_BetList'),
('Acc_Rpt_Winloss_ALog_BetList_History'),
('Acc_Rpt_Winloss_ALog_BetList_History_xtest'),
('Acc_Rpt_Winloss_ALog_BetList_xtest'),
('Acc_Rpt_Winloss_ALog_Details'),
('Acc_Rpt_Winloss_Bezbet'),
('Acc_Rpt_Winloss_Bezbet_BetList'),
('Acc_Rpt_Winloss_Bezbet_BetList_History'),
('Acc_Rpt_Winloss_Bezbet_BetList_History_xtest'),
('Acc_Rpt_Winloss_Bezbet_BetList_xtest'),
('Acc_Rpt_Winloss_Bezbet_Details'),
('Acc_Rpt_Winloss_Dela'),
('Acc_Rpt_Winloss_Dela_BetList'),
('Acc_Rpt_Winloss_Dela_BetList_History'),
('Acc_Rpt_Winloss_Dela_BetList_History_xtest'),
('Acc_Rpt_Winloss_Dela_BetList_xtest'),
('Acc_Rpt_Winloss_Dela_Details'),
('Acc_Rpt_Winloss_M88'),
('Acc_Rpt_Winloss_M88_BetList'),
('Acc_Rpt_Winloss_M88_BetList_History'),
('Acc_Rpt_Winloss_M88_BetList_History_xtest'),
('Acc_Rpt_Winloss_M88_BetList_xpre'),
('Acc_Rpt_Winloss_M88_BetList_xtest'),
('Acc_Rpt_Winloss_M88_Details'),
('Acc_Rpt_Winloss_M88_Details_xpre'),
('Acc_Rpt_Winloss_M88_Details_xtest'),
('Acc_Rpt_Winloss_M88_xpre'),
('Acc_Rpt_Winloss_MayFair'),
('Acc_Rpt_Winloss_MayFair_BetList'),
('Acc_Rpt_Winloss_MayFair_BetList_History'),
('Acc_Rpt_Winloss_MayFair_BetList_History_xtest'),
('Acc_Rpt_Winloss_MayFair_BetList_xtest'),
('Acc_Rpt_Winloss_MayFair_Details'),
('Acc_Rpt_Winloss_Spondemo'),
('Acc_Rpt_Winloss_Spondemo_BetList'),
('Acc_Rpt_Winloss_Spondemo_BetList_History'),
('Acc_Rpt_Winloss_Spondemo_BetList_History_xtest'),
('Acc_Rpt_Winloss_Spondemo_BetList_xtest'),
('Acc_Rpt_Winloss_Spondemo_Details'),
('Acc_Rpt_Winloss_SunCity'),
('Acc_Rpt_Winloss_SunCity_BetList'),
('Acc_Rpt_Winloss_SunCity_BetList_History'),
('Acc_Rpt_Winloss_SunCity_BetList_History_xtest'),
('Acc_Rpt_Winloss_SunCity_BetList_xtest'),
('Acc_Rpt_Winloss_SunCity_Details'),
('Acc_Rpt_Winloss_TLC'),
('Acc_Rpt_Winloss_TLC_BetList'),
('Acc_Rpt_Winloss_TLC_BetList_History'),
('Acc_Rpt_Winloss_TLC_BetList_History_xtest'),
('Acc_Rpt_Winloss_TLC_BetList_xtest'),
('Acc_Rpt_Winloss_TLC_Details'),
('Acc_Rpt_Winloss_Zzun88'),
('Acc_Rpt_Winloss_Zzun88_BetList'),
('Acc_Rpt_Winloss_Zzun88_BetList_History'),
('Acc_Rpt_Winloss_Zzun88_BetList_History_xtest'),
('Acc_Rpt_Winloss_Zzun88_BetList_xtest'),
('Acc_Rpt_Winloss_Zzun88_Details'),
('Lbs_Rpt_Winloss_12Bet'),
('Lbs_Rpt_Winloss_12Bet_Details_Agent'),
('Lbs_Rpt_Winloss_12Bet_Details_Member'),
('Lbs_Rpt_Winloss_AB88'),
('Lbs_Rpt_Winloss_AB88_Details'),
('Lbs_Rpt_Winloss_ALog'),
('Lbs_Rpt_Winloss_ALog_Details'),
('Lbs_Rpt_Winloss_Dela'),
('Lbs_Rpt_Winloss_Dela_Details'),
('Lbs_Rpt_Winloss_M88'),
('Lbs_Rpt_Winloss_M88_Details'),
('Lbs_Rpt_Winloss_Spondemo'),
('Lbs_Rpt_Winloss_Spondemo_Details'),
('Lbs_Rpt_Winloss_TLC'),
('Lbs_Rpt_Winloss_TLC_Details'),
('Task_Exchange_HistoryIns'),
('Task_Exchange_HistoryIns_xtest'),
('Task_ExternalSettlement'),
('Task_ExternalSettlement_CleanUp'),
('Task_ExternalSettlement_thien'),
('Task_ExternalSettlement_Verification'),
('DBA_ReInit_bettrans_forecast_agent'),
('DBA_ReInit_bettrans_forecast_agent'),
('DBA_SMATO_MultipleSMADel'),
('DBA_SMATO_MultipleSMAUpd'),
('DBA_SMATO_SingleSMADel'),
('DBA_SMATO_SingleSMAUpd'),
('NAP_SMATurnoverGlobalSettingList'),
('Task_DownlineTurnOver_Setting_sum_job'),
('Acc_SMATurnover_IsNotifiedSel'),
('Acc_SMATurnover_IsNotifiedUpd'),
('Acc_SMATurnoverCheckTotalTurnover'),
('Acc_SMATurnoverListSel'),
('NAP_SMATurnover_IsNotifiedSel'),
('NAP_SMATurnover_IsNotifiedUpd'),
('NAP_SMATurnover_MonitorList'),
('NAP_SMATurnover_UsageList'),
('NAP_SMATurnoverListSel'),
('Task_GetDownlineTurnOver_Setting_Change'),
('Task_STDBY_SYNC_DownlineTurnOver'),
('bettrans_DownlineTurnOver_Setting'),
('sp_GetGlobalVariable'),
('sp_SetGlobalVariable'),
('displaymessage'),
('mdisplaymessage'),
('sp_MSdel_message'),
('sp_MSins_message'),
('sp_MSupd_message'),
('Age_Rpt_DailyWLFoobet'),
('SBQueue_receive_Patrick_bk'),
('Task_Delete_bettrans_running'),
('Task_ExternalSettlement_Loop')


SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'DROP PROC ' + ObjectName + '_delete'
	FROM #Tables_MarkDelete
	WHERE ID = @start
	
	PRINT 'In progress:' + @sql
	
	BEGIN TRY
		EXEC (@sql)
		PRINT 'Done: ' + @sql
	END TRY
	BEGIN CATCH
		PRINT 'Failed: OBJECT NOT EXISTS - ' + @sql 
	END CATCH

	SET @start = @start + 1
	
END

DROP TABLE #Tables_MarkDelete

GO

