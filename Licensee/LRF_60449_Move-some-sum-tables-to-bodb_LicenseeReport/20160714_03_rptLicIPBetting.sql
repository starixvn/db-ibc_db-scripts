use bodb_LicenseeReport
go
/*
	Task: rptLicIPBetting table:
		- Create partitions
		- Create table with data compression on page level
		- Create index with data compression on page level
*/

DECLARE @MinPartitionRange DATETIME, @MaxPartitionRange DATETIME
	, @Temp DATETIME, @SqlCmd VARCHAR(MAX), @Prefix VARCHAR(50)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255), @PathFile2 VARCHAR(255)

SELECT @MinPartitionRange = '2010-01-31'
	, @MaxPartitionRange = '2016-12-31'
	, @PathFile = 'E:\IBC_DB\bodb_LicenseeReport\rptLicIPBetting\'
	, @PathFile2 = 'D:\IBC_DB\bodb_LicenseeReport\rptLicIPBetting\'
	, @Prefix = 'rptLicIPBetting'
SET @Temp = @MinPartitionRange

WHILE @MaxPartitionRange > @MinPartitionRange
BEGIN
	SELECT @Temp = DATEADD(MINUTE, - 1, DATEADD(mm, DATEDIFF(m, 0, @MinPartitionRange) + 1, 0))
	--SELECT @Temp AS '@Temp'
	SET @SqlCmd = ''
	SELECT @FileGroupName = @Prefix + '_' + CAST(RIGHT(YEAR(@Temp), 2) AS VARCHAR(2)) 
								+ 'M' + CAST(RIGHT('00' + CAST(MONTH(@Temp) AS VARCHAR(2)), 2) AS VARCHAR(2))

	--create file group
	SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
	PRINT @SqlCmd
	EXEC (@SqlCmd)

	--assign file group
	SET @SqlCmd = ''
	SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
			+ ''', FILENAME = N''' + CASE WHEN MONTH(@Temp) % 2 = 0 THEN @PathFile ELSE @PathFile2 END + @FileGroupName + '.ndf''
			, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
	PRINT @SqlCmd
	EXEC (@SqlCmd)
	
	SET @MinPartitionRange = DATEADD(MM, 1, @MinPartitionRange)
END

--create max group file
SET @FileGroupName = @Prefix + '_MAX'
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

SET @SqlCmd = ''
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
	+ ''', FILENAME = N''' + @PathFile + @FileGroupName + '.ndf''
	, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

--create parrtition function
CREATE PARTITION FUNCTION [pf_rptLicIPBetting_monthly](smalldatetime) AS RANGE LEFT FOR VALUES (N'2010-01-31T23:59:00.000', N'2010-02-28T23:59:00.000', N'2010-03-31T23:59:00.000', N'2010-04-30T23:59:00.000', N'2010-05-31T23:59:00.000', N'2010-06-30T23:59:00.000', N'2010-07-31T23:59:00.000', N'2010-08-31T23:59:00.000', N'2010-09-30T23:59:00.000', N'2010-10-31T23:59:00.000', N'2010-11-30T23:59:00.000', N'2010-12-31T23:59:00.000', N'2011-01-31T23:59:00.000', N'2011-02-28T23:59:00.000', N'2011-03-31T23:59:00.000', N'2011-04-30T23:59:00.000', N'2011-05-31T23:59:00.000', N'2011-06-30T23:59:00.000', N'2011-07-31T23:59:00.000', N'2011-08-31T23:59:00.000', N'2011-09-30T23:59:00.000', N'2011-10-31T23:59:00.000', N'2011-11-30T23:59:00.000', N'2011-12-31T23:59:00.000', N'2012-01-31T23:59:00.000', N'2012-02-29T23:59:00.000', N'2012-03-31T23:59:00.000', N'2012-04-30T23:59:00.000', N'2012-05-31T23:59:00.000', N'2012-06-30T23:59:00.000', N'2012-07-31T23:59:00.000', N'2012-08-31T23:59:00.000', N'2012-09-30T23:59:00.000', N'2012-10-31T23:59:00.000', N'2012-11-30T23:59:00.000', N'2012-12-31T23:59:00.000', N'2013-01-31T23:59:00.000', N'2013-02-28T23:59:00.000', N'2013-03-31T23:59:00.000', N'2013-04-30T23:59:00.000', N'2013-05-31T23:59:00.000', N'2013-06-30T23:59:00.000', N'2013-07-31T23:59:00.000', N'2013-08-31T23:59:00.000', N'2013-09-30T23:59:00.000', N'2013-10-31T23:59:00.000', N'2013-11-30T23:59:00.000', N'2013-12-31T23:59:00.000', N'2014-01-31T23:59:00.000', N'2014-02-28T23:59:00.000', N'2014-03-31T23:59:00.000', N'2014-04-30T23:59:00.000', N'2014-05-31T23:59:00.000', N'2014-06-30T23:59:00.000', N'2014-07-31T23:59:00.000', N'2014-08-31T23:59:00.000', N'2014-09-30T23:59:00.000', N'2014-10-31T23:59:00.000', N'2014-11-30T23:59:00.000', N'2014-12-31T23:59:00.000', N'2015-01-31T23:59:00.000', N'2015-02-28T23:59:00.000', N'2015-03-31T23:59:00.000', N'2015-04-30T23:59:00.000', N'2015-05-31T23:59:00.000', N'2015-06-30T23:59:00.000', N'2015-07-31T23:59:00.000', N'2015-08-31T23:59:00.000', N'2015-09-30T23:59:00.000', N'2015-10-31T23:59:00.000', N'2015-11-30T23:59:00.000', N'2015-12-31T23:59:00.000', N'2016-01-31T23:59:00.000', N'2016-02-29T23:59:00.000', N'2016-03-31T23:59:00.000', N'2016-04-30T23:59:00.000', N'2016-05-31T23:59:00.000', N'2016-06-30T23:59:00.000', N'2016-07-31T23:59:00.000', N'2016-08-31T23:59:00.000', N'2016-09-30T23:59:00.000', N'2016-10-31T23:59:00.000', N'2016-11-30T23:59:00.000', N'2016-12-31T23:59:00.000')
GO

