use bodb_LicenseeReport
go
/*
	Task: rptLicWinloss2 table:
		- Create partitions
		- Create table with data compression on page level
		- Create index with data compression on page level
*/

DECLARE @MinPartitionRange DATETIME, @MaxPartitionRange DATETIME
	, @Temp DATETIME, @SqlCmd VARCHAR(MAX), @Prefix VARCHAR(50)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255), @PathFile2 VARCHAR(255)

SELECT @MinPartitionRange = '2010-01-31'
	, @MaxPartitionRange = '2018-12-31'
	, @PathFile = 'E:\IBC_DB\bodb_LicenseeReport\rpt_LicWinloss2\'
	, @PathFile2 = 'D:\IBC_DB\bodb_LicenseeReport\rpt_LicWinloss2\'
	, @Prefix = 'rptLicensee'
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

--create DATA group file
SET @FileGroupName = 'LicWinloss2_DATA'
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
CREATE PARTITION FUNCTION [pf_rptLicensee_monthly](smalldatetime) AS RANGE LEFT FOR VALUES (N'2010-01-31T23:59:00.000', N'2010-02-28T23:59:00.000', N'2010-03-31T23:59:00.000', N'2010-04-30T23:59:00.000', N'2010-05-31T23:59:00.000', N'2010-06-30T23:59:00.000', N'2010-07-31T23:59:00.000', N'2010-08-31T23:59:00.000', N'2010-09-30T23:59:00.000', N'2010-10-31T23:59:00.000', N'2010-11-30T23:59:00.000', N'2010-12-31T23:59:00.000', N'2011-01-31T23:59:00.000', N'2011-02-28T23:59:00.000', N'2011-03-31T23:59:00.000', N'2011-04-30T23:59:00.000', N'2011-05-31T23:59:00.000', N'2011-06-30T23:59:00.000', N'2011-07-31T23:59:00.000', N'2011-08-31T23:59:00.000', N'2011-09-30T23:59:00.000', N'2011-10-31T23:59:00.000', N'2011-11-30T23:59:00.000', N'2011-12-31T23:59:00.000', N'2012-01-31T23:59:00.000', N'2012-02-29T23:59:00.000', N'2012-03-31T23:59:00.000', N'2012-04-30T23:59:00.000', N'2012-05-31T23:59:00.000', N'2012-06-30T23:59:00.000', N'2012-07-31T23:59:00.000', N'2012-08-31T23:59:00.000', N'2012-09-30T23:59:00.000', N'2012-10-31T23:59:00.000', N'2012-11-30T23:59:00.000', N'2012-12-31T23:59:00.000', N'2013-01-31T23:59:00.000', N'2013-02-28T23:59:00.000', N'2013-03-31T23:59:00.000', N'2013-04-30T23:59:00.000', N'2013-05-31T23:59:00.000', N'2013-06-30T23:59:00.000', N'2013-07-31T23:59:00.000', N'2013-08-31T23:59:00.000', N'2013-09-30T23:59:00.000', N'2013-10-31T23:59:00.000', N'2013-11-30T23:59:00.000', N'2013-12-31T23:59:00.000', N'2014-01-31T23:59:00.000', N'2014-02-28T23:59:00.000', N'2014-03-31T23:59:00.000', N'2014-04-30T23:59:00.000', N'2014-05-31T23:59:00.000', N'2014-06-30T23:59:00.000', N'2014-07-31T23:59:00.000', N'2014-08-31T23:59:00.000', N'2014-09-30T23:59:00.000', N'2014-10-31T23:59:00.000', N'2014-11-30T23:59:00.000', N'2014-12-31T23:59:00.000', N'2015-01-31T23:59:00.000', N'2015-02-28T23:59:00.000', N'2015-03-31T23:59:00.000', N'2015-04-30T23:59:00.000', N'2015-05-31T23:59:00.000', N'2015-06-30T23:59:00.000', N'2015-07-31T23:59:00.000', N'2015-08-31T23:59:00.000', N'2015-09-30T23:59:00.000', N'2015-10-31T23:59:00.000', N'2015-11-30T23:59:00.000', N'2015-12-31T23:59:00.000', N'2016-01-31T23:59:00.000', N'2016-02-29T23:59:00.000', N'2016-03-31T23:59:00.000', N'2016-04-30T23:59:00.000', N'2016-05-31T23:59:00.000', N'2016-06-30T23:59:00.000', N'2016-07-31T23:59:00.000', N'2016-08-31T23:59:00.000', N'2016-09-30T23:59:00.000', N'2016-10-31T23:59:00.000', N'2016-11-30T23:59:00.000', N'2016-12-31T23:59:00.000', N'2017-01-31T23:59:00.000', N'2017-02-28T23:59:00.000', N'2017-03-31T23:59:00.000', N'2017-04-30T23:59:00.000', N'2017-05-31T23:59:00.000', N'2017-06-30T23:59:00.000', N'2017-07-31T23:59:00.000', N'2017-08-31T23:59:00.000', N'2017-09-30T23:59:00.000', N'2017-10-31T23:59:00.000', N'2017-11-30T23:59:00.000', N'2017-12-31T23:59:00.000', N'2018-01-31T23:59:00.000', N'2018-02-28T23:59:00.000', N'2018-03-31T23:59:00.000', N'2018-04-30T23:59:00.000', N'2018-05-31T23:59:00.000', N'2018-06-30T23:59:00.000', N'2018-07-31T23:59:00.000', N'2018-08-31T23:59:00.000', N'2018-09-30T23:59:00.000', N'2018-10-31T23:59:00.000', N'2018-11-30T23:59:00.000', N'2018-12-31T23:59:00.000')
GO

