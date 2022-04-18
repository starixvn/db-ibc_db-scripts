/*<info serverAlias="DBACC-bodb02" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[TASK_rptDepWinlost_14]
	@WinlostDate SMALLDATETIME
AS

/*
	Created: 20220317@Percy
	DB: DBACC.bodb02
	Task:
	Revisions:
		- 20220317@Percy: Initialize SP [RedmineID: #167035]
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @Prev_WinlostDate SMALLDATETIME = DATEADD(DAY, -1, @WinlostDate)
	
	DECLARE @MinSumDate SMALLDATETIME
	SELECT  @MinSumDate = MIN(WinlostDate) FROM bodb_Report.dbo.rptDepWinlost_Main WITH (NOLOCK)

	-- List customer
	DECLARE @Customer TABLE (custid INT, recommend INT, mrecommend INT, srecommend INT, currency INT, OpeningBalance MONEY DEFAULT(0))
	INSERT INTO @Customer (custid, recommend, mrecommend, srecommend, currency)
	SELECT c.custid, c.recommend, c.mrecommend, c.srecommend, c.currency
	FROM bodb_Report.dbo.rptDepCust_UAT r WITH (NOLOCK)
		INNER JOIN dbo.Customer c WITH (NOLOCK) ON r.custid = c.custid
	WHERE r.regen_winlostdate <= @WinlostDate

	-- Initialize Opening Balance
	IF @Prev_WinlostDate < @MinSumDate
		UPDATE c
		SET c.OpeningBalance = r.ClosingBalance
		FROM @Customer c
			INNER JOIN bodb_Report.dbo.rptDepWinlost_UAT r WITH (NOLOCK) ON c.custid = r.custid AND r.winlostdate = @Prev_WinlostDate
	ELSE
		UPDATE c
		SET c.OpeningBalance =  m.OpeningBalance
								+ ISNULL(t.Deposit, 0) + ISNULL(t.Aff2MemTransfer, 0) - ISNULL(t.Withdrawal, 0) + ISNULL(t.Bonus, 0) 
								+ ISNULL(t.Adjustment, 0) - ISNULL(t.Outstanding, 0) + ISNULL(t.Winloss, 0) + ISNULL(t.playercomm, 0)
								+ ISNULL(t.Transfer3rd, 0) + ISNULL(t.Transfer3rdOthers, 0) - ISNULL(t.Comm_BetTrade_Full, 0)
								+ ISNULL(t.Promotion, 0) + ISNULL(b.Bonus, 0) + ISNULL(b.Adjustment, 0)
		FROM @Customer c
			INNER JOIN bodb_Report.dbo.rptDepWinlost_Main_UAT m WITH (NOLOCK) ON c.custid = m.custid AND m.winlostdate = @Prev_WinlostDate
			LEFT JOIN bodb_Report.dbo.rptDepWinlost_Trans_UAT t WITH (NOLOCK) ON m.Winlostdate = t.Winlostdate AND m.custid = t.custid AND t.SportType = -1 AND t.PartnerID = -1
			LEFT JOIN bodb_Report.dbo.rptDepWinlost_BonusWallet_UAT b WITH (NOLOCK) ON m.Winlostdate = b.Winlostdate AND m.custid = b.custid

	DECLARE @CasinoPartner TABLE (PartnerId INT, TransferId INT, CancelTransferId INT)

	INSERT INTO @CasinoPartner(PartnerId, TransferId, CancelTransferId)
	SELECT PartnerId, TransferId, CancelTransferId
	FROM bodb_report.dbo.tblCasinoPartners WITH(NOLOCK)
	WHERE TransferId IS NOT NULL OR CancelTransferId IS NOT NULL

	-- For Bonus
	DECLARE @BonusList TABLE (BonusType TINYINT, BonusBettype INT, AdjustmentBettype INT)

	INSERT INTO @BonusList(BonusType, BonusBettype, AdjustmentBettype)
	VALUES (1, 22200, 22201) -- Bonus Wallet

	CREATE TABLE #rptDepWinlostDetails
	(
		CustID						INT
		,PartnerID					INT DEFAULT(-1)
		,Bettype					INT
		,Deposit					MONEY DEFAULT(0)
		,Withdrawal					MONEY DEFAULT(0)
		,Aff2MemTransfer			MONEY DEFAULT(0)
		,Bonus						MONEY DEFAULT(0)
		,Adjustment					MONEY DEFAULT(0)
		,TurnOver					MONEY DEFAULT(0)
		,OutStanding				MONEY DEFAULT(0)
		,Winloss					MONEY DEFAULT(0)
		,Transfer3rd				MONEY DEFAULT(0)
		,DrawGame					MONEY DEFAULT(0)
		,Turnover_BA				MONEY DEFAULT(0)
		,Comm_BA					MONEY DEFAULT(0)
		,AmountDueTo_BA				MONEY DEFAULT(0)
		,playercomm					MONEY DEFAULT(0)
		,Transfer3rdOthers			MONEY DEFAULT(0)
		,Transfer3rdOthers_In		MONEY DEFAULT(0)
		,Transfer3rdOthers_Out		MONEY DEFAULT(0)
		,Comm_BetTrade				MONEY DEFAULT(0)
		,Comm_BetTrade_Full			MONEY DEFAULT(0)
		,WLBoughtTicket_BetTrade	MONEY DEFAULT(0)
		,AmountDueTo_BetTrade		MONEY DEFAULT(0)
		,BetCount					INT DEFAULT(0)
		,BonusWallet				MONEY DEFAULT(0)
		,AdjBonusWallet				MONEY DEFAULT(0)
		,Promotion					MONEY DEFAULT(0)
		,UNIQUE CLUSTERED (CustID, PartnerID, Bettype)
	)

	CREATE TABLE #rptDepWinlost
	(
		CustID						INT
		,Deposit					MONEY DEFAULT(0)
		,Withdrawal					MONEY DEFAULT(0)
		,Aff2MemTransfer			MONEY DEFAULT(0)
		,Bonus						MONEY DEFAULT(0)
		,Adjustment					MONEY DEFAULT(0)
		,TurnOver					MONEY DEFAULT(0)
		,OutStanding				MONEY DEFAULT(0)
		,Winloss					MONEY DEFAULT(0)
		,Transfer3rd				MONEY DEFAULT(0)
		,DrawGame					MONEY DEFAULT(0)
		,Turnover_BA				MONEY DEFAULT(0)
		,Comm_BA					MONEY DEFAULT(0)
		,AmountDueTo_BA				MONEY DEFAULT(0)
		,playercomm					MONEY DEFAULT(0)
		,Transfer3rdOthers			MONEY DEFAULT(0)
		,Comm_BetTrade				MONEY DEFAULT(0)
		,Comm_BetTrade_Full			MONEY DEFAULT(0)
		,WLBoughtTicket_BetTrade	MONEY DEFAULT(0)
		,AmountDueTo_BetTrade		MONEY DEFAULT(0)
		,BonusWallet				MONEY DEFAULT(0)
		,AdjBonusWallet				MONEY DEFAULT(0)
		,Promotion					MONEY DEFAULT(0)
		,UNIQUE CLUSTERED (CustID)
	)

	CREATE TABLE #rptDepWinlostByProduct
	(
		CustID			INT
		,SportType		SMALLINT
		,turnover		MONEY DEFAULT(0)
		,drawTO			MONEY DEFAULT(0)
		,Winlost		MONEY DEFAULT(0)
		,playercomm		MONEY DEFAULT(0)
		,BetCount		INT DEFAULT(0)
		,OutStanding	MONEY DEFAULT(0)
		,UNIQUE CLUSTERED (CustID, SportType)
	)

	CREATE TABLE #rptDepWinlostTransfer3rdOthers
	(
		CustID			INT
		,PartnerID		INT
		,TransferAmount	MONEY DEFAULT(0)
		,TransferIn		MONEY DEFAULT(0)
		,TransferOut	MONEY DEFAULT(0)
		,UNIQUE CLUSTERED (CustID, PartnerID)
	)

	CREATE TABLE #rptDepWinlostBonusWallet
	(
		CustID		INT
		,BonusType	TINYINT DEFAULT(1)
		,Bonus		MONEY DEFAULT(0)
		,Adjustment	MONEY DEFAULT(0)
		UNIQUE CLUSTERED (CustID, BonusType)
	)

	-- #rptDepWinlostDetails
	BEGIN
		INSERT INTO #rptDepWinlostDetails (CustID, BetType, TurnOver, Winloss, DrawGame, playercomm, Comm_BetTrade, Comm_BetTrade_Full, WLBoughtTicket_BetTrade, BetCount, Promotion)
		SELECT b.custid
			,CASE
				WHEN b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150 THEN -150
				WHEN b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173 THEN -173
				ELSE b.bettype END AS BetType
			,SUM(CASE WHEN b.StatusID NOT IN (101, 102, 103) THEN b.stake ELSE 0 END) AS Turnover
			,SUM(CASE
					WHEN b.bettype IN (4300, 4299, 4298, 4297, 3007, 1906, 1698, 1699, 3898, 3899, 4599, 4600) THEN 0
					WHEN b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150 THEN 0
					WHEN b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173 THEN 0
					WHEN b.bettype BETWEEN 17000 AND 17030 THEN 0
					ELSE b.winlost - b.actual_stake END) AS Winloss
			,SUM(CASE WHEN b.statusID = 111 THEN b.stake ELSE 0 END) AS DrawGame
			,SUM(b.playercomm) AS playercomm
			,SUM(CASE WHEN b.bettype = 903 AND b.statusID NOT IN (101, 102, 103) THEN b.awinlost ELSE 0 END) AS Comm_BetTrade
			,SUM(CASE WHEN b.bettype = 903 AND b.statusID NOT IN (101, 102, 103) THEN b.winlost - b.actual_stake ELSE 0 END) AS Comm_BetTrade_Full
			,SUM(CASE WHEN b.bettype = 902 AND b.statusID NOT IN (101, 102, 103) THEN b.winlost - b.actual_stake ELSE 0 END) AS WLBoughtTicket_BetTrade
			,SUM(CASE WHEN b.StatusID NOT IN (101, 102, 103) THEN 1 ELSE 0 END) AS BetCount
			,SUM(CASE
					WHEN b.bettype IN (4300, 4299, 4298, 4297, 3007, 1906, 1698, 1699, 3898, 3899, 4599, 4600) THEN b.winlost - b.actual_stake
					WHEN b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150 THEN b.winlost - b.actual_stake
					WHEN b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173 THEN b.winlost - b.actual_stake
					WHEN b.bettype BETWEEN 17000 AND 17030 THEN b.winlost - b.actual_stake
					ELSE 0 END) AS Promotion
		FROM dbo.bettrans14 b WITH (NOLOCK)
			INNER JOIN @Customer c ON b.custid = c.custid
		WHERE b.winlostdate = @WinlostDate AND b.betType <> 999 -- Licensee OddsSpread
		GROUP BY b.custid
			,CASE
				WHEN b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150 THEN -150
				WHEN b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173 THEN -173
				ELSE b.bettype END

		INSERT INTO #rptDepWinlostDetails (CustID, BetType, PartnerId, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Transfer3rd, BonusWallet, AdjBonusWallet, Transfer3rdOthers, Transfer3rdOthers_In, Transfer3rdOthers_Out)
		SELECT b.custId, b.bettype, ISNULL(p.PartnerId, -1) AS PartnerId
			,SUM(CASE WHEN b.bettype = 22001 THEN b.Winlost - b.Actual_Stake ELSE 0 END) AS Deposit
			,-SUM(CASE WHEN b.bettype IN (22002, 22003) THEN b.Winlost - b.Actual_Stake ELSE 0 END) AS Withdrawal
			,SUM(CASE WHEN b.bettype = 21006 THEN b.Winlost - b.Actual_Stake ELSE 0 END) AS Aff2MemTransfer
			,SUM(CASE WHEN b.bettype IN (22004, 22202) THEN b.Winlost - b.Actual_Stake ELSE 0 END) AS Bonus
			,SUM(CASE WHEN b.bettype IN (21001, 21002, 21003, 21004, 21005, 22005, 22203) THEN b.Winlost - b.Actual_Stake ELSE 0 END) AS Adjustment
			,SUM(CASE WHEN b.bettype IN (22006, 22007) THEN b.Winlost - b.Actual_Stake ELSE 0 END) AS Transfer3rd
			,SUM(CASE WHEN b.bettype = 22200 THEN b.Winlost - b.Actual_Stake ELSE 0 END) AS BonusWallet
			,SUM(CASE WHEN b.bettype = 22201 THEN b.Winlost - b.Actual_Stake ELSE 0 END) AS AdjBonusWallet
			,SUM(CASE
					WHEN p.TransferId IS NULL AND p.CancelTransferId IS NULL THEN 0
					ELSE b.Winlost - b.Actual_Stake END) AS Transfer3rdOthers
			,SUM(CASE
					WHEN p.TransferId IS NULL AND p.CancelTransferId IS NULL THEN 0
					WHEN b.Winlost - b.Actual_Stake > 0 THEN 0
					ELSE -(b.Winlost - b.Actual_Stake) END) AS Transfer3rdOthers_In
			,SUM(CASE
					WHEN p.TransferId IS NULL AND p.CancelTransferId IS NULL THEN 0
					WHEN b.Winlost - b.Actual_Stake < 0 THEN 0
					ELSE -(b.Winlost - b.Actual_Stake) END) AS Transfer3rdOthers_Out
		FROM dbo.transfer b WITH (NOLOCK)
			INNER JOIN @Customer c ON b.custid = c.custid
			LEFT JOIN @CasinoPartner p ON b.bettype IN (p.TransferId, p.CancelTransferId)
		WHERE b.winlostdate = @WinlostDate
		GROUP BY b.custId, b.bettype, ISNULL(p.PartnerId, -1)
	END

	-- #rptDepWinlost
	BEGIN
		INSERT INTO #rptDepWinlost (CustID, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, TurnOver, OutStanding, Winloss, Transfer3rd, DrawGame, playercomm, Transfer3rdOthers, Comm_BetTrade, Comm_BetTrade_Full, WLBoughtTicket_BetTrade, BonusWallet, AdjBonusWallet, Promotion)
		SELECT CustID, SUM(Deposit), SUM(Withdrawal), SUM(Aff2MemTransfer),  SUM(Bonus), SUM(Adjustment), SUM(Turnover), SUM(Outstanding), SUM(Winloss), SUM(Transfer3rd), SUM(DrawGame), SUM(Playercomm), SUM(Transfer3rdOthers), SUM(Comm_BetTrade), SUM(Comm_BetTrade_Full), SUM(WLBoughtTicket_BetTrade), SUM(BonusWallet), SUM(AdjBonusWallet), SUM(Promotion)
		FROM #rptDepWinlostDetails
		WHERE Bettype NOT IN (913, 914)
		GROUP BY CustID

		-- Update for BA
		UPDATE r
		SET r.Turnover_BA = t.Turnover_BA, r.Comm_BA = t.Comm_BA, r.AmountDueTo_BA = t.AmountDueTo_BA
		FROM #rptDepWinlost r
			INNER JOIN (
				SELECT b.custid
					,SUM(b.stake) AS Turnover_BA
					,SUM(b.comm) AS Comm_BA
					,-SUM(b.winlost - b.actual_stake + b.awinlost + b.comm) AS AmountDueTo_BA
				FROM dbo.bettrans14 b WITH (NOLOCK)
					INNER JOIN @Customer c ON b.custid = c.custid
					INNER JOIN bodb_Licensee.dbo.LicenseeBATransaction_active ba WITH (NOLOCK) ON b.transid = ba.transid
				WHERE b.winlostdate = @WinlostDate
					AND b.statusID NOT IN (101, 102, 103)
				GROUP BY b.custid
			) AS t ON r.CustID = t.CustID

		-- Update for BT
		UPDATE r
		SET r.AmountDueTo_BetTrade = t.WLBeticket + r.WLBoughtTicket_BetTrade - r.Comm_BetTrade
		FROM #rptDepWinlost r
			INNER JOIN (
				SELECT b.custid
					,SUM(CASE WHEN b.bettype NOT IN (902, 903) THEN b.winlost - b.actual_stake ELSE 0 END) AS WLBeticket -- WL of bet ticket of bettrade
				FROM dbo.bettrans14 b WITH (NOLOCK)
					INNER JOIN @Customer c ON b.custid = c.custid
					INNER JOIN dbo.f_GetBetTradeCustList('All') bt ON c.custid = bt.custid
				WHERE b.winlostdate = @WinlostDate
					AND b.statusID NOT IN (101, 102, 103)
				GROUP BY b.custid
			) AS t ON r.CustID = t.CustID

		-- Delete redundant data
		DELETE #rptDepWinlost
		WHERE Deposit = 0
			AND Withdrawal = 0
			AND Aff2MemTransfer = 0
			AND Bonus = 0
			AND Adjustment = 0
			AND TurnOver = 0
			AND OutStanding = 0
			AND Winloss = 0
			AND Transfer3rd = 0
			AND DrawGame = 0
			AND Turnover_BA = 0
			AND Comm_BA = 0
			AND AmountDueTo_BA = 0
			AND playercomm = 0
			AND Transfer3rdOthers = 0
			AND Comm_BetTrade = 0
			AND AmountDueTo_BetTrade = 0
			AND BonusWallet = 0
			AND AdjBonusWallet = 0
			AND Promotion = 0
	END

	-- #rptDepWinlostByProduct
	BEGIN
		INSERT INTO #rptDepWinlostByProduct (CustID, SportType, turnover, drawTO, Winlost, playercomm, BetCount)
		SELECT CustID
			,CASE
				WHEN bettype BETWEEN 81 AND 120 THEN 161 --Number Game
				WHEN bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game: Happy 5
				WHEN bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
				WHEN bettype IN (71, 72, 23002) THEN 251 --Casino
				WHEN bettype = 1000 THEN 253 --games
				WHEN bettype BETWEEN 1201 AND 1299 THEN 180 --Virtual Sport
				WHEN bettype BETWEEN 1501 AND 1599 THEN 202 --Keno
				WHEN bettype BETWEEN 18000 AND 18006 THEN 204 --Colossus Bet
				WHEN bettype BETWEEN 4001 AND 4100 THEN 212 --Voidbridge
				WHEN bettype = 901 THEN -2 --BetTrade - Sold
				WHEN bettype = 902 THEN -3 --BetTrade - Bought.
				WHEN bettype = 903 THEN -4 --BetTrade - Commission
				WHEN bettype = 904 THEN -5 --BetTrade - Winloss
				WHEN bettype = 911 THEN -6 --Cash Out - Sold
				WHEN bettype = 912 THEN -7 --Cash Out - Bought.
				WHEN bettype = 913 THEN -8 --Cash Out - Commission
				WHEN bettype = 914 THEN -9 --Cash Out - Winloss
				WHEN bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
				WHEN bettype BETWEEN 1700 AND 1799 THEN 255 -- GD
				WHEN bettype = 1900 THEN 249 -- VG
				WHEN bettype BETWEEN 2101 AND 2199 THEN 208
				WHEN bettype BETWEEN 2201 AND 2299 THEN 209
				WHEN (bettype BETWEEN 2301 AND 2399 OR bettype BETWEEN 2901 AND 2999) THEN 210
				WHEN bettype BETWEEN 2401 AND 2499 THEN 211
				WHEN bettype BETWEEN 1011 AND 1020 THEN 219
				WHEN bettype BETWEEN 2701 AND 2799 THEN 190 -- Betradar VS
				WHEN bettype BETWEEN 2800 AND 2829 THEN 193 -- Betradar VS: Virtual Basketball
				WHEN bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
				WHEN bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
				WHEN bettype BETWEEN 4101 AND 4296 OR bettype BETWEEN 6701 AND 7000 THEN 248 -- PP
				WHEN bettype BETWEEN 4297 AND 4300 THEN -248 -- PP Prize
				WHEN (bettype BETWEEN 1901 AND 1999 AND bettype <> 1906) THEN 165 -- CC
				WHEN bettype = 1906 THEN -165 -- Bonus
				WHEN bettype BETWEEN 4301 AND 4598 THEN 247 -- SG
				WHEN bettype BETWEEN 4599 AND 4600 THEN -247 -- SG Jackpot Contribution and Jackpot Prize
				WHEN bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
				WHEN bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
				WHEN bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
				WHEN bettype BETWEEN 3101 AND 3149 THEN 243 -- AE Casino
				WHEN bettype = 3150 THEN -243 -- AE Casino Lucky Draw
				WHEN bettype BETWEEN 1611 AND 1697 THEN 200 -- SBC
				WHEN bettype = -150 THEN 150 -- SBC Free Bets
				WHEN bettype BETWEEN 1698 AND 1699 THEN -200 -- SBC Prize
				WHEN bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
				WHEN bettype = 3007 THEN -244 -- SAG Tip ticket
				WHEN bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
				WHEN (bettype BETWEEN 3001 AND 3099 AND bettype <> 3007) THEN 244 -- SAG
				WHEN bettype BETWEEN 5701 AND 5799 THEN 236 -- GDG
				WHEN bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
				WHEN bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
				WHEN bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
				WHEN bettype BETWEEN 3801 AND 3897 THEN 171 -- VGA
				WHEN bettype = -173 THEN 173 -- VGA Free Bets
				WHEN bettype BETWEEN 3898 AND 3899 THEN -171 -- VGA Prize
				WHEN bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba promotion
				WHEN bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
				WHEN bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
				WHEN bettype BETWEEN 7701 AND 7799 THEN 172 -- AP
				WHEN bettype BETWEEN 7801 AND 7899 THEN 174 -- APM
				ELSE 0 END AS SportType
			,SUM(TurnOver) AS Turnover
			,SUM(DrawGame) AS drawTO
			,SUM(Promotion + Winloss) AS Winloss
			,SUM(playercomm) AS Playercomm
			,SUM(BetCount) AS BetCount
		FROM #rptDepWinlostDetails
		WHERE Bettype < 19999 AND PartnerID = -1
		GROUP BY CustID
			,CASE
				WHEN bettype BETWEEN 81 AND 120 THEN 161 --Number Game
				WHEN bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game: Happy 5
				WHEN bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
				WHEN bettype IN (71, 72, 23002) THEN 251 --Casino
				WHEN bettype = 1000 THEN 253 --games
				WHEN bettype BETWEEN 1201 AND 1299 THEN 180 --Virtual Sport
				WHEN bettype BETWEEN 1501 AND 1599 THEN 202 --Keno
				WHEN bettype BETWEEN 18000 AND 18006 THEN 204 --Colossus Bet
				WHEN bettype BETWEEN 4001 AND 4100 THEN 212 --Voidbridge
				WHEN bettype = 901 THEN -2 --BetTrade - Sold
				WHEN bettype = 902 THEN -3 --BetTrade - Bought.
				WHEN bettype = 903 THEN -4 --BetTrade - Commission
				WHEN bettype = 904 THEN -5 --BetTrade - Winloss
				WHEN bettype = 911 THEN -6 --Cash Out - Sold
				WHEN bettype = 912 THEN -7 --Cash Out - Bought.
				WHEN bettype = 913 THEN -8 --Cash Out - Commission
				WHEN bettype = 914 THEN -9 --Cash Out - Winloss
				WHEN bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
				WHEN bettype BETWEEN 1700 AND 1799 THEN 255 -- GD
				WHEN bettype = 1900 THEN 249 -- VG
				WHEN bettype BETWEEN 2101 AND 2199 THEN 208
				WHEN bettype BETWEEN 2201 AND 2299 THEN 209
				WHEN (bettype BETWEEN 2301 AND 2399 OR bettype BETWEEN 2901 AND 2999) THEN 210
				WHEN bettype BETWEEN 2401 AND 2499 THEN 211
				WHEN bettype BETWEEN 1011 AND 1020 THEN 219
				WHEN bettype BETWEEN 2701 AND 2799 THEN 190 -- Betradar VS
				WHEN bettype BETWEEN 2800 AND 2829 THEN 193 -- Betradar VS: Virtual Basketball
				WHEN bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
				WHEN bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
				WHEN bettype BETWEEN 4101 AND 4296 OR bettype BETWEEN 6701 AND 7000 THEN 248 -- PP
				WHEN bettype BETWEEN 4297 AND 4300 THEN -248 -- PP Prize
				WHEN (bettype BETWEEN 1901 AND 1999 AND bettype <> 1906) THEN 165 -- CC
				WHEN bettype = 1906 THEN -165 -- Bonus
				WHEN bettype BETWEEN 4301 AND 4598 THEN 247 -- SG
				WHEN bettype BETWEEN 4599 AND 4600 THEN -247 -- SG Jackpot Contribution and Jackpot Prize
				WHEN bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
				WHEN bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
				WHEN bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
				WHEN bettype BETWEEN 3101 AND 3149 THEN 243 -- AE Casino
				WHEN bettype = 3150 THEN -243 -- AE Casino Lucky Draw
				WHEN bettype BETWEEN 1611 AND 1697 THEN 200 -- SBC
				WHEN bettype = -150 THEN 150 -- SBC Free Bets
				WHEN bettype BETWEEN 1698 AND 1699 THEN -200 -- SBC Prize
				WHEN bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
				WHEN bettype = 3007 THEN -244 -- SAG Tip ticket
				WHEN bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
				WHEN (bettype BETWEEN 3001 AND 3099 AND bettype <> 3007) THEN 244 -- SAG
				WHEN bettype BETWEEN 5701 AND 5799 THEN 236 -- GDG
				WHEN bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
				WHEN bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
				WHEN bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
				WHEN bettype BETWEEN 3801 AND 3897 THEN 171 -- VGA
				WHEN bettype = -173 THEN 173 -- VGA Free Bets
				WHEN bettype BETWEEN 3898 AND 3899 THEN -171 -- VGA Prize
				WHEN bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba promotion
				WHEN bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
				WHEN bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
				WHEN bettype BETWEEN 7701 AND 7799 THEN 172 -- AP
				WHEN bettype BETWEEN 7801 AND 7899 THEN 174 -- APM
				ELSE 0 END
	END

	-- #rptDepWinlostTransfer3rdOthers
	BEGIN
		DECLARE @RefNoList TABLE (RefNo BIGINT)
		DECLARE @TransferData TABLE (CustId INT, PartnerID INT, TransferIn MONEY, TransferOut MONEY)

		INSERT INTO @RefNoList (RefNo)
		SELECT b.refno
		FROM dbo.transfer b WITH (NOLOCK)
			INNER JOIN @Customer c ON b.custid = c.custid
			INNER JOIN @CasinoPartner p ON b.bettype = p.CancelTransferId
		WHERE b.winlostdate = @Winlostdate
		GROUP BY b.refno

		INSERT INTO @TransferData (CustId, PartnerId, TransferIn, TransferOut)
		SELECT b.CustId, p.PartnerId
			,SUM(CASE WHEN b.Winlost - b.Actual_Stake < 0 THEN -(b.Winlost - b.Actual_Stake) ELSE 0 END) AS TransferIn
			,SUM(CASE WHEN b.Winlost - b.Actual_Stake > 0 THEN -(b.Winlost - b.Actual_Stake) ELSE 0 END) AS TransferOut
		FROM dbo.transfer b WITH (NOLOCK)
			INNER JOIN @CasinoPartner p ON b.bettype IN (p.CancelTransferId, p.PartnerId)
		WHERE b.refno IN (SELECT RefNo FROM @RefNoList)
			AND b.winlostdate = @Winlostdate
		GROUP BY b.custid, p.PartnerId

		INSERT INTO #rptDepWinlostTransfer3rdOthers (CustId, PartnerId, TransferAmount, TransferIn, TransferOut)
		SELECT t.CustId, t.PartnerId
			,SUM(t.Transfer3rdOthers) AS TransferAmount
			,SUM(t.Transfer3rdOthers_In - ISNULL(d.TransferIn, 0)) AS TransferIn
			,SUM(t.Transfer3rdOthers_Out - ISNULL(d.TransferOut, 0)) AS TransferOut
		FROM #rptDepWinlostDetails t
			INNER JOIN dbo.Customer c WITH (NOLOCK) ON t.custid = c.custid
			INNER JOIN dbo.Customer a WITH (NOLOCK) ON c.recommend = a.custid
			LEFT JOIN @TransferData d ON t.custid = d.CustId AND t.PartnerId = d.PartnerId
		WHERE t.PartnerId > -1
			AND (c.username2 IS NOT NULL OR (c.username2 IS NULL AND a.username NOT LIKE '%ACC%'))
		GROUP BY t.CustId, t.PartnerId
	END

	-- #rptDepWinlostBonusWallet
	BEGIN
		INSERT INTO #rptDepWinlostBonusWallet (CustID, BonusType, Bonus, Adjustment)
		SELECT t.CustId, d.BonusType
			,SUM(ISNULL(t.BonusWallet, 0)) AS Bonus
			,SUM(ISNULL(t.AdjBonusWallet, 0)) AS Adjustment
		FROM #rptDepWinlostDetails t
			INNER JOIN @BonusList d ON t.Bettype IN (d.BonusBettype, d.AdjustmentBettype)
		GROUP BY t.CustId, d.BonusType
	END

	-- Regen data
	BEGIN
		IF @WinlostDate < @MinSumDate
		BEGIN
			DELETE bodb_Report.dbo.rptDepWinlost_UAT WITH (ROWLOCK) WHERE CustId IN (SELECT custid FROM @Customer) AND WinlostDate = @WinlostDate
			DELETE bodb_Report.dbo.rptDepWinlostByProduct_UAT WITH (ROWLOCK) WHERE CustId IN (SELECT custid FROM @Customer) AND WinlostDate = @WinlostDate
			DELETE bodb_Report.dbo.rptDepWinlost_Transfer3rdOthers_UAT WITH (ROWLOCK) WHERE CustId IN (SELECT custid FROM @Customer) AND WinlostDate = @WinlostDate
			DELETE bodb_Report.dbo.rptDepWinlost_BonusWallet_UAT WITH (ROWLOCK) WHERE CustId IN (SELECT custid FROM @Customer) AND WinlostDate = @WinlostDate

			INSERT INTO bodb_Report.dbo.rptDepWinlost_UAT
			(
				winlostdate, custid, currency, OpeningBalance, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss
				,recommend, mrecommend, srecommend, actualrate, Transfer3rd, DrawGame, Turnover_BA, Comm_BA
				,AmountDueTo_BA, playercomm, Transfer3rdOthers, comm_bettrade, amountdueto_bettrade, Promotion, ClosingBalance
			)
			SELECT @WinlostDate, c.custid, c.currency, c.OpeningBalance, ISNULL(r.Deposit, 0), ISNULL(r.Withdrawal, 0), ISNULL(r.Aff2MemTransfer, 0), ISNULL(r.Bonus, 0), ISNULL(r.Adjustment, 0)
				,ISNULL(r.Turnover, 0), ISNULL(r.Outstanding, 0), ISNULL(r.Winloss, 0)
				,c.recommend, c.mrecommend, c.srecommend, e.actualrate, ISNULL(r.Transfer3rd, 0), ISNULL(r.DrawGame, 0), ISNULL(r.Turnover_BA, 0), ISNULL(r.Comm_BA, 0)
				,ISNULL(r.AmountDueTo_BA, 0), ISNULL(r.playercomm, 0), ISNULL(r.Transfer3rdOthers, 0), ISNULL(r.comm_bettrade, 0), ISNULL(r.amountdueto_bettrade, 0), ISNULL(r.Promotion, 0)
				,c.OpeningBalance
					+ ISNULL(r.Deposit, 0) + ISNULL(r.Aff2MemTransfer, 0) - ISNULL(r.Withdrawal, 0) 
					+ ISNULL(r.Bonus, 0) + ISNULL(r.Adjustment, 0) - ISNULL(r.Outstanding, 0) + ISNULL(r.Winloss, 0)
					+ ISNULL(r.playercomm, 0) + ISNULL(r.Transfer3rd, 0) + ISNULL(r.Transfer3rdOthers, 0) - ISNULL(r.Comm_BetTrade_Full, 0) 
					+ ISNULL(r.Promotion,0) + ISNULL(b.Bonus, 0) + ISNULL(b.Adjustment, 0) AS ClosingBalance
			FROM @Customer c
				INNER JOIN bodb02.dbo.ExchangeDailyOanda e WITH (NOLOCK) ON c.currency = e.ExchangeId AND e.ExchangeDate = @WinlostDate
				LEFT JOIN #rptDepWinlost r ON c.custid = r.CustID
				LEFT JOIN #rptDepWinlostBonusWallet b ON c.custid = b.CustID
			WHERE c.OpeningBalance <> 0 OR r.CustID IS NOT NULL OR b.CustID IS NOT NULL
				

			INSERT INTO bodb_Report.dbo.rptDepWinlostByProduct_UAT (winlostdate, custid, sporttype, currency, turnover, drawTO, winlost, playercomm, BetCount, outstanding)
			SELECT @WinlostDate, c.custid, sporttype, c.currency, turnover, drawTO, winlost, playercomm, BetCount, outstanding
			FROM @Customer c
				INNER JOIN #rptDepWinlostByProduct r ON c.custid = r.CustID

			INSERT INTO bodb_Report.dbo.rptDepWinlost_Transfer3rdOthers_UAT (winlostdate, CustId, Currency, PartnerId, Recommend, MRecommend, SRecommend, TransferAmount, TransferIn, TransferOut)
			SELECT @WinlostDate, c.CustId, c.currency, PartnerId, recommend, mrecommend, srecommend, TransferAmount, TransferIn, TransferOut
			FROM @Customer c
				INNER JOIN #rptDepWinlostTransfer3rdOthers r ON c.custid = r.CustID

			INSERT INTO bodb_Report.dbo.rptDepWinlost_BonusWallet_UAT (Winlostdate, CustID, BonusType, Bonus, Adjustment)
			SELECT @Winlostdate, CustID, BonusType, Bonus, Adjustment
			FROM #rptDepWinlostBonusWallet
		END
		ELSE
		BEGIN
			DELETE bodb_Report.dbo.rptDepWinlost_Main_UAT WITH (ROWLOCK) WHERE CustId IN (SELECT custid FROM @Customer) AND WinlostDate = @WinlostDate
			DELETE bodb_Report.dbo.rptDepWinlost_Trans_UAT WITH (ROWLOCK) WHERE CustId IN (SELECT custid FROM @Customer) AND WinlostDate = @WinlostDate
			DELETE bodb_Report.dbo.rptDepWinlost_BonusWallet_UAT WITH (ROWLOCK) WHERE CustId IN (SELECT custid FROM @Customer) AND WinlostDate = @WinlostDate

			INSERT INTO bodb_Report.dbo.rptDepWinlost_Trans_UAT
			(
				Winlostdate, CustID, SportType, PartnerID, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss
				,Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade, Comm_BetTrade_Full
				,AmountDueTo_BetTrade, Promotion
			)
			SELECT
				@Winlostdate, CustID, -1, -1, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, TurnOver, OutStanding, Winloss
				,Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade, 0
				,AmountDueTo_BetTrade, Promotion
			FROM #rptDepWinlost

			INSERT INTO bodb_Report.dbo.rptDepWinlost_Trans_UAT (Winlostdate, CustID, SportType, PartnerID, Turnover, DrawGame, Winloss, playercomm, BetCount, Outstanding)
			SELECT @WinlostDate, custid, sporttype, -1, turnover, drawTO, winlost, playercomm, BetCount, outstanding
			FROM #rptDepWinlostByProduct

			INSERT INTO bodb_Report.dbo.rptDepWinlost_Trans_UAT (Winlostdate, CustID, SportType, PartnerID, TransferAmount, TransferIn, TransferOut)
			SELECT
				@Winlostdate, CustID, -1, PartnerID, TransferAmount, TransferIn, TransferOut
			FROM #rptDepWinlostTransfer3rdOthers

			INSERT INTO bodb_Report.dbo.rptDepWinlost_BonusWallet_UAT (Winlostdate, CustID, BonusType, Bonus, Adjustment)
			SELECT @Winlostdate, CustID, BonusType, Bonus, Adjustment
			FROM #rptDepWinlostBonusWallet

			INSERT INTO bodb_Report.dbo.rptDepWinlost_Main_UAT (Winlostdate, CustID, OpeningBalance, actualrate, srecommend, mrecommend, recommend, currency)
			SELECT @Winlostdate, c.CustID, c.OpeningBalance, e.actualrate, c.srecommend, c.mrecommend, c.recommend, c.currency
			FROM @Customer c
				INNER JOIN bodb02.dbo.ExchangeDailyOanda e WITH (NOLOCK) ON c.currency = e.ExchangeId AND e.ExchangeDate = @WinlostDate
				LEFT JOIN bodb_Report.dbo.rptDepWinlost_Trans_UAT t WITH (NOLOCK) ON c.custid = t.CustID AND t.SportType = -1 AND t.PartnerID = -1 AND t.Winlostdate = @WinlostDate
				LEFT JOIN bodb_Report.dbo.rptDepWinlost_BonusWallet_UAT b WITH (NOLOCK) ON t.CustID = b.CustID AND t.Winlostdate = b.Winlostdate
			WHERE c.OpeningBalance <> 0 OR t.CustID IS NOT NULL
		END
	END

	DROP TABLE #rptDepWinlostDetails
	DROP TABLE #rptDepWinlost
	DROP TABLE #rptDepWinlostByProduct
	DROP TABLE #rptDepWinlostTransfer3rdOthers
	DROP TABLE #rptDepWinlostBonusWallet
END
GO