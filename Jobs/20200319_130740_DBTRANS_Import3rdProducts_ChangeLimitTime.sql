USE [msdb]
GO

/*
	Created: 20200319@Percy
	DB: DBTRANS
	Task: Change limit time from 3:00AM to 1:45AM
	RedmineID: #130740
*/

EXEC dbo.sp_update_jobstep
		@job_name=N'bodb02: Licensee Winloss AG GD VG',
		@step_name=N'Check data ready or not', 
		@step_id=1, 
		@subsystem=N'TSQL', 
		@command=N'SET NOCOUNT ON
DECLARE @WinlostDate SMALLDATETIME
    , @LimitTime VARCHAR(8)
    , @CurrentTime TIME
    , @IsReady BIT
    , @ErrrMessage VARCHAR(100)

SELECT GETDATE()
SELECT @WinlostDate = CONVERT(VARCHAR(10), DATEADD(dd, -1, GETDATE()), 112)
    , @CurrentTime = CONVERT(VARCHAR(8), GETDATE(), 114)
    , @LimitTime = ''01:45:00''

IF EXISTS (SELECT 1
				FROM bodb02.dbo.bettrans WITH(NOLOCK)
				WHERE winlostdate = @WinlostDate AND bettype IN (1700, 1800, 1900, 8000))
BEGIN
    SET @ErrrMessage = ''* already generated data for winlostdate: '' + CONVERT(VARCHAR(10), @WinlostDate, 112) + '' *''
    RAISERROR (@ErrrMessage, -- Message text.
               16, -- Severity.
               1 -- State.
               );
END

WHILE @CurrentTime < @LimitTime
BEGIN
    
    EXEC DBLIC.bodb_licensee.dbo.Task_DEP_SeparatedWallet_Data_Check @WinlostDate = @WinlostDate
	   , @IsReady = @IsReady OUTPUT

    IF @IsReady = 1
    BEGIN
	   BREAK
    END
    ELSE
    BEGIN
	   SET @ErrrMessage = ''* data not ready yet for winlostdate: '' + CONVERT(VARCHAR(10), @WinlostDate, 112) + '' *''
	   RAISERROR(@ErrrMessage, 0, 0) WITH NOWAIT
    END

    WAITFOR DELAY ''00:10:00''
    SELECT @CurrentTime = CONVERT(VARCHAR(8), GETDATE(), 114)
END
', 
		@database_name=N'bodb02'
