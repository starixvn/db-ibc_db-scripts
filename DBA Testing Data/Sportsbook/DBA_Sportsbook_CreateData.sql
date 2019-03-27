USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_Sportsbook_CreateData]
	@CustId				INT = 1176092 -- input custid of member
	,@WinlostDate		SMALLDATETIME = NULL -- input winlostdate
	,@TransDate			SMALLDATETIME = NULL -- input transdate
	,@SportType			INT = 1 -- input sporttype of SB
	,@BetType			INT = 1 -- input bettype of SB
	,@betteam			VARCHAR(10) = NULL -- input betteam of tickets
	,@matchid			INT = NULL -- input matchid
	,@NoOfTickets		INT = 1 -- input number of tickets
	,@status			VARCHAR(20) = 'running' -- input status of tickets
	/* ===== for Parlay of SB: bettype = 29 ===== */
	,@NoOfSubTicket		INT = NULL
	-- choose one of @ListOfSportType or @ListOfMatchId
	,@ListOfSportType	VARCHAR(2000) = NULL -- list of SportType for each sub ticket
	,@ListOfMatchId		VARCHAR(2000) = NULL -- list of matchId for each sub ticket
	,@ListOfCombo		VARCHAR(100) = NULL -- list of 2 --> @NoOfSubTicket: '2', '2,3', '3'
AS

/*
	Created: Percy
	DB: DB206, DB230
	Task: Created testing data for Sportsbook
	-- Parlay, Outright: not support yet

	------------------- Sample execute --------------
	EXEC bodb02.dbo.DBA_Sportsbook_CreateData
		@CustId			= 1176092 -- input custid of member
		,@WinlostDate	= '2019-02-27' -- input winlostdate
		,@TransDate		= '2019-02-27 12:59:59' -- input transdate
		,@SportType		= 1 -- input sporttype of SB
		,@BetType		= 1 -- input bettype of SB
		,@betteam		= 'a' -- input betteam of tickets
		,@matchid		= NULL -- input matchid
		,@NoOfTickets	= 1 -- input number of tickets
		,@status		= 'running'
		
*/

--
DECLARE @host_name VARCHAR(50)
SELECT  @host_name = RIGHT(HOST_NAME(), LEN(HOST_NAME()) - 6)

IF EXISTS (
	SELECT 1 FROM ( VALUES 
		(6, 5)
		,(10, 1)
	) AS X (SportType, Bettype)
	WHERE SportType = @SportType AND Bettype = @BetType
)
BEGIN
	SELECT 0 AS ErrCode, N'This case is very hiếm =))' AS ErrMsg
	RETURN
END

IF @WinlostDate IS NULL
	SELECT @WinlostDate = CONVERT(DATE, GETDATE())

IF @TransDate IS NULL
	SELECT @TransDate = GETDATE()

-- Check status
DECLARE @statusID SMALLINT
SELECT  @statusID = CASE @status	WHEN 'WON'		THEN 112
									WHEN 'LOSE'		THEN 113
									WHEN 'DRAW'		THEN 111
									WHEN 'VOID'		THEN 102
									WHEN 'Reject'	THEN 101
									WHEN 'Refund'	THEN 103
									WHEN 'running'	THEN 0
									WHEN 'waiting'	THEN 1
									END

IF @statusID IS NULL
BEGIN
	SELECT 100 AS ErrCode, 'Invalid status!' AS ErrMsg
	RETURN
END
-- customer Info
DECLARE @username NVARCHAR(20), @recommend INT, @mrecommend INT, @srecommend INT, @currency INT, @currencyName VARCHAR(50), @actualrate FLOAT

SELECT @recommend = recommend, @mrecommend = mrecommend, @srecommend = srecommend, @currency = currency
FROM CustDB.dbo.custInfo WITH (NOLOCK)
WHERE custid = @custid AND roleId = 1

IF @recommend IS NULL
BEGIN
	SELECT 200 AS ErrCode, 'Invalid custid!' AS ErrMsg
	RETURN
END

SELECT @currencyName = currency, @actualrate = actualrate
FROM bodb02.dbo.exchange WITH (NOLOCK)
WHERE exchangeid = @currency

-- Check valid sporttype/bettype
IF @BetType IN (9)
BEGIN
	SELECT 300 AS ErrCode, 'Not support bettype 9!' AS ErrMsg
	RETURN
