use bodb_ACC
go

/*
	Created: 20190701@Percy
	DB: DBACC.bodb_ACC
	Task: Remove WL due to partner - #115802
*/

-- PRO part
	/*
	select *
	from dbo.Acc_DWLList with (nolock)
	where custid in (32131757, 32131917, 35999728, 35999735)
	*/

update dbo.Acc_DWLList with (rowlock)
set IsDeleted = 1
where custid in (32131757, 32131917, 35999728, 35999735)