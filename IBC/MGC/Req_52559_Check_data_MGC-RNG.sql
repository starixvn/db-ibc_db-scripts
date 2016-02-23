use bodb02
go

/*
	check data between bettrans & bettransrng for MGC RnG
	run on db06 or db052
*/

declare @CustIds table(custid int)
declare @FromDate smalldatetime, @ToDate smalldatetime
declare @aGenericGameSetting money, @aBrandedGameSetting money
declare @mGenericGameSetting money, @mBrandedGameSetting money
declare @sGenericGameSetting money, @sBrandedGameSetting money

select @FromDate = '2016-02-17' --replace FromDate...
select @ToDate = '2016-02-17' --replace ToDate...
SELECT @aGenericGameSetting = 0.875 --PT of Generic Game (by request) - bettype: 2009
SELECT @aBrandedGameSetting = 0.8 --PT of Branded Game (by request) - bettype: 2008
SELECT @mGenericGameSetting = 0 --PT of Generic Game (by request) - bettype: 2009
SELECT @mBrandedGameSetting = 0 --PT of Branded Game (by request) - bettype: 2008
SELECT @sGenericGameSetting = 0 --PT of Generic Game (by request) - bettype: 2009
SELECT @sBrandedGameSetting = 0 --PT of Branded Game (by request) - bettype: 2008

--insert into @CustIds(custid)
--select custid from dbo.custInfo with(nolock) where username in ('12BETUUS02101') --replace username ...., 'ACGUUS3838030'

declare @sourcedata table (custid int, username varchar(50), matchid int
	, bettype smallint, winlostdate smalldatetime, status varchar(10)
	, turnover money, winlost money, awinlost money, mwinlost money, swinlost money
	, scomm money, acomm money, comm money, playercomm money)

declare @targetdata table (custid int, username varchar(50), matchid int
	, bettype smallint, winlostdate smalldatetime, status varchar(10)
	, turnover money, winlost money, awinlost money, mwinlost money, swinlost money
	, scomm money, acomm money, comm money, playercomm money)

declare @wrongdata table (custid int, username varchar(50), transid bigint
	, stake money, winlost money, actual_stake money, playercomm money, playerdiscount decimal,
	awinlost money, apositiontaking money, comm money, discount decimal, winlostdate smalldatetime, gameid smallint, status varchar(10)
	,issue varchar(200) )

--Case 1: Check sum all detail tickets in BettransRNG & sum ticket in Bettrans
insert into @sourcedata(custid, username, matchid, bettype, winlostdate, status
	, turnover, winlost, awinlost, swinlost, mwinlost, scomm, acomm, comm, playercomm)
select custid, username, productid, gameID, winlostdate
	, case when sum(winlost-actual_stake) > 0 then 'WON'
		when sum(winlost-actual_stake) < 0 then 'LOSE'
		else 'DRAW' end as status
	, sum(stake) as stake, sum(winlost-actual_stake) as winlost, sum(awinlost) as awinlost, sum(swinlost) as swinlost, sum(mwinlost) as mwinlost
	, sum(scomm) as scomm, sum(acomm) as acomm, sum(comm) as comm, sum(playercomm) as playercomm
from dbo.bettransRnG with(nolock)
where --custid in (select custid from @CustIds) and
	productID in (205)--MGC RNG
	and winlostdate BETWEEN @FromDate AND @ToDate
	and issum = 1
group by custid, username, productid, gameid, winlostdate

insert into @targetdata(custid, username, matchid, bettype, winlostdate, status
	, turnover, winlost, awinlost, swinlost, mwinlost, scomm, acomm, comm, playercomm)
select custid, username, matchid, bettype, winlostdate, status
	, sum(stake) as stake, sum(winlost-actual_stake) as winlost
	, sum(awinlost) as awinlost, sum(swinlost) as swinlost, sum(mwinlost) as mwinlost
	, sum(scomm) as scomm, sum(acomm) as acomm, sum(comm) as comm, sum(playercomm) as playercomm
from dbo.bettrans with(nolock)
where --custid in (select custid from @CustIds) and
	matchid in (205)--MGC RNG
	and winlostdate BETWEEN @FromDate AND @ToDate
	and statusid not in (0,1)
group by custid, username, matchid, bettype, winlostdate, status


select s.*, t.*
from @sourcedata s
	inner join @targetdata t on s.custid = t.custid and s.bettype = t.bettype and s.winlostdate = t.winlostdate
where s.turnover <> t.turnover 
	or s.winlost <> t.winlost 
	or s.swinlost <> t.swinlost 
	or s.mwinlost <> t.mwinlost 
	or s.awinlost <> t.awinlost
	or s.scomm <> t.scomm 
	or s.acomm <> t.acomm 
	or s.comm <> t.comm 
	or s.playercomm <> t.playercomm
	or s.status <> t.status
	