--create partition schema
CREATE PARTITION SCHEME [ps_rptLicIPBetting_monthly] AS PARTITION [pf_rptLicIPBetting_monthly] TO ([rptLicIPBetting_10M01], [rptLicIPBetting_10M02], [rptLicIPBetting_10M03], [rptLicIPBetting_10M04], [rptLicIPBetting_10M05], [rptLicIPBetting_10M06], [rptLicIPBetting_10M07], [rptLicIPBetting_10M08], [rptLicIPBetting_10M09], [rptLicIPBetting_10M10], [rptLicIPBetting_10M11], [rptLicIPBetting_10M12], [rptLicIPBetting_11M01], [rptLicIPBetting_11M02], [rptLicIPBetting_11M03], [rptLicIPBetting_11M04], [rptLicIPBetting_11M05], [rptLicIPBetting_11M06], [rptLicIPBetting_11M07], [rptLicIPBetting_11M08], [rptLicIPBetting_11M09], [rptLicIPBetting_11M10], [rptLicIPBetting_11M11], [rptLicIPBetting_11M12], [rptLicIPBetting_12M01], [rptLicIPBetting_12M02], [rptLicIPBetting_12M03], [rptLicIPBetting_12M04], [rptLicIPBetting_12M05], [rptLicIPBetting_12M06], [rptLicIPBetting_12M07], [rptLicIPBetting_12M08], [rptLicIPBetting_12M09], [rptLicIPBetting_12M10], [rptLicIPBetting_12M11], [rptLicIPBetting_12M12], [rptLicIPBetting_13M01], [rptLicIPBetting_13M02], [rptLicIPBetting_13M03], [rptLicIPBetting_13M04], [rptLicIPBetting_13M05], [rptLicIPBetting_13M06], [rptLicIPBetting_13M07], [rptLicIPBetting_13M08], [rptLicIPBetting_13M09], [rptLicIPBetting_13M10], [rptLicIPBetting_13M11], [rptLicIPBetting_13M12], [rptLicIPBetting_14M01], [rptLicIPBetting_14M02], [rptLicIPBetting_14M03], [rptLicIPBetting_14M04], [rptLicIPBetting_14M05], [rptLicIPBetting_14M06], [rptLicIPBetting_14M07], [rptLicIPBetting_14M08], [rptLicIPBetting_14M09], [rptLicIPBetting_14M10], [rptLicIPBetting_14M11], [rptLicIPBetting_14M12], [rptLicIPBetting_15M01], [rptLicIPBetting_15M02], [rptLicIPBetting_15M03], [rptLicIPBetting_15M04], [rptLicIPBetting_15M05], [rptLicIPBetting_15M06], [rptLicIPBetting_15M07], [rptLicIPBetting_15M08], [rptLicIPBetting_15M09], [rptLicIPBetting_15M10], [rptLicIPBetting_15M11], [rptLicIPBetting_15M12], [rptLicIPBetting_16M01], [rptLicIPBetting_16M02], [rptLicIPBetting_16M03], [rptLicIPBetting_16M04], [rptLicIPBetting_16M05], [rptLicIPBetting_16M06], [rptLicIPBetting_16M07], [rptLicIPBetting_16M08], [rptLicIPBetting_16M09], [rptLicIPBetting_16M10], [rptLicIPBetting_16M11], [rptLicIPBetting_16M12], [rptLicIPBetting_MAX])
GO

CREATE TABLE [dbo].[rptLicIPBetting](
	[keyid] [bigint] IDENTITY(1,1) NOT NULL,
	[winlostdate] [smalldatetime] NULL,
	[Licenseeid] [int] NULL,
	[countrySHORT] [varchar](2) NULL,
	[Currency] [smallint] NULL,
	[CustID] [int] NULL,
	[ip] [varchar](20) NULL,
	[turnover] [money] NULL,
	[winlost] [money] NULL,
	[BetCount] [int] NULL,
	[statusID] [smallint] NULL
) ON [ps_rptLicIPBetting_monthly]([winlostdate])

GO

CREATE CLUSTERED INDEX [CIX_rptLicIPBetting] ON [dbo].[rptLicIPBetting] 
(
	[winlostdate] ASC,
	[Licenseeid] ASC,
	[countrySHORT] ASC,
	[Currency] ASC,
	[statusID] ASC
)WITH (DATA_COMPRESSION = PAGE) ON [ps_rptLicIPBetting_monthly]([winlostdate])
GO
