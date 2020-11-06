/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20201105@Sophia
	Task: SA Gaming - Re-generate data due to data patch update epositiontaking [Redmine: #144902] 
	DB: DBTXN-bodb02
*/

USE bodb02
GO 

	
EXEC dbo.Task_sum_winloss_14
	@WinlostDate = '2020-10-31',
	@CustIds = '46093945,45593622'



EXEC dbo.Task_sum_winloss_14
	@WinlostDate = '2020-11-01',
	@CustIds = '46246612'
	
	
GO
 