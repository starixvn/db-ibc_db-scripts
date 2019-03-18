USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_Sportsbook_CreateData]
	@CustId			INT = 1176092 -- input custid of member
	,@WinlostDate	SMALLDATETIME = NULL -- input winlostdate
	,@TransDate		SMALLDATETIME = NULL -- input transdate
	,@SportType		INT = 1 -- input sporttype of SB
	,@BetType		INT = 1 -- input bettype of SB
	,@betteam		VARCHAR(10) = NULL -- input betteam of tickets
	,@matchid		INT = NULL
	,@NoOfTickets	INT = 1 -- input number of tickets
	,@status		VARCHAR(20) = 'running' -- input status of tickets
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
		,@NoOfTickets	= 1 -- input number of tickets
		,@status		= 'running'
		
*/

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
	SELECT 'Invalid status!'
	RETURN
END
-- customer Info
DECLARE @username NVARCHAR(20), @recommend INT, @mrecommend INT, @srecommend INT, @currency INT, @currencyName VARCHAR(50), @actualrate FLOAT

SELECT @recommend = recommend, @mrecommend = mrecommend, @srecommend = srecommend, @currency = currency
FROM CustDB.dbo.custInfo WITH (NOLOCK)
WHERE custid = @custid AND roleId = 1

IF @recommend IS NULL
BEGIN
	SELECT 'Invalid custid!'
	RETURN
END

SELECT @currencyName = currency, @actualrate = actualrate
FROM bodb02.dbo.exchange WITH (NOLOCK)
WHERE exchangeid = @currency

-- Check valid sporttype/bettype
IF @BetType IN (9,29)
BEGIN
	SELECT 'Not support parlay yet!'
	RETURN
END

IF NOT EXISTS (SELECT 1 FROM bodb02.dbo.SportBettypeMatrix WITH (NOLOCK) WHERE ProductID = 1 AND SportType = @SportType AND BetType = @BetType)
BEGIN
	SELECT 'Support SB only!'
	RETURN
END

-- Insert tickets
DECLARE @NoOfTickets_Ins INT
DECLARE @transids_Ins TABLE (transid BIGINT)

DECLARE @transids TABLE (transid BIGINT, matchid INT, matchId_Ins INT, leagueId INT, leagueId_Ins INT)

IF @bettype <> 10
BEGIN
	INSERT INTO @transids (transid, matchid, matchId_Ins, leagueId, leagueId_Ins)
	SELECT TOP (@NoOfTickets) b.transid, b.matchid, b.matchid, m.leagueId, m.leagueId
	FROM bodb02.dbo.bettrans_DBA_TestData b WITH (NOLOCK)
		INNER JOIN bodb02.dbo.match_DBA_TestData m WITH (NOLOCK) ON b.matchid = m.matchid
	WHERE m.sporttype = @SportType AND b.bettype = @BetType
		AND b.statusId = @statusID
		AND (b.betteam = @betteam OR @betteam IS NULL)
		AND (m.matchid_bettrans = @matchid OR @matchid IS NULL)

	SELECT @NoOfTickets_Ins = @@ROWCOUNT
END
ELSE
BEGIN
	INSERT INTO @transids (transid, matchid, matchId_Ins, leagueId, leagueId_Ins)
	SELECT TOP (@NoOfTickets) b.transid, b.matchid, b.matchid, l.leagueId, l.leagueId
	FROM bodb02.dbo.bettrans_DBA_TestData b WITH (NOLOCK)
		INNER JOIN bodb02.dbo.outright_DBA_TestData m WITH (NOLOCK) ON b.matchid = m.orid
		INNER JOIN bodb02.dbo.League_DBA_TestData l WITH (NOLOCK) ON m.leagueid = l.leagueid
	WHERE l.sporttype = @SportType AND b.bettype = @BetType
		AND b.statusId = @statusID
		AND (b.betteam = @betteam OR @betteam IS NULL)
		AND (m.orid_bettrans = @matchid OR @matchid IS NULL)

	SELECT @NoOfTickets_Ins = @@ROWCOUNT
