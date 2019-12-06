use bodb_ACC
go

/*
	Created: 20191206@Percy
	DB: DBACC.bodb_ACC
	Task: Insert DWL dummy account on UAT
*/

insert into dbo.Acc_DWLList_xtest (custid, product, seq, ProductId, IsDeleted)
select 40075838, 'SG', 40, 36, 0 union all
select 40180814, 'Saba Promotion', 41, 37, 0