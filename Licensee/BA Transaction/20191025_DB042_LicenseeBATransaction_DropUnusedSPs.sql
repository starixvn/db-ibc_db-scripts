/*
	Created: 20191025@Percy
	DB: DB042
	Task: LicenseeBATransaction - Drop unused SPs
*/

--- bodb_Licensee
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Task_BATransaction_Copy_Ticket'

update @sp set spname = 'DEL_' + spname

declare @sql varchar(max) = ''
select  @sql = @sql + 'drop procedure ' + name + char(10) + 'go' + char(10)
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