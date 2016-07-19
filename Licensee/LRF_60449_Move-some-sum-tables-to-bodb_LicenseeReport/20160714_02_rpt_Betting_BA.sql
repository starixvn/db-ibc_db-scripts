use bodb_LicenseeReport
go
/*
	Task: rpt_Betting_BA table:
		- Create partitions
		- Create table with data compression on page level
		- Create index with data compression on page level
*/

DECLARE @MinPartitionRange DATETIME, @MaxPartitionRange DATETIME
	, @Temp DATETIME, @SqlCmd VARCHAR(MAX), @Prefix VARCHAR(50)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255), @PathFile2 VARCHAR(255)

SELECT @MinPartitionRange = '2009-01-31'
	, @MaxPartitionRange = '2016-12-31'
	, @PathFile = 'E:\IBC_DB\bodb_LicenseeReport\rpt_Betting_BA\'
	, @PathFile2 = 'D:\IBC_DB\bodb_LicenseeReport\rpt_Betting_BA\'
	, @Prefix = 'rptBetting_ba'
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
CREATE PARTITION FUNCTION [pf_rptBetting_ba_monthly](DATETIME) AS RANGE LEFT FOR VALUES (N'2009-01-31T23:59:00.000', N'2009-02-28T23:59:00.000', N'2009-03-31T23:59:00.000', N'2009-04-30T23:59:00.000', N'2009-05-31T23:59:00.000', N'2009-06-30T23:59:00.000', N'2009-07-31T23:59:00.000', N'2009-08-31T23:59:00.000', N'2009-09-30T23:59:00.000', N'2009-10-31T23:59:00.000', N'2009-11-30T23:59:00.000', N'2009-12-31T23:59:00.000', N'2010-01-31T23:59:00.000', N'2010-02-28T23:59:00.000', N'2010-03-31T23:59:00.000', N'2010-04-30T23:59:00.000', N'2010-05-31T23:59:00.000', N'2010-06-30T23:59:00.000', N'2010-07-31T23:59:00.000', N'2010-08-31T23:59:00.000', N'2010-09-30T23:59:00.000', N'2010-10-31T23:59:00.000', N'2010-11-30T23:59:00.000', N'2010-12-31T23:59:00.000', N'2011-01-31T23:59:00.000', N'2011-02-28T23:59:00.000', N'2011-03-31T23:59:00.000', N'2011-04-30T23:59:00.000', N'2011-05-31T23:59:00.000', N'2011-06-30T23:59:00.000', N'2011-07-31T23:59:00.000', N'2011-08-31T23:59:00.000', N'2011-09-30T23:59:00.000', N'2011-10-31T23:59:00.000', N'2011-11-30T23:59:00.000', N'2011-12-31T23:59:00.000', N'2012-01-31T23:59:00.000', N'2012-02-29T23:59:00.000', N'2012-03-31T23:59:00.000', N'2012-04-30T23:59:00.000', N'2012-05-31T23:59:00.000', N'2012-06-30T23:59:00.000', N'2012-07-31T23:59:00.000', N'2012-08-31T23:59:00.000', N'2012-09-30T23:59:00.000', N'2012-10-31T23:59:00.000', N'2012-11-30T23:59:00.000', N'2012-12-31T23:59:00.000', N'2013-01-31T23:59:00.000', N'2013-02-28T23:59:00.000', N'2013-03-31T23:59:00.000', N'2013-04-30T23:59:00.000', N'2013-05-31T23:59:00.000', N'2013-06-30T23:59:00.000', N'2013-07-31T23:59:00.000', N'2013-08-31T23:59:00.000', N'2013-09-30T23:59:00.000', N'2013-10-31T23:59:00.000', N'2013-11-30T23:59:00.000', N'2013-12-31T23:59:00.000', N'2014-01-31T23:59:00.000', N'2014-02-28T23:59:00.000', N'2014-03-31T23:59:00.000', N'2014-04-30T23:59:00.000', N'2014-05-31T23:59:00.000', N'2014-06-30T23:59:00.000', N'2014-07-31T23:59:00.000', N'2014-08-31T23:59:00.000', N'2014-09-30T23:59:00.000', N'2014-10-31T23:59:00.000', N'2014-11-30T23:59:00.000', N'2014-12-31T23:59:00.000', N'2015-01-31T23:59:00.000', N'2015-02-28T23:59:00.000', N'2015-03-31T23:59:00.000', N'2015-04-30T23:59:00.000', N'2015-05-31T23:59:00.000', N'2015-06-30T23:59:00.000', N'2015-07-31T23:59:00.000', N'2015-08-31T23:59:00.000', N'2015-09-30T23:59:00.000', N'2015-10-31T23:59:00.000', N'2015-11-30T23:59:00.000', N'2015-12-31T23:59:00.000', N'2016-01-31T23:59:00.000', N'2016-02-29T23:59:00.000', N'2016-03-31T23:59:00.000', N'2016-04-30T23:59:00.000', N'2016-05-31T23:59:00.000', N'2016-06-30T23:59:00.000', N'2016-07-31T23:59:00.000', N'2016-08-31T23:59:00.000', N'2016-09-30T23:59:00.000', N'2016-10-31T23:59:00.000', N'2016-11-30T23:59:00.000', N'2016-12-31T23:59:00.000')
GO
GO