END
ELSE IF @BetType = 29
BEGIN
	SELECT 300 AS ErrCode, 'Not support bettype 29!' AS ErrMsg
	RETURN
	DECLARE @tblSubSportType TABLE (ID INT, SportType INT)
	DECLARE @tblSubMatchId TABLE (ID INT, matchid INT)

	IF @ListOfSportType IS NOT NULL
	BEGIN
		BEGIN TRY
			INSERT INTO @tblSubSportType (ID, SportType)
			SELECT rank, CONVERT(INT, val) FROM dbo.strSplit(@ListOfSportType, ',')
		END TRY
		BEGIN CATCH
			SELECT 400 AS ErrCode, 'Wrong format of @ListOfSportType' AS ErrMsg
			RETURN
		END CATCH

		INSERT INTO @tblSubMatchId (ID, matchid)
		SELECT 1,1
		FROM @tblSubSportType s
			INNER JOIN dbo.match m WITH (NOLOCK) ON s.SportType = m.sporttype
			INNER JOIN dbo.bettransm bm WITH (NOLOCK) ON m.matchid = bm.matchid
	END
	ELSE IF @ListOfMatchId IS NOT NULL
	BEGIN
		BEGIN TRY
			INSERT INTO @tblSubMatchId (ID, matchid)
			SELECT rank, CONVERT(INT, val) FROM dbo.strSplit(@ListOfMatchId, ',')
		END TRY
		BEGIN CATCH
			SELECT 500 AS ErrCode, 'Wrong format of @ListOfMatchId' AS ErrMsg
			RETURN
		END CATCH
	END
	
	IF @ListOfCombo IS NULL
		SELECT @ListOfCombo = '2'

	DECLARE @tblCombo TABLE (Combo INT)

	BEGIN TRY
		INSERT INTO @tblCombo (Combo)
		SELECT CONVERT(INT, val) FROM dbo.strSplit(@ListOfCombo, ',')
	END TRY
	BEGIN CATCH
		SELECT 400 AS ErrCode, 'Wrong format of @ListOfCombo' AS ErrMsg
		RETURN
	END CATCH

	IF @NoOfSubTicket IS NULL
		SELECT @NoOfSubTicket = 2

	IF @NoOfSubTicket = 1 OR EXISTS (SELECT 1 FROM @tblCombo WHERE Combo = 1)
	BEGIN
		SELECT 500 AS ErrCode, '@ListOfCombo and @NoOfSubTicket not allow value 1' AS ErrMsg
		RETURN
	END

	IF (SELECT MAX(Combo) FROM @tblCombo) > @NoOfSubTicket
	BEGIN
		SELECT 600 AS ErrCode, 'Not consistance between @ListOfCombo and @NoOfSubTicket' AS ErrMsg
		RETURN
	END

	SELECT @matchid = 29

	RETURN
END

IF NOT EXISTS (SELECT 1 FROM bodb02.dbo.CS_SportBettypeMatrix WITH (NOLOCK) WHERE ProductID = 1 AND SportType = @SportType AND BetType = @BetType)
BEGIN
	SELECT 700 AS ErrCode, 'Support SB only!' AS ErrMsg
	RETURN
END

--
DECLARE @LeagueId_Ins INT
IF @matchid IS NOT NULL
BEGIN
	IF @BetType = 10
		SELECT @LeagueId_Ins = o.leagueId
		FROM dbo.outright o WITH (NOLOCK)
			INNER JOIN dbo.League l WITH (NOLOCK) ON o.leagueid = l.leagueid
		WHERE o.orid = @matchid
			AND l.SportType = @SportType
	ELSE
		SELECT @LeagueId_Ins =m.leagueId FROM dbo.match m WITH (NOLOCK) WHERE m.matchid = @matchid AND SportType = @SportType
	
	IF @LeagueId_Ins IS NULL
	BEGIN
		SELECT 300 AS ErrCode, 'Invalid @matchid!' AS ErrMsg
		RETURN
	END
END

-- Insert tickets
DECLARE @NoOfTickets_Ins INT
DECLARE @transids_Ins TABLE (transid BIGINT)

DECLARE @transids TABLE (transid BIGINT, matchid INT, matchId_Ins INT, leagueId INT, leagueId_Ins INT)

