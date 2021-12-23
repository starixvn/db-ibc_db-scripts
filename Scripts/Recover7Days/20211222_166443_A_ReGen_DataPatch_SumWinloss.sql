/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20221222@Sophia
	Task: Joker - Re-generate data due to data patch update epositiontaking [Redmine: #166443] 
	DB: DBTXN-bodb02
*/

USE bodb02
GO 

	
EXEC dbo.Task_sum_winloss_14
	@WinlostDate = '2021-12-14',
	@CustIds = '56475760'

	
EXEC dbo.Task_sum_winloss_14
	@WinlostDate = '2021-12-15',
	@CustIds = '53634893,58703902,33655935,56475760'
	
GO
  