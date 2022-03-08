/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Created: 20220308@Sol
	DB : DBACC-bodb02
	Task: Check data - [Redmine: #162264]
*/

USE bodb02;

GO 

DECLARE
	@WinLostDate	SMALLDATETIME	= '2022-02-12 00:00:00',
	@IsSuccessful	BIT				= 0 

--######### CREATE SCHEMA ############

BEGIN

	CREATE table #NEW_rptDepWinlost_Trans
	(
		Winlostdate	smalldatetime
		,CustID	int
		,SportType	smallint
		,PartnerID	int
		,Deposit	money
		,Withdrawal	money
		,Aff2MemTransfer	money
		,Bonus	money
		,Adjustment	money
		,Turnover	money
		,Outstanding	money
		,Winloss	money
		,Transfer3rd	money
		,DrawGame	money
		,Turnover_BA	money
		,Comm_BA	money
		,AmountDueTo_BA	money
		,playercomm	money
		,Transfer3rdOthers	money
		,Comm_BetTrade	money
		,Comm_Bettrade_Full	money
		,AmountDueTo_BetTrade	money
		,BetCount	int
		,TransferAmount	money
		,TransferIn	money
		,TransferOut	money
		,Promotion	money
	)

	CREATE UNIQUE CLUSTERED INDEX [NEW_CIX_rptDepWinlost_Trans] ON #NEW_rptDepWinlost_Trans
	(
		[Winlostdate] ASC,
		[CustID] ASC,
		[SportType] ASC,
		[PartnerID] ASC
	)

	CREATE table #NEW_rptDepWinlost_BonusWallet
	(
		Winlostdate	smalldatetime
		,CustID	int
		,BonusType	tinyint
		,Bonus	money
		,Adjustment	money
	)

	CREATE UNIQUE CLUSTERED INDEX [NEW_CIX_rptDepWinlost_Bonus] ON #NEW_rptDepWinlost_BonusWallet
	(
		[Winlostdate] ASC,
		[CustID] ASC
	)


	CREATE table #OLD_rptDepWinlost_Trans
	(
		Winlostdate	smalldatetime
		,CustID	int
		,SportType	smallint
		,PartnerID	int
		,Deposit	money
		,Withdrawal	money
		,Aff2MemTransfer	money
		,Bonus	money
		,Adjustment	money
		,Turnover	money
		,Outstanding	money
		,Winloss	money
		,Transfer3rd	money
		,DrawGame	money
		,Turnover_BA	money
		,Comm_BA	money
		,AmountDueTo_BA	money
		,playercomm	money
		,Transfer3rdOthers	money
		,Comm_BetTrade	money
		,Comm_Bettrade_Full	money
		,AmountDueTo_BetTrade	money
		,BetCount	int
		,TransferAmount	money
		,TransferIn	money
		,TransferOut	money
		,Promotion	money
	)

	CREATE UNIQUE CLUSTERED INDEX [OLD_CIX_rptDepWinlost_Trans] ON #OLD_rptDepWinlost_Trans
	(
		[Winlostdate] ASC,
		[CustID] ASC,
		[SportType] ASC,
		[PartnerID] ASC
	)

	CREATE table #OLD_rptDepWinlost_BonusWallet
	(
		Winlostdate	smalldatetime
		,CustID	int
		,BonusType	tinyint
		,Bonus	money
		,Adjustment	money
	)

	CREATE UNIQUE CLUSTERED INDEX [OLD_CIX_rptDepWinlost_Bonus] ON #OLD_rptDepWinlost_BonusWallet
	(
		[Winlostdate] ASC,
		[CustID] ASC
	)

END

--## END - CREATE SCHEMA ##--

--## COMMON DECLARE SECTION ##--

BEGIN

	SET NOCOUNT ON
	--1.Set low deadlock priority
	SET @isSuccessful = 0

	SET DEADLOCK_PRIORITY LOW

	DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
	INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
	EXEC bodb02.dbo.Age_SelBalanceUpDay

	DECLARE @CurrentDate DATE,
			@CurrentHour TINYINT,
			@LogDesc VARCHAR(8000) = 'Date generated: ',
			@LogID BIGINT,
			@NumberofCus INT= 0,
			@MoveBetsDay SMALLDATETIME,
			@ErrMsg VARCHAR(1000) = ''

	SELECT @CurrentDate = CONVERT(DATE, CURRENT_TIMESTAMP, 112)
	SELECT @CurrentHour = DATEPART(HOUR, CURRENT_TIMESTAMP)
	SELECT @MoveBetsDay = MoveBetsDay FROM @MBBU

	IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.bettrans14 WITH (NOLOCK)
					WHERE winlostdate = @Winlostdate AND bettype < 19999 AND bettype <> 18000)
		OR @WinlostDate > @MoveBetsDay
	BEGIN
		PRINT 'EXEC TASK_RealtimeSummaryDepData_Bettrans14: There is no data in bettrans14 to summarize or input @Winlostdate is greater than MoveBet day ==> RETURN'
		RETURN
	END

	DECLARE @CasinoPartner TABLE (
		PartnerId INT,
		TransferId INT,
		CancelTransferId INT)

	INSERT INTO @CasinoPartner(
		PartnerId,
		TransferId,
		CancelTransferId)
	SELECT
		PartnerId,
		TransferId,
		CancelTransferId
	FROM bodb_report.dbo.tblCasinoPartners WITH(NOLOCK)
	WHERE TransferId IS NOT NULL OR CancelTransferId IS NOT NULL

	-- For Bonus
	DECLARE @BonusList TABLE (
		BonusType TINYINT,
		BonusBettype INT,
		AdjustmentBettype INT)

	INSERT INTO @BonusList (BonusType, BonusBettype, AdjustmentBettype)
	VALUES( 1, 22200, 22201) -- Bonus Wallet

	CREATE TABLE #rptDepWinlostDetails (CustID INT, PartnerID INT DEFAULT(-1), Bettype INT, Deposit MONEY DEFAULT(0), Withdrawal MONEY DEFAULT(0)
		, Aff2MemTransfer MONEY DEFAULT(0), Bonus MONEY DEFAULT(0), Adjustment MONEY DEFAULT(0), TurnOver MONEY DEFAULT(0), OutStanding MONEY DEFAULT(0)
		, Winloss MONEY DEFAULT(0), Transfer3rd MONEY DEFAULT(0), DrawGame MONEY DEFAULT(0), Turnover_BA MONEY DEFAULT(0), Comm_BA MONEY DEFAULT(0)
		, AmountDueTo_BA MONEY DEFAULT(0), playercomm MONEY DEFAULT(0), Transfer3rdOthers MONEY DEFAULT(0), Transfer3rdOthers_In MONEY DEFAULT(0)
		, Transfer3rdOthers_Out MONEY DEFAULT(0), Comm_BetTrade MONEY DEFAULT(0), Comm_BetTrade_Full MONEY DEFAULT(0)
		, WLBoughtTicket_BetTrade MONEY DEFAULT(0), AmountDueTo_BetTrade MONEY DEFAULT(0), BetCount INT DEFAULT(0)
		, BonusWallet MONEY DEFAULT(0), AdjBonusWallet MONEY DEFAULT(0), Promotion MONEY DEFAULT(0)
		UNIQUE CLUSTERED (CustID, PartnerID, Bettype)
	)

	CREATE TABLE #rptDepWinlost (CustID INT, Deposit MONEY DEFAULT(0), Withdrawal MONEY DEFAULT(0), Aff2MemTransfer MONEY DEFAULT(0)
		, Bonus MONEY DEFAULT(0), Adjustment MONEY DEFAULT(0), TurnOver MONEY DEFAULT(0), OutStanding MONEY DEFAULT(0), Winloss MONEY DEFAULT(0), Transfer3rd MONEY DEFAULT(0)
		, DrawGame MONEY DEFAULT(0), Turnover_BA MONEY DEFAULT(0), Comm_BA MONEY DEFAULT(0), AmountDueTo_BA MONEY DEFAULT(0), playercomm MONEY DEFAULT(0)
		, Transfer3rdOthers MONEY DEFAULT(0), Comm_BetTrade MONEY DEFAULT(0), WLBoughtTicket_BetTrade MONEY DEFAULT(0), AmountDueTo_BetTrade MONEY DEFAULT(0)
		, BonusWallet MONEY DEFAULT(0), AdjBonusWallet MONEY DEFAULT(0), Promotion MONEY DEFAULT(0)
		UNIQUE CLUSTERED (CustID)
	)

	CREATE TABLE #BATrans(TransID BIGINT UNIQUE CLUSTERED (TransID))

	CREATE TABLE #DepCustID (CustID INT UNIQUE CLUSTERED (CustID))

	CREATE TABLE #rptDepWinlostTransfer3rdOthers (
		CustID INT,
		PartnerID INT,
		TransferAmount MONEY DEFAULT(0),
		TransferIn MONEY DEFAULT(0),
		TransferOut MONEY DEFAULT(0)
		UNIQUE CLUSTERED (CustID, PartnerID)
	)

	CREATE TABLE #rptDepWinlostBonusWallet (
		CustID INT,
		BonusType TINYINT DEFAULT(1),
		Bonus MONEY DEFAULT(0),
		Adjustment MONEY DEFAULT(0)
		UNIQUE CLUSTERED (CustID, BonusType)
	)

