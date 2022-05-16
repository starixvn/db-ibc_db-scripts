/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Task_Statement_Accum]
	@CustIds		VARCHAR(MAX)
	,@StartAccDate	DATETIME
AS

/*
	Created: 20220421@Percy
	DB: DBRPT-bodb_Report
	Task: Statement_Accum - Generate data by CustId

	Revisions:
		- 20220421@Percy: Initialize SP [RedmineID: #102322]
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @InitBalDate DATETIME = '2011-12-31'

	-- Get Customer List
	BEGIN
		DECLARE @Customer TABLE (CustId INT)
		INSERT INTO @Customer (CustId)
		SELECT value FROM STRING_SPLIT(@CustIds, ',')

		DECLARE @State_Cust TABLE (CustId INT) -- custid has data on Statement
	END

	-- Insert Statement_Accum
	BEGIN
		CREATE TABLE #tmpData (CustId INT, AccDate DATETIME, TotalAmt MONEY, PRIMARY KEY (CustId, AccDate))
		CREATE TABLE #Statement_Accum (CustId INT, AccDate DATETIME, TotalAmt MONEY, IsDiffAmt TINYINT DEFAULT(0), PRIMARY KEY (CustId, AccDate))
		
		INSERT INTO #tmpData (CustId, AccDate, TotalAmt)
		SELECT s.CustId, CONVERT(DATE, CASE WHEN s.transtype <> 'Bal' AND s.AccDate = @InitBalDate THEN DATEADD(DAY, 1, AccDate) ELSE AccDate END), SUM(s.totalamt)
		FROM @Customer c
			INNER JOIN dbo.Statement s WITH (NOLOCK) ON s.custid = c.CustId
		WHERE s.AccDate >= @StartAccDate
			AND (s.transtype <> 'Bal' OR s.AccDate = @InitBalDate)
		GROUP BY s.CustId, CONVERT(DATE, CASE WHEN s.transtype <> 'Bal' AND s.AccDate = @InitBalDate THEN DATEADD(DAY, 1, AccDate) ELSE AccDate END)

		INSERT INTO @State_Cust (CustId)
		SELECT DISTINCT CustId FROM #tmpData

		;WITH CTE_Statement AS (
			SELECT c.CustId, CASE WHEN t.AccDate = @InitBalDate THEN DATEADD(DAY, -1, @InitBalDate) ELSE b.ToDate END AS ToDate, SUM(ISNULL(t.TotalAmt, 0)) AS TotalAmt
			FROM dbo.BalanceDate b WITH (NOLOCK)
				CROSS JOIN @State_Cust c
				LEFT JOIN #tmpData t ON t.custid = c.CustId AND t.accdate BETWEEN b.FromDate AND b.ToDate
			WHERE b.ToDate >= @StartAccDate
			GROUP BY c.CustId, CASE WHEN t.AccDate = @InitBalDate THEN DATEADD(DAY, -1, @InitBalDate) ELSE b.ToDate END
		)
		INSERT INTO #Statement_Accum (CustId, AccDate, TotalAmt)
		SELECT CustId, AccDate, TotalAmt
		FROM (
			SELECT CustId, DATEADD(DAY, 1, ToDate) AS AccDate
				,SUM(TotalAmt) OVER(PARTITION BY CustId ORDER BY ToDate) AS TotalAmt
			FROM CTE_Statement
		) t
		WHERE TotalAmt <> 0
		
		DELETE s WITH (ROWLOCK)
		FROM dbo.Statement_Accum s
			INNER JOIN #Statement_Accum t ON s.CustId = t.CustId AND s.AccDate = t.AccDate

		INSERT INTO dbo.Statement_Accum (CustId, AccDate, TotalAmt)
		SELECT CustId, AccDate, TotalAmt FROM #Statement_Accum
	END

	-- Update Cust_Statement table
	BEGIN
		--UPDATE t
		--SET t.IsDiffAmt = 1
		--FROM #Statement_Accum t
		--	LEFT JOIN dbo.Statement s WITH (NOLOCK) ON t.CustId = s.custid AND t.AccDate = s.accdate AND s.transtype = 'Bal'
		--WHERE s.custid IS NULL OR t.TotalAmt <> s.totalamt

		;WITH CTE_Statement_Accum AS (
			SELECT CustId, MIN(AccDate) AS StartDate, MAX(AccDate) AS EndDate, MAX(IsDiffAmt) AS IsDiffAmt
			FROM #Statement_Accum
			GROUP BY CustId
		)
		UPDATE cs WITH (ROWLOCK)
		SET cs.StartDate = s.StartDate, cs.EndDate = s.EndDate, cs.IsDiffAmt = ISNULL(s.IsDiffAmt, 0), cs.IsFinished = 1
		FROM dbo.Cust_Statement cs
			INNER JOIN @Customer c ON cs.CustId = c.CustId
			LEFT JOIN CTE_Statement_Accum s ON c.CustId = s.CustId
	END

	DROP TABLE #Statement_Accum
	DROP TABLE #tmpData
END
GO