--------------------------

--Case 2,3,4
insert into @wrongdata (custid , username , transid 
	, stake , winlost , actual_stake , playercomm , playerdiscount , awinlost , apositiontaking , comm ,
	discount , winlostdate ,gameid, status , issue )
select top 100 custid,username,transid,stake,winlost,actual_stake,playercomm,playerdiscount,awinlost,apositiontaking,comm,discount,winlostdate,gameid,status,
		case when winlost>actual_stake then 'Issue: Status should be WON'
		when winlost=actual_stake then 'Issue: Status should be DRAW'
		when winlost<actual_stake then 'Issue: Status should be LOSE' 
		end as 'Comment'
from dbo.bettransRnG with(nolock)
where --custid in (select custid from @CustIds) AND
	productID in (205)--MGC RNG
	AND winlostdate BETWEEN @FromDate AND @ToDate
	AND statusID NOT IN (0,1)
	AND (
			(winlost>actual_stake AND status<>'WON')--Case 2: Check data in BettransRNG - if winlost - actual_stake > 0 -> status=WON
			OR
			(winlost=actual_stake AND status<>'DRAW')--Case 3: Check data in BettransRNG - if winlost - actual_stake = 0 -> status=DRAW
			OR
			(winlost<actual_stake AND status<>'LOSE')--Case 4: Check data in BettransRNG - if winlost - actual_stake < 0 -> status=LOSE
			
	    )

--Case 5,6,7 
insert into @wrongdata (custid , username , transid 
	, stake , winlost , actual_stake , playercomm , playerdiscount , awinlost , apositiontaking , comm ,
	discount , winlostdate ,gameid, status , issue )
select top 100 custid,username,transid,stake,winlost,actual_stake,playercomm,playerdiscount,awinlost,apositiontaking,comm,discount,winlostdate,gameid,status,
		case when -(winlost-actual_stake)*apositiontaking<>awinlost then 'Issue: awinlost is calculated wrongly' 
			 when stake*playerdiscount<>playercomm then 'Issue: playercomm is wrong'
			 when gameID = 2009 AND apositiontaking<>@aGenericGameSetting then 'Issue: apositiontaking is wrong (generic game)'
			 when gameID = 2008 AND apositiontaking<>@aBrandedGameSetting then 'Issue: apositiontaking is wrong (branded game)' 
			 when gameID = 2009 AND mpositiontaking<>@mGenericGameSetting then 'Issue: mpositiontaking is wrong (generic game)'
			 when gameID = 2008 AND mpositiontaking<>@mBrandedGameSetting then 'Issue: mpositiontaking is wrong (branded game)' 
			 when gameID = 2009 AND spositiontaking<>@sGenericGameSetting then 'Issue: spositiontaking is wrong (generic game)'
			 when gameID = 2008 AND spositiontaking<>@sBrandedGameSetting then 'Issue: spositiontaking is wrong (branded game)' 
			 when apositiontaking + mpositiontaking + spositiontaking <>tpositiontaking then 'Issue: tpositiontaking is wrong' 
		end as 'Comment'
from dbo.bettransRnG with(nolock)
where --custid in (select custid from @CustIds) AND
	productID in (205)--MGC RNG
	AND winlostdate BETWEEN @FromDate AND @ToDate
	AND statusID NOT IN (0,1)
	AND (
			(-(winlost-actual_stake)*apositiontaking<>awinlost) --Case 5: Check data in BettransRNG - awinlost,playercomm are calculated correctly
			OR
			(stake*playerdiscount<>playercomm) --Case 5b: playercomm is wrong
			OR 
			(gameID = 2009 AND apositiontaking<>@aGenericGameSetting) --Case 6: detect apositiontaking is wrong when placing bet Generic Game
			OR
			(gameID = 2008 AND apositiontaking<>@aBrandedGameSetting) --Case 6: detect apositiontaking is wrong when placing bet Branded Game
			OR 
			(gameID = 2009 AND mpositiontaking<>@mGenericGameSetting) --Case 6: detect mpositiontaking is wrong when placing bet Generic Game
			OR
			(gameID = 2008 AND mpositiontaking<>@mBrandedGameSetting) --Case 6: detect mpositiontaking is wrong when placing bet Branded Game
			OR 
			(gameID = 2009 AND spositiontaking<>@sGenericGameSetting) --Case 6: detect spositiontaking is wrong when placing bet Generic Game
			OR
			(gameID = 2008 AND spositiontaking<>@sBrandedGameSetting) --Case 6: detect spositiontaking is wrong when placing bet Branded Game
			OR
			(apositiontaking + mpositiontaking + spositiontaking <>tpositiontaking) --Case 7: detect apositiontaking + mpositiontaking + spositiontaking <>tpositiontaking
	    )

select *
from @wrongdata

--------------------------

go