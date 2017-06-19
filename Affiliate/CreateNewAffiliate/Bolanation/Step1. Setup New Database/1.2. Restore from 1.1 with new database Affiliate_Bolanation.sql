
/*
	Setup new aff for Affiliate_Bolanation]
	2- Restore db with name [Affiliate_Bolanation]
*/
USE master
GO

--//#2
declare @table table (
	LogicalName nvarchar(1000), 
	PhysicalName nvarchar(1000), 
	Type varchar(10), 
	FileGroupName varchar(1000),
	Size varchar(100),
	MaxSize varchar(100),
	FileId varchar(10),
	CreateLSN varchar(1000), 
	DropLSN varchar(1000),
	UniqueId varchar(1000),
	ReadOnlyLSN varchar(100),
	ReadWriteLSN varchar(100),
	BackupSizeInBytes varchar(100),
	SourceBlockSize varchar(100),
	FileGroupId varchar(100),
	LogGroupGUID varchar(100),
	DifferentialBaseLSN varchar(1000),
	DifferentialBaseGUID varchar(1000),
	IsReadOnly varchar(100),
	IsPresent varchar(10),
	TDEThumbprint varchar(10)
	)

INSERT INTO @table
EXEC('RESTORE filelistonly FROM disk = ''G:\___Tmp\DBAFF.Affiliate_Athena000_20170619.bak''')
SELECT 'RESTORE DATABASE Affiliate_Bolanation FROM DISK = N''G:\___Tmp\DBAFF.Affiliate_Athena000_20170619.bak'' ',''
UNION ALL
SELECT 'WITH NORECOVERY, FILE = 1,',''
UNION ALL
SELECT 'MOVE N''' + LogicalName + '''' , ' TO N''' + REPLACE(PhysicalName,'G:\IBC_DB\Affiliate_Athena000\', 'G:\IBC_DB\Affiliate_Bolanation\') + ''','
FROM @table
UNION ALL
SELECT '  NOUNLOAD, STATS = 10', ''

GO
