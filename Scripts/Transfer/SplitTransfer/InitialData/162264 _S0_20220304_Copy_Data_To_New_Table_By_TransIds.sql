/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20220304@Sol
	DB : DBTRANS-bodb02
	Task: insert data table transfer and transferinfo - [Redmine: #162264]
*/

USE bodb02;

GO  

DECLARE
	@TransIdList VARCHAR(MAX) = ''

	SET NOCOUNT ON

	CREATE TABLE #TransIdList(TransId BIGINT)
	
	---get list transid from string to temp table
	INSERT INTO #TransIdList(TransId)
	SELECT f.val
	FROM dbo.f_SplitString(@TransIdList, ',') f
	OPTION (MAXRECURSION 0)

	---output transid from Transfer table to use in TransferInfo
	DECLARE @TransferTransId TABLE(TransferTransId BIGINT, bettransTransId BIGINT)

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
		
		---insert into transfer table
		;MERGE
			INTO dbo.Transfer AS t
			USING
			(
				SELECT
					b.transid, b.CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
					SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
					SRecommend, b.Username, b.Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
					CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN '0' ELSE b.betcheck END AS SerialNo
					, RepUpdateTime
				FROM #BettransByBatch b WITH(NOLOCK)
			) AS src
			ON t.TransId = src.transid
			WHEN NOT MATCHED BY TARGET THEN
				INSERT 
				(
					CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
					SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
					SRecommend, Username, Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
					SerialNo, RepUpdateTime
				)
				VALUES
				(
					CustId, TransDate, WinlostDate, Bettype, Stake, Actual_Stake, Winlost, AWinlost, MWinlost,
					SWinlost, PlayerComm, Comm, AComm, SComm, StatusId, RefNo, TransDesc, Recommend, MRecommend, 
					SRecommend, Username, Currency, CurrencyName, ActualRate, Creator, Balance, IP, CheckTime,
					SerialNo, RepUpdateTime
				)
			OUTPUT INSERTED.TransId, src.transid INTO @TransferTransId(TransferTransId, bettransTransId);
		
		---insert into transferinfo table for bettype > 20000
		INSERT INTO dbo.TransferInfo
		(
			TransId, APositiontaking, MPositiontaking, SPositiontaking, EPositiontaking, PlayerDiscount,
			Discount, ADiscount, SDiscount, WalletType, BonusID, Amount, CheckerId, CheckerName, IsCollection,
			IsDel,RepUpdateTime
		)
		SELECT  
			t.TransferTransId, b.apositiontaking, b.mpositiontaking, b.spositiontaking, b.epositiontaking,
			b.playerdiscount, b.discount, b.adiscount, b.sdiscount, b.WalletType, b.BonusID, b.oddsspread,
			CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN b.betid ELSE NULL END, --custid when verify/unverify
			CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN b.betcheck ELSE NULL END, --username when verify/unverify
			b.oddsid, b.liveindicator, b.RepUpdateTime
		FROM #BettransByBatch b
			INNER JOIN @TransferTransId t
				ON b.transid = t.bettransTransId
		WHERE b.Bettype > 20000

		---drop table temp
		DROP TABLE #BettransByBatch

	END
	
	---drop table temp
	DROP TABLE #TransIdList

GO