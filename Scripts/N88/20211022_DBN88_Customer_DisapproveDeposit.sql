/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20211022@Percy
	DB: DBN88-bodb_N88
	Task: Manually update data for first deposit due to disapprove deposit
*/
use bodb_N88
go

-- 6 rows
update c
set c.FirstDepositDate = null, c.FirstDepositAmount = null, c.UpdatedTime = getdate()
from dbo.Customer c with (rowlock)
where c.FirstDepositDate is not null
	and not exists (
		select 1 from dbo.DepositInfo d with (rowlock)
		where c.CustId = d.CustId and d.FirstDeposit = 1 and d.Status = 3
	)