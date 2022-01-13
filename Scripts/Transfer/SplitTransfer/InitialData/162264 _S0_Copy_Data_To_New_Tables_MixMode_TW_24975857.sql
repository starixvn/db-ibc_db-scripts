/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20211230@Sol
	DB : DBTRANS-bodb02
	Task: copy data to new table transfer and transferinfo - [Redmine: #162264]
*/

USE bodb02;

GO  

DECLARE @OutTransId TABLE (TransId BIGINT)
DECLARE @NewTransId BIGINT = 0
DECLARE @TransId BIGINT = 0

---insert into transfer table with transid = 108711261410
SET @TransId = 108711261410
INSERT INTO bodb02.dbo.Transfer
(
	CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
	SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
	SRecommend, Username, Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
	SerialNo, RepUpdateTime
)
OUTPUT INSERTED.TransId INTO @OutTransId(TransId)
SELECT
	b.CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
	SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
	SRecommend, b.Username, b.Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
	CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN '0' ELSE b.betcheck END
	, RepUpdateTime
FROM bodb02.dbo.bettrans b WITH(NOLOCK)
WHERE b.transid = @TransId

---insert into transferinfo table for bettype > 20000
SELECT TOP 1 @NewTransId = TransId FROM @OutTransId

INSERT INTO bodb02.dbo.TransferInfo
(
	TransId, APositiontaking, MPositiontaking, SPositiontaking, EPositiontaking, PlayerDiscount,
	Discount, ADiscount, SDiscount, WalletType, BonusID, Amount, CheckerId, CheckerName, IsCollection,
	IsDel,RepUpdateTime
)
SELECT  
	@NewTransId, b.apositiontaking, b.mpositiontaking, b.spositiontaking, b.epositiontaking,
	b.playerdiscount, b.discount, b.adiscount, b.sdiscount, b.WalletType, b.BonusID, b.oddsspread,
	CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN b.betid ELSE NULL END, --custid when verify/unverify
	CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN b.betcheck ELSE NULL END, --username when verify/unverify
	b.oddsid, b.liveindicator, b.RepUpdateTime
FROM bodb02.dbo.bettrans b WITH(NOLOCK)
WHERE b.transid = @TransId AND b.bettype > 20000



-------------------------------------------------------------

DELETE FROM @OutTransId
SET @NewTransId = 0

---insert into transfer table with transid = 108711261390
SET @TransId = 108711261390
INSERT INTO bodb02.dbo.Transfer
(
	CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
	SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
	SRecommend, Username, Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
	SerialNo, RepUpdateTime
)
OUTPUT INSERTED.TransId INTO @OutTransId(TransId)
SELECT
	b.CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
	SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
	SRecommend, b.Username, b.Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
	CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN '0' ELSE b.betcheck END
	, RepUpdateTime
FROM bodb02.dbo.bettrans b WITH(NOLOCK)
WHERE b.transid = @TransId

---insert into transferinfo table for bettype > 20000
SELECT TOP 1 @NewTransId = TransId FROM @OutTransId

INSERT INTO bodb02.dbo.TransferInfo
(
	TransId, APositiontaking, MPositiontaking, SPositiontaking, EPositiontaking, PlayerDiscount,
	Discount, ADiscount, SDiscount, WalletType, BonusID, Amount, CheckerId, CheckerName, IsCollection,
	IsDel,RepUpdateTime
)
SELECT  
	@NewTransId, b.apositiontaking, b.mpositiontaking, b.spositiontaking, b.epositiontaking,
	b.playerdiscount, b.discount, b.adiscount, b.sdiscount, b.WalletType, b.BonusID, b.oddsspread,
	CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN b.betid ELSE NULL END, --custid when verify/unverify
	CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN b.betcheck ELSE NULL END, --username when verify/unverify
	b.oddsid, b.liveindicator, b.RepUpdateTime
FROM bodb02.dbo.bettrans b WITH(NOLOCK)
WHERE b.transid = @TransId AND b.bettype > 20000

GO