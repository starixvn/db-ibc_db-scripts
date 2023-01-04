/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20221013@Danny
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
*/
SET NOCOUNT ON
CREATE TABLE Statement_Accum_CheckData_UAT	
(
	[CustId] [int] PRIMARY KEY,
	[TotalAmt] [money] NULL,
	IsFinished BIT DEFAULT 0,
	MinAccDate DATETIME
)


INSERT INTO Statement_Accum_CheckData_UAT(CustId, TotalAmt, IsFinished, MinAccDate)
SELECT t.CustId, sa.TotalAmt, 0, t.MinAccDate
FROM DB06.bodb_report.dbo.Statement_Accum_CheckData_UAT t WITH(NOLOCK)
INNER JOIN DB06.bodb_report.dbo.Statement_Accum_WrongBalance_UAT s WITH(NOLOCK) ON t.CustId = s.CustId
INNER JOIN DB06.bodb_report.dbo.Statement_Accum  sa WITH(NOLOCK) ON t.CustId = sa.CustId AND sa.AccDate = '2022-11-04'

INSERT INTO Statement_Accum_WrongBalance_UAT(CustID, TotalAmt)
SELECT CustId, TotalAmt FROM Statement_Accum_CheckData_UAT WITH(NOLOCK)

DECLARE @balDate TABLE (balDate DATETIME)
INSERT INTO @balDate(balDate)
SELECT AccDate FROM Statement WITH(NOLOCK) WHERE CustID = 3 AND TransType = 'BAL'  AND accdate >= '2011-12-31'
UNION ALL
SELECT '2022-11-04' AS AccDate
ORDER BY AccDate ASC

CREATE TABLE #CustID (ID INT Identity (1,1) PRIMARY KEY, CustID INT)
INSERT INTO #CustID (CustID)
SELECT CustID FROM dbo.Statement_Accum_WrongBalance_UAT WITH(NOLOCK) 

DECLARE @i INT = 1,  @CustID_Check INT
​
WHILE EXISTS (SELECT TOP 1 1 FROM #CustID WITH(NOLOCK) WHERE ID = @i )  
BEGIN
	SELECT @CustID_Check = CustID FROM  #CustID WHERE ID = @i
	​
	 with t as (
	  select b.balDate, x.totalAmt
	  FROM @balDate b
	  CROSS APPLY (
  		SELECT totalamt FROM Statement_Accum x with(nolock) where x.AccDate = b.balDate AND x.CustId = @CustID_Check
	  ) x
	), u AS
	(
	  SELECT b.balDate, x.totalAmt
	  FROM @balDate b
	  CROSS APPLY (
	  SELECT SUM(totalamt) totalamt
	  FROM Statement x with(nolock) 
	  where x.AccDate < b.balDate 
	  AND x.CustId = @CustID_Check 
	  AND ( x.transtype NOT IN ('BAL','GP') OR  (x.transtype  = 'BAL' AND ACcDate = '2011-12-31' )) 
	  AND ACcDate >= '2011-12-31'
	  ) x
	), result as 
	( SELECT t.balDate ,t.totalAmt, u.totalAmt as amt_recheck, CASE WHEN t.totalAmt <> u.totalAmt THEN 1 ELSE 0 END isDiff
	FROM t 
	LEFT JOIN u ON t.balDate = u.balDate
	)
	UPDATE x
	SET x.Diff_From = r.balDate,
		x.TotalAmt_Recal = r1.amt_recheck
	FROM  dbo.Statement_Accum_WrongBalance_UAT x WITH(ROWLOCK, UPDLOCK)
	OUTER APPLY(
		SELECT MIN(balDate) balDate FROM result r WHERE isDiff = 1
	) r
	OUTER APPLY(
		SELECT r.amt_recheck FROM result r WHERE balDate = '2022-11-04'
	) r1
	WHERE x.CustID = @CustID_Check 

	SELECT @i = @i +1
END

DROP TABLE #CustID​