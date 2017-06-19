USE master
GO
/*
	Setup new aff for Affiliate_Bolanation]
	1- Full backup [Affiliate_Athena000] database
*/
DECLARE @fileName VARCHAR(255), @backupPath VARCHAR(128), @serverName VARCHAR(50), @databaseName VARCHAR(50), @Date VARCHAR(20)
SELECT @backupPath = 'G:\___Tmp'
	, @serverName = @@SERVERNAME
	, @databaseName = 'Affiliate_Athena000'
	, @Date = CONVERT(VARCHAR(10), GETDATE(), 112)

SET @fileName = @backupPath + '\' + @serverName + '.' + @databaseName + '_' + @Date + '.bak' 
BACKUP DATABASE @databaseName TO DISK = @fileName  WITH FORMAT, COPY_ONLY, INIT, COMPRESSION

GO