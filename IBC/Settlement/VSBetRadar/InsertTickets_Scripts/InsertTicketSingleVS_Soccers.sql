--VS Betradar: 2701,2702,2703,2704,2705,2706,2707
DECLARE @matchid int = 70030595
	,@bettype VARCHAR(1000) = '2701,2702,2703,2704,2705,2706,2707'
	,@comstatus nvarchar(5) = '0'
	,@odds money = 0.96
	,@custid int = 1009827 --1339673 --25209587-- 0: random custid/ 19717490: specified custid/  50057,78761,103873,851668,878902,879241: betdaq, 2331,1077687,15523642: betfair
	,@hdp1 smallmoney =0.75 --35869,3462557
	,@hdp2 smallmoney = 0
	,@sporttype int = 190
	,@isMatch bit =0

	If @isMatch = 1
	Begin
	Declare @tblMatch table (matchid int, matchcode nvarchar(20))
	Declare @tmpMatchid int
	Insert into match (leagueid,homeid,awayid,eventdate,eventstatus,betstatus,matchcode,kickofftime,sporttype,GoalRecord,livehomescore,liveawayscore,hthomescore,htawayscore,finalhomescore,finalawayscore,creator,AutoSetting)
	OUTPUT INSERTED.matchid, INSERTED.matchcode
	INTO @tblMatch
	Select top 1 leagueid,homeid,awayid,CONVERT(nvarchar(10),CURRENT_TIMESTAMP,120) as eventdate,'running' as eventstatus, NULL as betstatus,'VSBetradarHelenTest' as matchcode,GETDATE() as kickofftime,@sporttype as sporttype,NULL as GoalRecord,0 as livehomescore,0 as liveawayscore, NULL as hthomescore,NULL as htawayscore,NULL as finalhomescore,NULL as finalawayscore,8 as creator, NULL as autosetting
	From Match (nolock) Where sporttype = 1
	
	Select @tmpMatchid = (Select matchid from @tblMatch)
	Update Match Set matchcode = matchcode + cast(@tmpMatchid as nvarchar(20)) Where matchid = @tmpMatchid
	
	Insert into match_remark (matchid,IsHTCal, calculate,refund,calrefund,multiple)
	VALUES (@tmpMatchid,0,0,0,0,0 )
	
	Select  matchid,matchcode from @tblMatch
	RETURN
	End

DECLARE @tblbettype TABLE (seq INT IDENTITY(1,1),bettype SMALLINT PRIMARY KEY)
INSERT INTO @tblbettype(bettype)
SELECT val FROM dbo.strSplit(@bettype,',')

DECLARE @tblOdds table (oddsid INT, bettype SMALLINT)
DECLARE @tblResultDetail table (resourceID INT)

DECLARE @tblbettypeBetteam TABLE (bettype SMALLINT, betteam NVARCHAR(10), oddsType TINYINT, hdp1 SMALLMONEY,hdp2 SMALLMONEY)

DECLARE @betteam NVARCHAR(10) ,@oddsid INT ,@eventdate date,@date int


IF @bettype is null
begin
	select 'plz input bettype'
	RETURN
end

		
		
IF isNULL(@matchid,0) <> 0
Begin
Select top 1 matchid from match (nolock) Where matchid = @matchid and sporttype in (190,191,192)
	If @@rowcount = 0
	Begin
	Select 'Invalid match, pls change matchid'
	Return
	End

End
	
	
		
INSERT INTO @tblbettypeBetteam (bettype, betteam, oddsType,hdp1,hdp2)
SELECT 2701,s.val,4,0,0 --Multiple
FROM dbo.strSplit ('1^x^2','^') s
UNION ALL
SELECT 2702,s.val,4,0,0 --Multiple
FROM dbo.strSplit ('1^x^2','^') s
UNION ALL
SELECT 2703,s.val,4,@hdp1,0 --Multiple
FROM dbo.strSplit ('O^U','^') s
UNION ALL
SELECT 2704,s.val,4,@hdp1,0 --Multiple
FROM dbo.strSplit ('O^U','^') s
UNION ALL
SELECT 2705,s.val,4,@hdp1,@hdp2 --Multiple
FROM dbo.strSplit ('H^A','^') s
UNION ALL
SELECT 2706,s.val,4,@hdp1,@hdp2 --Multiple
FROM dbo.strSplit ('H^A','^') s
UNION ALL
SELECT 2707,s.val,4,0,0 --Multiple
FROM dbo.strSplit ('0:0^1:0^0:1^1:1^2:0^0:2^2:1^1:2^3:0^0:3^3:1^1:3^2:2^3:2^2:3^3:3^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS^AOS','^') s

	
		
IF NOT exists (select TOP 1 1 from @tblbettypeBetteam where bettype IN (SELECT val FROM dbo.strSplit(@bettype,',')))
BEGIN
	select 'dont support bettype ' +@bettype 
	RETURN
END

IF isnull(@matchid,0) = 0
BEGIN
	SELECT TOP 1 @matchid = m.matchid, @eventdate = m.eventdate
	FROM match m WITH(NOLOCK)
	WHERE m.matchid = (	Select top 1 m.matchid from match m(nolock)
										LEFT Join bettrans b (nolock) On m.matchid = b.matchid
										Where m.sporttype = 1 and m.eventstatus = 'running'
										Group by m.matchid
										Having count(b.transid)  >=0
										Order by count(b.transid), m.matchid)
										
