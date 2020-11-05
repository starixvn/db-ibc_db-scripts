/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Create: 20201105@Sol
	Task: SA Gaming - Re-generate data due to the change from Data batch update from TW - [Redmine: #144902] 
	DB: DBACC-bodb02
*/

USE bodb02;

GO 

EXEC dbo.Task_ResetWinning_ExtraPT14
	@FromDate= @WinlostDate,
	@ToDate = @WinlostDate,
	@Mode = 1

GO