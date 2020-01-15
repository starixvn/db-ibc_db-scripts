
/*
created: 20200115@Sophia
Task: ReGen Sum data on 20200114 [Redmine: #127238]

*/
-----------------------------------------
----#1. DB : DBSUM.bodb_Summary 

DECLARE @WinlostDate SMALLDATETIME = '2020-01-14'
 
BEGIN

	EXEC dbo.Task_CS_SumWinloss
	   @WinlostDate = @WinlostDate
	  
	EXEC dbo.Task_CS_SumCancelled
	   @WinlostDate = @WinlostDate
	 
END
   