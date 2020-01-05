
/*
created: 20200105@Sophia:
Task: ReGen Sum data [Redmine: #126598]

*/
 ------------------------------------
 -----#2. DBACC.bodb02

DECLARE @WinlostDate SMALLDATETIME = '2020-01-02'

WHILE  @WinlostDate <= '2020-01-04'
BEGIN

	EXEC dbo.Task_CS_HeadlineBalance
	   @Winlostdate = @Winlostdate,
	   @IsCheckDataOnly = 0   
	
	SELECT @WinlostDate = DATEADD (DD, 1, @WinlostDate)   
	
END 