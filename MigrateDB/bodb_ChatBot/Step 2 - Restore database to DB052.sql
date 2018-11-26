USE [master]
GO

/*
	Created: 20181120@Percy
	DB: DB052
	Task: Migrate DB053 to DB052 - bodb_ChatBot
		- Step 2: Restore database
*/

DECLARE @fileName VARCHAR(256) -- filename for restore  
 
-- set file name from backup Step 1
SET @fileName = ''

-- run script to restore

RESTORE DATABASE bodb_ChatBot
FROM DISK = @fileName
WITH REPLACE
-- ,
-- MOVE '' TO '' -- check if need to move log file