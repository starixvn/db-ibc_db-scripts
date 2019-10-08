/*
	Created: 20191001@Percy
	DB: DB06, DB061
	Task: Setup HA on NAP/ExtNAP - Rename unused SPs
*/

--- bodb_ACC
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Acc_MailingListIns' union all
select 'Acc_MailingListSel' union all
select 'Acc_MailingListUpd'

declare @sql varchar(max) = ''
select  @sql = @sql + 'sp_rename ''' + name + ''', ''DEL_' + name + '''' + char(10) + 'go' + char(10)
from (
	select distinct o.name
	from @sp sp
		inner join bodb_ACC.sys.objects o
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


-- bodb02
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Acc_ResetWinning_Sel' union all
select 'Acc_Rpt_AllStatementCompany' union all
select 'Acc_Rpt_BaseBalMovement_SAg' union all
select 'Acc_Rpt_OriginalBalMovement_SAg' union all
select 'Acc_Rpt_TicketsListing'

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