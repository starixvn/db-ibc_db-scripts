/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration, permission for web account to access NAP_UserControl - [Redmine:99462]
	SERVER: DBCUST
			
	
*/

-- Create User FOR NAP_UserControl
IF @@SERVERNAME NOT IN ('DBCUST','DB230\SQLSERVER2008R2','DB233','SITDBCUST')
BEGIN
	SELECT 'Must be run on DBCUST' AS 'Error'

	RETURN
END

DECLARE @strUser	VARCHAR(MAX) = ''
DECLARE @tmpAffectedDB TABLE (DBName VARCHAR(50))

INSERT INTO @tmpAffectedDB (DBName)
SELECT name
FROM   sys.databases
WHERE  name = 'NAP_UserControl'


DECLARE @tmpMember TABLE (Name VARCHAR(50))

INSERT INTO @tmpMember (Name) 
VALUES ('bodbAdminNet'), ('BODBDownlineNet'), ('bodbExtAccNet')
	,('BODBDownlineNetView'), ('vnteam')

/*
	USE DBName
	GO 
	CREATE USER vnXXX FOR LOGIN vnXXX WITH DEFAULT_SCHEMA=[dbo] 
	GO
*/
SELECT	@strUser = @strUser 
					+ 'USE ' + d.DBName + ';'
					+ CHAR(13)
					+ 'IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_principals 
										WHERE NAME = ''' + t.Name + ''') 
										AND NOT EXISTS (SELECT 1 FROM sys.database_principals d JOIN sys.server_principals s ON d.sid = s.sid WHERE s.NAME = ''' + t.Name + ''') '
					+ CHAR(13) 
					+ 'BEGIN'
					+ CHAR(13)
								+ 'CREATE USER ' + '[' + t.Name + ']' + ' FOR LOGIN ' + '[' + t.Name + ']' + ' WITH DEFAULT_SCHEMA=[dbo] ' + ';'
								+ CHAR(13)
								+ 'ALTER USER' + '[' + t.Name + ']' + ' WITH DEFAULT_SCHEMA=[dbo]' + ';'
					+ CHAR(13) 
					+ 'END'
					+ CHAR(13) 
					+ 'ELSE'
					+ CHAR(13)
						+ 'PRINT DB_NAME() + ''.[' + t.Name + ']'' ' + CHAR(13)
FROM	@tmpAffectedDB d
	CROSS APPLY (
		SELECT	t.Name
		FROM	@tmpMember t
	) t
--PRINT @strUser
EXEC (@strUser)

GO

-------------------------------------------
-------------------------------------------
-- Add Role for member

IF @@SERVERNAME NOT IN ('DBCUST','DB230\SQLSERVER2008R2','DB233','SITDBCUST')
BEGIN
	SELECT 'Must be run on DBCUST' AS 'Error'

	RETURN
END

DECLARE @strUser VARCHAR(MAX) = ''
		,@RoleName VARCHAR(50) = 'db_datareader'

DECLARE @tmpMember TABLE (Name VARCHAR(50))
DECLARE @tmpAffectedDB TABLE (DBName VARCHAR(50))

INSERT INTO @tmpAffectedDB (DBName)
SELECT name
FROM   sys.databases
WHERE  name = 'NAP_UserControl'

INSERT INTO @tmpMember (Name) 
	VALUES ('bodbAdminNet'), ('BODBDownlineNet'), ('bodbExtAccNet')
	,('BODBDownlineNetView'), ('vnteam')

/*
	USE DBName
	GO
	EXEC sp_AddRoleMember 'db_xxx', 'vnxxx'
	GO
*/
SELECT	@strUser = @strUser
					+ 'USE ' + d.DBName + ';'
					+ CHAR(13)
					+ 'IF EXISTS (SELECT TOP 1 1 FROM sys.database_principals WHERE NAME = ''' + t.Name + ''') '
					+ CHAR(13)
					+ 'EXEC sp_AddRoleMember ''' + @RoleName + ''',''' + t.Name + ''' ' + ';'
					+ CHAR(13) + 'ELSE'
					+ CHAR(13)
					+ 'PRINT DB_NAME() + ''.[' + t.Name + ']''' + CHAR(13)
FROM	@tmpAffectedDB d
	CROSS APPLY (
		SELECT Name
		FROM @tmpMember 
	)t
--print @strUser
EXEC (@strUser)

GO