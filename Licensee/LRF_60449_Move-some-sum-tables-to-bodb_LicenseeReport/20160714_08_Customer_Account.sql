use bodb_LicenseeReport
go
/*
	Task: tbl_Customer_Account table:
		- Create partitions
		- Create table with data compression on page level
		- Create index with data compression on page level
*/
SET NOCOUNT ON
DECLARE @MinPartitionRange DATETIME, @MaxPartitionRange DATETIME
	, @Temp DATETIME, @SqlCmd VARCHAR(MAX), @Prefix VARCHAR(50)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255), @PathFile2 VARCHAR(255), @PathFile3 VARCHAR(255)

SELECT @MinPartitionRange = '2010-04-30 23:59:59.997'
	, @MaxPartitionRange = '2016-12-31 23:59:59.997'
	, @PathFile = 'E:\IBC_DB\bodb_LicenseeReport\Customer_Account\'
	, @PathFile2 = 'D:\IBC_DB\bodb_LicenseeReport\Customer_Account\'
	, @PathFile3 = 'E:\IBC_DB\bodb_LicenseeReport\'
	, @Prefix = 'Customer_Account'
SET @Temp = @MinPartitionRange

WHILE @MaxPartitionRange > @MinPartitionRange
BEGIN
	SELECT @Temp = DATEADD(DAY, -(DAY(DATEADD(MONTH, 1, @MinPartitionRange))),DATEADD(MONTH, 1, @MinPartitionRange))
	--SELECT @Temp AS '@Temp'
	--print convert(varchar(100), @Temp, 121)
	--PRINT @Temp
	SET @SqlCmd = ''
	SELECT @FileGroupName = @Prefix + '_' + CAST(RIGHT(YEAR(@Temp), 2) AS VARCHAR(2)) 
								+ 'M' + CAST(RIGHT('00' + CAST(MONTH(@Temp) AS VARCHAR(2)), 2) AS VARCHAR(2))

	--print @FileGroupName
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
	
	SET @MinPartitionRange = DATEADD(QUARTER, 1, @MinPartitionRange)
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

--create Data KPI group file
SET @FileGroupName = 'KPI_Data'
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

SET @SqlCmd = ''
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
	+ ''', FILENAME = N''' + @PathFile3 + @FileGroupName + '.ndf''
	, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

--create Index KPI group file
SET @FileGroupName = 'KPI_Index'
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

SET @SqlCmd = ''
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
	+ ''', FILENAME = N''' + @PathFile3 + @FileGroupName + '.ndf''
	, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

--create parrtition function
CREATE PARTITION FUNCTION [pf_kpiCustomer_Account_quarterly](DATETIME) AS RANGE LEFT FOR VALUES (N'2010-04-30 23:59:59.997', N'2010-07-31 23:59:59.997', N'2010-10-31 23:59:59.997', N'2011-01-31 23:59:59.997', N'2011-04-30 23:59:59.997', N'2011-07-31 23:59:59.997', N'2011-10-31 23:59:59.997', N'2012-01-31 23:59:59.997', N'2012-04-30 23:59:59.997', N'2012-07-31 23:59:59.997', N'2012-10-31 23:59:59.997', N'2013-01-31 23:59:59.997', N'2013-04-30 23:59:59.997', N'2013-07-31 23:59:59.997', N'2013-10-31 23:59:59.997', N'2014-01-31 23:59:59.997', N'2014-04-30 23:59:59.997', N'2014-07-31 23:59:59.997', N'2014-10-31 23:59:59.997', N'2015-01-31 23:59:59.997', N'2015-04-30 23:59:59.997', N'2015-07-31 23:59:59.997', N'2015-10-31 23:59:59.997', N'2016-01-31 23:59:59.997', N'2016-04-30 23:59:59.997', N'2016-07-31 23:59:59.997', N'2016-10-31 23:59:59.997')
GO

--create partition schema
CREATE PARTITION SCHEME [ps_kpiCustomer_Account_quarterly] AS PARTITION [pf_kpiCustomer_Account_quarterly] TO ([Customer_Account_10M04], [Customer_Account_10M07], [Customer_Account_10M10], [Customer_Account_11M01], [Customer_Account_11M04], [Customer_Account_11M07], [Customer_Account_11M10], [Customer_Account_12M01], [Customer_Account_12M04], [Customer_Account_12M07], [Customer_Account_12M10], [Customer_Account_13M01], [Customer_Account_13M04], [Customer_Account_13M07], [Customer_Account_13M10], [Customer_Account_14M01], [Customer_Account_14M04], [Customer_Account_14M07], [Customer_Account_14M10], [Customer_Account_15M01], [Customer_Account_15M04], [Customer_Account_15M07], [Customer_Account_15M10], [Customer_Account_16M01], [Customer_Account_16M04], [Customer_Account_16M07], [Customer_Account_16M10], [Customer_Account_MAX])
GO

CREATE TABLE [dbo].[tbl_Customer_Account](
	[transid] [bigint] NOT NULL,
	[refno] [bigint] NOT NULL,
	[custid] [int] NOT NULL,
	[currency] [int] NOT NULL,
	[transdate] [datetime] NOT NULL,
	[amount] [money] NULL,
	[creator] [int] NULL,
	[TransDesc] [nvarchar](200) NULL,
	[deleted] [bit] NULL,
	[balanceduppreviousday] [bit] NULL,
	[OtherCustid] [int] NULL,
	[recommend] [int] NULL,
	[mrecommend] [int] NULL,
	[srecommend] [int] NULL,
	[transtype] [smallint] NULL,
 CONSTRAINT [PK_customer_account] PRIMARY KEY CLUSTERED 
(
	[transid] ASC
)WITH (DATA_COMPRESSION = PAGE) ON [KPI_Data]
) ON [ps_kpiCustomer_Account_quarterly]([transdate])

GO

CREATE NONCLUSTERED INDEX [ix_transdate] ON [dbo].[tbl_Customer_Account] 
(
	[transdate] ASC,
	[transtype] ASC,
	[custid] ASC
)
INCLUDE ( [amount],
[currency]) WITH (DATA_COMPRESSION = PAGE) ON [ps_kpiCustomer_Account_quarterly]([transdate])
GO

ALTER TABLE [dbo].[tbl_Customer_Account] ADD  CONSTRAINT [DF_tbl_Customer_Account_deleted]  DEFAULT ((0)) FOR [deleted]
GO
