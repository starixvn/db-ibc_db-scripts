--====================== Create temp table to store temp data ====================================
--DBDW2.bodb_Archive
USE [bodb_Archive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tmpbettrans] (
	[transid] [bigint] NOT NULL
	,[winlostdate] [datetime] NULL
	,[custid] [int] NOT NULL
	,[site] [varchar](10) NULL
	,[IP] [varchar](15) NULL
	,[CountryCode] [varchar](2) NULL
	) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO

CREATE NONCLUSTERED INDEX [IX_winlostdate] ON [dbo].[tmpbettrans] (
	[winlostdate] ASC
	,[IP] ASC
	) INCLUDE ([custid])
GO

--====================== Load tickets from DB06 to DBDW2 using SSIS ====================================
--DB06.bodb_Archive
SELECT transid
	,winlostdate
	,b.custid
	,a.site
	,IP
	,CountryCode
FROM bodb_archive.dbo.bettrans_bk b WITH (NOLOCK)
	INNER JOIN bodb02.dbo.customer c WITH (NOLOCK) ON b.custid = c.custid
	INNER JOIN bodb02.dbo.customer a WITH (NOLOCK) ON c.recommend = a.custid
WHERE winlostdate BETWEEN '2014-11-1'
		AND '2014-11-30'

--====================== Update country & Aus filter ====================================
--DBDW2.bodb_Archive
DECLARE @from DATETIME
	,@to DATETIME

SELECT @from = '2014-1-4'
	,@to = '2014-3-14'

CREATE TABLE #IPs (
	IP VARCHAR(15)
	,CountryCode VARCHAR(2)
	)

INSERT INTO #IPs
SELECT DISTINCT IP
	,NULL
FROM tmpbettrans
WHERE winlostdate BETWEEN @from
		AND @to

UPDATE #IPs
SET CountryCode = CASE 
		WHEN len(IP) < 7
			THEN NULL
		ELSE bodb02.dbo.IP2Country(IP)
		END

CREATE CLUSTERED INDEX [#CIX_IP] ON #IPs (IP)

UPDATE b
SET CountryCode = i.CountryCode
FROM tmpbettrans b
	INNER JOIN #IPs i ON b.IP = i.IP
WHERE winlostdate BETWEEN @from
		AND @to
	AND i.CountryCode = 'AU'

DROP TABLE #IPs

--====================== Get SMA count ====================================
--DBLOG.bodb_customerlog
SELECT COUNT(DISTINCT userid)
FROM UserLog_Login b WITH (NOLOCK)
WHERE LogDate >= '2014-11-1'
	AND logdate < '2014-12-1'
	AND CountryCode = 'AUSTRALIA'
	AND RoleID IN (
		2
		,3
		,4
		)

--====================== Get Member count ====================================
--DBDW2.bodb_Archive
SELECT COUNT(DISTINCT custid) Bc
FROM tmpbettrans b
	LEFT JOIN bodb_Account.dbo.tbl_site s WITH (NOLOCK) ON b.site = s.site
WHERE winlostdate >= '2014-11-1'
	AND winlostdate < '2014-12-1'
	AND countrycode = 'AU'
	AND IsDeposit = 0
