/*
	Created: 20191025@Percy
	DB: DB06, DB061
	Task: LicenseeBATransaction - Rename unused SPs
*/

--- bodb02
/*
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'DBA_rptDepWL_GENData_Bettrans' union all
select 'DBA_rptDepWL_GENData_Bettrans14' union all
select 'DBA_rptDepWL_GENData_BettransBK' union all
select 'Task_BATransaction_Check' union all
select 'Task_DailySummary_Cust' union all
select 'Task_DOT_dep_DailySummary_BettransBK' union all
select 'Task_DOT_dep_DailySummary_BettransBK_DepWinlost_BK'

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

-- DB06
use bodb02
go
sp_rename 'DBA_rptDepWL_GENData_Bettrans', 'DEL_DBA_rptDepWL_GENData_Bettrans'
go
sp_rename 'DBA_rptDepWL_GENData_Bettrans14', 'DEL_DBA_rptDepWL_GENData_Bettrans14'
go
sp_rename 'DBA_rptDepWL_GENData_BettransBK', 'DEL_DBA_rptDepWL_GENData_BettransBK'
go
sp_rename 'Task_BATransaction_Check', 'DEL_Task_BATransaction_Check'
go
sp_rename 'Task_DailySummary_Cust', 'DEL_Task_DailySummary_Cust'
go
sp_rename 'Task_DOT_dep_DailySummary_BettransBK', 'DEL_Task_DOT_dep_DailySummary_BettransBK'
go
sp_rename 'Task_DOT_dep_DailySummary_BettransBK_DepWinlost_BK', 'DEL_Task_DOT_dep_DailySummary_BettransBK_DepWinlost_BK'
go
sp_rename 'Task_DOT_dep_DailySummary_BettransBK_xpre', 'DEL_Task_DOT_dep_DailySummary_BettransBK_xpre'
go


-- DB061
use bodb02
go
sp_rename 'DBA_rptDepWL_GENData_Bettrans', 'DEL_DBA_rptDepWL_GENData_Bettrans'
go
sp_rename 'DBA_rptDepWL_GENData_Bettrans14', 'DEL_DBA_rptDepWL_GENData_Bettrans14'
go
sp_rename 'DBA_rptDepWL_GENData_BettransBK', 'DEL_DBA_rptDepWL_GENData_BettransBK'
go
sp_rename 'Task_BATransaction_Check', 'DEL_Task_BATransaction_Check'
go
sp_rename 'Task_DailySummary_Cust', 'DEL_Task_DailySummary_Cust'
go
sp_rename 'Task_DOT_dep_DailySummary_BettransBK', 'DEL_Task_DOT_dep_DailySummary_BettransBK'
go
sp_rename 'Task_DOT_dep_DailySummary_BettransBK_DepWinlost_BK', 'DEL_Task_DOT_dep_DailySummary_BettransBK_DepWinlost_BK'
go
sp_rename 'Task_DOT_dep_DailySummary_BettransBK_xpre', 'DEL_Task_DOT_dep_DailySummary_BettransBK_xpre'
go