use bodb_ACC
go

/*
	Created: 20190725@Percy
	DB: DBACC.bodb_ACC
	Task: Insert dummy account for Card Club - UAT
*/

insert into dbo.Acc_DWLList_xtest (custid, product, seq, ProductId, IsDeleted)
values (37498893, 'Card Club', 39, 34, 0)
go