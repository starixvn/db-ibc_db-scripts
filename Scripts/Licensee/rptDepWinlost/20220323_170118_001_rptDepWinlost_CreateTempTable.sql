/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220322@Percy
	DB: DBRPT-bodb_Report
	Task: Regen data on rptDepWinlost
		- Step 1: Create table _UAT
*/
use bodb_Report
go

-- rptDepCust_UAT
create table dbo.rptDepCust_UAT (
	id int identity(1, 1), custid int, init_winlostdate smalldatetime, regen_winlostdate smalldatetime
	,constraint PK_rptDepCust_UAT primary key (custid)
)
go

-- rptDepWinlost_UAT
create table dbo.rptDepWinlost_UAT (
	winlostdate smalldatetime, custid int, currency int, OpeningBalance money, Deposit money, Withdrawal money, Aff2MemTransfer money, Bonus money, Adjustment money
	,Turnover money, Outstanding money, Winloss money, ClosingBalance money, recommend int, mrecommend int, srecommend int, actualrate float
	,Transfer3rd money, DrawGame money, Turnover_BA money, Comm_BA money, AmountDueTo_BA money, playercomm money, Transfer3rdOthers money
	,Comm_BetTrade money, AmountDueTo_BetTrade money, Promotion	money
	,constraint PK_rptDepWinlost_UAT primary key (custid, winlostdate)
) on ps_DepWLBK_monthly
go

-- rptDepWinlostByProduct_UAT
create table dbo.rptDepWinlostByProduct_UAT (
	winlostdate datetime, custid int, sporttype smallint, turnover money, drawTO money, winlost money, playercomm money, BetCount int, Outstanding money, currency int
	,constraint PK_rptDepWinlostByProduct_UAT primary key (custid, winlostdate, sporttype)
) on ps_DepWLbyProductBK_monthly2
go

-- rptDepWinlost_Transfer3rdOthers_UAT
create table dbo.rptDepWinlost_Transfer3rdOthers_UAT (
	winlostdate smalldatetime, CustId int, Currency int, PartnerId int, Recommend int, MRecommend int, SRecommend int, TransferAmount money, TransferIn money, TransferOut money
	,constraint PK_rptDepWinlost_Transfer3rdOthers_UAT primary key (winlostdate, CustId, PartnerId)
) on DepWL
go

-- rptDepWinlost_BonusWallet_UAT
create table dbo.rptDepWinlost_BonusWallet_UAT (
	Winlostdate smalldatetime, CustID int, BonusType tinyint, Bonus money, Adjustment money
	,constraint PK_rptDepWinlost_BonusWallet_UAT primary key (Winlostdate, CustID, BonusType)
) on RS_rptDepWL_Utility
go

-- rptDepWinlost_Main_UAT
create table dbo.rptDepWinlost_Main_UAT (
	Winlostdate smalldatetime, CustID int, OpeningBalance money, actualrate float, srecommend int, mrecommend int, recommend int, currency int
	,constraint PK_rptDepWinlost_Main_UAT primary key (Winlostdate, CustID)
) on RS_rptDepWL_Main
go

-- rptDepWinlost_Trans_UAT
create table dbo.rptDepWinlost_Trans_UAT (
	Winlostdate smalldatetime, CustID int, SportType smallint, PartnerID int, Deposit money, Withdrawal money, Aff2MemTransfer money, Bonus money, Adjustment money
	,Turnover money, Outstanding money, Winloss money, Transfer3rd money, DrawGame money, Turnover_BA money, Comm_BA money, AmountDueTo_BA money, playercomm money
	,Transfer3rdOthers money, Comm_BetTrade money, Comm_Bettrade_Full money, AmountDueTo_BetTrade money, BetCount int, TransferAmount money, TransferIn money, TransferOut money, Promotion money
	,constraint PK_rptDepWinlost_Trans_UAT primary key (Winlostdate, CustID, SportType, PartnerID)
) on RS_rptDepWL_Trans
go