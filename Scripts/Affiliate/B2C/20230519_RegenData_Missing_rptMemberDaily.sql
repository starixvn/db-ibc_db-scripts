/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G" isFunction="0" isNested="0"></info>*/
/*
	Created: 20230518@Sally
	DB: DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G
	Task: 
	Step 2
		- Regen data 2023-04 into rptMemberDaily		
*/  


DECLARE	@FromDate   SMALLDATETIME = '2023-04-01'
		,@ToDate		SMALLDATETIME = '2023-04-30'
		,@WinlostDate	SMALLDATETIME

	SELECT @WinlostDate = @FromDate
	WHILE  (@WinlostDate <= @ToDate)
	BEGIN
		BEGIN
			EXEC Task_Aff_ImportData @WinlostDate = @WinlostDate
		END	
		SELECT @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
		WAITFOR DELAY '000:00:00.280'
	END

GO
