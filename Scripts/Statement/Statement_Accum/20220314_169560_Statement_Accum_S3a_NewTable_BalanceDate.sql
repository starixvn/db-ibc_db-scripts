/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220314@Percy
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
		Step 3a: Initialize data for Cust_Statement & BalanceDate
*/

USE bodb_Report
GO

-- Clean up data
DELETE dbo.Cust_Statement
GO
DELETE dbo.BalanceDate
GO

-- I. Cust_Statement
-- 1. Initialize: 8s (6805784 rows affected)
INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT DISTINCT CustId, '2022-06-10'
FROM dbo.Statement_Accum WITH (NOLOCK)
WHERE AccDate IN ('2022-06-10', '2022-06-17')

-- 2. CustIds have bet tickets: 55s (216155 rows affected)
;WITH CTE_CustId AS (
	SELECT DISTINCT c.CustId
	FROM (
		SELECT custid, recommend, mrecommend, srecommend
		FROM bodb_archive.dbo.bettrans_bk WITH (NOLOCK)
		WHERE winlostdate BETWEEN '2022-06-10' AND '2022-06-23'
		GROUP BY custid, recommend, mrecommend, srecommend
	) b
		CROSS APPLY (
			SELECT b.custid
			UNION SELECT b.recommend
			UNION SELECT b.mrecommend
			UNION SELECT b.srecommend
		) c
)
INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT cc.CustId, '2022-06-10'
FROM CTE_CustId cc
	LEFT JOIN dbo.Cust_Statement cs WITH (NOLOCK) ON cc.CustId = cs.CustId
WHERE cs.CustId IS NULL

-- 3. CustIds have transfer tickets
	-- Transfer_bk: 23s (206623 rows affected)
INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT t.CustId, '2022-06-10'
FROM (
	SELECT custid
	FROM bodb_archive.dbo.transfer_bk WITH (NOLOCK)
	WHERE winlostdate BETWEEN '2022-05-27' AND '2022-06-23'
		AND transdate >= '2022-06-10' AND transdate < '2022-06-24'
	GROUP BY custid
) t
	LEFT JOIN dbo.Cust_Statement cs WITH (NOLOCK) ON t.CustId = cs.CustId
WHERE cs.CustId IS NULL

	-- Transfer: 2s (0 rows affected)
INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT t.CustId, '2022-06-10'
FROM (
	SELECT custid
	FROM bodb02.dbo.Transfer WITH (NOLOCK)
	WHERE winlostdate BETWEEN '2022-06-24' AND '2022-07-01'
		AND transdate >= '2022-06-10' AND transdate < '2022-06-24'
	GROUP BY custid
) t
	LEFT JOIN dbo.Cust_Statement cs WITH (NOLOCK) ON t.CustId = cs.CustId
WHERE cs.CustId IS NULL

-- 4. CustIds have payout trans: 0s (0 rows affected)
INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT p.CustId, '2022-06-10'
FROM (
	SELECT CustId
	FROM bodb02.dbo.PayoutTrans WITH (NOLOCK)
	WHERE winlostdate BETWEEN '2022-06-10' AND '2022-06-23'
		AND PayoutStatusId IN (4, 5)
	GROUP BY CustId
) p
	LEFT JOIN dbo.Cust_Statement cs WITH (NOLOCK) ON p.CustId = cs.CustId
WHERE cs.CustId IS NULL


-- II. BalanceDate
INSERT INTO dbo.BalanceDate (FromDate, ToDate)
VALUES
	('2022-06-10', '2022-06-16')
	,('2022-06-17', '2022-06-23')