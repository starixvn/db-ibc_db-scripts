USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_Sportsbook_CreateData]
	@CustId			INT = 1176092 -- input custid of member
	,@WinlostDate	SMALLDATETIME = '2019-02-27' -- input winlostdate
	,@TransDate		SMALLDATETIME = '2019-02-27 12:59:59' -- input transdate
	,@SportType		INT = 1 -- input sporttype of SB
	,@BetType		INT = 1 -- input bettype of SB
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

DECLARE @transids TABLE (transid BIGINT, matchid INT, matchId_Ins INT)
INSERT INTO @transids (transid, matchid)
SELECT TOP (@NoOfTickets) b.transid, b.matchid
FROM bodb02.dbo.bettrans_DBA_TestData b WITH (NOLOCK)
	INNER JOIN bodb02.dbo.match_DBA_TestData m WITH (NOLOCK) ON b.matchid = m.matchid
WHERE m.sporttype = @SportType AND b.bettype = @BetType
	AND b.statusId = @statusID

SELECT @NoOfTickets_Ins = @@ROWCOUNT

IF @NoOfTickets_Ins = 0
BEGIN
	SELECT 'Not have data sample for this case! Please contact DBA!'
	RETURN
END

WHILE @NoOfTickets_Ins < @NoOfTickets
BEGIN
	INSERT INTO @transids (transid, matchid)
	SELECT TOP (@NoOfTickets - @NoOfTickets_Ins) transid, matchid FROM @transids

	SELECT @NoOfTickets_Ins = @NoOfTickets_Ins + @@ROWCOUNT
END

DECLARE @matchids_Ins TABLE (ID INT IDENTITY(1,1), matchid INT, matchId_Ins INT)

INSERT INTO bodb02.dbo.match
(
	leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,
	creator,matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,
	DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
	GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus
)
OUTPUT INSERTED.matchid INTO @matchids_Ins (matchId_Ins)
SELECT
	leagueid,homeid,awayid,@WinlostDate,eventstatus,betstatus,livehomescore,liveawayscore,finalhomescore,finalawayscore,
	creator,matchcode,kickofftime,closedtime,showtime,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,homeid2,awayid2,
	DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,InjuryTime,GoalRecord,ParentID,ChildMatchType,
	GlobalShowTime,HasLive,changetime,settletime,IsAutoPayout,AutoSetting,SettlementStatus
FROM bodb02.dbo.match_DBA_TestData m WITH (NOLOCK)
WHERE EXISTS (SELECT 1 FROM @transids t WHERE m.matchid = t.matchid)
ORDER BY m.matchid

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
	t.matchid,@recommend,@mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,@currency,ip,transdesc,
	sdiscount,scomm,spositiontaking,swinlost,@srecommend,@Username,@CurrencyName,@actualrate,oddstype,statusID,
	currency2,balance,SecAcceptFlag,transid2,RecommDate,ExtraInfo,WalletType,BonusID,RefCode
FROM bodb02.dbo.bettrans_DBA_TestData b WITH (NOLOCK)
	INNER JOIN @transids t ON b.transid = t.transid

-- Return data
SELECT b.*
FROM bodb02.dbo.bettrans b WITH (NOLOCK)
	INNER JOIN @transids_Ins t ON b.transid = t.transid

SELECT m.*
FROM bodb02.dbo.match m WITH (NOLOCK)
	INNER JOIN @matchids_Ins t ON m.matchid = t.matchId_Ins