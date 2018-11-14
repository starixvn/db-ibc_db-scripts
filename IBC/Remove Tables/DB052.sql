/*
	Created: 20181101@Percy
	DB: DB052
	Task: Remove unused tables
*/
use Bodb_Licensee
go 
exec sp_rename 'CurrencyUser_20180102_bk', 'DEL_CurrencyUser_20180102_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'CurrencyUser_20180102_bk2', 'DEL_CurrencyUser_20180102_bk2' 
go
use Bodb_Licensee
go 
exec sp_rename 'CurrencyUser_BKDel20171225', 'DEL_CurrencyUser_BKDel20171225' 
go
use Bodb_Licensee
go 
exec sp_rename 'CustSearch', 'DEL_CustSearch' 
go
use Bodb_Licensee
go 
exec sp_rename 'DBA_LicenseeNew', 'DEL_DBA_LicenseeNew' 
go
use Bodb_Licensee
go 
exec sp_rename 'DonTest02', 'DEL_DonTest02' 
go
use Bodb_Licensee
go 
exec sp_rename 'EventLogAction', 'DEL_EventLogAction' 
go
use Bodb_Licensee
go 
exec sp_rename 'IPCountry', 'DEL_IPCountry' 
go
use Bodb_Licensee
go 
exec sp_rename 'KPI_Branches', 'DEL_KPI_Branches' 
go
use Bodb_Licensee
go 
exec sp_rename 'KPI_BranchGroup', 'DEL_KPI_BranchGroup' 
go
use Bodb_Licensee
go 
exec sp_rename 'KPI_Groups', 'DEL_KPI_Groups' 
go
use Bodb_Licensee
go 
exec sp_rename 'KPI_Sections', 'DEL_KPI_Sections' 
go
use Bodb_Licensee
go 
exec sp_rename 'KPI_SectionStatistic', 'DEL_KPI_SectionStatistic' 
go
use Bodb_Licensee
go 
exec sp_rename 'KPI_StatisticConfig', 'DEL_KPI_StatisticConfig' 
go
use Bodb_Licensee
go 
exec sp_rename 'KPI_Statistics', 'DEL_KPI_Statistics' 
go
use Bodb_Licensee
go 
exec sp_rename 'LA_InvoiceHeader_20170926_Migrate', 'DEL_LA_InvoiceHeader_20170926_Migrate' 
go
use Bodb_Licensee
go 
exec sp_rename 'LA_InvoiceHeader_20171116_bk_Test', 'DEL_LA_InvoiceHeader_20171116_bk_Test' 
go
use Bodb_Licensee
go 
exec sp_rename 'LA_InvoiceStatement_20170926_Migrate', 'DEL_LA_InvoiceStatement_20170926_Migrate' 
go
use Bodb_Licensee
go 
exec sp_rename 'LA_SettingGroupAssignment_20180522_bk', 'DEL_LA_SettingGroupAssignment_20180522_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'LA_SettingGroupDetail_20180522_bk', 'DEL_LA_SettingGroupDetail_20180522_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeBAPayment', 'DEL_LicenseeBAPayment' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeCustinfo', 'DEL_LicenseeCustinfo' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeFunctions_20171212_bk', 'DEL_LicenseeFunctions_20171212_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeFunctions_bk20180228', 'DEL_LicenseeFunctions_bk20180228' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeFunctions_BoDog_Racing', 'DEL_LicenseeFunctions_BoDog_Racing' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeProduct3rd_BoDog_Racing', 'DEL_LicenseeProduct3rd_BoDog_Racing' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeSourcedSetting_20180409_bk_Opal88', 'DEL_LicenseeSourcedSetting_20180409_bk_Opal88' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeSourcedSetting_Danielbk_20180709', 'DEL_LicenseeSourcedSetting_Danielbk_20180709' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUser_20180102_bk', 'DEL_LicenseeUser_20180102_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUser_20180102_bk2', 'DEL_LicenseeUser_20180102_bk2' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUser_BKDel20171225', 'DEL_LicenseeUser_BKDel20171225' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUserFunctions_20171206_bk', 'DEL_LicenseeUserFunctions_20171206_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUserFunctions_20171212_bk', 'DEL_LicenseeUserFunctions_20171212_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUserFunctions_20180102_bk', 'DEL_LicenseeUserFunctions_20180102_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUserFunctions_20180102_bk2', 'DEL_LicenseeUserFunctions_20180102_bk2' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUserFunctions_20180201_bk', 'DEL_LicenseeUserFunctions_20180201_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUserFunctions_bk20180228', 'DEL_LicenseeUserFunctions_bk20180228' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUserFunctions_BKDel20171225', 'DEL_LicenseeUserFunctions_BKDel20171225' 
go
use Bodb_Licensee
go 
exec sp_rename 'LicenseeUserFunctions_BoDog_Racing', 'DEL_LicenseeUserFunctions_BoDog_Racing' 
go
use Bodb_Licensee
go 
exec sp_rename 'lukas_test_traceLogshipping', 'DEL_lukas_test_traceLogshipping' 
go
use Bodb_Licensee
go 
exec sp_rename 'MailKPI_ReportPermission', 'DEL_MailKPI_ReportPermission' 
go
use Bodb_Licensee
go 
exec sp_rename 'MailKPI_Reports', 'DEL_MailKPI_Reports' 
go
use Bodb_Licensee
go 
exec sp_rename 'MailKPI_ReportSections', 'DEL_MailKPI_ReportSections' 
go
use Bodb_Licensee
go 
exec sp_rename 'MailKPI_Sections', 'DEL_MailKPI_Sections' 
go
use Bodb_Licensee
go 
exec sp_rename 'MailKPI_SendMailUsers', 'DEL_MailKPI_SendMailUsers' 
go
use Bodb_Licensee
go 
exec sp_rename 'MailKPI_TaskLogs', 'DEL_MailKPI_TaskLogs' 
go
use Bodb_Licensee
go 
exec sp_rename 'MailKPI_Tasks', 'DEL_MailKPI_Tasks' 
go
use Bodb_Licensee
go 
exec sp_rename 'MailKPI_Users', 'DEL_MailKPI_Users' 
go
use Bodb_Licensee
go 
exec sp_rename 'OAS_ChargeInfo_20180306_bk_91255', 'DEL_OAS_ChargeInfo_20180306_bk_91255' 
go
use Bodb_Licensee
go 
exec sp_rename 'rptLicWinloss2_201601_21_22', 'DEL_rptLicWinloss2_201601_21_22' 
go
use Bodb_Licensee
go 
exec sp_rename 'rptLicWinloss2_staging', 'DEL_rptLicWinloss2_staging' 
go
use Bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTask', 'DEL_Service_ScheduledTask' 
go
use Bodb_Licensee
go 
exec sp_rename 'Service_ScheduledTaskLog', 'DEL_Service_ScheduledTaskLog' 
go
use Bodb_Licensee
go 
exec sp_rename 'SpNames', 'DEL_SpNames' 
go
use Bodb_Licensee
go 
exec sp_rename 'Tmp_Update_UserName2', 'DEL_Tmp_Update_UserName2' 
go
use Bodb_Licensee
go 
exec sp_rename 'UserLog_Login', 'DEL_UserLog_Login' 
go
use Bodb_Licensee
go 
exec sp_rename 'Users_20180102_bk', 'DEL_Users_20180102_bk' 
go
use Bodb_Licensee
go 
exec sp_rename 'Users_BKDel20171225', 'DEL_Users_BKDel20171225' 
go
use Bodb_Licensee
go 
exec sp_rename 'UserStatistic', 'DEL_UserStatistic' 
go
use Bodb_Licensee
go 
exec sp_rename 'UserLog_LicenseeBAConfig', 'DEL_UserLog_LicenseeBAConfig' 
go
use Bodb_Licensee
go 
exec sp_rename 'UserLog_LicenseeCurrencyBAGroup', 'DEL_UserLog_LicenseeCurrencyBAGroup' 
go
use Bodb_Licensee
go 
exec sp_rename 'UserLog_LicenseeSpecialCust', 'DEL_UserLog_LicenseeSpecialCust' 
go
use Bodb_LicenseeReport
go 
exec sp_rename 'tbl_Customer_Account_old', 'DEL_tbl_Customer_Account_old' 
go
use Bodb_LicenseeReport
go 
exec sp_rename 'tbl_Customer_Account', 'DEL_tbl_Customer_Account' 
go
use Bodb_LicenseeReport
go 
use Bodb_LicenseeReport
go 
exec sp_rename 'Lrf_Rpt_LicWinloss_Log', 'DEL_Lrf_Rpt_LicWinloss_Log' 
go
use bodb_PlaytechCS
go 
exec sp_rename 'bettrans', 'DEL_bettrans' 
go
use bodb_PlaytechCS
go
use bodb_PlaytechCS
go 
exec sp_rename 'LicenseeVersionKey', 'DEL_LicenseeVersionKey' 
go
use Bodb02
go 
exec sp_rename 'Acc_ExternalSettlement', 'DEL_Acc_ExternalSettlement' 
go
use Bodb02
go 
exec sp_rename 'Alogtickets_tmp_M2', 'DEL_Alogtickets_tmp_M2' 
go
use Bodb02
go 
exec sp_rename 'Alogtickets_tmp_M3', 'DEL_Alogtickets_tmp_M3' 
go
use Bodb02
go 
exec sp_rename 'Alogtickets_tmp_M4', 'DEL_Alogtickets_tmp_M4' 
go
use Bodb02
go 
exec sp_rename 'Alogtickets_tmp_M5', 'DEL_Alogtickets_tmp_M5' 
go
use Bodb02
go 
exec sp_rename 'Alogtickets_tmp_M6', 'DEL_Alogtickets_tmp_M6' 
go
use Bodb02
go 
exec sp_rename 'Alogtickets_tmp_M7', 'DEL_Alogtickets_tmp_M7' 
go
use Bodb02
go 
exec sp_rename 'Alogtickets_tmp_M8', 'DEL_Alogtickets_tmp_M8' 
go
use Bodb02
go 
exec sp_rename 'bettrans_forecast_agent', 'DEL_bettrans_forecast_agent' 
go
use Bodb02
go 
exec sp_rename 'bettrans_lrf_betRunning', 'DEL_bettrans_lrf_betRunning' 
go
use Bodb02
go 
exec sp_rename 'bettrans_lrf_betRunning_Joe', 'DEL_bettrans_lrf_betRunning_Joe' 
go
use Bodb02
go 
exec sp_rename 'bettrans_running', 'DEL_bettrans_running' 
go
use Bodb02
go 
exec sp_rename 'bettrans_running_toDelete', 'DEL_bettrans_running_toDelete' 
go
use Bodb02
go 
exec sp_rename 'bettrans_tempV', 'DEL_bettrans_tempV' 
go
use Bodb02
go 
exec sp_rename 'bettrans_trigger_agent', 'DEL_bettrans_trigger_agent' 
go
use Bodb02
go 
exec sp_rename 'custbankinfo', 'DEL_custbankinfo' 
go
use Bodb02
go 
exec sp_rename 'custsetting_ksm', 'DEL_custsetting_ksm' 
go
use Bodb02
go 
exec sp_rename 'DBA_Custom_Logs', 'DEL_DBA_Custom_Logs' 
go
use Bodb02
go 
exec sp_rename 'Exchange_History', 'DEL_Exchange_History' 
go
use Bodb02
go 
exec sp_rename 'Exchange_History_Old', 'DEL_Exchange_History_Old' 
go
use Bodb02
go 
exec sp_rename 'ExchangeDaily', 'DEL_ExchangeDaily' 
go
use Bodb02
go 
exec sp_rename 'invalid_cs', 'DEL_invalid_cs' 
go
use Bodb02
go 
exec sp_rename 'jwait', 'DEL_jwait' 
go
use Bodb02
go 
exec sp_rename 'LA_AdHocReport_Francis', 'DEL_LA_AdHocReport_Francis' 
go
use Bodb02
go 
exec sp_rename 'LCS_custgametype', 'DEL_LCS_custgametype' 
go
use Bodb02
go 
exec sp_rename 'LCS_StakeLevel', 'DEL_LCS_StakeLevel' 
go
use Bodb02
go 
exec sp_rename 'MovebetTrans_lastbatch', 'DEL_MovebetTrans_lastbatch' 
go
use Bodb02
go 
exec sp_rename 'RefCombination_backup', 'DEL_RefCombination_backup' 
go
use Bodb02
go 
exec sp_rename 'RefCombinationSet_backup', 'DEL_RefCombinationSet_backup' 
go
use Bodb02
go 
exec sp_rename 'SS', 'DEL_SS' 
go
use Bodb02
go 
exec sp_rename 'SystemSettings2', 'DEL_SystemSettings2' 
go
use Bodb02
go 
exec sp_rename 'tmpCustomer', 'DEL_tmpCustomer' 
go
use Bodb02
go 
exec sp_rename 'tmpDepSuperID', 'DEL_tmpDepSuperID' 
go
use Bodb02
go 
exec sp_rename 'vcheck', 'DEL_vcheck' 
go
use Bodb02
go 
exec sp_rename 'WinLimit_GlobalSetting', 'DEL_WinLimit_GlobalSetting' 
go