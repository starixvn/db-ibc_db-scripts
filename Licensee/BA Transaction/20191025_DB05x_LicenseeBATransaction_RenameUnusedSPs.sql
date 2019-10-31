/*
	Created: 20191025@Percy
	DB: DB052, DB053
	Task: LicenseeBATransaction - Rename unused SPs
*/

--- bodb_Licensee
/*
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Task_DailyRptLicWinloss'

declare @sql varchar(max) = ''
select  @sql = @sql + 'sp_rename ''' + name + ''', ''DEL_' + name + '''' + char(10) + 'go' + char(10)
from (
	select distinct o.name
	from @sp sp
		inner join bodb_Licensee.sys.objects o
			on o.name = sp.spname
				or o.name = sp.spname + '_xtest'
				or o.name = sp.spname + '_xpre'
				or o.name = sp.spname + '_UAT1'
				or o.name = sp.spname + '_UAT2'
				or o.name = sp.spname + '_UAT3'
				or o.name = sp.spname + '_UAT4'
) as t

select cast(@sql as xml)
go



--- bodb_LicenseeReport
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Task_CustomerActive_GenDataFromBettrans' union all
select 'Task_CustomerActive_GenDataFromBettrans14' union all
select 'Task_rptCustomerTurnOver_Bettrans_20180627_bk'

declare @sql varchar(max) = ''
select  @sql = @sql + 'sp_rename ''' + name + ''', ''DEL_' + name + '''' + char(10) + 'go' + char(10)
from (
	select distinct o.name
	from @sp sp
		inner join bodb_LicenseeReport.sys.objects o
			on o.name = sp.spname
				or o.name = sp.spname + '_xtest'
				or o.name = sp.spname + '_xpre'
				or o.name = sp.spname + '_UAT1'
				or o.name = sp.spname + '_UAT2'
				or o.name = sp.spname + '_UAT3'
				or o.name = sp.spname + '_UAT4'
) as t

select cast(@sql as xml)
go


--- bodb02
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Acc_MoveBet_BettransSel' union all
select 'Lrf_Rpt_LiveReportSummary_xpre1' union all
select 'Lrf_Rpt_LiveReportSummaryDetail_20141216' union all
select 'Lrf_Rpt_MatchWinLoss_support' union all
select 'Lrf_Rpt_Outstanding' union all
select 'Lrf_Rpt_WinlossByProduct_DonTest' union all
select 'Lrf_Rpt_WinlossByProduct_DanielTest' union all
select 'SYNC_LicenseeBATransaction_Active_FromDB054' union all
select 'SYNC_LicenseeBATransaction_BK_FromDB054' union all
select 'Task_DailyRptLicWinloss2_Bettrans_Dontest' union all
select 'Task_DailyRptLicWinloss2_FrancisTest' union all
select 'Task_DailyRptLicWinloss3' union all
select 'Lrf_Rpt_MatchWinLossDetail_support' union all
select 'DEL_Lrf_Rpt_MobileWinlossDetail_Ag' union all
select 'Lrf_Rpt_MobileWinloss_dontest' union all
select 'Task_DailyRptLicWinloss2_archive' union all
select 'Task_DailyRptLicWinloss' union all
select 'Lrf_Rpt_MobileWinloss_20141215' union all
select 'Lrf_Rpt_MatchWinLoss_ExportExcel' union all
select 'Lrf_Rpt_WinlossByProduct_20141215' union all
select 'Lrf_Rpt_WinlossByProductDetail_20141215' union all
select 'OA_Rpt_SummaryCurrencyWinloss' union all
select 'Lrf_Rpt_LicWinlossDetail_20141215' union all
select 'OA_Rpt_LicenseeCurrencyWinloss' union all
select 'Lrf_Rpt_LiveReportSummary_20141215' union all
select 'Task_DOT_dep_DailySummary_Bettrans14' union all
select 'Task_DOT_dep_DailySummary_Bettrans' union all
select 'Task_BATransaction_Check' union all
select 'Lrf_Rpt_LiveReportSummaryDetail_dontest' union all
select 'DEL_Acc_Rpt_LicWinlossDetail_MAg2' union all
select 'DEL_Lrf_BetList_MobileReport_SelWinloss_Mem'

declare @sql varchar(max) = ''
select  @sql = @sql + 'sp_rename ''' + name + ''', ''DEL_' + name + '''' + char(10) + 'go' + char(10)
from (
	select distinct o.name
	from @sp sp
		inner join bodb02.sys.objects o
			on o.name = sp.spname
				or o.name = sp.spname + '_xtest'
				or o.name = sp.spname + '_xpre'
				or o.name = sp.spname + '_UAT1'
				or o.name = sp.spname + '_UAT2'
				or o.name = sp.spname + '_UAT3'
				or o.name = sp.spname + '_UAT4'
) as t

select cast(@sql as xml)
go

*/

