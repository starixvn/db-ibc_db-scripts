USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_Bullfighting_CreateData]
	@custid INT = NULL,
	@username VARCHAR(50) = NULL,

	@league3rdId INT = NULL,
	@isCreateLeague3rdId BIT = NULL,
	
	@match3rdId INT = NULL,
	@isCreateMatch3rd BIT = NULL,
	@isLiveMatch BIT = NULL,
	@HomeId INT = NULL,
	@AwayId INT = NULL,

	@winlostdate SMALLDATETIME = NULL,
	@status VARCHAR(50) = NULL,
	@betChoice VARCHAR(1) = NULL,
	@numOfTickets INT = NULL,
	@stake MONEY = NULL,
	@matchNo VARCHAR(50) = '123456'
AS

/*
	Created by Percy
	Date: 2017-10-27
	DB: DB206.bodb02

	Param's Explanation:
		@betChoice: b = Banker, p = Player
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @tmpWinlostdate SMALLDATETIME
	SELECT  @tmpWinlostdate = CONVERT(DATE, GETDATE())

	DECLARE @MoveBetsDay SMALLDATETIME, @BalanceUpDay SMALLDATETIME
	SELECT  @MoveBetsDay = MAX(EventDate) FROM dbo.match14 WITH(NOLOCK)
	SELECT  @BalanceUpDay = winlostdate FROM dbo.bettrans WITH (NOLOCK) WHERE bettype = 20000 AND matchid = 0 AND custid = 3

	IF @isCreateLeague3rdId IS NULL
		SELECT @isCreateLeague3rdId = 0
	
	IF @isCreateMatch3rd IS NULL
		SELECT @isCreateMatch3rd = 0

	IF @status IS NULL
	BEGIN
		SELECT @status = 'running'

		IF @winlostdate <= @MoveBetsDay
			SELECT @status = 'WON'
	END

	IF @status NOT IN ('WON', 'LOSE', 'DRAW', 'running', 'waiting', 'Void', 'Reject', 'Refund')
	BEGIN
		SELECT 'Invalid status'
		RETURN
	END

	IF @status IN ('running', 'waiting') AND @winlostdate IS NOT NULL
	BEGIN
		IF @winlostdate < @MoveBetsDay
		BEGIN
			SELECT 'Running/Waiting status mismatch with winlostdate'
			RETURN
		END
	END

	DECLARE @statusId SMALLINT
	SELECT  @statusId = CASE @status
							WHEN 'running' THEN 0
							WHEN 'waiting' THEN 1
							WHEN 'WON' THEN 112
							WHEN 'LOSE' THEN 113
							WHEN 'DRAW' THEN 111
							WHEN 'Void' THEN 102
							WHEN 'Reject' THEN 101
							WHEN 'Refund' THEN 103
						END
	
	IF @numOfTickets IS NULL
		SELECT @numOfTickets = 1

	IF @numOfTickets > 50
	BEGIN
		SELECT 'Number of tickets should be less than 51'
		RETURN
	END
	ELSE IF @numOfTickets < 1
	BEGIN
		SELECT 'Number of tickets should be greater than 0'
		RETURN
	END
	
	IF @stake IS NULL
		SELECT @stake = 100

	-- translog.gameid3rd = bettrans.betId = match3rd.VendorMatchId
	DECLARE @gameid3rd BIGINT = 456718

	-- translog.ProductID = bettrans.oddsid = match3rd.sporttype
	-- translog.gameId = bettrans.bettype
	DECLARE @sporttype SMALLINT = 207, @bettype INT = 1004

	-- translog.transdesc = bettrans.transdesc
	DECLARE @transdesc VARCHAR(500)

	-- translog.transid3rd = bettrans.betcheck
	DECLARE @betcheck VARCHAR(100) = 'TXN20170901164159001'

	-- translog.custom2 = bettrans.hdp1
	DECLARE @hdp1 VARCHAR(50)
	SELECT  @hdp1 = @matchNo

	-- translog.custom3 = bettrans.betteam
	DECLARE @betteam VARCHAR(50)

	-- translog.siteId = bettrans.betdaqid
	DECLARE @betdaqid BIGINT = 4100200

	-- translog.custom1 = bettrans.oddstype
	DECLARE @oddstype TINYINT = 1

	DECLARE @ip VARCHAR(20) = '10.21.10.xx'

	-- betChoice
	IF @betChoice IS NULL
		SELECT @betChoice = 'b'

	IF @betChoice NOT IN ('p', 'b')
	BEGIN
		SELECT 'Wrong betChoice'
		RETURN
	END

	SELECT  @betteam = @betChoice

	-- custinfo
	BEGIN
		DECLARE @srecommend INT, @mrecommend INT, @recommend INT, @actualrate FLOAT, @currency INT

		IF @custid IS NOT NULL OR @username IS NOT NULL
		BEGIN
			SELECT @srecommend = srecommend, @mrecommend = mrecommend, @recommend = recommend, @currency = currency, @username = username
			FROM CustDB.dbo.custInfo WITH (NOLOCK) WHERE custid = @custid AND roleid = 1

			IF @recommend IS NULL
			BEGIN
				SELECT @srecommend = srecommend, @mrecommend = mrecommend, @recommend = recommend, @currency = currency, @username = username
				FROM CustDB.dbo.Customer WITH (NOLOCK) WHERE username = @username AND roleid = 1  
			END

			IF @recommend IS NULL
			BEGIN
				SELECT 'Invalid custid/username'
				RETURN
			END
		END
		ELSE
		BEGIN
			SELECT TOP 1 @srecommend = srecommend, @mrecommend = mrecommend, @recommend = recommend, @currency = currency, @username = username
			FROM CustDB.dbo.custInfo WITH (NOLOCK) WHERE roleid = 1 AND currency = 20
		END

		SELECT @actualrate = actualrate FROM dbo.exchange WITH (NOLOCK) WHERE exchangeid = @currency
	END

	-- Home, Away
	BEGIN
		IF @HomeId IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.Team3rd WITH (NOLOCK) WHERE Team3rdId = @HomeId AND SportType = @sporttype)
		BEGIN
			SELECT @HomeId = NULL

			SELECT TOP 1 @HomeId = Team3rdId FROM dbo.Team3rd WITH (NOLOCK) WHERE SportType = @sporttype
		END

		IF @HomeId IS NULL
		BEGIN
			INSERT INTO dbo.Team3rd (SportType, CreateTime)
			VALUES (@sporttype, GETDATE())

			SELECT @HomeId = SCOPE_IDENTITY()

			UPDATE dbo.Team3rd WITH (ROWLOCK)
			SET TeamName = 'Banker-' + CONVERT(VARCHAR(10), Team3rdId),
				VendorTeamId = @HomeId,
				VendorTeamName = 'Banker-' + CONVERT(VARCHAR(10), Team3rdId)
			WHERE Team3rdId = @HomeId
		END

		IF @AwayId IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.Team3rd WITH (NOLOCK) WHERE Team3rdId = @AwayId AND SportType = @sporttype AND Team3rdId <> @HomeId)
		BEGIN
			SELECT @AwayId = NULL

			SELECT TOP 1 @AwayId = Team3rdId FROM dbo.Team3rd WITH (NOLOCK) WHERE SportType = @sporttype AND Team3rdId <> @HomeId
		END

		IF @AwayId IS NULL
		BEGIN
			INSERT INTO dbo.Team3rd (SportType, CreateTime)
			VALUES (@sporttype, GETDATE())

			SELECT @AwayId = SCOPE_IDENTITY()

			UPDATE dbo.Team3rd WITH (ROWLOCK)
			SET TeamName = 'Banker-' + CONVERT(VARCHAR(10), Team3rdId),
				VendorTeamId = @AwayId,
				VendorTeamName = 'Banker-' + CONVERT(VARCHAR(10), Team3rdId)
			WHERE Team3rdId = @AwayId
		END
	END

	DECLARE @matchStatus VARCHAR(50)

	IF @league3rdId IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM dbo.League3rd WITH (NOLOCK) WHERE League3rdId = @league3rdId AND SportType = @sporttype)
		BEGIN
			SELECT 'Invalid league'
			RETURN
		END

		IF @match3rdId IS NOT NULL
		BEGIN
			SELECT @winlostdate = EventDate, @matchStatus = EventStatus
			FROM dbo.Match3rd WITH (NOLOCK)
			WHERE Match3rdId = @match3rdId AND SportType = @sporttype AND League3rdId = @league3rdId AND EventStatus IN ('running', 'completed')

			IF @matchStatus IS NULL
			BEGIN
				SELECT @winlostdate = EventDate, @matchStatus = EventStatus
				FROM dbo.Match3rd14 WITH (NOLOCK)
				WHERE Match3rdId = @match3rdId AND SportType = @sporttype AND League3rdId = @league3rdId AND EventStatus IN ('completed')
			END

			IF @matchStatus IS NULL
			BEGIN
				SELECT @winlostdate = EventDate, @matchStatus = EventStatus
				FROM DBARC.bodb_Archive.dbo.Match3rd_bk WITH (NOLOCK)
				WHERE Match3rdId = @match3rdId AND SportType = @sporttype AND League3rdId = @league3rdId AND EventStatus IN ('completed')
			END

			IF @matchStatus IS NULL
			BEGIN
				SELECT 'Invalid match'
				RETURN
			END

			IF @matchStatus = 'closed'
			BEGIN
				SELECT 'This match is closed'
				RETURN
			END
		END
		ELSE IF @isCreateMatch3rd = 0
		BEGIN
			IF @winlostDate IS NOT NULL
			BEGIN
				IF @winlostDate > @MoveBetsDay
				BEGIN
					SELECT TOP 1 @match3rdId = match3rdId, @winlostdate = EventDate, @matchStatus = EventStatus
					FROM dbo.Match3rd WITH (NOLOCK) WHERE League3rdId = @league3rdId AND SportType = @sporttype AND EventStatus IN ('running', 'completed')
				END
				ELSE IF @winlostDate >= @BalanceUpDay
				BEGIN
					SELECT TOP 1 @match3rdId = match3rdId, @winlostdate = EventDate, @matchStatus = EventStatus
					FROM dbo.Match3rd14 WITH (NOLOCK) WHERE League3rdId = @league3rdId AND SportType = @sporttype AND EventStatus IN ('completed')
				END
				ELSE
				BEGIN
					SELECT TOP 1 @match3rdId = match3rdId, @winlostdate = EventDate, @matchStatus = EventStatus
					FROM DBARC.bodb_Archive.dbo.Match3rd_bk WITH (NOLOCK) WHERE League3rdId = @league3rdId AND SportType = @sporttype AND EventStatus IN ('completed')
				END
			END
			ELSE
			BEGIN
				SELECT TOP 1 @match3rdId = match3rdId, @winlostdate = EventDate, @matchStatus = EventStatus
				FROM dbo.Match3rd WITH (NOLOCK) WHERE League3rdId = @league3rdId AND SportType = @sporttype AND EventStatus IN ('running', 'completed')
			END

			IF @matchStatus IS NOT NULL
			BEGIN
				IF @matchStatus = 'closed'
				BEGIN
					SELECT 'This match is closed'
					RETURN
				END
			END
			ELSE
			BEGIN
				IF @status IN ('WON','LOSE','DRAW')
					SELECT @matchStatus = 'Completed'
				ELSE
					SELECT @matchStatus = 'running'

				INSERT INTO dbo.Match3rd
				(
					League3rdId, HomeId, AwayId, EventDate, SportType, VendorMatchId, MatchNo, HasLive,
					EventStatus, VendorEventStatus, CreateTime, UpdateTime
				)
				VALUES
				(
					@league3rdId, @HomeId, @AwayId, @tmpWinlostdate, @sporttype, @gameid3rd, 8, ISNULL(@isLiveMatch, 0),
					@matchStatus, @matchStatus, GETDATE(), GETDATE()
				)

				SELECT @Match3rdId = SCOPE_IDENTITY()
			END
		END
		ELSE
		BEGIN
			IF @status IN ('WON','LOSE','DRAW')
					SELECT @matchStatus = 'Completed'
				ELSE
					SELECT @matchStatus = 'running'

			INSERT INTO dbo.Match3rd
			(
				League3rdId, HomeId, AwayId, EventDate, SportType, VendorMatchId, MatchNo, HasLive,
				EventStatus, VendorEventStatus, CreateTime, UpdateTime
			)
			VALUES
			(
				@league3rdId, @HomeId, @AwayId, @tmpWinlostdate, @sporttype, @gameid3rd, 8, ISNULL(@isLiveMatch, 0),
				@matchStatus, @matchStatus, GETDATE(), GETDATE()
			)

			SELECT @Match3rdId = SCOPE_IDENTITY()
		END
	END
	ELSE
	BEGIN
		IF @match3rdId IS NOT NULL
		BEGIN
			SELECT @winlostdate = EventDate, @matchStatus = EventStatus, @league3rdId = League3rdId
			FROM dbo.Match3rd WITH (NOLOCK)
			WHERE Match3rdId = @match3rdId AND SportType = @sporttype AND EventStatus IN ('running', 'completed')

			IF @matchStatus IS NULL
			BEGIN
				SELECT @winlostdate = EventDate, @matchStatus = EventStatus, @league3rdId = League3rdId
				FROM dbo.Match3rd14 WITH (NOLOCK)
				WHERE Match3rdId = @match3rdId AND SportType = @sporttype AND EventStatus IN ('completed')
			END

			IF @matchStatus IS NULL
			BEGIN
				SELECT @winlostdate = EventDate, @matchStatus = EventStatus, @league3rdId = League3rdId
				FROM DBARC.bodb_Archive.dbo.Match3rd_bk WITH (NOLOCK)
				WHERE Match3rdId = @match3rdId AND SportType = @sporttype AND EventStatus IN ('completed')
			END

			IF @matchStatus IS NULL
			BEGIN
				SELECT 'Invalid match'
				RETURN
			END

			IF @matchStatus = 'closed'
			BEGIN
				SELECT 'This match is closed'
				RETURN
			END

			IF NOT EXISTS (SELECT TOP 1 league3rdId FROM dbo.League3rd WITH (NOLOCK) WHERE League3rdId = @league3rdId AND SportType = @sporttype)
			BEGIN
				SELECT 'Invalid league of match'
				RETURN
			END
		END
		ELSE
		BEGIN
			IF @isCreateLeague3rdId = 0
			SELECT TOP 1 @league3rdId = league3rdId FROM dbo.League3rd WITH (NOLOCK) WHERE League3rdId = @league3rdId AND SportType = @sporttype

			IF @league3rdId IS NULL
			BEGIN
				INSERT INTO dbo.League3rd (SportType, CreateTime)
				VALUES (@sporttype, GETDATE())

				SELECT @league3rdId = SCOPE_IDENTITY()

				UPDATE dbo.League3rd WITH (ROWLOCK)
				SET LeagueName = 'Bullfighting - League ' + CONVERT(VARCHAR(10), League3rdId),
					VendorLeagueId = League3rdId,
					VendorLeagueName = 'Bullfighting - League ' + CONVERT(VARCHAR(10), League3rdId),
					LeagueCode = 'BLA' + RIGHT(CONVERT(VARCHAR(10), League3rdId), 2)
				WHERE League3rdId = @league3rdId
			END

			IF @status IN ('WON','LOSE','DRAW')
					SELECT @matchStatus = 'Completed'
				ELSE
					SELECT @matchStatus = 'running'

			INSERT INTO dbo.Match3rd
			(
				League3rdId, HomeId, AwayId, EventDate, SportType, VendorMatchId, MatchNo, HasLive,
				EventStatus, VendorEventStatus, CreateTime, UpdateTime
			)
			VALUES
			(
				@league3rdId, @HomeId, @AwayId, @tmpWinlostdate, @sporttype, @gameid3rd, 8, ISNULL(@isLiveMatch, 0),
				@matchStatus, @matchStatus, GETDATE(), GETDATE()
			)

			SELECT @Match3rdId = SCOPE_IDENTITY()
		END
	END

	IF @winlostdate IS NOT NULL
		SELECT @tmpWinlostdate = @winlostdate

	IF EXISTS (SELECT 1 FROM dbo.Match3rd WITH (NOLOCK) WHERE Match3rdId = @match3rdId AND EventDate <> @tmpWinlostdate)
		UPDATE dbo.Match3rd WITH (ROWLOCK)
		SET EventDate = @tmpWinlostdate
		WHERE Match3rdId = @match3rdId

	-- insert ticket into translog
	SELECT @transdesc = 'Banker=' + TeamName FROM dbo.Team3rd WITH (NOLOCK) WHERE Team3rdId = @HomeId
	SELECT @transdesc = @transdesc + ';Player=' + TeamName FROM dbo.Team3rd WITH (NOLOCK) WHERE Team3rdId = @AwayId
	SELECT @transdesc = @transdesc + ';ArenaCode=' + LeagueCode FROM dbo.League3rd WITH (NOLOCK) WHERE League3rdId = @League3rdId

	DECLARE @translog TABLE (translogid BIGINT PRIMARY KEY)
	DECLARE @bettrans TABLE (transid BIGINT PRIMARY KEY)
	DECLARE @translogid BIGINT

	INSERT INTO dbo.translog
	 (
		[custid],[transdate],[odds],[stake],[status],[apositiontaking],[mpositiontaking],[tpositiontaking],[spositiontaking],
		[playerdiscount],[discount],[adiscount],[sdiscount],[creator],[winlostdate],[betfrom],[virtualrate],[actualrate],[actual_stake],
		[currency],[CurrencyName],[recommend],[mrecommend],[srecommend],[ip],[statusID],[balance],[Username],[transdesc],
		[productID],[gameID],[eventID],[vendorID],[Gameid3rd],[Tranid3rd],[liveindicator],[custom1],[custom2],[custom3],[SiteId]
	)
	VALUES
	(
		@custid, GETDATE(), 0.95, @stake, @status, 0.85, 0, 0.85, 0,
		0, 0, 0, 0, 8, @tmpWinlostdate, 'd', @actualrate, @actualrate, @stake,
		@currency, '', @recommend, @mrecommend, @srecommend, @ip, @statusId, @stake*100, @username, @transdesc,
		@sporttype, @bettype, @match3rdId, @gameid3rd, @gameid3rd, @betcheck, 0, @oddstype, @hdp1, @betteam, @betdaqid
	)

	SELECT @translogid = SCOPE_IDENTITY()

	INSERT INTO @translog (translogid)
	VALUES (@translogid)

	IF @numOfTickets > 1
	BEGIN
		;WITH Number AS
		(
			SELECT 1 AS A
			UNION ALL
			SELECT A + 1
			FROM Number
			WHERE A < @numOfTickets - 1
		)
		INSERT INTO dbo.translog
		(
			[custid],[transdate],[odds],[stake],[status],[apositiontaking],[mpositiontaking],[tpositiontaking],[spositiontaking],
			[playerdiscount],[discount],[adiscount],[sdiscount],[creator],[winlostdate],[betfrom],[virtualrate],[actualrate],[actual_stake],
			[currency],[CurrencyName],[recommend],[mrecommend],[srecommend],[ip],[statusID],[balance],[Username],[transdesc],
			[productID],[gameID],[eventID],[vendorID],[Gameid3rd],[Tranid3rd],[liveindicator],[custom1],[custom2],[custom3],[SiteId]
		)
		OUTPUT INSERTED.translogid INTO @translog (translogid)
		SELECT
			[custid],[transdate],[odds],[stake],[status],[apositiontaking],[mpositiontaking],[tpositiontaking],[spositiontaking],
			[playerdiscount],[discount],[adiscount],[sdiscount],[creator],[winlostdate],[betfrom],[virtualrate],[actualrate],[actual_stake],
			[currency],[CurrencyName],[recommend],[mrecommend],[srecommend],[ip],[statusID],[balance],[Username],[transdesc],
			[productID],[gameID],[eventID],[vendorID],[Gameid3rd],[Tranid3rd],[liveindicator],[custom1],[custom2],[custom3],[SiteId]
		FROM dbo.translog t WITH (NOLOCK)
			CROSS APPLY Number n
		WHERE translogid = @translogid
	END

	IF @status NOT IN ('running', 'waiting', 'Reject')
	BEGIN
		INSERT INTO dbo.bettrans
		(
			[custid],[transdate],[oddsid],[hdp1],[odds],[stake],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm],[apositiontaking],
			[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],[livehomescore],[liveawayscore],[liveindicator],[betteam],[creator],[refno],
			[comstatus],[winlostdate],[betfrom],[betcheck],[checktime],[actualrate],[matchid],[recommend],[mrecommend],[ruben],[betid],[statuswinlost],
			[bettype],[betdaqid],[actual_stake],[currency],[ip],[transdesc],[sdiscount],[scomm],[spositiontaking],[swinlost],[srecommend],[Username],[CurrencyName],
			[virtualrate],[statusID],[currency2],[balance],[SecAcceptFlag],[transid2],[RecommDate],[oddstype]
		)
		OUTPUT INSERTED.transid INTO @bettrans (transid)
		SELECT
			[custid],[transdate],100,@hdp1,[odds],[stake],[status],
			CASE WHEN statusID IN (102, 103, 111) THEN [stake] WHEN statusID = 112 THEN odds*[stake] ELSE 0 END,
			CASE WHEN statusID IN (102, 103, 111) THEN [stake] WHEN statusID = 112 THEN odds*[stake] ELSE 0 END * apositiontaking,
			0,0,0,0,[apositiontaking],
			[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],0,0,[liveindicator],@betteam,[creator],translogid,
			'',[winlostdate],[betfrom],@betcheck,transdate,[actualrate],eventID,[recommend],[mrecommend],1,Gameid3rd,'',
			[gameID],@betdaqid,[actual_stake],[currency],[ip],[transdesc],[sdiscount],0,[spositiontaking],0,[srecommend],[Username],[CurrencyName],
			[virtualrate],[statusID],[currency],[balance],0,0,transdate,custom1
		FROM dbo.translog t WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @translog tmp WHERE t.translogid = tmp.translogid)
	END

	DECLARE @turnOver MONEY, @winlost MONEY, @awinlost MONEY

	IF @winlostdate BETWEEN @BalanceUpDay AND @MoveBetsDay
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM dbo.Match3rd14 WITH (NOLOCK) WHERE Match3rdId = @Match3rdId)
		BEGIN
			INSERT INTO dbo.Match3rd14
			(
				Match3rdId, League3rdId, HomeId, AwayId, EventDate, SportType, VendorMatchId, MatchNo, HasLive,
				EventStatus, VendorEventStatus, CreateTime, UpdateTime
			)
			SELECT
				Match3rdId, League3rdId, HomeId, AwayId, EventDate, SportType, VendorMatchId, MatchNo, HasLive,
				'Completed', VendorEventStatus, CreateTime, UpdateTime
			FROM dbo.Match3rd WITH (NOLOCK)
			WHERE Match3rdId = @Match3rdId

			DELETE dbo.Match3rd WITH (ROWLOCK, UPDLOCK)
			WHERE Match3rdId = @Match3rdId
		END

		INSERT INTO dbo.translog14
		(
			[translogid],[custid],[transdate],[odds],[stake],[status],[apositiontaking],[mpositiontaking],[tpositiontaking],[spositiontaking],
			[playerdiscount],[discount],[adiscount],[sdiscount],[creator],[winlostdate],[betfrom],[virtualrate],[actualrate],[actual_stake],
			[currency],[CurrencyName],[recommend],[mrecommend],[srecommend],[ip],[statusID],[balance],[Username],[transdesc],
			[productID],[gameID],[eventID],[vendorID],[Gameid3rd],[Tranid3rd],[liveindicator],[custom1],[custom2],[custom3]
		)
		SELECT
			[translogid],[custid],[transdate],[odds],[stake],[status],[apositiontaking],[mpositiontaking],[tpositiontaking],[spositiontaking],
			[playerdiscount],[discount],[adiscount],[sdiscount],[creator],[winlostdate],[betfrom],[virtualrate],[actualrate],[actual_stake],
			[currency],[CurrencyName],[recommend],[mrecommend],[srecommend],[ip],[statusID],[balance],[Username],[transdesc],
			[productID],[gameID],[eventID],[vendorID],[Gameid3rd],[Tranid3rd],[liveindicator],[custom1],[custom2],[custom3]
		FROM dbo.translog t WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @translog tmp WHERE t.translogid = tmp.translogid)

		DELETE t WITH (ROWLOCK, UPDLOCK)
		FROM dbo.translog t
		WHERE EXISTS (SELECT 1 FROM @translog tmp WHERE t.translogid = tmp.translogid)

		INSERT INTO dbo.bettrans14
		(
			[transid],[custid],[transdate],[oddsid],[hdp1],[odds],[stake],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm],[apositiontaking],
			[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],[livehomescore],[liveawayscore],[liveindicator],[betteam],[creator],[refno],
			[comstatus],[winlostdate],[betfrom],[betcheck],[checktime],[actualrate],[matchid],[recommend],[mrecommend],[ruben],[betid],[statuswinlost],
			[bettype],[betdaqid],[actual_stake],[currency],[ip],[transdesc],[sdiscount],[scomm],[spositiontaking],[swinlost],[srecommend],[Username],[CurrencyName],
			[virtualrate],[statusID],[currency2],[balance],[SecAcceptFlag],[transid2],[oddstype]
		)
		SELECT
			[transid],[custid],[transdate],[oddsid],[hdp1],[odds],[stake],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm],[apositiontaking],
			[mpositiontaking],[tpositiontaking],[playerdiscount],[discount],[adiscount],[livehomescore],[liveawayscore],[liveindicator],[betteam],[creator],[refno],
			[comstatus],[winlostdate],[betfrom],[betcheck],[checktime],[actualrate],[matchid],[recommend],[mrecommend],[ruben],[betid],[statuswinlost],
			[bettype],[betdaqid],[actual_stake],[currency],[ip],[transdesc],[sdiscount],[scomm],[spositiontaking],[swinlost],[srecommend],[Username],[CurrencyName],
			[virtualrate],[statusID],[currency2],[balance],[SecAcceptFlag],[transid2],[oddstype]
		FROM dbo.bettrans b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @bettrans tmp WHERE b.transid = tmp.transid)

		SELECT  @turnOver = SUM(ABS(stake)), @winlost = SUM(winlost-actual_stake), @awinlost = SUM(awinlost)
		FROM dbo.bettrans b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @bettrans tmp WHERE b.transid = tmp.transid)

		DELETE b WITH (ROWLOCK, UPDLOCK)
		FROM dbo.bettrans b
		WHERE EXISTS (SELECT 1 FROM @bettrans tmp WHERE b.transid = tmp.transid)
		
		IF NOT EXISTS (SELECT 1 FROM dbo.sum_winloss WITH (NOLOCK) WHERE srecommend = @srecommend AND sporttype = @sporttype AND winlostdate = @winlostdate)
		BEGIN
			INSERT INTO dbo.sum_winloss
			(
				winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
				turnover, winlost, awinlost, mwinlost, swinlost,
				playercomm, comm, acomm, scomm, betcount, grosscomm,
				sporttype, bettype, netTurnover, TunroverNoDraw
			)
			SELECT
				@winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
				@turnOver, @winlost, @awinlost, 0, 0,
				0, 0, 0, 0, @numOfTickets, 0,
				@sporttype, 0, 0, CASE WHEN @statusID = 111 THEN 0 ELSE @turnOver END
			FROM dbo.custInfo WITH (NOLOCK)
			WHERE custid IN (@custid, @recommend, @mrecommend, @srecommend)
		END
		ELSE
		BEGIN
			UPDATE dbo.sum_winloss WITH (ROWLOCK)
			SET turnover = ISNULL(turnover, 0) + @turnOver,
				winlost = ISNULL(winlost, 0) + @winlost,
				awinlost = ISNULL(awinlost, 0) + @awinlost,
				TunroverNoDraw = ISNULL(TunroverNoDraw, 0) + CASE WHEN @statusID = 111 THEN 0 ELSE @turnOver END
			WHERE sporttype = @sporttype AND winlostdate = @winlostdate
				AND (
					custid = @custid AND roleid = 1
					OR custid = @recommend AND roleid = 2
					OR custid = @mrecommend AND roleid = 3
					OR custid = @srecommend AND roleid = 4
				)
		END
	END
	ELSE IF @winlostdate < @BalanceUpDay
	BEGIN
		DECLARE @transIds VARCHAR(MAX), @translogIds VARCHAR(MAX)
		SELECT  @transIds = (SELECT ',' + CONVERT(VARCHAR(20), transid) FROM @bettrans FOR XML PATH(''))
		SELECT  @translogIds = (SELECT ',' + CONVERT(VARCHAR(20), translogid) FROM @translog FOR XML PATH(''))

		SELECT  @transIds = RIGHT(@transIds, LEN(@transIds) - 1)
		SELECT  @translogIds = RIGHT(@translogIds, LEN(@translogIds) - 1)

		EXEC dbo.DBA_BalanceUp
			@Match3rdId = @Match3rdId,
			@transIds = @transIds,
			@translogIds = @translogIds,
			@sporttype = @sporttype,
			@bettype = @bettype,
			@winlostdate = @winlostdate,
			@numOfTickets = @numOfTickets,
			@srecommend = @srecommend,
			@mrecommend = @mrecommend,
			@recommend = @recommend,
			@custId = @custId,
			@username = @username

		DELETE dbo.Match3rd WITH (ROWLOCK, UPDLOCK)
		WHERE Match3rdId = @Match3rdId
		
		DELETE t WITH (ROWLOCK, UPDLOCK)
		FROM dbo.translog t
		WHERE EXISTS (SELECT 1 FROM @translog tmp WHERE t.translogid = tmp.translogid)

		DELETE b WITH (ROWLOCK, UPDLOCK)
		FROM dbo.bettrans b
		WHERE EXISTS (SELECT 1 FROM @bettrans tmp WHERE b.transid = tmp.transid)
	END
END
GO