--create partition schema
CREATE PARTITION SCHEME [ps_rptBetting_ba_monthly] AS PARTITION [pf_rptBetting_ba_monthly] TO ([rptBetting_ba_09M01], [rptBetting_ba_09M02], [rptBetting_ba_09M03], [rptBetting_ba_09M04], [rptBetting_ba_09M05], [rptBetting_ba_09M06], [rptBetting_ba_09M07], [rptBetting_ba_09M08], [rptBetting_ba_09M09], [rptBetting_ba_09M10], [rptBetting_ba_09M11], [rptBetting_ba_09M12], [rptBetting_ba_10M01], [rptBetting_ba_10M02], [rptBetting_ba_10M03], [rptBetting_ba_10M04], [rptBetting_ba_10M05], [rptBetting_ba_10M06], [rptBetting_ba_10M07], [rptBetting_ba_10M08], [rptBetting_ba_10M09], [rptBetting_ba_10M10], [rptBetting_ba_10M11], [rptBetting_ba_10M12], [rptBetting_ba_11M01], [rptBetting_ba_11M02], [rptBetting_ba_11M03], [rptBetting_ba_11M04], [rptBetting_ba_11M05], [rptBetting_ba_11M06], [rptBetting_ba_11M07], [rptBetting_ba_11M08], [rptBetting_ba_11M09], [rptBetting_ba_11M10], [rptBetting_ba_11M11], [rptBetting_ba_11M12], [rptBetting_ba_12M01], [rptBetting_ba_12M02], [rptBetting_ba_12M03], [rptBetting_ba_12M04], [rptBetting_ba_12M05], [rptBetting_ba_12M06], [rptBetting_ba_12M07], [rptBetting_ba_12M08], [rptBetting_ba_12M09], [rptBetting_ba_12M10], [rptBetting_ba_12M11], [rptBetting_ba_12M12], [rptBetting_ba_13M01], [rptBetting_ba_13M02], [rptBetting_ba_13M03], [rptBetting_ba_13M04], [rptBetting_ba_13M05], [rptBetting_ba_13M06], [rptBetting_ba_13M07], [rptBetting_ba_13M08], [rptBetting_ba_13M09], [rptBetting_ba_13M10], [rptBetting_ba_13M11], [rptBetting_ba_13M12], [rptBetting_ba_14M01], [rptBetting_ba_14M02], [rptBetting_ba_14M03], [rptBetting_ba_14M04], [rptBetting_ba_14M05], [rptBetting_ba_14M06], [rptBetting_ba_14M07], [rptBetting_ba_14M08], [rptBetting_ba_14M09], [rptBetting_ba_14M10], [rptBetting_ba_14M11], [rptBetting_ba_14M12], [rptBetting_ba_15M01], [rptBetting_ba_15M02], [rptBetting_ba_15M03], [rptBetting_ba_15M04], [rptBetting_ba_15M05], [rptBetting_ba_15M06], [rptBetting_ba_15M07], [rptBetting_ba_15M08], [rptBetting_ba_15M09], [rptBetting_ba_15M10], [rptBetting_ba_15M11], [rptBetting_ba_15M12], [rptBetting_ba_16M01], [rptBetting_ba_16M02], [rptBetting_ba_16M03], [rptBetting_ba_16M04], [rptBetting_ba_16M05], [rptBetting_ba_16M06], [rptBetting_ba_16M07], [rptBetting_ba_16M08], [rptBetting_ba_16M09], [rptBetting_ba_16M10], [rptBetting_ba_16M11], [rptBetting_ba_16M12], [rptBetting_ba_MAX])
GO

CREATE TABLE [dbo].[rpt_Betting_BA](
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
	[BuyBackAmount] [money] NULL,
	[CustomerCategory] [smallint] NULL
) ON [ps_rptBetting_ba_monthly]([rptDate])

GO

CREATE CLUSTERED INDEX [CIX_rpt_Betting_BA] ON [dbo].[rpt_Betting_BA] 
(
	[rptDate] ASC,
	[SiteID] ASC,
	[Bettype] ASC,
	[LeagueID] ASC,
	[CurrencyID] ASC,
	[Status] ASC,
	[IsLive] ASC
)WITH (DATA_COMPRESSION = PAGE) ON [ps_rptBetting_ba_monthly]([rptDate])
GO
