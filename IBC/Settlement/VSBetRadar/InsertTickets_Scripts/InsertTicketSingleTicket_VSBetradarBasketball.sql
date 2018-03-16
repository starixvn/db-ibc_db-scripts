-- List of  corresponding betradar : 172,152,188,184,177,186,185,146,189,190,147,148,133,134,149,150,140,141,142
-- Phase 1: 401,402,403,404,405,406,407,408,409,410,411,412,413,414
-- Phase 2: 415,416,417,418,419,420,421,422,423,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,17,18 -- 424: not include 424
-- List new bettypes of PH P2a: 417,418,419,420,421,422,423,425,426,429,445,446,447 -- 424: not include (move to next phase)
-- List new bettypes of PH P2b: 417,418,419,420,421,422,423,424,425,426,429,445,446,447,416 
-- Auto betradar: 135,160,164,168,169,173,174,175,176,180,192,193,210,211,212,213,214,215,216,217,424
-- List of Corner bettypes: 194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209
-- Inst Calc: 8,14,178,190,402,404,435 -- 8,178,402,404(hdp1) ----Full bettypes: 3,8,14,18,127,178,189,190,401,402,403,404,434,435 ------ hdp bettypes: 3,8,18,178,401,402,403,404 ----- no hdp bettypes: 14,127,189,190,434,435
-- Determined all bettype: 3,4,6,8,13,14,16,18,26,27,30,126,127,128,129,130,131,132,133,134,140,141,142,143,144,145,146,147,148,149,150,152,159,161,162,163,170,172,178,179,181,182,187,188,189,190,195,196,197,198,199,200,201,202,204,205,206,207,302,304,401,402,403,404,405,406,407,408,409,412,413,414,415,416,417,418,419,420,421,422,423,426,427,429,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447
-- 4 New Bettypes Dec Only: 461,462,463,464
-- Bettypes for API: 1, 3, 7, 8, 5, 15, 28, 2, 12, 6, 126, 413, 414, 24, 151, 16, 405, 14, 127, 26, 13, 130, 129, 461, 462 , 463, 464
-- PH Phase 3: 22,448,449,450,451,452,453,454,455,456,457,458,459,460
-- Earlay list: 22,135,160,164,168,169,173,174,175,176,180,192,193,210,211,212,213,214,215,424,455
-- List Goal Record Bettype: 14,127,415,422,423,425,448,454
--insert into match(leagueid, homeid, awayid, eventdate, eventstatus, betstatus, livehomescore, liveawayscore, finalhomescore, finalawayscore, creator, matchcode, kickofftime, closedtime, showtime, hthomescore, htawayscore, ruben, multiple, yenbet, exrisk, sporttype,  homeid2, awayid2, DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, InjuryTime, GoalRecord, ParentID, ChildMatchType, GlobalShowTime, HasLive, changetime, settletime, IsAutoPayout, AutoSetting)
--select top 1 leagueid, homeid, awayid, '2018-02-13', eventstatus, betstatus, livehomescore, liveawayscore, finalhomescore, finalawayscore, creator, matchcode, '2018-02-13', closedtime, showtime, hthomescore, htawayscore, ruben, multiple, yenbet, exrisk, 193,  homeid2, awayid2, DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, InjuryTime, GoalRecord, ParentID, ChildMatchType, GlobalShowTime, HasLive, changetime, settletime, IsAutoPayout, AutoSetting
--from match (nolock) 
--where sporttype = 190 and eventstatus = 'running'
/*
insert into match (leagueid, homeid, awayid, eventdate, eventstatus, betstatus, livehomescore, liveawayscore, finalhomescore, finalawayscore, creator, matchcode, kickofftime, closedtime, showtime, hthomescore, htawayscore, ruben, multiple, yenbet, exrisk, sporttype, homeid2, awayid2, DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, InjuryTime, GoalRecord, ParentID, ChildMatchType, GlobalShowTime, HasLive, changetime, settletime, IsAutoPayout, AutoSetting)
select top 1 leagueid, homeid, awayid, eventdate, eventstatus, betstatus, livehomescore, liveawayscore, finalhomescore, finalawayscore, creator
		, 'HelentestVS2', kickofftime, closedtime, showtime, hthomescore, htawayscore, ruben, multiple, yenbet, exrisk
		, 193, homeid2, awayid2, DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, InjuryTime, GoalRecord, ParentID, ChildMatchType, GlobalShowTime, HasLive, changetime, settletime, IsAutoPayout, AutoSetting
from match (nolock)
where sporttype = 1 and eventstatus = 'running'
union all
select top 1 leagueid, homeid, awayid, eventdate, eventstatus, betstatus, livehomescore, liveawayscore, finalhomescore, finalawayscore, creator
, 'HelentestVS2', kickofftime, closedtime, showtime, hthomescore, htawayscore, ruben, multiple, yenbet, exrisk
		, 192, homeid2, awayid2, DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, InjuryTime, GoalRecord, ParentID, ChildMatchType, GlobalShowTime, HasLive, changetime, settletime, IsAutoPayout, AutoSetting
from match (nolock)
where sporttype = 1 and eventstatus = 'running'

union all
select top 1 leagueid, homeid, awayid, eventdate, eventstatus, betstatus, livehomescore, liveawayscore, finalhomescore, finalawayscore, creator
		, 'HelentestVS2', kickofftime, closedtime, showtime, hthomescore, htawayscore, ruben, multiple, yenbet, exrisk
		, 190, homeid2, awayid2, DisplayMode, LeaguePatternID, HomeDisplayPatternID, AwayDisplayPatternID, IsNeutral, InjuryTime, GoalRecord, ParentID, ChildMatchType, GlobalShowTime, HasLive, changetime, settletime, IsAutoPayout, AutoSetting
from match (nolock)
where sporttype = 1 and eventstatus = 'running'


select matchid,sporttype from match where matchcode = 'HelentestVS2'
*/

