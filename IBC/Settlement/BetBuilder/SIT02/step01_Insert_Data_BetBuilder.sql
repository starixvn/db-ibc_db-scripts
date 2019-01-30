/*
	Created: 20190130@Vicky
	Task : create data for BetBuilder
	DB:  SIT2DB02/bodb02
*/
 USE bodb02
 GO


DECLARE @matchid INT, @match_code varchar(20),@FixtureId INT, @vendorid INT, @selectionName1 VARCHAR(200), @selectionName2 VARCHAR(200), @selectionName3 VARCHAR(200)
DECLARE @Sporttype INT = 1
CREATE TABLE #tblMarketID (marketID VARCHAR(20), selectionType INT, Result VARCHAR(20),selectionName INT)
DECLARE @tblKey TABLE(vID INT)
DECLARE @iMarket INT, @totalMaketCreated INT, @curMarket INT
DECLARE @numTicket INT
CREATE TABLE  #tblBetType (BetType SMALLINT, betcheck varchar(20))

--------------------------------------------------------------------------------
SELECT @match_code = 'VK_20190130_1'
		,@totalMaketCreated = 3
		,@numTicket = 2

------------------------------------------------------------------------------------
SET @FixtureId = COALESCE((SELECT MAX(FixtureID) FROM VendorStatus WHERE vendorID = 34),0) + 1
SET @vendorid=34

SELECT 'start create market'
SELECT @iMarket = 0
	   ,@curMarket = 100000236
	   ,@iMarket = @curMarket

WHILE @iMarket < @totalMaketCreated + @curMarket
BEGIN
	
	SELECT @iMarket = @iMarket +1
			,@selectionName1 = FLOOR(RAND()*(20-5+1)+1) 
			,@selectionName2 = FLOOR(RAND()*(20-5+1)+1)
			,@selectionName3 = FLOOR(RAND()*(20-5+1)+1)
			
	INSERT INTO #tblMarketID(marketID, selectionType, Result)
	VALUES (@iMarket,@selectionName1,'WON')
		  ,(@iMarket,@selectionName2,'WON')
		  ,(@iMarket,@selectionName3,'WON')
END 

SELECT 'end create market'
--------------------------------------------------------------------------------
--DELETE VendorStatus WHERE FixtureId = @FixtureId
--DELETE SMP_Market WHERE  FixtureId = @FixtureId
--DELETE SMP_MarketSelection WHERE FixtureId = @FixtureId
	
--------------------------------------------------------------------------------

INSERT INTO dbo.match(homeid, awayid, eventstatus, matchcode,  leagueid,creator,sporttype,homeid2,awayid2,DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,HasLive, eventdate,kickofftime, autosetting)
OUTPUT INSERTED.matchID INTO @tblKey(vID)
VALUES           (191601, 191602, 'Running',  @match_code, 100,       8,       @SportType,      0,      0,      0,           0,               0,                      0,               0,          0, getdate(), getdate(),8)



SELECT  @matchid = vID 
from @tblKey

SELECT 'matchid', @matchid


-----------------------------VENDOR

INSERT INTO VendorStatus(matchid,  vendorid, SB_TradeStatusID, VD_TradeStatusID,  Link,Opened,changetime,FixtureId)
VALUES					(@matchid, @vendorid,	1,					1,				1,      1,   null,   @FixtureId)	

-----------------------------------SMP_Market
INSERT INTO SMP_Market(VendorID,  matchID, MarketID, Price,  TradeStatus,Result,ResultStatusID,SelectionCounts,CreateTime,UpdateTime)
SELECT DISTINCT @vendorid, @matchid,marketID,	10,      'Open',    MIN(result), 0,				2,			  GETDATE(),GETDATE()	
FROM #tblMarketID
GROUP BY marketID

-----------------------------------SMP_Selection
/*INSERT INTO SMP_Selection(SelectionName)
SELECT DISTINCT SelectionName
FROM #tblMarketID
WHERE  SelectionName NOT IN (SELECT SelectionName FROM SMP_Selection)
*/
-----------------------------------UPDATE selectionType
/*UPDATE tmpM
SET tmpM.selectionType = s.selectionType
FROM #tblMarketID tmpM
	INNER JOIN SMP_Selection s ON s.SelectionName = tmpM.selectionName
*/


-----------------------------------SMP_MarketSelection
INSERT INTO SMP_MarketSelection (matchID,MarketId,SelectionType,Result,ResultStatusId)
SELECT DISTINCT @matchid,marketID,selectionType,Result,0
FROM  #tblMarketID





--------------------------------BETTRANS------------------------------------------



INSERT INTO #tblBetType (BetType , betcheck)
SELECT DISTINCT 38, marketID
FROM #tblMarketID

    
-----------------------------------------------------------------------------------------------------

