DECLARE
	@custid				INT = 1009827
	,@matchIdInfo		VARCHAR(1000)  = '70030595,70030595,70030595,70030595,70030595,70030595'   -- Match ID list
	,@betTypeInfo		VARCHAR(1000)  = '2701,2702,2703,2704,2705,2706'  -- bettype list
	,@betTeamInfo		VARCHAR(1000)  = 'x,1,o,u,h,a'  -- Betted team list
	,@oddValueInfo		VARCHAR(1000) ='1.95,1.85,1.84,1.9,1.9,1.9'   -- Odd's value list
	,@stake money = 100
	,@hdp1 smallmoney = 0
	,@hdp2 smallmoney = 0
	
	,@apos	 SMALLMONEY = 0.4
	,@mpos SMALLMONEY = 0.3
	,@spos	 SMALLMONEY = 0.2
	,@playerdis DECIMAL(9,8) = 0.05
	,@dis DECIMAL(9,8) = 0.03
	,@adis	DECIMAL(9,8) = 0.02
	,@sdis	DECIMAL(9,8) = 0.01
	,@comstatus nvarchar(20) =1

	
Declare @tbldata table (matchid INT, bettype SMALLINT,betteam nvarchar(10), odds money,hdp1 smallmoney, hdp2 smallmoney)
INSERT INTO @tbldata (matchid, bettype,betteam,odds, hdp1,hdp2)	   
SELECT m.val as matchid, s.val as bettype,x.val as betteam,o.val as odds, case when s.val in (2703,2704,2705,2706) then @hdp1 else 0 end , case when s.val in (2705,2706) then @hdp2 else 0 end
FROM dbo.strSplit(@matchIdInfo,',') m
INNER JOIN dbo.strSplit (@betTypeInfo,',') s ON m.rank = s.rank
INNER JOIN dbo.strSplit(@betTeamInfo,',') x On s.rank = x.rank 
INNER JOIN dbo.strSplit(@oddValueInfo,',') o On s.rank = o.rank   

INSERT INTO odds(matchid, bettype, oddsstatus, sporttype,liveindicator)
SELECT TOP 100 td.matchid,td.bettype,'running',1,0
FROM	@tbldata td
LEFT JOIN odds o ON o.matchid = td.matchid and o.bettype = td.bettype
WHERE	o.oddsid IS NULL 

DECLARE @execRefno int , @transCount int = 10
UPDATE dbo.ref WITH (ROWLOCK)
SET @execRefno = refno = refno + @transCount
WHERE  refid='refno'

---Custid
DECLARE  @recommend int,@mrecommend int,@srecommend int,  @currency tinyint, @username nvarchar(50), @currencyName nvarchar(50)
IF ISNULL(@custid,0) = 0 
BEGIN
Select @custid = (SELECT top 1 custid from Custdb.dbo.custInfo (nolock) Where roleid = 1 and currency <> 20 and custid > 100000 and srecommend > 10000000)
END

SELECT TOP 1  @recommend = c.recommend, @mrecommend = c.mrecommend, @srecommend = c.srecommend, @username = c.Username, @currency = c.currency,@currencyName = e.currency
FROM CustDB.dbo.custInfo c (nolock)
Inner Join exchange e (nolock) ON c.currency = e.exchangeid
Where custid  = @custid

If @@rowcount = 0 
BEGIN
Print 'The custid does not exist, pls choose another one'
Return
END

Declare @bOdds money
SELECT	@bOdds = CAST(EXP(SUM(CAST(LOG(val)AS DECIMAL(38, 20)))) as money)
FROM	dbo.strSplit(@oddValueInfo,',')
	
DECLARE @tblResult table (matchid int, transid bigint, refno bigint, bettype int, betteam nvarchar(10),betcheck nvarchar(10), hdp1 smallmoney, hdp2 smallmoney)
DECLARE @cntMatch tinyint        

INSERT INTO bettransm (refno,matchid, custid,transdate,oddsid,bettype,betteam, hdp1,hdp2,odds,stake,statusid, status,winlost,awinlost,mwinlost,swinlost,statuswinlost, betfrom,winlostdate,matchdate, creator,betcheck, apositiontaking,mpositiontaking,spositiontaking,tpositiontaking,playercomm,comm,acomm,scomm,playerdiscount,discount,adiscount,sdiscount,comstatus )
OUTPUT INSERTED.matchid, INSERTED.transid, INSERTED.refno, INSERTED.bettype, INSERTED.betteam,INSERTED.betcheck, INSERTED.hdp1, INSERTED.hdp2
INTO @tblResult

SELECT	@execRefno,td.matchid, @custid, GETDATE(),o.oddsid,td.bettype,td.betteam, td.hdp1, td.hdp2, td.odds, @stake, 0 as statusid, 'running', 0 as winlost,0 as awinlost,0 as mwinlost,0 as swinlost,0 as statuswinlost, 'i' as betfrom, NULL as winlostdate,m.eventdate as matchdate, @custid as creator, 0 as betcheck, @apos, @mpos, @spos, sum(@apos+@mpos+@spos) as tpositiontaking, 0 as playercomm, 0 as comm, 0 as acomm, 0 as scomm, @playerdis, @dis, @adis,@sdis,@execRefno as comstatus
FROM	@tbldata td
INNER JOIN dbo.odds o ON td.matchid = o.matchid and td.bettype = o.bettype
INNER JOIN dbo.match m ON td.matchid = m.matchid 
Where o.liveindicator =0     
Group by td.matchid,td.bettype,td.betteam,td.odds,td.hdp1,td.hdp2,o.oddsid,m.eventdate    

Select @cntMatch = @@rowcount         

INSERT INTO bettrans (matchid, refno,custid,username, transdate,oddsid,bettype,betteam, hdp1,hdp2,odds,stake,actual_stake, statusid, status,winlost,awinlost,mwinlost,swinlost,statuswinlost, betfrom,winlostdate, creator,betcheck, apositiontaking,mpositiontaking,spositiontaking,tpositiontaking,playercomm,comm,acomm,scomm,playerdiscount,discount,adiscount,sdiscount,recommend,mrecommend,srecommend, currency,CurrencyName,comstatus )                                                     
OUTPUT INSERTED.matchid, INSERTED.transid,INSERTED.refno, INSERTED.bettype,INSERTED.betteam,INSERTED.betcheck, INSERTED.hdp1,INSERTED.hdp2
INTO @tblResult
SELECT 2799 as matchid, @execRefno, @custid,@username, getdate() as transdate, 1 as oddsid, 2799 as bettype, 'a' as betteam, 0 as hdp1, 0 as hdp2, @bOdds, @stake as stake,@stake as actual_stake, 0 as statusid, 'running' as status, 0 as winlost, 0 as awinlost, 0 as mwinlost, 0 as swinlost, 0 as statuswinlost, 'i' as betfrom, max(m.eventdate) as winlostdate, @custid as creator, 'm'+cast (@cntMatch as nvarchar(10)) as betcheck, @apos, @mpos,@spos,sum(@apos+@mpos+@spos) as tpositiontaking, 0 as playercomm, 0 as comm, 0 as acomm, 0 as scomm, @playerdis,@dis,@adis, @sdis,@recommend,@mrecommend,@srecommend, @currency,@currencyName,@comstatus
FROM @tbldata td
Inner Join Match m (nolock) ON td.matchid = m.matchid

Select top 50 * from @tblResult



