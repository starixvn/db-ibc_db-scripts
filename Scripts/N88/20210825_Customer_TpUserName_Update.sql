/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20210825@Percy
	DB: DBN88-bodb_N88
	Task: Update TpUserName manually
	https://nexdev.net/issues/160657
*/
use bodb_N88
go

declare @i smallint = 1, @msg varchar(1000)

while 1 = 1
begin
	select @msg = 'start batch: ' + convert(varchar(10), @i)
	raiserror (@msg, 1, 0) with nowait

	update top (5000) c with (rowlock)
	set c.TpUserName = case c.SiteId when 1 then 'Nova88_' when 2 then 'Goal123_' else 'Bwing_' end
						+ convert(varchar(20), c.CustId)
	from dbo.Customer c
	where c.TpUserName is null

	if @@rowcount < 5000
		break

	waitfor delay '00:00:00.280'
end