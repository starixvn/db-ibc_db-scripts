use bodb_ACC
go

/*
	Created: 20190701@Percy
	DB: DBACC.bodb_ACC
	Task: Remove WL due to partner - #115802
*/

-- UAT part
	/*
	select *
	from dbo.Acc_DWLList_xtest with (nolock)
	where custid in (32131993, 32132063, 35883280, 35898466)
	*/

update dbo.Acc_DWLList_xtest with (rowlock)
set IsDeleted = 1
where custid in (32131993, 32132063, 35883280, 35898466)