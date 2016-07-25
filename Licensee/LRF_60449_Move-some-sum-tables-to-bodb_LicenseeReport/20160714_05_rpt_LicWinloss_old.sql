use bodb_LicenseeReport
go
/*
	Task: rptLicWinloss_old table:
		- Create partitions
		- Create table with data compression on page level
		- Create index with data compression on page level
*/

DECLARE @MinPartitionRange DATETIME, @MaxPartitionRange DATETIME
	, @Temp DATETIME, @SqlCmd VARCHAR(MAX), @Prefix VARCHAR(50)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255), @PathFile2 VARCHAR(255)

SELECT @MinPartitionRange = '2008-07-31'
	, @MaxPartitionRange = '2018-12-31'
	, @PathFile = 'E:\IBC_DB\bodb_LicenseeReport\rpt_LicWinloss_Old\'
	, @PathFile2 = 'D:\IBC_DB\bodb_LicenseeReport\rpt_LicWinloss_Old\'
	, @Prefix = 'rptLicWL_old'
SET @Temp = @MinPartitionRange

WHILE @MaxPartitionRange > @MinPartitionRange
BEGIN
	SELECT @Temp = DATEADD(MINUTE, - 1, DATEADD(mm, DATEDIFF(m, 0, @MinPartitionRange) + 1, 0))
	--SELECT @Temp AS '@Temp'
	SET @SqlCmd = ''
	SELECT @FileGroupName = @Prefix + '_' + CAST(RIGHT(YEAR(@Temp), 2) AS VARCHAR(2)) 
								+ 'M' + CAST(RIGHT('00' + CAST(MONTH(@Temp) AS VARCHAR(2)), 2) AS VARCHAR(2))
	--print convert(varchar(50), @Temp , 121)
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
	
	SET @MinPartitionRange = DATEADD(MM, 1, @MinPartitionRange)
END

