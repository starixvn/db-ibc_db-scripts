/*
	Created: 20191025@Percy
	DB: DB052, DB053
	Task: LicenseeBATransaction - Rename unused SPs
*/

--- bodb_Licensee
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