/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20220613@Evan
	DB: DB053-bodb_LicenseeReport
	Task: New table rptLicenseeWinloss [Redmine: #172604]
	Step 1: New file group & partition by year
*/

USE bodb_LicenseeReport
GO

--- Create the filegroups:
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_12
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_13
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_14
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_15
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_16
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_17
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_18
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_19
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_20
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_21
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_22
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_23
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_24
ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP rptLicenseeWinloss_MAX
GO

--- Add files to the filegroups:
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_12 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_12.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_12]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_13 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_13.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_13]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_14 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_14.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_14]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_15 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_15.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_15]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_16 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_16.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_16]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_17 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_17.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_17]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_18 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_18.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_18]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_19 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_19.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_19]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_20 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_20.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_20]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_21 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_21.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_21]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_22 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_22.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_22]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_23 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_23.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_23]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_24 , FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_24.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_24]
ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = rptLicenseeWinloss_MAX, FILENAME = 'F:/User_DB/bodb_LicenseeReport/rptLicenseeWinloss_MAX.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [rptLicenseeWinloss_MAX]
GO

--- Create the partition function:
CREATE PARTITION FUNCTION [PF_rptLicenseeWinloss_Yearly](DATETIME) AS
RANGE LEFT FOR VALUES
(
    N'2012-12-31 23:59:59.997',
    N'2013-12-31 23:59:59.997',
    N'2014-12-31 23:59:59.997',
    N'2015-12-31 23:59:59.997',
    N'2016-12-31 23:59:59.997',
    N'2017-12-31 23:59:59.997',
    N'2018-12-31 23:59:59.997',
    N'2019-12-31 23:59:59.997',
    N'2020-12-31 23:59:59.997',
    N'2021-12-31 23:59:59.997',
    N'2022-12-31 23:59:59.997',
    N'2023-12-31 23:59:59.997',
	N'2024-12-31 23:59:59.997'
)
GO

--- Create the partition scheme:
CREATE PARTITION SCHEME [PS_rptLicenseeWinloss_Yearly] AS PARTITION [PF_rptLicenseeWinloss_Yearly] TO
(
    rptLicenseeWinloss_12,
	rptLicenseeWinloss_13,
	rptLicenseeWinloss_14,
	rptLicenseeWinloss_15,
	rptLicenseeWinloss_16,
    rptLicenseeWinloss_17,
    rptLicenseeWinloss_18,
    rptLicenseeWinloss_19,
    rptLicenseeWinloss_20,
    rptLicenseeWinloss_21,
    rptLicenseeWinloss_22,
    rptLicenseeWinloss_23,
	rptLicenseeWinloss_24,
    rptLicenseeWinloss_MAX
)
GO