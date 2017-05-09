USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[DBA_Fast_Market_GenTickets]    Script Date: 05/09/2017 14:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[DBA_Fast_Market_GenTickets] @MatchId int = 0
	, @CustId int = 0
	, @IsCreditCustomer bit = 1
	, @liveindicator bit = 0
as
/*	Creator: 20160303@Patrick
	Task: DBA - Generate tickets
	DB: DBTXN/BODB02
	Original: 
	
	Revisions:
		
	Param's Explanation:

	DBA_Fast_Market_GenTickets @matchid = 18031182
 
*/
begin
	set nocount on

	if @@servername not in ('DB230', 'DB206')
	begin
		select 'error!!!'
		return
	end

	--if (select max(transid) from dbext.bodb_Age.dbo.bettrans_running with(nolock)) > (select max(transid) from dbo.bettrans with(nolock))
	--begin
	--	select 'bettrans_running error!!!'
	--	return
	--end

	--if (select max(transid) from dbext.bodb02.dbo.bettrans_lrf_betRunning with(nolock)) > (select max(transid) from dbo.bettrans with(nolock))
	--begin
	--	select 'bettrans_lrf_betRunning error!!!'
	--	return
	--end

	--get matchinfo
	declare @eventdate datetime = cast(getdate() as date)
	select top 1 @matchid = matchid 
	from bodb02.dbo.match m (nolock)
	where eventdate = @eventdate and m.sporttype = 1 and eventstatus = 'running'
		and (@MatchId = 0 OR (@MatchId <> 0 AND m.matchid = @MatchId))

	if @MatchId is null
	begin
		select 'match does not exist'
		return
	end

	select @matchid as '@matchid'

	--get custinfo
	declare @tmpCustInfo table (rowid int identity(1,1), custid int, creator int, username nvarchar(30)
		, recommend int, mrecommend int, srecommend int, currency tinyint, currencyName nvarchar(50)
		, siteName nvarchar(100), isDeposit bit)

	insert into @tmpCustInfo
	select top 1 ci.custid, ci.custid, ci.username, ci.recommend, ci.mrecommend, ci.srecommend, ci.currency
		, ex.currency, ag.site, case when sp.custid is null then 0 else 1 end
	from custdb.dbo.custinfo ci (nolock) 
		inner join custdb.dbo.exchange ex (nolock) on ex.exchangeid = ci.currency 
		inner join custdb.dbo.customer ag (nolock) on ag.custid = ci.recommend 
		left join custDB.dbo.Dep_CustSuper sp (nolock) on ci.srecommend = sp.custid
	where ci.roleid = 1 and ci.username not like '%bettrade%'
		and ((@IsCreditCustomer = 1 and sp.custid is null) or (@IsCreditCustomer = 0 and sp.custid is not null)) 
		and ci.currency = 20 and ci.custid <> 14123341
		and (@CustId = 0 or (@CustId <> 0 and ci.custid = @CustId))

	if not exists (select top 1 1 from @tmpCustInfo)
	begin
		select 'Custinfo does not exist'
		return
	end
	select * from @tmpCustInfo
	
	--bettrans info
	declare @tmpBettrans table (rn int identity (1,1) not null, custid int, transdate datetime, oddsid int, hdp1 smallmoney
		, hdp2 smallmoney, odds smallmoney, stake money, [status] nvarchar(10), winlost money, awinlost money, mwinlost money
		, playercomm money, comm money, acomm money, apositiontaking smallmoney, mpositiontaking smallmoney, tpositiontaking smallmoney
		, playerdiscount decimal(9,8), discount decimal(9,8), adiscount decimal(9,8), livehomescore smallint, liveawayscore smallint
		, liveindicator bit, betteam nvarchar(10), creator int, refno bigint, comstatus nvarchar(20), winlostdate smalldatetime
		, betfrom nvarchar(1), betcheck nvarchar(50), checktime datetime, oddsspread money, actualrate float, matchid int, recommend int
		, mrecommend int, ruben tinyint, betid bigint, statuswinlost tinyint, modds smallmoney, bettype smallint, betdaqid bigint
		, actual_stake money, currency tinyint, ip nvarchar(15), transdesc nvarchar(1000), sdiscount decimal(9,8), scomm money
		, spositiontaking smallmoney, swinlost money, srecommend int, username nvarchar(50), currencyName nvarchar(50), virtualrate float
		, oddstype tinyint, statusID tinyint, currency2 tinyint, balance money, SecAcceptFlag bit, transid2 bigint, RecommDate datetime)

	declare @BetOptions table (rowid int identity(0,1), option_name varchar(100) unique, option_binary varchar(8), option_ascii tinyint
		, option_char varchar(1))

	insert into @BetOptions(option_name, option_binary, option_ascii, option_char)
	select option_name, option_binary, option_ascii, option_char 
	from dbo.f_DBA_Fast_Market_GenerateBetOptions() 
	where option_ascii in (1,2,4,8,16,32,64,128)
	order by newid()

	declare @optionId int, @option_name_temp varchar(100), @option_ascii_temp tinyint, @option_name varchar(100)

	declare @options_name table(option_name varchar(100))

	select @optionId = 0
	while exists (select top 1 1 from @betoptions where rowid = @optionId)
	begin
		delete from @options_name

		select @option_name = option_name from @betoptions where rowid = @optionId

		set @optionId += 1

		insert into @options_name(option_name)
		select val from dbo.strSplit(@option_name, '_')

		--for bettype 221
		select @option_name_temp = null, @option_ascii_temp = 0
		select @option_name_temp = coalesce(@option_name_temp + '_' + cast(option_name as varchar), cast(option_name as varchar))
		from @options_name where option_name not in ('None', 'Bookings', 'Penalty')

		if exists (select 1 from @betoptions where option_name = @option_name_temp)
		begin
			select @option_ascii_temp = option_ascii from @betoptions where option_name = @option_name_temp
			insert into @tmpBettrans (bettype, betteam, betcheck, hdp1, hdp2)
			values(221, @option_ascii_temp, '', 0, @option_ascii_temp)
		end
		--else 
		--	select @option_ascii_temp = ascii(replicate(char('0'), 8))
	
		--for bettype 222
		select @option_name_temp = null, @option_ascii_temp = 0
		select @option_name_temp = coalesce(@option_name_temp + '_' + cast(option_name as varchar), cast(option_name as varchar))
		from @options_name where option_name not in ('Free-Kick', 'Goal-Kick', 'Throw-In', 'Bookings')

		if exists (select 1 from @betoptions where option_name = @option_name_temp)
		begin
			select @option_ascii_temp = option_ascii from @betoptions where option_name = @option_name_temp
			
			insert into @tmpBettrans (bettype, betteam, betcheck, hdp1, hdp2)
			values(222, @option_ascii_temp, '', 0, @option_ascii_temp)
			--invert
			insert into @tmpBettrans (bettype, betteam, betcheck, hdp1, hdp2)
			values(222, 0, '', 0, @option_ascii_temp)
		end
		--else 
		--	select @option_ascii_temp = ascii(replicate(char('0'), 8))

		--for bettype 223
		select @option_name_temp = null, @option_ascii_temp = 0
		select @option_name_temp = coalesce(@option_name_temp + '_' + cast(option_name as varchar), cast(option_name as varchar))
		from (
			select top 1 option_name
			from @options_name where option_name not in ('Bookings', 'Penalty')
		)t

		if exists (select 1 from @betoptions where option_name = @option_name_temp)
		begin
			select @option_ascii_temp = option_ascii from @betoptions where option_name = @option_name_temp
			insert into @tmpBettrans (bettype, betteam, betcheck, hdp1, hdp2)
			values(223, @option_ascii_temp, '', 0, @option_ascii_temp)
		end
		--else 
		--	select @option_ascii_temp = ascii(replicate(char('0'), 8))

		--for bettype 224
		select @option_name_temp = null, @option_ascii_temp = 0
		select @option_name_temp = coalesce(@option_name_temp + '_' + cast(option_name as varchar), cast(option_name as varchar))
		from (
			select top 1 option_name
			from @options_name where option_name not in ('Free-Kick', 'Goal-Kick', 'Throw-In')
		)t

		if exists (select 1 from @betoptions where option_name = @option_name_temp)
		begin
			select @option_ascii_temp = option_ascii from @betoptions where option_name = @option_name_temp
			insert into @tmpBettrans (bettype, betteam, betcheck, hdp1, hdp2)
			values(224, @option_ascii_temp, '', 0, @option_ascii_temp)
		end
		--else 
		--	select @option_ascii_temp = ascii(replicate(char('0'), 8))
		
		select @option_name_temp = null, @option_ascii_temp = 0
		select @option_name_temp = coalesce(@option_name_temp + '_' + cast(option_name as varchar), cast(option_name as varchar))
		from @options_name where option_name  IN ('none', 'CornersFreeKickGoalKickPenalty')

		if exists (select 1 from @betoptions where option_name = @option_name_temp)
		begin
			select @option_ascii_temp = option_ascii from @betoptions where option_name = @option_name_temp
			insert into @tmpBettrans (bettype, betteam, betcheck, hdp1, hdp2)
			values(225, @option_ascii_temp, '', 0, @option_ascii_temp)
		end

	end
	
	declare	@transdate datetime = getdate(), @winlostdate datetime = cast(getdate() as date)
		, @refno bigint = 100000000000, @stake money = 100, @odds smallmoney = 1.2, @oddstype tinyint = 1
		, @apositiontaking smallmoney = 0.3, @mpositiontaking decimal(9,8) = 0, @spositiontaking decimal(9,8) = 0
		, @tpositiontaking decimal(9,8) = 0.3, @playerdiscount decimal(9,8) = 0.00025, @discount decimal(9,8) = 0.00
		, @adiscount decimal(9,8) = 0.00, @sdiscount decimal(9,8) = 0.00

	--++update bettrans info
	update @tmpbettrans
	set custid = c.custid, creator = c.creator, username = c.username, recommend = c.recommend, mrecommend = c.mrecommend
		, srecommend = c.srecommend, currency = c.currency, currencyname = c.currencyname, apositiontaking = @apositiontaking
		, mpositiontaking = @mpositiontaking, tpositiontaking = @tpositiontaking, spositiontaking = @spositiontaking
		, playerdiscount = @playerdiscount, discount = @discount, adiscount = @adiscount, sdiscount = @sdiscount
		, transdate = @transdate, winlostdate = @winlostdate, refno = @refno, stake = @stake, odds = @odds, oddstype = @oddstype
		, winlost = 0, awinlost = 0, mwinlost = 0, swinlost = 0, playercomm = 0, comm = 0, acomm = 0, scomm = 0, [status] = 'running'
		, statusid = 0, ruben = 0, statuswinlost = null, oddsid = 0, actual_stake = case when @odds < 0 then @stake * @odds else @stake end
		, livehomescore = 0, liveawayscore = 0, liveindicator = @liveindicator
		, comstatus = 0, betfrom = 'i', checktime = @transdate, oddsspread = 0, actualrate = 0, virtualrate = 0, betid = 0
		, modds = 1, betdaqid = -1, ip = '127.0.0.1', transdesc = null, matchid = @matchid
	from @tmpcustinfo c
	
	select * from @tmpBettrans

	declare @index int = 0, @str_result varchar(50)
	declare @transidlist table(transid bigint, matchid int, bettype smallint)

	--221
	set @index = 0
	while @index <= 89
	begin
		if @index = 86
		begin
			delete from @tmpbettrans where bettype in (222, 224)
		end

		--221
		select @str_result = case when @index <= 44 then HomeValue else AwayValue end
		from dbo.ResultDetail with(nolock) where matchid = @MatchId and ResourceId = '22101'
		
		if (SELECT byte FROM dbo.f_Set_GetByte_xtest(@str_result, @index)) <> ascii(char('0'))
		begin
			insert into dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, [status], winlost, awinlost, mwinlost
				, swinlost, playercomm, comm, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking
				, playerdiscount, discount, adiscount, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator
				, refno, comstatus, winlostdate, betfrom, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend
				, srecommend, ruben, betid, modds, bettype, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc
				, username, virtualrate, oddstype, statusid, balance, secacceptflag, transid2, recommdate)
			output inserted.transid, inserted.matchid, inserted.bettype into @transidlist
			select custid, transdate, oddsid, @index, hdp2, odds, stake, status, winlost, awinlost, mwinlost, swinlost, playercomm, comm
				, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking, playerdiscount, discount, adiscount
				, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator, refno, comstatus, winlostdate, betfrom
				, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend, srecommend, ruben, betid, modds, bettype
				, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc, username, virtualrate, oddstype, statusid
				, balance, secacceptflag, transid2, recommdate
			from @tmpbettrans where bettype = 221
		end

		--222
		set @str_result = null
		select @str_result = case when @index <= 44 then HomeValue else AwayValue end
		from dbo.ResultDetail with(nolock) where matchid = @MatchId and ResourceId = '22201'
		
		if (SELECT byte from dbo.f_Set_GetByte_xtest(@str_result, @index)) <> ascii(char('0'))
		begin
			insert into dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, [status], winlost, awinlost, mwinlost
				, swinlost, playercomm, comm, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking
				, playerdiscount, discount, adiscount, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator
				, refno, comstatus, winlostdate, betfrom, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend
				, srecommend, ruben, betid, modds, bettype, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc
				, username, virtualrate, oddstype, statusid, balance, secacceptflag, transid2, recommdate)
			output inserted.transid, inserted.matchid, inserted.bettype into @transidlist
			select custid, transdate, oddsid, @index, hdp2, odds, stake, status, winlost, awinlost, mwinlost, swinlost, playercomm, comm
				, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking, playerdiscount, discount, adiscount
				, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator, refno, comstatus, winlostdate, betfrom
				, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend, srecommend, ruben, betid, modds, bettype
				, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc, username, virtualrate, oddstype, statusid
				, balance, secacceptflag, transid2, recommdate
			from @tmpbettrans where bettype = 222
		end

		--223
		set @str_result = null
		select @str_result = case when @index <= 44 then HomeValue else AwayValue end
		from dbo.ResultDetail with(nolock) where matchid = @MatchId and ResourceId = '22301'
		
		if (SELECT byte from dbo.f_Set_GetByte_xtest(@str_result, @index)) <> ascii(char('0'))
		begin
			insert into dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, [status], winlost, awinlost, mwinlost
				, swinlost, playercomm, comm, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking
				, playerdiscount, discount, adiscount, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator
				, refno, comstatus, winlostdate, betfrom, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend
				, srecommend, ruben, betid, modds, bettype, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc
				, username, virtualrate, oddstype, statusid, balance, secacceptflag, transid2, recommdate)
			output inserted.transid, inserted.matchid, inserted.bettype into @transidlist
			select custid, transdate, oddsid, @index, hdp2, odds, stake, status, winlost, awinlost, mwinlost, swinlost, playercomm, comm
				, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking, playerdiscount, discount, adiscount
				, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator, refno, comstatus, winlostdate, betfrom
				, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend, srecommend, ruben, betid, modds, bettype
				, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc, username, virtualrate, oddstype, statusid
				, balance, secacceptflag, transid2, recommdate
			from @tmpbettrans where bettype = 223
		end

		--224
		set @str_result = null
		select @str_result = case when @index <= 44 then HomeValue else AwayValue end
		from dbo.ResultDetail with(nolock) where matchid = @MatchId and ResourceId = '22401'
		
		if (SELECT byte from dbo.f_Set_GetByte_xtest(@str_result, @index)) <> ascii(char('0'))
		begin
			insert into dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, [status], winlost, awinlost, mwinlost
				, swinlost, playercomm, comm, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking
				, playerdiscount, discount, adiscount, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator
				, refno, comstatus, winlostdate, betfrom, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend
				, srecommend, ruben, betid, modds, bettype, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc
				, username, virtualrate, oddstype, statusid, balance, secacceptflag, transid2, recommdate)
			output inserted.transid, inserted.matchid, inserted.bettype into @transidlist
			select custid, transdate, oddsid, @index, hdp2, odds, stake, status, winlost, awinlost, mwinlost, swinlost, playercomm, comm
				, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking, playerdiscount, discount, adiscount
				, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator, refno, comstatus, winlostdate, betfrom
				, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend, srecommend, ruben, betid, modds, bettype
				, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc, username, virtualrate, oddstype, statusid
				, balance, secacceptflag, transid2, recommdate
			from @tmpbettrans where bettype = 224
		end
		
		set @str_result = null
		select @str_result = case when @index <= 44 then HomeValue else AwayValue end
		from dbo.ResultDetail with(nolock) where matchid = @MatchId and ResourceId = '22501'
		
		if (SELECT byte from dbo.f_Set_GetByte_xtest(@str_result, @index)) <> ascii(char('0'))
		begin
			insert into dbo.bettrans (custid, transdate, oddsid, hdp1, hdp2, odds, stake, [status], winlost, awinlost, mwinlost
				, swinlost, playercomm, comm, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking
				, playerdiscount, discount, adiscount, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator
				, refno, comstatus, winlostdate, betfrom, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend
				, srecommend, ruben, betid, modds, bettype, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc
				, username, virtualrate, oddstype, statusid, balance, secacceptflag, transid2, recommdate)
			output inserted.transid, inserted.matchid, inserted.bettype into @transidlist
			select custid, transdate, oddsid, @index, hdp2, odds, stake, status, winlost, awinlost, mwinlost, swinlost, playercomm, comm
				, acomm, scomm, apositiontaking, mpositiontaking, spositiontaking, tpositiontaking, playerdiscount, discount, adiscount
				, sdiscount, livehomescore, liveawayscore, liveindicator, betteam, creator, refno, comstatus, winlostdate, betfrom
				, betcheck, checktime, oddsspread, actualrate, matchid, recommend, mrecommend, srecommend, ruben, betid, modds, bettype
				, betdaqid, actual_stake, currency, currencyname, currency2, ip, transdesc, username, virtualrate, oddstype, statusid
				, balance, secacceptflag, transid2, recommdate
			from @tmpbettrans where bettype = 225
		end
		
		set @index += 1
	end
	
	--update/insert odds info
	if exists (select top 1 1 from @transidlist) 
	begin
		insert into dbo.odds (matchid, bettype, oddsstatus, liveindicator, livehomescore, liveawayscore, creator, sporttype)
		select distinct t.matchid, t.bettype, 'running', 1, 0, 0, 8, 1
		from @transidlist t
		where not exists (select top 1 1 from dbo.odds o with(nolock) where o.matchid = t.matchid and o.bettype = t.bettype)
				
		update b set b.oddsid = o.oddsid
		from dbo.bettrans b with(nolock)
			inner join dbo.odds o with(nolock) on o.matchid = b.matchid and o.bettype = o.bettype
		where exists (select top 1 1 from @transidlist t where t.transid = b.transid)
	end
	
	--update match info
	if exists (select top 1 1 from @transIDList) 
	begin
		update m
		set eventdate = @eventdate, kickofftime = dateadd(hour, -2, @eventdate)
			, ruben = 0, settletime = null, eventstatus = 'running'
		from bodb02.dbo.match m with(rowlock, updlock)
		where exists (select top 1 1 from @transidlist t where m.matchid = t.matchid)
	end

	select count(1) as totaltickets from @transIDList

end