DECLARE @matchid int = 80001037
	,@bettype VARCHAR(1000) = '2801,2802,2803,2804,2805,2806,2807,2808,2809,2811,2812'
	,@isMatch BIT = 1 --1: need matchid, 0: no need matchid
	,@comstatus nvarchar(20) = '0'
	,@odds money = 1.9
	,@custid int = 1009827 -- 0: random custid/ 19717490: specified custid/  50057,78761,103873,851668,878902,879241: betdaq, 2331,1077687,15523642: betfair -- 2237314 member11
	,@hdp1 smallmoney = 2
DECLARE @tblbettype TABLE (seq INT IDENTITY(1,1),bettype SMALLINT PRIMARY KEY)
INSERT INTO @tblbettype(bettype)
SELECT val FROM dbo.strSplit(@bettype,',')

DECLARE @tblOdds table (oddsid INT, bettype SMALLINT)
DECLARE @tblResultDetail table (resourceID INT)

DECLARE @tblbettypeBetteam TABLE (bettype SMALLINT, betteam NVARCHAR(10), oddsType TINYINT, hdp1 SMALLMONEY, betid varchar(max))

DECLARE @betteam NVARCHAR(10) = 'ALL',@oddsid INT ,@eventdate date

IF @bettype is null
begin
	select 'plz input bettype'
	RETURN
end

	
INSERT INTO @tblbettypeBetteam (bettype, betteam, oddsType,hdp1, betid)
SELECT 2801,s.val,4,@hdp1,0 --Multiple
FROM dbo.strSplit ('h^a','^') s
UNION ALL
SELECT 2802,s.val,1,0 ,0
FROM dbo.strSplit ('1^x^2','^') s
UNION ALL
SELECT 2803,s.val,4,@hdp1,0  --Multiple
FROM dbo.strSplit ('o^u','^') s
UNION ALL
SELECT 2804,s.val,1,0,0
FROM dbo.strSplit ('o^u','^') s
UNION ALL
SELECT 2805,s.val,1,0,0
FROM dbo.strSplit ('h^a','^') s
UNION ALL
SELECT 2806,s.val,1,0,0
FROM dbo.strSplit ('h^a','^') s
UNION ALL
SELECT 2807,s.val,4,@hdp1,0 --Multiple
FROM dbo.strSplit ('H1-5^H6-10^H11+^A1-5^A6-10^A11+','^') s
UNION ALL
SELECT 2808,s.val,4,@hdp1,0 --Multiple
FROM dbo.strSplit ('H1-5^H6-10^H11+^D^A1-5^A6-10^A11+','^') s
UNION ALL
SELECT 2809,s.val,1,0,20 
FROM dbo.strSplit ('h^a','^') s

UNION ALL
SELECT 2809,s.val,1,0 ,40
FROM dbo.strSplit ('h^a','^') s

UNION ALL
SELECT 2809,s.val,1,0 ,60
FROM dbo.strSplit ('h^a','^') s

UNION ALL
SELECT 2811,s.val,1,0,0
FROM dbo.strSplit ('o^u','^') s
UNION ALL
SELECT 2812,s.val,1,0,0
FROM dbo.strSplit ('o^u','^') s

IF NOT exists (select TOP 1 1 from @tblbettypeBetteam where bettype IN (SELECT val FROM dbo.strSplit(@bettype,',')))
BEGIN
	select 'dont support bettype ' +@bettype 
	RETURN
END

IF @matchid is null
return
	
