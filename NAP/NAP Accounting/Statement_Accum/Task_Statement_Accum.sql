/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Task_Statement_Accum]
	@CustId INT
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

	-- Insert Statement_Accum
	BEGIN
		CREATE TABLE #Statement_Accum (AccDate DATETIME, TotalAmt MONEY)

		INSERT INTO #Statement_Accum (AccDate, TotalAmt)
		SELECT t.accdate, t.totalamt_accum
		FROM (
			SELECT s.accdate, s.transtype, s.totalamt
				,SUM(CASE WHEN s.transtype <> 'Bal' OR s.accdate = '2011-12-31' THEN s.totalamt ELSE 0 END)
					OVER(ORDER BY accdate, CASE WHEN s.transtype = 'Bal' THEN 0 ELSE 1 END) AS totalamt_accum
			FROM dbo.Statement s WITH (NOLOCK)
			WHERE s.custid = @CustId
				AND s.accdate >= '2011-12-31' -- First day have 'BAL'
		) t
		WHERE t.totalamt_accum <> 0 AND t.transtype = 'Bal'

		DELETE s WITH (ROWLOCK)
		FROM dbo.Statement_Accum s
			INNER JOIN #Statement_Accum t ON s.AccDate = t.AccDate
		WHERE s.CustId = @CustId

		INSERT INTO dbo.Statement_Accum (CustId, AccDate, TotalAmt)
		SELECT @CustId, AccDate, TotalAmt FROM #Statement_Accum
	END

	-- Update Cust_Statement table
	BEGIN
		DECLARE @StartDate DATETIME, @EndDate DATETIME, @IsDiffAmt BIT = 0
		SELECT  @StartDate = MIN(AccDate), @EndDate = MAX(AccDate) FROM #Statement_Accum

		IF EXISTS (
			SELECT 1
			FROM #Statement_Accum t
				INNER JOIN dbo.Statement s WITH (NOLOCK) ON t.AccDate = s.accdate AND s.transtype = 'Bal'
			WHERE s.custid = @CustId AND t.TotalAmt <> s.totalamt
		)
			SET @IsDiffAmt = 1

		UPDATE dbo.Cust_Statement WITH (ROWLOCK)
		SET StartDate = @StartDate, EndDate = @EndDate, IsDiffAmt = @IsDiffAmt, IsFinished = 1
		WHERE CustId = @CustId
	END

	DROP TABLE #Statement_Accum
END
GO