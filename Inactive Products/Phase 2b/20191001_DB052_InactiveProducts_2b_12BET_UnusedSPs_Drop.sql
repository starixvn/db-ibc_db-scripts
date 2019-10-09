/*
	Created: 20191001@Percy
	DB: DB52
	Task: Remove inactive Products - Drop unused SPs
*/

--- Affiliate_12BET
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Aff_AffiliateCommByMonthAll' union all
select 'Aff_AffiliateDailySelForImport' union all
select 'Aff_AffiliateReport' union all
select 'Aff_AffiliateReportDetail' union all
select 'Aff_CalMonthlyEarning' union all
select 'Aff_CalMonthlyEarningCurrent' union all
select 'Aff_CommissionForCurrentMonth' union all
select 'Aff_CommissionForMonth' union all
select 'Aff_CustomerSelSummary' union all
select 'Aff_EarningSelDaily' union all
select 'Aff_EarningSelDetail' union all
select 'Aff_GetMemberWinlost' union all
select 'Aff_MemberDailyForCurrentDate' union all
select 'Aff_PlayersSelDetail' union all
select 'Aff_ReportDetailSelAll' union all
select 'Aff_ReportDetailSelByAff' union all
select 'Aff_ReportQM' union all
select 'Aff_ReportQMDetail' union all
select 'Task_Aff_MemberDailySummary' union all
select 'Task_Aff_MemberDailySummaryForAff' union all
select 'Task_Aff_MonthlyTransfer' union all
select 'Task_Aff_MonthlyTransfer_ForAff'

update @sp set spname = 'DEL_' + spname

declare @sql varchar(max) = ''
select  @sql = @sql + 'drop procedure ' + name + char(10) + 'go' + char(10)
from (
	select distinct o.name
	from @sp sp
		inner join Affiliate_12BET.sys.objects o
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