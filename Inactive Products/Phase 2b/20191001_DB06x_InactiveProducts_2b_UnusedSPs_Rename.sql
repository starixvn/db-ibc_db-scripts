/*
	Created: 20191001@Percy
	DB: DB06, DB061
	Task: Remove inactive Products - Rename unused SPs
*/

--- bodb02
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Acc_AllStatement_Full_2009' union all
select 'Acc_AllStatement_Full_20160211' union all
select 'Acc_AllStatement_Full_thien' union all
select 'Acc_ResetWinning_SelByDate' union all
select 'Acc_Rpt_AllProductWLAutomail' union all
select 'Acc_Statement' union all
select 'Acc_StatementSel_backup_20160615' union all
select 'Acc_StatementSel_viet' union all
select 'Aff_PlayersWinlostByProductSel' union all
select 'NAP_SaveBet_GetTurnOver' union all
select 'NAP_SaveBet_GetWinLost' union all
select 'Task_DailyDummyTransfer_s162' union all
select 'Task_ResetWinning_Non3rdParty1' union all
select 'Task_ResetWinning_Non3rdParty2'

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



-- bodb_Archive
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select '_DEL_Task_Archive_Event' union all
select '_DEL_Task_Archive_Event_Manually' union all
select 'Acc_StatementSel_bk'

declare @sql varchar(max) = ''
select  @sql = @sql + 'sp_rename ''' + name + ''', ''DEL_' + name + '''' + char(10) + 'go' + char(10)
from (
	select distinct o.name
	from @sp sp
		inner join bodb_Archive.sys.objects o
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