--- DB052
use bodb_Licensee
go
sp_rename 'Task_DailyRptLicWinloss', 'DEL_Task_DailyRptLicWinloss'
go


use bodb_LicenseeReport
go
sp_rename 'Task_CustomerActive_GenDataFromBettrans', 'DEL_Task_CustomerActive_GenDataFromBettrans'
go
sp_rename 'Task_CustomerActive_GenDataFromBettrans14', 'DEL_Task_CustomerActive_GenDataFromBettrans14'
go
sp_rename 'Task_rptCustomerTurnOver_Bettrans_20180627_bk', 'DEL_Task_rptCustomerTurnOver_Bettrans_20180627_bk'
go


use bodb02
go
sp_rename 'Acc_MoveBet_BettransSel', 'DEL_Acc_MoveBet_BettransSel'
go
sp_rename 'DEL_Acc_Rpt_LicWinlossDetail_MAg2', 'DEL_DEL_Acc_Rpt_LicWinlossDetail_MAg2'
go
sp_rename 'DEL_Acc_Rpt_LicWinlossDetail_MAg2_xpre', 'DEL_DEL_Acc_Rpt_LicWinlossDetail_MAg2_xpre'
go
sp_rename 'DEL_Acc_Rpt_LicWinlossDetail_MAg2_xtest', 'DEL_DEL_Acc_Rpt_LicWinlossDetail_MAg2_xtest'
go
sp_rename 'DEL_Lrf_Rpt_MobileWinlossDetail_Ag', 'DEL_DEL_Lrf_Rpt_MobileWinlossDetail_Ag'
go
sp_rename 'Lrf_Rpt_LicWinlossDetail_20141215', 'DEL_Lrf_Rpt_LicWinlossDetail_20141215'
go
sp_rename 'Lrf_Rpt_LiveReportSummary_20141215', 'DEL_Lrf_Rpt_LiveReportSummary_20141215'
go
sp_rename 'Lrf_Rpt_LiveReportSummary_xpre1', 'DEL_Lrf_Rpt_LiveReportSummary_xpre1'
go
sp_rename 'Lrf_Rpt_LiveReportSummaryDetail_20141216', 'DEL_Lrf_Rpt_LiveReportSummaryDetail_20141216'
go
sp_rename 'Lrf_Rpt_LiveReportSummaryDetail_dontest', 'DEL_Lrf_Rpt_LiveReportSummaryDetail_dontest'
go
sp_rename 'Lrf_Rpt_MatchWinLoss_ExportExcel', 'DEL_Lrf_Rpt_MatchWinLoss_ExportExcel'
go
sp_rename 'Lrf_Rpt_MatchWinLoss_ExportExcel_UAT3', 'DEL_Lrf_Rpt_MatchWinLoss_ExportExcel_UAT3'
go
sp_rename 'Lrf_Rpt_MatchWinloss_ExportExcel_UAT4', 'DEL_Lrf_Rpt_MatchWinloss_ExportExcel_UAT4'
go
sp_rename 'Lrf_Rpt_MatchWinLoss_ExportExcel_xpre', 'DEL_Lrf_Rpt_MatchWinLoss_ExportExcel_xpre'
go
sp_rename 'Lrf_Rpt_MatchWinLoss_ExportExcel_xtest', 'DEL_Lrf_Rpt_MatchWinLoss_ExportExcel_xtest'
go
sp_rename 'Lrf_Rpt_MatchWinLoss_support', 'DEL_Lrf_Rpt_MatchWinLoss_support'
go
sp_rename 'Lrf_Rpt_MatchWinLossDetail_support', 'DEL_Lrf_Rpt_MatchWinLossDetail_support'
go
sp_rename 'Lrf_Rpt_MobileWinloss_20141215', 'DEL_Lrf_Rpt_MobileWinloss_20141215'
go
sp_rename 'Lrf_Rpt_MobileWinloss_dontest', 'DEL_Lrf_Rpt_MobileWinloss_dontest'
go
sp_rename 'Lrf_Rpt_Outstanding', 'DEL_Lrf_Rpt_Outstanding'
go
sp_rename 'Lrf_Rpt_Outstanding_UAT1', 'DEL_Lrf_Rpt_Outstanding_UAT1'
go
sp_rename 'Lrf_Rpt_Outstanding_UAT2', 'DEL_Lrf_Rpt_Outstanding_UAT2'
go
sp_rename 'Lrf_Rpt_Outstanding_UAT3', 'DEL_Lrf_Rpt_Outstanding_UAT3'
go
sp_rename 'Lrf_Rpt_Outstanding_UAT4', 'DEL_Lrf_Rpt_Outstanding_UAT4'
go
sp_rename 'Lrf_Rpt_Outstanding_xpre', 'DEL_Lrf_Rpt_Outstanding_xpre'
go
sp_rename 'Lrf_Rpt_Outstanding_xtest', 'DEL_Lrf_Rpt_Outstanding_xtest'
go
sp_rename 'Lrf_Rpt_WinlossByProduct_20141215', 'DEL_Lrf_Rpt_WinlossByProduct_20141215'
go
sp_rename 'Lrf_Rpt_WinlossByProduct_DanielTest', 'DEL_Lrf_Rpt_WinlossByProduct_DanielTest'
go
sp_rename 'Lrf_Rpt_WinlossByProduct_DonTest', 'DEL_Lrf_Rpt_WinlossByProduct_DonTest'
go
sp_rename 'Lrf_Rpt_WinlossByProductDetail_20141215', 'DEL_Lrf_Rpt_WinlossByProductDetail_20141215'
go
sp_rename 'OA_Rpt_LicenseeCurrencyWinloss', 'DEL_OA_Rpt_LicenseeCurrencyWinloss'
go
sp_rename 'OA_Rpt_LicenseeCurrencyWinloss_UAT1', 'DEL_OA_Rpt_LicenseeCurrencyWinloss_UAT1'
go
sp_rename 'OA_Rpt_LicenseeCurrencyWinloss_UAT4', 'DEL_OA_Rpt_LicenseeCurrencyWinloss_UAT4'
go
sp_rename 'OA_Rpt_LicenseeCurrencyWinloss_xtest', 'DEL_OA_Rpt_LicenseeCurrencyWinloss_xtest'
go
sp_rename 'OA_Rpt_SummaryCurrencyWinloss', 'DEL_OA_Rpt_SummaryCurrencyWinloss'
go
sp_rename 'OA_Rpt_SummaryCurrencyWinloss_xtest', 'DEL_OA_Rpt_SummaryCurrencyWinloss_xtest'
go
sp_rename 'SYNC_LicenseeBATransaction_Active_FromDB054', 'DEL_SYNC_LicenseeBATransaction_Active_FromDB054'
go
sp_rename 'SYNC_LicenseeBATransaction_BK_FromDB054', 'DEL_SYNC_LicenseeBATransaction_BK_FromDB054'
go
sp_rename 'Task_BATransaction_Check', 'DEL_Task_BATransaction_Check'
go
sp_rename 'Task_DailyRptLicWinloss', 'DEL_Task_DailyRptLicWinloss'
go
sp_rename 'Task_DailyRptLicWinloss_xpre', 'DEL_Task_DailyRptLicWinloss_xpre'
go
sp_rename 'Task_DailyRptLicWinloss_xtest', 'DEL_Task_DailyRptLicWinloss_xtest'
go
sp_rename 'Task_DailyRptLicWinloss2_archive', 'DEL_Task_DailyRptLicWinloss2_archive'
go
sp_rename 'Task_DailyRptLicWinloss2_Bettrans_Dontest', 'DEL_Task_DailyRptLicWinloss2_Bettrans_Dontest'
go
sp_rename 'Task_DailyRptLicWinloss2_FrancisTest', 'DEL_Task_DailyRptLicWinloss2_FrancisTest'
go
sp_rename 'Task_DailyRptLicWinloss3', 'DEL_Task_DailyRptLicWinloss3'
go
sp_rename 'Task_DOT_dep_DailySummary_Bettrans', 'DEL_Task_DOT_dep_DailySummary_Bettrans'
go
sp_rename 'Task_DOT_dep_DailySummary_Bettrans_xpre', 'DEL_Task_DOT_dep_DailySummary_Bettrans_xpre'
go
sp_rename 'Task_DOT_dep_DailySummary_Bettrans_xtest', 'DEL_Task_DOT_dep_DailySummary_Bettrans_xtest'
go
sp_rename 'Task_DOT_dep_DailySummary_Bettrans14', 'DEL_Task_DOT_dep_DailySummary_Bettrans14'
go
sp_rename 'Task_DOT_dep_DailySummary_Bettrans14_xpre', 'DEL_Task_DOT_dep_DailySummary_Bettrans14_xpre'
go
sp_rename 'Task_DOT_dep_DailySummary_Bettrans14_xtest', 'DEL_Task_DOT_dep_DailySummary_Bettrans14_xtest'
go




