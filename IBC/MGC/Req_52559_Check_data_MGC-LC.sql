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
select @ToDate = '2016-02-19' --replace ToDate...
SELECT @aGenericGameSetting = 0.875 --PT of Generic Game (by request)
SELECT @aBrandedGameSetting = 0.8 --PT of Branded Game (by request)
SELECT @mGenericGameSetting = 0 --PT of Generic Game (by request)
SELECT @mBrandedGameSetting = 0 --PT of Branded Game (by request)
SELECT @sGenericGameSetting = 0 --PT of Generic Game (by request)
SELECT @sBrandedGameSetting = 0 --PT of Branded Game (by request)

declare @wrongdata table (custid int, username varchar(50), transid bigint
	, stake money, winlost money, actual_stake money, playercomm money, playerdiscount decimal,
	awinlost money, apositiontaking money, comm money, discount decimal, winlostdate smalldatetime, bettype smallint, status varchar(10)
	,issue varchar(200) )
	
--Case 1: check data between translog & bettrans
SELECT top 100 * FROM bettrans bt with (nolock)
	inner JOIN Translog tl with (nolock) on bt.refno=tl.translogid
WHERE bt.winlostdate BETWEEN @FromDate AND @ToDate
	AND matchid IN (203)--MGC LC
	AND bettype IN (2001,2002,2003,2004,2005,2006,2007)
	AND bt.statusID NOT IN (0,1)
	AND (
			bt.stake <> tl.stake
			OR bt.actual_stake <> tl.actual_stake
			OR bt.status <> tl.status
			OR bt.playerdiscount <> tl.playerdiscount
			OR bt.discount <> tl.discount
			OR bt.adiscount <> tl.adiscount
			OR bt.sdiscount <> tl.sdiscount
			OR bt.apositiontaking <> tl.apositiontaking
			OR bt.mpositiontaking <> tl.mpositiontaking
			OR bt.spositiontaking <> tl.spositiontaking
			OR bt.tpositiontaking <> tl.tpositiontaking
			OR bt.matchid <> tl.productID
			OR bt.bettype <> tl.gameID
			OR bt.statusID <> tl.statusID
		)

--Case 2,3,4
insert into @wrongdata (custid , username , transid 
	, stake , winlost , actual_stake , playercomm , playerdiscount , awinlost , apositiontaking , comm ,
	discount , winlostdate , bettype, status , issue )
select top 100 custid,username,transid,stake,winlost,actual_stake,playercomm,playerdiscount,awinlost,apositiontaking,comm,discount,winlostdate,bettype,status,
		case when winlost>actual_stake then 'Issue: Status should be WON'
		when winlost=actual_stake then 'Issue: Status should be DRAW'
		when winlost<actual_stake then 'Issue: Status should be LOSE' 
		end as 'Comment'
from dbo.bettrans with(nolock)
where
	matchid in (203)--MGC LC
	AND bettype IN (2001,2002,2003,2004,2005,2006,2007)
	AND winlostdate BETWEEN @FromDate AND @ToDate
	AND statusID NOT IN (0,1)
	AND (
			(winlost>actual_stake AND status<>'WON')--Case : Check data in Bettrans: if winlost - actual_stake > 0 -> status=WON
			OR
			(winlost=actual_stake AND status<>'DRAW')--Case : Check data in Bettrans: if winlost - actual_stake = 0 -> status=DRAW
			OR
			(winlost<actual_stake AND status<>'LOSE')--Case : Check data in Bettrans: if winlost - actual_stake < 0 -> status=LOSE
			
	    )

--Case 5,6,7 
insert into @wrongdata (custid , username , transid 
	, stake , winlost , actual_stake , playercomm , playerdiscount , awinlost , apositiontaking , comm ,
	discount , winlostdate , bettype, status , issue )
select top 100 custid,username,transid,stake,winlost,actual_stake,playercomm,playerdiscount,awinlost,apositiontaking,comm,discount,winlostdate, bettype, status,
		case when -(winlost-actual_stake)*apositiontaking<>awinlost then 'Issue: awinlost is calculated wrongly' 
			 when stake*playerdiscount<>playercomm then 'Issue: playercomm is wrong'
			 when bettype IN (2001,2002,2003,2004) AND apositiontaking<>@aGenericGameSetting then 'Issue: apositiontaking is wrong (generic game)'
			 when bettype IN (2005,2006,2007) AND apositiontaking<>@aBrandedGameSetting then 'Issue: apositiontaking is wrong (branded game)' 
			 when bettype IN (2001,2002,2003,2004) AND mpositiontaking<>@mGenericGameSetting then 'Issue: mpositiontaking is wrong (generic game)'
			 when bettype IN (2005,2006,2007) AND mpositiontaking<>@mBrandedGameSetting then 'Issue: mpositiontaking is wrong (branded game)' 
			 when bettype IN (2001,2002,2003,2004) AND spositiontaking<>@sGenericGameSetting then 'Issue: spositiontaking is wrong (generic game)'
			 when bettype IN (2005,2006,2007) AND spositiontaking<>@sBrandedGameSetting then 'Issue: spositiontaking is wrong (branded game)' 
			 when apositiontaking + mpositiontaking + spositiontaking <>tpositiontaking then 'Issue: tpositiontaking is wrong' 
		end as 'Comment'
from dbo.bettrans with(nolock)
where 
	matchid in (203)--MGC LC
	AND bettype IN (2001,2002,2003,2004,2005,2006,2007)
	AND winlostdate BETWEEN @FromDate AND @ToDate
	AND statusID NOT IN (0,1)
	AND (
			(-(winlost-actual_stake)*apositiontaking<>awinlost) --Case 5: Check data in Bettrans: awinlost,playercomm are calculated correctly
			OR
			(stake*playerdiscount<>playercomm) --Case 5b: check player wrong playercomm
			OR 
			(bettype IN (2001,2002,2003,2004) AND apositiontaking<>@aGenericGameSetting) --Case 6: detect apositiontaking is wrong when placing bet Generic Game
			OR
			(bettype IN (2005,2006,2007) AND apositiontaking<>@aBrandedGameSetting) --Case 6: detect apositiontaking is wrong when placing bet Branded Game
			OR 
			(bettype IN (2001,2002,2003,2004) AND mpositiontaking<>@mGenericGameSetting) --Case 6: detect mpositiontaking is wrong when placing bet Generic Game
			OR
			(bettype IN (2005,2006,2007) AND mpositiontaking<>@mBrandedGameSetting) --Case 6: detect mpositiontaking is wrong when placing bet Branded Game
			OR 
			(bettype IN (2001,2002,2003,2004) AND spositiontaking<>@sGenericGameSetting) --Case 6: detect spositiontaking is wrong when placing bet Generic Game
			OR
			(bettype IN (2005,2006,2007) AND spositiontaking<>@sBrandedGameSetting) --Case 6: detect spositiontaking is wrong when placing bet Branded Game
			OR
			(apositiontaking + mpositiontaking + spositiontaking <>tpositiontaking) --Case 7: detect apositiontaking + mpositiontaking + spositiontaking <>tpositiontaking
	    )

select *
from @wrongdata

go