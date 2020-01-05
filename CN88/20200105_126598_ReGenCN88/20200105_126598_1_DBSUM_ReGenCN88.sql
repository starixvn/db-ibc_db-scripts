
/*
created: 20200105@Sophia:
Task: ReGen Sum data [Redmine: #126598]

*/
-----------------------------------------
----#1. DB : DBSUM.bodb_Summary 

DECLARE @WinlostDate SMALLDATETIME = '2020-01-02'

WHILE  @WinlostDate <= '2020-01-04'
BEGIN

	EXEC dbo.Task_CS_SumWinloss
	   @WinlostDate = @WinlostDate
	  
	EXEC dbo.Task_CS_SumCancelled
	   @WinlostDate = @WinlostDate
	
	SELECT @WinlostDate = DATEADD (DD, 1, @WinlostDate)    
END
   