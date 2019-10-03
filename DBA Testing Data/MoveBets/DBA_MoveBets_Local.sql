use bodb02
go

alter procedure dbo.DBA_MoveBets_Local
	@matchid				int
	,@productid				int = 0 -- for product with none match
	,@eventtable			varchar(100) = 'match' -- match, outright, VSOutright, none
	,@winlostdate			smalldatetime -- input date from bettrans14: exec dbage.bodb02.dbo.Age_SelBalanceUpDay
	,@mainParlay_transids	varchar(max) = ''
as

/*
	Created: 20190924@Percy
	DB: DBTXN.bodb02
	Task: MoveBets on local by matchid - for testing Recover Bets

	Remark: data on bettrans/bettransm only
*/

begin
	set nocount on

	if @@servername not in ('db206', 'db230')
	begin
		raiserror ('must run on dbtrans local', 16, 1)
		return
	end

	declare @errmsg varchar(1000) = ''

	-- check winlostdate
	declare @MBBU table (BalanceUpDay smalldatetime, MoveBetsDay smalldatetime)
	insert into @MBBU (BalanceUpDay, MoveBetsDay)
	exec dbage.bodb02.dbo.Age_SelBalanceUpDay

	if not exists (select 1 from @MBBU where @winlostdate between BalanceUpDay and MoveBetsDay)
	begin
		raiserror ('Wrong input winlostdate, please select winlostdate on bettrans14 range: exec dbage.bodb02.dbo.Age_SelBalanceUpDay', 16, 1)
		return
	end
	-- end check winlostdate

	-- event info
	if @eventtable not in ('match', 'outright', 'VSOutright', 'none')
	begin
		raiserror ('Wrong input eventtable, it should be ''match'' or ''outright'' or ''VSOutright'' or ''none''', 16, 1)
		return
	end

	declare @eventtype tinyint
	select  @eventtype = case @eventtable when 'none' then 0 when 'match' then 1 when 'outright' then 2 when 'VSOutright' then 3 end

	declare @sporttype smallint
	select  @sporttype = sporttype
	from (
		select sporttype from dbo.match with (nolock) where matchid = @matchid and @eventtype = 1
		union all
		select l.sporttype from dbo.outright o with (nolock) inner join dbo.league l with (nolock) on o.leagueid = l.leagueid
		where o.orid = @matchid and @eventtype = 2
		union all
		select sporttype from dbo.VSRaceInfo with (nolock) where eventid = @matchid and @eventtype = 3
		union all
		select 0 as sporttype where @eventtype = 0
	) as m

	if @sporttype is null
	begin
		raiserror ('Wrong input matchid', 16, 1)
		return
	end
	-- end event info

	-- data info
	declare @bettype table (bettype smallint, eventtype tinyint)
	insert into @bettype (bettype, eventtype)
	select distinct bettype, eventtype
	from dbo.SportBettypeMatrix with (nolock)
	where (@sporttype = 0 or sporttype = @sporttype)
		and eventtype = @eventtype

	declare @bettrans table (transid bigint, custid int, winlostdate smalldatetime, errmsg varchar(1000))
	
	if @eventtype = 0
		insert into @bettrans (transid, custid, winlostdate, errmsg)
		select
			b.transid
			,b.custid
			,b.winlostdate
			,case	when bt.bettype is null then 'invalid bettype of this match'
					when c.custid is null then 'invalid custid'
					when b.statusid in (0, 1) then 'still have running tickets'
					when b.recommend <> c.recommend or b.mrecommend <> c.mrecommend or b.srecommend <> c.srecommend then 'invalid SMA'
					when b.currency <> c.currency then 'invalid currency'
					else '' end
		from dbo.bettrans b with (nolock)
			left join @bettype bt on b.bettype = bt.bettype
			left join custdb.dbo.custinfo c with (nolock) on b.custid = c.custid and c.roleid = 1
		where matchid in (select sporttype from dbo.CS_SportBettypeMatrix with (nolock) where ProductID = @productid)
	else
		insert into @bettrans (transid, custid, winlostdate, errmsg)
		select
			b.transid
			,b.custid
			,b.winlostdate
			,case	when bt.bettype is null then 'invalid bettype of this match'
					when c.custid is null then 'invalid custid'
					when b.statusid in (0, 1) then 'still have running tickets'
					when b.recommend <> c.recommend or b.mrecommend <> c.mrecommend or b.srecommend <> c.srecommend then 'invalid SMA'
					when b.currency <> c.currency then 'invalid currency'
					else '' end
		from dbo.bettrans b with (nolock)
			left join @bettype bt on b.bettype = bt.bettype
			left join custdb.dbo.custinfo c with (nolock) on b.custid = c.custid and c.roleid = 1
		where matchid = @matchid

	if @@rowcount = 0
	begin
		raiserror ('This match/product does not ticket', 16, 1)
		return
	end

	if exists (select 1 from @bettrans where errmsg <> '')
	begin
		select @errmsg = @errmsg + 'transid: ' + convert(varchar(100), transid) + ' - ' +  errmsg + char(10) + char(13) from @bettrans where errmsg <> ''
		raiserror (@errmsg, 16, 1)
		return
	end

	if exists (select 1 from @bettrans having count(distinct winlostdate) > 1)
	begin
		raiserror ('This match have some tickets with diff winlostdate', 16, 1)
		return
	end

	declare @bettransm table (transid bigint, refno bigint, custid int, winlostdate smalldatetime, errmsg varchar(1000))

	if @eventtype = 1
	begin
		insert into @bettransm (transid, refno, custid, winlostdate, errmsg)
		select
			b.transid
			,b.refno
			,b.custid
			,b.winlostdate
			,case	when bt.bettype is null then 'invalid bettype of this match'
					when c.custid is null then 'invalid custid'
					when b.statusid in (0, 1) then 'still have running tickets'
					else '' end
		from dbo.bettransm b with (nolock)
			left join @bettype bt on b.bettype = bt.bettype
			left join custdb.dbo.custinfo c with (nolock) on b.custid = c.custid and c.roleid = 1
		where matchid = @matchid

		if exists (select 1 from @bettransm where errmsg <> '')
		begin
			select @errmsg = 'bettransm <==> '
			select @errmsg = @errmsg + 'transid: ' + convert(varchar(100), transid) + ' - ' +  errmsg + char(10) + char(13) from @bettrans where errmsg <> ''
			raiserror (@errmsg, 16, 1)
			return
		end

		if exists (select 1 from @bettransm having count(distinct winlostdate) > 1)
		begin
			raiserror ('bettransm <==> This match have some tickets with diff winlostdate', 16, 1)
			return
		end
	end

	declare @tmpParlay table (transid bigint, custid int, winlostdate smalldatetime, errmsg varchar(1000))
	
	if isnull(@mainParlay_transids , '') <> ''
	begin
		insert into @tmpParlay (transid, custid, winlostdate, errmsg)
		select b.transid, b.custid, b.winlostdate
			,case	when b.bettype is null then 'invalid main ticket'
					when b.bettype <> 29 then 'wrong bettype (29)'
					when b.matchid <> 29 then 'wrong matchid (29)'
					when b.statusid in (0, 1) then 'running ticket'
					when b.bmtransid is null then 'no sub ticket on this match'
					when b.c_custid is null then 'invalid custid'
					when b.recommend <> b.c_recommend or b.mrecommend <> b.c_mrecommend or b.srecommend <> b.c_srecommend then 'invalid SMA'
					when b.currency <> b.c_currency then 'invalid currency'
					else '' end
		from dbo.strSplit(@mainParlay_transids, ',') f
			outer apply (
				select b.transid, b.bettype, b.winlostdate, b.matchid, b.statusid, bm.transid as bmtransid
						,b.custid, b.recommend, b.mrecommend, b.srecommend, b.currency
						,c.custid as c_custid, c.recommend as c_recommend, c.mrecommend as c_mrecommend, c.srecommend as c_srecommend, c.currency as c_currency
				from dbo.bettrans b with (nolock)
					left join @bettransm bm on b.refno = bm.refno
					left join custdb.dbo.custinfo c with (nolock) on b.custid = c.custid and c.roleid = 1
				 where b.transid = f.val
			) b
		
		if exists (select 1 from @tmpParlay where errmsg <> '')
		begin
			select @errmsg = 'main parlay transids <==> '
			select @errmsg = @errmsg + 'transid: ' + convert(varchar(100), transid) + ' - ' +  errmsg + char(10) + char(13) from @tmpParlay where errmsg <> ''
			raiserror (@errmsg, 16, 1)
			return
		end

		insert into @bettrans (transid, custid, winlostdate)
		select transid, custid, winlostdate from @tmpParlay
	end

	if exists (select 1 from @bettrans having count(1) > 2000)
	begin
		raiserror ('bettrans <==> over 2k tickets, failed', 16, 1)
		return
	end

	if exists (select 1 from @bettransm having count(1) > 2000)
	begin
		raiserror ('bettransm <==> over 2k tickets, failed', 16, 1)
		return
	end
	-- end data info

	-- move data
	--begin transaction
	
	begin try
		if @eventtype = 1
		begin
			insert into dbo.match14 (
				matchid,leagueid,homeid,awayid,eventdate,eventstatus,betstatus,livehomescore,liveawayscore
				,finalhomescore,finalawayscore,creator,matchcode,kickofftime,closedtime,showtime
				,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,tstamp,homeid2,awayid2
				,DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,GoalRecord
				,settletime,globalshowtime,ParentID,IsAutoPayout,AutoSetting,ShowTimeDT,ChildMatchType
			)
			select
				matchid,leagueid,homeid,awayid,@winlostdate,eventstatus,betstatus,livehomescore,liveawayscore
				,finalhomescore,finalawayscore,creator,matchcode,dateadd(day, -datediff(day, @winlostdate, kickofftime), kickofftime),closedtime,showtime
				,hthomescore,htawayscore,ruben,multiple,yenbet,exrisk,sporttype,tstamp,homeid2,awayid2
				,DisplayMode,LeaguePatternID,HomeDisplayPatternID,AwayDisplayPatternID,IsNeutral,GoalRecord
				,settletime,globalshowtime,ParentID,IsAutoPayout,AutoSetting,ShowTimeDT,ChildMatchType
			from dbo.match with (nolock)
			where matchid = @matchid
		end
		else if @eventtype = 2
		begin
			insert into dbo.outright14 (
				orid,leagueid,teamid,eventdate,kickofftime,oddsstatus,odds,maxbet,gapodds,matchcode,groupmatch
				,status,creator,bal,risk,DisplayMode,PlaceOdds,Placing,IsFavor,IsSCR,ProgramID,FOddsStatus,SCRTime
				,LeaguePatternID,TeamPatternID,ProgramDate,IsDeadheat,StdDelBetCheck,autosuspend,EventId,Year
			)
			select
				orid,leagueid,teamid,@winlostdate,kickofftime,oddsstatus,odds,maxbet,gapodds,matchcode,groupmatch
				,status,creator,bal,risk,DisplayMode,PlaceOdds,Placing,IsFavor,IsSCR,ProgramID,FOddsStatus,SCRTime
				,LeaguePatternID,TeamPatternID,ProgramDate,IsDeadheat,StdDelBetCheck,autosuspend,EventId,Year
			from dbo.outright with (nolock)
			where orid = @matchid
		end
		else if @eventtype = 3
		begin
			insert into dbo.VSOutright14 (
				Orid,EventID,RacerNum,IsFavor,EventDate,KickoffTime,RacerID,HumanID,WinOdds,PlaceOdds,Lane,MaxBet
				,DisplayMode,Placing,Colours,Creator,ChangeTime,EventStatus
			)
			select
				Orid,EventID,RacerNum,IsFavor,@winlostdate,KickoffTime,RacerID,HumanID,WinOdds,PlaceOdds,Lane,MaxBet
				,DisplayMode,Placing,Colours,Creator,ChangeTime,EventStatus
			from dbo.VSOutright with (nolock)
			where EventID = @matchid
		end

		if @eventtype <> 0
			insert into dbo.odds14 (
				oddsid,matchid,bettype,switch,hdp1,hdp2,odds1a,odds2a,odds1b,odds2b,odds1c,odds2c,odds1e,odds2e,odds1f,odds2f
				,odds1d,odds2d,odds1hka,odds2hka,odds1hkb,odds2hkb,odds1hkc,odds2hkc,odds1hke,odds2hke,odds1hkf,odds2hkf
				,odds1hkd,odds2hkd,oddsspreada,oddsspreadb,oddsspreadd,oddsspreade,oddsspreadf,oddsspreadc,autobookie
				,gapodds1,gapodds2,maxstake1,maxstake2,minstake1,minstake2,diffbalance,maxodds,minodds,oddsstatus,liveindicator
				,changetime,risk,stakerange,newoffersetup,livehomescore,liveawayscore,creator,com1,comx,com2,cs00,cs01,cs10
				,cs11,cs02,cs12,cs22,cs21,cs20,cs30,cs31,cs32,cs33,cs23,cs13,cs03,cs43,cs42,cs41,cs40,cs44,cs14,cs24,cs04,cs34
				,cs50,cs05,comstatus,csstatus,commaxbet,csmaxbet,com1total,comxtotal,com2total,bal00,bal10,bal11,bal01,bal20,bal21
				,bal22,bal12,bal02,bal30,bal31,bal32,bal33,bal23,bal13,bal03,bal40,bal41,bal42,bal43,bal44,bal34,bal24,bal14,bal04
				,bal50,bal05,maxbet,ht,autoreject,allowance,autosuspend,multiple,stakerange2,risk2,allowance2,site2,site3,site4
				,hometotal,awaytotal,sporttype,tstamp,Resourceid,Resultkey,cs99,bal99
			)
			select
				oddsid,matchid,bettype,switch,hdp1,hdp2,odds1a,odds2a,odds1b,odds2b,odds1c,odds2c,odds1e,odds2e,odds1f,odds2f
				,odds1d,odds2d,odds1hka,odds2hka,odds1hkb,odds2hkb,odds1hkc,odds2hkc,odds1hke,odds2hke,odds1hkf,odds2hkf
				,odds1hkd,odds2hkd,oddsspreada,oddsspreadb,oddsspreadd,oddsspreade,oddsspreadf,oddsspreadc,autobookie
				,gapodds1,gapodds2,maxstake1,maxstake2,minstake1,minstake2,diffbalance,maxodds,minodds,oddsstatus,liveindicator
				,changetime,risk,stakerange,newoffersetup,livehomescore,liveawayscore,creator,com1,comx,com2,cs00,cs01,cs10
				,cs11,cs02,cs12,cs22,cs21,cs20,cs30,cs31,cs32,cs33,cs23,cs13,cs03,cs43,cs42,cs41,cs40,cs44,cs14,cs24,cs04,cs34
				,cs50,cs05,comstatus,csstatus,commaxbet,csmaxbet,com1total,comxtotal,com2total,bal00,bal10,bal11,bal01,bal20,bal21
				,bal22,bal12,bal02,bal30,bal31,bal32,bal33,bal23,bal13,bal03,bal40,bal41,bal42,bal43,bal44,bal34,bal24,bal14,bal04
				,bal50,bal05,maxbet,ht,autoreject,allowance,autosuspend,multiple,stakerange2,risk2,allowance2,site2,site3,site4
				,hometotal,awaytotal,sporttype,tstamp,Resourceid,Resultkey,cs99,bal99
			from dbo.odds with (nolock)
			where matchid = @matchid

		select b.*
		into #__bettrans
		from dbo.bettrans b with (nolock)
		where exists (select 1 from @bettrans bt where b.transid = bt.transid)

		insert into dbo.bettrans14 (
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
			,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore
			,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate
			,matchid,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,tstamp,actual_stake,currency,ip,transdesc
			,sdiscount,scomm,spositiontaking,swinlost,srecommend,virtualrate,Username,CurrencyName,oddstype,statusID,currency2
			,balance,SecAcceptFlag,transid2,ExtraInfo,WalletType,BonusID,RefCode,recommdate,SettlementTime
		)
		select
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
			,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore
			,liveindicator,betteam,creator,refno,comstatus,@winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate
			,matchid,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,tstamp,actual_stake,currency,ip,transdesc
			,sdiscount,scomm,spositiontaking,swinlost,srecommend,virtualrate,Username,CurrencyName,oddstype,statusID,currency2
			,balance,SecAcceptFlag,transid2,ExtraInfo,WalletType,BonusID,RefCode,recommdate,SettlementTime
		from #__bettrans b

		if exists (select 1 from @bettransm)
		begin
			insert into dbo.bettransm14 (
				transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,livehomescore,liveawayscore,liveindicator,betteam
				,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,apositiontaking,mpositiontaking,tpositiontaking
				,awinlost,mwinlost,playerdiscount,discount,adiscount,playercomm,comm,acomm,actualrate,matchid,matchdate,finalodds,isfinish,statuswinlost
				,ruben,bettype,spositiontaking,swinlost,sdiscount,scomm,statusID,recommdate,transdesc,SecAcceptFlag,SecAcceptTime,LiveBetAcceptTime
			)
			select
				transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,livehomescore,liveawayscore,liveindicator,betteam
				,creator,refno,comstatus,@winlostdate,betfrom,betcheck,checktime,oddsspread,apositiontaking,mpositiontaking,tpositiontaking
				,awinlost,mwinlost,playerdiscount,discount,adiscount,playercomm,comm,acomm,actualrate,matchid,@winlostdate as matchdate,finalodds,isfinish,statuswinlost
				,ruben,bettype,spositiontaking,swinlost,sdiscount,scomm,statusID,recommdate,transdesc,SecAcceptFlag,SecAcceptTime,LiveBetAcceptTime
			from dbo.bettransm with (nolock)
			where transid in (select transid from @bettransm)
		end

		-- sum 19999
		delete dbo.bettranssum with (rowlock, updlock) where winlostdate = @winlostdate and custid in (select custid from @bettrans)
		insert into dbo.bettranssum (
			custid,currency,recommend,mrecommend,srecommend,winlostdate,stake,actual_stake
			,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm
		)
		select
			custid, currency, recommend, mrecommend, srecommend,
			@winlostdate, sum(stake) stake, sum(actual_stake) actual_stake,
			sum(winlost) winlost, sum(awinlost) awinlost, sum(mwinlost) mwinlost, sum(swinlost) swinlost,
			sum(playercomm) playercomm, sum(comm) comm, sum(acomm) acomm, sum(scomm) scomm
		from #__bettrans b
		where statusid not in (101, 102)
		group by custid, currency, recommend, mrecommend, srecommend

		;with mb as (
			select
				1 as ruben, 'SUM' as [status], 142 as statusID, 0 as matchid, 19999 as bettype, refno, 8 as creator
				,winlostdate as transdate, b.custid, b.currency, b.recommend, b.mrecommend, b.srecommend
				,winlostdate, stake, winlost, awinlost, mwinlost, swinlost
				,actual_stake, playercomm, comm, acomm, scomm
				,0 as apositiontaking, 0 as mpositiontaking, 0 as spositiontaking, 0 as tpositiontaking
				,e.actualrate, e.actualrate as virtualrate, c.username, e.Currency as CurrencyName, '0' as comstatus, getdate() as checktime
			from 
				bettranssum b with (nolock)
				inner join custdb.dbo.exchange e with (nolock) on b.currency = e.exchangeid
				inner join custdb.dbo.custInfo c with (nolock) on b.custid = c.custid and c.roleid = 1
			where b.winlostdate = @winlostdate and b.custid in (select custid from @bettrans)
		)
		merge dbo.bettrans as s
		using mb as t on s.winlostdate = t.winlostdate and s.custid = t.custid and s.bettype = t.bettype
		when matched then update
			set s.ruben = t.ruben
				,s.status = t.status
				,s.statusId = t.statusId
				,s.matchid = t.matchid
				,s.bettype = t.bettype
				--,s.refno = t.refno
				,s.creator = t.creator
				,s.transdate = t.transdate
				,s.currency = t.currency
				,s.recommend = t.recommend
				,s.mrecommend = t.mrecommend
				,s.srecommend = t.srecommend
				,s.winlostdate = t.winlostdate
				,s.stake = isnull(s.stake, 0) + t.stake
				,s.winlost = isnull(s.winlost, 0) + t.winlost
				,s.awinlost = isnull(s.awinlost, 0) + t.awinlost
				,s.mwinlost = isnull(s.mwinlost, 0) + t.mwinlost
				,s.swinlost = isnull(s.swinlost, 0) + t.swinlost
				,s.actual_stake = isnull(s.actual_stake, 0) + t.actual_stake
				,s.playercomm = isnull(s.playercomm, 0) + t.playercomm
				,s.comm = isnull(s.comm, 0) + t.comm
				,s.acomm = isnull(s.acomm, 0) + t.acomm
				,s.scomm = isnull(s.scomm, 0) + t.scomm
				,s.apositiontaking = t.apositiontaking
				,s.mpositiontaking = t.mpositiontaking
				,s.spositiontaking = t.spositiontaking
				,s.tpositiontaking = t.tpositiontaking
				,s.actualrate = t.actualrate
				,s.virtualrate = t.virtualrate
				,s.Username = t.Username
				,s.CurrencyName = t.CurrencyName
				,s.comstatus = t.comstatus
				,s.checktime = t.checktime
		when not matched by target then insert
			(
				ruben, [status], statusID, matchid, bettype, refno, creator, transdate,
				custid, currency, recommend, mrecommend, srecommend,
				winlostdate, stake, winlost, awinlost, mwinlost, swinlost,
				actual_stake, playercomm, comm, acomm, scomm, 
				apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
				actualrate, virtualrate, Username, CurrencyName, comstatus, checktime
			)
			values
			(
				ruben, [status], statusID, matchid, bettype, refno, creator, transdate,
				custid, currency, recommend, mrecommend, srecommend,
				winlostdate, stake, winlost, awinlost, mwinlost, swinlost,
				actual_stake, playercomm, comm, acomm, scomm, 
				apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
				actualrate, virtualrate, Username, CurrencyName, comstatus, checktime
			);
	
		-- sum_winloss
		with cte_sumwinloss as
		(
			select @winlostdate as winlostdate, 1 as roleid, b.custid, b.recommend, b.mrecommend, b.srecommend, c.username
				,sum(abs(b.stake)) as TurnOver, sum(b.winlost-b.actual_stake) as winlost, sum(b.awinlost) as awinlost
				,sum(b.mwinlost) as mwinlost,sum(b.swinlost) as swinlost,sum(b.playercomm) as playercomm,sum(b.comm) as comm
				,sum(b.acomm) as acomm, sum(b.scomm) as scomm, count (1) as BetCount
				,sum(case when b.apositiontaking = 1 then 0 else comm/(1-apositiontaking) end) as grosscomm
				,case
					when bettype between 81 and 120 or bettype between 8101 and 8120 then 161 -- number game 
					when bettype between 1201 and 1299 then 180 -- virtual sport
					when bettype between 2700 and 2899 then 190 -- betradar virtual sport
					when bettype between 1501 and 1599 then 202 -- keno
					when bettype between 1021 and 1049 then 220 -- keno lottery
					when bettype between 1700 and 1799 then 255 -- gold deluxe
					when bettype between 1800 and 1899 then 250 --- ag casino 
					when bettype = 1900 then 249 --- vegas games 
					when bettype between 2001 and 2007 then 203 --- microgaming - live casino 
					when bettype between 2008 and 2009 then 205 --- microgaming - rng casino
					when bettype between  18000 and 18099 then 204 --- colossus bets
					when bettype between 2101 and 2199 then 208
					when bettype between 2201 and 2299 then 209
					when bettype between 2301 and 2399 or bettype between 2901 and 2999 then 210
					when bettype between 2401 and 2499 then 211 --- allbet
					when bettype between 4001 and 4100 then 212 --voidbridge
					when bettype between 4101 and 4300 then 248 --pragmatic
					when bettype between 2501 and 2699 then 213 --ng2 -
					when bettype between 1011 and 1020 then 219 --fishing world -
					when bettype between 8000 and 8099 then 221 -- exchange
					when bettype between 1901 and 1999 then 165 -- card club
					else 0 end sporttype
				,0 as bettype
				,0 as netTurnover
				,sum(case	when bettype between 2401 and 2499 then oddsspread
							when (bettype < 999 or bettype between 1301 and 1399 or bettype between 9001 and 9399) and bettype not between 81 and 120
								then case when statusid in (112,113) and modds in (-0.25, 0.25) then abs(stake)/2
											when statusid in (111) then 0 else 0 end
							else abs(stake) end) as turnovernodraw
			from #__bettrans b
				inner join custdb.dbo.custInfo c with (nolock) on b.custid = c.custid and c.roleid = 1
			group by b.custid, b.recommend, b.mrecommend, b.srecommend, c.username
				,case
					when bettype between 81 and 120 or bettype between 8101 and 8120 then 161 -- number game 
					when bettype between 1201 and 1299 then 180 -- virtual sport
					when bettype between 2700 and 2899 then 190 -- betradar virtual sport
					when bettype between 1501 and 1599 then 202 -- keno
					when bettype between 1021 and 1049 then 220 -- keno lottery
					when bettype between 1700 and 1799 then 255 -- gold deluxe
					when bettype between 1800 and 1899 then 250 --- ag casino 
					when bettype = 1900 then 249 --- vegas games 
					when bettype between 2001 and 2007 then 203 --- microgaming - live casino 
					when bettype between 2008 and 2009 then 205 --- microgaming - rng casino
					when bettype between  18000 and 18099 then 204 --- colossus bets
					when bettype between 2101 and 2199 then 208
					when bettype between 2201 and 2299 then 209
					when bettype between 2301 and 2399 or bettype between 2901 and 2999 then 210
					when bettype between 2401 and 2499 then 211 --- allbet
					when bettype between 4001 and 4100 then 212 --voidbridge
					when bettype between 4101 and 4300 then 248 --pragmatic
					when bettype between 2501 and 2699 then 213 --ng2 -
					when bettype between 1011 and 1020 then 219 --fishing world -
					when bettype between 8000 and 8099 then 221 -- exchange
					when bettype between 1901 and 1999 then 165 -- card club
					else 0 end

			union all
			select @winlostdate as winlostdate, 2 as roleid, b.recommend as custid, b.recommend, b.mrecommend, b.srecommend, c.username
				,sum(abs(b.stake)) as TurnOver, sum(b.winlost-b.actual_stake) as winlost, sum(b.awinlost) as awinlost
				,sum(b.mwinlost) as mwinlost,sum(b.swinlost) as swinlost,sum(b.playercomm) as playercomm,sum(b.comm) as comm
				,sum(b.acomm) as acomm, sum(b.scomm) as scomm, count (1) as BetCount
				,sum(case when b.apositiontaking + b.mpositiontaking = 1 then 0 else acomm/(1-apositiontaking-mpositiontaking) end) as grosscomm
				,case
					when bettype between 81 and 120 or bettype between 8101 and 8120 then 161 -- number game 
					when bettype between 1201 and 1299 then 180 -- virtual sport
					when bettype between 2700 and 2899 then 190 -- betradar virtual sport
					when bettype between 1501 and 1599 then 202 -- keno
					when bettype between 1021 and 1049 then 220 -- keno lottery
					when bettype between 1700 and 1799 then 255 -- gold deluxe
					when bettype between 1800 and 1899 then 250 --- ag casino 
					when bettype = 1900 then 249 --- vegas games 
					when bettype between 2001 and 2007 then 203 --- microgaming - live casino 
					when bettype between 2008 and 2009 then 205 --- microgaming - rng casino
					when bettype between  18000 and 18099 then 204 --- colossus bets
					when bettype between 2101 and 2199 then 208
					when bettype between 2201 and 2299 then 209
					when bettype between 2301 and 2399 or bettype between 2901 and 2999 then 210
					when bettype between 2401 and 2499 then 211 --- allbet
					when bettype between 4001 and 4100 then 212 --voidbridge
					when bettype between 4101 and 4300 then 248 --pragmatic
					when bettype between 2501 and 2699 then 213 --ng2 -
					when bettype between 1011 and 1020 then 219 --fishing world -
					when bettype between 8000 and 8099 then 221 -- exchange
					when bettype between 1901 and 1999 then 165 -- card club
					else 0 end sporttype
				,0 as bettype
				,sum(abs(stake*apositiontaking)) as netTurnover
				,sum(case	when bettype between 2401 and 2499 then oddsspread
							when (bettype < 999 or bettype between 1301 and 1399 or bettype between 9001 and 9399) and bettype not between 81 and 120
								then case when statusid in (112,113) and modds in (-0.25, 0.25) then abs(stake)/2
											when statusid in (111) then 0 else 0 end
							else abs(stake) end) as turnovernodraw
			from #__bettrans b
				inner join custdb.dbo.custInfo c with (nolock) on b.recommend = c.custid and c.roleid = 2
			group by b.recommend, b.mrecommend, b.srecommend, c.username
				,case
					when bettype between 81 and 120 or bettype between 8101 and 8120 then 161 -- number game 
					when bettype between 1201 and 1299 then 180 -- virtual sport
					when bettype between 2700 and 2899 then 190 -- betradar virtual sport
					when bettype between 1501 and 1599 then 202 -- keno
					when bettype between 1021 and 1049 then 220 -- keno lottery
					when bettype between 1700 and 1799 then 255 -- gold deluxe
					when bettype between 1800 and 1899 then 250 --- ag casino 
					when bettype = 1900 then 249 --- vegas games 
					when bettype between 2001 and 2007 then 203 --- microgaming - live casino 
					when bettype between 2008 and 2009 then 205 --- microgaming - rng casino
					when bettype between  18000 and 18099 then 204 --- colossus bets
					when bettype between 2101 and 2199 then 208
					when bettype between 2201 and 2299 then 209
					when bettype between 2301 and 2399 or bettype between 2901 and 2999 then 210
					when bettype between 2401 and 2499 then 211 --- allbet
					when bettype between 4001 and 4100 then 212 --voidbridge
					when bettype between 4101 and 4300 then 248 --pragmatic
					when bettype between 2501 and 2699 then 213 --ng2 -
					when bettype between 1011 and 1020 then 219 --fishing world -
					when bettype between 8000 and 8099 then 221 -- exchange
					when bettype between 1901 and 1999 then 165 -- card club
					else 0 end

			union all
			select @winlostdate as winlostdate, 3 as roleid, b.mrecommend as custid, 0 as recommend, b.mrecommend, b.srecommend, c.username
				,sum(abs(b.stake)) as TurnOver, sum(b.winlost-b.actual_stake) as winlost, sum(b.awinlost) as awinlost
				,sum(b.mwinlost) as mwinlost,sum(b.swinlost) as swinlost,sum(b.playercomm) as playercomm,sum(b.comm) as comm
				,sum(b.acomm) as acomm, sum(b.scomm) as scomm, count (1) as BetCount
				,sum(case when b.tpositiontaking = 1 then 0 else scomm/(1-tpositiontaking) end) as grosscomm
				,case
					when bettype between 81 and 120 or bettype between 8101 and 8120 then 161 -- number game 
					when bettype between 1201 and 1299 then 180 -- virtual sport
					when bettype between 2700 and 2899 then 190 -- betradar virtual sport
					when bettype between 1501 and 1599 then 202 -- keno
					when bettype between 1021 and 1049 then 220 -- keno lottery
					when bettype between 1700 and 1799 then 255 -- gold deluxe
					when bettype between 1800 and 1899 then 250 --- ag casino 
					when bettype = 1900 then 249 --- vegas games 
					when bettype between 2001 and 2007 then 203 --- microgaming - live casino 
					when bettype between 2008 and 2009 then 205 --- microgaming - rng casino
					when bettype between  18000 and 18099 then 204 --- colossus bets
					when bettype between 2101 and 2199 then 208
					when bettype between 2201 and 2299 then 209
					when bettype between 2301 and 2399 or bettype between 2901 and 2999 then 210
					when bettype between 2401 and 2499 then 211 --- allbet
					when bettype between 4001 and 4100 then 212 --voidbridge
					when bettype between 4101 and 4300 then 248 --pragmatic
					when bettype between 2501 and 2699 then 213 --ng2 -
					when bettype between 1011 and 1020 then 219 --fishing world -
					when bettype between 8000 and 8099 then 221 -- exchange
					when bettype between 1901 and 1999 then 165 -- card club
					else 0 end sporttype
				,0 as bettype
				,sum(abs(stake*mpositiontaking)) as netTurnover
				,sum(case	when bettype between 2401 and 2499 then oddsspread
							when (bettype < 999 or bettype between 1301 and 1399 or bettype between 9001 and 9399) and bettype not between 81 and 120
								then case when statusid in (112,113) and modds in (-0.25, 0.25) then abs(stake)/2
											when statusid in (111) then 0 else 0 end
							else abs(stake) end) as turnovernodraw
			from #__bettrans b
				inner join custdb.dbo.custInfo c with (nolock) on b.mrecommend = c.custid and c.roleid = 3
			group by b.mrecommend, b.srecommend, c.username
				,case
					when bettype between 81 and 120 or bettype between 8101 and 8120 then 161 -- number game 
					when bettype between 1201 and 1299 then 180 -- virtual sport
					when bettype between 2700 and 2899 then 190 -- betradar virtual sport
					when bettype between 1501 and 1599 then 202 -- keno
					when bettype between 1021 and 1049 then 220 -- keno lottery
					when bettype between 1700 and 1799 then 255 -- gold deluxe
					when bettype between 1800 and 1899 then 250 --- ag casino 
					when bettype = 1900 then 249 --- vegas games 
					when bettype between 2001 and 2007 then 203 --- microgaming - live casino 
					when bettype between 2008 and 2009 then 205 --- microgaming - rng casino
					when bettype between  18000 and 18099 then 204 --- colossus bets
					when bettype between 2101 and 2199 then 208
					when bettype between 2201 and 2299 then 209
					when bettype between 2301 and 2399 or bettype between 2901 and 2999 then 210
					when bettype between 2401 and 2499 then 211 --- allbet
					when bettype between 4001 and 4100 then 212 --voidbridge
					when bettype between 4101 and 4300 then 248 --pragmatic
					when bettype between 2501 and 2699 then 213 --ng2 -
					when bettype between 1011 and 1020 then 219 --fishing world -
					when bettype between 8000 and 8099 then 221 -- exchange
					when bettype between 1901 and 1999 then 165 -- card club
					else 0 end

			union all
			select @winlostdate as winlostdate, 4 as roleid, b.srecommend as custid, 0 as recommend, 0 as mrecommend, b.srecommend, c.username
				,sum(abs(b.stake)) as TurnOver, sum(b.winlost-b.actual_stake) as winlost, sum(b.awinlost) as awinlost
				,sum(b.mwinlost) as mwinlost,sum(b.swinlost) as swinlost,sum(b.playercomm) as playercomm,sum(b.comm) as comm
				,sum(b.acomm) as acomm, sum(b.scomm) as scomm, count (1) as BetCount
				,sum(case when b.tpositiontaking = 1 then 0 else scomm/(1-tpositiontaking) end) as grosscomm
				,case
					when bettype between 81 and 120 or bettype between 8101 and 8120 then 161 -- number game 
					when bettype between 1201 and 1299 then 180 -- virtual sport
					when bettype between 2700 and 2899 then 190 -- betradar virtual sport
					when bettype between 1501 and 1599 then 202 -- keno
					when bettype between 1021 and 1049 then 220 -- keno lottery
					when bettype between 1700 and 1799 then 255 -- gold deluxe
					when bettype between 1800 and 1899 then 250 --- ag casino 
					when bettype = 1900 then 249 --- vegas games 
					when bettype between 2001 and 2007 then 203 --- microgaming - live casino 
					when bettype between 2008 and 2009 then 205 --- microgaming - rng casino
					when bettype between  18000 and 18099 then 204 --- colossus bets
					when bettype between 2101 and 2199 then 208
					when bettype between 2201 and 2299 then 209
					when bettype between 2301 and 2399 or bettype between 2901 and 2999 then 210
					when bettype between 2401 and 2499 then 211 --- allbet
					when bettype between 4001 and 4100 then 212 --voidbridge
					when bettype between 4101 and 4300 then 248 --pragmatic
					when bettype between 2501 and 2699 then 213 --ng2 -
					when bettype between 1011 and 1020 then 219 --fishing world -
					when bettype between 8000 and 8099 then 221 -- exchange
					when bettype between 1901 and 1999 then 165 -- card club
					else 0 end sporttype
				,0 as bettype
				,sum(abs(stake*spositiontaking)) as netTurnover
				,sum(case	when bettype between 2401 and 2499 then oddsspread
							when (bettype < 999 or bettype between 1301 and 1399 or bettype between 9001 and 9399) and bettype not between 81 and 120
								then case when statusid in (112,113) and modds in (-0.25, 0.25) then abs(stake)/2
											when statusid in (111) then 0 else 0 end
							else abs(stake) end) as turnovernodraw
			from #__bettrans b
				inner join custdb.dbo.custInfo c with (nolock) on b.srecommend = c.custid and c.roleid = 4
			group by b.srecommend, c.username
				,case
					when bettype between 81 and 120 or bettype between 8101 and 8120 then 161 -- number game 
					when bettype between 1201 and 1299 then 180 -- virtual sport
					when bettype between 2700 and 2899 then 190 -- betradar virtual sport
					when bettype between 1501 and 1599 then 202 -- keno
					when bettype between 1021 and 1049 then 220 -- keno lottery
					when bettype between 1700 and 1799 then 255 -- gold deluxe
					when bettype between 1800 and 1899 then 250 --- ag casino 
					when bettype = 1900 then 249 --- vegas games 
					when bettype between 2001 and 2007 then 203 --- microgaming - live casino 
					when bettype between 2008 and 2009 then 205 --- microgaming - rng casino
					when bettype between  18000 and 18099 then 204 --- colossus bets
					when bettype between 2101 and 2199 then 208
					when bettype between 2201 and 2299 then 209
					when bettype between 2301 and 2399 or bettype between 2901 and 2999 then 210
					when bettype between 2401 and 2499 then 211 --- allbet
					when bettype between 4001 and 4100 then 212 --voidbridge
					when bettype between 4101 and 4300 then 248 --pragmatic
					when bettype between 2501 and 2699 then 213 --ng2 -
					when bettype between 1011 and 1020 then 219 --fishing world -
					when bettype between 8000 and 8099 then 221 -- exchange
					when bettype between 1901 and 1999 then 165 -- card club
					else 0 end
		)
		merge sum_winloss as s
		using cte_sumwinloss as t on s.custid = t.custid and s.winlostdate = t.winlostdate and s.sporttype = t.sporttype and s.bettype = t.bettype
		when matched then update
			set s.username			 = t.username
				,s.custid			 = t.custid
				,s.roleid			 = t.roleid
				,s.recommend		 = t.recommend
				,s.mrecommend		 = t.mrecommend
				,s.srecommend		 = t.srecommend
				,s.turnover			 = t.turnover
				,s.winlost			 = t.winlost
				,s.awinlost			 = t.awinlost
				,s.mwinlost			 = t.mwinlost
				,s.swinlost			 = t.swinlost
				,s.playercomm		 = t.playercomm
				,s.comm				 = t.comm
				,s.acomm			 = t.acomm
				,s.scomm			 = t.scomm
				,s.BetCount			 = t.BetCount
				,s.grosscomm		 = t.grosscomm
				,s.netTurnover		 = t.netTurnover
				,s.TunroverNoDraw	 = t.turnovernodraw
		when not matched by target then insert
			(
				winlostdate,username,custid,roleid,recommend,mrecommend,srecommend,turnover
				,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,BetCount
				,grosscomm,sporttype,bettype,netTurnover,TunroverNoDraw
			)
			values
			(
				winlostdate,username,custid,roleid,recommend,mrecommend,srecommend,turnover
				,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,BetCount
				,grosscomm,sporttype,bettype,netTurnover,turnovernodraw
			);

		-- delete data
		delete dbo.bettrans with (rowlock, updlock)
		where transid in (select transid from #__bettrans)

		if @eventtype = 1
			delete dbo.match with (rowlock, updlock)
			where matchid = @matchid
		else if @eventtype = 2
			delete dbo.outright with (rowlock, updlock)
			where orid = @matchid
		else if @eventtype = 3
			delete dbo.VSOutright with (rowlock, updlock)
			where EventId = @matchid

		if exists (select 1 from @bettransm)
			delete dbo.bettransm with (rowlock, updlock)
			where transid in (select transid from @bettransm)
	end try
	begin catch
		select @errmsg = error_message()
		raiserror (@errmsg, 16, 1)
		--rollback transaction
	end catch

	--commit transaction
	-- end move data

	declare @custids varchar(max)
	select  @custids = coalesce(@custids + ',', '') + convert(varchar(20), custid) from (select distinct custid from @bettrans) as b

	declare @wld varchar(10)
	select  @wld = convert(varchar(10), @winlostdate, 120)

	declare @sql varchar(max)

	-- rptStatement
	select @sql = 'exec bodb_report.dbo.Task_rptStatement_14 @winlostdate = ''' + @wld + ''', @custids = ''' + @custids + ''''
	exec (@sql) at dbrpt

	-- cs_sumwinloss/cs_sumcancelled
	select @sql = 'exec bodb_summary.dbo.Task_CS_SumCancelled_14 @winlostdate = ''' + @wld + ''', @custids = ''' + @custids + ''''
	exec (@sql) at dbage
	exec (@sql) at dbext

	select @sql = 'exec bodb_summary.dbo.Task_CS_SumWinloss_14 @winlostdate = ''' + @wld + ''', @custids = ''' + @custids + ''''
	exec (@sql) at dbage
	exec (@sql) at dbext
end
go