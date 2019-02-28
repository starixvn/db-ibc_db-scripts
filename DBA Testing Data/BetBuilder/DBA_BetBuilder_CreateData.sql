USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_BetBuilder_CreateData]
	@CustId				INT,
	@stake				MONEY = 100,
	@Betteam			VARCHAR(20) = 'b',
	@odds				MONEY = 0.95,
	@MarketId			BIGINT = 1,
	@Selections			XML = 
						'
							<Selection Name="Selection Name 01 - Yes" Result="" />
							<Selection Name="Selection Name 01 - Team A Win" Result="" />
						',
	@WinlostDate		SMALLDATETIME = NULL,
	@LeagueId			INT = 1,
	@MatchId			INT = 1,
	@MatchStatus		VARCHAR(10) = 'Completed',
	@Status				VARCHAR(20) = 'running',
	@spositiontaking	MONEY = 0.4,
	@mpositiontaking	MONEY = 0.3,
	@apositiontaking	MONEY = 0.2,
	@sdiscount			MONEY = 0.004,
	@adiscount			MONEY = 0.003,
	@discount			MONEY = 0.002,
	@playerdiscount		MONEY = 0.001
AS

/*
	Create: PERCY

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

	DECLARE @SportType	INT = 1 -- Soccer
			,@Bettype	INT = 38 -- BetBuilder

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

	IF @Status = 'running' AND @MatchStatus = 'Completed'
	BEGIN
		SELECT '@MatchStatus and @Status not match'
		RETURN
	END

	IF @Status NOT IN ('running', 'WON', 'LOSE', 'DRAW')
	BEGIN
		SELECT 'Just support @Status IN running, WON, LOSE, DRAW'
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
			'BetBuilder' AS leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range,hdp_allowance,
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
		SET matchcode = 'BetBuilder_' + CONVERT(VARCHAR(20), @matchId)
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
						'BetBuilder' AS leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range,hdp_allowance,
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
				SET matchcode = 'BetBuilder_' + CONVERT(VARCHAR(20), @matchId)
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
					'BetBuilder' AS leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range,hdp_allowance,
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
			SET matchcode = 'BetBuilder_' + CONVERT(VARCHAR(20), @matchId)
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
			SET matchcode = 'BetBuilder_' + CONVERT(VARCHAR(20), @matchId)
			WHERE matchId = @matchId
		END
	END

	DECLARE @betcheck NVARCHAR(50)

	-- SelectionInfo
	BEGIN
		-- VendorStatus
		DECLARE @vendorId SMALLINT

		SELECT @vendorId = vendorId FROM dbo.VendorStatus WITH (NOLOCK) WHERE matchid = @MatchId

		IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO dbo.VendorStatus (matchid, vendorid, SB_TradeStatusID, VD_TradeStatusID, Link, Opened, FixtureId)
			VALUES (@MatchId, 34, 1, 1, 1, 1, 1)
		END

		DECLARE @SelectionCounts SMALLINT

		DECLARE @tblSelection TABLE (SelectionType INT, SelectionName VARCHAR(200), Result VARCHAR(50), ResultStatusId TINYINT)
		INSERT INTO @tblSelection (SelectionName, Result, ResultStatusId)
		SELECT t.c.value('@Name', 'VARCHAR(200)') AS SelectionName, NULLIF(t.c.value('@Result', 'VARCHAR(50)'), '') AS Result, 0
		FROM @Selections.nodes('Selection') AS t(c)

		SELECT  @SelectionCounts = @@ROWCOUNT

		-- Market
		IF NOT EXISTS (SELECT 1 FROM dbo.SMP_Market WITH (NOLOCK) WHERE VendorId = 34 AND MatchId = @MatchId AND MarketId = @MarketId)
		BEGIN
			INSERT INTO dbo.SMP_Market (VendorId, MatchId, MarketId, Price, TradeStatus, Result, ResultStatusId, SelectionCounts, CreateTime, UpdateTime)
			SELECT 34, @MatchId, @MarketId, 10, 'Open', NULL, 0, @SelectionCounts, GETDATE(), GETDATE()
		END

		UPDATE s
		SET s.SelectionType = ss.SelectionType
		FROM @tblSelection s
			INNER JOIN dbo.SMP_Selection ss WITH (NOLOCK) ON s.SelectionName = ss.SelectionName

		INSERT INTO dbo.SMP_Selection (SelectionName)
		SELECT SelectionName FROM @tblSelection WHERE SelectionType IS NULL		 

		UPDATE s
		SET s.SelectionType = ss.SelectionType
		FROM @tblSelection s
			INNER JOIN dbo.SMP_Selection ss WITH (NOLOCK) ON s.SelectionName = ss.SelectionName

		UPDATE @tblSelection
		SET ResultStatusId = CASE Result WHEN NULL THEN 0 WHEN 'running' THEN 1 ELSE 2 END

		MERGE dbo.SMP_MarketSelection AS t
		USING @tblSelection AS s
			ON t.MatchId = @MatchId
				AND t.MarketId = @MarketId
				AND t.SelectionType = s.SelectionType
		WHEN MATCHED THEN UPDATE
			SET t.Result = s.Result,
				t.ResultStatusId = s.ResultStatusId
		WHEN NOT MATCHED THEN INSERT
			(MatchId, MarketId, SelectionType, Result, ResultStatusId) VALUES (@MatchId, @MarketId, SelectionType, Result, ResultStatusId);
	END

	SELECT @betcheck = CONVERT(NVARCHAR(50), @MarketID)
	
	-- bettrans
	DECLARE @transid BIGINT
	INSERT INTO dbo.bettrans
	(
		custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,
		mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,creator,
		refno,winlostdate,betfrom,actualrate,matchid,recommend,mrecommend,ruben,betid,bettype,betdaqid,actual_stake,
		currency,ip,transdesc,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,
		oddstype,statusID,balance,transid2,betcheck
	)
	SELECT
		@custid,@transdate,1 AS oddsid,0,0,@odds,@stake,'running' AS status,0 AS winlost,0 AS awinlost,0 AS mwinlost,0 AS playercomm,0 AS comm,0 AS acomm,@apositiontaking,
		@mpositiontaking,@tpositiontaking,@playerdiscount,@discount,@adiscount,0 AS livehomescore,0 AS liveawayscore,0 AS liveindicator,@betteam,8 AS creator,
		100000000000 AS refno,@winlostdate,'d' AS betfrom,@actualrate,@matchid,@recommend,@mrecommend,0,1 AS betid,@bettype,1 AS betdaqid,@stake AS actual_stake,
		@currency,'10.21.10.01' AS ip,'' AS transdesc,@sdiscount,0 AS scomm,@spositiontaking,0 AS swinlost,@srecommend,@Username,@CurrencyName,@actualrate AS virtualrate,
		1,0 AS statusID,100 AS balance,0 AS transid2,@betcheck

	SELECT @transid = SCOPE_IDENTITY()

	-- oddsid
	INSERT INTO odds (matchid, bettype, sporttype, liveindicator, TBRepKey)
	SELECT t.matchid, t.bettype, t.sporttype, t.liveindicator, 1
	FROM (
		SELECT @matchid matchid, 38 bettype, 1 sporttype, 0 liveindicator
		FROM master.dbo.spt_values
		WHERE number = 1 AND type = 'p'
		UNION ALL
		SELECT @matchid matchid, 38 bettype, 1 sporttype, 1 liveindicator
		FROM master.dbo.spt_values
		WHERE number = 1 AND type = 'p'
	)t
	LEFT JOIN odds o 
		ON o.matchid = t.matchid
			AND o.sporttype = t.sporttype
			AND o.bettype = t.bettype
			AND o.liveindicator = t.liveindicator
	WHERE o.matchid IS NULL

	IF @MatchStatus = 'Completed'
	BEGIN
		IF @Status = 'WON'
		BEGIN
			UPDATE dbo.bettrans WITH (ROWLOCK, UPDLOCK)
			SET status = 'WON', statusID = 112, ruben = 1,
				winlost = @stake*(1+@odds),
				awinlost = -@stake*(1+@odds)*@apositiontaking,
				mwinlost = -@stake*(1+@odds)*@mpositiontaking,
				swinlost = -@stake*(1+@odds)*@spositiontaking,
				playercomm = @stake*@playerdiscount,
				comm = @stake*@discount*(1-@apositiontaking),
				acomm = @stake*@adiscount*(1-@apositiontaking-@mpositiontaking),
				scomm = @stake*@sdiscount*(1-@tpositiontaking)
			WHERE transid = @transid
		END
		ELSE IF @Status = 'LOSE'
		BEGIN
			UPDATE dbo.bettrans WITH (ROWLOCK, UPDLOCK)
			SET status = 'LOSE',
				statusID = 113,
				ruben = 1
			WHERE transid = @transid
		END
		ELSE IF @Status = 'DRAW'
		BEGIN
			UPDATE dbo.bettrans WITH (ROWLOCK, UPDLOCK)
			SET status = 'DRAW',
				statusID = 111,
				ruben = 1
			WHERE transid = @transid
		END
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