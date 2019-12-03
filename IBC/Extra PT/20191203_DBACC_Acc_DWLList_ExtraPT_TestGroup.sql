use bodb_ACC
go

/*
	Created: 20191203@Percy
	DB: DBACC.bodb_ACC
	Task: Insert new extra PT group for testing
*/

insert into dbo.Acc_DWLList_ExtraPT (CustId,GroupId,GroupName,IsDisabled)
select 11973923, 50, 'ACCTEST', 0
go

insert into dbo.Acc_DWLList_ExtraPT_xtest (CustId,GroupId,GroupName,IsDisabled)
select 11973927, 50, 'ACCTEST', 0