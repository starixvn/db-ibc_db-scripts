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
	@IsSuccessful	BIT				= 0,
	@NumberofCus INT = 0 

--######### CREATE SCHEMA ############

BEGIN

	CREATE TABLE #OLD_rptDepWinlost_Main
	(
		[Winlostdate] [smalldatetime] NOT NULL,
		[CustID] [int] NOT NULL,
		[OpeningBalance] [money] NOT NULL,
		[actualrate] [float] NULL,
		[srecommend] [int] NOT NULL,
		[mrecommend] [int] NOT NULL,
		[recommend] [int] NOT NULL,
		[currency] [int] NOT NULL
	)

	CREATE UNIQUE CLUSTERED INDEX OLD_CIX_rptDepWinlost_Main ON #OLD_rptDepWinlost_Main
	(
		[Winlostdate] ASC,
		[CustID] ASC
	)

	CREATE TABLE #NEW_rptDepWinlost_Main
	(
		[Winlostdate] [smalldatetime] NOT NULL,
		[CustID] [int] NOT NULL,
		[OpeningBalance] [money] NOT NULL,
		[actualrate] [float] NULL,
		[srecommend] [int] NOT NULL,
		[mrecommend] [int] NOT NULL,
		[recommend] [int] NOT NULL,
		[currency] [int] NOT NULL
	) 

	CREATE UNIQUE CLUSTERED INDEX NEW_CIX_rptDepWinlost_Main ON #NEW_rptDepWinlost_Main
	(
		[Winlostdate] ASC,
		[CustID] ASC
	)

END

--## END - CREATE SCHEMA ##--

--## COMMON DECLARE SECTION ##--

BEGIN

	SET NOCOUNT ON

	IF @Winlostdate > CURRENT_TIMESTAMP OR NOT EXISTS (SELECT TOP 1 1 FROM dbo.bettrans14 WITH (NOLOCK) WHERE winlostdate = @Winlostdate AND bettype < 19999 AND bettype <> 18000)
		BEGIN
			PRINT 'EXEC GEN_HourlySummaryDepData_Bettrans14: There is no data in bettrans14 to summarize or input @Winlostdate is greater than current day ==> RETURN'
			RETURN
		END

	DECLARE @i TINYINT = 1
	DECLARE @PreviousDay DATE = DATEADD(DAY,-1,@WinlostDate)
	SET @isSuccessful = 0

	DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
	INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
	EXEC bodb02.dbo.Age_SelBalanceUpDay
	
	DECLARE @BalanceUpDay SMALLDATETIME, @MoveBetsDay SMALLDATETIME
	SELECT  @BalanceUpDay = BalanceUpDay, @MoveBetsDay = MoveBetsDay FROM @MBBU
	
	CREATE TABLE #rptDepWinlost_Main (CustID INT, OpeningBalance MONEY DEFAULT (0), actualrate FLOAT DEFAULT (0), srecommend INT, mrecommend INT, recommend INT, currency INT
											  UNIQUE CLUSTERED (CustID))
	
	CREATE TABLE #OpeningBalance 
	(CustID INT, OpeningBalance MONEY DEFAULT(0), srecommend INT, mrecommend INT, recommend INT, currency INT)

END

--## END - COMMON DECLARE SECTION ##--

--## NEW - GEN DATA - NEW ##

