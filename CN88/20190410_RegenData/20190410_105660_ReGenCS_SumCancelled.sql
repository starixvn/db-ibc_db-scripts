
Use bodb_Summary
GO

/*
Create 20190410@Sophia
Task: Regen data of CN88 [redmine: 105660 ] 
DB: DBSUM.bodb_Summary

*/


 EXEC Task_DailyRptCS_SumCancelled_CheckAndCorrect @WinlostDate = '20190404', @IsCheckDataOnly = 0
 

 EXEC Task_DailyRptCS_SumCancelled_CheckAndCorrect @WinlostDate = '20190405', @IsCheckDataOnly = 0
 

 EXEC Task_DailyRptCS_SumCancelled_CheckAndCorrect @WinlostDate = '20190406', @IsCheckDataOnly = 0
 

 EXEC Task_DailyRptCS_SumCancelled_CheckAndCorrect @WinlostDate = '20190407', @IsCheckDataOnly = 0