SELECT 'insert bettrans'
BEGIN
    DECLARE @custid  INT,@transdate DATETIME,@oddsid INT,@hdp1 SMALLMONEY,@hdp2 SMALLMONEY,@odds SMALLMONEY,@stake MONEY,@status nvarchar(10),@winlost MONEY,@awinlost MONEY,@mwinlost MONEY,@playercomm MONEY,@comm MONEY,@acomm MONEY,@apositiontaking SMALLMONEY,@mpositiontaking SMALLMONEY,@tpositiontaking SMALLMONEY,@playerdiscount DECIMAL(9,8),@discount DECIMAL(9,8),@adiscount DECIMAL(9,8),@livehomescore SMALLINT,@liveawayscore SMALLINT,@liveindicator BIT,@betteam nvarchar(10),@creator INT,@refno BIGINT,@comstatus  NVARCHAR(20),@winlostdate SMALLDATETIME,@betfrom NVARCHAR(1),@betcheck NVARCHAR(50),@checktime DATETIME,@oddsspread MONEY,@actualrate FLOAT,@recommend INT,@mrecommend INT,@ruben TINYINT,@betid BIGINT,@statuswinlost TINYINT,@modds SMALLMONEY,@bettype SMALLINT,@betdaqid BIGINT,@tstamp TIMESTAMP,@actual_stake MONEY,@currency TINYINT,@ip NVARCHAR(15),@transdesc NVARCHAR(1000),@sdiscount DECIMAL(9,8),@scomm MONEY,@spositiontaking SMALLMONEY,@swinlost MONEY,@srecommend  INT,@Username NVARCHAR(50),@CurrencyName  NVARCHAR(50),@virtualrate FLOAT,@oddstype TINYINT,@statusID TINYINT,@currency2 TINYINT,@balance MONEY,@SecAcceptFlag BIT,@transid2 BIGINT,@RecommDate DATETIME,@ExtraInfo VARCHAR(1000),@WalletType TINYINT,@BonusID INT,@RefCode BIGINT
	SELECT @custid  =29040458, @transdate = GETDATE(),@oddsid =207,@hdp1 =4.00,@hdp2 =0.00,@odds =1.88,@stake =100.00,@winlost =0,@awinlost =0,@mwinlost =0.00,@playercomm =0.00,@comm =0,@acomm =0,@apositiontaking =0.03,@mpositiontaking =0.100,@tpositiontaking =0.63,@playerdiscount =0.00000000,@discount =0.00200000,@adiscount =0.00200000,@livehomescore =0,@liveawayscore =0,@liveindicator =0,@creator =29040458,@refno =299415096,@comstatus  =0,@winlostdate =GETDATE(),@betfrom ='i',@betcheck ='TXN20180718133118001',@checktime =GETDATE(),@oddsspread = NULL,@actualrate =2E-102,@recommend =14228863,@mrecommend =14191761,@ruben =1,@statuswinlost =1.00,@modds = NULL,@betdaqid =4100200/*--,@tstamp =GETDATE()*/,@actual_stake =100.00,@currency =20,@ip ='127.0.0.1',@transdesc = 'transdesc',@sdiscount= 0.00250000,@scomm =0.0093,@spositiontaking =0.60,@swinlost =0,@srecommend  =1338545,@Username ='twpgmyolanda.wu',@CurrencyName  ='UUS',@virtualrate =2E-102,@oddstype =4,@currency2 =NULL,@balance =20204.44,@SecAcceptFlag =0,@transid2 =NULL,@RecommDate =NULL,@ExtraInfo =NULL,@WalletType =NULL,@BonusID =NULL,@RefCode =NULL
			,@status ='running'
			,@statusID =0
	DECLARE @i INT
	SET @i = 0
	WHILE @i < @numTicket
	BEGIN
	    SET @i = @i + 1
	    
	    INSERT INTO DBTXN.bodb02.dbo.bettrans(custid, transdate,  oddsid,  hdp1,  hdp2,  odds,  stake,  status,  winlost,  awinlost,  mwinlost,  playercomm,  comm,  acomm,  apositiontaking,  mpositiontaking,  tpositiontaking,  playerdiscount,  discount,  adiscount,  livehomescore,  liveawayscore,  liveindicator,  betteam,    creator,  refno,  comstatus,  winlostdate,  betfrom,  betcheck,  checktime,  oddsspread,  actualrate,  matchid,  recommend,  mrecommend,  ruben,  betid,    statuswinlost,  modds,  bettype,    betdaqid,   actual_stake,  currency,  ip,  transdesc,  sdiscount,  scomm,  spositiontaking,  swinlost,  srecommend,  Username,  CurrencyName,  virtualrate,  oddstype,  statusID,  currency2,  balance,  SecAcceptFlag,  transid2,  RecommDate,  ExtraInfo,  WalletType,  BonusID,  RefCode)
	    SELECT              @custid, @transdate, @oddsid, @hdp1, @hdp2, @odds, @stake, @status, @winlost, @awinlost, @mwinlost, @playercomm, @comm, @acomm, @apositiontaking, @mpositiontaking, @tpositiontaking, @playerdiscount, @discount, @adiscount, @livehomescore, @liveawayscore, @liveindicator, '', @creator, @refno, @comstatus, @winlostdate, @betfrom, betcheck, @checktime, @oddsspread, @actualrate, @matchid, @recommend, @mrecommend, @ruben, 0, @statuswinlost, @modds, bt.bettype, @betdaqid,  @actual_stake, @currency, @ip, @transdesc, @sdiscount, @scomm, @spositiontaking, @swinlost, @srecommend, @Username, @CurrencyName, @virtualrate, @oddstype, @statusID, @currency2, @balance, @SecAcceptFlag, @transid2, @RecommDate, @ExtraInfo, @WalletType, @BonusID, @RefCode
	    FROM #tblBetType bt
	END
END 

DROP TABLE #tblMarketID
DROP TABLE #tblBetType