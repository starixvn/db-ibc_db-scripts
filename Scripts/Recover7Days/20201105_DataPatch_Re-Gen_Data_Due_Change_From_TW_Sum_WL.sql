/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20201105@Sol
	Task: SA Gaming - Re-generate data due to the change from Data batch update from TW - [Redmine: #144902] 
	DB: DBTXN-bodb02
*/

USE bodb02;

GO 

EXEC dbo.Task_sum_winloss_14
	@WinlostDate = '2020-10-29',
	@CustIds = '46093945'
	
	
EXEC dbo.Task_sum_winloss_14
	@WinlostDate = '2020-10-31',
	@CustIds = '46093945,45593622'



EXEC dbo.Task_sum_winloss_14
	@WinlostDate = '2020-11-01',
	@CustIds = '46246612'
	
	
GO
 