BEGIN
		
	IF EXISTS (SELECT TOP 1 1 FROM bodb_Report.dbo.rptDepWinlost_Main WITH (NOLOCK) WHERE winlostdate = @PreviousDay)
	BEGIN
		SELECT 'Code unchanged in the Split Transfer release - RETURN'
		RETURN 
	END
	ELSE --
	BEGIN
		----insert temp data to sum later
		--from bettrans
		INSERT INTO #OpeningBalance(CustID, OpeningBalance, srecommend, mrecommend, recommend, currency)
		SELECT b.CustID
				, SUM(CASE @Winlostdate WHEN @BalanceUpDay 
					    THEN 0
						ELSE CASE WHEN winlostdate < @Winlostdate THEN winlost - actual_stake + playercomm ELSE 0 END 
						END) AS OpeningBalance
				, b.srecommend, b.mrecommend, b.recommend, 
				CASE 
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate < '20141128' THEN 13
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate >= '20141128' THEN 66 
				ELSE b.currency 
				END AS currency
		FROM dbo.bettrans b WITH (NOLOCK) 
			INNER JOIN dbo.Dep_CustSuper d WITH (NOLOCK) ON b.srecommend = d.custid
			INNER JOIN dbo.CustInfo c WITH (NOLOCK) ON b.custid = c.custid
		WHERE b.winlostdate <= @Winlostdate
				AND b.matchid >= 0
				AND c.roleid = 1
				AND	bettype < 19999 AND winlostdate > @MoveBetsDay
		GROUP BY b.custid, b.srecommend, b.mrecommend, b.recommend, 
				CASE 
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate < '20141128' THEN 13
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate >= '20141128' THEN 66 
					ELSE b.currency
				END


		SELECT * FROM #OpeningBalance

		--from transfer
		INSERT INTO #OpeningBalance(CustID, OpeningBalance, srecommend, mrecommend, recommend, currency)
		SELECT b.CustID
				, SUM(CASE @Winlostdate WHEN @BalanceUpDay 
					    THEN CASE WHEN bettype = 20000 THEN winlost - actual_stake + playercomm ELSE 0 END 
						ELSE CASE WHEN winlostdate < @Winlostdate THEN winlost - actual_stake + playercomm ELSE 0 END 
						END) AS OpeningBalance
				, b.srecommend, b.mrecommend, b.recommend, 
				CASE 
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate < '20141128' THEN 13
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate >= '20141128' THEN 66 
				ELSE b.currency 
				END AS currency
		FROM dbo.transfer b WITH (NOLOCK) 
			INNER JOIN dbo.Dep_CustSuper d WITH (NOLOCK) ON b.srecommend = d.custid
			INNER JOIN dbo.CustInfo c WITH (NOLOCK) ON b.custid = c.custid
		WHERE b.winlostdate <= @Winlostdate
				AND c.roleid = 1
				AND (bettype = 19999 AND winlostdate <= @MoveBetsDay OR b.Bettype > 19999)
		GROUP BY b.custid, b.srecommend, b.mrecommend, b.recommend, 
				CASE 
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate < '20141128' THEN 13
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate >= '20141128' THEN 66 
					ELSE b.currency
				END
		
		INSERT INTO #rptDepWinlost_Main (CustID, OpeningBalance, srecommend, mrecommend, recommend, currency)
		SELECT b.custid, SUM(ISNULL(b.OpeningBalance, 0)), b.srecommend, b.mrecommend, b.recommend, b.currency
		FROM #OpeningBalance b
		GROUP BY b.custid, b.srecommend, b.mrecommend, b.recommend, b.currency
				
		DELETE FROM #rptDepWinlost_Main
		WHERE CustID NOT IN (SELECT CustID FROM bodb_Report.dbo.rptDepWinlost_Trans WITH (NOLOCK) WHERE Winlostdate = @Winlostdate)
			AND OpeningBalance = 0
				
		DELETE FROM #NEW_rptDepWinlost_Main WITH (UPDLOCK, ROWLOCK)
		WHERE Winlostdate = @Winlostdate
				
		INSERT INTO #NEW_rptDepWinlost_Main (Winlostdate, CustID, OpeningBalance, actualrate, srecommend, mrecommend, recommend, currency)
		SELECT @Winlostdate, mt.CustID, mt.OpeningBalance, e.ActualRate, mt.srecommend, mt.mrecommend, mt.recommend, mt.currency
		FROM #rptDepWinlost_Main mt	 
		INNER JOIN dbo.ExchangeDailyOanda e WITH (NOLOCK) ON mt.currency = e.ExchangeId AND e.ExchangeDate = @Winlostdate 
				
		SELECT @NumberofCus = @@ROWCOUNT
			
		SET @isSuccessful = 1

		
	END

END

--## END - NEW - GEN DATA - END ##

--CLEAR DATA FROM TEMP TABLE
TRUNCATE TABLE #rptDepWinlost_Main
TRUNCATE TABLE #OpeningBalance

SELECT @NumberofCus = 0, @IsSuccessful = 0
--## OLD - GEN DATA - OLD ##

