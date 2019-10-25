/*
	Created: 20191025@Percy
	DB: DB06, DB061
	Task: LicenseeBATransaction - Drop unused SPs
*/

--- bodb02
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'DBA_rptDepWL_GENData_Bettrans' union all
select 'DBA_rptDepWL_GENData_Bettrans14' union all
select 'DBA_rptDepWL_GENData_BettransBK' union all
select 'Task_BATransaction_Check' union all
select 'Task_DailySummary_Cust' union all
select 'Task_DOT_dep_DailySummary_BettransBK' union all
select 'Task_DOT_dep_DailySummary_BettransBK_DepWinlost_BK'

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
go