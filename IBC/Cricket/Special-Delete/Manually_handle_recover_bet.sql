use bodb02
go
/*
Recover bet:
	1 - Search ticket (include Cricket IMBC)  NAP_BettransSelRecoverBet
	2 - Check negative balance
	3 - Recover ticket NAP_BettransRecoverBet
	4 - Recover NetPosition Dot_Member_NetPosition_UnVoid_test (include Dot_Member_NetPosition_GetQueue_test & Dot_Member_NetPosition_GetSchedule_test)
	5 - If fail to call recover NP service, log failed API

	run on DBTXN.bodb02
	Note:
	- Do not support bettrade
	- Do not proceed send mail to licensee
 */
declare @TransIds varchar(max)
	, @UserId int	
	, @IP varchar(50)
	, @ErrCode int
	, @ErrMsg nvarchar(200)
 
select @TransIds = '8413655314,8412783358', @UserId = 8, @IP = '127.0.0.1'

if isnull(@TransIds, '') = '' or isnull(@UserId, '') = '' or isnull(@IP, '') = ''
begin
	return
end
--==start step 1: search ticket need to void--===============
select 'start #1' as '#1'
declare @TicketList table(transid bigint, bettype smallint, iscricket bit)
  
insert into @TicketList(transid, bettype, iscricket)
select t.transid, b.bettype, case when s.custid is null and b.bettype = 501 then 1 else 0 end
from (
select val as transid from dbo.strSplit(@TransIds, ',')
) t
inner join dbo.bettrans b with(nolock) on t.transid = b.transid
left join CustDB.dbo.Dep_CustSuper s with(nolock) on b.srecommend = s.custid

--double check
if exists (select top 1 1 from @TicketList where bettype in (500))
begin
	select 'The ticket list contains a bettype 500.'
	return
end

--add more check at here

select 'end #1' as '#1'
--==end step 1: search ticket need to void--=================

--==start step 2: check negative balance--===============
select 'start #2' as '#2'
exec dbo.NAP_BettransCheckNegativeBalance_xtest
	@TransIds = @TransIds,
	@Type = 0, --for delete
	@ExcludeRunning = 0 --need to check

select 'end #2' as '#2'
--==end step 2: check negative balance--=================

--==start step 3: recover bet--===============
select 'start #3' as '#3'

exec dbo.NAP_BettransRecoverBet_xtest @TransIds = @TransIds
	--@TransIdSolds	VARCHAR(MAX)	= '', -- just for BetTrade's subticket (transid of bettype 901)  	

	, @UserId = @UserId
	, @IP = @IP
	, @ErrCode = @ErrCode OUTPUT
	, @ErrMsg = @ErrMsg OUTPUT

if @ErrCode <> 0
begin
	select @ErrCode as '@ErrCode', @ErrMsg as '@ErrMsg'
	return
end

select 'end #3' as '#3'
--==end step 2: recover bet--=================

--==start step 4: update NP--===============
select 'start #4' as '#4'

declare @TicketCricketList table (transid bigint, isfinished bit)
declare @TransFailedIds table(transid bigint, msg nvarchar(300))
declare @transid bigint

insert into @TicketCricketList(transid, isfinished)
select transid, 0
from @TicketList where iscricket = 1

while 1 = 1
begin
	update top(1) t
	set @transid = transid
		, isfinished = 1
	from @TicketCricketList t
	where isfinished = 0

	if @@rowcount = 0
	break

	--cal service to update NP
	begin try
	exec dbo.Dot_Member_NetPosition_UnVoid_test
		@Transid = @transid,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT

	if @ErrCode <> 0
	begin
		if not exists (select top 1 1 from @TransFailedIds)
		begin
			insert into @TransFailedIds(transid, msg)
			values(@transid, @ErrMsg)
		end
	end
	end try
	begin catch
		if not exists (select top 1 1 from @TransFailedIds)
		begin
			insert into @TransFailedIds(transid, msg)
			values(@transid, @ErrMsg)
		end
	end catch

end

if exists (select top 1 1 from @TransFailedIds)
begin
	select 'Failed to update NP' as 'Failed', * from @TransFailedIds
end

select 'end #4' as '#4'
--==end step 4: update NP--===============

 go