END
	

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
		SELECT @matchid, @tmp_bettype, 'running',0,0,0,8,1,0,20
		
		SET @oddsid = SCOPE_IDENTITY()
	END
	
	INSERT INTO @tblOdds(oddsid, bettype)
	SELECT @oddsid, @tmp_bettype
	
	SET @seq = @seq + 1
END


-----------------------------Process for bettrans

DECLARE @refno bigint, @recommend int,@mrecommend int,@srecommend int,  @currency tinyint, @username nvarchar(50), @currencyName nvarchar(50)
, @stake money = 1000, @apos smallmoney = 0.4,@mpos smallmoney = 0.3, @spos smallmoney = 0.2 ,@tpos smallmoney = 0.9
, @playerdis decimal(9,8) = 0.02 ,@dis decimal(9,8) = 0.025, @adis decimal(9,8) = 0.03, @sdis decimal(9,8) = 0.04

SELECT top 1 @eventdate = eventdate from Match (nolock) where matchid = @matchid
Select @date =  DATEPART( DAY, @eventdate)

If isnull(@custid,0) = 0 
BEGIN
Select @custid = (SELECT top 1 custid from Custdb.dbo.custInfo (nolock) Where roleid = 1 and currency <> 20 and custid > 100000 and srecommend > 1000)
END

SELECT top 1 @refno = 100000000000, @recommend = c.recommend, @mrecommend = c.mrecommend,@currency = c.currency, @srecommend = c.srecommend, @username = c.Username, @currencyName = e.currency
FROM CustDB.dbo.custInfo c (nolock)
Inner Join exchange e (nolock) ON c.currency = e.exchangeid
Where custid  = @custid

If @@rowcount = 0 
BEGIN
Print 'The custid does not exist, pls choose another one'

Return
END

DECLARE @tblResult table ( matchid int, transid bigint, bettype smallint, betteam nvarchar(10),hdp1 smallmoney,hdp2 smallmoney)

INSERT INTO bettrans (custid, transdate, oddsid,bettype, hdp1, hdp2,betteam,betid, odds, stake, status, winlost, awinlost, mwinlost, playercomm, comm, acomm, apositiontaking, mpositiontaking, tpositiontaking, playerdiscount, discount, adiscount, refno, winlostdate, matchid, recommend, mrecommend,  actual_stake, currency, sdiscount, scomm, spositiontaking, swinlost, srecommend,Username, CurrencyName, oddstype, statusID,comstatus,oddsspread,betdaqid,modds,transdesc)
OUTPUT INSERTED.matchid, INSERTED.transid, INSERTED.bettype, INSERTED.betteam, INSERTED.hdp1, INSERTED.hdp2
INTO @tblResult
SELECT	@custid,GETDATE(),o.oddsid,tb.bettype, tb.hdp1, tb.hdp2,tb.betteam, 0 as betid, @odds, @stake, 'running', 0,0,0,0,0,0, @apos, @mpos, @tpos, @playerdis, @dis,@adis, @refno, @eventdate,@matchid, @recommend, @mrecommend,  case when @odds< 0 then abs(@stake*@odds) else @stake end as actual_stake, @currency, @sdis, 0, @spos, 0, @srecommend,@Username, @CurrencyName,tb.oddsType, 0,@comstatus,0,-1 as betdaqid, 0 as modds, 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666"'
FROM	@tblbettypeBetteam tb
INNER JOIN @tblbettype t ON tb.bettype = t.bettype
INNER JOIN @tblOdds o ON o.bettype = t.bettype                                                                 
  
  
  --Update for bettype 2707
IF EXISTS (Select 1 FRom @tblbettype Where bettype = 2707)
BEGIN 
DECLARE  @tmpAOS TABLE (seq INT IDENTITY(1,1),transid BIGINT PRIMARY KEY)

INSERT INTO @tmpAOS (transid)
Select transid from bettrans (nolock)
Where matchid = @matchid and bettype = 2707 and betteam = 'AOS'
Order by transid


Update bettrans
Set transdesc =   Case
						When ta.seq = 1 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="0:0,1:0,0:1,1:1,2:0,0:2,2:1,1:2,3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 2 then  'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="1:0,0:1,1:1,2:0,0:2,2:1,1:2,3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 3 then  'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="0:1,1:1,2:0,0:2,2:1,1:2,3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 4 then  'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="1:1,2:0,0:2,2:1,1:2,3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 5 then  'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="2:0,0:2,2:1,1:2,3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 6 then  'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="0:2,2:1,1:2,3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 7 then  'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="2:1,1:2,3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 8 then  'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="1:2,3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 9 then  'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 10 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="0:3,3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 11 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="3:1,1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 12 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="1:3,2:2,3:2,2:3,3:3"'
						when ta.seq = 13 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="2:2,3:2,2:3,3:3"'
						when ta.seq = 14 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="3:2,2:3,3:3"'
						when ta.seq = 15 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="2:3,3:3"'
						when ta.seq = 16 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="3:3"'
						when ta.seq = 17 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s=""'
						when ta.seq = 18 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666"'
						when ta.seq >=19 then 'm="Match Day '+convert(nvarchar(2),@date)+', season 6666" s="0:0,1:0,0:1,1:1,2:0,0:2,2:1,1:2,3:0,0:3,3:1,1:3,2:2,3:2,2:3,3:3"' End
From bettrans b WITH (ROWLOCK, UPDLOCK)
Inner Join @tmpAOS ta ON b.transid = ta.transid 
Where matchid = @matchid and b.bettype = 2707 and b.betteam = 'AOS'
 
END                                  
---View data
SELECT top 1000 * from @tblResult
