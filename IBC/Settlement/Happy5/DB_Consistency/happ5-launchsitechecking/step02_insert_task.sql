/*
	Created: Vicky
	Task: insert task for Happy5
	DB: DBTP/bodb_Consistency
	Date: 20181218
*/
USE [bodb_Consistency]
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------
SET IDENTITY_INSERT DBA_Tasks ON

INSERT INTO DBA_Tasks (TaskId, RuleId, Command)
VALUES
	--PT
	 (31,17,'EXEC DBA_Consistency_LaunchedSiteChecking @ProductId=164, @sites=''Indo,KORIBC'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
SET IDENTITY_INSERT DBA_Tasks OFF