/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240821@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: LAP - Exchange - Support Running ticket [RedmineID: #208108]		


	Run script with date range 07/01/2024 - 09/05/2024
	Part 1: 
		betPlaced >= '2024-08-15'
	Part 2: waiting 1 hours
		betPlaced >= '2024-08-01' and betPlaced < '2024-08-15'
	Part 3: waiting 1 hours
		betPlaced >= '2024-07-15' and betPlaced < '2024-08-01'
	Part 4: waiting 1 hours
		betPlaced >= '2024-07-01' and betPlaced < '2024-07-15'

*/


USE [bodb_3rdProduct]
GO

declare @BatchSize INT = 100000

drop table if exists #tmpBettrans_Exchange
create table #tmpBettrans_Exchange (betID bigint, isfinished bit default(0))

insert into #tmpBettrans_Exchange (betID)
select s.betID
from dbo.Bettrans_Exchange s with (nolock)
where betPlaced >= '2024-08-20' and betPlaced < '2024-09-06'

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
