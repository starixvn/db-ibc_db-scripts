/*
	Created: Elodie
	Date: 20161125
	Task: Change NG2 MinPT of Super for THAUS Headline
	DB: DBCUST/CustDB
*/
USE CustDB
GO

CREATE TABLE #Super (CustID INT)

INSERT INTO #Super (CustID)
SELECT ci.custid
FROM customer ci WITH(NOLOCK)
	INNER JOIN dbo.custAccount ca WITH (NOLOCK) ON ca.custid = ci.custid
WHERE ca.groupID = 515 AND roleid = 4

UNION ALL SELECT 21278849 AS custid -- dummy super

UPDATE cs
SET cs.MinPT = 80
FROM dbo.CustPTSetting3rd_Agent cs WITH (ROWLOCK,UPDLOCK)
	INNER JOIN #Super s ON s.CustID = cs.CustID
WHERE cs.SportType BETWEEN 213 AND 218

