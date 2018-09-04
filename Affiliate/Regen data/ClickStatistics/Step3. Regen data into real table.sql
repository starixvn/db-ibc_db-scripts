use [Affiliate_12BET]
go

/*
	Created: 20180904@Percy
	DB: DBAFF12BET.Affiliate_12BET
	Task: Step 3: Gen data into real table
*/
declare @fromdate smalldatetime, @todate smalldatetime
select  @fromdate = '2018-08-01', @todate = '2018-08-31'

delete dbo.ClickStatisticsSum with (rowlock, updlock)
where date between @fromdate and @todate

insert into ClickStatisticsSum (AffID,TrackingID,[Date],TotalClick,UniqueClick,IsForMonth)
select AffID,TrackingID,[Date],TotalClick,UniqueClick,IsForMonth from dbo.ClickStatisticsSum_tmp