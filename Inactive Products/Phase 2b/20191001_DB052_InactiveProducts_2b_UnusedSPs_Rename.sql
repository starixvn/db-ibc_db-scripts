/*
	Created: 20191001@Percy
	DB: DB052
	Task: Remove inactive Products - Rename unused SPs
*/

--- bodb_Summary
declare @sp table (spname varchar(1000))
insert into @sp (spname)
select 'Task_DailyRptPokerGamesSumWinLoss' union all
select 'Task_DailyRptPokerGamesSumWinLoss_CheckData' union all
select 'Task_DailyRptPokerGamesSumWinLoss_CheckData_Job' union all
select 'Task_DailyRptPokerGamesSumWinLoss_Job'

declare @sql varchar(max) = ''
select  @sql = @sql + 'sp_rename ''' + name + ''', ''DEL_' + name + '''' + char(10) + 'go' + char(10)
from (
	select distinct o.name
	from @sp sp
		inner join bodb_Summary.sys.objects o
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
select 'Acc_AllStatement_Full' union all
select 'Acc_ResetWinning_SelByDate' union all
select 'Acc_ResetWinning_SelByDate_lukas' union all
select 'Acc_ResetWinning_SelByDate14' union all
select 'Acc_Rpt_AllProductWLAutomail' union all
select 'Age_Chart_WinlossAnalysis_Ag' union all
select 'Age_Chart_WinlossAnalysis_MAg' union all
select 'Age_Chart_WinlossAnalysis_SAg' union all
select 'Age_Rpt_Outstanding_Ag' union all
select 'Age_Rpt_Outstanding_MAg' union all
select 'Age_Rpt_Outstanding_SAg' union all
select 'Age_Rpt_WinLoss_Ag_bettrans' union all
select 'Age_Rpt_WinLoss_Ag_Kiwi' union all
select 'Age_Rpt_WinLoss_MAg_bettrans' union all
select 'Age_Rpt_WinLoss_MAg_Thien' union all
select 'Age_Rpt_WinLoss_SAg_bettrans' union all
select 'Age_Rpt_WinLoss_SAg_Thien' union all
select 'Age_Rpt_WinLossDetail_Ag_bettrans' union all
select 'Age_Rpt_WinLossDetail_Ag_thien' union all
select 'Age_Rpt_WinLossDetail_MAg_bettrans' union all
select 'Age_Rpt_WinLossDetail_MAg_bettrans_New' union all
select 'Age_Rpt_WinLossDetail_MAg_bettrans_New_thien' union all
select 'Age_Rpt_WinLossDetail_SAg_bettrans' union all
select 'Age_Rpt_WinLossDetail_SAg_tmp' union all
select 'Age_Statement_Mem' union all
select 'Agw_Rpt_AgentWinlossDetail_MAg' union all
select 'Agw_Rpt_AgentWinlossDetail_SAg' union all
select 'Agw_Rpt_MasterWinlossDetail_SAg' union all
select 'Agw_Rpt_MemberWinlossDetail_Ag' union all
select 'Agw_Rpt_MemberWinlossDetail_MAg' union all
select 'Agw_Rpt_MemberWinlossDetail_SAg' union all
select 'Agw_Rpt_WinlossDetail_Ag' union all
select 'Agw_Rpt_WinlossDetail_MAg' union all
select 'Agw_Rpt_WinlossDetail_SAg' union all
select 'Agw_Rpt_WinlossTotal_Ag' union all
select 'Agw_Rpt_WinlossTotal_MAg' union all
select 'Agw_Rpt_WinlossTotal_SAg' union all
select 'Age_Statement_Mem_BetSummary' union all
select 'Age_Statement_Rpt_SAg' union all
select 'Age_Statement_Rpt_MAg' union all
select 'Age_Statement_Rpt_Ag'

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