use bodb_LicenseeReport
go
/*
	Task: rpt_Betting table:
		- Create partitions
		- Create table with data compression on page level
		- Create index with data compression on page level
*/

DECLARE @MinPartitionRange DATETIME, @MaxPartitionRange DATETIME
	, @Temp DATETIME, @SqlCmd VARCHAR(MAX), @Prefix VARCHAR(50)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255), @PathFile2 VARCHAR(255)

SELECT @MinPartitionRange = '2009-01-31'
	, @MaxPartitionRange = '2018-12-31'
	, @PathFile = 'E:\IBC_DB\bodb_LicenseeReport\rpt_Betting\'
	, @PathFile2 = 'D:\IBC_DB\bodb_LicenseeReport\rpt_Betting\'
	, @Prefix = 'rptBetting'
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
CREATE PARTITION FUNCTION [pf_rptBetting_monthly](datetime) AS RANGE LEFT FOR VALUES (N'2009-01-31T23:59:00.000', N'2009-02-28T23:59:00.000', N'2009-03-31T23:59:00.000', N'2009-04-30T23:59:00.000', N'2009-05-31T23:59:00.000', N'2009-06-30T23:59:00.000', N'2009-07-31T23:59:00.000', N'2009-08-31T23:59:00.000', N'2009-09-30T23:59:00.000', N'2009-10-31T23:59:00.000', N'2009-11-30T23:59:00.000', N'2009-12-31T23:59:00.000', N'2010-01-31T23:59:00.000', N'2010-02-28T23:59:00.000', N'2010-03-31T23:59:00.000', N'2010-04-30T23:59:00.000', N'2010-05-31T23:59:00.000', N'2010-06-30T23:59:00.000', N'2010-07-31T23:59:00.000', N'2010-08-31T23:59:00.000', N'2010-09-30T23:59:00.000', N'2010-10-31T23:59:00.000', N'2010-11-30T23:59:00.000', N'2010-12-31T23:59:00.000', N'2011-01-31T23:59:00.000', N'2011-02-28T23:59:00.000', N'2011-03-31T23:59:00.000', N'2011-04-30T23:59:00.000', N'2011-05-31T23:59:00.000', N'2011-06-30T23:59:00.000', N'2011-07-31T23:59:00.000', N'2011-08-31T23:59:00.000', N'2011-09-30T23:59:00.000', N'2011-10-31T23:59:00.000', N'2011-11-30T23:59:00.000', N'2011-12-31T23:59:00.000', N'2012-01-31T23:59:00.000', N'2012-02-29T23:59:00.000', N'2012-03-31T23:59:00.000', N'2012-04-30T23:59:00.000', N'2012-05-31T23:59:00.000', N'2012-06-30T23:59:00.000', N'2012-07-31T23:59:00.000', N'2012-08-31T23:59:00.000', N'2012-09-30T23:59:00.000', N'2012-10-31T23:59:00.000', N'2012-11-30T23:59:00.000', N'2012-12-31T23:59:00.000', N'2013-01-31T23:59:00.000', N'2013-02-28T23:59:00.000', N'2013-03-31T23:59:00.000', N'2013-04-30T23:59:00.000', N'2013-05-31T23:59:00.000', N'2013-06-30T23:59:00.000', N'2013-07-31T23:59:00.000', N'2013-08-31T23:59:00.000', N'2013-09-30T23:59:00.000', N'2013-10-31T23:59:00.000', N'2013-11-30T23:59:00.000', N'2013-12-31T23:59:00.000', N'2014-01-31T23:59:00.000', N'2014-02-28T23:59:00.000', N'2014-03-31T23:59:00.000', N'2014-04-30T23:59:00.000', N'2014-05-31T23:59:00.000', N'2014-06-30T23:59:00.000', N'2014-07-31T23:59:00.000', N'2014-08-31T23:59:00.000', N'2014-09-30T23:59:00.000', N'2014-10-31T23:59:00.000', N'2014-11-30T23:59:00.000', N'2014-12-31T23:59:00.000', N'2015-01-31T23:59:00.000', N'2015-02-28T23:59:00.000', N'2015-03-31T23:59:00.000', N'2015-04-30T23:59:00.000', N'2015-05-31T23:59:00.000', N'2015-06-30T23:59:00.000', N'2015-07-31T23:59:00.000', N'2015-08-31T23:59:00.000', N'2015-09-30T23:59:00.000', N'2015-10-31T23:59:00.000', N'2015-11-30T23:59:00.000', N'2015-12-31T23:59:00.000', N'2016-01-31T23:59:00.000', N'2016-02-29T23:59:00.000', N'2016-03-31T23:59:00.000', N'2016-04-30T23:59:00.000', N'2016-05-31T23:59:00.000', N'2016-06-30T23:59:00.000', N'2016-07-31T23:59:00.000', N'2016-08-31T23:59:00.000', N'2016-09-30T23:59:00.000', N'2016-10-31T23:59:00.000', N'2016-11-30T23:59:00.000', N'2016-12-31T23:59:00.000', N'2017-01-31T23:59:00.000', N'2017-02-28T23:59:00.000', N'2017-03-31T23:59:00.000', N'2017-04-30T23:59:00.000', N'2017-05-31T23:59:00.000', N'2017-06-30T23:59:00.000', N'2017-07-31T23:59:00.000', N'2017-08-31T23:59:00.000', N'2017-09-30T23:59:00.000', N'2017-10-31T23:59:00.000', N'2017-11-30T23:59:00.000', N'2017-12-31T23:59:00.000', N'2018-01-31T23:59:00.000', N'2018-02-28T23:59:00.000', N'2018-03-31T23:59:00.000', N'2018-04-30T23:59:00.000', N'2018-05-31T23:59:00.000', N'2018-06-30T23:59:00.000', N'2018-07-31T23:59:00.000', N'2018-08-31T23:59:00.000', N'2018-09-30T23:59:00.000', N'2018-10-31T23:59:00.000', N'2018-11-30T23:59:00.000', N'2018-12-31T23:59:00.000')
GO

