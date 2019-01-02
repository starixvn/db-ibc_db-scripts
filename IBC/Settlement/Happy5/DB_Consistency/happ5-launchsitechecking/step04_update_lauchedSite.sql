/*
	Created: Vicky
	Task: insert task for Happy5
	DB: DBTP/bodb_Consistency
	Date: 20181218
*/
USE [bodb_Consistency]
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE DBA_Tasks 
SET Command = 'EXEC DBA_Consistency_LaunchedSiteChecking @ProductId=164, @sites=''Indo,KORIBC'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
WHERE TaskId = 31