END

--## END - COMMON DECLARE SECTION ##--

--## NEW - GEN DATA - NEW ##

BEGIN

	BEGIN TRY
		--3.Prepare staging data for table rptDepWinlost_Trans
		--Insert Details for rptDepWinlost/rptDepWinlostByProduct/rptDepWinlostTransfer3rdOthers
		INSERT INTO #rptDepWinlostDetails (
			CustID,
			BetType,
			Deposit,
			Withdrawal,
			Aff2MemTransfer,
			Bonus,
			Adjustment,
			Transfer3rd,
			BonusWallet,
			AdjBonusWallet)
		SELECT
			b.custid,
			b.bettype,
			SUM(CASE WHEN b.bettype = 22001 THEN b.winlost-b.actual_stake ELSE 0 END), --Deposit
			-SUM(CASE WHEN b.bettype IN (22002,22003) THEN b.winlost-b.actual_stake ELSE 0 END),--Withdrawal
			SUM(CASE WHEN b.bettype = 21006 THEN b.winlost-b.actual_stake ELSE 0 END), --Aff2MemTransfer
			SUM(CASE WHEN b.bettype IN (22004, 22202) THEN b.winlost-b.actual_stake ELSE 0 END),--Bonus
			SUM(CASE WHEN b.bettype IN (21001, 21002, 21003, 21004, 21005, 22005, 22203) THEN b.winlost-b.actual_stake ELSE 0 END), --Adjustment
			SUM(CASE WHEN b.bettype IN (22006,22007) THEN b.winlost-b.actual_stake ELSE 0 END),--Transfer3rd
			SUM(CASE WHEN b.bettype = 22200 THEN b.winlost-b.actual_stake ELSE 0 END), -- Bonus Wallet
			SUM(CASE WHEN b.bettype = 22201 THEN b.winlost-b.actual_stake ELSE 0 END) -- AdjBonusWallet
		FROM dbo.Transfer b WITH (NOLOCK)
			INNER JOIN dbo.Dep_CustSuper d WITH (NOLOCK) ON b.srecommend = d.custid
			INNER JOIN dbo.CustInfo c WITH (NOLOCK) ON b.custid = c.custid
		WHERE b.winlostdate = @Winlostdate
			AND c.roleid = 1
			AND (bettype = 19999 AND winlostdate <= @MoveBetsDay OR b.Bettype > 19999)
		GROUP BY b.custid, b.bettype

		INSERT INTO #DepCustID (CustID)
		SELECT CustID
		FROM #rptDepWinlostDetails
		WHERE PartnerID = -1
		GROUP BY CustID

		--Update Transfer3rdOthers attributes
		UPDATE #rptDepWinlostDetails
		SET PartnerID = t.PartnerId,
			Transfer3rdOthers = t.Transfer3rdOthers,
			Transfer3rdOthers_In = t.Transfer3rdOthers_In,
			Transfer3rdOthers_Out = t.Transfer3rdOthers_Out
		FROM (
				SELECT
					b.custid,
					p.PartnerId,
					b.bettype,
					SUM(b.winlost - b.actual_stake) AS Transfer3rdOthers,
					SUM(CASE WHEN (winlost-actual_stake) < 0 THEN -(winlost-actual_stake) ELSE 0 END) AS Transfer3rdOthers_In,
					SUM(CASE WHEN (winlost-actual_stake) > 0 THEN -(winlost-actual_stake) ELSE 0 END) AS Transfer3rdOthers_Out
				FROM dbo.Transfer b WITH (NOLOCK)
					INNER JOIN @CasinoPartner p ON b.bettype IN (p.TransferId, p.CancelTransferId)
				WHERE b.winlostdate = @Winlostdate
				GROUP BY
					b.custid,
					p.PartnerId,
					b.bettype
			) AS t
		WHERE #rptDepWinlostDetails.CustID = t.custid AND #rptDepWinlostDetails.Bettype = t.bettype

		/*--Force seek predicate on custid for bettrans14 part
		DECLARE @n INT = 2147483647
		*/
		INSERT INTO #rptDepWinlostDetails (
			CustID,
			BetType,
			TurnOver,
			OutStanding,
			Winloss,
			DrawGame,
			playercomm,
			Comm_BetTrade,
			WLBoughtTicket_BetTrade,
			BetCount,
			Promotion)
		SELECT
			b.custid,
			CASE
				WHEN b.bettype BETWEEN 81 AND 120 THEN 161--Number Game
				WHEN b.bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game: Happy 5
				WHEN b.bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
				WHEN b.bettype IN (71,72,23002) THEN 251--Casino
				WHEN b.bettype = 1000 THEN 253--games
				WHEN b.bettype BETWEEN 1201 AND 1299 THEN 180--Virtual Sport
				WHEN b.bettype BETWEEN 1501 AND 1599 THEN 202--Keno
				WHEN bettype BETWEEN 18000 AND 18006 THEN 204 --Colossus Bet
				WHEN b.bettype BETWEEN 4001 AND 4100 THEN 212--Voidbridge
				WHEN b.bettype = 901 THEN -2--BetTrade - Sold
				WHEN b.bettype = 902 THEN -3--BetTrade - Bought.
				WHEN b.bettype = 903 THEN -4--BetTrade - Commission
				WHEN b.bettype = 904 THEN -5--BetTrade - Winloss
				WHEN b.bettype = 911 THEN -6--Cash Out - Sold
				WHEN b.bettype = 912 THEN -7--Cash Out - Bought.
				WHEN b.bettype = 913 THEN -8--Cash Out - Commission
				WHEN b.bettype = 914 THEN -9--Cash Out - Winloss
				WHEN b.bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
				WHEN b.bettype BETWEEN 1700 AND 1799 THEN 255 -- GD
				WHEN b.bettype = 1900 THEN 249 -- VG
				WHEN b.bettype BETWEEN 2101 AND 2199 THEN 208
				WHEN b.bettype BETWEEN 2201 AND 2299 THEN 209
				WHEN (b.bettype BETWEEN 2301 AND 2399 OR b.bettype BETWEEN 2901 AND 2999) THEN 210
				WHEN b.bettype BETWEEN 2401 AND 2499 THEN 211 -- Allbet
				WHEN b.bettype BETWEEN 1011 AND 1020 THEN 219
				WHEN b.bettype BETWEEN 2701 AND 2799 THEN 190 -- Betradar VS
				WHEN b.bettype BETWEEN 2800 AND 2829 THEN 193 -- Betradar VS: Virtual Basketball
				WHEN b.bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
				WHEN b.bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
				WHEN b.bettype BETWEEN 4101 AND 4296 OR bettype BETWEEN 6701 AND 7000 THEN 248 -- PP
				WHEN b.bettype BETWEEN 4297 AND 4300 THEN -248 -- PP Prize
				WHEN (b.bettype BETWEEN 1901 AND 1999 AND bettype <> 1906) THEN 165 -- CC
				WHEN b.bettype = 1906 THEN -165 -- Bonus
				WHEN b.bettype BETWEEN 4301 AND 4598 THEN 247	-- SG
				WHEN b.bettype BETWEEN 4599 AND 4600 THEN -247	-- SG Jackpot Contribution and Jackpot Prize
				WHEN b.bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
				WHEN b.bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
				WHEN b.bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
				WHEN b.bettype BETWEEN 3101 AND 3149 THEN 243 -- AE Casino
				WHEN b.bettype = 3150 THEN -243 -- AE Casino Lucky Draw
				WHEN (b.bettype BETWEEN 1611 AND 1697 AND b.matchid <> 150) THEN 200 -- SBC
				WHEN (b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150) THEN -150 -- SBC FreeBets
				WHEN (b.bettype BETWEEN 1698 AND 1699 AND b.matchid <> 150) THEN -200 -- SBC Prize
				WHEN b.bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
				WHEN b.bettype = 3007 THEN -244 -- SAG Tip ticket
				WHEN b.bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
				WHEN b.bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
				WHEN (b.bettype BETWEEN 3001 AND 3099 AND b.bettype <> 3007) THEN 244 -- SAG
				WHEN bettype BETWEEN 5701 AND 5799 THEN 236 -- GDG
				WHEN bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
				WHEN bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
				WHEN bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
				WHEN (bettype BETWEEN 3801 AND 3897 AND b.matchid <> 173) THEN 171 -- VGA
				WHEN (bettype BETWEEN 3801 AND 3899 AND b.matchid = 173) THEN -173 -- VGA FreeBets
				WHEN (bettype BETWEEN 3898 AND 3899 AND b.matchid <> 173) THEN -171 -- VGA Prize
				WHEN bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba Promotion
				WHEN bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
				WHEN bettype BETWEEN 7701 AND 7799 THEN 172 -- AP
				WHEN bettype BETWEEN 7801 AND 7899 THEN 174 -- APM
				WHEN bettype BETWEEN 5301 AND 5399 THEN 231 -- VS3
			ELSE 0 END,--SportType
			SUM(CASE WHEN b.statusID NOT IN (101, 102, 103) THEN b.stake ELSE 0 END),--Turnover
			SUM(CASE WHEN b.ruben = 0 THEN b.actual_stake ELSE 0 END),--Outstanding
			SUM(CASE
					WHEN b.ruben = 1
						AND b.bettype NOT IN (4300, 4299, 4298, 4297, 3007, 1906, 1698, 1699, 3898, 3899, 4599, 4600)
						AND (b.bettype NOT BETWEEN 1611 AND 1697 OR b.matchid <> 150)
						AND (b.bettype NOT BETWEEN 3801 AND 3899 OR b.matchid <> 173)
						AND (b.bettype NOT BETWEEN 17000 AND 17030)
						THEN b.winlost - b.actual_stake
					ELSE 0
				END),--Winloss
			SUM(CASE WHEN b.statusID = 111 THEN b.stake ELSE 0 END),--DrawGame
			SUM(CASE WHEN b.ruben = 1 THEN b.playercomm ELSE 0 END),--Playercomm
			SUM(CASE WHEN b.bettype = 903 AND b.ruben = 1 AND b.statusID NOT IN (101, 102, 103) THEN b.awinlost ELSE 0 END),--Comm_BetTrade
			SUM(CASE WHEN b.bettype = 902 AND b.ruben = 1 AND b.statusID NOT IN (101, 102, 103) THEN b.winlost - b.actual_stake ELSE 0 END),--WLBoughtTicket_BetTrade
			SUM(CASE WHEN b.bettype < 19999 AND b.StatusID NOT IN (101, 102, 103) THEN 1 ELSE 0 END), --BetCount
			SUM(CASE
					WHEN b.bettype IN (4300, 4299, 4298, 4297, 3007, 1906, 1698, 1699, 3898, 3899, 4599, 4600)
						OR (b.bettype BETWEEN 1611 AND 1697 AND b.matchid = 150)
						OR (b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173)
						OR (b.bettype BETWEEN 17000 AND 17030)
						THEN b.winlost - b.actual_stake
					ELSE 0
				END) -- Promotion
		FROM dbo.bettrans14 b WITH (NOLOCK)
			INNER JOIN #DepCustID d on b.custid = d.CustID
		/*
			FROM (SELECT TOP (@n) custid FROM #DepCustID) d
			INNER JOIN bettrans14 b WITH (NOLOCK) on b.custid = d.CustID
			WHERE b.winlostdate = @Winlostdate
			GROUP BY b.custid, b.bettype
			OPTION(OPTIMIZE FOR (@n = 1)) --Trick SQL optimizer to use nested loop
		*/
		WHERE b.winlostdate = @WinLostDate
			AND b.bettype < 19999
			AND b.bettype <> 999
		GROUP BY
			b.custid,
			CASE
				WHEN b.bettype BETWEEN 81 AND 120 THEN 161--Number Game
				WHEN b.bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game: Happy 5
				WHEN b.bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
				WHEN b.bettype IN (71,72,23002) THEN 251--Casino
				WHEN b.bettype = 1000 THEN 253--games
				WHEN b.bettype BETWEEN 1201 AND 1299 THEN 180--Virtual Sport
				WHEN b.bettype BETWEEN 1501 AND 1599 THEN 202--Keno
				WHEN bettype BETWEEN 18000 AND 18006 THEN 204 --Colossus Bet
				WHEN b.bettype BETWEEN 4001 AND 4100 THEN 212--Voidbridge
				WHEN b.bettype = 901 THEN -2--BetTrade - Sold
				WHEN b.bettype = 902 THEN -3--BetTrade - Bought.
				WHEN b.bettype = 903 THEN -4--BetTrade - Commission
				WHEN b.bettype = 904 THEN -5--BetTrade - Winloss
				WHEN b.bettype = 911 THEN -6--Cash Out - Sold
				WHEN b.bettype = 912 THEN -7--Cash Out - Bought.
				WHEN b.bettype = 913 THEN -8--Cash Out - Commission
				WHEN b.bettype = 914 THEN -9--Cash Out - Winloss
				WHEN b.bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
				WHEN b.bettype BETWEEN 1700 AND 1799 THEN 255 -- GD
				WHEN b.bettype = 1900 THEN 249 -- VG
				WHEN b.bettype BETWEEN 2101 AND 2199 THEN 208
				WHEN b.bettype BETWEEN 2201 AND 2299 THEN 209
				WHEN (b.bettype BETWEEN 2301 AND 2399 OR b.bettype BETWEEN 2901 AND 2999) THEN 210
				WHEN b.bettype BETWEEN 2401 AND 2499 THEN 211 -- Allbet
				WHEN b.bettype BETWEEN 1011 AND 1020 THEN 219
				WHEN b.bettype BETWEEN 2701 AND 2799 THEN 190 -- Betradar VS
				WHEN b.bettype BETWEEN 2800 AND 2829 THEN 193 -- Betradar VS: Virtual Basketball
				WHEN b.bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
				WHEN b.bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
				WHEN b.bettype BETWEEN 4101 AND 4296 OR bettype BETWEEN 6701 AND 7000 THEN 248 -- PP
				WHEN b.bettype BETWEEN 4297 AND 4300 THEN -248 -- PP Prize
				WHEN (b.bettype BETWEEN 1901 AND 1999 AND bettype <> 1906) THEN 165 -- CC
				WHEN b.bettype = 1906 THEN -165 -- Bonus
				WHEN b.bettype BETWEEN 4301 AND 4598 THEN 247	-- SG
				WHEN b.bettype BETWEEN 4599 AND 4600 THEN -247	-- SG Jackpot Contribution and Jackpot Prize
				WHEN b.bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
				WHEN b.bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
				WHEN b.bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
				WHEN b.bettype BETWEEN 3101 AND 3149 THEN 243 -- AE Casino
				WHEN b.bettype = 3150 THEN -243 -- AE Casino Lucky Draw
				WHEN (b.bettype BETWEEN 1611 AND 1697 AND b.matchid <> 150) THEN 200 -- SBC
				WHEN (b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150) THEN -150 -- SBC FreeBets
				WHEN (b.bettype BETWEEN 1698 AND 1699 AND b.matchid <> 150) THEN -200 -- SBC Prize
				WHEN b.bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
				WHEN b.bettype = 3007 THEN -244 -- SAG Tip ticket
				WHEN b.bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
				WHEN b.bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
				WHEN (b.bettype BETWEEN 3001 AND 3099 AND b.bettype <> 3007) THEN 244 -- SAG
				WHEN bettype BETWEEN 5701 AND 5799 THEN 236 -- GDG
				WHEN bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
				WHEN bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
				WHEN bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
				WHEN (bettype BETWEEN 3801 AND 3897 AND b.matchid <> 173) THEN 171 -- VGA
				WHEN (bettype BETWEEN 3801 AND 3899 AND b.matchid = 173) THEN -173 -- VGA FreeBets
				WHEN (bettype BETWEEN 3898 AND 3899 AND b.matchid <> 173) THEN -171 -- VGA Prize
				WHEN bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba Promotion
				WHEN bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
				WHEN bettype BETWEEN 7701 AND 7799 THEN 172 -- AP
				WHEN bettype BETWEEN 7801 AND 7899 THEN 174 -- APM
				WHEN bettype BETWEEN 5301 AND 5399 THEN 231 -- VS3
				ELSE 0
			END--SportType
		OPTION (RECOMPILE, MAXDOP 8)

		/*--PREPARE DATA FOR rptDepWinlost--*/
		INSERT INTO #rptDepWinlost (
			CustID,
			Deposit,
			Withdrawal,
			Aff2MemTransfer,
			Bonus,
			Adjustment,
			TurnOver,
			OutStanding,
			Winloss,
			Transfer3rd,
			DrawGame,
			playercomm,
			Transfer3rdOthers,
			Comm_BetTrade,
			WLBoughtTicket_BetTrade,
			BonusWallet,
			AdjBonusWallet,
			Promotion)
		SELECT
			custid,
			SUM(Deposit), --Deposit
			SUM(Withdrawal),--Withdrawal
			SUM(Aff2MemTransfer), --Aff2MemTransfer
			SUM(Bonus),--Bonus
			SUM(Adjustment),--Adjustment
			SUM(Turnover),--Turnover
			SUM(Outstanding),--Outstanding
			SUM(CASE WHEN bettype NOT IN (246, -248, -244, -165, -150, -200, -243, -171, -173, -247) THEN Winloss ELSE 0 END),--Winloss
			SUM(Transfer3rd),--Transfer3rd
			SUM(DrawGame),--DrawGame
			SUM(Playercomm),--Playercomm
			SUM(Transfer3rdOthers),--Transfer3rdOthers
			SUM(Comm_BetTrade),--Comm_BetTrade
			SUM(WLBoughtTicket_BetTrade),--WLBoughtTicket_BetTrade
			SUM(BonusWallet), -- Bonus Wallet
			SUM(AdjBonusWallet), -- Adjustment Bonus Wallet
			SUM(Promotion) -- Promotion
		FROM #rptDepWinlostDetails
		WHERE Bettype NOT IN (-8, -9)
		GROUP BY custid

		--Update BA attributes
		INSERT INTO #BATrans (transid)
		SELECT transid
		FROM bodb_Licensee.dbo.LicenseeBATransaction_bk WITH (NOLOCK)
		WHERE WinlostDate = @Winlostdate

		UPDATE #rptDepWinlost
		SET Turnover_BA = ISNULL(t.turnover_ba,0),
			Comm_BA = ISNULL(t.Comm_BA,0),
			AmountDueTo_BA = ISNULL(t.AmountDueTo_BA,0)
		FROM (
			SELECT b.custid,
				SUM(b.stake) Turnover_BA,
				SUM(b.comm) AS Comm_BA,
				-SUM(b.winlost - b.actual_stake + b.awinlost + b.comm) AS AmountDueTo_BA
			FROM dbo.bettrans14 b WITH(NOLOCK)
			WHERE b.transid IN (SELECT transid FROM #BATrans)
				AND b.winlostdate = @Winlostdate
				AND b.ruben = 1
				AND b.statusID NOT IN (101, 102, 103)
			GROUP BY b.custid) AS t
		WHERE #rptDepWinlost.CustID = t.CustID

		--Update BetTrade attribute
		UPDATE #rptDepWinlost
		SET AmountDueTo_BetTrade = ISNULL(t.WLBeticket, 0) + WLBoughtTicket_BetTrade - Comm_BetTrade
		FROM (SELECT b.custid,
				SUM(CASE WHEN b.bettype NOT IN (902,903) THEN b.winlost - b.actual_stake ELSE 0 END) AS WLBeticket --WL of bet ticket of bettrade
			FROM dbo.bettrans14 b WITH (NOLOCK)
				INNER JOIN dbo.f_GetBetTradeCustList('All') bt ON b.custid = bt.Custid
			WHERE b.winlostdate = @Winlostdate
				--AND (b.bettype < 31 OR b.bettype BETWEEN 121 AND 999 OR b.bettype BETWEEN 1301 AND 1399)
				AND b.ruben = 1
				AND b.statusID NOT IN(101, 102, 103)
			GROUP BY b.custid) t
		WHERE #rptDepWinlost.custid = t.custid

		--Delete redundant data
		DELETE FROM #rptDepWinlost
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
		/*--END PREPARE DATA FOR rptDepWinlost--*/

		/*--PREPARE DATA FOR rptDepWinlostTransfer3rdOthers--*/
		DECLARE @RefNoList AS TABLE (RefNo BIGINT)
		DECLARE @TransferData AS TABLE (
			CustId INT,
			PartnerID INT,
			TransferIn MONEY,
			TransferOut MONEY)

		INSERT INTO @RefNoList(RefNo)
		SELECT b.refno
		FROM dbo.Transfer b WITH (NOLOCK)
			INNER JOIN @CasinoPartner p ON b.bettype = p.CancelTransferId
			INNER JOIN dbo.CustInfo c WITH (NOLOCK) ON b.custid = c.custid
			INNER JOIN dbo.Dep_CustSuper s WITH(NOLOCK) ON s.custid = c.srecommend
		WHERE b.winlostdate = @Winlostdate
			AND c.roleid = 1
		GROUP BY b.refno

		INSERT INTO @TransferData(CustId, PartnerId, TransferIn, TransferOut)
		SELECT b.CustId
			, p.PartnerId
			, SUM(CASE WHEN (b.winlost-b.actual_stake) < 0 THEN -(b.winlost-b.actual_stake) ELSE 0 END)--TransferIn
			, SUM(CASE WHEN (b.winlost-b.actual_stake) > 0 THEN -(b.winlost-b.actual_stake) ELSE 0 END) --TransferOut
		FROM dbo.Transfer b WITH (NOLOCK)
			INNER JOIN @CasinoPartner p ON b.bettype IN (p.CancelTransferId, p.PartnerId)
		WHERE b.refno IN (SELECT RefNo FROM @RefNoList)
		GROUP BY b.custid, p.PartnerId

		INSERT INTO #rptDepWinlostTransfer3rdOthers(
			CustId,
			PartnerId,
			TransferAmount,
			TransferIn,
			TransferOut)
		SELECT t.CustId
			, t.PartnerId
			, SUM(t.Transfer3rdOthers)--TransferAmount
			, SUM(t.Transfer3rdOthers_In - ISNULL(d.TransferIn, 0))--TransferIn
			, SUM(t.Transfer3rdOthers_Out - ISNULL(d.TransferOut, 0))--TransferOut
		FROM #rptDepWinlostDetails t
			INNER JOIN dbo.vw_Customer c WITH (NOLOCK) ON t.custid = c.custid
			INNER JOIN dbo.vw_Customer agent WITH (NOLOCK) ON c.recommend = agent.custid
			LEFT JOIN @TransferData d ON t.custid = d.CustId AND t.PartnerId = d.PartnerId
		WHERE t.PartnerId > -1
			AND (c.username2 IS NOT NULL OR (c.username2 IS NULL AND agent.username NOT LIKE '%ACC%'))
		GROUP BY t.CustId, t.PartnerId
		/*--END PREPARE DATA FOR rptDepWinlostTransfer3rdOthers--*/

		/*--PREPARE DATA FOR rptDepWinlostBonusWallet--*/
		INSERT INTO #rptDepWinlostBonusWallet (
			CustID,
			BonusType,
			Bonus,
			Adjustment)
		SELECT t.CustId
			, d.BonusType
			, SUM(ISNULL(t.BonusWallet, 0)) -- Bonus value of Bonus Wallet
			, SUM(ISNULL(t.AdjBonusWallet, 0))-- Adjustment value of Bonus Wallet
		FROM #rptDepWinlostDetails t
			INNER JOIN @BonusList d ON t.Bettype IN (d.BonusBettype, d.AdjustmentBettype)
		GROUP BY t.CustId, d.BonusType

		/*--END PREPARE DATA FOR rptDepWinlostBonusWallet--*/
		
		--For rptDepWinlost
		INSERT INTO #NEW_rptDepWinlost_Trans(Winlostdate, CustID, SportType, PartnerID, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover
			, Outstanding, Winloss, Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade, Comm_BetTrade_Full
			, AmountDueTo_BetTrade
			, Promotion
			)
		SELECT @Winlostdate, CustID, -1, -1, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, TurnOver
		, OutStanding, Winloss, Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade, 0
		, AmountDueTo_BetTrade
		, Promotion
		FROM #rptDepWinlost

		SELECT @NumberofCus = @@ROWCOUNT

		--For rptDepWinlostByProduct
		INSERT INTO #NEW_rptDepWinlost_Trans (
			Winlostdate,
			CustID,
			SportType,
			PartnerID,
			Turnover,
			DrawGame,
			Winloss,
			playercomm,
			BetCount,
			Outstanding)
		SELECT
			@Winlostdate,
			CustID,
			Bettype,
			-1,
			TurnOver,
			DrawGame,
			CASE WHEN Bettype IN (246, -248, -244, -165, -150, -200, -243, -171, -173, -247) THEN Promotion ELSE Winloss END AS Winloss,
			playercomm,
			BetCount,
			OutStanding
		FROM #rptDepWinlostDetails
		WHERE Bettype < 19999 --Only get SportType of bet ticket
			AND PartnerID = -1

		--For rptDepWinlost_Transfer3rdOthers
		INSERT INTO #NEW_rptDepWinlost_Trans (
			Winlostdate,
			CustID,
			SportType,
			PartnerID,
			TransferAmount,
			TransferIn,
			TransferOut)
		SELECT
			@Winlostdate,
			CustID,
			-1,
			PartnerID,
			TransferAmount,
			TransferIn,
			TransferOut
		FROM #rptDepWinlostTransfer3rdOthers

		--For rptDepWinlost_BonusWallet
		INSERT INTO #NEW_rptDepWinlost_BonusWallet (
			Winlostdate,
			CustID,
			BonusType,
			Bonus,
			Adjustment)
		SELECT
			@Winlostdate,
			CustID,
			BonusType,
			Bonus,
			Adjustment
		FROM #rptDepWinlostBonusWallet

		SELECT @isSuccessful = 1, @ErrMsg = ''

		--5.Update Log
		SELECT @LogDesc = @LogDesc + CONVERT(VARCHAR(20),@Winlostdate) + ' (No. of Customer affected: ' + CONVERT(VARCHAR(20), @NumberofCus) + '); Type: realtime'

	END TRY
	BEGIN CATCH
		
		SELECT @isSuccessful = 0, @ErrMsg = LEFT(ERROR_MESSAGE(),1000)
		SELECT @LogDesc = @LogDesc + '; Type: realtime' + '; ErrMsg: ' + @ErrMsg

		PRINT 'EXEC TASK_RealtimeSummaryDepData_Bettrans14, Winlostdate = ' + CONVERT(VARCHAR(20), @Winlostdate, 120) + ', ErrMsg: ' + ERROR_MESSAGE()

	END CATCH

	SELECT @LogDesc, @IsSuccessful, @ErrMsg

