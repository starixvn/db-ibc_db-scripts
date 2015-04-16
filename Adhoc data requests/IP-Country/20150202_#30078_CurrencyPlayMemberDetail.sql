--DB06.bodb02

declare @from datetime, @to datetime

select @from = '2015-3-1'
select @to = dateadd(MM, 1, @from)

SELECT l.LicenseeID, CountryCode, bettrans.currency,bettrans.custid,
		SUM(
			case when bettrans.liveawayscore = 0 and bettrans.bettype IN(33,43) then ABS(bettrans.stake/2) else ABS(bettrans.stake) end
			) as TurnOver,
		SUM(winlost-actual_stake)  winlost,
		COUNT(bettrans.transid) BetCount,		
		--114: half win, 115: half lose
		CASE 
			WHEN bettrans.status = 'WON' AND bettrans.bettype IN(1,3,7,8,17,18) AND ABS(modds) = 0.25 THEN 114 
			WHEN bettrans.status = 'LOSE' AND bettrans.bettype IN(1,3,7,8,17,18) AND ABS(modds) = 0.25 THEN 115
			WHEN bettrans.status = 'WON' THEN 112
			WHEN bettrans.status = 'LOSE' THEN 113
			WHEN bettrans.status = 'DRAW' THEN 111
			END AS statusID
INTO #tmp	
FROM
	bodb_archive.dbo.bettrans_bk bettrans WITH (NOLOCK)
	INNER JOIN bodb02.dbo.customer WITH (NOLOCK) ON bettrans.custid=customer.custid
	INNER JOIN bodb02.dbo.dep_custsuper s WITH (NOLOCK) ON customer.srecommend = s.custid
	INNER JOIN DB052.bodb_licensee.dbo.Licensees l WITH (NOLOCK) ON s.site = l.LicenseeName
WHERE
	bettrans.winlostdate >= @from AND winlostdate < @to AND
	bettrans.status IN ('WON','LOSE','DRAW') AND
	bettrans.Currency IN (2,4,13,15) AND
	bettrans.currency <> 20
GROUP BY
	l.LicenseeID,
	CountryCode,
	bettrans.currency,
	bettrans.custid,
	CASE 
	WHEN bettrans.status = 'WON' AND bettrans.bettype IN(1,3,7,8,17,18) AND ABS(modds) = 0.25 THEN 114 
	WHEN bettrans.status = 'LOSE' AND bettrans.bettype IN(1,3,7,8,17,18) AND ABS(modds) = 0.25 THEN 115
	WHEN bettrans.status = 'WON' THEN 112
	WHEN bettrans.status = 'LOSE' THEN 113
	WHEN bettrans.status = 'DRAW' THEN 111
	END

SELECT
    l.LicenseeName,
    e.Code,
    CASE
        WHEN b.currency = 2 THEN 'MALAYSIA'
        WHEN b.currency = 4 THEN 'THAILAND'
        WHEN b.currency = 13 THEN 'CHINA'
        WHEN b.currency = 15 THEN 'INDONESIA'  
    END AS CurrencyCountry,
    c.username,
    CASE WHEN ISNULL(ct.countryLONG,'') IN ('','-') THEN 'UNKNOWN'
		ELSE ct.countryLONG END as country,
	SUM(CASE WHEN b.statusID = 111  THEN 0
						WHEN b.statusID IN (114,115) THEN 0.5
						WHEN b.statusID IN (112,113) THEN 1 ELSE 0 END * turnover ) AS TurnoverWL,
	SUM(CASE WHEN statusID IN (112,113,111,114,115) THEN turnover ELSE 0 END ) AS TurnoverWLD,
	SUM(winlost) AS winlost,
	sum(BetCount) as betcount
	--count(CustID) as membercount
FROM #tmp b WITH (NOLOCK)
    INNER join DB052.bodb_licensee.dbo.Licensees l WITH (NOLOCK) ON l.licenseeid = b.licenseeid
    INNER join bodb02.dbo.exchange e WITH (NOLOCK) ON b.currency = e.exchangeid
    INNER join bodb02.dbo.customer c WITH (NOLOCK) ON b.custid = c.custid
	LEFT JOIN DB052.bodb_licensee.dbo.country ct WITH (NOLOCK) ON b.countryCode = ct.countrySHORT
--WHERE
	--b.Currency IN (2,4,13,15) --MALAYSIA,THAILAND,CHINA,INDONESIA
GROUP BY l.LicenseeName,b.currency, c.username,
	e.Code,CASE WHEN ISNULL(ct.countryLONG,'') IN ('','-') THEN 'UNKNOWN' ELSE ct.countryLONG END
ORDER BY LicenseeName, e.code,CASE WHEN ISNULL(ct.countryLONG,'') IN ('','-') THEN 'UNKNOWN' ELSE ct.countryLONG END

drop table #tmp