IF @bettype <> 10
BEGIN
	INSERT INTO @transids (transid, matchid, matchId_Ins, leagueId, leagueId_Ins)
	SELECT TOP (@NoOfTickets) b.transid, b.matchid, @matchid, m.leagueId, @LeagueId_Ins
	FROM bodb02.dbo.bettrans_DBA_TestData b WITH (NOLOCK)
		INNER JOIN bodb02.dbo.match_DBA_TestData m WITH (NOLOCK) ON b.matchid = m.matchid
	WHERE m.sporttype = @SportType AND b.bettype = @BetType
		AND b.statusId = @statusID
		AND (b.betteam = @betteam OR @betteam IS NULL)
		--AND (m.matchid_bettrans = @matchid OR @matchid IS NULL)

	SELECT @NoOfTickets_Ins = @@ROWCOUNT
END
ELSE
BEGIN
	INSERT INTO @transids (transid, matchid, matchId_Ins, leagueId, leagueId_Ins)
	SELECT TOP (@NoOfTickets) b.transid, b.matchid, @matchid, l.leagueId, @LeagueId_Ins
	FROM bodb02.dbo.bettrans_DBA_TestData b WITH (NOLOCK)
		INNER JOIN bodb02.dbo.outright_DBA_TestData m WITH (NOLOCK) ON b.matchid = m.orid
		INNER JOIN bodb02.dbo.League_DBA_TestData l WITH (NOLOCK) ON m.leagueid = l.leagueid
	WHERE l.sporttype = @SportType AND b.bettype = @BetType
		AND b.statusId = @statusID
		AND (b.betteam = @betteam OR @betteam IS NULL)
		--AND (m.orid_bettrans = @matchid OR @matchid IS NULL)

	SELECT @NoOfTickets_Ins = @@ROWCOUNT
END

IF @NoOfTickets_Ins = 0
BEGIN
	SELECT 'Hi ' + @host_name + '!' + CHAR(10) + CHAR(13)
			+ 'Not have data sample for this case! Just sent email to DBA, please wait 5 mins!' AS Message
			, @matchid AS matchid, @SportType AS SportType, @BetType AS Bettype, @Status AS Status, @betteam AS betteam

	-- For send mail if not have data (job every 5 mins)
	DECLARE @Message VARCHAR(4000) = ''
	SELECT  @Message = 'Not have data sample for this info: '
						+ 'matchid = ' + ISNULL(CONVERT(VARCHAR(20), @matchid), 'NULL') + ', '
						+ 'SportType = ' + ISNULL(CONVERT(VARCHAR(20), @SportType), 'NULL') + ', '
						+ 'Bettype = ' + ISNULL(CONVERT(VARCHAR(20), @BetType), 'NULL') + ', '
						+ 'Status = ' + ISNULL(CONVERT(VARCHAR(20), @Status), 'NULL') + ', '
						+ 'betteam = ' + ISNULL(CONVERT(VARCHAR(20), @betteam), 'NULL')

	INSERT INTO dbo.DBA_TestData_ErrLog (ErrMsg, Username)
	VALUES (@Message, @host_name)

	RETURN
END

WHILE @NoOfTickets_Ins < @NoOfTickets
BEGIN
	INSERT INTO @transids (transid, matchid, matchId_Ins, leagueId, leagueId_Ins)
	SELECT TOP (@NoOfTickets - @NoOfTickets_Ins) transid, matchid, matchId_Ins, leagueId, leagueId_Ins FROM @transids

	SELECT @NoOfTickets_Ins = @NoOfTickets_Ins + @@ROWCOUNT
END

DECLARE @leagueids_Ins TABLE(ID INT IDENTITY(1,1), leagueId INT, leagueId_Ins INT)
CREATE TABLE #matchids_Ins (ID INT IDENTITY(1,1), matchid INT, matchId_Ins INT)