BEGIN
	
	IF EXISTS (SELECT TOP 1 1 FROM bodb_Report.dbo.rptDepWinlost_Main WITH (NOLOCK) WHERE winlostdate = @PreviousDay)
	BEGIN
		SELECT 'Code unchanged in the Split Transfer release - RETURN'
		RETURN 
	END
	ELSE --
	BEGIN
		INSERT INTO #rptDepWinlost_Main (CustID, OpeningBalance, srecommend, mrecommend, recommend, currency)
		SELECT b.CustID
				, SUM(CASE @Winlostdate WHEN @BalanceUpDay 
						THEN CASE WHEN bettype = 20000 THEN winlost - actual_stake + playercomm ELSE 0 END 
						ELSE CASE WHEN winlostdate < @Winlostdate THEN winlost - actual_stake + playercomm ELSE 0 END 
						END)
				, b.srecommend, b.mrecommend, b.recommend, 
				CASE 
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate < '20141128' THEN 13
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate >= '20141128' THEN 66 
				ELSE b.currency 
				END
		FROM dbo.bettrans b WITH (NOLOCK) 
			INNER JOIN dbo.Dep_CustSuper d WITH (NOLOCK) ON b.srecommend = d.custid
			INNER JOIN dbo.CustInfo c WITH (NOLOCK) ON b.custid = c.custid
		WHERE b.winlostdate <= @Winlostdate
				AND b.matchid >= 0
				AND c.roleid = 1
				AND 1 = CASE
					WHEN b.bettype = 19999 AND b.winlostdate > @MoveBetsDay THEN 0
					WHEN b.bettype < 19999 AND b.winlostdate <= @MoveBetsDay THEN 0
					ELSE 1 END
		GROUP BY b.custid, b.srecommend, b.mrecommend, b.recommend, 
				CASE 
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate < '20141128' THEN 13
					WHEN b.recommend IN (14373731, 14373733) AND @Winlostdate >= '20141128' THEN 66 
				ELSE b.currency
				END
		OPTION (RECOMPILE, MAXDOP 8)
				
		DELETE FROM #rptDepWinlost_Main
		WHERE CustID NOT IN (SELECT CustID FROM bodb_Report.dbo.rptDepWinlost_Trans WITH (NOLOCK) WHERE Winlostdate = @Winlostdate)
			AND OpeningBalance = 0
				
		DELETE FROM #OLD_rptDepWinlost_Main WITH (UPDLOCK, ROWLOCK)
		WHERE Winlostdate = @Winlostdate
				
		INSERT INTO #OLD_rptDepWinlost_Main (Winlostdate, CustID, OpeningBalance, actualrate, srecommend, mrecommend, recommend, currency)
		SELECT @Winlostdate, mt.CustID, mt.OpeningBalance, e.ActualRate, mt.srecommend, mt.mrecommend, mt.recommend, mt.currency
		FROM #rptDepWinlost_Main mt	 
		INNER JOIN dbo.ExchangeDailyOanda e WITH (NOLOCK) ON mt.currency = e.ExchangeId AND e.ExchangeDate = @Winlostdate 
				
		SELECT @NumberofCus = @@ROWCOUNT
			
		SET @isSuccessful = 1
	END

END

--## END - OLD - GEN DATA - OLD ##

DROP TABLE #rptDepWinlost_Main
DROP TABLE #OpeningBalance

--## COMPARE DATA ##

BEGIN
	--rptDepWinlost_Trans
	SELECT 
		old.Winlostdate				AS OLD_Winlostdate, new.Winlostdate					AS NEW_Winlostdate
		,old.CustID					AS OLD_CustID, new.CustID							AS NEW_CustID
		,old.OpeningBalance			AS OLD_OpeningBalance, new.OpeningBalance			AS NEW_OpeningBalance
		,old.actualrate				AS OLD_actualrate, new.actualrate				AS NEW_actualrate
		,old.srecommend				AS OLD_srecommend, new.srecommend				AS NEW_srecommend
		,old.mrecommend				AS OLD_mrecommend, new.mrecommend				AS NEW_mrecommend
		,old.recommend				AS OLD_recommend, new.recommend					AS NEW_recommend
		,old.currency					AS OLD_currency, new.currency				AS NEW_currency
	
	FROM #OLD_rptDepWinlost_Main old
		FULL OUTER JOIN #NEW_rptDepWinlost_Main new
			ON old.Winlostdate = new.Winlostdate AND old.CustID = new.CustID
	WHERE 
		(
			old.Winlostdate IS NULL
			OR new.Winlostdate IS NULL
			OR old.OpeningBalance <> new.OpeningBalance
			OR old.actualrate <> new.actualrate
			OR old.srecommend <> new.srecommend
			OR old.mrecommend <> new.mrecommend
			OR old.recommend <> new.recommend
			OR old.currency <> new.currency
		)

END

DROP TABLE #OLD_rptDepWinlost_Main
DROP TABLE #NEW_rptDepWinlost_Main

--##################################################