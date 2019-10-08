/*
	Created: 20191001@Percy
	DB: DBTXN
	Task: Setup HA on NAP/ExtNAP - Rename unused SPs
*/

-- bodb02
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Acc_AccAdminSel' union all
select 'Acc_AccAdminSelByID' union all
select 'Acc_BettransCheckNegativeBetCredit' union all
select 'Acc_BettransRecoverSpecialBets' union all
select 'Acc_HedgeDel' union all
select 'Acc_HedgeSel' union all
select 'Acc_HedgeUpd' union all
select 'Acc_ResetWinning_Ins' union all
select 'Acc_Rpt_BetRatioByUser' union all
select 'Acc_Rpt_BetRatioByUser14' union all
select 'Acc_Rpt_HedgeRecord' union all
select 'Admin_3rdAutoSettlement_s201'

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