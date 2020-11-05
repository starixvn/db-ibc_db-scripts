/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20201105@Sol
	Task: SA Gaming - Re-generate data due to the change from Data batch update from TW - [Redmine: #144902] 
	DB: DBTXN-bodb02
*/

USE bodb02;

GO 

EXEC dbo.Task_sum_winloss_14
	@WinlostDate = @WinlostDate,
	@CustIds = @CustIds

GO

EXEC dbo.Task_Sum_Winloss @winlostdate

GO