----create max group file
SET @FileGroupName = @Prefix + '_MAX'
print @FileGroupName
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
CREATE PARTITION FUNCTION [pf_rptLicWL_old_monthly](smalldatetime) AS RANGE LEFT FOR VALUES (N'2008-07-31T23:59:00.000', N'2008-08-31T23:59:00.000', N'2008-09-30T23:59:00.000', N'2008-10-31T23:59:00.000', N'2008-11-30T23:59:00.000', N'2008-12-31T23:59:00.000', N'2009-01-31T23:59:00.000', N'2009-02-28T23:59:00.000', N'2009-03-31T23:59:00.000', N'2009-04-30T23:59:00.000', N'2009-05-31T23:59:00.000', N'2009-06-30T23:59:00.000', N'2009-07-31T23:59:00.000', N'2009-08-31T23:59:00.000', N'2009-09-30T23:59:00.000', N'2009-10-31T23:59:00.000', N'2009-11-30T23:59:00.000', N'2009-12-31T23:59:00.000', N'2010-01-31T23:59:00.000', N'2010-02-28T23:59:00.000', N'2010-03-31T23:59:00.000', N'2010-04-30T23:59:00.000', N'2010-05-31T23:59:00.000', N'2010-06-30T23:59:00.000', N'2010-07-31T23:59:00.000', N'2010-08-31T23:59:00.000', N'2010-09-30T23:59:00.000', N'2010-10-31T23:59:00.000', N'2010-11-30T23:59:00.000', N'2010-12-31T23:59:00.000', N'2011-01-31T23:59:00.000', N'2011-02-28T23:59:00.000', N'2011-03-31T23:59:00.000', N'2011-04-30T23:59:00.000', N'2011-05-31T23:59:00.000', N'2011-06-30T23:59:00.000', N'2011-07-31T23:59:00.000', N'2011-08-31T23:59:00.000', N'2011-09-30T23:59:00.000', N'2011-10-31T23:59:00.000', N'2011-11-30T23:59:00.000', N'2011-12-31T23:59:00.000', N'2012-01-31T23:59:00.000', N'2012-02-29T23:59:00.000', N'2012-03-31T23:59:00.000', N'2012-04-30T23:59:00.000', N'2012-05-31T23:59:00.000', N'2012-06-30T23:59:00.000', N'2012-07-31T23:59:00.000', N'2012-08-31T23:59:00.000', N'2012-09-30T23:59:00.000', N'2012-10-31T23:59:00.000', N'2012-11-30T23:59:00.000', N'2012-12-31T23:59:00.000', N'2013-01-31T23:59:00.000', N'2013-02-28T23:59:00.000', N'2013-03-31T23:59:00.000', N'2013-04-30T23:59:00.000', N'2013-05-31T23:59:00.000', N'2013-06-30T23:59:00.000', N'2013-07-31T23:59:00.000', N'2013-08-31T23:59:00.000', N'2013-09-30T23:59:00.000', N'2013-10-31T23:59:00.000', N'2013-11-30T23:59:00.000', N'2013-12-31T23:59:00.000', N'2014-01-31T23:59:00.000', N'2014-02-28T23:59:00.000', N'2014-03-31T23:59:00.000', N'2014-04-30T23:59:00.000', N'2014-05-31T23:59:00.000', N'2014-06-30T23:59:00.000', N'2014-07-31T23:59:00.000', N'2014-08-31T23:59:00.000', N'2014-09-30T23:59:00.000', N'2014-10-31T23:59:00.000', N'2014-11-30T23:59:00.000', N'2014-12-31T23:59:00.000', N'2015-01-31T23:59:00.000', N'2015-02-28T23:59:00.000', N'2015-03-31T23:59:00.000', N'2015-04-30T23:59:00.000', N'2015-05-31T23:59:00.000', N'2015-06-30T23:59:00.000', N'2015-07-31T23:59:00.000', N'2015-08-31T23:59:00.000', N'2015-09-30T23:59:00.000', N'2015-10-31T23:59:00.000', N'2015-11-30T23:59:00.000', N'2015-12-31T23:59:00.000', N'2016-01-31T23:59:00.000', N'2016-02-29T23:59:00.000', N'2016-03-31T23:59:00.000', N'2016-04-30T23:59:00.000', N'2016-05-31T23:59:00.000', N'2016-06-30T23:59:00.000', N'2016-07-31T23:59:00.000', N'2016-08-31T23:59:00.000', N'2016-09-30T23:59:00.000', N'2016-10-31T23:59:00.000', N'2016-11-30T23:59:00.000', N'2016-12-31T23:59:00.000', N'2017-01-31T23:59:00.000', N'2017-02-28T23:59:00.000', N'2017-03-31T23:59:00.000', N'2017-04-30T23:59:00.000', N'2017-05-31T23:59:00.000', N'2017-06-30T23:59:00.000', N'2017-07-31T23:59:00.000', N'2017-08-31T23:59:00.000', N'2017-09-30T23:59:00.000', N'2017-10-31T23:59:00.000', N'2017-11-30T23:59:00.000', N'2017-12-31T23:59:00.000', N'2018-01-31T23:59:00.000', N'2018-02-28T23:59:00.000', N'2018-03-31T23:59:00.000', N'2018-04-30T23:59:00.000', N'2018-05-31T23:59:00.000', N'2018-06-30T23:59:00.000', N'2018-07-31T23:59:00.000', N'2018-08-31T23:59:00.000', N'2018-09-30T23:59:00.000', N'2018-10-31T23:59:00.000', N'2018-11-30T23:59:00.000', N'2018-12-31T23:59:00.000')
GO

