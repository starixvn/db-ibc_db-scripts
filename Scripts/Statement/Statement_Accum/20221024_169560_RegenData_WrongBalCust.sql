/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20221013@Danny
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
*/

USE bodb_Report
GO

DECLARE @balDate TABLE (balDate DATETIME)
INSERT INTO @balDate(balDate)
SELECT AccDate FROM Statement WITH(NOLOCK) WHERE CustID = 3 AND TransType = 'BAL'  AND accdate >= '2011-12-31'
UNION ALL SELECT '2022-10-14' AS AccDate
ORDER BY AccDate ASC

CREATE TABLE #CustID (ID INT Identity (1,1) PRIMARY KEY, CustID INT)
INSERT INTO #CustID (CustID)
SELECT CustID FROM dbo.Statement_Accum_WrongBalance_UAT WITH(NOLOCK) 

DECLARE @i INT = 1, @CustID_Regen INT 
WHILE EXISTS (SELECT TOP 1 1 FROM #CustID WHERE ID = @i)
BEGIN

	SELECT @CustID_Regen  =  CustID FROM #CustID WHERE ID = @i 

	; with t as (
	  select b.balDate, x.totalAmt
	  FROM @balDate b
	  CROSS APPLY (
		SELECT totalamt FROM Statement_Accum x with(nolock) where x.AccDate = b.balDate AND x.CustId = @CustID_Regen
	  ) x
	), u AS
	(
	  SELECT b.balDate, x.totalAmt
	  FROM @balDate b
	  CROSS APPLY (
	  SELECT SUM(totalamt) totalamt
	  FROM Statement x with(nolock) 
	  where x.AccDate < b.balDate 
	  AND x.CustId = @CustID_Regen 
	  AND ( x.transtype NOT IN ('BAL','GP') OR  (x.transtype  = 'BAL' AND ACcDate = '2011-12-31' )) 
	  AND ACcDate >= '2011-12-31'
	  ) x
	), result_ AS
	(

		SELECT t.balDate, t.totalAmt, u.totalAmt AS totalAmt_recal, CASE WHEN t.totalAmt <> u.totalAmt THEN 1 ELSE 0 END isDiff
		FROM t 
		LEFT JOIN u ON t.balDate = u.balDate
	)
	UPDATE s
	SET s.TotalAmt = r.totalAmt_recal
	FROM Statement_Accum s with(ROWLOCK, UPDLOCK)
	INNER JOIN result_ r ON s.AccDate = r.balDate
	WHERE r.isDiff = 1 AND s.CustId = @CustID_Regen

	SELECT @i = @i + 1
END


