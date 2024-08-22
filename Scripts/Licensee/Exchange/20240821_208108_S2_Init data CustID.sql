/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240821@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: LAP - Exchange - Support Running ticket [RedmineID: #208108]		
*/


USE [bodb_3rdProduct]
GO

declare @BatchSize INT = 100000

drop table if exists #tmpBettrans_Exchange
create table #tmpBettrans_Exchange (betID bigint, isfinished bit default(0))

insert into #tmpBettrans_Exchange (betID)
select s.betID
from dbo.Bettrans_Exchange s with (nolock)
where betPlaced >= '2024-07-01'

while exists (select top 1 1 from #tmpBettrans_Exchange)
begin
	update top (@BatchSize)	b
	set isfinished = 1
	from #tmpBettrans_Exchange b

	update b
	set CustID = CONVERT(INT,REPLACE(REPLACE(REPLACE(userId, 'poc', ''), 'sit', ''), 'uat', ''))
	from dbo.Bettrans_Exchange b
		inner join #tmpBettrans_Exchange t on b.betID = t.betID
	where t.isfinished = 1

	delete from #tmpBettrans_Exchange where isfinished = 1

	waitfor delay '00:00:00.280'
end