--create partition schema
CREATE PARTITION SCHEME [ps_rptBetting_monthly] AS PARTITION [pf_rptBetting_monthly] TO ([rptBetting_09M01], [rptBetting_09M02], [rptBetting_09M03], [rptBetting_09M04], [rptBetting_09M05], [rptBetting_09M06], [rptBetting_09M07], [rptBetting_09M08], [rptBetting_09M09], [rptBetting_09M10], [rptBetting_09M11], [rptBetting_09M12], [rptBetting_10M01], [rptBetting_10M02], [rptBetting_10M03], [rptBetting_10M04], [rptBetting_10M05], [rptBetting_10M06], [rptBetting_10M07], [rptBetting_10M08], [rptBetting_10M09], [rptBetting_10M10], [rptBetting_10M11], [rptBetting_10M12], [rptBetting_11M01], [rptBetting_11M02], [rptBetting_11M03], [rptBetting_11M04], [rptBetting_11M05], [rptBetting_11M06], [rptBetting_11M07], [rptBetting_11M08], [rptBetting_11M09], [rptBetting_11M10], [rptBetting_11M11], [rptBetting_11M12], [rptBetting_12M01], [rptBetting_12M02], [rptBetting_12M03], [rptBetting_12M04], [rptBetting_12M05], [rptBetting_12M06], [rptBetting_12M07], [rptBetting_12M08], [rptBetting_12M09], [rptBetting_12M10], [rptBetting_12M11], [rptBetting_12M12], [rptBetting_13M01], [rptBetting_13M02], [rptBetting_13M03], [rptBetting_13M04], [rptBetting_13M05], [rptBetting_13M06], [rptBetting_13M07], [rptBetting_13M08], [rptBetting_13M09], [rptBetting_13M10], [rptBetting_13M11], [rptBetting_13M12], [rptBetting_14M01], [rptBetting_14M02], [rptBetting_14M03], [rptBetting_14M04], [rptBetting_14M05], [rptBetting_14M06], [rptBetting_14M07], [rptBetting_14M08], [rptBetting_14M09], [rptBetting_14M10], [rptBetting_14M11], [rptBetting_14M12], [rptBetting_15M01], [rptBetting_15M02], [rptBetting_15M03], [rptBetting_15M04], [rptBetting_15M05], [rptBetting_15M06], [rptBetting_15M07], [rptBetting_15M08], [rptBetting_15M09], [rptBetting_15M10], [rptBetting_15M11], [rptBetting_15M12], [rptBetting_16M01], [rptBetting_16M02], [rptBetting_16M03], [rptBetting_16M04], [rptBetting_16M05], [rptBetting_16M06], [rptBetting_16M07], [rptBetting_16M08], [rptBetting_16M09], [rptBetting_16M10], [rptBetting_16M11], [rptBetting_16M12], [rptBetting_17M01], [rptBetting_17M02], [rptBetting_17M03], [rptBetting_17M04], [rptBetting_17M05], [rptBetting_17M06], [rptBetting_17M07], [rptBetting_17M08], [rptBetting_17M09], [rptBetting_17M10], [rptBetting_17M11], [rptBetting_17M12], [rptBetting_18M01], [rptBetting_18M02], [rptBetting_18M03], [rptBetting_18M04], [rptBetting_18M05], [rptBetting_18M06], [rptBetting_18M07], [rptBetting_18M08], [rptBetting_18M09], [rptBetting_18M10], [rptBetting_18M11], [rptBetting_18M12], [rptBetting_MAX])
GO

