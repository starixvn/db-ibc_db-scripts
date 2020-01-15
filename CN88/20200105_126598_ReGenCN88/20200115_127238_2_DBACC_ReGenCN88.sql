
/*
created: 20200105@Sophia:
Task: ReGen Sum data on 2020-01-14 [Redmine: #127238]

*/
 ------------------------------------
 -----#2. DB061.bodb02 only

DECLARE @WinlostDate SMALLDATETIME = '2020-01-14'
 
BEGIN

	EXEC dbo.Task_CS_HeadlineBalance
	   @Winlostdate = @Winlostdate,
	   @IsCheckDataOnly = 0   	 
	
END 