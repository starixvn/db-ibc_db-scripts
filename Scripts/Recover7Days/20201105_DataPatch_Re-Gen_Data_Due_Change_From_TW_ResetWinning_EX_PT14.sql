/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Create: 20201105@Sol
	Task: SA Gaming - Re-generate data due to the change from Data batch update from TW - [Redmine: #144902] 
	DB: DBACC-bodb02
*/

USE bodb02
GO 


-----reset winning

EXEC dbo.Acc_ResetWinning_SelByDate14
   @Winlostdate = '2020-10-29',
   @Mode = 1 
   
EXEC dbo.Acc_ResetWinning_SelByDate14
   @Winlostdate = '2020-10-31',
   @Mode = 1 

EXEC dbo.Acc_ResetWinning_SelByDate14
   @Winlostdate = '2020-11-01',
   @Mode = 1 

-----reset extraPT


EXEC dbo.Task_ResetWinning_ExtraPT14
	@FromDate= '2020-10-29',
	@ToDate = '2020-10-29',
	@Mode = 1


EXEC dbo.Task_ResetWinning_ExtraPT14
	@FromDate= '2020-10-31',
	@ToDate = '2020-10-31',
	@Mode = 1
	
EXEC dbo.Task_ResetWinning_ExtraPT14
	@FromDate= '2020-11-01',
	@ToDate = '2020-11-01',
	@Mode = 1	
	
GO