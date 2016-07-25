USE bodb_LicenseeReport
GO
/*
	Task: Create bettrans table
*/

DECLARE @SqlCmd VARCHAR(MAX)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255)

SELECT @PathFile = 'E:\IBC_DB\bodb_LicenseeReport\'

--create file group for staging data
SET @FileGroupName = 'LicenseeReport_Staging_Data'
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

SET @SqlCmd = ''
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
	+ ''', FILENAME = N''' + @PathFile + @FileGroupName + '.ndf''
	, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)
GO

CREATE TABLE [dbo].[bettrans](
	[transid] [bigint] NOT NULL,
	[custid] [int] NOT NULL,
	[stake] [money] NOT NULL,
	[statusid] [tinyint] NULL,
	[status] [nvarchar](15) NULL,
	[winlost] [money] NULL,
	[awinlost] [money] NULL,
	[mwinlost] [money] NULL,
	[playercomm] [money] NULL,
	[comm] [money] NULL,
	[acomm] [money] NULL,
	[apositiontaking] [smallmoney] NULL,
	[mpositiontaking] [smallmoney] NULL,
	[tpositiontaking] [smallmoney] NULL,
	[liveindicator] [bit] NULL,
	[betteam] [nvarchar](10) NULL,
	[winlostdate] [smalldatetime] NULL,
	[betfrom] [nvarchar](1) NULL,
	[actualrate] [float] NULL,
	[matchid] [int] NULL,
	[recommend] [int] NOT NULL,
	[mrecommend] [int] NOT NULL,
	[actual_stake] [money] NULL,
	[currency] [tinyint] NULL,
	[scomm] [money] NULL,
	[spositiontaking] [smallmoney] NULL,
	[swinlost] [money] NULL,
	[srecommend] [int] NOT NULL,
	[refno] [bigint] NULL,
	[transdate] [datetime] NULL,
	[bettype] [smallint] NULL,
	[virtualrate] [float] NULL,
	[isBA] [bit] NULL,
	[discount] [decimal](9, 8) NULL,
	[customercategory] [smallint] NULL,
	[site] [varchar](10) NULL,
	[CashInAmount] [money] NULL,
	[WinPrizeAmount] [money] NULL,
	[CashOutAmount] [money] NULL,
 CONSTRAINT [PK_bettrans] PRIMARY KEY CLUSTERED 
(
	[transid] ASC
) ON [LicenseeReport_Staging_Data]
) ON [LicenseeReport_Staging_Data]

GO

CREATE NONCLUSTERED INDEX [IX_winlostdate_bettype_currency] ON [dbo].[bettrans] 
(
	[winlostdate] ASC,
	[bettype] ASC,
	[currency] ASC
)
INCLUDE ( [liveindicator],
[customercategory],
[custid],
[stake],
[winlost],
[actual_stake],
[awinlost],
[mwinlost],
[swinlost],
[playercomm],
[comm],
[acomm],
[scomm],
[virtualrate],
[isBA],
[statusid],
[matchid],
[recommend]) ON [LicenseeReport_Staging_Data]
GO

ALTER TABLE [dbo].[bettrans] ADD  CONSTRAINT [DF_bettrans_isBA]  DEFAULT ((0)) FOR [isBA]
GO

ALTER TABLE [dbo].[bettrans] ADD  CONSTRAINT [DF_bettrans_customercategory]  DEFAULT ((-1)) FOR [customercategory]
GO