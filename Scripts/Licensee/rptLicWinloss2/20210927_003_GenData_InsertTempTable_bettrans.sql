/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20210927@Percy
	DBRPT-bodb_Report
	Task: Gen data for apositiontaking column (rptLicWinloss2)
	Step 3: Insert data into temp table (bettrans)
*/
use bodb_Report
go

declare @winlostdate smalldatetime = '2021-08-01'
create table #CustIds (CustId int)

while @winlostdate <= '2021-09-10'
begin
	truncate table #CustIds

	insert into #CustIds (CustId)
	select CustId from DBLIC.bodb_LicenseeReport.dbo.rptLicWinloss2 with (nolock)
	where winlostdate = @winlostdate
	group by CustId

	insert into dbo.bettrans_temp (transid,custid,winlostdate,matchid,bettype,liveawayscore,statusID,stake,actual_stake
		,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,virtualrate,currency,oddsspread,modds,betfrom,apositiontaking)
	select transid,b.custid,winlostdate,matchid,bettype,liveawayscore,statusID,stake,actual_stake
		,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,virtualrate,currency,oddsspread,modds,betfrom,apositiontaking
	from bodb_Archive.dbo.bettrans_bk b with (nolock)
		inner join #CustIds c on b.custid = c.custid
	where winlostdate = @winlostdate
		and statusId in (101, 111, 112, 113)

	select @winlostdate = dateadd(day, 1, @winlostdate)

	waitfor delay '00:00:00.280'
end