/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested="1"></info>*/
CREATE PROCEDURE [dbo].[Task_Statement_Accum_CheckData_Job]
AS
/*
	Created: 20220421@Danny
	DB: DBRPT-bodb_Report
	Task: Statement_Accum - Generate data

	Revisions:
		- 20220421@Percy: Initialize SP [RedmineID: #102322]
*/

BEGIN
SET NOCOUNT ON
	DECLARE @i INT, @n INT, @batch INT = 200
	DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
	INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
	EXEC bodb02.dbo.Age_SelBalanceUpDay

	DECLARE @BalanceUpDay SMALLDATETIME, @MoveBetsDay SMALLDATETIME
	SELECT  @BalanceUpDay = BalanceUpDay, @MoveBetsDay = MoveBetsDay FROM @MBBU

	CREATE TABLE #CustFinanceBal (CustID INT, TotalAmt MONEY, TotalAmt_Check MONEY, MinAccDate DATETIME)

	WHILE 1 = 1
	BEGIN
		TRUNCATE TABLE #CustFinanceBal

		UPDATE TOP(1000) d
		SET d.IsFinished = 1
		OUTPUT deleted.CustId, deleted.TotalAmt, deleted.MinAccDate
		INTO #CustFinanceBal(CustID, TotalAmt, MinAccDate)
		FROM Statement_Accum_CheckData_UAT d
		WHERE IsFinished = 0

		IF @@ROWCOUNT = 0 
			RETURN

		INSERT INTO dbo.Statement_Accum_WrongBalance(CustID, TotalAmt, TotalAmt_Recal)
		select t.CustID, t.TotalAmt, s.totalamt AS TotalAmt_Check
		FROM #CustFinanceBal  t
		CROSS APPLY (
			SELECT SUM(s.totalamt) totalamt
			FROM dbo.Statement s WITH(NOLOCK) 
			WHERE  t.CustID = s.custid 
			AND s.accdate < @BalanceUpDay 
			AND s.accdate >= t.MinAccDate
			AND (( s.transtype NOT IN ('BAL','GP') AND ACcDate >= '2011-12-31') OR (s.transtype  = 'BAL' AND ACcDate = '2011-12-31' )) 
		) s
		where t.TotalAmt <> s.totalamt

		WAITFOR DELAY '00:00:00.003'
	END

	DROP TABLE #CustFinanceBal

END
