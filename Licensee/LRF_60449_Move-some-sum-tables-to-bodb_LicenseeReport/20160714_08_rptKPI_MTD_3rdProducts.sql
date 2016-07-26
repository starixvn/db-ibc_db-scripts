use bodb_LicenseeReport
go
/*
	Task: rptKPI_MTD_3rdProducts table:
		- Create partitions
		- Create table with data compression on page level
		- Create index with data compression on page level
*/
SET NOCOUNT ON
DECLARE @MinPartitionRange DATETIME, @MaxPartitionRange DATETIME
	, @Temp DATETIME, @SqlCmd VARCHAR(MAX), @Prefix VARCHAR(50)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255), @PathFile2 VARCHAR(255)

SELECT @MinPartitionRange = '2012-01-01'
	, @MaxPartitionRange = '2018-12-31'
	, @PathFile = 'E:\IBC_DB\bodb_LicenseeReport\rptKPI_MTD_3rdProducts\'
	, @PathFile2 = 'D:\IBC_DB\bodb_LicenseeReport\rptKPI_MTD_3rdProducts\'
	, @Prefix = 'rptKPI_MTD_3rdProducts'
SET @Temp = @MinPartitionRange

WHILE @MaxPartitionRange > @MinPartitionRange
BEGIN
	SELECT @Temp = DATEADD(MINUTE, - 1, DATEADD(yy, 0, DATEADD(yy, DATEDIFF(yy, 0, @MinPartitionRange) + 1, 0)))

	--SELECT @Temp AS '@Temp'
	--print convert(varchar(100), @Temp, 121)
	--PRINT @Temp
	SET @SqlCmd = ''
	SELECT @FileGroupName = @Prefix + '_' + CAST(RIGHT(YEAR(@Temp), 2) AS VARCHAR(2)) 
								+ 'M' + CAST(RIGHT('00' + CAST(MONTH(@Temp) AS VARCHAR(2)), 2) AS VARCHAR(2))

	--print @FileGroupName
	----create file group
	SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
	PRINT @SqlCmd
	EXEC (@SqlCmd)

	----assign file group
	SET @SqlCmd = ''
	SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
			+ ''', FILENAME = N''' + CASE WHEN YEAR(@Temp) % 2 = 0 THEN @PathFile ELSE @PathFile2 END + @FileGroupName + '.ndf''
			, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
	PRINT @SqlCmd
	EXEC (@SqlCmd)
	
	SET @MinPartitionRange = DATEADD(YEAR, 1, @MinPartitionRange)
END

----create max group file
SET @FileGroupName = @Prefix + '_MAX'
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)
--print @FileGroupName
SET @SqlCmd = ''
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
	+ ''', FILENAME = N''' + @PathFile + @FileGroupName + '.ndf''
	, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

--create parrtition function
CREATE PARTITION FUNCTION [pf_rptKPI_MTD_3rdProducts_yearly](DATETIME) AS RANGE LEFT FOR VALUES (N'2012-12-31 23:59:00.000', N'2013-12-31 23:59:00.000', N'2014-12-31 23:59:00.000', N'2015-12-31 23:59:00.000', N'2016-12-31 23:59:00.000', N'2017-12-31 23:59:00.000', N'2018-12-31 23:59:00.000')
GO

--create partition schema
CREATE PARTITION SCHEME [ps_rptKPI_MTD_3rdProducts_yearly] AS PARTITION [pf_rptKPI_MTD_3rdProducts_yearly] TO ([rptKPI_MTD_3rdProducts_12M12], [rptKPI_MTD_3rdProducts_13M12], [rptKPI_MTD_3rdProducts_14M12], [rptKPI_MTD_3rdProducts_15M12], [rptKPI_MTD_3rdProducts_16M12], [rptKPI_MTD_3rdProducts_17M12], [rptKPI_MTD_3rdProducts_18M12], [rptKPI_MTD_3rdProducts_MAX])
GO

CREATE TABLE [dbo].[rptKPI_MTD_3rdProducts](
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[StatID] [int] NOT NULL,
	[Bettype] [int] NOT NULL,
	[MonthToDate] [float] NULL,
 CONSTRAINT [PK_rptKPI_MTD_3rdProducts] PRIMARY KEY CLUSTERED 
(
	[rptDate] ASC,
	[SiteID] ASC,
	[CurrencyID] ASC,
	[StatID] ASC,
	[Bettype] ASC
)WITH (DATA_COMPRESSION = PAGE)
) ON [ps_rptKPI_MTD_3rdProducts_yearly]([rptDate])
