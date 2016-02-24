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
 
select @TransIds = '9799002825,9799002826'

if isnull(@TransIds, '') = ''
begin
	return
end

--==start step 1: search cricket ticket to update NP--===============
declare @TicketCricketList table(transid bigint, bettype smallint, isfinished bit)
  
insert into @TicketCricketList(transid, bettype, isfinished)
select t.transid, b.bettype, 0
from (
select val as transid from dbo.strSplit(@TransIds, ',')
) t
	inner join dbo.bettrans b with(nolock) on t.transid = b.transid
where b.srecommend not in (select custid from CustDB.dbo.Dep_CustSuper s with(nolock))

--double check
if exists (select top 1 1 from @TicketCricketList where bettype in (500))
begin
	select 'The ticket list contains a bettype 500.'
	return
end

--==end step 1: search cricket ticket to update NP--=================

--==start step 4: update NP--===============

declare @ScheduleList table (CustId int, MatchId int, bettype smallint)
declare @QueueItems table (NPQueueID bigint, Matchid int, Bettype smallint, MinTransid bigint, MaxTransid bigint, ActionTypeID tinyint, NeedPending bit)

declare @transid bigint, @NPQueueID bigint, @MatchId int, @Bettype smallint
	, @MinTransid bigint, @MaxTransId bigint, @CustId int

while 1 = 1
begin
	set @transid = 0

	update top(1) t
	set @transid = transid
		, isfinished = 1
	from @TicketCricketList t
	where isfinished = 0

	if @@rowcount = 0
	break

	--cal service to update NP
	exec dbo.Dot_Member_NetPosition_UnVoid_test
		@Transid = @transid,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT

	if @ErrCode <> 0
	begin
		select @ErrCode as '@ErrCode', @ErrMsg as '@ErrMsg'
		continue
	end

	--clean data
	delete from @QueueItems
	delete from @ScheduleList

	--get queue item
	insert into @QueueItems
	exec dbo.Dot_Member_NetPosition_GetQueue_test

	if not exists (select 1 from @QueueItems)
		continue

	select top 1 @NPQueueID = NPQueueID, @Matchid = Matchid, @Bettype = Bettype, @MinTransid = MinTransid, @MaxTransId = MaxTransid
   	from @QueueItems
	where ActionTypeID = 3 and MinTransid = @transid

	--get schedule
	insert into @ScheduleList
	exec dbo.Dot_Member_NetPosition_GetSchedule_test @NPQueueID = @NPQueueID
		, @Matchid = @Matchid
		, @bettype = @bettype
		, @MinTransid = @MinTransid
		, @MaxTransid = @MaxTransId
		, @ActionTypeID = 3

	if not exists (select 1 from @ScheduleList)
		continue

	select top 1 @CustId = CustId
	from @ScheduleList 
	where MatchId = @MatchId and bettype = @Bettype

	--calculate NP
	exec dbo.Dot_Member_NetPosition_Calculation_test @Custid = @CustId
		, @Matchid = @Matchid
		, @bettype = @bettype
		, @ActionTypeID = 3

end

--==end step 4: update NP--===============

 go