/*
	Created:
	Task: Get file group
*/
DECLARE @tbl TABLE (Database_Name SYSNAME, File_Group SYSNAME, File_Path VARCHAR(1000))
DECLARE @sql VARCHAR(2000)
SELECT        @sql = 
'
        USE [?]
        SELECT        DB_NAME()                        AS Database_Name
                        , f.name            AS File_Group
                        , d.physical_name   AS File_Name
        FROM sys.filegroups                                f
        INNER JOIN  sys.database_files  d   ON f.data_space_id = d.data_space_id
'
INSERT INTO @tbl
EXEC sp_MSforeachdb @sql

SELECT * FROM @tbl
WHERE Database_Name NOT IN (
        'master', 'tempdb', 'model', 'msdb'
        , 'ReportServer', 'ReportServerTempDB'
        , 'ReportServer$SQLSERVER2008R2', 'ReportServer$SQLSERVER2008R2TempDB')