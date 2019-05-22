Use bodb_ACC
GO 
/*
Create: 20190522@Sophia
Task : Update Keno to RNG Keno [redmineId: 113490]
DB: DBACC.bodb_ACC
*/



	UPDATE bodb_ACC.dbo.Acc_DWLList 
	SET Product = 'RNG Keno'
	WHERE Product = 'Keno'

	UPDATE bodb_ACC.dbo.Acc_DWLList_xtest
	SET Product = 'RNG Keno'
	WHERE Product = 'Keno'