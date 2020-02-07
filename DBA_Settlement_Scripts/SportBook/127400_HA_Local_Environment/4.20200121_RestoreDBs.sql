CREATE PROC DBA_Task_LocalDatabaseRestore
(
    @filePath VARCHAR(500) = '\\nas\bk_db\db230\',
    @listDatabases VARCHAR(MAX) = '',
    @isTest BIT = 1
)
AS
/*  Creator: Sol
    Date: 20200117
    Task: Backup database
    DB: Alls
    Original: 
    
    Revisions:
        - 20200117@Sol: Restore database [Redmine: #00000]

    Param's Explanation:
        - @filePath: the path where is used to storage database backup file
        - @listDatabases: list of database need to backup, seperate by a comma
        - @isTest: 0 to show the path, 1 to backup to specific path
*/ 
BEGIN

    SET NOCOUNT ON;

    DECLARE @serverName VARCHAR(200) -- server name
    DECLARE @name VARCHAR(50) -- database name  
    DECLARE @fileName VARCHAR(256) -- filename for backup  
    DECLARE @fileDate VARCHAR(20) -- used for file name
    DECLARE @dirTree TABLE (subdirectory nvarchar(255), depth INT) -- check existing folder
    DECLARE @folderName VARCHAR(500) -- folder to store backup file

    -- correct filePath
    SET @filePath = CASE WHEN RIGHT(@filePath,1) = '\' THEN @filePath ELSE @filePath + '\' END

    -- specify filename format
    SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

    -- server name
    SELECT @serverName = @@SERVERNAME

    -- get sub-folder into temp table
    INSERT INTO @dirTree(subdirectory, depth)
    EXEC master.sys.xp_dirtree @filePath 

    -- loop throught all databases
    DECLARE db_cursor CURSOR READ_ONLY FOR  
    SELECT name
    FROM master.sys.databases
    WHERE name IN (SELECT Val FROM f_SplitString(@listDatabases,',')) 
        AND state = 0 -- database is online
        AND is_in_standby = 0 -- database is not read only for log shipping

    OPEN db_cursor
    FETCH NEXT FROM db_cursor INTO @name

    WHILE @@FETCH_STATUS = 0   
    BEGIN

        -- check folder and create if need
        SET @folderName = @filePath + @name
        IF NOT EXISTS (SELECT 1 FROM @dirTree WHERE subdirectory = @name)
        BEGIN
            EXEC master.dbo.xp_create_subdir @folderName
        END

        SET @fileName = @filePath + @name + '\' + @serverName + '_' + @name + '.BAK'
    
        IF (@isTest = 0)
        BEGIN
            INSERT INTO tracking(username,dtime,tp,sqltext,hostname,affectedRows,transid,matchid)   
            SELECT 'SPVN\helen.do', GETDATE(), 'S', 'RESTORE DATABASE ' + @name + 'FROM DISK = ' + @fileName, @serverName, NULL, NULL, NULL  
              
            RESTORE DATABASE @name FROM DISK = @fileName 
  
            INSERT INTO tracking(username,dtime,tp,sqltext,hostname,affectedRows,transid,matchid)   
            SELECT 'SPVN\helen.do', GETDATE(), 'F', 'RESTORE DATABASE ' + @name + 'FROM DISK = ' + @fileName, @serverName, NULL, NULL, NULL
        END
        ELSE 
        BEGIN  
            SELECT @fileName  
            INSERT INTO tracking(username,dtime,tp,sqltext,hostname,affectedRows,transid,matchid)   
            SELECT 'SPVN\helen.do', GETDATE(), 'F', 'RESTORE DATABASE ' + @name + 'FROM DISK = ' + @fileName, @serverName, NULL, NULL, NULL  
        END

        FETCH NEXT FROM db_cursor INTO @name

    END

    CLOSE db_cursor
    DEALLOCATE db_cursor
END
GO