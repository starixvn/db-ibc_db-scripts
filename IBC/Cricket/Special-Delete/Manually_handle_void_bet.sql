use bodb02
go
/*

Void By Bet Id

	1 - Search ticket (include Cricket IMBC) NAP_BettransSpecialDelBetID_Sel, NAP_BettransSelSpecialDel_EarlyKO, NAP_BettransSpecialDelBetID_Sel
	2 - Count negative balance NAP_BettransCheckNegativeBalance
	3 - Update NP payout = 0 for voided tickets Dot_Member_NetPosition_Void_test (include Dot_Member_NetPosition_Calculation_test at this step)
	4 - If fail to update NP payout, log failed API and stop
	5 - If succeed update NP payout, void ticket
	6 - If fail to void ticket:
	 + call NAP_RollbackCricketList (for list of rollback ticket)
	 + call Dot_Member_NetPosition_UnVoid_test (include Dot_Member_NetPosition_GetQueue_test & Dot_Member_NetPosition_GetSchedule_test)

	run on DBTXN.bodb02
	
	Note:
	- Do not support bettrade
	- Do not proceed send mail to licensee
 */

 declare @TransIds varchar(max)
	, @UserName varchar(30)
	, @Password varchar(50)
	, @UserId int = 0 -- custid of Admin
	, @IP varchar(15)
	, @Reason nvarchar(500) = ''
	, @InvalidTrans nvarchar(max) = ''

 select @TransIds = '???'
	, @UserName = 'sa'
	, @Password = '56E8A2D78170E87C928E480797CC73' --1234aa
	, @UserId= 8
	, @IP = '127.0.0.1'
	, @Reason = 'void ticket manually'
 --replace ticket

 if isnull(@TransIds, '') = '' or isnull(@UserName, '') = '' or isnull(@Password, '') = '' or isnull(@IP, '') = ''
 begin
	select 'Something is wrong. Please check these params: @TransIds, @UserName, @Password & @IP' as 'Failed'
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
exec dbo.NAP_BettransCheckNegativeBalance
	@TransIds = @TransIds,
	@Type = 0, --for delete
	@ExcludeRunning = 0 --need to check

select 'end #2' as '#2'
--==end step 2: check negative balance--=================

--==start step 3: update NP--===============
select 'start #3' as '#3'
 
create table #TicketCricketList (transid bigint, isfinished bit)
declare @TransFailedIds table(transid bigint, msg nvarchar(300))
declare @transid bigint, @ErrCode int, @ErrMsg varchar(300)
  
insert into #TicketCricketList(transid, isfinished)
select transid, 0
from @TicketList where iscricket = 1

while 1 = 1
begin
	update top(1) t
	set @transid = transid
		, isfinished = 1
	from #TicketCricketList t
	where isfinished = 0

	if @@rowcount = 0
	break

	--cal service to update NP
	begin try
	exec dbo.Dot_Member_NetPosition_Void
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

--need to remove some transids which failed to update NP
if exists (select top 1 1 from @TransFailedIds)
begin
	delete @TicketList where transid in (select transid from @TransFailedIds)
	
	--rebuild new list transids
	set @TransIds =  null
	select @TransIds = coalesce(@TransIds + ',' + cast(transid as nvarchar), cast(transid as nvarchar))
	from @TicketList

	select 'Failed to update NP' as 'Failed', * from @TransFailedIds
end
 
select 'end #3' as '#3'
 --==end step 3: update NP--=================

--==start step 4 & 5: void ticket--===============
select 'start #4&5' as '#4_5'

select @ErrCode = 0, @ErrMsg = ''
exec dbo.NAP_BettransSpecialDelBetID_Del @TransIds = @TransIds
	--,@TransIdSolds	VARCHAR(MAX)	= '' -- just for BetTrade's subticket (transid of bettype 901)  
	
	, @UserName = @UserName
	, @Password = @Password
	, @UserId = @UserId
	, @IP = @IP
	, @Reason = @Reason
	
	, @InvalidTrans = @InvalidTrans OUTPUT -- invalid trans of BTrade
	, @ErrCode = @ErrCode OUTPUT
	, @ErrMsg = @ErrMsg OUTPUT

select @InvalidTrans as '@InvalidTrans'

select 'end #4&5' as '#4_5'
--==end step 4 & 5: void ticket--=================

 drop table #TicketCricketList

 go
