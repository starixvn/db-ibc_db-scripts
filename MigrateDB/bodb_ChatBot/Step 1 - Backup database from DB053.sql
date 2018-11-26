USE [master]
GO

/*
	Created: 20181120@Percy
	DB: DB053
	Task: Migrate DB053 to DB052 - bodb_ChatBot
		- Step 1: Backup database
*/

DECLARE @databasename VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup file
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name
 
-- specify database backup directory
SET @path = 'C:\Backup\'  
 
-- specify filename format
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112)

-- database name
SELECT @databasename = 'bodb_ChatBot'

-- set file backup name
SET @fileName = @path + @databasename + '_' + @fileDate + '.BAK'

-- output filename
SELECT @fileName AS [fileName]

-- run script to backup
BACKUP DATABASE @databasename TO DISK = @fileName