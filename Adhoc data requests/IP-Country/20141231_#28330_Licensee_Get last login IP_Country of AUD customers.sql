
--============For 12BET ====================================================================
--DB052.bodb02
CREATE TABLE #IPs(IP varchar(20), Country varchar(2))

INSERT INTO #IPs(IP)
SELECT distinct iplogin
FROM customer c WITH (NOLOCK)
	INNER JOIN Dep_CustSuper ds WITH (NOLOCK) ON c.srecommend = ds.custid
WHERE roleid = 1
	AND c.currency = 9
	AND iplogin IS NOT NULL

UPDATE #IPs SET Country = dbo.IP2Country(IP)

SELECT ds.site Licensee
	,c.Username
	,iplogin [Last Login IP]
	,lastlogged [Last Login Date]
	,isnull(co.countryLONG, 'Unknown') Country
FROM customer c WITH (NOLOCK)
	INNER JOIN Dep_CustSuper ds WITH (NOLOCK) ON c.srecommend = ds.custid
	LEFT JOIN #IPs i ON c.iplogin = i.IP
	LEFT JOIN bodb_Licensee.dbo.Country co WITH (NOLOCK) ON i.Country = co.countrySHORT
WHERE roleid = 1
	AND c.currency = 9
	AND iplogin IS NOT NULL
ORDER BY Licensee, username

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
select transid, winlostdate, b.custid, s.site, b.Currency, IP, CountryCode, bettype, matchid,
	winlost, stake, actual_stake, awinlost, mwinlost, swinlost, scomm, actualrate, virtualrate, tpositiontaking
from bodb_archive.dbo.bettrans_bk b with (nolock) 
	inner join bodb02.dbo.customer c with (nolock) on b.custid = c.custid
	inner join bodb02.dbo.Dep_CustSuper s with (nolock) on c.srecommend = s.custid
where winlostdate between '2013-1-1' and '2013-1-31'
	and c.currency = 9 and s.site <> '12BET'

--DBSPARE.bodb_Archive09
select transid, winlostdate, b.custid, s.site, b.Currency, IP, NULL CountryCode, bettype, matchid,
	winlost, stake, actual_stake, awinlost, mwinlost, swinlost, scomm, actualrate, virtualrate, tpositiontaking
from dbo.bettrans_2009 b with (nolock) 
	inner join DB06.bodb02.dbo.customer c with (nolock) on b.custid = c.custid
	inner join DB06.bodb02.dbo.Dep_CustSuper s with (nolock) on c.srecommend = s.custid
where winlostdate >= '2009-7-7'
	and c.currency = 9 and s.site = 'mansion88'	
	

----------- Get data + update country info -------------		
--DBDW2.bodb_Archive
select ds.site, c.custid, c.username, lastlogged into #cust from bodb02.dbo.customer c with (nolock)
	INNER JOIN bodb02.dbo.Dep_CustSuper ds WITH (NOLOCK) ON c.srecommend = ds.custid 
where c.roleid = 1 and c.currency = 9 and ds.site <> '12BET'

CREATE CLUSTERED INDEX [#CIX_ID] ON #cust(custid)

;WITH custIP AS
(
select distinct b.custid, winlostdate, IP 
from dbo.tmpbettrans b with (nolock) 
	inner join #cust c ON b.custid = c.custid
--where winlostdate = '2012-12-1'
)
select custid, winlostdate, IP INTO #LastCustIP from 
(
	select custid, IP, winlostdate, ROW_NUMBER() over (PARTITION by custid order by winlostdate desc) rownum
	from custIP
) A
where rownum = 1

CREATE TABLE #IPs(IP varchar(20), Country varchar(50))

INSERT INTO #IPs(IP) SELECT distinct IP FROM #LastCustIP

UPDATE #IPs SET Country = bodb02.dbo.IP2Country(IP)

select site Licensee, c.Username, cl.IP [Last Login IP], winlostdate [Last login Date], CountryLong Country
from #cust c 
	inner join #LastCustIP cl on c.custid = cl.custid
	inner join #IPs i on cl.IP = i.IP
	LEFT JOIN DB052.bodb_licensee.dbo.Country co WITH (NOLOCK) ON i.Country = co.countrySHORT
order by Licensee, username
	
drop table #LastCustIP
drop table #IPs
drop table #cust
		
		