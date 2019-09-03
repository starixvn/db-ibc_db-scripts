
/*

CREATED: 20190903@Sophia
DB: DBAGE.bodb_Summary 
Task: Adjust effective date of new Headline's PT - regen CS_SumWinloss [redmine: 119579]  
*/

---------- bettrans14 range
EXEC Task_DailyRptCS_SumWinloss_CheckAndCorrect 
	@WinlostDate  = '2019-08-28'
	@IsCheckDataOnly = 0 
	
EXEC Task_DailyRptCS_SumWinloss_CheckAndCorrect 
	@WinlostDate  = '2019-08-29'
	@IsCheckDataOnly = 0 
	
EXEC Task_DailyRptCS_SumWinloss_CheckAndCorrect 
	@WinlostDate  = '2019-08-30'
	@IsCheckDataOnly = 0 

----------Bettrans ranage 

EXEC Task_DailyRptCS_SumWinloss 
	@WinlostDate  = '2019-08-31'
 
 
EXEC Task_DailyRptCS_SumWinloss 
	@WinlostDate  = '2019-09-01'
 
 
 
EXEC Task_DailyRptCS_SumWinloss 
	@WinlostDate  = '2019-09-02'
 