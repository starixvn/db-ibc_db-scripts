/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210927@Percy
	DBLIC-bodb_LicenseeReport
	Task: Gen data for apositiontaking column (rptLicWinloss2)
	Step 5: Insert data into temp table (rptLicWinloss2)
*/
use bodb_LicenseeReport
go

create table #tmpData
(
	winlostdate	smalldatetime
	,username nvarchar(50)
	,username2 nvarchar(50)
	,custid int
	,roleid int
	,recommend int
	,mrecommend int
	,srecommend int
	,turnover money
	,winlost money
	,awinlost money
	,mwinlost money
	,swinlost money
	,playercomm money
	,comm money
	,acomm money
	,scomm money
	,winlostvirtual money
	,commvirtual money
	,BetCount int
	,Currency smallint
	,sporttype smallint
	,bettype smallint
	,statusID smallint
	,isBA bit
	,isMobile bit
	,betfrom nvarchar(1)
	,BetEffective money
	,BuyBackAmt money
	,BABuyBackAmt money
	,apositiontaking smallmoney
	,RowId int
	,IsUpdate bit default (0)
)

declare @winlostdate smalldatetime = '2021-08-01', @sql varchar(max)
while @winlostdate <= '2021-09-10'
begin
	truncate table #tmpData
	
	set @sql =
	'select winlostdate,username,username2,custid,roleid,recommend,mrecommend,srecommend
		,turnover,winlost,BetEffective,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,winlostvirtual,commvirtual
		,BetCount,Currency,sporttype,bettype,statusID,isBA,isMobile,betfrom,BuyBackAmt,BABuyBackAmt,apositiontaking,RowId
	from openquery(DBRPT, ''
		select winlostdate,username,username2,custid,roleid,recommend,mrecommend,srecommend
			,turnover,winlost,BetEffective,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,winlostvirtual,commvirtual
			,BetCount,Currency,sporttype,bettype,statusID,isBA,isMobile,betfrom,BuyBackAmt,BABuyBackAmt,apositiontaking
			,row_number() over(partition by winlostdate, custid, sporttype, bettype, statusId, isBA, isMobile, betfrom
							order by winlostdate) as RowId
		from bodb_Report.dbo.rptLicWinloss2_temp with (nolock)
		where winlostdate = ''''' + convert(varchar(10), @winlostdate, 120) + ''''''')'

	insert into #tmpData (winlostdate,username,username2,custid,roleid,recommend,mrecommend,srecommend
		,turnover,winlost,BetEffective,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,winlostvirtual,commvirtual
		,BetCount,Currency,sporttype,bettype,statusID,isBA,isMobile,betfrom,BuyBackAmt,BABuyBackAmt,apositiontaking,RowId)
	exec (@sql)

	-- data change
	;with cte_data as (
		select winlostdate,custid,sporttype,bettype,statusID,isBA,isMobile,betfrom from #tmpData where RowId = 2
	)
	update t
	set t.IsUpdate = 1
	from #tmpData t
		inner join cte_data c on c.winlostdate = t.winlostdate and c.custid = t.custid
			and c.sporttype = t.sporttype and c.bettype = t.bettype and c.statusID = t.statusID and c.isBA = t.isBA
			and c.isMobile = t.isMobile and c.betfrom = t.betfrom

	-- just 1 apositiontaking value
	update r with (rowlock)
	set r.apositiontaking = t.apositiontaking
	from dbo.rptLicWinloss2 r
		inner join #tmpData t on r.winlostdate = t.winlostdate and r.custid = t.custid
			and r.sporttype = t.sporttype and r.bettype = t.bettype and r.statusID = t.statusID and r.isBA = t.isBA
			and r.isMobile = t.isMobile and r.betfrom = t.betfrom
	where r.winlostdate = @winlostdate and t.IsUpdate = 0

	-- more than 1 apositiontaking value
	update r with (rowlock)
	set r.apositiontaking = t.apositiontaking
		,r.turnover = t.turnover
		,r.winlost = t.winlost
		,r.BetEffective = t.BetEffective
		,r.awinlost = t.awinlost
		,r.mwinlost = t.mwinlost
		,r.swinlost = t.swinlost
		,r.playercomm = t.playercomm
		,r.comm = t.comm
		,r.acomm = t.acomm
		,r.scomm = t.scomm
		,r.winlostvirtual = t.winlostvirtual
		,r.commvirtual = t.commvirtual
		,r.BetCount = t.BetCount
		,r.BuyBackAmt = t.BuyBackAmt
		,r.BABuyBackAmt = t.BABuyBackAmt
	from dbo.rptLicWinloss2 r
		inner join #tmpData t on r.winlostdate = t.winlostdate and r.custid = t.custid
			and r.sporttype = t.sporttype and r.bettype = t.bettype and r.statusID = t.statusID and r.isBA = t.isBA
			and r.isMobile = t.isMobile and r.betfrom = t.betfrom
	where r.winlostdate = @winlostdate and t.IsUpdate = 1 and t.RowId = 1

	-- insert for more than 1 apositiontaking value
	insert into rptLicWinloss2 (winlostdate,username,username2,custid,roleid,recommend,mrecommend,srecommend
		,turnover,winlost,BetEffective,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,winlostvirtual,commvirtual
		,BetCount,Currency,sporttype,bettype,statusID,isBA,isMobile,betfrom,BuyBackAmt,BABuyBackAmt,apositiontaking)
	select winlostdate,username,username2,custid,roleid,recommend,mrecommend,srecommend
		,turnover,winlost,BetEffective,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,winlostvirtual,commvirtual
		,BetCount,Currency,sporttype,bettype,statusID,isBA,isMobile,betfrom,BuyBackAmt,BABuyBackAmt,apositiontaking
	from #tmpData
	where IsUpdate = 1 and RowId > 1

	select @winlostdate = dateadd(day, 1, @winlostdate)

	waitfor delay '00:00:00.280'
end

drop table #tmpData