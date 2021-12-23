/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
Create: 20221222@Sophia
Task: Joker - Re-generate data due to data patch update epositiontaking [Redmine: #166443] 
DB: DBARC.bodb_Archive

*/

 use bodb_Archive
 
------------------------------EXCUTE SP----------------------------------------------

TRUNCATE TABLE [sum_winloss_old_tmp]

EXEC 	bodb02.dbo.Task_sum_winloss_Old  
		@WinlostDate = '2021-12-14',
		@CustIds = '56475760' 
	
EXEC 	bodb02.dbo.Task_sum_winloss_Old
		@WinlostDate = '2021-12-15',
		@CustIds = '53634893,58703902,33655935,56475760'
	