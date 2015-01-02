--============For 12BET ====================================================================
--DB052.bodb02
CREATE TABLE #IPs (
	IP VARCHAR(20)
	,Country VARCHAR(2)
	)

INSERT INTO #IPs (IP)
SELECT DISTINCT iplogin
FROM customer c WITH (NOLOCK)
INNER JOIN Dep_CustSuper ds WITH (NOLOCK)
	ON c.srecommend = ds.custid
WHERE roleid = 1
	AND c.currency = 9
	AND iplogin IS NOT NULL

UPDATE #IPs
SET Country = dbo.IP2Country(IP)

SELECT ds.site Licensee
	,c.Username
	,iplogin [Last Login IP]
	,lastlogged [Last Login Date]
	,isnull(co.countryLONG, 'Unknown') Country
FROM customer c WITH (NOLOCK)
INNER JOIN Dep_CustSuper ds WITH (NOLOCK)
	ON c.srecommend = ds.custid
LEFT JOIN #IPs i
	ON c.iplogin = i.IP
LEFT JOIN bodb_Licensee.dbo.Country co WITH (NOLOCK)
	ON i.Country = co.countrySHORT
WHERE roleid = 1
	AND c.currency = 9
	AND iplogin IS NOT NULL
ORDER BY Licensee
	,username

DROP TABLE #IPs

--//////////////////////////////////////////////////////////////////////////////////////////////////////
--============For Other Licensees ====================================================================
------Create temp table to store temp data----
--DBDW2.bodb_Archive
CREATE TABLE [dbo].[tmpbettrans] (
	[transid] [bigint] NOT NULL
	,[winlostdate] [datetime] NULL
	,[custid] [int] NOT NULL
	,[site] [varchar](10) NULL
	,[IP] [varchar](15) NULL
	,[CountryCode] [varchar](2) NULL
	) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_winlostdate] ON [dbo].[tmpbettrans] (
	[winlostdate] ASC
	,[IP] ASC
	,custID ASC
	)
GO

----------- Load tickets from DB06 to DBDW2 using SSIS -----------
--DB06.bodb_Archive
SELECT transid
	,winlostdate
	,b.custid
	,s.site
	,b.Currency
	,IP
	,CountryCode
	,bettype
	,matchid
	,winlost
	,stake
	,actual_stake
	,awinlost
	,mwinlost
	,swinlost
	,scomm
	,actualrate
	,virtualrate
	,tpositiontaking
FROM bodb_archive.dbo.bettrans_bk b WITH (NOLOCK)
INNER JOIN bodb02.dbo.customer c WITH (NOLOCK)
	ON b.custid = c.custid
INNER JOIN bodb02.dbo.Dep_CustSuper s WITH (NOLOCK)
	ON c.srecommend = s.custid
WHERE winlostdate BETWEEN '2013-1-1'
		AND '2013-1-31'
	AND c.currency = 9
	AND s.site <> '12BET'

--DBSPARE.bodb_Archive09
SELECT transid
	,winlostdate
	,b.custid
	,s.site
	,b.Currency
	,IP
	,NULL CountryCode
	,bettype
	,matchid
	,winlost
	,stake
	,actual_stake
	,awinlost
	,mwinlost
	,swinlost
	,scomm
	,actualrate
	,virtualrate
	,tpositiontaking
FROM dbo.bettrans_2009 b WITH (NOLOCK)
INNER JOIN DB06.bodb02.dbo.customer c WITH (NOLOCK)
	ON b.custid = c.custid
INNER JOIN DB06.bodb02.dbo.Dep_CustSuper s WITH (NOLOCK)
	ON c.srecommend = s.custid
WHERE winlostdate >= '2009-7-7'
	AND c.currency = 9
	AND s.site = 'mansion88'

----------- Get data + update country info -------------		
--DBDW2.bodb_Archive
SELECT ds.site
	,c.custid
	,c.username
	,lastlogged
INTO #cust
FROM bodb02.dbo.customer c WITH (NOLOCK)
INNER JOIN bodb02.dbo.Dep_CustSuper ds WITH (NOLOCK)
	ON c.srecommend = ds.custid
WHERE c.roleid = 1
	AND c.currency = 9
	AND ds.site <> '12BET'

CREATE CLUSTERED INDEX [#CIX_ID] ON #cust (custid);

WITH custIP
AS (
	SELECT DISTINCT b.custid
		,winlostdate
		,IP
	FROM dbo.tmpbettrans b WITH (NOLOCK)
	INNER JOIN #cust c
		ON b.custid = c.custid
			--where winlostdate = '2012-12-1'
	)
SELECT custid
	,winlostdate
	,IP
INTO #LastCustIP
FROM (
	SELECT custid
		,IP
		,winlostdate
		,ROW_NUMBER() OVER (
			PARTITION BY custid ORDER BY winlostdate DESC
			) rownum
	FROM custIP
	) A
WHERE rownum = 1

CREATE TABLE #IPs (
	IP VARCHAR(20)
	,Country VARCHAR(50)
	)

INSERT INTO #IPs (IP)
SELECT DISTINCT IP
FROM #LastCustIP

UPDATE #IPs
SET Country = bodb02.dbo.IP2Country(IP)

SELECT site Licensee
	,c.Username
	,cl.IP [Last Login IP]
	,winlostdate [Last login Date]
	,CountryLong Country
FROM #cust c
INNER JOIN #LastCustIP cl
	ON c.custid = cl.custid
INNER JOIN #IPs i
	ON cl.IP = i.IP
LEFT JOIN DB052.bodb_licensee.dbo.Country co WITH (NOLOCK)
	ON i.Country = co.countrySHORT
ORDER BY Licensee
	,username

DROP TABLE #LastCustIP

DROP TABLE #IPs

DROP TABLE #cust