IF @matchid IS NULL
BEGIN
	INSERT INTO dbo.League
	(
		leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range
		,hdp_allowance,hdp_gapodds,hdp_gapoddsr,ou_min,ou_max,ou_risk,ou_range,ou_allowance,ou_gapodds,ou_gapoddsr,oe_min,oe_max,oe_risk,oe_range
		,oe_gapodds,cs_min,cs_max,cs_risk,cs_range,cs_gapodds,b1x2_min,b1x2_max,b1x2_risk,b1x2_range,b1x2_gapodds,tg_min,tg_max,tg_risk,tg_range
		,tg_gapodds,ht_min,ht_max,ht_risk,ht_range,ht_allowance,ht_gapodds,ht_gapoddsr,ht1x2_min,ht1x2_max,ht1x2_risk,ht1x2_range
		,ht1x2_gapodds,leaguenamec_uni,leaguenamej,sporttype,createdate,leaguenamecn,oe_gapoddsr,DisplayMode,isTest,leaguenameth,ProgramID
		,TrackCondition,IsActive,leaguenameko,TrackConditionCh,TrackConditionCs,leaguenameES,CountryCode,leaguenameVN,GameSession,SessionTime,OverTime
		,leaguenameEL,OverTimeSession,IsCountDownTimer,Category,IsMainMarket,leaguecode,outright,leaguenameSC2,DisplayCat,IsAutoPayout,AutoSetting
		,[Group],ShowInAllMarket,PutInMainCat,leaguenameMMR,leaguenameHI
	)
	OUTPUT INSERTED.leagueId INTO @leagueids_Ins (leagueId_Ins)
	SELECT
		leaguename,maxstake,minstake,maxstakeou,maxstakeoe,leaguenamec,leaguenametc,creator,lcolor,hdp_min,hdp_max,hdp_risk,hdp_range
		,hdp_allowance,hdp_gapodds,hdp_gapoddsr,ou_min,ou_max,ou_risk,ou_range,ou_allowance,ou_gapodds,ou_gapoddsr,oe_min,oe_max,oe_risk,oe_range
		,oe_gapodds,cs_min,cs_max,cs_risk,cs_range,cs_gapodds,b1x2_min,b1x2_max,b1x2_risk,b1x2_range,b1x2_gapodds,tg_min,tg_max,tg_risk,tg_range
		,tg_gapodds,ht_min,ht_max,ht_risk,ht_range,ht_allowance,ht_gapodds,ht_gapoddsr,ht1x2_min,ht1x2_max,ht1x2_risk,ht1x2_range
		,ht1x2_gapodds,leaguenamec_uni,leaguenamej,sporttype,createdate,leaguenamecn,oe_gapoddsr,DisplayMode,isTest,leaguenameth,ProgramID
		,TrackCondition,IsActive,leaguenameko,TrackConditionCh,TrackConditionCs,leaguenameES,CountryCode,leaguenameVN,GameSession,SessionTime,OverTime
		,leaguenameEL,OverTimeSession,IsCountDownTimer,Category,IsMainMarket,leaguecode,outright,leaguenameSC2,DisplayCat,IsAutoPayout,AutoSetting
		,[Group],ShowInAllMarket,PutInMainCat,leaguenameMMR,leaguenameHI
	FROM dbo.league_DBA_TestData l WITH (NOLOCK)
	WHERE EXISTS (SELECT 1 FROM @transids t WHERE l.leagueId = t.leagueId)

	;WITH CTE_league AS (
		SELECT leagueid, ROW_NUMBER() OVER(ORDER BY leagueid) AS RN
		FROM (SELECT DISTINCT leagueid FROM @transids) AS A
	)
	UPDATE l
	SET l.leagueid = c.leagueid
	FROM @leagueids_Ins l
		INNER JOIN CTE_league c ON l.ID = c.RN

	UPDATE t
	SET t.leagueid_Ins = l.leagueid_Ins
	FROM @transids t
		INNER JOIN @leagueids_Ins l ON t.leagueid = l.leagueid

	IF @bettype <> 10
	BEGIN
		INSERT INTO bodb02.dbo.match
		(
			leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,
			creator,matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,
			DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
			GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus,ShowTimeDT
		)
		OUTPUT INSERTED.matchid INTO #matchids_Ins (matchId_Ins)
		SELECT
			t.leagueid,homeid,awayid,@WinlostDate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,
			creator,matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,
			DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
			GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus,ShowTimeDT
		FROM bodb02.dbo.match_DBA_TestData m WITH (NOLOCK)
			INNER JOIN (SELECT DISTINCT matchid, leagueid FROM @transids) AS t ON m.matchid = t.matchid
		ORDER BY m.matchid

		WHILE EXISTS (SELECT 1 FROM #matchids_Ins WHERE matchId_Ins BETWEEN 99000000 AND 99000200)
		BEGIN
			TRUNCATE TABLE #matchids_Ins

			INSERT INTO bodb02.dbo.match
			(
				leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,
				creator,matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,
				DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
				GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus,ShowTimeDT
			)
			OUTPUT INSERTED.matchid INTO #matchids_Ins (matchId_Ins)
			SELECT
				t.leagueid,homeid,awayid,@WinlostDate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,
				creator,matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,
				DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
				GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus,ShowTimeDT
			FROM bodb02.dbo.match_DBA_TestData m WITH (NOLOCK)
				INNER JOIN (SELECT DISTINCT matchid, leagueid FROM @transids) AS t ON m.matchid = t.matchid
			ORDER BY m.matchid
		END
	END
	ELSE
	BEGIN
		INSERT INTO bodb02.dbo.outright
		(
			leagueid,teamid,eventdate,kickofftime,oddsstatus,odds,maxbet,gapodds,matchcode,groupmatch,status,creator,bal,risk,DisplayMode,ProgramID
			,HorseJockey,HorseDraw,HorseWgt,PlaceOdds,Placing,IsFavor,IsSCR,Colours,HorseTrainer,FOddsStatus,SCRTime,changetime,LeaguePatternID,TeamPatternID
			,ProgramDate,IsDeadheat,StdDelBetCheck,autosuspend,EventId,Year
		)
		OUTPUT INSERTED.orid INTO #matchids_Ins (matchId_Ins)
		SELECT
			t.leagueid,teamid,eventdate,kickofftime,oddsstatus,odds,maxbet,gapodds,matchcode,groupmatch,status,creator,bal,risk,DisplayMode,ProgramID
			,HorseJockey,HorseDraw,HorseWgt,PlaceOdds,Placing,IsFavor,IsSCR,Colours,HorseTrainer,FOddsStatus,SCRTime,changetime,LeaguePatternID,TeamPatternID
			,ProgramDate,IsDeadheat,StdDelBetCheck,autosuspend,EventId,Year
		FROM bodb02.dbo.outright_DBA_TestData m WITH (NOLOCK)
			INNER JOIN (SELECT DISTINCT matchid, leagueid FROM @transids) AS t ON m.orid = t.matchid
		ORDER BY m.orid
	END

	;WITH CTE_match AS (
		SELECT matchid, ROW_NUMBER() OVER(ORDER BY matchid) AS RN
		FROM (SELECT DISTINCT matchid FROM @transids) AS A
	)
	UPDATE m
	SET m.matchid = c.matchid
	FROM #matchids_Ins m
		INNER JOIN CTE_match c ON m.ID = c.RN

	UPDATE t
	SET t.matchid_Ins = m.matchid_Ins
	FROM @transids t
		INNER JOIN #matchids_Ins m ON t.matchid = m.matchid

	INSERT INTO dbo.match_remark
	(
		[matchid],[calculate],[multiple],[calrefund],[refund],[calStatus],[IsTotalBetDenied_1],[IsTotalBetDenied_3],[IsTotalBetDenied_7]
		,[IsTotalBetDenied_8],[LiveTimer],[HomeRedCard],[AwayRedCard],[LivePeriod],[HedgeForecast],[IsTotalBetDenied_20],[IsTotalBetDenied_21]
		,[IsNeutral],[StreamingID],[IsInternal],[IsHTCal],[LiveDeleteChecker],[HomeColor],[AwayColor],[ConfirmHT],[ConfirmFT],[PausePeriod]
		,[TimerSuspend],[isPending],[isUndecided],[StdDelBetCheck],[SettlementStatus135],[DelayLive],[HomeSubstitutes],[AwaySubstitutes]
		,[StartTeam],[RBEventNumber],[RBLinkStatus],[HomePenalty],[AwayPenalty],[HomeYellowCard],[AwayYellowCard],[IsHT],[IsMiniOdds]
		,[StreamingOfferToCredit],[Tier],[BestOfMap],[IsStartingSoon],[MoveBO3Down],[ShowLiveScore],[isFullTime],[MatchType],[GameStatus],OfferLive
	)
	SELECT
		matchId_Ins,[calculate],[multiple],[calrefund],[refund],[calStatus],[IsTotalBetDenied_1],[IsTotalBetDenied_3],[IsTotalBetDenied_7]
		,[IsTotalBetDenied_8],[LiveTimer],[HomeRedCard],[AwayRedCard],[LivePeriod],[HedgeForecast],[IsTotalBetDenied_20],[IsTotalBetDenied_21]
		,[IsNeutral],[StreamingID],[IsInternal],[IsHTCal],[LiveDeleteChecker],[HomeColor],[AwayColor],[ConfirmHT],[ConfirmFT],[PausePeriod]
		,[TimerSuspend],[isPending],[isUndecided],[StdDelBetCheck],[SettlementStatus135],[DelayLive],[HomeSubstitutes],[AwaySubstitutes]
		,[StartTeam],[RBEventNumber],[RBLinkStatus],[HomePenalty],[AwayPenalty],[HomeYellowCard],[AwayYellowCard],[IsHT],[IsMiniOdds]
		,[StreamingOfferToCredit],[Tier],[BestOfMap],[IsStartingSoon],[MoveBO3Down],[ShowLiveScore],[isFullTime],[MatchType],[GameStatus],OfferLive
	FROM dbo.match_remark_DBA_TestData m WITH (NOLOCK)
		INNER JOIN (SELECT DISTINCT matchid, matchId_Ins FROM @transids) AS t ON m.matchid = t.matchid

	INSERT INTO [dbo].[odds]
	(
		[matchid],[bettype],[switch],[hdp1],[hdp2],[odds1a],[odds2a],[odds1b],[odds2b],[odds1c],[odds2c],[odds1e],[odds2e],[odds1f],[odds2f]
		,[odds1d],[odds2d],[odds1hka],[odds2hka],[odds1hkb],[odds2hkb],[odds1hkc],[odds2hkc],[odds1hke],[odds2hke],[odds1hkf],[odds2hkf]
		,[odds1hkd],[odds2hkd],[oddsspreada],[oddsspreadb],[oddsspreadd],[oddsspreade],[oddsspreadf],[oddsspreadc],[autobookie],[gapodds1]
		,[gapodds2],[maxstake1],[maxstake2],[minstake1],[minstake2],[diffbalance],[maxodds],[minodds],[oddsstatus],[liveindicator]
		,[changetime],[risk],[stakerange],[newoffersetup],[livehomescore],[liveawayscore],[creator],[com1],[comx],[com2],[cs00],[cs01]
		,[cs10],[cs11],[cs02],[cs12],[cs22],[cs21],[cs20],[cs30],[cs31],[cs32],[cs33],[cs23],[cs13],[cs03],[cs43],[cs42],[cs41],[cs40]
		,[cs44],[cs14],[cs24],[cs04],[cs34],[cs50],[cs05],[comstatus],[csstatus],[commaxbet],[csmaxbet],[com1total],[comxtotal],[com2total]
		,[bal00],[bal10],[bal11],[bal01],[bal20],[bal21],[bal22],[bal12],[bal02],[bal30],[bal31],[bal32],[bal33],[bal23],[bal13],[bal03]
		,[bal40],[bal41],[bal42],[bal43],[bal44],[bal34],[bal24],[bal14],[bal04],[bal50],[bal05],[maxbet],[ht],[autoreject],[allowance]
		,[autosuspend],[multiple],[stakerange2],[risk2],[allowance2],[site2],[site3],[site4],[hometotal],[awaytotal],[sporttype],[goal]
		,[HasBeenLinked],[LinkedHdpId],[LinkedOUId],[TBRepKey],[Linked1X2Id],[SecAcceptFlag],[SecAccept],[Resourceid],[Resultkey]
		,[cs99],[bal99],[autosuspend2],[FavLimit],[UndLimit]
	)
	SELECT TOP 10
		matchId_Ins,[bettype],[switch],[hdp1],[hdp2],[odds1a],[odds2a],[odds1b],[odds2b],[odds1c],[odds2c],[odds1e],[odds2e],[odds1f],[odds2f]
		,[odds1d],[odds2d],[odds1hka],[odds2hka],[odds1hkb],[odds2hkb],[odds1hkc],[odds2hkc],[odds1hke],[odds2hke],[odds1hkf],[odds2hkf]
		,[odds1hkd],[odds2hkd],[oddsspreada],[oddsspreadb],[oddsspreadd],[oddsspreade],[oddsspreadf],[oddsspreadc],[autobookie],[gapodds1]
		,[gapodds2],[maxstake1],[maxstake2],[minstake1],[minstake2],[diffbalance],[maxodds],[minodds],[oddsstatus],[liveindicator]
		,[changetime],[risk],[stakerange],[newoffersetup],[livehomescore],[liveawayscore],[creator],[com1],[comx],[com2],[cs00],[cs01]
		,[cs10],[cs11],[cs02],[cs12],[cs22],[cs21],[cs20],[cs30],[cs31],[cs32],[cs33],[cs23],[cs13],[cs03],[cs43],[cs42],[cs41],[cs40]
		,[cs44],[cs14],[cs24],[cs04],[cs34],[cs50],[cs05],[comstatus],[csstatus],[commaxbet],[csmaxbet],[com1total],[comxtotal],[com2total]
		,[bal00],[bal10],[bal11],[bal01],[bal20],[bal21],[bal22],[bal12],[bal02],[bal30],[bal31],[bal32],[bal33],[bal23],[bal13],[bal03]
		,[bal40],[bal41],[bal42],[bal43],[bal44],[bal34],[bal24],[bal14],[bal04],[bal50],[bal05],[maxbet],[ht],[autoreject],[allowance]
		,[autosuspend],[multiple],[stakerange2],[risk2],[allowance2],[site2],[site3],[site4],[hometotal],[awaytotal],[sporttype],[goal]
		,[HasBeenLinked],[LinkedHdpId],[LinkedOUId],[TBRepKey],[Linked1X2Id],[SecAcceptFlag],1 AS [SecAccept],[Resourceid],[Resultkey]
		,[cs99],[bal99],[autosuspend2],[FavLimit],[UndLimit]
	FROM dbo.odds_DBA_TestData o WITH (NOLOCK)
		INNER JOIN (SELECT DISTINCT matchid, matchId_Ins FROM @transids) AS t ON o.matchid = t.matchid
END

INSERT INTO bodb02.dbo.bettrans
(
	custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,
	apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,
	liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,
	matchid,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,
	sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,
	currency2,balance,SecAcceptFlag,transid2,RecommDate,ExtraInfo,WalletType,BonusID,RefCode
)
OUTPUT INSERTED.transid INTO @transids_Ins (transid)
SELECT
	@custid,@transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,
	apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,
	liveindicator,betteam,creator,refno,comstatus,@winlostdate,betfrom,betcheck,checktime,oddsspread,@actualrate,
	t.matchId_Ins,@recommend,@mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,@currency,ip,transdesc,
	sdiscount,scomm,spositiontaking,swinlost,@srecommend,@Username,@CurrencyName,@actualrate,oddstype,statusID,
	currency2,balance,SecAcceptFlag,transid2,RecommDate,ExtraInfo,WalletType,BonusID,RefCode
FROM bodb02.dbo.bettrans_DBA_TestData b WITH (NOLOCK)
	INNER JOIN @transids t ON b.transid = t.transid

-- Return data
BEGIN
	SELECT 'bettrans' AS TableName, b.transid, b.bettype, b.betteam, b.status, b.statusId, b.*
	FROM bodb02.dbo.bettrans b WITH (NOLOCK)
		INNER JOIN @transids_Ins t ON b.transid = t.transid

	IF @BetType <> 10
	BEGIN
		SELECT 'match' AS TableName, m.*
		FROM bodb02.dbo.match m WITH (NOLOCK)
			INNER JOIN @transids t ON m.matchid = t.matchId_Ins

		SELECT 'odds' AS TableName, o.*
		FROM bodb02.dbo.odds o WITH (NOLOCK)
			INNER JOIN @transids t ON o.matchid = t.matchId_Ins
	END
	ELSE
	BEGIN
		SELECT 'outright' AS TableName, m.*
		FROM bodb02.dbo.outright m WITH (NOLOCK)
			INNER JOIN @transids t ON m.orid = t.matchId_Ins
	END
END

DROP TABLE #matchids_Ins