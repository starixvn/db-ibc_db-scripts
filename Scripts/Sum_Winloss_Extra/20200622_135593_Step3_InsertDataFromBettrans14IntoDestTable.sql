/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
	Created: 20200618@Malcolm
	Task: the script to create data from 2020-05-01 in bettrans14 [Redmine: #135593]
	DB: DBSUM.bodb_Summary
*/

USE bodb_Summary
GO

DECLARE @BalanceUpDay SMALLDATETIME, @MoveBetsDay SMALLDATETIME, @WinlostDate SMALLDATETIME
	SELECT 
		TOP 1 @BalanceUpDay = winlostdate
	FROM bodb02.dbo.Bettrans WITH(NOLOCK)
	WHERE bettype = 20000 and matchid = 0	and custid = 3
	
	SELECT    
		@MoveBetsDay = MAX(eventdate)  
	FROM bodb02.dbo.match14 WITH(NOLOCK)  

SET @WinlostDate = @BalanceUpDay

WHILE @WinlostDate <= @MoveBetsDay
BEGIN
   EXEC dbo.Task_DailySum_Winloss_Extra_CheckData @WinlostDate = @WinlostDate, @ProductIds = '46',@IsCheckDataOnly = 0
   SET @WinlostDate = DATEADD(DAY,1,@WinlostDate)	
END

