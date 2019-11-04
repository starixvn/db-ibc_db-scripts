use bodb_Acc
go

/*
	Created: 20191104@Percy
	DB: DBACC.bodb_Acc
	Task: Reset Winning - Remove Microgaming - Live Casino & Microgaming - RNG Casino
*/

update dbo.Acc_DWLList with (rowlock)
set IsDeleted = 1
where ProductId in (13, 17)
go

update dbo.Acc_DWLList_xtest with (rowlock)
set IsDeleted = 1
where ProductId in (13, 17)