/*
	Created: 20181225@Percy
	DB: DB052
	Task: Rename un-used SPs
	Reference: https://docs.google.com/spreadsheets/d/1YGYSeWIKXnAg2EM60kxEpOMhWElfA2LIhwrb4j_mJNM/edit#gid=523938262
*/
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_GroupCurrency_ViewLog_xtest', 'DEL_Acc_BA_GroupCurrency_ViewLog_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_GroupCurrencyUpd_xpre', 'DEL_Acc_BA_GroupCurrencyUpd_xpre' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_GroupCurrencyUpd_xtest', 'DEL_Acc_BA_GroupCurrencyUpd_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_LicConfig_ViewLog_xtest', 'DEL_Acc_BA_LicConfig_ViewLog_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_LicConfigUpd_UAT4', 'DEL_Acc_BA_LicConfigUpd_UAT4' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_LicConfigUpd_xpre', 'DEL_Acc_BA_LicConfigUpd_xpre' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_LicConfigUpd_xtest', 'DEL_Acc_BA_LicConfigUpd_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_SpecialCust_ViewLog_xtest', 'DEL_Acc_BA_SpecialCust_ViewLog_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_SpecialCustAdd_xpre', 'DEL_Acc_BA_SpecialCustAdd_xpre' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_SpecialCustAdd_xtest', 'DEL_Acc_BA_SpecialCustAdd_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_SpecialCustDel_xpre', 'DEL_Acc_BA_SpecialCustDel_xpre' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_SpecialCustDel_xtest', 'DEL_Acc_BA_SpecialCustDel_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_SpecialCustSel_UAT4', 'DEL_Acc_BA_SpecialCustSel_UAT4' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_SpecialCustSel_xtest', 'DEL_Acc_BA_SpecialCustSel_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_SpecialCustUpd_xpre', 'DEL_Acc_BA_SpecialCustUpd_xpre' 
go
use bodb_Licensee
go 
exec sp_rename 'Acc_BA_SpecialCustUpd_xtest', 'DEL_Acc_BA_SpecialCustUpd_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'DBA_LicenseeBAConfig_Ins_xtest', 'DEL_DBA_LicenseeBAConfig_Ins_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'DBA_LicenseeCustomerDel_UAT4', 'DEL_DBA_LicenseeCustomerDel_UAT4' 
go
use bodb_Licensee
go 
exec sp_rename 'DBA_Lrf_EnablePlayerComm_UAT4', 'DEL_DBA_Lrf_EnablePlayerComm_UAT4' 
go
use bodb_Licensee
go 
exec sp_rename 'GEN_RptKPI_MTD', 'DEL_GEN_RptKPI_MTD' 
go
use bodb_Licensee
go 
exec sp_rename 'GEN_RptKPI_MTD_FDL', 'DEL_GEN_RptKPI_MTD_FDL' 
go
use bodb_Licensee
go 
exec sp_rename 'GEN_RptKPI_MTD_Old', 'DEL_GEN_RptKPI_MTD_Old' 
go
use bodb_Licensee
go 
exec sp_rename 'GEN_RptKPI_MTD_PeakConcurrentBettors', 'DEL_GEN_RptKPI_MTD_PeakConcurrentBettors' 
go
use bodb_Licensee
go 
exec sp_rename 'GEN_RptKPI_MTD_xtest', 'DEL_GEN_RptKPI_MTD_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetAllBranches', 'DEL_KPI_GetAllBranches' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetAllBranches_xtest', 'DEL_KPI_GetAllBranches_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetAllGroups_xtest', 'DEL_KPI_GetAllGroups_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetAllSections', 'DEL_KPI_GetAllSections' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetAllStatistics', 'DEL_KPI_GetAllStatistics' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetReportData_BA_UAT2', 'DEL_KPI_GetReportData_BA_UAT2' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetReportData_BA_xtest', 'DEL_KPI_GetReportData_BA_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetReportData_UAT2', 'DEL_KPI_GetReportData_UAT2' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetReportData_UAT2', 'DEL_KPI_GetReportData_UAT2' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetReportData_xtest', 'DEL_KPI_GetReportData_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetReportData_xtest', 'DEL_KPI_GetReportData_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetStatisticsConfig', 'DEL_KPI_GetStatisticsConfig' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetStatisticsConfig_xtest', 'DEL_KPI_GetStatisticsConfig_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetTopThreeSports_UAT2', 'DEL_KPI_GetTopThreeSports_UAT2' 
go
use bodb_Licensee
go 
exec sp_rename 'KPI_GetTopThreeSports_xtest', 'DEL_KPI_GetTopThreeSports_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_CustomerUpdSpecialLevel', 'DEL_Lrf_CustomerUpdSpecialLevel' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_CustomerUpdSpecialLevel_xtest', 'DEL_Lrf_CustomerUpdSpecialLevel_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_2', 'DEL_LRF_GET_Licensees_KPIs_2' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_2012', 'DEL_LRF_GET_Licensees_KPIs_2012' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_BA_2', 'DEL_LRF_GET_Licensees_KPIs_BA_2' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_LC', 'DEL_LRF_GET_Licensees_KPIs_LC' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_LC_2012', 'DEL_LRF_GET_Licensees_KPIs_LC_2012' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_LC_xtest', 'DEL_LRF_GET_Licensees_KPIs_LC_xtest' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_NG', 'DEL_LRF_GET_Licensees_KPIs_NG' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_NG_2012', 'DEL_LRF_GET_Licensees_KPIs_NG_2012' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_VS', 'DEL_LRF_GET_Licensees_KPIs_VS' 
go
use bodb_Licensee
go 
exec sp_rename 'LRF_GET_Licensees_KPIs_VS_2012', 'DEL_LRF_GET_Licensees_KPIs_VS_2012' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_GetSystemNameStatistic', 'DEL_Lrf_GetSystemNameStatistic' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_LicenseeCustCommSel', 'DEL_Lrf_LicenseeCustCommSel' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_LicenseeCustCommSel_UAT1', 'DEL_Lrf_LicenseeCustCommSel_UAT1' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrt_BrowserStatistic', 'DEL_Lrt_BrowserStatistic' 
go
use bodb_Licensee
go 
exec sp_rename 'MailKPI_AddUser', 'DEL_MailKPI_AddUser' 
go
use bodb_Licensee
go 
exec sp_rename 'MailKPI_GetReportSectionByUserID', 'DEL_MailKPI_GetReportSectionByUserID' 
go
use bodb_Licensee
go 
exec sp_rename 'MailKPI_GetTaskLists', 'DEL_MailKPI_GetTaskLists' 
go
use bodb_Licensee
go 
exec sp_rename 'MailKPI_GetTaskLogByLogID', 'DEL_MailKPI_GetTaskLogByLogID' 
go
use bodb_Licensee
go 
exec sp_rename 'MailKPI_GetTaskLogs', 'DEL_MailKPI_GetTaskLogs' 
go
use bodb_Licensee
go 
exec sp_rename 'MailKPI_GetUserByTaskID', 'DEL_MailKPI_GetUserByTaskID' 
go
use bodb_Licensee
go 
exec sp_rename 'MailKPI_GetUserByUserID', 'DEL_MailKPI_GetUserByUserID' 
go
use bodb_Licensee
go 
exec sp_rename 'MailKPI_TaskLogs_Insert', 'DEL_MailKPI_TaskLogs_Insert' 
go
use bodb_Licensee
go 
exec sp_rename 'MailKPI_TaskLogs_Upd', 'DEL_MailKPI_TaskLogs_Upd' 
go
use bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTaskDateUpd', 'DEL_Service_ScheduledTaskDateUpd' 
go
use bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTaskListSel', 'DEL_Service_ScheduledTaskListSel' 
go
use bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTaskLogCountSel', 'DEL_Service_ScheduledTaskLogCountSel' 
go
use bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTaskLogDel', 'DEL_Service_ScheduledTaskLogDel' 
go
use bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTaskLogIns', 'DEL_Service_ScheduledTaskLogIns' 
go
use bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTaskLogListSel', 'DEL_Service_ScheduledTaskLogListSel' 
go
use bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTaskLogSel', 'DEL_Service_ScheduledTaskLogSel' 
go
use bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTaskLogUpd', 'DEL_Service_ScheduledTaskLogUpd' 
go
use bodb_Licensee
go 
exec sp_rename 'SpNamesClearSuffix', 'DEL_SpNamesClearSuffix' 
go
use bodb_Licensee
go 
exec sp_rename 'SPNamesDelete', 'DEL_SPNamesDelete' 
go
use bodb_Licensee
go 
exec sp_rename 'SpNamesGetAll', 'DEL_SpNamesGetAll' 
go
use bodb_Licensee
go 
exec sp_rename 'SpNamesGetBySpKey', 'DEL_SpNamesGetBySpKey' 
go
use bodb_Licensee
go 
exec sp_rename 'SpNamesSearch', 'DEL_SpNamesSearch' 
go
use bodb_Licensee
go 
exec sp_rename 'SpNamesUpdateSuffix', 'DEL_SpNamesUpdateSuffix' 
go
use bodb_Licensee
go 
exec sp_rename 'Task_Licensee_BALimitWarning', 'DEL_Task_Licensee_BALimitWarning' 
go
use bodb_Licensee
go 
exec sp_rename 'view_kpi_statistics', 'DEL_view_kpi_statistics' 
go
use bodb_LicenseeReport
go 
exec sp_rename 'GEN_Customer_Account2', 'DEL_GEN_Customer_Account2' 
go
use bodb_LicenseeReport
go 
exec sp_rename 'GEN_rptKPI_Transfer', 'DEL_GEN_rptKPI_Transfer' 
go
use bodb_PlaytechCS
go 
exec sp_rename 'Task_PTCS_SelLicenseeList', 'DEL_Task_PTCS_SelLicenseeList' 
go
use bodb02
go 
exec sp_rename 'Task_RptLicIPBetting_UpdateCountry', 'DEL_Task_RptLicIPBetting_UpdateCountry' 
go
use bodb02
go 
exec sp_rename 'Task_ExternalSettlement_CleanUp', 'DEL_Task_ExternalSettlement_CleanUp' 
go
use bodb02
go 
exec sp_rename 'Task_ExternalSettlement_delete', 'DEL_Task_ExternalSettlement_delete' 
go
use bodb02
go 
exec sp_rename 'Task_ExternalSettlement_Verification', 'DEL_Task_ExternalSettlement_Verification' 
go
use bodb02
go 
exec sp_rename 'Acc_CustSetting3rd_19', 'DEL_Acc_CustSetting3rd_19' 
go
use bodb02
go 
exec sp_rename 'Acc_MoveBet_ExchangeDailySel', 'DEL_Acc_MoveBet_ExchangeDailySel' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet', 'DEL_Acc_Rpt_Winloss_12Bet' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_Details_Agent', 'DEL_Acc_Rpt_Winloss_12Bet_Details_Agent' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_Details_Agent_xpre', 'DEL_Acc_Rpt_Winloss_12Bet_Details_Agent_xpre' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_Details_Member', 'DEL_Acc_Rpt_Winloss_12Bet_Details_Member' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_Details_Member_xpre', 'DEL_Acc_Rpt_Winloss_12Bet_Details_Member_xpre' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_xpre', 'DEL_Acc_Rpt_Winloss_12Bet_xpre' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88', 'DEL_Acc_Rpt_Winloss_AB88' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_Details', 'DEL_Acc_Rpt_Winloss_AB88_Details' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_Details_Agent', 'DEL_Acc_Rpt_Winloss_AB88_Details_Agent' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_Details_Member', 'DEL_Acc_Rpt_Winloss_AB88_Details_Member' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_Details_xpre', 'DEL_Acc_Rpt_Winloss_AB88_Details_xpre' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_xpre', 'DEL_Acc_Rpt_Winloss_AB88_xpre' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_ALog', 'DEL_Acc_Rpt_Winloss_ALog' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_ALog_Details', 'DEL_Acc_Rpt_Winloss_ALog_Details' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Bezbet', 'DEL_Acc_Rpt_Winloss_Bezbet' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Bezbet_Details', 'DEL_Acc_Rpt_Winloss_Bezbet_Details' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Dela', 'DEL_Acc_Rpt_Winloss_Dela' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Dela_Details', 'DEL_Acc_Rpt_Winloss_Dela_Details' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88', 'DEL_Acc_Rpt_Winloss_M88' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88_Details', 'DEL_Acc_Rpt_Winloss_M88_Details' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88_Details_xpre', 'DEL_Acc_Rpt_Winloss_M88_Details_xpre' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88_Details_xtest', 'DEL_Acc_Rpt_Winloss_M88_Details_xtest' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88_xpre', 'DEL_Acc_Rpt_Winloss_M88_xpre' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_MayFair', 'DEL_Acc_Rpt_Winloss_MayFair' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_MayFair_Details', 'DEL_Acc_Rpt_Winloss_MayFair_Details' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Spondemo', 'DEL_Acc_Rpt_Winloss_Spondemo' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Spondemo_Details', 'DEL_Acc_Rpt_Winloss_Spondemo_Details' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_SunCity', 'DEL_Acc_Rpt_Winloss_SunCity' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_SunCity_Details', 'DEL_Acc_Rpt_Winloss_SunCity_Details' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_TLC', 'DEL_Acc_Rpt_Winloss_TLC' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_TLC_Details', 'DEL_Acc_Rpt_Winloss_TLC_Details' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Zzun88', 'DEL_Acc_Rpt_Winloss_Zzun88' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Zzun88_Details', 'DEL_Acc_Rpt_Winloss_Zzun88_Details' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_12Bet', 'DEL_Lbs_Rpt_Winloss_12Bet' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_12Bet_Details_Agent', 'DEL_Lbs_Rpt_Winloss_12Bet_Details_Agent' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_12Bet_Details_Member', 'DEL_Lbs_Rpt_Winloss_12Bet_Details_Member' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_AB88', 'DEL_Lbs_Rpt_Winloss_AB88' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_AB88_Details', 'DEL_Lbs_Rpt_Winloss_AB88_Details' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_ALog', 'DEL_Lbs_Rpt_Winloss_ALog' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_ALog_Details', 'DEL_Lbs_Rpt_Winloss_ALog_Details' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_Dela', 'DEL_Lbs_Rpt_Winloss_Dela' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_Dela_Details', 'DEL_Lbs_Rpt_Winloss_Dela_Details' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_M88', 'DEL_Lbs_Rpt_Winloss_M88' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_M88_Details', 'DEL_Lbs_Rpt_Winloss_M88_Details' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_Spondemo', 'DEL_Lbs_Rpt_Winloss_Spondemo' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_Spondemo_Details', 'DEL_Lbs_Rpt_Winloss_Spondemo_Details' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_TLC', 'DEL_Lbs_Rpt_Winloss_TLC' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_TLC_Details', 'DEL_Lbs_Rpt_Winloss_TLC_Details' 
go
use bodb02
go 
exec sp_rename 'Lbs_UserLogin', 'DEL_Lbs_UserLogin' 
go
use bodb02
go 
exec sp_rename 'Lrf_BetList_SelRunningByDate_Mem_DonTest02', 'DEL_Lrf_BetList_SelRunningByDate_Mem_DonTest02' 
go
use bodb02
go 
exec sp_rename 'Task_Exchange_HistoryIns', 'DEL_Task_Exchange_HistoryIns' 
go
use bodb02
go 
exec sp_rename 'Task_Exchange_HistoryIns_xtest', 'DEL_Task_Exchange_HistoryIns_xtest' 
go
use bodb02
go 
exec sp_rename 'WriteLog_UserLog_Login', 'DEL_WriteLog_UserLog_Login' 
go