--create partition schema
CREATE PARTITION SCHEME [ps_rptLicensee_monthly] AS PARTITION [pf_rptLicensee_monthly] TO ([rptLicensee_10M01], [rptLicensee_10M02], [rptLicensee_10M03], [rptLicensee_10M04], [rptLicensee_10M05], [rptLicensee_10M06], [rptLicensee_10M07], [rptLicensee_10M08], [rptLicensee_10M09], [rptLicensee_10M10], [rptLicensee_10M11], [rptLicensee_10M12], [rptLicensee_11M01], [rptLicensee_11M02], [rptLicensee_11M03], [rptLicensee_11M04], [rptLicensee_11M05], [rptLicensee_11M06], [rptLicensee_11M07], [rptLicensee_11M08], [rptLicensee_11M09], [rptLicensee_11M10], [rptLicensee_11M11], [rptLicensee_11M12], [rptLicensee_12M01], [rptLicensee_12M02], [rptLicensee_12M03], [rptLicensee_12M04], [rptLicensee_12M05], [rptLicensee_12M06], [rptLicensee_12M07], [rptLicensee_12M08], [rptLicensee_12M09], [rptLicensee_12M10], [rptLicensee_12M11], [rptLicensee_12M12], [rptLicensee_13M01], [rptLicensee_13M02], [rptLicensee_13M03], [rptLicensee_13M04], [rptLicensee_13M05], [rptLicensee_13M06], [rptLicensee_13M07], [rptLicensee_13M08], [rptLicensee_13M09], [rptLicensee_13M10], [rptLicensee_13M11], [rptLicensee_13M12], [rptLicensee_14M01], [rptLicensee_14M02], [rptLicensee_14M03], [rptLicensee_14M04], [rptLicensee_14M05], [rptLicensee_14M06], [rptLicensee_14M07], [rptLicensee_14M08], [rptLicensee_14M09], [rptLicensee_14M10], [rptLicensee_14M11], [rptLicensee_14M12], [rptLicensee_15M01], [rptLicensee_15M02], [rptLicensee_15M03], [rptLicensee_15M04], [rptLicensee_15M05], [rptLicensee_15M06], [rptLicensee_15M07], [rptLicensee_15M08], [rptLicensee_15M09], [rptLicensee_15M10], [rptLicensee_15M11], [rptLicensee_15M12], [rptLicensee_16M01], [rptLicensee_16M02], [rptLicensee_16M03], [rptLicensee_16M04], [rptLicensee_16M05], [rptLicensee_16M06], [rptLicensee_16M07], [rptLicensee_16M08], [rptLicensee_16M09], [rptLicensee_16M10], [rptLicensee_16M11], [rptLicensee_16M12], [rptLicensee_17M01], [rptLicensee_17M02], [rptLicensee_17M03], [rptLicensee_17M04], [rptLicensee_17M05], [rptLicensee_17M06], [rptLicensee_17M07], [rptLicensee_17M08], [rptLicensee_17M09], [rptLicensee_17M10], [rptLicensee_17M11], [rptLicensee_17M12], [rptLicensee_18M01], [rptLicensee_18M02], [rptLicensee_18M03], [rptLicensee_18M04], [rptLicensee_18M05], [rptLicensee_18M06], [rptLicensee_18M07], [rptLicensee_18M08], [rptLicensee_18M09], [rptLicensee_18M10], [rptLicensee_18M11], [rptLicensee_18M12], [rptLicensee_MAX])
GO

