
DECLARE @sql varchar(MAX)

DECLARE @parts TABLE
(
	partNo int,
	filegroup varchar(20),
	HasCompression bit
)

INSERT INTO @parts
SELECT 25, 'BETBK_12M01', 1 UNION ALL
SELECT 26, 'BETBK_12M02', 1 UNION ALL
SELECT 27, 'BETBK_12M03', 1 UNION ALL
SELECT 28, 'BETBK_12M04', 1 UNION ALL
SELECT 29, 'BETBK_12M05', 1 UNION ALL
SELECT 30, 'BETBK_12M06', 1 UNION ALL
SELECT 31, 'BETBK_12M07', 1 UNION ALL
SELECT 32, 'BETBK_12M08', 1 UNION ALL
SELECT 33, 'BETBK_12M09', 0 UNION ALL
SELECT 34, 'BETBK_12M10', 0 UNION ALL
SELECT 35, 'BETBK_12M11', 0 UNION ALL
SELECT 36, 'BETBK_12M12', 0

SELECT @sql = ''
SELECT @sql = @sql + '/*/////////////////// START DELETE PART ' + filegroup + '//////////////////////////////////// */

CREATE TABLE [dbo].[bettrans_bk_staging](
	[custid] [int] NOT NULL,
	[transdate] [datetime] NOT NULL,
	[oddsid] [int] NOT NULL,
	[hdp1] [smallmoney] NULL,
	[hdp2] [smallmoney] NULL,
	[odds] [smallmoney] NULL,
	[stake] [money] NOT NULL,
	[actual_stake] [money] NULL,
	[status] [varchar](10) NULL,
	[winlost] [money] NULL,
	[awinlost] [money] NULL,
	[mwinlost] [money] NULL,
	[swinlost] [money] NULL,
	[playercomm] [money] NULL,
	[comm] [money] NULL,
	[acomm] [money] NULL,
	[scomm] [money] NULL,
	[apositiontaking] [smallmoney] NULL,
	[mpositiontaking] [smallmoney] NULL,
	[spositiontaking] [smallmoney] NULL,
	[tpositiontaking] [smallmoney] NULL,
	[playerdiscount] [decimal](9, 8) NULL,
	[discount] [decimal](9, 8) NULL,
	[adiscount] [decimal](9, 8) NULL,
	[sdiscount] [decimal](9, 8) NULL,
	[livehomescore] [smallint] NULL,
	[liveawayscore] [smallint] NULL,
	[liveindicator] [bit] NULL,
	[betteam] [varchar](10) NULL,
	[creator] [int] NOT NULL,
	[refno] [bigint] NULL,
	[winlostdate] [smalldatetime] NULL,
	[betfrom] [varchar](1) NULL,
	[betcheck] [varchar](50) NULL,
	[checktime] [datetime] NULL,
	[oddsspread] [smallmoney] NULL,
	[actualrate] [float] NULL,
	[matchid] [int] NULL,
	[recommend] [int] NULL,
	[mrecommend] [int] NULL,
	[srecommend] [int] NULL,
	[ruben] [tinyint] NULL,
	[betid] [bigint] NULL,
	[statuswinlost] [tinyint] NULL,
	[modds] [smallmoney] NULL,
	[betdaqid] [bigint] NULL,
	[tstamp] [binary](8) NULL,
	[currency] [tinyint] NULL,
	[ip] [varchar](15) NULL,
	[transdesc] [nvarchar](1000) NULL,
	[virtualrate] [float] NULL,
	[oddstype] [tinyint] NULL,
	[statusID] [tinyint] NULL,
	[currency2] [tinyint] NULL,
	[transid] [bigint] NOT NULL,
	[bettype] [smallint] NULL,
	[balance] [money] NULL,
	[transid2] [bigint] NULL,
	[SecAcceptFlag] [bit] NULL,
	[recommdate] [datetime] NULL,
	[comstatus] [nvarchar](20) NULL,
	[site] [varchar](10) NULL,
	[CountryCode] [varchar](2) NULL,
	[oddsspread_new] [money] NULL
) ON [' + filegroup + ']' + 
CASE WHEN HasCompression = 1 THEN '
WITH
(
DATA_COMPRESSION = PAGE
)'
ELSE '' END + '

CREATE CLUSTERED INDEX [CIX_winlostdate_staging] ON [dbo].[bettrans_bk_staging] 
(
	[winlostdate] ASC
)

ALTER TABLE dbo.bettrans_bk SWITCH PARTITION ' + CONVERT(varchar(2), partNo) + ' TO dbo.bettrans_bk_staging

DROP TABLE dbo.bettrans_bk_staging

/*////////////////////////////////////END DELETE PART ' + filegroup + '//////////////////////////////////// */'

FROM @parts

select CAST(@sql AS XML)