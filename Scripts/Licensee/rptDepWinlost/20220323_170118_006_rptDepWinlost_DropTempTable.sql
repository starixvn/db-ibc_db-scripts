/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220322@Percy
	DB: DBRPT-bodb_Report
	Task: Regen data on rptDepWinlost
		- Step 6: Drop table _UAT
*/

-- run on DB061
use bodb_Report
go

-- rptDepCust_UAT
drop table dbo.rptDepCust_UAT
go

-- rptDepWinlost_UAT
drop table dbo.rptDepWinlost_UAT
go

-- rptDepWinlostByProduct_UAT
drop table dbo.rptDepWinlostByProduct_UAT
go

-- rptDepWinlost_Transfer3rdOthers_UAT
drop table dbo.rptDepWinlost_Transfer3rdOthers_UAT
go

-- rptDepWinlost_BonusWallet_UAT
drop table dbo.rptDepWinlost_BonusWallet_UAT
go

-- rptDepWinlost_Main_UAT
drop table dbo.rptDepWinlost_Main_UAT
go

-- rptDepWinlost_Trans_UAT
drop table dbo.rptDepWinlost_Trans_UAT
go