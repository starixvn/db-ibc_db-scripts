/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220314@Percy
	DB: DBRPT-bodb_Report
	Task: New table Statement_Accum [RedmineID: #169560]
		Step 1: New file group & partition by year
*/

USE bodb_Report
GO

-- add file group
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_12
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_13
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_14
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_15
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_16
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_17
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_18
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_19
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_20
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_21
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_22
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_23
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_24
ALTER DATABASE bodb_Report ADD FILEGROUP Statement_Accum_MAX
GO

-- add file name
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_12 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_12.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_12]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_13 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_13.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_13]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_14 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_14.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_14]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_15 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_15.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_15]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_16 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_16.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_16]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_17 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_17.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_17]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_18 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_18.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_18]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_19 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_19.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_19]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_20 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_20.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_20]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_21 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_21.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_21]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_22 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_22.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_22]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_23 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_23.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_23]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_24 , FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_24.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_24]
ALTER DATABASE bodb_Report ADD FILE (NAME = Statement_Accum_MAX, FILENAME = '/mnt/DiskG/bodb_Report/Statement_Accum_MAX.ndf', SIZE = 1024 KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1024 KB) TO FILEGROUP [Statement_Accum_MAX]
GO

-- Create partition function
CREATE PARTITION FUNCTION [PF_Statement_Accum_Yearly](DATETIME) AS
RANGE LEFT FOR VALUES
(
    N'2012-12-31',
    N'2013-12-31',
    N'2014-12-31',
    N'2015-12-31',
    N'2016-12-31',
    N'2017-12-31',
    N'2018-12-31',
    N'2019-12-31',
    N'2020-12-31',
    N'2021-12-31',
    N'2022-12-31',
    N'2023-12-31',
	N'2024-12-31'
)
GO

-- create partition schema
CREATE PARTITION SCHEME [PS_Statement_Accum_Yearly] AS PARTITION [PF_Statement_Accum_Yearly] TO
(
    Statement_Accum_12,
	Statement_Accum_13,
	Statement_Accum_14,
	Statement_Accum_15,
	Statement_Accum_16,
    Statement_Accum_17,
    Statement_Accum_18,
    Statement_Accum_19,
    Statement_Accum_20,
    Statement_Accum_21,
    Statement_Accum_22,
    Statement_Accum_23,
	Statement_Accum_24,
    Statement_Accum_MAX
)
GO