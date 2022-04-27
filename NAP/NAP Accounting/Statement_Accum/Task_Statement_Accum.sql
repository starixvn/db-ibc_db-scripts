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
	END

	-- Insert Statement_Accum
	BEGIN
		CREATE TABLE #Statement_Accum (CustId INT, AccDate DATETIME, TotalAmt MONEY, IsDiffAmt TINYINT DEFAULT(0))

		INSERT INTO #Statement_Accum (CustId, AccDate, TotalAmt)
		SELECT CustId, CASE WHEN accdate = @InitBalDate THEN accdate ELSE DATEADD(DAY, 1, accdate) END AS accdate, totalamt_accum
		FROM (
			SELECT c.CustId, b.AccDate, b.IsBal, s.transtype
				,SUM(ISNULL(s.totalamt, 0))
					OVER(PARTITION BY c.CustId ORDER BY ISNULL(s.accdate, b.accdate), CASE WHEN s.transtype = 'Bal' THEN 0 ELSE 1 END) AS totalamt_accum
			FROM dbo.BalanceDate b WITH (NOLOCK)
				CROSS JOIN @Customer c
				LEFT JOIN dbo.Statement s WITH (NOLOCK) ON s.custid = c.CustId AND b.accdate > s.accdate - 1 AND b.accdate <= s.accdate AND (s.transtype <> 'Bal' OR s.accdate = @InitBalDate)
			WHERE b.accdate >= @StartAccDate
		) t
		WHERE totalamt_accum <> 0
			AND (
				IsBal = 1
				OR (accdate = @InitBalDate AND transtype = 'Bal')
			)

		DELETE t
		FROM (
			SELECT CustId, ROW_NUMBER() OVER(PARTITION BY CustId, AccDate ORDER BY AccDate) AS RN
			FROM #Statement_Accum
		) t
		WHERE t.RN > 1

		DELETE s WITH (ROWLOCK)
		FROM dbo.Statement_Accum s
			INNER JOIN #Statement_Accum t ON s.CustId = t.CustId AND s.AccDate = t.AccDate

		INSERT INTO dbo.Statement_Accum (CustId, AccDate, TotalAmt)
		SELECT CustId, AccDate, TotalAmt FROM #Statement_Accum
	END

	-- Update Cust_Statement table
	BEGIN
		UPDATE t
		SET t.IsDiffAmt = 1
		FROM #Statement_Accum t
			LEFT JOIN dbo.Statement s WITH (NOLOCK) ON t.CustId = s.custid AND t.AccDate = s.accdate AND s.transtype = 'Bal'
		WHERE s.custid IS NULL OR t.TotalAmt <> s.totalamt

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
END
GO