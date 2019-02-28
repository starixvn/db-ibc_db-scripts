USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_Happy5_CreateData]
	@CustId				INT,
	@stake				MONEY = 100,
	@Bettype			INT = 8101,
	@Betteam			VARCHAR(20) = 'b',
	@WinlostDate		SMALLDATETIME = NULL,
	@LeagueId			INT = 1,
	@MatchId			INT = 1,
	@MatchStatus		VARCHAR(10) = 'Completed',
	@MatchResult		VARCHAR(20) = '1,2,3,4,5',
	@spositiontaking	MONEY = 0.4,
	@mpositiontaking	MONEY = 0.3,
	@apositiontaking	MONEY = 0.2,
	@sdiscount			MONEY = 0.004,
	@adiscount			MONEY = 0.003,
	@discount			MONEY = 0.002,
	@playerdiscount		MONEY = 0.001
AS

/*
	Created: Percy

	Param's Explanation:
		@LeagueId:
			 0: create new league
			 1: using exists league
			>1: using input league
		@MatchId:
			 0: create new match
			 1: using exists match
			>1: using input match
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @tpositiontaking MONEY
	SELECT  @tpositiontaking = @apositiontaking + @mpositiontaking + @spositiontaking

	IF @tpositiontaking > 1
	BEGIN
		SELECT 'Invalid PT'
		RETURN
	END

	-- Get custinfo
	DECLARE @username VARCHAR(50), @recommend INT, @mrecommend INT, @srecommend INT, @currency INT, @actualrate FLOAT, @CurrencyName VARCHAR(10)

	SELECT
		@username = c.username,
		@recommend = c.recommend,
		@mrecommend = c.mrecommend,
		@srecommend = c.srecommend,
		@currency = c.currency
	FROM CustDB.dbo.custInfo c WITH (NOLOCK)
	WHERE c.custid = @CustId AND c.roleid = 1

	IF @@ROWCOUNT = 0
	BEGIN
		SELECT 'Invalid member'
		RETURN
	END

	SELECT @actualrate = actualrate, @CurrencyName = currency FROM dbo.exchange WITH (NOLOCK) WHERE exchangeid = @currency

	DECLARE @SportType INT = 164

	IF @MatchId <= 1 AND @MatchStatus NOT IN ('running', 'Completed')
	BEGIN
		SELECT 'Invalid @MatchStatus'
		RETURN
	END

	DECLARE @transdate SMALLDATETIME
	SELECT  @WinlostDate = ISNULL(@WinlostDate, CONVERT(DATE, GETDATE()))
	SELECT  @transdate = DATEADD(SECOND, DATEDIFF(SECOND, CONVERT(DATE, GETDATE()), GETDATE()), @WinlostDate)

	DECLARE @MBDate SMALLDATETIME, @BUDate SMALLDATETIME
	SELECT  @MBDate = MAX(eventdate) FROM dbo.match14 WITH (NOLOCK)
	SELECT  TOP 1 @BUDate = winlostdate FROM dbo.bettrans WITH (NOLOCK) WHERE bettype = 20000 AND custid = 3 AND matchId = 0

	IF @MBDate IS NULL OR @BUDate IS NULL
	BEGIN
		SELECT 'Please check data, MBBU is invalid'
		RETURN
	END

	IF @MatchId <= 1 AND @MatchStatus = 'running' AND @WinlostDate <= @MBDate
	BEGIN
		SELECT '@MatchStatus and @WinlostDate not match'
		RETURN
	END

	DECLARE @tblResult TABLE (seq TINYINT, Number INT)
	DECLARE @NoOfBall INT

	IF @MatchId > 1
	BEGIN
		INSERT INTO @tblResult (seq, Number)
		SELECT seq, Number
		FROM dbo.bingoBall WITH (NOLOCK)
		WHERE matchId = @matchId

		IF @@ROWCOUNT <> 5
		BEGIN
			DELETE @tblResult

			INSERT INTO @tblResult (seq, Number)
			SELECT seq, Number
			FROM dbo.bingoBall14 WITH (NOLOCK)
			WHERE matchId = @matchId

			IF @@ROWCOUNT <> 5
			BEGIN
				DELETE @tblResult

				INSERT INTO @tblResult (seq, Number)
				SELECT seq, Number
				FROM DBARC.bodb_Archive.dbo.bingoBall_bk WITH (NOLOCK)
				WHERE matchId = @matchId

				IF @@ROWCOUNT <> 5
					DELETE @tblResult
			END
		END

		IF NOT EXISTS (SELECT 1 FROM @tblResult)
		BEGIN
			INSERT INTO @tblResult (seq, Number)
			SELECT rank, val FROM dbo.strSplit(@MatchResult, ',')

			SELECT @NoOfBall = @@ROWCOUNT
		END
	END

	IF @NoOfBall <> 5
	BEGIN
		SELECT 'Invalid @MatchResult'
		RETURN
	END

	IF @MatchId = 0 AND EXISTS (SELECT 1 FROM @tblResult WHERE Number NOT BETWEEN 1 AND 20)
	BEGIN
		SELECT 'Invalid @MatchResult'
		RETURN
	END

	IF @MatchId = 0 AND EXISTS (SELECT 1 FROM @tblResult GROUP BY Number HAVING COUNT(1) > 1)
	BEGIN
		SELECT 'Invalid @MatchResult'
		RETURN
	END

	----
	/* Odds type: select * from RefResource with(nolock) where RefId = 'OddsTypeFullName'
		1 Decimal Odds
		2 Hong Kong Odds
		3 Indonesian Odds
		4 Malay Odds
		5 American Odds
	*/

	DECLARE @tblBetChoice TABLE (bettype INT, betteam VARCHAR(10), odds MONEY, oddstype TINYINT)
	INSERT INTO @tblBetChoice (bettype, betteam, odds, oddstype)
	SELECT 8101, 'b', 0.93, 4 UNION ALL
	SELECT 8101, 's', 0.93, 4 UNION ALL
	SELECT 8102, 'o', 0.93, 4 UNION ALL
	SELECT 8102, 'e', 0.93, 4 UNION ALL
	SELECT 8103, 'sp', 18.49, 1 UNION ALL
	SELECT 8103, 'su', 2, 1 UNION ALL
	SELECT 8103, 'au', 2, 1 UNION ALL
	SELECT 8103, 'wi', 18.49, 1 UNION ALL
	SELECT 8104, 'mo', 0.93, 4 UNION ALL
	SELECT 8104, 'me', 0.93, 4 UNION ALL
	SELECT 8105, 'bo', 3.51, 1 UNION ALL
	SELECT 8105, 'be', 3.75, 1 UNION ALL
	SELECT 8105, 'so', 3.75, 1 UNION ALL
	SELECT 8105, 'se', 3.51, 1

	DECLARE @odds MONEY, @oddstype TINYINT
	SELECT  @odds = odds, @oddstype = oddstype FROM @tblBetChoice WHERE bettype = @bettype AND betteam = @betteam

	IF @odds IS NULL
	BEGIN
		SELECT 'Invalid @bettype/@betteam'
		RETURN
	END

	IF @leagueId = 0
	BEGIN
		INSERT INTO dbo.league
		(
			leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range,hdp_allowance,
			hdp_gapodds,hdp_gapoddsr,ou_min,ou_max,ou_risk,ou_range,ou_allowance,ou_gapodds,ou_gapoddsr,oe_min,oe_max,oe_risk,oe_range,oe_gapodds,
			cs_min,cs_max,cs_risk,cs_range,cs_gapodds,b1x2_min,b1x2_max,b1x2_risk,b1x2_range,b1x2_gapodds,tg_min,tg_max,tg_risk,tg_range,tg_gapodds,
			ht_min,ht_max,ht_risk,ht_range,ht_allowance,ht_gapodds,ht_gapoddsr,ht1x2_min,ht1x2_max,ht1x2_risk,ht1x2_range,ht1x2_gapodds,leaguenamec_uni,
			leaguenamej,sporttype,createdate,leaguenamecn,oe_gapoddsr,DisplayMode,isTest,leaguenameth,ProgramID,TrackCondition,IsActive,leaguenameko,
			TrackConditionCh,TrackConditionCs,leaguenameES,CountryCode,leaguenameVN,GameSession,SessionTime,OverTime,leaguenameEL,OverTimeSession,
			IsCountDownTimer,Category,IsMainMarket,leaguecode,outright,leaguenameSC2,DisplayCat,IsAutoPayout,AutoSetting,[Group],ShowInAllMarket,
			PutInMainCat,leaguenameMMR,leaguenameHI
		)
		SELECT TOP 1
			'Happy 5' AS leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range,hdp_allowance,
			hdp_gapodds,hdp_gapoddsr,ou_min,ou_max,ou_risk,ou_range,ou_allowance,ou_gapodds,ou_gapoddsr,oe_min,oe_max,oe_risk,oe_range,oe_gapodds,
			cs_min,cs_max,cs_risk,cs_range,cs_gapodds,b1x2_min,b1x2_max,b1x2_risk,b1x2_range,b1x2_gapodds,tg_min,tg_max,tg_risk,tg_range,tg_gapodds,
			ht_min,ht_max,ht_risk,ht_range,ht_allowance,ht_gapodds,ht_gapoddsr,ht1x2_min,ht1x2_max,ht1x2_risk,ht1x2_range,ht1x2_gapodds,leaguenamec_uni,
			leaguenamej,@SportType AS sporttype,createdate,leaguenamecn,oe_gapoddsr,DisplayMode,isTest,leaguenameth,ProgramID,TrackCondition,IsActive,leaguenameko,
			TrackConditionCh,TrackConditionCs,leaguenameES,CountryCode,leaguenameVN,GameSession,SessionTime,OverTime,leaguenameEL,OverTimeSession,
			IsCountDownTimer,Category,IsMainMarket,leaguecode,outright,leaguenameSC2,DisplayCat,IsAutoPayout,AutoSetting,[Group],ShowInAllMarket,
			PutInMainCat,leaguenameMMR,leaguenameHI
		FROM dbo.league WITH (NOLOCK)
		WHERE SportType = 1

		SELECT @leagueId = SCOPE_IDENTITY()

		INSERT INTO dbo.match
		(
			leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,matchcode,
			kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,DisplayMode,
			LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
			GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus
		)
		SELECT TOP 1
			@leagueId,homeid,awayid,@WinlostDate,@MatchStatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,matchcode,
			@transdate,@transdate,@transdate,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,@sporttype,homeid2,awayid2,DisplayMode,
			LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
			@transdate,HasLive,@transdate,@transdate,IsAutoPayout,AutoSetting,SettlementStatus
		FROM dbo.match WITH (NOLOCK)
		WHERE SportType = 1 AND eventstatus = 'running'

		SELECT @matchId = SCOPE_IDENTITY()

		UPDATE dbo.match WITH (ROWLOCK, UPDLOCK)
		SET matchcode = 'Happy5_' + CONVERT(VARCHAR(20), @matchId)
		WHERE matchId = @matchId
	END
	ELSE IF @leagueId = 1
	BEGIN
		IF @matchId > 1
		BEGIN
			SELECT @leagueId = l.leagueId, @MatchStatus = m.eventstatus, @WinlostDate = m.eventdate
			FROM dbo.league l WITH (NOLOCK)
				INNER JOIN dbo.match m WITH (NOLOCK) ON l.leagueId = m.leagueId
			WHERE m.matchId = @matchId AND m.SportType = @SportType AND l.SportType = @SportType
			
			IF @@ROWCOUNT = 0
			BEGIN
				SELECT @leagueId = l.leagueId, @MatchStatus = m.eventstatus, @WinlostDate = m.eventdate
				FROM dbo.league l WITH (NOLOCK)
					INNER JOIN dbo.match14 m WITH (NOLOCK) ON l.leagueId = m.leagueId
				WHERE m.matchId = @matchId AND m.SportType = @SportType AND l.SportType = @SportType

				IF @@ROWCOUNT = 0
				BEGIN
					SELECT @leagueId = l.leagueId, @MatchStatus = m.eventstatus, @WinlostDate = m.eventdate
					FROM dbo.league l WITH (NOLOCK)
						INNER JOIN DBARC.bodb_Archive.dbo.match_bk m WITH (NOLOCK) ON l.leagueId = m.leagueId
					WHERE m.matchId = @matchId AND m.SportType = @SportType AND l.SportType = @SportType
			
					IF @@ROWCOUNT = 0
					BEGIN
						SELECT 'Invalid @matchId'
						RETURN
					END
				END
			END
		END
		ELSE IF @matchId = 1
		BEGIN
			IF @winlostdate > @MBDate
				SELECT TOP 1 @leagueId = l.leagueId, @matchId = m.matchId
				FROM dbo.league l WITH (NOLOCK)
					INNER JOIN dbo.match m WITH (NOLOCK) ON l.leagueId = m.leagueId
				WHERE m.SportType = @SportType AND l.SportType = @SportType AND m.eventdate = @WinlostDate AND eventstatus = @MatchStatus
			ELSE IF @winlostdate >= @BUDate
				SELECT TOP 1 @leagueId = l.leagueId, @matchId = m.matchId
				FROM dbo.league l WITH (NOLOCK)
					INNER JOIN dbo.match14 m WITH (NOLOCK) ON l.leagueId = m.leagueId
				WHERE m.SportType = @SportType AND l.SportType = @SportType AND m.eventdate = @WinlostDate AND eventstatus = @MatchStatus
			ELSE
				SELECT TOP 1 @leagueId = l.leagueId, @matchId = m.matchId
				FROM dbo.league l WITH (NOLOCK)
					INNER JOIN DBARC.bodb_Archive.dbo.match_bk m WITH (NOLOCK) ON l.leagueId = m.leagueId
				WHERE m.SportType = @SportType AND l.SportType = @SportType AND m.eventdate = @WinlostDate AND eventstatus = @MatchStatus

			IF @@ROWCOUNT = 0
			BEGIN
				SELECT TOP 1 @leagueId = l.leagueId FROM dbo.league l WITH (NOLOCK) WHERE l.SportType = @SportType

				IF @@ROWCOUNT = 0
				BEGIN
					INSERT INTO dbo.league
					(
						leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range,hdp_allowance,
						hdp_gapodds,hdp_gapoddsr,ou_min,ou_max,ou_risk,ou_range,ou_allowance,ou_gapodds,ou_gapoddsr,oe_min,oe_max,oe_risk,oe_range,oe_gapodds,
						cs_min,cs_max,cs_risk,cs_range,cs_gapodds,b1x2_min,b1x2_max,b1x2_risk,b1x2_range,b1x2_gapodds,tg_min,tg_max,tg_risk,tg_range,tg_gapodds,
						ht_min,ht_max,ht_risk,ht_range,ht_allowance,ht_gapodds,ht_gapoddsr,ht1x2_min,ht1x2_max,ht1x2_risk,ht1x2_range,ht1x2_gapodds,leaguenamec_uni,
						leaguenamej,sporttype,createdate,leaguenamecn,oe_gapoddsr,DisplayMode,isTest,leaguenameth,ProgramID,TrackCondition,IsActive,leaguenameko,
						TrackConditionCh,TrackConditionCs,leaguenameES,CountryCode,leaguenameVN,GameSession,SessionTime,OverTime,leaguenameEL,OverTimeSession,
						IsCountDownTimer,Category,IsMainMarket,leaguecode,outright,leaguenameSC2,DisplayCat,IsAutoPayout,AutoSetting,[Group],ShowInAllMarket,
						PutInMainCat,leaguenameMMR,leaguenameHI
					)
					SELECT TOP 1
						'Happy 5' AS leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range,hdp_allowance,
						hdp_gapodds,hdp_gapoddsr,ou_min,ou_max,ou_risk,ou_range,ou_allowance,ou_gapodds,ou_gapoddsr,oe_min,oe_max,oe_risk,oe_range,oe_gapodds,
						cs_min,cs_max,cs_risk,cs_range,cs_gapodds,b1x2_min,b1x2_max,b1x2_risk,b1x2_range,b1x2_gapodds,tg_min,tg_max,tg_risk,tg_range,tg_gapodds,
						ht_min,ht_max,ht_risk,ht_range,ht_allowance,ht_gapodds,ht_gapoddsr,ht1x2_min,ht1x2_max,ht1x2_risk,ht1x2_range,ht1x2_gapodds,leaguenamec_uni,
						leaguenamej,@SportType AS sporttype,createdate,leaguenamecn,oe_gapoddsr,DisplayMode,isTest,leaguenameth,ProgramID,TrackCondition,IsActive,leaguenameko,
						TrackConditionCh,TrackConditionCs,leaguenameES,CountryCode,leaguenameVN,GameSession,SessionTime,OverTime,leaguenameEL,OverTimeSession,
						IsCountDownTimer,Category,IsMainMarket,leaguecode,outright,leaguenameSC2,DisplayCat,IsAutoPayout,AutoSetting,[Group],ShowInAllMarket,
						PutInMainCat,leaguenameMMR,leaguenameHI
					FROM dbo.league WITH (NOLOCK)
					WHERE SportType = 1

					SELECT @leagueId = SCOPE_IDENTITY()
				END

				INSERT INTO dbo.match
				(
					leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,matchcode,
					kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,DisplayMode,
					LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
					GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus
				)
				SELECT TOP 1
					@leagueId,homeid,awayid,@WinlostDate,@MatchStatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,matchcode,
					@transdate,@transdate,@transdate,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,@sporttype,homeid2,awayid2,DisplayMode,
					LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
					@transdate,HasLive,@transdate,@transdate,IsAutoPayout,AutoSetting,SettlementStatus
				FROM dbo.match WITH (NOLOCK)
				WHERE SportType = 1 AND eventstatus = 'running'

				SELECT @matchId = SCOPE_IDENTITY()

				UPDATE dbo.match WITH (ROWLOCK, UPDLOCK)
				SET matchcode = 'Happy5_' + CONVERT(VARCHAR(20), @matchId)
				WHERE matchId = @matchId
			END
		END
		ELSE IF @matchid = 0
		BEGIN
			SELECT TOP 1 @leagueId = l.leagueId FROM dbo.league l WITH (NOLOCK) WHERE l.SportType = @SportType

			IF @@ROWCOUNT = 0
			BEGIN
				INSERT INTO dbo.league
				(
					leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range,hdp_allowance,
					hdp_gapodds,hdp_gapoddsr,ou_min,ou_max,ou_risk,ou_range,ou_allowance,ou_gapodds,ou_gapoddsr,oe_min,oe_max,oe_risk,oe_range,oe_gapodds,
					cs_min,cs_max,cs_risk,cs_range,cs_gapodds,b1x2_min,b1x2_max,b1x2_risk,b1x2_range,b1x2_gapodds,tg_min,tg_max,tg_risk,tg_range,tg_gapodds,
					ht_min,ht_max,ht_risk,ht_range,ht_allowance,ht_gapodds,ht_gapoddsr,ht1x2_min,ht1x2_max,ht1x2_risk,ht1x2_range,ht1x2_gapodds,leaguenamec_uni,
					leaguenamej,sporttype,createdate,leaguenamecn,oe_gapoddsr,DisplayMode,isTest,leaguenameth,ProgramID,TrackCondition,IsActive,leaguenameko,
					TrackConditionCh,TrackConditionCs,leaguenameES,CountryCode,leaguenameVN,GameSession,SessionTime,OverTime,leaguenameEL,OverTimeSession,
					IsCountDownTimer,Category,IsMainMarket,leaguecode,outright,leaguenameSC2,DisplayCat,IsAutoPayout,AutoSetting,[Group],ShowInAllMarket,
					PutInMainCat,leaguenameMMR,leaguenameHI
				)
				SELECT TOP 1
					'Happy 5' AS leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range,hdp_allowance,
					hdp_gapodds,hdp_gapoddsr,ou_min,ou_max,ou_risk,ou_range,ou_allowance,ou_gapodds,ou_gapoddsr,oe_min,oe_max,oe_risk,oe_range,oe_gapodds,
					cs_min,cs_max,cs_risk,cs_range,cs_gapodds,b1x2_min,b1x2_max,b1x2_risk,b1x2_range,b1x2_gapodds,tg_min,tg_max,tg_risk,tg_range,tg_gapodds,
					ht_min,ht_max,ht_risk,ht_range,ht_allowance,ht_gapodds,ht_gapoddsr,ht1x2_min,ht1x2_max,ht1x2_risk,ht1x2_range,ht1x2_gapodds,leaguenamec_uni,
					leaguenamej,@SportType AS sporttype,createdate,leaguenamecn,oe_gapoddsr,DisplayMode,isTest,leaguenameth,ProgramID,TrackCondition,IsActive,leaguenameko,
					TrackConditionCh,TrackConditionCs,leaguenameES,CountryCode,leaguenameVN,GameSession,SessionTime,OverTime,leaguenameEL,OverTimeSession,
					IsCountDownTimer,Category,IsMainMarket,leaguecode,outright,leaguenameSC2,DisplayCat,IsAutoPayout,AutoSetting,[Group],ShowInAllMarket,
					PutInMainCat,leaguenameMMR,leaguenameHI
				FROM dbo.league WITH (NOLOCK)
				WHERE SportType = 1

				SELECT @leagueId = SCOPE_IDENTITY()
			END

			INSERT INTO dbo.match
			(
				leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,matchcode,
				kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,DisplayMode,
				LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
				GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus
			)
			SELECT TOP 1
				@leagueId,homeid,awayid,@WinlostDate,@MatchStatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,matchcode,
				@transdate,@transdate,@transdate,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,@sporttype,homeid2,awayid2,DisplayMode,
				LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
				@transdate,HasLive,@transdate,@transdate,IsAutoPayout,AutoSetting,SettlementStatus
			FROM dbo.match WITH (NOLOCK)
			WHERE SportType = 1 AND eventstatus = 'running'

			SELECT @matchId = SCOPE_IDENTITY()

			UPDATE dbo.match WITH (ROWLOCK, UPDLOCK)
			SET matchcode = 'Happy5_' + CONVERT(VARCHAR(20), @matchId)
			WHERE matchId = @matchId
		END
	END
	ELSE IF @leagueId > 1
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM dbo.league WITH (NOLOCK) WHERE leagueId = @LeagueId AND SportType = @SportType)
		BEGIN
			SELECT 'Invalid @leagueId'
			RETURN
		END

		IF @matchId > 1
		BEGIN
			IF @WinlostDate > @MBDate
				SELECT @MatchStatus = eventStatus FROM bodb02.dbo.match WITH (NOLOCK) WHERE matchId = @matchId AND leagueId = @leagueId AND SportType = @SportType
			ELSE IF @WinlostDate >= @BUDate
			IF NOT EXISTS (SELECT 1 FROM dbo.match WITH (NOLOCK) WHERE matchId = @matchId AND leagueId = @leagueId AND SportType = @SportType)
			BEGIN
				SELECT 'Invalid @matchId'
				RETURN
			END
		END

		IF @matchId = 1
		BEGIN
			SELECT TOP 1 @matchId = matchId FROM dbo.match WITH (NOLOCK) WHERE leagueId = @leagueId AND SportType = @SportType

			IF @@ROWCOUNT = 0
				SELECT @matchId = 0
		END

		IF @matchId = 0
		BEGIN
			INSERT INTO dbo.match
			(
				leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,matchcode,
				kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,DisplayMode,
				LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
				GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus
			)
			SELECT TOP 1
				@leagueId,homeid,awayid,@WinlostDate,@MatchStatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,matchcode,
				@transdate,@transdate,@transdate,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,@sporttype,homeid2,awayid2,DisplayMode,
				LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
				@transdate,HasLive,@transdate,@transdate,IsAutoPayout,AutoSetting,SettlementStatus
			FROM dbo.match WITH (NOLOCK)
			WHERE SportType = 1 AND eventstatus = 'running'

			SELECT @matchId = SCOPE_IDENTITY()

			UPDATE dbo.match WITH (ROWLOCK, UPDLOCK)
			SET matchcode = 'Happy5_' + CONVERT(VARCHAR(20), @matchId)
			WHERE matchId = @matchId
		END
	END

	IF @MatchStatus = 'Completed'
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM @tblResult)
		BEGIN
			IF @winlostdate > @MBDate
				INSERT INTO @tblResult (seq, Number)
				SELECT seq, Number
				FROM dbo.bingoBall WITH (NOLOCK)
				WHERE matchId = @matchId
			ELSE IF @winlostdate >= @BUDate
				INSERT INTO @tblResult (seq, Number)
				SELECT seq, Number
				FROM dbo.bingoBall14 WITH (NOLOCK)
				WHERE matchId = @matchId
			ELSE
				INSERT INTO @tblResult (seq, Number)
				SELECT seq, Number
				FROM DBARC.bodb_Archive.dbo.bingoBall_bk WITH (NOLOCK)
				WHERE matchId = @matchId

			IF @@ROWCOUNT <> 5
			BEGIN
				DELETE @tblResult

				INSERT INTO @tblResult (seq, Number)
				SELECT rank, val FROM dbo.strSplit(@MatchResult, ',')

				IF @@ROWCOUNT <> 5
				BEGIN
					SELECT 'Match is not have data in bingoBall. Please input @MatchResult'
					RETURN
				END
			END
		END
	END

	-- bingoBall
	IF @Winlostdate > @MBDate
	BEGIN
		MERGE dbo.bingoBall AS t
		USING @tblResult AS s ON t.matchId = @matchId AND t.seq = s.seq
		WHEN MATCHED THEN UPDATE
			SET t.Number		= s.Number,
				t.UpdateTime	= GETDATE()
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(matchid, seq, number, updatetime) VALUES (@matchid, seq, number, GETDATE())
		WHEN NOT MATCHED BY SOURCE AND t.matchid = @matchid THEN DELETE;
	END
	ELSE IF @Winlostdate >= @BUDate
	BEGIN
		MERGE dbo.bingoBall14 AS t
		USING @tblResult AS s ON t.matchId = @matchId AND t.seq = s.seq
		WHEN MATCHED THEN UPDATE
			SET t.Number		= s.Number,
				t.UpdateTime	= GETDATE()
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(matchid, seq, number, updatetime) VALUES (@matchid, seq, number, GETDATE())
		WHEN NOT MATCHED BY SOURCE AND t.matchid = @matchid THEN DELETE;
	END
	ELSE
	BEGIN
		DELETE DBARC.bodb_Archive.dbo.bingoBall_bk WITH (ROWLOCK, UPDLOCK) WHERE matchid = @matchid
		
		INSERT INTO DBARC.bodb_Archive.dbo.bingoBall_bk (matchid, seq, number, updatetime)
		SELECT @matchid, seq, number, GETDATE() FROM @tblResult
	END
	
	-- bettrans
	DECLARE @transid BIGINT
	INSERT INTO dbo.bettrans
	(
		custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,
		mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,creator,
		refno,winlostdate,betfrom,actualrate,matchid,recommend,mrecommend,ruben,betid,bettype,betdaqid,actual_stake,
		currency,ip,transdesc,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,
		oddstype,statusID,balance,transid2
	)
	SELECT
		@custid,@transdate,1 AS oddsid,0,0,@odds,@stake,'running' AS status,0 AS winlost,0 AS awinlost,0 AS mwinlost,0 AS playercomm,0 AS comm,0 AS acomm,@apositiontaking,
		@mpositiontaking,@tpositiontaking,@playerdiscount,@discount,@adiscount,0 AS livehomescore,0 AS liveawayscore,0 AS liveindicator,@betteam,8 AS creator,
		100000000000 AS refno,@winlostdate,'d' AS betfrom,@actualrate,@matchid,@recommend,@mrecommend,0,1 AS betid,@bettype,1 AS betdaqid,@stake AS actual_stake,
		@currency,'10.21.10.01' AS ip,'' AS transdesc,@sdiscount,0 AS scomm,@spositiontaking,0 AS swinlost,@srecommend,@Username,@CurrencyName,@actualrate AS virtualrate,
		@oddstype,0 AS statusID,100 AS balance,0 AS transid2

	SELECT @transid = SCOPE_IDENTITY()

	-- Settled
	DECLARE @sumBall INT, @sumOddBall INT, @sumEvenBall INT, @countOddBall INT, @countEvenBall INT
	DECLARE @status VARCHAR(20), @statusId TINYINT

	IF @MatchStatus = 'Completed'
	BEGIN
		SELECT	@sumBall = SUM(Number),
				@sumOddBall = SUM(CASE WHEN Number%2 <> 0 THEN Number ELSE 0 END),
				@sumEvenBall = SUM(CASE WHEN Number%2 = 0 THEN Number ELSE 0 END),
				@countOddBall = COUNT(CASE WHEN Number%2 <> 0 THEN Number ELSE 0 END),
				@countEvenBall = COUNT(CASE WHEN Number%2 = 0 THEN Number ELSE 0 END)
		FROM @tblResult

		-- Won condition
		IF (@bettype = 8101 AND (
					(@betteam = 'b' AND @sumBall >= 53)
				OR	(@betteam = 's' AND @sumBall < 53)))
		OR (@bettype = 8102 AND (
					(@betteam = 'o' AND @sumBall%2 <> 0)
				OR	(@betteam = 'e' AND @sumBall%2 = 0)))
		OR (@bettype = 8103 AND (
					(@betteam = 'sp' AND @sumBall BETWEEN 15 AND 33)
				OR	(@betteam = 'su' AND @sumBall BETWEEN 34 AND 52)
				OR	(@betteam = 'au' AND @sumBall BETWEEN 53 AND 71)
				OR	(@betteam = 'wi' AND @sumBall BETWEEN 72 AND 90)))
		OR (@bettype = 8104 AND (
					(@betteam = 'mo' AND @countOddBall > @countEvenBall)
				OR	(@betteam = 'me' AND @countOddBall < @countEvenBall)))
		OR (@bettype = 8105 AND (
					(@betteam = 'bo' AND @sumBall >= 53 AND @sumBall%2 <> 0)
				OR	(@betteam = 'be' AND @sumBall >= 53 AND @sumBall%2 = 0)
				OR	(@betteam = 'so' AND @sumBall < 53 AND @sumBall%2 <> 0)
				OR	(@betteam = 'se' AND @sumBall < 53 AND @sumBall%2 = 0)))
		BEGIN
			UPDATE dbo.bettrans WITH (ROWLOCK, UPDLOCK)
			SET status = 'WON', statusID = 112, ruben = 1,
				winlost = @stake*(1 + CASE WHEN @oddstype = 1 THEN 1 ELSE 0 END+@odds),
				awinlost = -@stake*(1 + CASE WHEN @oddstype = 1 THEN 1 ELSE 0 END+@odds)*@apositiontaking,
				mwinlost = -@stake*(1 + CASE WHEN @oddstype = 1 THEN 1 ELSE 0 END+@odds)*@mpositiontaking,
				swinlost = -@stake*(1 + CASE WHEN @oddstype = 1 THEN 1 ELSE 0 END+@odds)*@spositiontaking,
				playercomm = @stake*@playerdiscount,
				comm = @stake*@discount*(1-@apositiontaking),
				acomm = @stake*@adiscount*(1-@apositiontaking-@mpositiontaking),
				scomm = @stake*@sdiscount*(1-@tpositiontaking)
			WHERE transid = @transid
		END
		ELSE
			UPDATE dbo.bettrans WITH (ROWLOCK, UPDLOCK)
			SET status = 'LOSE',
				statusID = 113,
				ruben = 1
			WHERE transid = @transid
	END

	-- MBBU
	IF @WinlostDate BETWEEN @BUDate AND @MBDate
	BEGIN
		-- match
		IF NOT EXISTS (SELECT 1 FROM dbo.match14 WITH (NOLOCK) WHERE matchId = @matchId)
		BEGIN
			INSERT INTO dbo.match14
			(
				matchid,leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,
				matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,DisplayMode,
				LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,GoalRecord,settletime,globalshowtime,ParentID,IsAutoPayout,AutoSetting
			)
			SELECT
				matchid,leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,
				matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,DisplayMode,
				LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,GoalRecord,settletime,globalshowtime,ParentID,IsAutoPayout,AutoSetting
			FROM dbo.match WITH (NOLOCK)
			WHERE matchId = @matchId

			DELETE dbo.match WITH (ROWLOCK, UPDLOCK) WHERE matchId = @matchId
		END

		-- bingoBall
		IF NOT EXISTS (SELECT 1 FROM dbo.bingoBall14 WITH (NOLOCK) WHERE matchId = @matchId)
		BEGIN
			INSERT INTO dbo.bingoBall14 (Matchid,Seq,Number,UpdateTime)
			SELECT Matchid,Seq,Number,UpdateTime FROM dbo.bingoBall WITH (NOLOCK) WHERE matchId = @matchId

			DELETE dbo.bingoBall WITH (ROWLOCK, UPDLOCK) WHERE matchId = @matchId
		END

		-- sum_winloss
		;WITH tmp_sum_winloss AS
		(
			SELECT
				b.custid,b.recommend,b.mrecommend,b.srecommend,
				SUM(b.stake) AS turnover, COUNT(b.transid) AS betcount,
				SUM(b.winlost-b.actual_stake) AS winlost, SUM(b.awinlost) AS awinlost, SUM(b.mwinlost) AS mwinlost, SUM(b.swinlost) AS swinlost,
				SUM(b.stake) AS turnoverNoDraw,
				SUM(b.oddsspread) AS oddsspread,
				SUM(b.scomm) AS scomm, SUM(b.acomm) AS acomm, SUM(b.comm) AS comm, SUM(b.playercomm) AS playercomm,
				SUM(CASE tpositiontaking WHEN 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommSuper,
				SUM(CASE tpositiontaking WHEN 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommMaster,
				SUM(CASE WHEN apositiontaking+mpositiontaking = 1 THEN 0 ELSE acomm/(1-apositiontaking-mpositiontaking) END) AS GrossCommAgent,
				SUM(CASE WHEN apositiontaking = 1 THEN 0 ELSE ISNULL(comm/(1-apositiontaking),0) END) AS GrossCommMember
			FROM dbo.bettrans b WITH (NOLOCK)
			WHERE b.transid = @transid
			GROUP BY b.custid,b.recommend,b.mrecommend,b.srecommend
		)
		MERGE dbo.sum_winloss AS s
		USING (
			SELECT custid, roleId, recommend, mrecommend, srecommend, @winlostdate AS winlostdate, @sporttype AS sporttype,
				turnover, betcount, winlost, awinlost, mwinlost, swinlost, turnoverNoDraw,
				oddsspread, scomm, acomm, comm, playercomm, GrossComm
			FROM (
				SELECT custid, 1 AS roleId, recommend, mrecommend, srecommend,
					turnover, betcount, winlost, awinlost, mwinlost, swinlost, turnoverNoDraw,
					oddsspread, scomm, acomm, comm, playercomm, GrossCommMember AS GrossComm
				FROM tmp_sum_winloss
				UNION ALL
				SELECT recommend, 2 AS roleId, @recommend, @mrecommend, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(turnoverNoDraw),
					SUM(oddsspread), SUM(scomm), SUM(acomm), SUM(comm), SUM(playercomm), SUM(GrossCommAgent)
				FROM tmp_sum_winloss
				GROUP BY recommend
				UNION ALL
				SELECT mrecommend, 3 AS roleId, 0, @mrecommend, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(turnoverNoDraw),
					SUM(oddsspread), SUM(scomm), SUM(acomm), SUM(comm), SUM(playercomm), SUM(GrossCommMaster)
				FROM tmp_sum_winloss
				GROUP BY mrecommend
				UNION ALL
				SELECT srecommend, 4 AS roleId, 0, 0, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(turnoverNoDraw),
					SUM(oddsspread), SUM(scomm), SUM(acomm), SUM(comm), SUM(playercomm), SUM(GrossCommSuper)
				FROM tmp_sum_winloss
				GROUP BY srecommend
			) AS A
		) AS src
			ON s.custid = src.custid AND s.winlostdate = src.winlostdate AND s.sporttype = src.sporttype
		WHEN MATCHED THEN
			UPDATE SET
			s.turnover = ISNULL(s.turnover, 0) + ISNULL(src.turnover, 0),
			s.BetCount = ISNULL(s.BetCount, 0) + ISNULL(src.betcount, 0),
			s.winlost = ISNULL(s.winlost, 0) + ISNULL(src.winlost, 0),
			s.awinlost = ISNULL(s.awinlost, 0) + ISNULL(src.awinlost, 0),
			s.mwinlost = ISNULL(s.mwinlost, 0) + ISNULL(src.mwinlost, 0),
			s.swinlost = ISNULL(s.swinlost, 0) + ISNULL(src.swinlost, 0),
			s.playercomm = ISNULL(s.playercomm, 0) + ISNULL(src.playercomm, 0),
			s.comm = ISNULL(s.comm, 0) + ISNULL(src.comm, 0),
			s.acomm = ISNULL(s.acomm, 0) + ISNULL(src.acomm, 0),
			s.scomm = ISNULL(s.scomm, 0) + ISNULL(src.scomm, 0),
			s.TunroverNoDraw = ISNULL(s.TunroverNoDraw, 0) + ISNULL(src.turnoverNoDraw, 0),
			s.grosscomm = ISNULL(s.grosscomm, 0) + ISNULL(src.grosscomm, 0)
		WHEN NOT MATCHED THEN
			INSERT
			(
				winlostdate,username,custid,roleid,recommend,mrecommend,srecommend,turnover,
				winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
				BetCount,grosscomm,sporttype,bettype,netTurnover,TunroverNoDraw
			)
			VALUES
			(
				src.winlostdate, '',src.custId,src.roleId,src.recommend,src.mrecommend,src.srecommend,src.turnover,
				src.winlost,src.awinlost,src.mwinlost,src.swinlost,src.playercomm,src.comm,src.acomm,src.scomm,
				src.betcount,src.GrossComm,src.sporttype,0,0,src.turnoverNoDraw
			);

		-- rptStatement
		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement
			@winlostdate = @winlostdate,
			@custid = @custid,
			@recommend = @recommend,
			@mrecommend = @mrecommend,
			@srecommend = @srecommend,
			@BalanceUpDay = @BUDate,
			@statementdate = @winlostdate

		-- bettrans
		INSERT INTO dbo.bettrans14
		(
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,mpositiontaking,tpositiontaking,
			playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,
			oddsspread,actualrate,matchid,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,sdiscount,
			scomm,spositiontaking,swinlost,srecommend,virtualrate,Username,CurrencyName,oddstype,statusID,currency2,balance,SecAcceptFlag,transid2,ExtraInfo,
			WalletType,BonusID,RefCode,recommdate
		)
		SELECT
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,mpositiontaking,tpositiontaking,
			playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,
			oddsspread,actualrate,matchid,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,sdiscount,
			scomm,spositiontaking,swinlost,srecommend,virtualrate,Username,CurrencyName,oddstype,statusID,currency2,balance,SecAcceptFlag,transid2,ExtraInfo,
			WalletType,BonusID,RefCode,recommdate
		FROM dbo.bettrans WITH (NOLOCK)
		WHERE transid = @transid

		DELETE dbo.bettrans WITH (ROWLOCK, UPDLOCK) WHERE transid = @transid
	END
	ELSE IF @WinlostDate < @BUDate
	BEGIN
		-- match
		IF NOT EXISTS (SELECT 1 FROM DBARC.bodb_Archive.dbo.match_bk WITH (NOLOCK) WHERE matchId = @matchId)
		BEGIN
			INSERT INTO DBARC.bodb_Archive.dbo.match_bk
			(
				matchid,leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,
				matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,DisplayMode,
				LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,GoalRecord,globalshowtime,ParentID
			)
			SELECT
				matchid,leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,creator,
				matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,DisplayMode,
				LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,GoalRecord,globalshowtime,ParentID
			FROM dbo.match WITH (NOLOCK)
			WHERE matchId = @matchId

			DELETE dbo.match WITH (ROWLOCK, UPDLOCK) WHERE matchId = @matchId
		END

		-- bingoBall
		IF NOT EXISTS (SELECT 1 FROM DBARC.bodb_Archive.dbo.bingoBall_bk WITH (NOLOCK) WHERE matchId = @matchId)
		BEGIN
			INSERT INTO DBARC.bodb_Archive.dbo.bingoBall_bk (Matchid,Seq,Number,UpdateTime)
			SELECT Matchid,Seq,Number,UpdateTime FROM dbo.bingoBall WITH (NOLOCK) WHERE matchId = @matchId

			DELETE dbo.bingoBall WITH (ROWLOCK, UPDLOCK) WHERE matchId = @matchId
		END

		-- rptStatement
		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement_Old
			@winlostdate = @winlostdate,
			@custid = @custid,
			@recommend = @recommend,
			@mrecommend = @mrecommend,
			@srecommend = @srecommend

		DECLARE @transids VARCHAR(MAX)
		SELECT  @transids = CONVERT(VARCHAR(20), @transid)
		
		-- sum_winloss_old
		EXEC DBAGE.bodb_Summary.dbo.DBA_sum_winloss_old_Ins
			@transids		= @transids,
			@recommend		= @recommend,
			@mrecommend		= @mrecommend,
			@srecommend		= @srecommend,
			@winlostdate	= @winlostdate,
			@sporttype		= @sporttype

		-- bettrans
		INSERT INTO DBARC.bodb_Archive.dbo.bettrans_bk
		(
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,mpositiontaking,tpositiontaking,
			playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,
			oddsspread,actualrate,matchid,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,sdiscount,
			scomm,spositiontaking,swinlost,srecommend,virtualrate,oddstype,statusID,currency2,balance,SecAcceptFlag,transid2,ExtraInfo,
			WalletType,BonusID,RefCode
		)
		SELECT
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,mpositiontaking,tpositiontaking,
			playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,
			oddsspread,actualrate,matchid,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,sdiscount,
			scomm,spositiontaking,swinlost,srecommend,virtualrate,oddstype,statusID,currency2,balance,SecAcceptFlag,transid2,ExtraInfo,
			WalletType,BonusID,RefCode
		FROM dbo.bettrans WITH (NOLOCK)
		WHERE transid = @transid

		DELETE dbo.bettrans WITH (ROWLOCK, UPDLOCK) WHERE transid = @transid
	END

	SELECT @transid as transid, @winlostdate as winlostdate, @bettype as bettype, @betteam as betteam, @matchid as matchid
END
GO