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
	, @MaxPartitionRange = '2018-12-31 23:59:59.997'
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
CREATE PARTITION FUNCTION [pf_kpiCustomer_Account_quarterly](DATETIME) AS RANGE LEFT FOR VALUES (N'2010-03-31T23:59:59.997', N'2010-06-30T23:59:59.997', N'2010-09-30T23:59:59.997', N'2010-12-31T23:59:59.997', N'2011-03-31T23:59:59.997', N'2011-06-30T23:59:59.997', N'2011-09-30T23:59:59.997', N'2011-12-31T23:59:59.997', N'2012-03-31T23:59:59.997', N'2012-06-30T23:59:59.997', N'2012-09-30T23:59:59.997', N'2012-12-31T23:59:59.997', N'2013-03-31T23:59:59.997', N'2013-06-30T23:59:59.997', N'2013-09-30T23:59:59.997', N'2013-12-31T23:59:59.997', N'2014-03-31T23:59:59.997', N'2014-06-30T23:59:59.997', N'2014-09-30T23:59:59.997', N'2014-12-31T23:59:59.997', N'2015-03-31T23:59:59.997', N'2015-06-30T23:59:59.997', N'2015-09-30T23:59:59.997', N'2015-12-31T23:59:59.997', N'2016-03-31T23:59:59.997', N'2016-06-30T23:59:59.997', N'2016-09-30T23:59:59.997', N'2016-12-31T23:59:59.997', N'2017-03-31T23:59:59.997', N'2017-06-30T23:59:59.997', N'2017-09-30T23:59:59.997', N'2017-12-31T23:59:59.997', N'2018-03-31T23:59:59.997', N'2018-06-30T23:59:59.997', N'2018-09-30T23:59:59.997', N'2018-12-31T23:59:59.997')
GO

--create partition schema
CREATE PARTITION SCHEME [ps_kpiCustomer_Account_quarterly] AS PARTITION [pf_kpiCustomer_Account_quarterly] TO ([Customer_Account_10M03], [Customer_Account_10M06], [Customer_Account_10M09], [Customer_Account_10M12], [Customer_Account_11M03], [Customer_Account_11M06], [Customer_Account_11M09], [Customer_Account_11M12], [Customer_Account_12M03], [Customer_Account_12M06], [Customer_Account_12M09], [Customer_Account_12M12], [Customer_Account_13M03], [Customer_Account_13M06], [Customer_Account_13M09], [Customer_Account_13M12], [Customer_Account_14M03], [Customer_Account_14M06], [Customer_Account_14M09], [Customer_Account_14M12], [Customer_Account_15M03], [Customer_Account_15M06], [Customer_Account_15M09], [Customer_Account_15M12], [Customer_Account_16M03], [Customer_Account_16M06], [Customer_Account_16M09], [Customer_Account_16M12], [Customer_Account_17M03], [Customer_Account_17M06], [Customer_Account_17M09], [Customer_Account_17M12], [Customer_Account_18M03], [Customer_Account_18M06], [Customer_Account_18M09], [Customer_Account_18M12]
, [Customer_Account_MAX])
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