END

--## END - NEW - GEN DATA - END ##

--CLEAR DATA FROM TEMP TABLE
TRUNCATE TABLE #rptDepWinlostDetails
TRUNCATE TABLE #rptDepWinlost
TRUNCATE TABLE #rptDepWinlostTransfer3rdOthers
TRUNCATE TABLE #rptDepWinlostBonusWallet
TRUNCATE TABLE #BATrans
TRUNCATE TABLE #DepCustID

SELECT @NumberofCus = 0, @LogDesc = 'Date generated: ', @IsSuccessful = 0, @ErrMsg = ''
--## OLD - GEN DATA - OLD ##

BEGIN
	
	BEGIN TRY
		--3.Prepare staging data for table rptDepWinlost_Trans
		--Insert Details for rptDepWinlost/rptDepWinlostByProduct/rptDepWinlostTransfer3rdOthers
		INSERT INTO #rptDepWinlostDetails (
			CustID,
			BetType,
			Deposit,
			Withdrawal,
			Aff2MemTransfer,
			Bonus,
			Adjustment,
			Transfer3rd,
			BonusWallet,
			AdjBonusWallet)
		SELECT
			b.custid,
			b.bettype,
			SUM(CASE WHEN b.bettype = 22001 THEN b.winlost-b.actual_stake ELSE 0 END), --Deposit
			-SUM(CASE WHEN b.bettype IN (22002,22003) THEN b.winlost-b.actual_stake ELSE 0 END),--Withdrawal
			SUM(CASE WHEN b.bettype = 21006 THEN b.winlost-b.actual_stake ELSE 0 END), --Aff2MemTransfer
			SUM(CASE WHEN b.bettype IN (22004, 22202) THEN b.winlost-b.actual_stake ELSE 0 END),--Bonus
			SUM(CASE WHEN b.bettype IN (21001, 21002, 21003, 21004, 21005, 22005, 22203) THEN b.winlost-b.actual_stake ELSE 0 END), --Adjustment
			SUM(CASE WHEN b.bettype IN (22006,22007) THEN b.winlost-b.actual_stake ELSE 0 END),--Transfer3rd
			SUM(CASE WHEN b.bettype = 22200 THEN b.winlost-b.actual_stake ELSE 0 END), -- Bonus Wallet
			SUM(CASE WHEN b.bettype = 22201 THEN b.winlost-b.actual_stake ELSE 0 END) -- AdjBonusWallet
		FROM dbo.bettrans b WITH (NOLOCK)
			INNER JOIN dbo.Dep_CustSuper d WITH (NOLOCK) ON b.srecommend = d.custid
			INNER JOIN dbo.CustInfo c WITH (NOLOCK) ON b.custid = c.custid
		WHERE b.winlostdate = @Winlostdate
			AND b.matchid = 0
			AND c.roleid = 1
			AND b.bettype <> 999 --Licensee Spread Setting
			AND 1 = CASE
						WHEN b.bettype = 19999 AND b.winlostdate > @MoveBetsDay THEN 0
						WHEN b.bettype < 19999 AND b.winlostdate <= @MoveBetsDay THEN 0
						ELSE 1 END
		GROUP BY b.custid, b.bettype
		OPTION (RECOMPILE, MAXDOP 8)

		INSERT INTO #DepCustID (CustID)
		SELECT CustID
		FROM #rptDepWinlostDetails
		WHERE PartnerID = -1
		GROUP BY CustID

		--Update Transfer3rdOthers attributes
		UPDATE #rptDepWinlostDetails
		SET PartnerID = t.PartnerId,
			Transfer3rdOthers = t.Transfer3rdOthers,
			Transfer3rdOthers_In = t.Transfer3rdOthers_In,
			Transfer3rdOthers_Out = t.Transfer3rdOthers_Out
		FROM (
			SELECT
				b.custid,
				p.PartnerId,
				b.bettype,
				SUM(b.winlost - b.actual_stake) AS Transfer3rdOthers,
				SUM(CASE WHEN (winlost-actual_stake) < 0 THEN -(winlost-actual_stake) ELSE 0 END) AS Transfer3rdOthers_In,
				SUM(CASE WHEN (winlost-actual_stake) > 0 THEN -(winlost-actual_stake) ELSE 0 END) AS Transfer3rdOthers_Out
			FROM dbo.bettrans b WITH (NOLOCK)
				INNER JOIN @CasinoPartner p ON b.bettype IN (p.TransferId, p.CancelTransferId)
			WHERE b.winlostdate = @Winlostdate
				AND b.matchid = 0
			GROUP BY
				b.custid,
				p.PartnerId,
				b.bettype) AS t
		WHERE #rptDepWinlostDetails.CustID = t.custid AND #rptDepWinlostDetails.Bettype = t.bettype

		/*--Force seek predicate on custid for bettrans14 part
		DECLARE @n INT = 2147483647
		*/
		INSERT INTO #rptDepWinlostDetails (
			CustID,
			BetType,
			TurnOver,
			OutStanding,
			Winloss,
			DrawGame,
			playercomm,
			Comm_BetTrade,
			WLBoughtTicket_BetTrade,
			BetCount,
			Promotion)
		SELECT
			b.custid,
			CASE
				WHEN b.bettype BETWEEN 81 AND 120 THEN 161--Number Game
				WHEN b.bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game: Happy 5
				WHEN b.bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
				WHEN b.bettype IN (71,72,23002) THEN 251--Casino
				WHEN b.bettype = 1000 THEN 253--games
				WHEN b.bettype BETWEEN 1201 AND 1299 THEN 180--Virtual Sport
				WHEN b.bettype BETWEEN 1501 AND 1599 THEN 202--Keno
				WHEN bettype BETWEEN 18000 AND 18006 THEN 204 --Colossus Bet
				WHEN b.bettype BETWEEN 4001 AND 4100 THEN 212--Voidbridge
				WHEN b.bettype = 901 THEN -2--BetTrade - Sold
				WHEN b.bettype = 902 THEN -3--BetTrade - Bought.
				WHEN b.bettype = 903 THEN -4--BetTrade - Commission
				WHEN b.bettype = 904 THEN -5--BetTrade - Winloss
				WHEN b.bettype = 911 THEN -6--Cash Out - Sold
				WHEN b.bettype = 912 THEN -7--Cash Out - Bought.
				WHEN b.bettype = 913 THEN -8--Cash Out - Commission
				WHEN b.bettype = 914 THEN -9--Cash Out - Winloss
				WHEN b.bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
				WHEN b.bettype BETWEEN 1700 AND 1799 THEN 255 -- GD
				WHEN b.bettype = 1900 THEN 249 -- VG
				WHEN b.bettype BETWEEN 2101 AND 2199 THEN 208
				WHEN b.bettype BETWEEN 2201 AND 2299 THEN 209
				WHEN (b.bettype BETWEEN 2301 AND 2399 OR b.bettype BETWEEN 2901 AND 2999) THEN 210
				WHEN b.bettype BETWEEN 2401 AND 2499 THEN 211 -- Allbet
				WHEN b.bettype BETWEEN 1011 AND 1020 THEN 219
				WHEN b.bettype BETWEEN 2701 AND 2799 THEN 190 -- Betradar VS
				WHEN b.bettype BETWEEN 2800 AND 2829 THEN 193 -- Betradar VS: Virtual Basketball
				WHEN b.bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
				WHEN b.bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
				WHEN b.bettype BETWEEN 4101 AND 4296 OR bettype BETWEEN 6701 AND 7000 THEN 248 -- PP
				WHEN b.bettype BETWEEN 4297 AND 4300 THEN -248 -- PP Prize
				WHEN (b.bettype BETWEEN 1901 AND 1999 AND bettype <> 1906) THEN 165 -- CC
				WHEN b.bettype = 1906 THEN -165 -- Bonus
				WHEN b.bettype BETWEEN 4301 AND 4598 THEN 247	-- SG
				WHEN b.bettype BETWEEN 4599 AND 4600 THEN -247	-- SG Jackpot Contribution and Jackpot Prize
				WHEN b.bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
				WHEN b.bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
				WHEN b.bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
				WHEN b.bettype BETWEEN 3101 AND 3149 THEN 243 -- AE Casino
				WHEN b.bettype = 3150 THEN -243 -- AE Casino Lucky Draw
				WHEN (b.bettype BETWEEN 1611 AND 1697 AND b.matchid <> 150) THEN 200 -- SBC
				WHEN (b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150) THEN -150 -- SBC FreeBets
				WHEN (b.bettype BETWEEN 1698 AND 1699 AND b.matchid <> 150) THEN -200 -- SBC Prize
				WHEN b.bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
				WHEN b.bettype = 3007 THEN -244 -- SAG Tip ticket
				WHEN b.bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
				WHEN b.bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
				WHEN (b.bettype BETWEEN 3001 AND 3099 AND b.bettype <> 3007) THEN 244 -- SAG
				WHEN bettype BETWEEN 5701 AND 5799 THEN 236 -- GDG
				WHEN bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
				WHEN bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
				WHEN bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
				WHEN (bettype BETWEEN 3801 AND 3897 AND b.matchid <> 173) THEN 171 -- VGA
				WHEN (bettype BETWEEN 3801 AND 3899 AND b.matchid = 173) THEN -173 -- VGA FreeBets
				WHEN (bettype BETWEEN 3898 AND 3899 AND b.matchid <> 173) THEN -171 -- VGA Prize
				WHEN bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba Promotion
				WHEN bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
				WHEN bettype BETWEEN 7701 AND 7799 THEN 172 -- AP
				WHEN bettype BETWEEN 7801 AND 7899 THEN 174 -- APM
			ELSE 0 END,--SportType
			SUM(CASE WHEN b.statusID NOT IN (101, 102, 103) THEN b.stake ELSE 0 END),--Turnover
			SUM(CASE WHEN b.ruben = 0 THEN b.actual_stake ELSE 0 END),--Outstanding
			SUM(CASE
					WHEN b.ruben = 1
						AND b.bettype NOT IN (4300, 4299, 4298, 4297, 3007, 1906, 1698, 1699, 3898, 3899, 4599, 4600)
						AND (b.bettype NOT BETWEEN 1611 AND 1697 OR b.matchid <> 150)
						AND (b.bettype NOT BETWEEN 3801 AND 3899 OR b.matchid <> 173)
						AND (b.bettype NOT BETWEEN 17000 AND 17030)
						THEN b.winlost - b.actual_stake
					ELSE 0
				END),--Winloss
			SUM(CASE WHEN b.statusID = 111 THEN b.stake ELSE 0 END),--DrawGame
			SUM(CASE WHEN b.ruben = 1 THEN b.playercomm ELSE 0 END),--Playercomm
			SUM(CASE WHEN b.bettype = 903 AND b.ruben = 1 AND b.statusID NOT IN (101, 102, 103) THEN b.awinlost ELSE 0 END),--Comm_BetTrade
			SUM(CASE WHEN b.bettype = 902 AND b.ruben = 1 AND b.statusID NOT IN (101, 102, 103) THEN b.winlost - b.actual_stake ELSE 0 END),--WLBoughtTicket_BetTrade
			SUM(CASE WHEN b.bettype < 19999 AND b.StatusID NOT IN (101, 102, 103) THEN 1 ELSE 0 END), --BetCount
			SUM(CASE
					WHEN b.bettype IN (4300, 4299, 4298, 4297, 3007, 1906, 1698, 1699, 3898, 3899, 4599, 4600)
						OR (b.bettype BETWEEN 1611 AND 1697 AND b.matchid = 150)
						OR (b.bettype BETWEEN 3801 AND 3899 AND b.matchid = 173)
						OR (b.bettype BETWEEN 17000 AND 17030)
						THEN b.winlost - b.actual_stake
					ELSE 0
				END) -- Promotion
		FROM dbo.bettrans14 b WITH (NOLOCK)
			INNER JOIN #DepCustID d on b.custid = d.CustID
		/*
			FROM (SELECT TOP (@n) custid FROM #DepCustID) d
			INNER JOIN bettrans14 b WITH (NOLOCK) on b.custid = d.CustID
			WHERE b.winlostdate = @Winlostdate
			GROUP BY b.custid, b.bettype
			OPTION(OPTIMIZE FOR (@n = 1)) --Trick SQL optimizer to use nested loop
		*/
		WHERE b.winlostdate = @WinLostDate
			AND b.bettype < 19999
			AND b.bettype <> 999
		GROUP BY
			b.custid,
			CASE
				WHEN b.bettype BETWEEN 81 AND 120 THEN 161--Number Game
				WHEN b.bettype BETWEEN 8101 AND 8120 THEN 164 --Number Game: Happy 5
				WHEN b.bettype BETWEEN 3601 AND 3610 THEN 168 --Happy 5 Linked Games
				WHEN b.bettype IN (71,72,23002) THEN 251--Casino
				WHEN b.bettype = 1000 THEN 253--games
				WHEN b.bettype BETWEEN 1201 AND 1299 THEN 180--Virtual Sport
				WHEN b.bettype BETWEEN 1501 AND 1599 THEN 202--Keno
				WHEN bettype BETWEEN 18000 AND 18006 THEN 204 --Colossus Bet
				WHEN b.bettype BETWEEN 4001 AND 4100 THEN 212--Voidbridge
				WHEN b.bettype = 901 THEN -2--BetTrade - Sold
				WHEN b.bettype = 902 THEN -3--BetTrade - Bought.
				WHEN b.bettype = 903 THEN -4--BetTrade - Commission
				WHEN b.bettype = 904 THEN -5--BetTrade - Winloss
				WHEN b.bettype = 911 THEN -6--Cash Out - Sold
				WHEN b.bettype = 912 THEN -7--Cash Out - Bought.
				WHEN b.bettype = 913 THEN -8--Cash Out - Commission
				WHEN b.bettype = 914 THEN -9--Cash Out - Winloss
				WHEN b.bettype BETWEEN 1800 AND 1899 THEN 250 -- AGC
				WHEN b.bettype BETWEEN 1700 AND 1799 THEN 255 -- GD
				WHEN b.bettype = 1900 THEN 249 -- VG
				WHEN b.bettype BETWEEN 2101 AND 2199 THEN 208
				WHEN b.bettype BETWEEN 2201 AND 2299 THEN 209
				WHEN (b.bettype BETWEEN 2301 AND 2399 OR b.bettype BETWEEN 2901 AND 2999) THEN 210
				WHEN b.bettype BETWEEN 2401 AND 2499 THEN 211 -- Allbet
				WHEN b.bettype BETWEEN 1011 AND 1020 THEN 219
				WHEN b.bettype BETWEEN 2701 AND 2799 THEN 190 -- Betradar VS
				WHEN b.bettype BETWEEN 2800 AND 2829 THEN 193 -- Betradar VS: Virtual Basketball
				WHEN b.bettype BETWEEN 1021 AND 1099 THEN 220 -- Lottery
				WHEN b.bettype BETWEEN 8000 AND 8099 THEN 221 -- Exchange
				WHEN b.bettype BETWEEN 4101 AND 4296 OR bettype BETWEEN 6701 AND 7000 THEN 248 -- PP
				WHEN b.bettype BETWEEN 4297 AND 4300 THEN -248 -- PP Prize
				WHEN (b.bettype BETWEEN 1901 AND 1999 AND bettype <> 1906) THEN 165 -- CC
				WHEN b.bettype = 1906 THEN -165 -- Bonus
				WHEN b.bettype BETWEEN 4301 AND 4598 THEN 247	-- SG
				WHEN b.bettype BETWEEN 4599 AND 4600 THEN -247	-- SG Jackpot Contribution and Jackpot Prize
				WHEN b.bettype BETWEEN 4601 AND 4900 THEN 245 -- VRG
				WHEN b.bettype BETWEEN 4901 AND 5000 THEN 222 -- TG
				WHEN b.bettype BETWEEN 5001 AND 5099 THEN 223 -- I4D
				WHEN b.bettype BETWEEN 3101 AND 3149 THEN 243 -- AE Casino
				WHEN b.bettype = 3150 THEN -243 -- AE Casino Lucky Draw
				WHEN (b.bettype BETWEEN 1611 AND 1697 AND b.matchid <> 150) THEN 200 -- SBC
				WHEN (b.bettype BETWEEN 1611 AND 1699 AND b.matchid = 150) THEN -150 -- SBC FreeBets
				WHEN (b.bettype BETWEEN 1698 AND 1699 AND b.matchid <> 150) THEN -200 -- SBC Prize
				WHEN b.bettype BETWEEN 6401 AND 6700 THEN 234 -- JK
				WHEN b.bettype = 3007 THEN -244 -- SAG Tip ticket
				WHEN b.bettype BETWEEN 6001 AND 6300 THEN 232 -- PGS
				WHEN b.bettype BETWEEN 3501 AND 3599 THEN 239 -- BGG
				WHEN (b.bettype BETWEEN 3001 AND 3099 AND b.bettype <> 3007) THEN 244 -- SAG
				WHEN bettype BETWEEN 5701 AND 5799 THEN 236 -- GDG
				WHEN bettype BETWEEN 3611 AND 3620 THEN 169 -- SLT
				WHEN bettype BETWEEN 7001 AND 7300 THEN 238 -- HB
				WHEN bettype BETWEEN 3401 AND 3499 THEN 233 -- WM
				WHEN (bettype BETWEEN 3801 AND 3897 AND b.matchid <> 173) THEN 171 -- VGA
				WHEN (bettype BETWEEN 3801 AND 3899 AND b.matchid = 173) THEN -173 -- VGA FreeBets
				WHEN (bettype BETWEEN 3898 AND 3899 AND b.matchid <> 173) THEN -171 -- VGA Prize
				WHEN bettype BETWEEN 17000 AND 17030 THEN 246 -- Saba Promotion
				WHEN bettype BETWEEN 7301 AND 7600 THEN 167 -- CG
				WHEN bettype BETWEEN 7701 AND 7799 THEN 172 -- AP
				WHEN bettype BETWEEN 7801 AND 7899 THEN 174 -- APM
				ELSE 0
			END--SportType
		OPTION (RECOMPILE, MAXDOP 8)

		/*--PREPARE DATA FOR rptDepWinlost--*/
		INSERT INTO #rptDepWinlost (
			CustID,
			Deposit,
			Withdrawal,
			Aff2MemTransfer,
			Bonus,
			Adjustment,
			TurnOver,
			OutStanding,
			Winloss,
			Transfer3rd,
			DrawGame,
			playercomm,
			Transfer3rdOthers,
			Comm_BetTrade,
			WLBoughtTicket_BetTrade,
			BonusWallet,
			AdjBonusWallet,
			Promotion)
		SELECT
			custid,
			SUM(Deposit), --Deposit
			SUM(Withdrawal),--Withdrawal
			SUM(Aff2MemTransfer), --Aff2MemTransfer
			SUM(Bonus),--Bonus
			SUM(Adjustment),--Adjustment
			SUM(Turnover),--Turnover
			SUM(Outstanding),--Outstanding
			SUM(CASE WHEN bettype NOT IN (246, -248, -244, -165, -150, -200, -243, -171, -173, -247) THEN Winloss ELSE 0 END),--Winloss
			SUM(Transfer3rd),--Transfer3rd
			SUM(DrawGame),--DrawGame
			SUM(Playercomm),--Playercomm
			SUM(Transfer3rdOthers),--Transfer3rdOthers
			SUM(Comm_BetTrade),--Comm_BetTrade
			SUM(WLBoughtTicket_BetTrade),--WLBoughtTicket_BetTrade
			SUM(BonusWallet), -- Bonus Wallet
			SUM(AdjBonusWallet), -- Adjustment Bonus Wallet
			SUM(Promotion) -- Promotion
		FROM #rptDepWinlostDetails
		WHERE Bettype NOT IN (-8, -9)
		GROUP BY custid

		--Update BA attributes
		INSERT INTO #BATrans (transid)
		SELECT transid
		FROM bodb_Licensee.dbo.LicenseeBATransaction_bk WITH (NOLOCK)
		WHERE WinlostDate = @Winlostdate

		UPDATE #rptDepWinlost
		SET Turnover_BA = ISNULL(t.turnover_ba,0),
			Comm_BA = ISNULL(t.Comm_BA,0),
			AmountDueTo_BA = ISNULL(t.AmountDueTo_BA,0)
		FROM (
			SELECT b.custid,
				SUM(b.stake) Turnover_BA,
				SUM(b.comm) AS Comm_BA,
				-SUM(b.winlost - b.actual_stake + b.awinlost + b.comm) AS AmountDueTo_BA
			FROM dbo.bettrans14 b WITH(NOLOCK)
			WHERE b.transid IN (SELECT transid FROM #BATrans)
				AND b.winlostdate = @Winlostdate
				AND b.ruben = 1
				AND b.statusID NOT IN (101, 102, 103)
			GROUP BY b.custid) AS t
		WHERE #rptDepWinlost.CustID = t.CustID

		--Update BetTrade attribute
		UPDATE #rptDepWinlost
		SET AmountDueTo_BetTrade = ISNULL(t.WLBeticket, 0) + WLBoughtTicket_BetTrade - Comm_BetTrade
		FROM (SELECT b.custid,
				SUM(CASE WHEN b.bettype NOT IN (902,903) THEN b.winlost - b.actual_stake ELSE 0 END) AS WLBeticket --WL of bet ticket of bettrade
			FROM dbo.bettrans14 b WITH (NOLOCK)
				INNER JOIN dbo.f_GetBetTradeCustList('All') bt ON b.custid = bt.Custid
			WHERE b.winlostdate = @Winlostdate
				--AND (b.bettype < 31 OR b.bettype BETWEEN 121 AND 999 OR b.bettype BETWEEN 1301 AND 1399)
				AND b.ruben = 1
				AND b.statusID NOT IN(101, 102, 103)
			GROUP BY b.custid) t
		WHERE #rptDepWinlost.custid = t.custid

		--Delete redundant data
		DELETE FROM #rptDepWinlost
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
		/*--END PREPARE DATA FOR rptDepWinlost--*/

		/*--PREPARE DATA FOR rptDepWinlostTransfer3rdOthers--*/
		DELETE FROM @RefNoList 
		DELETE FROM @TransferData 

		INSERT INTO @RefNoList(RefNo)
		SELECT b.refno
		FROM dbo.bettrans b WITH (NOLOCK)
			INNER JOIN @CasinoPartner p ON b.bettype = p.CancelTransferId
			INNER JOIN dbo.CustInfo c WITH (NOLOCK) ON b.custid = c.custid
			INNER JOIN dbo.Dep_CustSuper s WITH(NOLOCK) ON s.custid = c.srecommend
		WHERE b.matchid = 0
			AND b.winlostdate = @Winlostdate
			AND c.roleid = 1
		GROUP BY b.refno

		INSERT INTO @TransferData(CustId, PartnerId, TransferIn, TransferOut)
		SELECT b.CustId
			, p.PartnerId
			, SUM(CASE WHEN (b.winlost-b.actual_stake) < 0 THEN -(b.winlost-b.actual_stake) ELSE 0 END)--TransferIn
			, SUM(CASE WHEN (b.winlost-b.actual_stake) > 0 THEN -(b.winlost-b.actual_stake) ELSE 0 END) --TransferOut
		FROM dbo.bettrans b WITH (NOLOCK)
			INNER JOIN @CasinoPartner p ON b.bettype IN (p.CancelTransferId, p.PartnerId)
		WHERE b.refno IN (SELECT RefNo FROM @RefNoList)
		GROUP BY b.custid, p.PartnerId

		INSERT INTO #rptDepWinlostTransfer3rdOthers(
			CustId,
			PartnerId,
			TransferAmount,
			TransferIn,
			TransferOut)
		SELECT t.CustId
			, t.PartnerId
			, SUM(t.Transfer3rdOthers)--TransferAmount
			, SUM(t.Transfer3rdOthers_In - ISNULL(d.TransferIn, 0))--TransferIn
			, SUM(t.Transfer3rdOthers_Out - ISNULL(d.TransferOut, 0))--TransferOut
		FROM #rptDepWinlostDetails t
			INNER JOIN dbo.vw_Customer c WITH (NOLOCK) ON t.custid = c.custid
			INNER JOIN dbo.vw_Customer agent WITH (NOLOCK) ON c.recommend = agent.custid
			LEFT JOIN @TransferData d ON t.custid = d.CustId AND t.PartnerId = d.PartnerId
		WHERE t.PartnerId > -1
			AND (c.username2 IS NOT NULL OR (c.username2 IS NULL AND agent.username NOT LIKE '%ACC%'))
		GROUP BY t.CustId, t.PartnerId
		/*--END PREPARE DATA FOR rptDepWinlostTransfer3rdOthers--*/

		/*--PREPARE DATA FOR rptDepWinlostBonusWallet--*/
		INSERT INTO #rptDepWinlostBonusWallet (
			CustID,
			BonusType,
			Bonus,
			Adjustment)
		SELECT t.CustId
			, d.BonusType
			, SUM(ISNULL(t.BonusWallet, 0)) -- Bonus value of Bonus Wallet
			, SUM(ISNULL(t.AdjBonusWallet, 0))-- Adjustment value of Bonus Wallet
		FROM #rptDepWinlostDetails t
			INNER JOIN @BonusList d ON t.Bettype IN (d.BonusBettype, d.AdjustmentBettype)
		GROUP BY t.CustId, d.BonusType

		/*--END PREPARE DATA FOR rptDepWinlostBonusWallet--*/

		--For rptDepWinlost
		INSERT INTO #OLD_rptDepWinlost_Trans(Winlostdate, CustID, SportType, PartnerID, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover
			, Outstanding, Winloss, Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade, Comm_BetTrade_Full
			, AmountDueTo_BetTrade
			, Promotion
			)
		SELECT @Winlostdate, CustID, -1, -1, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, TurnOver
		, OutStanding, Winloss, Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade, 0
		, AmountDueTo_BetTrade
		, Promotion
		FROM #rptDepWinlost

		SELECT @NumberofCus = @@ROWCOUNT

		--For rptDepWinlostByProduct
		INSERT INTO #OLD_rptDepWinlost_Trans (
			Winlostdate,
			CustID,
			SportType,
			PartnerID,
			Turnover,
			DrawGame,
			Winloss,
			playercomm,
			BetCount,
			Outstanding)
		SELECT
			@Winlostdate,
			CustID,
			Bettype,
			-1,
			TurnOver,
			DrawGame,
			CASE WHEN Bettype IN (246, -248, -244, -165, -150, -200, -243, -171, -173, -247) THEN Promotion ELSE Winloss END AS Winloss,
			playercomm,
			BetCount,
			OutStanding
		FROM #rptDepWinlostDetails
		WHERE Bettype < 19999 --Only get SportType of bet ticket
			AND PartnerID = -1

		--For rptDepWinlost_Transfer3rdOthers
		INSERT INTO #OLD_rptDepWinlost_Trans (
			Winlostdate,
			CustID,
			SportType,
			PartnerID,
			TransferAmount,
			TransferIn,
			TransferOut)
		SELECT
			@Winlostdate,
			CustID,
			-1,
			PartnerID,
			TransferAmount,
			TransferIn,
			TransferOut
		FROM #rptDepWinlostTransfer3rdOthers

		--For rptDepWinlost_BonusWallet
		INSERT INTO #OLD_rptDepWinlost_BonusWallet (
			Winlostdate,
			CustID,
			BonusType,
			Bonus,
			Adjustment)
		SELECT
			@Winlostdate,
			CustID,
			BonusType,
			Bonus,
			Adjustment
		FROM #rptDepWinlostBonusWallet

		SELECT @isSuccessful = 1, @ErrMsg = ''

		--5.Update Log
		SELECT @LogDesc = @LogDesc + CONVERT(VARCHAR(20),@Winlostdate) + ' (No. of Customer affected: ' + CONVERT(VARCHAR(20), @NumberofCus) + '); Type: realtime'
						
	END TRY
	BEGIN CATCH
		SELECT @isSuccessful = 0, @ErrMsg = LEFT(ERROR_MESSAGE(),1000)
		SELECT @LogDesc = @LogDesc + '; Type: realtime' + '; ErrMsg: ' + @ErrMsg

		PRINT 'EXEC TASK_RealtimeSummaryDepData_Bettrans14, Winlostdate = ' + CONVERT(VARCHAR(20), @Winlostdate, 120) + ', ErrMsg: ' + ERROR_MESSAGE()
	END CATCH

	SELECT @LogDesc, @IsSuccessful, @ErrMsg
