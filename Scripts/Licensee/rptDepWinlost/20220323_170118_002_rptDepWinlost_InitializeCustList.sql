/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220322@Percy
	DB: DBRPT-bodb_Report
	Task: Regen data on rptDepWinlost
		- Step 2: Initialize Customer List
*/
use bodb_Report
go

truncate table dbo.rptDepCust_UAT -- reset identity value

insert into dbo.rptDepCust_UAT (custid, init_winlostdate, regen_winlostdate)
values
	(31117583, '2021-07-05', '2021-07-06'),
	(37294634, '2021-05-25', '2021-05-26'),
	(37317184, '2021-06-28', '2021-06-29')
-- init date: get Closing Balance
-- regen date: date start regen data