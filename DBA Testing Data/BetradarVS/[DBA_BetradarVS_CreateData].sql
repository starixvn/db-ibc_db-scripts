USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_BetradarVS_CreateData]
	@winlostdate	SMALLDATETIME = NULL,
	@username		NVARCHAR(50) = NULL,
	@custid			INT = NULL,
	@sporttype		SMALLINT = NULL,
	@bettype		INT = NULL,
	@stake			MONEY = NULL
AS

/*
	Created by Percy
	Date: 2017-06-28
	DB: DBTXN.bodb02
	Task: Creating testing data of Betradar Virtual Sports

	Revisions:
		- 20170628@Percy: Create new

	Param's Explanation:
*/

BEGIN
	SET NOCOUNT ON

	-- create league, match
	DECLARE @leagueId INT, @matchid_running INT, @matchid_completed INT

	SELECT @bettype = ISNULL(@bettype, 2701)
	SELECT @winlostdate = ISNULL(@winlostdate, CONVERT(DATE, GETDATE()))
	SELECT @stake = ISNULL(@stake, 1000)

	DECLARE @datetime DATETIME
	SELECT  @datetime = CONVERT(VARCHAR(10), @winlostdate, 120) + ' ' + CONVERT(VARCHAR(10), GETDATE(), 108)

	------------ member info -------------
	DECLARE @recommend INT, @mrecommend INT, @srecommend INT, @currency INT, @actualrate FLOAT
	IF @custid IS NOT NULL
	BEGIN
		SELECT TOP 1
			@custid = custid,
			@username = username,
			@recommend = recommend,
			@mrecommend = mrecommend,
			@srecommend = srecommend,
			@currency = currency
		FROM CustDB.dbo.custInfo WITH(NOLOCK)
		WHERE roleid = 1 AND custid = @custid
	END
	ELSE IF @username IS NOT NULL
	BEGIN
		SELECT TOP 1
			@custid = custid,
			@username = username,
			@recommend = recommend,
			@mrecommend = mrecommend,
			@srecommend = srecommend,
			@currency = currency
		FROM CustDB.dbo.custInfo WITH(NOLOCK)
		WHERE roleid = 1 AND username = @username
	END
	
	IF @recommend IS NULL
	BEGIN
		SELECT TOP 1
			@custid = custid,
			@username = username,
			@recommend = recommend,
			@mrecommend = mrecommend,
			@srecommend = srecommend,
			@currency = currency
		FROM CustDB.dbo.custInfo WITH(NOLOCK)
		WHERE roleid = 1
	END

	SELECT @actualrate = actualrate FROM dbo.exchange WITH(NOLOCK) WHERE exchangeid = @currency

	DECLARE @betteam NVARCHAR(20), @transdesc VARCHAR(1000)

	IF @bettype IN (2701, 2702)
	BEGIN
		SELECT @betteam = '1' -- 1 X 2
	END
	ELSE IF @bettype IN (2703, 2704)
	BEGIN
		SELECT @betteam = 'O' -- O/U
	END
	ELSE IF @bettype IN (2705, 2706)
	BEGIN
		SELECT @betteam = 'h' -- h/a
	END
	ELSE IF @bettype IN (2707)
	BEGIN
		SELECT @betteam = '0:0' -- Correct Score, 0:0 --> 3:3 and AOS (others)
	END

	IF @sporttype = 190
	BEGIN
		SELECT @transdesc = 'Match Day 23, season 6666'
	END
	ELSE IF @sporttype = 191
	BEGIN
		SELECT @transdesc = 'Round 16-1, Nation Cup 6666'
	END

		-- create league
	IF @sporttype IS NULL
		SELECT TOP 1 @leagueId = leagueId, @sporttype = sporttype
		FROM dbo.League WITH(NOLOCK) WHERE sporttype BETWEEN 190 AND 199
	ELSE
		SELECT TOP 1 @leagueId = leagueId
		FROM dbo.League WITH(NOLOCK) WHERE sporttype = @sporttype

	IF @leagueId IS NULL
	BEGIN
		SELECT @sporttype = ISNULL(@sporttype, 190)
	
		-- Creator is one of sporttypes
		INSERT INTO dbo.League (leaguename, creator, sporttype, createdate, DisplayMode, isTest, isActive)
		VALUES ('Virtual Soccer ' + CONVERT(VARCHAR(30), GETDATE(), 120), @sporttype, @sporttype, @datetime, 0, 1, 1)

		SELECT @leagueId = SCOPE_IDENTITY()
	END

		-- create match
		/*
			- creator is one of sporttypes
			- format of matchcode: [{x1} y1,] {x2} y2 --- xi: 0 --> 17, yi: int > 0
		*/
	/* running match */
	SELECT TOP 1 @matchid_running = matchid
	FROM dbo.match WITH(NOLOCK) WHERE sporttype = @sporttype AND eventdate = @winlostdate AND eventstatus = 'running'

	IF @matchid_running IS NULL
	BEGIN
		INSERT INTO dbo.match
		(
			[leagueid], [homeid], [awayid],
			[eventdate], [eventstatus],
			[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
			[creator], [matchcode], [kickofftime], [closedtime], [showtime],
			[hthomescore], [htawayscore], [ruben], [multiple],
			[sporttype], [IsNeutral], [GlobalShowTime], [changetime], [settletime], [ParentID]
		)
		SELECT TOP 1
			@leagueId, homeid, awayid,
			@winlostdate, 'running',
			0, 0, 0, 0,
			@sporttype, '{2} 23, {3} 6666', @datetime, NULL, @datetime,
			0, 0, 0, 0,
			@sporttype, 0, @datetime, @datetime, NULL, 1127222095
		FROM dbo.match WITH(NOLOCK)

		SELECT @matchid_running = SCOPE_IDENTITY()
	END

	/* completed match */
	SELECT TOP 1 @matchid_completed = matchid
	FROM dbo.match WITH(NOLOCK) WHERE sporttype = @sporttype AND eventdate = @winlostdate AND eventstatus = 'completed'

	IF @matchid_completed IS NULL
	BEGIN
		INSERT INTO dbo.match
		(
			[leagueid], [homeid], [awayid],
			[eventdate], [eventstatus],
			[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
			[creator], [matchcode], [kickofftime], [closedtime], [showtime],
			[hthomescore], [htawayscore], [ruben], [multiple],
			[sporttype], [IsNeutral], [GlobalShowTime], [changetime], [settletime], [ParentID]
		)
		SELECT TOP 1
			@leagueId, homeid, awayid,
			@winlostdate, 'completed',
			0, 0, 2, 0,
			@sporttype, '{3} 23, {4} 6666', @datetime, @datetime, @datetime,
			0, 0, 0, 0,
			@sporttype, 0, @datetime, @datetime, @datetime, 1127222095
		FROM dbo.match WITH(NOLOCK)

		SELECT @matchid_completed = SCOPE_IDENTITY()
	END

	CREATE TABLE #Numbers (ID INT IDENTITY, Number MONEY)
	WHILE 1=1
	BEGIN 
		INSERT INTO #Numbers (Number)
		SELECT CONVERT(MONEY, RAND())

		IF SCOPE_IDENTITY() = 100
			BREAK;
	END

	DECLARE @transid TABLE (transid BIGINT)

	DELETE dbo.bettrans WITH(ROWLOCK, UPDLOCK)
	WHERE custid = @custid AND winlostdate = @winlostdate AND bettype = @bettype

	-- running ticket --
	INSERT INTO dbo.bettrans
	(
		matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
		winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
		apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
		sdiscount, adiscount, discount, playerdiscount,
		livehomescore, liveawayscore, betteam, creator, refno,
		winlostdate, betfrom, checktime, oddsspread, oddstype,
		currency, actualrate, virtualrate,
		srecommend, mrecommend, recommend, custid, Username,
		ip, bettype, transdesc
	)
	OUTPUT INSERTED.transid INTO @transid (transid)
	SELECT @matchid_running, @datetime, 98344397, 0, 0, 0.9, A.stake*n.Number, A.stake*n.Number, 'running', 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,
		0.4, 0.3, 0.15, 0.85,
		0, 0, 0, 0,
		0, 0, @betteam, 8, 100000000000,
		@winlostdate, 'd', @datetime, 0, 1,
		@currency, @actualrate, @actualrate,
		@srecommend, @mrecommend, @recommend, @custid, @username,
		'127.1.1.0', @bettype, @transdesc
	FROM (VALUES (@stake)) AS A (stake)
	CROSS APPLY #Numbers n

	-- settle ticket --
		-- WON --
	INSERT INTO dbo.bettrans
	(
		matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
		winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
		apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
		sdiscount, adiscount, discount, playerdiscount,
		livehomescore, liveawayscore, betteam, creator, refno,
		winlostdate, betfrom, checktime, oddsspread, oddstype,
		currency, actualrate, virtualrate,
		srecommend, mrecommend, recommend, custid, Username,
		ip, bettype, transdesc
	)
	OUTPUT INSERTED.transid INTO @transid (transid)
	SELECT @matchid_running, @datetime, 98344397, 0, 0, 0.9, A.stake*n.Number, A.stake*n.Number, 'WON', 112, 1,
		2*A.stake*n.Number, -0.8*A.stake*n.Number, -0.6*A.stake*n.Number, -0.3*A.stake*n.Number, 0, 0, 0, 0,
		0.4, 0.3, 0.15, 0.85,
		0, 0, 0, 0,
		0, 0, @betteam, 8, 100000000000,
		@winlostdate, 'd', @datetime, 0, 1,
		@currency, @actualrate, @actualrate,
		@srecommend, @mrecommend, @recommend, @custid, @username,
		'127.1.1.0', @bettype, @transdesc
	FROM (VALUES (@stake)) AS A (stake)
	CROSS APPLY #Numbers n

		-- LOSE --
	INSERT INTO dbo.bettrans
	(
		matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
		winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
		apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
		sdiscount, adiscount, discount, playerdiscount,
		livehomescore, liveawayscore, betteam, creator, refno,
		winlostdate, betfrom, checktime, oddsspread, oddstype,
		currency, actualrate, virtualrate,
		srecommend, mrecommend, recommend, custid, Username,
		ip, bettype, transdesc
	)
	OUTPUT INSERTED.transid INTO @transid (transid)
	SELECT @matchid_running, @datetime, 98344397, 0, 0, 0.9, A.stake*n.Number, A.stake*n.Number, 'LOSE', 113, 1,
		0, 0.8*A.stake*n.Number, 0.6*A.stake*n.Number, 0.3*A.stake*n.Number, 0, 0, 0, 0,
		0.4, 0.3, 0.15, 0.85,
		0, 0, 0, 0,
		0, 0, @betteam, 8, 100000000000,
		@winlostdate, 'd', @datetime, 0, 1,
		@currency, @actualrate, @actualrate,
		@srecommend, @mrecommend, @recommend, @custid, @username,
		'127.1.1.0', @bettype, @transdesc
	FROM (VALUES (@stake)) AS A (stake)
	CROSS APPLY #Numbers n

	DECLARE @BalanceUpDay SMALLDATETIME, @MoveBetsDay SMALLDATETIME

	DECLARE @MBBUDate TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
	INSERT INTO @MBBUDate (BalanceUpDay, MoveBetsDay)
	EXEC DBAGE.bodb02.dbo.Age_SelBalanceUpDay

	SELECT TOP 1 @BalanceUpDay = BalanceUpDay, @MoveBetsDay = MoveBetsDay FROM @MBBUDate

	IF @winlostdate > @MoveBetsDay -- range bettrans
	BEGIN
		SELECT @custid AS CustId, @username AS Username, @matchid_running AS running_matchid, @matchid_completed AS completed_match, @winlostdate AS winlostdate
		
		RETURN
	END
	ELSE -- bettrans14, bettrans_bk
	BEGIN
		-- No need move league

		-- Move match
			-- Settle running match
		UPDATE dbo.match WITH (ROWLOCK, UPDLOCK)
		SET [eventstatus] = 'completed', [finalhomescore] = 3
		WHERE [matchid] = @matchid_running

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
			[eventdate], [eventstatus],
			[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
			[creator], [matchcode], [kickofftime], [closedtime], [showtime],
			[hthomescore], [htawayscore], [ruben], [multiple],
			[sporttype], [IsNeutral], [GlobalShowTime], [settletime], [ParentID]
		FROM dbo.match WITH(NOLOCK)
		WHERE matchid IN (@matchid_running, @matchid_completed)

		-- Insert into sum_winloss and move bettrans14
			-- Settle running ticket
		UPDATE TOP (50) bettrans WITH(ROWLOCK, UPDLOCK)
		SET status = 'WON', statusID = 112, ruben = 1, winlost = 2*actual_stake, awinlost = -0.8*actual_stake, mwinlost = -0.6*actual_stake, swinlost = -0.3*actual_stake
		WHERE custid = @custid AND winlostdate = @winlostdate AND bettype = @bettype AND ruben = 0

		UPDATE TOP (50) bettrans WITH(ROWLOCK, UPDLOCK)
		SET status = 'LOSE', statusID = 113, ruben = 1, winlost = 0, awinlost = 0.8*actual_stake, mwinlost = 0.6*actual_stake, swinlost = 0.3*actual_stake
		WHERE custid = @custid AND winlostdate = @winlostdate AND bettype = @bettype AND ruben = 0

		DELETE dbo.bettrans14 WITH(ROWLOCK, UPDLOCK)
		WHERE custid = @custid AND winlostdate = @winlostdate AND bettype = @bettype

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
			winlostdate, betfrom, checktime, oddsspread, oddstype,
			currency, actualrate, virtualrate,
			srecommend, mrecommend, recommend, custid, Username,
			ip, bettype, transdesc
		FROM dbo.bettrans bt WITH(NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @transid t WHERE bt.transid = t.transid)
		--SELECT @@ROWCOUNT

		DELETE dbo.sum_winloss WITH(ROWLOCK, UPDLOCK)
		WHERE winlostdate = @winlostdate
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
			@winlostdate, 1, @custid, @recommend, @mrecommend, @srecommend, @username,
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			190, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(comm/(1-apositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE custid = @custid AND winlostdate = @winlostdate AND bettype BETWEEN 2701 AND 2799
		) AS Member
		UNION ALL
		-- agent
		SELECT
			@winlostdate, 2, @recommend, @recommend, @mrecommend, @srecommend, '',
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			190, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(acomm/(1-apositiontaking - mpositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE recommend = @recommend AND winlostdate = @winlostdate AND bettype BETWEEN 2701 AND 2799
		) AS Agent
		UNION ALL
		-- master
		SELECT
			@winlostdate, 3, @mrecommend, 0, @mrecommend, @srecommend, '',
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			190, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(scomm/(1-tpositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE mrecommend = @mrecommend AND winlostdate = @winlostdate AND bettype BETWEEN 2701 AND 2799
		) AS [Master]
		UNION ALL
		-- super
		SELECT
			@winlostdate, 4, @srecommend, 0, 0, @srecommend, '',
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			190, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(scomm/(1-tpositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE srecommend = @srecommend AND winlostdate = @winlostdate AND bettype BETWEEN 2701 AND 2799
		) AS Super

		-- rptStatement
		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement
				@winlostdate = @winlostdate,
				@custid = @custid,
				@recommend = @recommend,
				@mrecommend = @mrecommend,
				@srecommend = @srecommend,
				@BalanceUpDay = @BalanceUpDay,
				@statementdate = @winlostdate

		-- delete match, bettrans
		DELETE bt WITH(ROWLOCK, UPDLOCK)
		FROM dbo.bettrans bt
		WHERE EXISTS (SELECT 1 FROM @transid t WHERE bt.transid = t.transid)

		DELETE dbo.match WITH(ROWLOCK, UPDLOCK)
		WHERE matchid IN (@matchid_running, @matchid_completed)

		IF @winlostdate < @BalanceUpDay -- range bettrans_bk
		BEGIN
			-- Insert data into sum_winloss_old from sum_winloss
			EXEC DBAGE.bodb_Summary.dbo.DBA_CopyData_SumWL_SumWLOld
				@winlostdate = @winlostdate,
				@srecommend = @srecommend,
				@sporttype = @sporttype

			-- Insert data into match_bk and bettrans_bk
			EXEC DBARC.bodb_Archive.dbo.DBA_CopyData_14_bk
				@winlostdate = @winlostdate,
				@srecommend = @srecommend,
				@sporttype = @sporttype,
				@bettype = @bettype

			-- Statement
			EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement_Old
				@winlostdate = @winlostdate,
				@custid = @custid,
				@recommend = @recommend,
				@mrecommend = @mrecommend,
				@srecommend = @srecommend

			-- Delete data match14 and bettrans14, sum_winloss
			DELETE bt WITH(ROWLOCK, UPDLOCK)
			FROM dbo.bettrans14 bt
			WHERE EXISTS (SELECT 1 FROM @transid t WHERE bt.transid = t.transid)

			DELETE dbo.match14 WITH(ROWLOCK, UPDLOCK)
			WHERE matchid IN (@matchid_running, @matchid_completed)

			DELETE dbo.sum_winloss WITH(ROWLOCK, UPDLOCK)
			WHERE srecommend = @srecommend AND winlostdate = @winlostdate AND sporttype = @sporttype
		END
	END

	DROP TABLE #Numbers
END