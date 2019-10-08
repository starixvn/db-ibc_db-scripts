/*
	Created: 20191001@Percy
	DB: DB053
	Task: Setup HA on NAP/ExtNAP - Rename unused SPs
*/

-- bodb02
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Acc_AllStatement' union all
select 'Acc_BettransDelSpecial_LeagueSelOutright' union all
select 'Acc_BettransDelSpecial_OutrightSel' union all
select 'Acc_BettransSelDelSpecial_MixParlay' union all
select 'Acc_BettransSelDelSpecial_Outright' union all
select 'Acc_BettransSelRecoverBet_LiveCS' union all
select 'Acc_BettransSelRecoverBet_NumberGame' union all
select 'Acc_BettransSelRecoverSpecialBets' union all
select 'Acc_BettransSelSpecialDel' union all
select 'Acc_BettransSelSpecialDel_EarlyKO' union all
select 'Acc_BettransSelSpecialDel_LiveCS' union all
select 'Acc_BettransSelSpecialDel_MixParlay' union all
select 'Acc_BettransSelSpecialDel_NumberGame' union all
select 'Acc_BettransSelSpecialDel_VirtualSports' union all
select 'Acc_BetTypeSel' union all
select 'Acc_LiveCS_SelGameByID' union all
select 'Acc_Rpt_MAMonitor_BettypeSel' union all
select 'Acc_Rpt_MAMonitor_SportSel' union all
select 'Acc_Rpt_MixParlayWon' union all
select 'Acc_SelHRAllowedCurrency' union all
select 'Acc_SMATurnoverLeagueSel' union all
select 'Acc_SMATurnoverMatchSel' union all
select 'Acc_SportTypeSel'

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