-- DB053
use bodb_LicenseeReport
go
sp_rename 'Task_CustomerActive_GenDataFromBettrans', 'DEL_Task_CustomerActive_GenDataFromBettrans'
go
sp_rename 'Task_CustomerActive_GenDataFromBettrans14', 'DEL_Task_CustomerActive_GenDataFromBettrans14'
go
sp_rename 'Task_rptCustomerTurnOver_Bettrans_20180627_bk', 'DEL_Task_rptCustomerTurnOver_Bettrans_20180627_bk'
go


use bodb02
go
sp_rename 'DEL_Lrf_BetList_MobileReport_SelWinloss_Mem', 'DEL_DEL_Lrf_BetList_MobileReport_SelWinloss_Mem'
go
sp_rename 'Lrf_Rpt_MatchWinloss_ExportExcel', 'DEL_Lrf_Rpt_MatchWinloss_ExportExcel'
go
sp_rename 'Lrf_Rpt_MatchWinLoss_ExportExcel_UAT3', 'DEL_Lrf_Rpt_MatchWinLoss_ExportExcel_UAT3'
go
sp_rename 'Lrf_Rpt_MatchWinLoss_support', 'DEL_Lrf_Rpt_MatchWinLoss_support'
go
sp_rename 'Lrf_Rpt_MatchWinLossDetail_support', 'DEL_Lrf_Rpt_MatchWinLossDetail_support'
go
sp_rename 'Lrf_Rpt_MobileWinloss_dontest', 'DEL_Lrf_Rpt_MobileWinloss_dontest'
go
sp_rename 'Lrf_Rpt_Outstanding', 'DEL_Lrf_Rpt_Outstanding'
go
sp_rename 'Lrf_Rpt_Outstanding_UAT1', 'DEL_Lrf_Rpt_Outstanding_UAT1'
go
sp_rename 'Lrf_Rpt_Outstanding_UAT3', 'DEL_Lrf_Rpt_Outstanding_UAT3'
go
sp_rename 'Lrf_Rpt_Outstanding_xpre', 'DEL_Lrf_Rpt_Outstanding_xpre'
go
sp_rename 'Lrf_Rpt_Outstanding_xtest', 'DEL_Lrf_Rpt_Outstanding_xtest'
go
sp_rename 'OA_Rpt_LicenseeCurrencyWinloss', 'DEL_OA_Rpt_LicenseeCurrencyWinloss'
go
sp_rename 'OA_Rpt_LicenseeCurrencyWinloss_UAT1', 'DEL_OA_Rpt_LicenseeCurrencyWinloss_UAT1'
go
sp_rename 'OA_Rpt_LicenseeCurrencyWinloss_UAT4', 'DEL_OA_Rpt_LicenseeCurrencyWinloss_UAT4'
go
sp_rename 'Task_BATransaction_Check', 'DEL_Task_BATransaction_Check'
go
sp_rename 'Task_DailyRptLicWinloss', 'DEL_Task_DailyRptLicWinloss'
go
sp_rename 'Task_DailyRptLicWinloss_xtest', 'DEL_Task_DailyRptLicWinloss_xtest'
go