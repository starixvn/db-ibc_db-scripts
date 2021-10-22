/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20210927@Percy
	DBRPT-bodb_Report
	Task: Gen data for apositiontaking column (rptLicWinloss2)
	Step 1: Create temp table
*/
use bodb_Report
go

create table dbo.bettrans_temp
(
	transid bigint
	,custid int
	,winlostdate smalldatetime
	,matchid int
	,bettype int
	,liveawayscore smallint
	,statusID tinyint
	,stake money
	,actual_stake money
	,winlost money
	,awinlost money
	,mwinlost money
	,swinlost money
	,playercomm money
	,comm money
	,acomm money
	,scomm money
	,virtualrate float
	,currency int
	,oddsspread money
	,modds smallmoney
	,betfrom nvarchar(1)
	,apositiontaking smallmoney
)
go

create clustered index CIX_bettrans_temp on dbo.bettrans_temp (winlostdate, custid)
go

create table dbo.rptLicWinloss2_temp
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
)
go

create clustered index CIX_rptLicWinloss2_temp on dbo.rptLicWinloss2_temp (winlostdate)
go