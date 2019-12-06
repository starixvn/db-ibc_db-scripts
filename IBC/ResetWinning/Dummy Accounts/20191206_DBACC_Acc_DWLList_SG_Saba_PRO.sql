use bodb_ACC
go

/*
	Created: 20191206@Percy
	DB: DBACC.bodb_ACC
	Task: Insert DWL dummy account on PRO
*/

insert into dbo.Acc_DWLList (custid, product, seq, ProductId, IsDeleted)
select 40069250, 'SG', 40, 36, 0 union all
select 40180941, 'Saba Promotion', 41, 37, 0