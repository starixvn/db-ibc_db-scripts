USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_Lucky3_CreateData]
	@matchid		INT				= NULL,
	@matchStatus	VARCHAR(20)		= NULL,
	@betStatus		VARCHAR(20)		= NULL,
	@winlostdate	SMALLDATETIME	= NULL,
	@sporttype		SMALLINT		= 160,
	@bettype		INT				= 1600,

	@username		NVARCHAR(50)	= NULL,
	@custid			INT				= NULL,
	
	@numOfTickets	INT				= 10,
	@numOfBets		INT				= 1,
	
	@choiceList		VARCHAR(50)		= '10,13,22,34,45',
	@winList		VARCHAR(10)		= '10,13,22',

	@isClearData	BIT				= 1,
	@isCreateLeague	BIT				= 0,
	@isCreateMatch	BIT				= 0
AS

/*
	Created by Percy
	Date: 2017-08-08
	Task: Create testing data of Lucky 3
	DB: DB206

	Params:
		- @matchStatus: 'running', 'Completed'
		- @betStatus: NULL, 'Refund'
		- @choiceList: list of numbers, from 01 to 75, 3 --> 15 numbers
		- @winList: list of win number, from 01 to 75, 3 numbers
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @tmpWinlostdate SMALLDATETIME
	SELECT  @tmpWinlostdate = @winlostdate

	SELECT  @winlostdate = NULL

	DECLARE @NoOfNumber TINYINT, @minN TINYINT, @maxN TINYINT, @NoOfCombination BIGINT
	
	DECLARE @choiceNumber TABLE (number VARCHAR(2))
	DECLARE @winNumber TABLE (number VARCHAR(2))

	INSERT INTO @choiceNumber (number)
	SELECT CONVERT(VARCHAR(2), val) FROM dbo.strSplit(@choiceList, ',')

	SELECT @NoOfNumber = @@ROWCOUNT

	IF @NoOfNumber < 3 OR @NoOfNumber > 15
	BEGIN
		SELECT '@choiceList is wrong, it should be 3 --> 15 numbers'
		RETURN
	END

	SELECT TOP 1 @NoOfCombination = Combination FROM Lucky3RefCombination WITH (NOLOCK) WHERE BallCount = @NoOfNumber

	INSERT INTO @winNumber (number)
	SELECT CONVERT(VARCHAR(2), val) FROM dbo.strSplit(@winList, ',')

	IF @@ROWCOUNT <> 3
	BEGIN
		SELECT '@winList is wrong, it should be 3 numbers'
		RETURN
	END

	SELECT @minN = MIN(number), @maxN = MAX(number) FROM @choiceNumber

	IF @minN < 1 OR @maxN > 75
	BEGIN
		SELECT '@choiceList is wrong, it should be from 01 to 75'
		RETURN
	END

	SELECT @minN = MIN(number), @maxN = MAX(number) FROM @winNumber

	IF @minN < 1 OR @maxN > 75
	BEGIN
		SELECT '@winList is wrong, it should be from 01 to 75'
		RETURN
	END

	IF ISNULL(@numOfTickets, 0) <= 0
		SELECT @numOfTickets = 1

	IF ISNULL(@matchStatus, 'running') NOT IN ('running', 'Completed')
	BEGIN
		SELECT 'Status of match must be running/Completed'
		RETURN
	END

	IF NOT EXISTS (
		SELECT TOP 1 1
		FROM dbo.SportBettypeMatrix s WITH(NOLOCK)
		WHERE s.ProductID = 26 AND s.SportType = ISNULL(@sporttype, s.SportType) AND s.BetType = ISNULL(@bettype, s.BetType)
	)
	BEGIN
		SELECT 'This product not offer this sporttype/bettype: SELECT * FROM dbo.SportBettypeMatrix WITH(NOLOCK) WHERE ProductID = 26'
		RETURN
	END

	DECLARE @srecommend INT, @mrecommend INT, @recommend INT, @currency INT, @actualrate FLOAT, @leagueid INT
	DECLARE @range TINYINT = 0 -- 1: bettrans, 2: bettrans14, 3: bettrans_bk
	DECLARE @MBDate SMALLDATETIME, @BUDate SMALLDATETIME

	---- match info ----
	IF @matchid IS NOT NULL
	BEGIN
		SELECT @leagueid = leagueid, @sporttype = sporttype, @winlostdate = eventdate, @matchStatus = eventstatus
		FROM dbo.match WITH (NOLOCK)
		WHERE matchid = @matchid

		IF @leagueid IS NOT NULL
		BEGIN
			SELECT @range = 1 -- bettrans
		END
		ELSE
		BEGIN
			SELECT @leagueid = leagueid, @sporttype = sporttype, @winlostdate = eventdate
			FROM dbo.match14 WITH (NOLOCK)
			WHERE matchid = @matchid
			
			IF @leagueid IS NOT NULL
			BEGIN
				SELECT @range = 2 -- bettrans14
			END
		END

		IF @leagueid IS NULL
		BEGIN
			SELECT @leagueid = leagueid, @sporttype = sporttype, @winlostdate = eventdate
			FROM DBARC.bodb_Archive.dbo.match_bk WITH (NOLOCK)
			WHERE matchid = @matchid
			
			IF @leagueid IS NOT NULL
			BEGIN
				SELECT @range = 3 -- bettrans_bk
			END
		END

		-- check match is invalid
		IF @leagueid IS NULL
		BEGIN
			SELECT 'This match is invalid (Not has league)'
			RETURN
		END
		ELSE IF NOT EXISTS (
			SELECT TOP 1 1
			FROM dbo.SportBettypeMatrix s WITH(NOLOCK)
			WHERE s.ProductID = 26 AND s.SportType = @sporttype AND s.BetType = ISNULL(@bettype, s.BetType)
		)
		BEGIN
			SELECT 'This match do not offer this sporttype/bettype!'
			RETURN
		END
	END
	-- if match is null, create match
	ELSE IF @isCreateMatch = 0
	BEGIN
		IF @sporttype IS NOT NULL AND @bettype IS NULL
			SELECT TOP 1 @bettype = BetType FROM dbo.SportBettypeMatrix WITH (NOLOCK) WHERE ProductID = 26 AND SportType = @sporttype

		IF @sporttype IS NULL AND @bettype IS NOT NULL
			SELECT TOP 1 @sporttype = SportType FROM dbo.SportBettypeMatrix WITH (NOLOCK) WHERE ProductID = 26 AND BetType = @bettype

		IF @sporttype IS NULL OR @bettype IS NULL
		BEGIN
			SELECT 'Please check data of SportBettypeMatrix!'
		END

		IF @winlostdate IS NULL
			SELECT @winlostdate = CONVERT(DATE, GETDATE())

		SELECT TOP 1 @leagueid = leagueid FROM dbo.League WITH (NOLOCK) WHERE sporttype = @sporttype

		IF @@ROWCOUNT = 0 OR @isCreateLeague = 1
		BEGIN
			INSERT INTO dbo.League (leaguename, creator, sporttype, createdate, DisplayMode, isTest, IsActive, IsMainMarket, outright, DisplayCat)
			VALUES ('Lucky 3 - League', 8, @sporttype, @winlostdate, 0, 1, 1, 0, 0, 0)

			SELECT @leagueid = SCOPE_IDENTITY()

			UPDATE dbo.League WITH (ROWLOCK, UPDLOCK)
			SET leaguename = 'Lucky 3 - League ' + CONVERT(VARCHAR(20), leagueid)
			WHERE leagueid = @leagueid

			INSERT INTO dbo.match
			(
				leagueid, homeid, awayid, eventdate, eventstatus, betstatus, creator, sporttype, homeid2, awayid2,
				DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, HasLive,
				kickofftime, closedtime, showtime
			)
			VALUES
			(
				@leagueid, 1, 5, @winlostdate, 'running', 'running', 8, @sporttype, 1, 1,
				1, 1, 1, 1, 1, 1,
				@winlostdate, @winlostdate, @winlostdate
			)

			SELECT @matchid = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			SELECT TOP 1 @matchid = matchid FROM dbo.match WITH (NOLOCK) WHERE leagueid = @leagueid AND sporttype = @sporttype
				AND (@matchStatus IS NULL OR eventstatus = @matchStatus)

			IF @@ROWCOUNT = 0
			BEGIN
				INSERT INTO dbo.match
				(
					leagueid, homeid, awayid, eventdate, eventstatus, betstatus, creator, sporttype, homeid2, awayid2,
					DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, HasLive,
					kickofftime, closedtime, showtime
				)
				VALUES
				(
					@leagueid, 1, 5, @winlostdate, 'running', 'running', 8, @sporttype, 1, 1,
					1, 1, 1, 1, 1, 1,
					@winlostdate, @winlostdate, @winlostdate
				)

				SELECT @matchid = SCOPE_IDENTITY()
			END
		END

		SELECT @range = 1
	END
	ELSE
	BEGIN
		IF @sporttype IS NOT NULL AND @bettype IS NULL
			SELECT TOP 1 @bettype = BetType FROM dbo.SportBettypeMatrix WITH (NOLOCK) WHERE ProductID = 26 AND SportType = @sporttype

		IF @sporttype IS NULL AND @bettype IS NOT NULL
			SELECT TOP 1 @sporttype = SportType FROM dbo.SportBettypeMatrix WITH (NOLOCK) WHERE ProductID = 26 AND BetType = @bettype

		IF @sporttype IS NULL OR @bettype IS NULL
		BEGIN
			SELECT 'Please check data of SportBettypeMatrix!'
		END

		IF @winlostdate IS NULL
			SELECT @winlostdate = CONVERT(DATE, GETDATE())
			
		SELECT TOP 1 @leagueid = leagueid FROM dbo.League WITH (NOLOCK) WHERE sporttype = @sporttype

		IF @@ROWCOUNT = 0 OR @isCreateLeague = 1
		BEGIN
			INSERT INTO dbo.League (leaguename, creator, sporttype, createdate, DisplayMode, isTest, IsActive, IsMainMarket, outright, DisplayCat)
			VALUES ('Lucky 3 - League', 8, @sporttype, @winlostdate, 0, 1, 1, 0, 0, 0)

			SELECT @leagueid = SCOPE_IDENTITY()

			UPDATE dbo.League WITH (ROWLOCK, UPDLOCK)
			SET leaguename = 'Lucky 3 - League ' + CONVERT(VARCHAR(20), leagueid)
			WHERE leagueid = @leagueid

			INSERT INTO dbo.match
			(
				leagueid, homeid, awayid, eventdate, eventstatus, betstatus, creator, sporttype, homeid2, awayid2,
				DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, HasLive,
				kickofftime, closedtime, showtime
			)
			VALUES
			(
				@leagueid, 1, 5, @winlostdate, 'running', 'running', 8, @sporttype, 1, 1,
				1, 1, 1, 1, 1, 1,
				@winlostdate, @winlostdate, @winlostdate
			)

			SELECT @matchid = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			INSERT INTO dbo.match
			(
				leagueid, homeid, awayid, eventdate, eventstatus, betstatus, creator, sporttype, homeid2, awayid2,
				DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, HasLive,
				kickofftime, closedtime, showtime
			)
			VALUES
			(
				@leagueid, 1, 5, @winlostdate, 'running', 'running', 8, @sporttype, 1, 1,
				1, 1, 1, 1, 1, 1,
				@winlostdate, @winlostdate, @winlostdate
			)

			SELECT @matchid = SCOPE_IDENTITY()

			SELECT @range = 1
		END
	END
	---- cust info ----
	IF @custid IS NOT NULL
	BEGIN
		SELECT
			@srecommend = c.srecommend, @mrecommend = c.mrecommend, @recommend = c.recommend, @username = c.username,
			@currency = c.currency, @actualrate = e.actualrate
		FROM CustDB.dbo.custInfo c WITH (NOLOCK)
			INNER JOIN dbo.exchange e WITH (NOLOCK) ON c.currency = e.exchangeid
		WHERE c.custid = @custid AND c.roleid = 1
	END
	ELSE IF ISNULL(@username, '') <> ''
	BEGIN
		SELECT
			@srecommend = c.srecommend, @mrecommend = c.mrecommend, @recommend = c.recommend, @custid = c.custid,
			@currency = c.currency, @actualrate = e.actualrate
		FROM CustDB.dbo.custInfo c WITH (NOLOCK)
			INNER JOIN dbo.exchange e WITH (NOLOCK) ON c.currency = e.exchangeid
		WHERE c.username = @username AND c.roleid = 1
	END

	IF @srecommend IS NULL
	BEGIN
		SELECT TOP 1
			@srecommend = c.srecommend, @mrecommend = c.mrecommend, @recommend = c.recommend, @username = c.username, @custid = c.custid,
			@currency = c.currency, @actualrate = e.actualrate
		FROM CustDB.dbo.custInfo c WITH (NOLOCK)
			INNER JOIN dbo.exchange e WITH (NOLOCK) ON c.currency = e.exchangeid
		WHERE c.roleid = 1
	END

	---- bettrans ----
	DECLARE @Numbers TABLE (ID INT IDENTITY(1,1))
	WHILE 1=1
	BEGIN 
		INSERT INTO @Numbers DEFAULT VALUES
		
		IF SCOPE_IDENTITY() >= @numOfTickets
			BREAK;
	END

	DECLARE @transdate SMALLDATETIME
	SELECT  @transdate = DATEADD(SECOND, DATEDIFF(SECOND, CONVERT(DATE, GETDATE()), GETDATE()), @winlostdate)

	SELECT @bettype = ISNULL(@bettype, 1600), @numOfTickets = ISNULL(@numOfTickets, 1)

	DECLARE @transid TABLE (transid BIGINT)

	IF @isClearData = 1
	BEGIN
		DELETE dbo.bettrans WITH(ROWLOCK, UPDLOCK)
		WHERE custid = @custid AND winlostdate = @winlostdate AND bettype = @bettype
	END

	-- insert running tickets --
	DECLARE @combination SMALLINT
	SELECT @combination = Combination
	FROM dbo.Lucky3RefCombination WITH (NOLOCK)
	WHERE BallCount = @NoOfNumber
		AND HitCount = 3

	DECLARE @hdp1 SMALLMONEY
	SELECT @hdp1 = l.Price
	FROM dbo.Lucky3PrizeSettingDetail l WITH (NOLOCK)
	WHERE l.PrizeSettingID = 1
		AND l.ExchangeID = @currency

	INSERT INTO dbo.bettrans
	(
		matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
		winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
		apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
		sdiscount, adiscount, discount, playerdiscount,
		livehomescore, liveawayscore, creator, refno,
		winlostdate, betfrom, checktime, oddsspread, oddstype,
		currency, actualrate, virtualrate,
		srecommend, mrecommend, recommend, custid, Username,
		ip, bettype, transdesc, betid
	)
	OUTPUT INSERTED.transid INTO @transid (transid)
	SELECT @matchid, @transdate, 98344397, ISNULL(@hdp1, 1), NULL, @numOfBets AS odds, stake * @combination, stake * @combination, 'running', 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,
		0.4, 0.3, 0.15, 0.85,
		0, 0, 0, 0,
		@NoOfNumber AS livehomescore, 0, 8, 100000000000,
		@winlostdate, 'd', @transdate, 0, 1,
		@currency, @actualrate, @actualrate,
		@srecommend, @mrecommend, @recommend, @custid, @username,
		'127.1.1.0', @bettype, @choiceList, @NoOfCombination
	FROM (VALUES (@numOfBets)) AS A (stake)
	CROSS APPLY @Numbers n

	-- settle tickets --
	SELECT @matchStatus = ISNULL(@matchStatus, 'running')

	DECLARE @MBBUDay TABLE (BUDay SMALLDATETIME, MBDay SMALLDATETIME)
	
	INSERT INTO @MBBUDay (BUDay, MBDay)
	EXEC DBAGE.bodb02.dbo.Age_SelBalanceUpDay

	SELECT TOP 1 @MBDate = MBDay, @BUDate = BUDay FROM @MBBUDay

	IF @tmpWinlostdate <= @MBDate
	BEGIN
		SELECT @matchStatus = 'Completed', @range = 2

		IF @tmpWinlostdate < @BUDate
			SELECT @range = 3
	END

	IF @matchStatus = 'Completed'
	BEGIN
		-- update match
		IF 3 = (SELECT COUNT(*) FROM dbo.bingoBall WITH (NOLOCK) WHERE Matchid = @matchid)
		BEGIN
			DELETE @winNumber

			INSERT INTO @winNumber (number)
			SELECT Number FROM dbo.bingoBall WITH (NOLOCK)
		END
		ELSE
		BEGIN
			DELETE dbo.bingoBall WITH (ROWLOCK, UPDLOCK) WHERE Matchid = @matchid

			INSERT INTO dbo.bingoBall (Matchid, Seq, Number, sporttype)
			SELECT @matchid, ROW_NUMBER() OVER(ORDER BY number) AS seq, number, @sporttype
			FROM @winNumber
		END

		DECLARE @FirstBall TINYINT, @SecondBall TINYINT, @ThirdBall TINYINT

		SELECT
			@FirstBall = CASE Seq WHEN 1 THEN Number ELSE @FirstBall END,
			@SecondBall = CASE Seq WHEN 2 THEN Number ELSE @SecondBall END,
			@ThirdBall = CASE Seq WHEN 3 THEN Number ELSE @ThirdBall END
		FROM dbo.bingoBall WITH (NOLOCK)
		WHERE Matchid = @matchid

		DECLARE @p1 INT = 0, @p2 VARCHAR(200) = ''
		EXEC [dbo].[NAP_Admin_Settlement_s160]  
			 @MatchId = @matchid
			 ,@Action = 'CAL'  
			 ,@IsAuto = 0
			 ,@FirstBall = @FirstBall
			 ,@SecondBall = @SecondBall
			 ,@ThirdBall = @ThirdBall
			 ,@AdminId = 8
			 ,@IP = ''
   
			 ,@ErrCode = @p1 OUTPUT
			 ,@ErrMsg = @p2 OUTPUT
		
		IF @p1 <> 0
		BEGIN
			SELECT @p2 AS 'Settle failed!'
			RETURN
		END

		UPDATE dbo.match WITH (ROWLOCK, UPDLOCK)
			SET eventstatus = 'Completed'
			WHERE matchid = @matchid
	END

	SELECT @custid AS custid, @username AS username, @matchid AS matchid, @range AS range

	-- archive data
	IF @range > 1
	BEGIN
		DELETE dbo.bingoBall14 WITH (ROWLOCK, UPDLOCK) WHERE Matchid = @matchid

		INSERT INTO dbo.bingoBall14 (Matchid, Seq, Number)
		SELECT Matchid, seq, number
		FROM dbo.bingoBall WITH (NOLOCK)
		WHERE Matchid = @matchid
		
		DELETE dbo.BetLucky3Result14 WITH (ROWLOCK, UPDLOCK)
		WHERE MatchId = @matchid

		INSERT INTO dbo.BetLucky3Result14
		(
			MatchId,TransId,CustId,Bettype,Currency,Hdp1,Odds,StatusId,Hits,Prize,PrizeAmount,Winlost,aWinlost,mWinlost,sWinlost,
			PlayerComm,Comm,aComm,sComm,aPositionTaking,mPositionTaking,sPositionTaking,PlayerDiscount,Discount,aDiscount,sDiscount,TransDesc
		)
		SELECT
			MatchId,TransId,CustId,Bettype,Currency,Hdp1,Odds,StatusId,Hits,Prize,PrizeAmount,Winlost,aWinlost,mWinlost,sWinlost,
			PlayerComm,Comm,aComm,sComm,aPositionTaking,mPositionTaking,sPositionTaking,PlayerDiscount,Discount,aDiscount,sDiscount,TransDesc
		FROM dbo.BetLucky3Result WITH (NOLOCK)
		WHERE MatchId = @matchid
		
		INSERT INTO dbo.match14
		(
			[matchid], [leagueid], [homeid], [awayid],
			[eventdate], [eventstatus],
			[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
			[creator], [matchcode], [kickofftime], [closedtime], [showtime],
			[hthomescore], [htawayscore], [ruben], [multiple],
			[sporttype], [IsNeutral], [GlobalShowTime], [settletime], [ParentID]
		)
		SELECT
			[matchid], [leagueid], [homeid], [awayid],
			@tmpwinlostdate, [eventstatus],
			[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
			[creator], [matchcode], [kickofftime], [closedtime], [showtime],
			[hthomescore], [htawayscore], [ruben], [multiple],
			[sporttype], [IsNeutral], [GlobalShowTime], [settletime], [ParentID]
		FROM dbo.match WITH(NOLOCK)
		WHERE matchid = @matchid

		-- Insert into sum_winloss and move bettrans14
		DELETE dbo.bettrans14 WITH(ROWLOCK, UPDLOCK)
		WHERE custid = @custid AND winlostdate = @tmpwinlostdate AND bettype = @bettype

		INSERT INTO dbo.bettrans14
		(
			transid, matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
			winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
			apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
			sdiscount, adiscount, discount, playerdiscount,
			livehomescore, liveawayscore, betteam, creator, refno,
			winlostdate, betfrom, checktime, oddsspread, oddstype,
			currency, actualrate, virtualrate,
			srecommend, mrecommend, recommend, custid, Username,
			ip, bettype, transdesc
		)
		SELECT
			transid, matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
			winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
			apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
			sdiscount, adiscount, discount, playerdiscount,
			livehomescore, liveawayscore, betteam, creator, refno,
			@tmpwinlostdate, betfrom, checktime, oddsspread, oddstype,
			currency, actualrate, virtualrate,
			srecommend, mrecommend, recommend, custid, Username,
			ip, bettype, transdesc
		FROM dbo.bettrans bt WITH(NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @transid t WHERE bt.transid = t.transid)

		DELETE dbo.sum_winloss WITH(ROWLOCK, UPDLOCK)
		WHERE winlostdate = @tmpWinlostdate
			AND custid IN (@custid, @recommend, @mrecommend, @srecommend)
			AND sporttype = @sporttype

		INSERT INTO dbo.sum_winloss
		(
			winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
			turnover, winlost, awinlost, mwinlost, swinlost,
			playercomm, comm, acomm, scomm, betcount, grosscomm,
			sporttype, bettype, netTurnover, TunroverNoDraw
		)
		-- member
		SELECT
			@tmpWinlostdate, 1, @custid, @recommend, @mrecommend, @srecommend, @username,
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			160, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(comm/(1-apositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE custid = @custid AND winlostdate = @tmpWinlostdate AND bettype = 1600
		) AS Member
		UNION ALL
		-- agent
		SELECT
			@tmpWinlostdate, 2, @recommend, @recommend, @mrecommend, @srecommend, '',
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			160, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(acomm/(1-apositiontaking - mpositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE recommend = @recommend AND winlostdate = @tmpWinlostdate AND bettype = 1600
		) AS Agent
		UNION ALL
		-- master
		SELECT
			@tmpWinlostdate, 3, @mrecommend, 0, @mrecommend, @srecommend, '',
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			160, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(scomm/(1-tpositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE mrecommend = @mrecommend AND winlostdate = @tmpWinlostdate AND bettype = 1600
		) AS [Master]
		UNION ALL
		-- super
		SELECT
			@tmpWinlostdate, 4, @srecommend, 0, 0, @srecommend, '',
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			160, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(scomm/(1-tpositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE srecommend = @srecommend AND winlostdate = @tmpWinlostdate AND bettype = 1600
		) AS Super

		-- rptStatement
		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement
				@winlostdate = @winlostdate,
				@statementDate = @tmpwinlostdate,
				@custid = @custid,
				@recommend = @recommend,
				@mrecommend = @mrecommend,
				@srecommend = @srecommend,
				@BalanceUpDay = @BUDate

		-- delete match, bettrans
		DELETE bt WITH(ROWLOCK, UPDLOCK)
		FROM dbo.bettrans bt
		WHERE EXISTS (SELECT 1 FROM @transid t WHERE bt.transid = t.transid)

		DELETE dbo.match WITH(ROWLOCK, UPDLOCK) WHERE matchid = @matchid

		DELETE dbo.BetLucky3Result WITH (ROWLOCK, UPDLOCK) WHERE MatchId = @matchid

		DELETE dbo.bingoBall WITH (ROWLOCK, UPDLOCK) WHERE Matchid = @matchid

		IF @range = 3 -- range bettrans_bk
		BEGIN
			-- Insert data into sum_winloss_old from sum_winloss
			EXEC DBAGE.bodb_Summary.dbo.DBA_CopyData_SumWL_SumWLOld
				@winlostdate = @tmpwinlostdate,
				@srecommend = @srecommend,
				@sporttype = @sporttype

			-- Insert data into match_bk and bettrans_bk
			EXEC DBARC.bodb_Archive.dbo.DBA_CopyData_14_bk
				@winlostdate = @tmpwinlostdate,
				@srecommend = @srecommend,
				@sporttype = @sporttype,
				@bettype = @bettype

			-- Statement
			EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement_Old
				@winlostdate = @tmpwinlostdate,
				@custid = @custid,
				@recommend = @recommend,
				@mrecommend = @mrecommend,
				@srecommend = @srecommend

			-- Delete data match14 and bettrans14, sum_winloss
			DELETE bt WITH(ROWLOCK, UPDLOCK)
			FROM dbo.bettrans14 bt
			WHERE EXISTS (SELECT 1 FROM @transid t WHERE bt.transid = t.transid)

			DELETE dbo.BetLucky3Result14 WITH (ROWLOCK, UPDLOCK) WHERE MatchId = @matchid

			DELETE dbo.bingoBall14 WITH (ROWLOCK, UPDLOCK) WHERE Matchid = @matchid

			DELETE dbo.match14 WITH(ROWLOCK, UPDLOCK) WHERE matchid = @matchid

			DELETE dbo.sum_winloss WITH(ROWLOCK, UPDLOCK)
			WHERE srecommend = @srecommend AND winlostdate = @tmpwinlostdate AND sporttype = @sporttype
		END
	END
END