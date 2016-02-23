use bodb02
go
/*
Recover bet when update NP failed:
	1 - Search ticket (include Cricket IMBC)  NAP_BettransSelRecoverBet
	2 - Check negative balance --skip this step
	3 - Recover ticket NAP_BettransRecoverBet --skip this step
	4 - Recover NetPosition Dot_Member_NetPosition_UnVoid_test (include Dot_Member_NetPosition_GetQueue_test & Dot_Member_NetPosition_GetSchedule_test)
	5 - If fail to call recover NP service, log failed API

	run on DBTXN.bodb02
	Note:
	- Do not support bettrade
	- Do not proceed send mail to licensee
	
 */
declare @TransIds varchar(max)
	, @ErrCode int
	, @ErrMsg nvarchar(200)
 
select @TransIds = '8415947885,8415948134'

if isnull(@TransIds, '') = ''
begin
	return
end

--==start step 1: search cricket ticket to update NP--===============
select 'start #1' as '#1'
declare @TicketCricketList table(transid bigint, bettype smallint, isfinished bit)
  
--insert into @TicketCricketList(transid, bettype, isfinished)
select t.transid, b.bettype, 0
from (
select val as transid from dbo.strSplit(@TransIds, ',')
) t
	inner join dbo.bettrans b with(nolock) on t.transid = b.transid
where b.srecommend not in (select custid from CustDB.dbo.Dep_CustSuper s with(nolock))
--where s.custid is null and b.bettype = 501
select * from @TicketCricketList

--double check
if exists (select top 1 1 from @TicketCricketList where bettype in (500))
begin
	select 'The ticket list contains a bettype 500.'
	return
end

--add more check at here

select 'end #1' as '#1'
--==end step 1: search cricket ticket to update NP--=================

--==start step 4: update NP--===============
select 'start #4' as '#4'

declare @TransFailedIds table(transid bigint, msg nvarchar(300))
declare @transid bigint

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