DECLARE @tmp_bettype SMALLINT,@seq INT = 1
	
WHILE (1 =1)
BEGIN
	SELECT @tmp_bettype = bettype FROM @tblbettype  WHERE seq = @seq
	IF @@rowcount = 0
		BREAK
		
	SELECT TOP 1 @oddsid = oddsid 
	FROM odds o WHERE o.matchid = @matchid AND o.bettype = @tmp_bettype
			
	IF @@rowcount = 0
	Begin
		INSERT INTO dbo.odds (matchid, bettype, oddsstatus, liveindicator, livehomescore, liveawayscore, creator, sporttype,SecAcceptFlag, SecAccept)
		SELECT @matchid, @tmp_bettype, 'running',0,0,0,8,193,0,20
		
		SET @oddsid = SCOPE_IDENTITY()
	END
	
	INSERT INTO @tblOdds(oddsid, bettype)
	SELECT @oddsid, @tmp_bettype
	
	SET @seq = @seq + 1
END


-----------------------------Process for bettrans

DECLARE @recommend int,@mrecommend int,@srecommend int, @hdp2 smallmoney,@refno bigint, @currency tinyint, @username nvarchar(50), @currencyName nvarchar(50)
, @stake money = 1000, @apos smallmoney = 0.4,@mpos smallmoney = 0.3, @spos smallmoney = 0.2 ,@tpos smallmoney = 0.9
, @playerdis decimal(9,8) = 0.02 ,@dis decimal(9,8) = 0.025, @adis decimal(9,8) = 0.03, @sdis decimal(9,8) = 0.04

SELECT top 1 @eventdate = eventdate from Match (nolock) where matchid = @matchid
If @custid = 0 
BEGIN
Select @custid = (SELECT top 1 custid from Custdb.dbo.custInfo (nolock) Where roleid = 1 and currency <> 20 and custid > 100000 and srecommend > 1000)
END

SELECT top 1 @refno = 100000000000, @recommend = c.recommend, @mrecommend = c.mrecommend,@currency = c.currency, @srecommend = c.srecommend, @username = c.Username, @currencyName = e.currency
FROM CustDB.dbo.custInfo c WITH (NOLOCK)
Inner Join exchange e with(nolock) ON c.currency = e.exchangeid
Where custid  = @custid

If @@rowcount = 0 
BEGIN
Print 'The custid does not exist, pls choose another one'

Return
END

DECLARE @tblResult table (transid bigint, bettype smallint, betteam nvarchar(10),hdp1 smallmoney, betid bigint)

INSERT INTO bettrans (custid, transdate, oddsid,bettype, hdp1, hdp2,betteam,betid, odds, stake, status, winlost, awinlost, mwinlost, playercomm, comm, acomm, apositiontaking, mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount, refno, winlostdate, matchid, recommend, mrecommend,  actual_stake, currency, sdiscount, scomm, spositiontaking, swinlost, srecommend,Username, CurrencyName, oddstype, statusID,comstatus,oddsspread)
OUTPUT INSERTED.transid, INSERTED.bettype, INSERTED.betteam, INSERTED.hdp1,INSERTED.betid
INTO @tblResult
SELECT	@custid,GETDATE(),o.oddsid,tb.bettype, tb.hdp1,0 as hdp2,tb.betteam, case when tb.bettype in (2809) then  '8' + tb.betid else 0 end AS betid, @odds, @stake, 'running', 0,0,0,0,0,0, @apos, @mpos, @tpos, @playerdis, @dis,@adis, @refno, @eventdate,@matchid, @recommend, @mrecommend,  @stake, @currency, @sdis, 0, @spos, 0, @srecommend,@Username, @CurrencyName,tb.oddsType, 0,@comstatus
, case when tb.bettype in (301,302,303,304) and tb.betteam = 'h' then 88 when  tb.bettype in (301,302,303,304) and tb.betteam = 'a' then -88 ELSE 0 END
FROM	@tblbettypeBetteam tb
--INNER JOIN @tblbettype t ON tb.bettype = t.bettype
INNER JOIN @tblOdds o ON o.bettype = tb.bettype
WHERE betteam = CASE WHEN @betteam = 'ALL' THEN betteam ELSE @betteam END

--Update multiple odds
Declare @multipleodds money
Update bettrans Set @multipleodds = (@odds-1)*(-1), odds = @multipleodds, actual_stake = @multipleodds*stake*(-1) Where matchid = @matchid and oddstype = 4 AND transid in (SELECT transid from @tblResult)

select @matchid
---View data
SELECT top 1000 * from bettrans (nolock) where matchid = @matchid
SELECT top 1000 bettype,betteam,betid from bettrans (nolock) where matchid = @matchid
--order by bettype