use [Affiliate_12BET]
go

/*
	Created: 20180904@Percy
	DB: DBAFF12BET.Affiliate_12BET
	Task: Step 2: Gen data into temp table to check
*/

declare @fromdate smalldatetime, @todate smalldatetime
select  @fromdate = '2018-08-01', @todate = '2018-08-31'
/*
	By Date
*/
select TrackingID,[Date],sum(1) as TotalClick,count(distinct IP) as UniqueClick
into #tmpByDate
from ClickStatistics_bk (nolock)
where date between @fromdate and @todate
group by TrackingID,Date

-- Daily by Date
insert into ClickStatisticsSum_tmp (AffID,TrackingID,[Date],TotalClick,UniqueClick,IsForMonth)
select a.AffID,t.TrackingID,t.[Date],t.TotalClick,t.UniqueClick, 0 AS IsForMonth
from #tmpByDate t
	inner join TrackingCode a (nolock)  on a.TrackingID=t.TrackingID

-- Monthly by Date
insert into ClickStatisticsSum_tmp(AffID,TrackingID,[Date],TotalClick,UniqueClick,IsForMonth)
select a.AffID, t.TrackingID, '2018-08-01' as Date, sum(t.TotalClick), sum(t.UniqueClick), 1 as IsForMonth
from #tmpByDate t
	inner join TrackingCode a (nolock)  on a.TrackingID=t.TrackingID
group by a.AffId, t.TrackingID

drop table #tmpByDate

/*
	All
*/
select a.AffID,s.[Date],sum(1) as TotalClick,count(distinct s.IP) as UniqueClick
into #tmpAll
from ClickStatistics_bk s (nolock)
	 inner join TrackingCode a (nolock)  on a.TrackingID=s.TrackingID
where date between @fromdate and @todate
group by a.AffID,s.Date

-- Summary for Daily All
insert into ClickStatisticsSum_tmp(AffID,TrackingID,[Date],TotalClick,UniqueClick,IsForMonth)
select AffID,0 as TrackingID,[Date],TotalClick,UniqueClick,0 as IsForMonth
from #tmpAll

--Summary for Monthly All
insert into ClickStatisticsSum_tmp(AffID,TrackingID,[Date],TotalClick,UniqueClick,IsForMonth)
select AffID,0 as TrackingID,'2018-08-01' as [Date],sum(TotalClick),sum(UniqueClick),1 as IsForMonth
from #tmpAll
group by AffId

drop table #tmpAll