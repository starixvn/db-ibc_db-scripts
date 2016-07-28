/*
	Created By: Helen
	Created Date: 20160719
	Task: Migrate data from phase 1 to phase 2 for CWL
	DB: DBCUST
	
	1. DBcust.custdb.dbo.WinLimit_CustSetting
	2. DBPRO.bodb02.dbo.WinLimit_GlobalSetting 
	3. DBTXN.bodb02.dbo.WinLimit_Game
	4. DBLOG.bodb_CustomerLog.dbo.WinLimit_Game_History

*/

USE CustDB
----------- DATA PREPARATION ------------------

SELECT CustID, ProductID, MaxWinLimit
INTO #playerSetting_phase1
FROM DBcust.custdb.dbo.WinLimit_CustSetting WITH (NOLOCK)

SELECT CustID, ProductID, MaxWinLimit, TotalWinAmt, IsBlocked, BlockedDate, UnBlockedDate, IsNotified, Bettype, BlockedWinAmt, ModifiedBy, CreatedBy, WinlostDate
INTO #Game_DetectBlock_phase1
FROM DBTXN.bodb02.dbo.WinLimit_Game WITH (NOLOCK)

SELECT CustID, ProductID, MaxWinLimit, TotalWinAmt, IsBlocked, BlockedDate, UnBlockedDate, IsNotified, Bettype, BlockedWinAmt, ModifiedBy, CreatedBy, WinlostDate
INTO #Game_DetectBlock_history_phase1
FROM DBLOG.bodb_CustomerLog.dbo.WinLimit_Game_History WITH (NOLOCK)

----------- END OF DATA PREPARATION ------------------
-- INSERT Player setting --------
INSERT INTO WinLimit_CustGameSetting (CustID, ProductID, BettypeID, LevelID, MaxWinLimit)
SELECT CustID, ps.ProductID, ps.BettypeID, LevelID, CASE WHEN ps.LevelID IN (1,2) THEN 0 ELSE MaxWinLimit END AS MaxWinLimit
FROM #playerSetting_phase1 cs
	INNER JOIN Winlimit_ProductSetting  ps WITH (NOLOCK) ON cs.ProductID = ps.ProductID

-- Insert Cust Status --------
INSERT INTO WinLimit_CustGameStatus (CustID, ProductID, BettypeID, IsBlockedPlaceBet, IsBlockedTransfer, ActionID, ModifiedDate)
 
SELECT G.CustID, G.ProductID, PS.BettypeID, 0 IsBlockedPlaceBet, ISNULL(G.IsBlocked,0) AS IsBlockedTransfer
		, CASE WHEN G.IsBlocked = 1 THEN 3  -- Block transfer
			   WHEN	G.IsBlocked = 0 AND UnBlockedDate IS NOT NULL THEN 4 -- Unblock transfer
			   ELSE 0 END AS ActionID
		, g.BlockedDate AS ModifiedDate
FROM (SELECT *, ROW_NUMBER () OVER (PARTITION BY Custid, productid order by BlockedDate DESC) AS Row_Index
	  FROM #Game_DetectBlock_phase1 ) AS G
		INNER JOIN Winlimit_ProductSetting PS WITH (NOLOCK)	 ON PS.ProductID = G.ProductID AND PS.LevelID = 3
WHERE G.Row_Index = 1	

-- INSERT Detect block ----------

INSERT INTO WinLimit_CustGameMonitoring (CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ModifiedDate, IsNotified, ModifiedBy, CreatedBy)
SELECT G.CustID, G.ProductID, PS.BettypeID, G.WinlostDate, PS.LevelID, G.MaxWinLimit, G.TotalWinAmt,G.BlockedWinAmt AS WinAmt, BlockedDate AS ModifiedDate
		, G.IsNotified, G.ModifiedBy, G.CreatedBy
FROM #Game_DetectBlock_phase1 G
	INNER JOIN Winlimit_ProductSetting PS WITH (NOLOCK)	 ON PS.ProductID = G.ProductID AND PS.LevelID = 3
	
-- INSERT Detect block history -----

INSERT INTO WinLimit_CustGameMonitoring_History (CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ActionID, ModifiedDate, IsNotified, ModifiedBy, CreatedBy)
SELECT G.CustID, G.ProductID, PS.BettypeID, G.WinlostDate, PS.LevelID, G.MaxWinLimit, G.TotalWinAmt, G.BlockedWinAmt AS WinAmt
		, CASE WHEN G.IsBlocked = 1 THEN 3  -- Block transfer
			   WHEN	G.IsBlocked = 0 AND UnBlockedDate IS NOT NULL THEN 4 -- Unblock transfer
			   ELSE 0 END AS ActionID
			   
		, BlockedDate AS ModifiedDate, G.IsNotified, G.ModifiedBy, G.CreatedBy
FROM #Game_DetectBlock_history_phase1 G
	INNER JOIN Winlimit_ProductSetting PS WITH (NOLOCK)	 ON PS.ProductID = G.ProductID AND PS.LevelID = 3

