USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_PHAIO3_CreateData]
	@matchid		INT = NULL,
	@isCreateMatch	BIT = 0,
	@winlostdate	SMALLDATETIME = NULL,

	@username		NVARCHAR(50) = NULL,
	@custid			INT = NULL,
	
	@bettype		INT = 461,
	@stake			MONEY = 100,
	@status			VARCHAR(30) = 'running',
	@numberOfTicket	INT = 1
AS

/*
	Created by Percy
	Date: 2017-09-19
	DB: DBTXN.bodb02
	Task: Creating testing data of PHAIO Phase 3

	Revisions:
		- 20170919@Percy: Create new

	Param's Explanation:
		@isCreateMatch: 0: get existing match if has, 1: create new match
		
		@username, @custid of member
		
		@bettype: 401 --> 404, 461 --> 464
		@status: 'WON', 'LOSE', 'DRAW', 'Refund', ...
*/

BEGIN
	SET NOCOUNT ON

	IF @numberOfTicket IS NULL
		SELECT @numberOfTicket = 1

	IF @numberOfTicket > 100
	BEGIN
		SELECT 'Number of ticket should be less than 100'

		RETURN
	END

	IF @bettype IS NULL
		SELECT @bettype = 401

	IF @bettype NOT IN (401,402,403,404,461,462,463,464)
	BEGIN
		SELECT 'bettype must be in (401,402,403,404,461,462,463,464)'
		
		RETURN
	END

	DECLARE @srecommend INT, @mrecommend INT, @recommend INT, @currency INT, @actualrate FLOAT
	DECLARE @MBDate SMALLDATETIME, @BUDate SMALLDATETIME

	SELECT @MBDate = MAX(eventdate) FROM dbo.match14 WITH (NOLOCK)
	SELECT @BUDate = winlostdate FROM dbo.bettrans WITH (NOLOCK) WHERE bettype = 20000 AND custid = 3 AND matchid = 0

	IF @BUDate IS NULL
	BEGIN
		SELECT TOP 1 @BUDate = winlostdate FROM dbo.bettrans WITH (NOLOCK) WHERE bettype = 20000
	END

	IF @custid IS NOT NULL
	BEGIN
		SELECT
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
		SELECT
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

	DECLARE @tmpWinlostdate SMALLDATETIME, @sporttype SMALLINT, @leagueId INT

	IF @matchid IS NOT NULL
	BEGIN
		SELECT @winlostdate = eventdate, @sporttype = sporttype FROM dbo.match WITH (NOLOCK) WHERE matchid = @matchid

		IF ISNULL(@sporttype, 1) <> 1
		BEGIN
			SELECT 'match is invalid, must support soccer'
			
			RETURN
		END

		IF @winlostdate IS NULL
			SELECT @winlostdate = eventdate, @sporttype = sporttype FROM dbo.match14 WITH (NOLOCK) WHERE matchid = @matchid

		IF ISNULL(@sporttype, 1) <> 1
		BEGIN
			SELECT 'match is invalid, must support soccer'
			
			RETURN
		END

		IF @winlostdate IS NULL
			SELECT @winlostdate = eventdate, @sporttype = sporttype FROM DBARC.bodb_Archive.dbo.match_bk WITH (NOLOCK) WHERE matchid = @matchid

		IF ISNULL(@sporttype, 1) <> 1
		BEGIN
			SELECT 'match is invalid, must support soccer'
			
			RETURN
		END
	END

	IF @sporttype IS NULL
	BEGIN
		IF @isCreateMatch = 0
		BEGIN
			SELECT TOP 1 @winlostdate = eventdate, @matchid = matchid, @sporttype = sporttype FROM dbo.match WITH (NOLOCK) WHERE sporttype = 1
		END

		IF @@ROWCOUNT = 0 OR @isCreateMatch = 1
		BEGIN
			SELECT @winlostdate = ISNULL(@winlostdate, CONVERT(DATE, GETDATE()))

			SELECT @tmpWinlostdate = @winlostdate
			
			IF @winlostdate <= @MBDate
				SELECT @winlostdate = CONVERT(DATE, GETDATE())
			
			SELECT TOP 1 @leagueId = leagueid FROM dbo.league WITH (NOLOCK) WHERE sporttype = 1

			IF @leagueId IS NULL
			BEGIN
				INSERT INTO dbo.League (leaguename, creator, sporttype, createdate, DisplayMode, isTest, isActive)
				VALUES ('', 8, 1, GETDATE(), 0, 1, 1)

				SELECT @leagueId = SCOPE_IDENTITY()

				UPDATE dbo.League WITH (ROWLOCK, UPDLOCK)
				SET leaguename = 'Soccer - PHAIO 3 - ' + CONVERT(VARCHAR(20), @leagueId)
				WHERE leagueid = @leagueId
			END

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
				@winlostdate, CASE WHEN ISNULL(@status, 'running') = 'running' THEN 'running' ELSE 'Completed' END,
				0, 0, 0, 0,
				8, '123456', @winlostdate, NULL, @winlostdate,
				0, 0, 0, 0,
				1, 0, @winlostdate, @winlostdate, NULL, 1127222095
			FROM dbo.match WITH(NOLOCK)

			SELECT @matchid = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			SELECT @tmpWinlostdate = @winlostdate

			IF @winlostdate <= @MBDate
				SELECT @winlostdate = CONVERT(DATE, GETDATE())
		END
	END
	ELSE
	BEGIN
		SELECT @tmpWinlostdate = @winlostdate

		IF @winlostdate <= @MBDate
			SELECT @winlostdate = CONVERT(DATE, GETDATE())
	END

	DECLARE @tmpBettype INT
	SELECT  @tmpBettype = @bettype
	
	IF @bettype BETWEEN 461 AND 464
		SELECT @tmpBettype = @tmpBettype - 60

	DECLARE @transid TABLE (transid BIGINT)

	INSERT INTO [dbo].[bettrans]
    (
		[custid],[transdate],[oddsid],[hdp1],[hdp2],[odds],[stake],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm],[apositiontaking]
		,[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],[livehomescore],[liveawayscore],[liveindicator],[betteam],[creator],[refno]
		,[comstatus],[winlostdate],[betfrom],[betcheck],[checktime],[oddsspread],[actualrate],[matchid],[recommend],[mrecommend],[ruben],[betid],[statuswinlost]
		,[modds],[bettype],[betdaqid],[actual_stake],[currency],[ip],[transdesc],[sdiscount],[scomm],[spositiontaking],[swinlost],[srecommend],[Username]
		,[CurrencyName],[virtualrate],[oddstype],[statusID],[currency2],[balance],[SecAcceptFlag],[transid2],[RecommDate],[ExtraInfo],[WalletType],[BonusID],[RefCode]
	)
	OUTPUT INSERTED.transid INTO @transid (transid)
	SELECT TOP (@numberOfTicket)
		@custid,@winlostdate,[oddsid],[hdp1],[hdp2],[odds],@stake,[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm],[apositiontaking]
		,[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],[livehomescore],[liveawayscore],[liveindicator],[betteam],[creator],[refno]
		,[comstatus],@winlostdate,[betfrom],[betcheck],[checktime],[oddsspread],@actualrate,@matchid,@recommend,@mrecommend,[ruben],[betid],[statuswinlost]
		,[modds],@bettype,[betdaqid],@stake,@currency,[ip],[transdesc],[sdiscount],[scomm],[spositiontaking],[swinlost],@srecommend,@Username
		,[CurrencyName],@actualrate,[oddstype],[statusID],[currency2],[balance],[SecAcceptFlag],[transid2],[RecommDate],[ExtraInfo],[WalletType],[BonusID],[RefCode]
	FROM dbo.bettrans_local WITH (NOLOCK)
	WHERE bettype = @tmpBettype
		AND status = ISNULL(@status, 'running')

	IF ISNULL(@status, 'running') <> 'running'
	BEGIN
		UPDATE b WITH (ROWLOCK, UPDLOCK)
		SET
			winlost = CASE @status WHEN 'WON' THEN b.stake*b.odds WHEN 'LOSE' THEN 0 ELSE b.stake END,
			swinlost = CASE @status WHEN 'WON' THEN -b.spositiontaking*b.stake*b.odds WHEN 'LOSE' THEN b.spositiontaking*b.stake*b.odds ELSE 0 END,
			mwinlost = CASE @status WHEN 'WON' THEN -b.mpositiontaking*b.stake*b.odds WHEN 'LOSE' THEN b.mpositiontaking*b.stake*b.odds ELSE 0 END,
			awinlost = CASE @status WHEN 'WON' THEN -b.apositiontaking*b.stake*b.odds WHEN 'LOSE' THEN b.apositiontaking*b.stake*b.odds ELSE 0 END
		FROM dbo.bettrans b
			INNER JOIN @transid t ON b.transid = t.transid

		IF @bettype BETWEEN 641 AND 644
		BEGIN
			UPDATE b WITH (ROWLOCK, UPDLOCK)
			SET b.odds = b.odds + 1
			FROM dbo.bettrans b
				INNER JOIN @transid t ON b.transid = t.transid
		END
	END
	ELSE
	BEGIN
		SELECT @custid AS custid, @username AS username, @matchid AS matchid, @tmpWinlostdate AS winlostdate
		
		RETURN
	END 

	IF @tmpWinlostdate <= @MBDate -- range 14
	BEGIN
		INSERT INTO [dbo].[bettrans14]
		(
			[transid],[custid],[transdate],[oddsid],[hdp1],[hdp2],[odds],[stake],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm],[apositiontaking]
			,[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],[livehomescore],[liveawayscore],[liveindicator],[betteam],[creator],[refno]
			,[comstatus],[winlostdate],[betfrom],[betcheck],[checktime],[oddsspread],[actualrate],[matchid],[recommend],[mrecommend],[ruben],[betid],[statuswinlost]
			,[modds],[bettype],[betdaqid],[actual_stake],[currency],[ip],[transdesc],[sdiscount],[scomm],[spositiontaking],[swinlost],[srecommend],[Username]
			,[CurrencyName],[virtualrate],[oddstype],[statusID],[currency2],[balance],[SecAcceptFlag],[transid2],[ExtraInfo],[WalletType],[BonusID],[RefCode]
		)
		SELECT
			[transid],[custid],@tmpWinlostdate,[oddsid],[hdp1],[hdp2],[odds],[stake],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm],[apositiontaking]
			,[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],[livehomescore],[liveawayscore],[liveindicator],[betteam],[creator],[refno]
			,[comstatus],@tmpWinlostdate,[betfrom],[betcheck],[checktime],[oddsspread],[actualrate],[matchid],[recommend],[mrecommend],[ruben],[betid],[statuswinlost]
			,[modds],[bettype],[betdaqid],[actual_stake],[currency],[ip],[transdesc],[sdiscount],[scomm],[spositiontaking],[swinlost],[srecommend],[Username]
			,[CurrencyName],[virtualrate],[oddstype],[statusID],[currency2],[balance],[SecAcceptFlag],[transid2],[ExtraInfo],[WalletType],[BonusID],[RefCode]
		FROM dbo.bettrans b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @transid t WHERE b.transid = t.transid)

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
			@tmpWinlostdate, [eventstatus],
			[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
			[creator], [matchcode], @tmpWinlostdate, @tmpWinlostdate, @tmpWinlostdate,
			[hthomescore], [htawayscore], [ruben], [multiple],
			[sporttype], [IsNeutral], @tmpWinlostdate, @tmpWinlostdate, [ParentID]
		FROM dbo.match WITH (NOLOCK)
		WHERE matchid = @matchid

		-- sum_winloss
		DELETE dbo.sum_winloss WITH (ROWLOCK, UPDLOCK)
		WHERE winlostdate = @tmpWinlostdate
			AND custid IN (@srecommend, @mrecommend, @recommend, @custid)

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
			0, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(comm/(1-apositiontaking)) grosscomm
			FROM dbo.bettrans14 b WITH(NOLOCK)
			WHERE custid = @custid AND winlostdate = @tmpWinlostdate AND bettype IN (401,402,403,404,461,462,463,464)
		) AS Member
		UNION ALL
		-- agent
		SELECT
			@tmpWinlostdate, 2, @recommend, @recommend, @mrecommend, @srecommend, '',
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			0, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(acomm/(1-apositiontaking - mpositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE recommend = @recommend AND winlostdate = @tmpWinlostdate AND bettype IN (401,402,403,404,461,462,463,464)
		) AS Agent
		UNION ALL
		-- master
		SELECT
			@tmpWinlostdate, 3, @mrecommend, 0, @mrecommend, @srecommend, '',
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			0, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(scomm/(1-tpositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE mrecommend = @mrecommend AND winlostdate = @tmpWinlostdate AND bettype IN (401,402,403,404,461,462,463,464)
		) AS [Master]
		UNION ALL
		-- super
		SELECT
			@tmpWinlostdate, 4, @srecommend, 0, 0, @srecommend, '',
			SUM(turnover), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
			SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(betcount), SUM(grosscomm),
			0, 0, 0, SUM(turnover)
		FROM
		(
			SELECT
				SUM(ABS(stake)) turnover, SUM(winlost-actual_stake) winlost, SUM(awinlost) awinlost, SUM(mwinlost) mwinlost, SUM(swinlost) swinlost,
				SUM(playercomm) playercomm, SUM(comm) comm, SUM(acomm) acomm, SUM(scomm) scomm, COUNT(1) BetCount, SUM(scomm/(1-tpositiontaking)) grosscomm
			FROM dbo.bettrans14 WITH(NOLOCK)
			WHERE srecommend = @srecommend AND winlostdate = @tmpWinlostdate AND bettype IN (401,402,403,404,461,462,463,464)
		) AS Super

		-- rptStatement
		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement
				@winlostdate = @tmpWinlostdate,
				@custid = @custid,
				@recommend = @recommend,
				@mrecommend = @mrecommend,
				@srecommend = @srecommend,
				@BalanceUpDay = @BUDate

		-- delete match, bettrans
		DELETE bt WITH(ROWLOCK, UPDLOCK)
		FROM dbo.bettrans bt
		WHERE EXISTS (SELECT 1 FROM @transid t WHERE bt.transid = t.transid)

		DELETE dbo.match WITH(ROWLOCK, UPDLOCK)
		WHERE matchid = @matchid

		IF @tmpWinlostdate < @BUDate -- range bk
		BEGIN
			-- Insert data into sum_winloss_old from sum_winloss
			EXEC DBAGE.bodb_Summary.dbo.DBA_CopyData_SumWL_SumWLOld
				@winlostdate = @tmpWinlostdate,
				@srecommend = @srecommend,
				@sporttype = @sporttype

			-- Insert data into match_bk and bettrans_bk
			EXEC DBARC.bodb_Archive.dbo.DBA_CopyData_14_bk
				@winlostdate = @tmpWinlostdate,
				@srecommend = @srecommend,
				@sporttype = @sporttype,
				@bettype = @bettype

			-- Statement
			EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement_Old
				@winlostdate = @tmpWinlostdate,
				@custid = @custid,
				@recommend = @recommend,
				@mrecommend = @mrecommend,
				@srecommend = @srecommend

			-- Delete data match14 and bettrans14, sum_winloss
			DELETE bt WITH(ROWLOCK, UPDLOCK)
			FROM dbo.bettrans14 bt
			WHERE EXISTS (SELECT 1 FROM @transid t WHERE bt.transid = t.transid)

			DELETE dbo.match14 WITH(ROWLOCK, UPDLOCK)
			WHERE matchid = @matchid

			DELETE dbo.sum_winloss WITH(ROWLOCK, UPDLOCK)
			WHERE srecommend = @srecommend AND winlostdate = @tmpWinlostdate AND sporttype = @sporttype
		END
	END

	SELECT @custid AS custid, @username AS username, @matchid AS matchid, @tmpWinlostdate AS winlostdate
END