CREATE TABLE [dbo].[rptLicWinloss2](
	[keyid] [bigint] IDENTITY(1,1) NOT NULL,
	[winlostdate] [smalldatetime] NULL,
	[username] [nvarchar](50) NULL,
	[username2] [nvarchar](50) NULL,
	[custid] [int] NULL,
	[roleid] [int] NULL,
	[recommend] [int] NULL,
	[mrecommend] [int] NULL,
	[srecommend] [int] NULL,
	[turnover] [money] NULL,
	[winlost] [money] NULL,
	[awinlost] [money] NULL,
	[mwinlost] [money] NULL,
	[swinlost] [money] NULL,
	[playercomm] [money] NULL,
	[comm] [money] NULL,
	[acomm] [money] NULL,
	[scomm] [money] NULL,
	[winlostvirtual] [money] NULL,
	[commvirtual] [money] NULL,
	[BetCount] [int] NULL,
	[Currency] [smallint] NULL,
	[sporttype] [smallint] NOT NULL,
	[bettype] [smallint] NOT NULL,
	[statusID] [smallint] NOT NULL,
	[isBA] [bit] NOT NULL,
	[isMobile] [bit] NOT NULL,
	[betfrom] [nvarchar](1) NOT NULL,
	[BetEffective] [money] NULL,
	[BuyBackAmt] [money] NULL,
	[BABuyBackAmt] [money] NULL,
 CONSTRAINT [PK_rptLicWinloss] PRIMARY KEY NONCLUSTERED 
(
	[keyid] ASC
)WITH (DATA_COMPRESSION = PAGE) ON [LicWinloss2_DATA]
) ON [ps_rptLicensee_monthly]([winlostdate])

GO

/****** Object:  Index [CIX_rptLicWinloss]    Script Date: 07/14/2016 03:00:01 ******/
CREATE CLUSTERED INDEX [CIX_rptLicWinloss] ON [dbo].[rptLicWinloss2] 
(
	[winlostdate] ASC,
	[srecommend] ASC,
	[mrecommend] ASC,
	[recommend] ASC,
	[roleid] ASC,
	[sporttype] ASC,
	[bettype] ASC,
	[isBA] ASC,
	[statusID] ASC
)WITH (DATA_COMPRESSION = PAGE) ON [ps_rptLicensee_monthly]([winlostdate])
GO

/****** Object:  Index [IX_recommend]    Script Date: 07/14/2016 03:00:01 ******/
CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[rptLicWinloss2] 
(
	[recommend] ASC,
	[roleid] ASC,
	[isBA] ASC,
	[sporttype] ASC,
	[statusID] ASC
)
INCLUDE ( [turnover],
[winlost],
[awinlost],
[playercomm],
[comm],
[Currency],
[BetCount],
[isMobile],
[betfrom],
[custid],
[BetEffective]) WITH (DATA_COMPRESSION = PAGE) ON [ps_rptLicensee_monthly]([winlostdate])
GO

ALTER TABLE [dbo].[rptLicWinloss2] ADD  DEFAULT ('') FOR [betfrom]
GO

ALTER TABLE [dbo].[rptLicWinloss2] ADD  DEFAULT ((0)) FOR [BetEffective]
GO