CREATE TABLE [dbo].[rpt_Betting](
	[RecordID] [bigint] IDENTITY(1,1) NOT NULL,
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[LeagueID] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[Status] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[BetCount] [int] NULL,
	[MemberCount] [int] NULL,
	[Turnover] [money] NULL,
	[WinLoss] [money] NULL,
	[WinLossA] [money] NULL,
	[WinLossM] [money] NULL,
	[WinLossS] [money] NULL,
	[CommissionP] [money] NULL,
	[CommissionA] [money] NULL,
	[CommissionM] [money] NULL,
	[CommissionS] [money] NULL,
	[WinLossVirtual] [money] NULL,
	[CommissionSVirtual] [money] NULL,
	[CustomerCategory] [smallint] NULL,
	[BuyBackAmount] [money] NULL,
	[WinPrizeAmount] [money] NULL,
	[CashOutAmount] [money] NULL
) ON [ps_rptBetting_monthly]([rptDate])

GO

CREATE CLUSTERED INDEX [CIX_rpt_Betting] ON [dbo].[rpt_Betting] 
(
	[rptDate] ASC,
	[SiteID] ASC,
	[Bettype] ASC,
	[LeagueID] ASC,
	[CurrencyID] ASC,
	[Status] ASC,
	[IsLive] ASC,
	[CustomerCategory] ASC
)WITH (DATA_COMPRESSION = PAGE) ON [ps_rptBetting_monthly]([rptDate])
GO

CREATE NONCLUSTERED INDEX [IX_Sport] ON [dbo].[rpt_Betting] 
(
	[SiteID] ASC,
	[Bettype] ASC,
	[rptDate] ASC,
	[Status] ASC,
	[CurrencyID] ASC,
	[LeagueID] ASC
)
INCLUDE ( [Turnover]) WITH (DATA_COMPRESSION = PAGE) ON [ps_rptBetting_monthly]([rptDate])
GO

CREATE NONCLUSTERED INDEX [IXM_SiteID_Bettype_01] ON [dbo].[rpt_Betting] 
(
	[SiteID] ASC,
	[Bettype] ASC,
	[rptDate] ASC,
	[CurrencyID] ASC
)
INCLUDE ( [Status],
[CustomerCategory],
[Turnover],
[WinLoss],
[BetCount],
[CommissionA],
[CommissionP]) WITH (DATA_COMPRESSION = PAGE) ON [ps_rptBetting_monthly]([rptDate])
GO
