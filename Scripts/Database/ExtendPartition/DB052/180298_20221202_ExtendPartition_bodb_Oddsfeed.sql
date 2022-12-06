/*<info serverAlias="DB052-bodb_Oddsfeed"></info>*/
/*
	Created: 20221202@Sol
	Task: Extend partition
	DB: DB052-bodb_Oddsfeed
*/

USE bodb_Oddsfeed;

GO
/*
TableName					Schema Name								Function Name							MaxRange
PartnerStatistics			StatisticsYearly_Scheme					StatisticsYearly_PFN					2023-01-01 00:00:00.000
UserLog						UserLogYearly_Scheme					UserLogYearly_PFN						2022-12-31 23:59:59.997
*/

GO

ALTER DATABASE bodb_Oddsfeed ADD FILEGROUP Statistics_2023;
ALTER DATABASE bodb_Oddsfeed ADD FILE (NAME = 'Statistics_2023', FILENAME = 'F:\USER_DB\bodb_oddsfeed\Statistics_2023.ndf', SIZE = 512KB, FILEGROWTH = 3072KB) TO FILEGROUP Statistics_2023;
ALTER PARTITION SCHEME StatisticsYearly_Scheme NEXT USED Statistics_2023;
ALTER PARTITION FUNCTION StatisticsYearly_PFN() SPLIT RANGE ('2024-01-01 00:00:00.000');
ALTER DATABASE bodb_Oddsfeed ADD FILEGROUP Statistics_2024;
ALTER DATABASE bodb_Oddsfeed ADD FILE (NAME = 'Statistics_2024', FILENAME = 'F:\USER_DB\bodb_oddsfeed\Statistics_2024.ndf', SIZE = 512KB, FILEGROWTH = 3072KB) TO FILEGROUP Statistics_2024;
ALTER PARTITION SCHEME StatisticsYearly_Scheme NEXT USED Statistics_2024;
ALTER PARTITION FUNCTION StatisticsYearly_PFN() SPLIT RANGE ('2025-01-01 00:00:00.000');
ALTER DATABASE bodb_Oddsfeed ADD FILEGROUP Statistics_2025;
ALTER DATABASE bodb_Oddsfeed ADD FILE (NAME = 'Statistics_2025', FILENAME = 'F:\USER_DB\bodb_oddsfeed\Statistics_2025.ndf', SIZE = 512KB, FILEGROWTH = 3072KB) TO FILEGROUP Statistics_2025;
ALTER PARTITION SCHEME StatisticsYearly_Scheme NEXT USED Statistics_2025;
ALTER PARTITION FUNCTION StatisticsYearly_PFN() SPLIT RANGE ('2026-01-01 00:00:00.000');

GO 

ALTER DATABASE bodb_Oddsfeed ADD FILEGROUP UserLog_2023;
ALTER DATABASE bodb_Oddsfeed ADD FILE (NAME = 'UserLog_2023', FILENAME = 'F:\USER_DB\bodb_oddsfeed\UserLog_2023.ndf', SIZE = 512KB, FILEGROWTH = 3072KB) TO FILEGROUP UserLog_2023;
ALTER PARTITION SCHEME UserLogYearly_Scheme NEXT USED UserLog_2023;
ALTER PARTITION FUNCTION UserLogYearly_PFN() SPLIT RANGE ('2023-12-31 23:59:59.997');
ALTER DATABASE bodb_Oddsfeed ADD FILEGROUP UserLog_2024;
ALTER DATABASE bodb_Oddsfeed ADD FILE (NAME = 'UserLog_2024', FILENAME = 'F:\USER_DB\bodb_oddsfeed\UserLog_2024.ndf', SIZE = 512KB, FILEGROWTH = 3072KB) TO FILEGROUP UserLog_2024;
ALTER PARTITION SCHEME UserLogYearly_Scheme NEXT USED UserLog_2024;
ALTER PARTITION FUNCTION UserLogYearly_PFN() SPLIT RANGE ('2024-12-31 23:59:59.997');
ALTER DATABASE bodb_Oddsfeed ADD FILEGROUP UserLog_2025;
ALTER DATABASE bodb_Oddsfeed ADD FILE (NAME = 'UserLog_2025', FILENAME = 'F:\USER_DB\bodb_oddsfeed\UserLog_2025.ndf', SIZE = 512KB, FILEGROWTH = 3072KB) TO FILEGROUP UserLog_2025;
ALTER PARTITION SCHEME UserLogYearly_Scheme NEXT USED UserLog_2025;
ALTER PARTITION FUNCTION UserLogYearly_PFN() SPLIT RANGE ('2025-12-31 23:59:59.997');

GO