END

--## END - OLD - GEN DATA - OLD ##

DROP TABLE #rptDepWinlostDetails
DROP TABLE #rptDepWinlost
DROP TABLE #rptDepWinlostTransfer3rdOthers
DROP TABLE #rptDepWinlostBonusWallet
DROP TABLE #BATrans
DROP TABLE #DepCustID

--## COMPARE DATA ##

BEGIN
	--rptDepWinlost_Trans
	SELECT 
		old.Winlostdate				AS OLD_Winlostdate, new.Winlostdate					AS NEW_Winlostdate
		,old.CustID					AS OLD_CustID, new.CustID							AS NEW_CustID
		,old.SportType				AS OLD_SportType, new.SportType				AS NEW_SportType
		,old.PartnerID				AS OLD_PartnerID, new.PartnerID				AS NEW_PartnerID
		,old.Deposit				AS OLD_Deposit, new.Deposit					AS NEW_Deposit
		,old.Withdrawal				AS OLD_Withdrawal, new.Withdrawal				AS NEW_Withdrawal
		,old.Aff2MemTransfer		AS OLD_Aff2MemTransfer, new.Aff2MemTransfer		AS NEW_Aff2MemTransfer
		,old.Bonus					AS OLD_Bonus, new.Bonus							AS NEW_Bonus
		,old.Adjustment				AS OLD_Adjustment, new.Adjustment				AS NEW_Adjustment
		,old.Turnover				AS OLD_Turnover, new.Turnover					AS NEW_Turnover
		,old.Outstanding			AS OLD_Outstanding, new.Outstanding				AS NEW_Outstanding
		,old.Transfer3rd			AS OLD_Transfer3rd, new.Transfer3rd				AS NEW_Transfer3rd
		,old.Winloss				AS OLD_Winloss, new.Winloss						AS NEW_Winloss
		,old.DrawGame				AS OLD_DrawGame, new.DrawGame					AS NEW_DrawGame
		,old.Turnover_BA			AS OLD_Turnover_BA, new.Turnover_BA				AS NEW_Turnover_BA
		,old.Comm_BA				AS OLD_Comm_BA, new.Comm_BA						AS NEW_Comm_BA
		,old.AmountDueTo_BA			AS OLD_AmountDueTo_BA, new.AmountDueTo_BA		AS NEW_AmountDueTo_BA
		,old.playercomm				AS OLD_playercomm, new.playercomm				AS NEW_playercomm
		,old.Transfer3rdOthers		AS OLD_Transfer3rdOthers, new.Transfer3rdOthers	AS NEW_Transfer3rdOthers
		,old.Comm_BetTrade			AS OLD_Comm_BetTrade, new.Comm_BetTrade			AS NEW_Comm_BetTrade
		,old.Comm_Bettrade_Full		AS OLD_Comm_Bettrade_Full, new.Comm_Bettrade_Full		AS NEW_Comm_Bettrade_Full
		,old.AmountDueTo_BetTrade	AS OLD_AmountDueTo_BetTrade, new.AmountDueTo_BetTrade	AS NEW_AmountDueTo_BetTrade
		,old.BetCount				AS OLD_BetCount, new.BetCount					AS NEW_BetCount
		,old.TransferAmount			AS OLD_TransferAmount, new.TransferAmount		AS NEW_TransferAmount
		,old.TransferIn				AS OLD_TransferIn, new.TransferIn				AS NEW_TransferIn
		,old.TransferOut			AS OLD_TransferOut, new.TransferOut			AS NEW_TransferOut
		,old.Promotion				AS OLD_Promotion, new.Promotion				AS NEW_Promotion
	FROM #OLD_rptDepWinlost_Trans old
		FULL OUTER JOIN #NEW_rptDepWinlost_Trans new
			ON old.Winlostdate = new.Winlostdate AND old.CustID = new.CustID
				AND old.SportType = new.SportType AND old.PartnerID = new.PartnerID
	WHERE 
		(
			old.Winlostdate IS NULL
			OR new.Winlostdate IS NULL
			OR old.SportType <> new.SportType
			OR old.PartnerID <> new.PartnerID
			OR old.Deposit <> new.Deposit
			OR old.Withdrawal <> new.Withdrawal
			OR old.Aff2MemTransfer <> new.Aff2MemTransfer
			OR old.Bonus <> new.Bonus
			OR old.Adjustment <> new.Adjustment
			OR old.Turnover <> new.Turnover
			OR old.Outstanding <> new.Outstanding
			OR old.Transfer3rd <> new.Transfer3rd
			OR old.Winloss <> new.Winloss
			OR old.DrawGame <> new.DrawGame
			OR old.Turnover_BA <> new.Turnover_BA
			OR old.Comm_BA <> new.Comm_BA
			OR old.AmountDueTo_BA <> new.AmountDueTo_BA
			OR old.playercomm <> new.playercomm
			OR old.Transfer3rdOthers <> new.Transfer3rdOthers
			OR old.Comm_BetTrade <> new.Comm_BetTrade
			OR old.Comm_Bettrade_Full <> new.Comm_Bettrade_Full
			OR old.AmountDueTo_BetTrade <> new.AmountDueTo_BetTrade
			OR old.BetCount <> new.BetCount
			OR old.TransferAmount <> new.TransferAmount
			OR old.TransferIn <> new.TransferIn
			OR old.TransferOut <> new.TransferOut
			OR old.Promotion <> new.Promotion
		)

	--rptDepWinlost_BonusWallet
	SELECT 
		old.Winlostdate				AS OLD_Winlostdate, new.Winlostdate					AS NEW_Winlostdate
		,old.CustID					AS OLD_CustID, new.CustID							AS NEW_CustID
		,old.BonusType				AS OLD_BonusType, new.BonusType				AS NEW_BonusType
		,old.Bonus					AS OLD_Bonus, new.Bonus							AS NEW_Bonus
		,old.Adjustment				AS OLD_Adjustment, new.Adjustment				AS NEW_Adjustment
	
	FROM #OLD_rptDepWinlost_BonusWallet old
		FULL OUTER JOIN #NEW_rptDepWinlost_BonusWallet new
			ON old.Winlostdate = new.Winlostdate AND old.CustID = new.CustID
	WHERE 
		(
			old.Winlostdate IS NULL
			OR new.Winlostdate IS NULL
			OR old.BonusType <> new.BonusType
			OR old.Bonus <> new.Bonus
			OR old.Adjustment <> new.Adjustment
		)
END


DROP TABLE #NEW_rptDepWinlost_Trans
DROP TABLE #NEW_rptDepWinlost_BonusWallet
DROP TABLE #OLD_rptDepWinlost_Trans
DROP TABLE #OLD_rptDepWinlost_BonusWallet

--##################################################