/*<info serverAlias="DBTXN-bodb02" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE dbo.Transfer_ExecRep_01
(
	@TransIdList VARCHAR(MAX) = ''
)
AS
/*
    Created by: 20211227@Kathy
    Task: transfer SP 
    DB: DBTXN/BODB02 

	Revisions:
		- 20211231@Sol: copy data to transfer and transferInfo - [Redmine: #162264]
*/

BEGIN
	SET NOCOUNT ON

	CREATE TABLE #TransIdList(TransId BIGINT)
	
	---get list transid from string to temp table
	INSERT INTO #TransIdList(TransId)
	SELECT f.val
	FROM dbo.f_SplitString(@TransIdList, ',') f
	OPTION (MAXRECURSION 0)

	----insert data
	BEGIN
		---insert data to temp table by batch
		SELECT 
			b.transid, CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
			SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
			SRecommend, Username, Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
			b.betcheck, ISNULL(RepUpdateTime, SYSDATETIME()) AS RepUpdateTime,
			b.apositiontaking, b.mpositiontaking, b.spositiontaking, b.epositiontaking,
			b.playerdiscount, b.discount, b.adiscount, b.sdiscount, b.WalletType, b.BonusID, b.oddsspread,
			b.betid, b.oddsid, b.liveindicator
		INTO #BettransByBatch
		FROM dbo.bettrans b WITH(NOLOCK)
		WHERE b.transid IN (SELECT TransId FROM #TransIdList)

		---set identity ON
		SET IDENTITY_INSERT dbo.Transfer ON

		---insert into transfer table
		INSERT INTO dbo.Transfer
		(
			TransId, CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
			SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
			SRecommend, Username, Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
			SerialNo, RepUpdateTime
		)
		SELECT
			b.transid, b.CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
			SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
			SRecommend, b.Username, b.Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
			CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN '0' ELSE b.betcheck END
			, RepUpdateTime
		FROM #BettransByBatch b WITH(NOLOCK)

		---set identity OFF
		SET IDENTITY_INSERT dbo.Transfer OFF

		---insert into transferinfo table for bettype > 20000
		INSERT INTO dbo.TransferInfo
		(
			TransId, APositiontaking, MPositiontaking, SPositiontaking, EPositiontaking, PlayerDiscount,
			Discount, ADiscount, SDiscount, WalletType, BonusID, Amount, CheckerId, CheckerName, IsCollection,
			IsDel,RepUpdateTime
		)
		SELECT  
			b.transid, b.apositiontaking, b.mpositiontaking, b.spositiontaking, b.epositiontaking,
			b.playerdiscount, b.discount, b.adiscount, b.sdiscount, b.WalletType, b.BonusID, b.oddsspread,
			CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN b.betid ELSE NULL END, --custid when verify/unverify
			CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN b.betcheck ELSE NULL END, --username when verify/unverify
			b.oddsid, b.liveindicator, b.RepUpdateTime
		FROM #BettransByBatch b
		WHERE b.Bettype > 20000

		---drop table temp
		DROP TABLE #BettransByBatch

	END
	
	---drop table temp
	DROP TABLE #TransIdList

END
GO