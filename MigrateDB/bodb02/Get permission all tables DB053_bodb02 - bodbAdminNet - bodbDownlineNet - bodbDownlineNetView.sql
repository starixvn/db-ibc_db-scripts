
-- run on DB053.bodb02
SELECT DISTINCT
	t.name AS tableName,
	p.permission_name AS permission,
	dp.default_schema_name,
	dp.name,
	N'	IF (EXISTS (SELECT 1
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = ''' + t.name + '''))
		BEGIN' + CHAR(13) + CHAR(10)
		+ N'GRANT ' + p.permission_name + ' ON ' + CONVERT(VARCHAR(100), t.name) + ' TO ' + CONVERT(VARCHAR(100), dp.name) + ' AS dbo '
		+ 'END'
		+ CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10)
		collate SQL_Latin1_General_CP1_CI_AS
FROM sys.tables t
	INNER JOIN sys.database_permissions      p ON t.OBJECT_ID=p.major_id
    LEFT OUTER JOIN sys.database_principals  dp ON p.grantee_principal_id = dp.principal_id
WHERE
	p.state_desc = 'GRANT'
	AND ISNULL(dp.name, '') NOT IN ('vnteam', 'public')