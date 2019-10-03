use bodb02
go
/*
	run on DB06/DB061
	clean del_ sps
*/
set nocount on

declare @sp table (spname varchar(1000))
insert into @sp (spname)
select '_DEL_Acc_Rpt_WinLostSummary' union all
select '_DEL_Task_DailyRptLicWinloss_archive' union all
select '_DEL_Task_DailyRptLicWinloss2_archive' union all
select '_delete_Acc_Rpt_BingoOutstanding' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Bullfighting_MatchDetail_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_ColossusBet_BetType_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_ColossusBet_Site_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_MetricGaming_BetType_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_MetricGaming_LiveNonLive_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_MetricGaming_MatchDetail_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_MetricGaming_Site_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_NumberGame_MatchDetail_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_OtherSports_BetType_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_OtherSports_LiveNonLive_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_OtherSports_SportType_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Products_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Racing_BetType' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Racing_BetType_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Racing_MatchDetail' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Racing_MatchDetail_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Racing_Site' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Racing_Site_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Racing_SportType' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Racing_SportType_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Soccer_BetType_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Soccer_LiveNonLive_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Soccer_Major_Minor_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Sportsbook_MatchDetail_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Sportsbook_Site_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Universal_BetType_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_Universal_Site_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_VirtualRacing_MatchDetail_14' union all
select '_delete_Acc_Rpt_CompanyWinLoss_VirtualSports_BetType_14' union all
select '_delete_Acc_Rpt_DailyWLDirect_Bingo' union all
select '_delete_Acc_Rpt_DailyWLDirect_Bingo_Bettype_Site' union all
select '_delete_Acc_Rpt_DailyWLDirect_Bingo_Bettype_Site14' union all
select '_delete_Acc_Rpt_DailyWLDirect_Bingo14' union all
select '_delete_Acc_Rpt_DailyWLDirect_Casino' union all
select '_delete_Acc_Rpt_DailyWLDirect_Casino_Bettype_Site' union all
select '_delete_Acc_Rpt_DailyWLDirect_Casino_Bettype_Site14' union all
select '_delete_Acc_Rpt_DailyWLDirect_Casino14' union all
select '_delete_Acc_Rpt_DailyWLDirect_ColosussBets' union all
select '_delete_Acc_Rpt_DailyWLDirect_ColosussBets14' union all
select '_delete_Acc_Rpt_DailyWLDirect_HorseRacing' union all
select '_delete_Acc_Rpt_DailyWLDirect_HorseRacing_Details' union all
select '_delete_Acc_Rpt_DailyWLDirect_HorseRacing_Details_14' union all
select '_delete_Acc_Rpt_DailyWLDirect_HorseRacing_Details14' union all
select '_delete_Acc_Rpt_DailyWLDirect_HorseRacing14' union all
select '_delete_Acc_Rpt_DailyWLDirect_LiveCasino' union all
select '_delete_Acc_Rpt_DailyWLDirect_LiveCasino_Bettype_Site' union all
select '_delete_Acc_Rpt_DailyWLDirect_LiveCasino_Bettype_Site14' union all
select '_delete_Acc_Rpt_DailyWLDirect_LiveCasino14' union all
select '_delete_Acc_Rpt_DailyWLDirect_Racing' union all
select '_delete_Acc_Rpt_DailyWLDirect_Racing14' union all
select '_delete_Acc_Rpt_DailyWLDirect_RacingBySport' union all
select '_delete_Acc_Rpt_DailyWLDirect_RacingBySport_Bettype_Site' union all
select '_delete_Acc_Rpt_DailyWLDirect_RacingBySport_Bettype_Site14' union all
select '_delete_Acc_Rpt_DailyWLDirect_RacingBySport_Details' union all
select '_delete_Acc_Rpt_DailyWLDirect_RacingBySport_Details14' union all
select '_delete_Acc_Rpt_DailyWLDirect_RacingBySport14' union all
select '_delete_Acc_Rpt_DailyWLDirect_Sporttype' union all
select '_delete_Acc_Rpt_DailyWLDirect_Sporttype_14' union all
select '_delete_Acc_Rpt_DailyWLDirect_Sporttype_Francis' union all
select '_delete_Acc_Rpt_DailyWLDirect_Sporttype_NOLOCK' union all
select '_delete_Acc_Rpt_DailyWLDirect_Sporttype_ROWLOCK' union all
select '_delete_Acc_Rpt_DailyWLDirect_Sporttype_Ver2016' union all
select '_delete_Acc_Rpt_DailyWLDirect_Sporttype14' union all
select '_delete_Acc_Rpt_DailyWLDirect_VirtualSports' union all
select '_delete_Acc_Rpt_DailyWLDirect_VirtualSports_Bettype' union all
select '_delete_Acc_Rpt_DailyWLDirect_VirtualSports_Bettype14' union all
select '_delete_Acc_Rpt_DailyWLDirect_VirtualSports14' union all
select '_delete_Acc_Rpt_MatchWinLossByBetType' union all
select '_delete_Acc_Rpt_MatchWinLossSingleBet' union all
select '_delete_Acc_Rpt_Racing_ComparisionTO3rd' union all
select '_delete_Acc_Rpt_WinlostCA_Details' union all
select '_delete_Acc_Rpt_WinlostCA_Details14' union all
select '_delete_Acc_Rpt_WinlostRacing_Tote' union all
select '_delete_Acc_Rpt_WinlostRacing_Tote_BetList' union all
select '_delete_Acc_Rpt_WinlostRacing_Tote_BetList14' union all
select '_delete_Acc_Rpt_WinlostRacing_Tote_BK' union all
select '_delete_Acc_Rpt_WinlostRacing_Tote_Details' union all
select '_delete_Acc_Rpt_WinlostRacing_Tote_Details_BK' union all
select '_delete_Acc_Rpt_WinlostRacing_Tote_Details14' union all
select '_delete_Acc_Rpt_WinlostRacing_Tote14' union all
select '_delete_Acc_Rpt_WinlostRacingLicensee_BetList_Details' union all
select '_delete_Acc_Rpt_WinlostRacingLicensee_BetList_Details14' union all
select '_delete_Acc_Rpt_WinlostRacingLicensee_Details' union all
select '_delete_Acc_Rpt_WinlostRacingLicensee_Details14' union all
select '_delete_Acc_Rpt_WinlostRacingLicensee_SiteSel' union all
select '_delete_NAP_Rpt_WinlostBI_ByDateRange'

declare @sql varchar(max) = ''

select  @sql = @sql + 'drop procedure ' + name + char(10) + 'go' + char(10)
from (
	select distinct o.name
	from @sp sp
		inner join sys.objects o on o.name like sp.spname + '%'
) as t

print @sql