END

IF @NoOfTickets_Ins = 0
BEGIN
	DECLARE @host_name VARCHAR(50)
	SELECT  @host_name = RIGHT(HOST_NAME(), LEN(HOST_NAME()) - 6)

	SELECT 'Hi ' + @host_name + '!' + CHAR(10) + CHAR(13)
			+ 'Not have data sample for this case! Just sent email to DBA, please wait 5 mins!' AS Message
			, @matchid AS matchid, @SportType AS SportType, @BetType AS Bettype, @Status AS Status, @betteam AS betteam

	-- For send mail if not have data (job every 5 mins)
	DECLARE @Message VARCHAR(4000) = ''
	SELECT  @Message = 'Not have data sample for this info: '
						+ 'matchid = ' + ISNULL(CONVERT(VARCHAR(20), @matchid), 'NULL')
						+ 'SportType = ' + ISNULL(CONVERT(VARCHAR(20), @SportType), 'NULL')
						+ 'Bettype = ' + ISNULL(CONVERT(VARCHAR(20), @BetType), 'NULL')
						+ 'Status = ' + ISNULL(CONVERT(VARCHAR(20), @Status), 'NULL')
						+ 'betteam = ' + ISNULL(CONVERT(VARCHAR(20), @betteam), 'NULL')

	INSERT INTO dbo.DBA_TestData_ErrLog (ErrMsg)
	VALUES (@Message)

	RETURN
END

WHILE @NoOfTickets_Ins < @NoOfTickets
BEGIN
	INSERT INTO @transids (transid, matchid, leagueid)
	SELECT TOP (@NoOfTickets - @NoOfTickets_Ins) transid, matchid, leagueid FROM @transids

	SELECT @NoOfTickets_Ins = @NoOfTickets_Ins + @@ROWCOUNT
END

DECLARE @leagueids_Ins TABLE(ID INT IDENTITY(1,1), leagueId INT, leagueId_Ins INT)
DECLARE @matchids_Ins TABLE (ID INT IDENTITY(1,1), matchid INT, matchId_Ins INT)

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
			GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus
		)
		OUTPUT INSERTED.matchid INTO @matchids_Ins (matchId_Ins)
		SELECT
			t.leagueid,homeid,awayid,@WinlostDate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,
			creator,matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,
			DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
			GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus
		FROM bodb02.dbo.match_DBA_TestData m WITH (NOLOCK)
			INNER JOIN (SELECT DISTINCT matchid, leagueid FROM @transids) AS t ON m.matchid = t.matchid
		ORDER BY m.matchid
	END
	ELSE
	BEGIN
		INSERT INTO bodb02.dbo.outright
		(
			leagueid,teamid,eventdate,kickofftime,oddsstatus,odds,maxbet,gapodds,matchcode,groupmatch,status,creator,bal,risk,DisplayMode,ProgramID
			,HorseJockey,HorseDraw,HorseWgt,PlaceOdds,Placing,IsFavor,IsSCR,Colours,HorseTrainer,FOddsStatus,SCRTime,changetime,LeaguePatternID,TeamPatternID
			,ProgramDate,IsDeadheat,StdDelBetCheck,autosuspend,EventId,Year
		)
		OUTPUT INSERTED.orid INTO @matchids_Ins (matchId_Ins)
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
	FROM @matchids_Ins m
		INNER JOIN CTE_match c ON m.ID = c.RN

	UPDATE t
	SET t.matchid_Ins = m.matchid_Ins
	FROM @transids t
		INNER JOIN @matchids_Ins m ON t.matchid = m.matchid
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
	END
	ELSE
	BEGIN
		SELECT 'outright' AS TableName, m.*
		FROM bodb02.dbo.outright m WITH (NOLOCK)
			INNER JOIN @transids t ON m.orid = t.matchId_Ins
	END
END