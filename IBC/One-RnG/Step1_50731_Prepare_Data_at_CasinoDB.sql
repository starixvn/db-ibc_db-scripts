use CasinoAdmin
go
/*
	this script copy data for CustWinlimit of ONE-RnG
	delete from dbo.CustLossLimitTmp
*/
-- BEGIN STEP 1: Prepare structure--------------------
------------------------------------------------------
set nocount on
create table dbo.CustLossLimitTmp (CustId int primary key, IsAutoReset bit, MaxLossLimit money) --on [DATA]

-- END STEP 1: Prepare structure--------------------
------------------------------------------------------
go

-- BEGIN STEP 2: Prepare data------------------------
------------------------------------------------------

create table #supers (rowindex int identity(1,1), custid int)

insert into #supers(custid)
select CustID from dbo.Customer with(nolock) where roleid = 4

declare @rowindex int, @srecommend int
set @rowindex = 1

while exists (select 1 from #supers where rowindex = @rowindex)
begin

	select @srecommend = custid from #supers where rowindex = @rowindex
	set @rowindex = @rowindex + 1
	
	insert into dbo.CustLossLimitTmp(custid, IsAutoReset, MaxLossLimit)
	(
		--super
		select cc.IBCCustID, cs.IsAutoReset, isnull(MaxTransferCredit, 0)
		from dbo.Customer cc with(nolock)
			inner join dbo.CustSetting cs with(nolock) on cc.custid = cs.CustSettingID
		where cc.CustID = @srecommend

		union all
		--all downline by @srecommend
		select cc.IBCCustID, cs.IsAutoReset, isnull(MaxTransferCredit, 0)
		from dbo.Customer cc with(nolock)
			inner join dbo.CustSetting cs with(nolock) on cc.custid = cs.CustSettingID
		where cc.SAgentID = @srecommend and IBCCustID is not null
		group by cc.IBCCustID, cs.IsAutoReset, isnull(MaxTransferCredit, 0)
	)
end

drop table #supers
go

-- END STEP 2: Prepare data------------------------
------------------------------------------------------
