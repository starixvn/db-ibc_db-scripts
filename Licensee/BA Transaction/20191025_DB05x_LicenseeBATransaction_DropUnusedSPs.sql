/*
	Created: 20191025@Percy
	DB: DB052, DB053
	Task: LicenseeBATransaction - Drop unused SPs
*/

/*
--- bodb_Licensee
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Task_DailyRptLicWinloss'

update @sp set spname = 'DEL_' + spname

declare @sql varchar(max) = ''
select  @sql = @sql + 'drop procedure DEL_' + name + char(10) + 'go' + char(10)
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

update @sp set spname = 'DEL_' + spname

declare @sql varchar(max) = ''
select  @sql = @sql + 'drop procedure DEL_' + name + char(10) + 'go' + char(10)
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

update @sp set spname = 'DEL_' + spname

declare @sql varchar(max) = ''
select  @sql = @sql + 'drop procedure DEL_' + name + char(10) + 'go' + char(10)
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

-- DB052
use bodb_licensee
go
drop procedure DEL_Task_DailyRptLicWinloss
go


use bodb_LicenseeReport
go
drop procedure DEL_Task_CustomerActive_GenDataFromBettrans
go
drop procedure DEL_Task_CustomerActive_GenDataFromBettrans14
go
drop procedure DEL_Task_rptCustomerTurnOver_Bettrans_20180627_bk
go


use bodb02
go
drop procedure DEL_Acc_MoveBet_BettransSel
go
drop procedure DEL_DEL_Acc_Rpt_LicWinlossDetail_MAg2
go
drop procedure DEL_DEL_Acc_Rpt_LicWinlossDetail_MAg2_xpre
go
drop procedure DEL_DEL_Acc_Rpt_LicWinlossDetail_MAg2_xtest
go
drop procedure DEL_DEL_Lrf_Rpt_MobileWinlossDetail_Ag
go
drop procedure DEL_Lrf_Rpt_LicWinlossDetail_20141215
go
drop procedure DEL_Lrf_Rpt_LiveReportSummary_20141215
go
drop procedure DEL_Lrf_Rpt_LiveReportSummary_xpre1
go
drop procedure DEL_Lrf_Rpt_LiveReportSummaryDetail_20141216
go
drop procedure DEL_Lrf_Rpt_LiveReportSummaryDetail_dontest
go
drop procedure DEL_Lrf_Rpt_MatchWinLoss_ExportExcel
go
drop procedure DEL_Lrf_Rpt_MatchWinLoss_ExportExcel_UAT3
go
drop procedure DEL_Lrf_Rpt_MatchWinloss_ExportExcel_UAT4
go
drop procedure DEL_Lrf_Rpt_MatchWinLoss_ExportExcel_xpre
go
drop procedure DEL_Lrf_Rpt_MatchWinLoss_ExportExcel_xtest
go
drop procedure DEL_Lrf_Rpt_MatchWinLoss_support
go
drop procedure DEL_Lrf_Rpt_MatchWinLossDetail_support
go
drop procedure DEL_Lrf_Rpt_MobileWinloss_20141215
go
drop procedure DEL_Lrf_Rpt_MobileWinloss_dontest
go
drop procedure DEL_Lrf_Rpt_Outstanding
go
drop procedure DEL_Lrf_Rpt_Outstanding_UAT1
go
drop procedure DEL_Lrf_Rpt_Outstanding_UAT2
go
drop procedure DEL_Lrf_Rpt_Outstanding_UAT3
go
drop procedure DEL_Lrf_Rpt_Outstanding_UAT4
go
drop procedure DEL_Lrf_Rpt_Outstanding_xpre
go
drop procedure DEL_Lrf_Rpt_Outstanding_xtest
go
drop procedure DEL_Lrf_Rpt_WinlossByProduct_20141215
go
drop procedure DEL_Lrf_Rpt_WinlossByProduct_DanielTest
go
drop procedure DEL_Lrf_Rpt_WinlossByProduct_DonTest
go
drop procedure DEL_Lrf_Rpt_WinlossByProductDetail_20141215
go
drop procedure DEL_OA_Rpt_LicenseeCurrencyWinloss
go
drop procedure DEL_OA_Rpt_LicenseeCurrencyWinloss_UAT1
go
drop procedure DEL_OA_Rpt_LicenseeCurrencyWinloss_UAT4
go
drop procedure DEL_OA_Rpt_LicenseeCurrencyWinloss_xtest
go
drop procedure DEL_OA_Rpt_SummaryCurrencyWinloss
go
drop procedure DEL_OA_Rpt_SummaryCurrencyWinloss_xtest
go
drop procedure DEL_SYNC_LicenseeBATransaction_Active_FromDB054
go
drop procedure DEL_SYNC_LicenseeBATransaction_BK_FromDB054
go
drop procedure DEL_Task_BATransaction_Check
go
drop procedure DEL_Task_DailyRptLicWinloss
go
drop procedure DEL_Task_DailyRptLicWinloss_xpre
go
drop procedure DEL_Task_DailyRptLicWinloss_xtest
go
drop procedure DEL_Task_DailyRptLicWinloss2_archive
go
drop procedure DEL_Task_DailyRptLicWinloss2_Bettrans_Dontest
go
drop procedure DEL_Task_DailyRptLicWinloss2_FrancisTest
go
drop procedure DEL_Task_DailyRptLicWinloss3
go
drop procedure DEL_Task_DOT_dep_DailySummary_Bettrans
go
drop procedure DEL_Task_DOT_dep_DailySummary_Bettrans_xpre
go
drop procedure DEL_Task_DOT_dep_DailySummary_Bettrans_xtest
go
drop procedure DEL_Task_DOT_dep_DailySummary_Bettrans14
go
drop procedure DEL_Task_DOT_dep_DailySummary_Bettrans14_xpre
go
drop procedure DEL_Task_DOT_dep_DailySummary_Bettrans14_xtest
go



-- DB053
use bodb_LicenseeReport
go
drop procedure DEL_Task_CustomerActive_GenDataFromBettrans
go
drop procedure DEL_Task_CustomerActive_GenDataFromBettrans14
go
drop procedure DEL_Task_rptCustomerTurnOver_Bettrans_20180627_bk
go


use bodb02
go
drop procedure DEL_DEL_Lrf_BetList_MobileReport_SelWinloss_Mem
go
drop procedure DEL_Lrf_Rpt_MatchWinloss_ExportExcel
go
drop procedure DEL_Lrf_Rpt_MatchWinLoss_ExportExcel_UAT3
go
drop procedure DEL_Lrf_Rpt_MatchWinLoss_support
go
drop procedure DEL_Lrf_Rpt_MatchWinLossDetail_support
go
drop procedure DEL_Lrf_Rpt_MobileWinloss_dontest
go
drop procedure DEL_Lrf_Rpt_Outstanding
go
drop procedure DEL_Lrf_Rpt_Outstanding_UAT1
go
drop procedure DEL_Lrf_Rpt_Outstanding_UAT3
go
drop procedure DEL_Lrf_Rpt_Outstanding_xpre
go
drop procedure DEL_Lrf_Rpt_Outstanding_xtest
go
drop procedure DEL_OA_Rpt_LicenseeCurrencyWinloss
go
drop procedure DEL_OA_Rpt_LicenseeCurrencyWinloss_UAT1
go
drop procedure DEL_OA_Rpt_LicenseeCurrencyWinloss_UAT4
go
drop procedure DEL_Task_BATransaction_Check
go
drop procedure DEL_Task_DailyRptLicWinloss
go
drop procedure DEL_Task_DailyRptLicWinloss_xtest
go