--create partition schema
CREATE PARTITION SCHEME [ps_rptLicWL_old_monthly] AS PARTITION [pf_rptLicWL_old_monthly] TO ([rptLicWL_old_08M07], [rptLicWL_old_08M08], [rptLicWL_old_08M09], [rptLicWL_old_08M10], [rptLicWL_old_08M11], [rptLicWL_old_08M12], [rptLicWL_old_09M01], [rptLicWL_old_09M02], [rptLicWL_old_09M03], [rptLicWL_old_09M04], [rptLicWL_old_09M05], [rptLicWL_old_09M06], [rptLicWL_old_09M07], [rptLicWL_old_09M08], [rptLicWL_old_09M09], [rptLicWL_old_09M10], [rptLicWL_old_09M11], [rptLicWL_old_09M12], [rptLicWL_old_10M01], [rptLicWL_old_10M02], [rptLicWL_old_10M03], [rptLicWL_old_10M04], [rptLicWL_old_10M05], [rptLicWL_old_10M06], [rptLicWL_old_10M07], [rptLicWL_old_10M08], [rptLicWL_old_10M09], [rptLicWL_old_10M10], [rptLicWL_old_10M11], [rptLicWL_old_10M12], [rptLicWL_old_11M01], [rptLicWL_old_11M02], [rptLicWL_old_11M03], [rptLicWL_old_11M04], [rptLicWL_old_11M05], [rptLicWL_old_11M06], [rptLicWL_old_11M07], [rptLicWL_old_11M08], [rptLicWL_old_11M09], [rptLicWL_old_11M10], [rptLicWL_old_11M11], [rptLicWL_old_11M12], [rptLicWL_old_12M01], [rptLicWL_old_12M02], [rptLicWL_old_12M03], [rptLicWL_old_12M04], [rptLicWL_old_12M05], [rptLicWL_old_12M06], [rptLicWL_old_12M07], [rptLicWL_old_12M08], [rptLicWL_old_12M09], [rptLicWL_old_12M10], [rptLicWL_old_12M11], [rptLicWL_old_12M12], [rptLicWL_old_13M01], [rptLicWL_old_13M02], [rptLicWL_old_13M03], [rptLicWL_old_13M04], [rptLicWL_old_13M05], [rptLicWL_old_13M06], [rptLicWL_old_13M07], [rptLicWL_old_13M08], [rptLicWL_old_13M09], [rptLicWL_old_13M10], [rptLicWL_old_13M11], [rptLicWL_old_13M12], [rptLicWL_old_14M01], [rptLicWL_old_14M02], [rptLicWL_old_14M03], [rptLicWL_old_14M04], [rptLicWL_old_14M05], [rptLicWL_old_14M06], [rptLicWL_old_14M07], [rptLicWL_old_14M08], [rptLicWL_old_14M09], [rptLicWL_old_14M10], [rptLicWL_old_14M11], [rptLicWL_old_14M12], [rptLicWL_old_15M01], [rptLicWL_old_15M02], [rptLicWL_old_15M03], [rptLicWL_old_15M04], [rptLicWL_old_15M05], [rptLicWL_old_15M06], [rptLicWL_old_15M07], [rptLicWL_old_15M08], [rptLicWL_old_15M09], [rptLicWL_old_15M10], [rptLicWL_old_15M11], [rptLicWL_old_15M12], [rptLicWL_old_16M01], [rptLicWL_old_16M02], [rptLicWL_old_16M03], [rptLicWL_old_16M04], [rptLicWL_old_16M05], [rptLicWL_old_16M06], [rptLicWL_old_16M07], [rptLicWL_old_16M08], [rptLicWL_old_16M09], [rptLicWL_old_16M10], [rptLicWL_old_16M11], [rptLicWL_old_16M12], [rptLicWL_old_17M01], [rptLicWL_old_17M02], [rptLicWL_old_17M03], [rptLicWL_old_17M04], [rptLicWL_old_17M05], [rptLicWL_old_17M06], [rptLicWL_old_17M07], [rptLicWL_old_17M08], [rptLicWL_old_17M09], [rptLicWL_old_17M10], [rptLicWL_old_17M11], [rptLicWL_old_17M12], [rptLicWL_old_18M01], [rptLicWL_old_18M02], [rptLicWL_old_18M03], [rptLicWL_old_18M04], [rptLicWL_old_18M05], [rptLicWL_old_18M06], [rptLicWL_old_18M07], [rptLicWL_old_18M08], [rptLicWL_old_18M09], [rptLicWL_old_18M10], [rptLicWL_old_18M11], [rptLicWL_old_18M12], [rptLicWL_old_MAX])
GO

CREATE TABLE [dbo].[rptLicWinloss_old](
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
	[isMobile] [bit] NOT NULL
) ON [ps_rptLicWL_old_monthly]([winlostdate])

GO

CREATE CLUSTERED INDEX [CIX_rptLicWinloss_old] ON [dbo].[rptLicWinloss_old] 
(
	[winlostdate] ASC,
	[srecommend] ASC,
	[mrecommend] ASC,
	[recommend] ASC,
	[roleid] ASC,
	[sporttype] ASC,
	[bettype] ASC,
	[statusID] ASC,
	[isBA] ASC
)WITH (DATA_COMPRESSION = PAGE) ON [ps_rptLicWL_old_monthly]([winlostdate])
GO

CREATE NONCLUSTERED INDEX [IX_rptLicWinlost_old_ag] ON [dbo].[rptLicWinloss_old] 
(
	[recommend] ASC,
	[winlostdate] ASC,
	[roleid] ASC,
	[sporttype] ASC,
	[bettype] ASC,
	[statusID] ASC,
	[isBA] ASC
)WITH (DATA_COMPRESSION = PAGE) ON [ps_rptLicWL_old_monthly]([winlostdate])
GO

ALTER TABLE [dbo].[rptLicWinloss_old] ADD  CONSTRAINT [DF_rptLicWinloss_old_isMobile]  DEFAULT ((0)) FOR [isMobile]
GO
