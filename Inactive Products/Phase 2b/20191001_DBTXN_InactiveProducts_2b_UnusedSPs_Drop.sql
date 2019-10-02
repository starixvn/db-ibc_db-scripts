/*
	Created: 20191001@Percy
	DB: DBTXN
	Task: Remove inactive Products - Drop unused SPs
*/

--- bodb02
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Acc_ResetWinning_SelByDate' union all
select 'Task_Daily3rdProductWinlost' union all
select 'Task_DailyDummyTransfer_s162' union all
select 'Task_DailyDummyTransfer_s253' union all
select 'Task_DailySummary_RESUM' union all
select 'Task_DailySummary_Sum_WinLoss' union all
select 'Task_DailySummary14' union all
select 'Task_ResetWinning_3rdParty'

update @sp set spname = 'DEL_' + spname

declare @sql varchar(max) = ''
select  @sql = @sql + 'drop procedure ' + name + char(10) + 'go' + char(10)
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