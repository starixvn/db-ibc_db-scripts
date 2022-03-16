/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20220303@Sol
	DB : DBTRANS-bodb02
	Task: update data table transfer and transferinfo - [Redmine: #162264]
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

		---update transfer table
		UPDATE t
			SET
				t.CustId = b.CustId
				,t.TransDate = b.TransDate 
				,t.WinlostDate = b.WinlostDate 
				,t.Bettype = b.Bettype 
				,t.Stake = b.Stake 
				,t.Actual_Stake = b.Actual_Stake 
				,t.Winlost = b.Winlost 
				,t.AWinlost = b.AWinlost 
				,t.MWinlost = b.MWinlost
				,t.SWinlost = b.SWinlost
				,t.PlayerComm = b.PlayerComm 
				,t.Comm = b.Comm 
				,t.AComm = b.AComm 
				,t.SComm = b.SComm 
				,t.StatusId = b.StatusId 
				,t.RefNo = b.RefNo 
				,t.TransDesc = b.TransDesc 
				,t.Recommend = b.Recommend 
				,t.MRecommend = b.MRecommend 
				,t.SRecommend = b.SRecommend 
				,t.Username = b.Username 
				,t.Currency = b.Currency 
				,t.CurrencyName = b.CurrencyName 
				,t.ActualRate = b.ActualRate 
				,t.Creator = b.Creator 
				,t.Balance = b.Balance 
				,t.IP = b.IP 
				,t.CheckTime = b.CheckTime
				,t.SerialNo = CASE WHEN ISNULL(b.betid, 0) NOT IN (0, 1) AND b.betcheck <> '0' THEN '0' ELSE b.betcheck END 
				,t.RepUpdateTime = b.RepUpdateTime
		FROM dbo.Transfer t
			INNER JOIN #BettransByBatch b
				ON t.TransId = b.transid

		---insert into transferinfo table for bettype > 20000
		UPDATE t
			SET
				t.APositiontaking = b.APositiontaking
				,t.MPositiontaking = b.MPositiontaking
				,t.SPositiontaking = b.SPositiontaking
				,t.EPositiontaking = b.EPositiontaking
				,t.PlayerDiscount = b.PlayerDiscount
				,t.Discount = b.Discount
				,t.ADiscount = b.ADiscount
				,t.SDiscount = b.SDiscount
				,t.WalletType = b.WalletType
				,t.BonusID = b.BonusID
				,t.Amount = b.oddsspread
				,t.CheckerId = CASE WHEN ISNULL(b.betid, 0) <> 0 AND b.betcheck <> '0' THEN b.betid ELSE NULL END
				,t.CheckerName = CASE WHEN ISNULL(b.betid, 0) NOT IN (0, 1) AND b.betcheck <> '0' THEN b.betcheck ELSE NULL END
				,t.IsCollection = b.oddsid
				,t.IsDel = b.liveindicator
				,t.RepUpdateTime = b.RepUpdateTime
		FROM dbo.TransferInfo t
			INNER JOIN #BettransByBatch b
				ON t.TransId = b.transid
		WHERE b.Bettype > 20000

		---drop table temp
		DROP TABLE #BettransByBatch

	END
	
	---drop table temp
	DROP TABLE #TransIdList

GO