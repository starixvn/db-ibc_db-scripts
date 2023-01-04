/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20221026@Danny
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement [RedmineID: #169560]
*/
USE bodb_Report
SET NOCOUNT ON

/* Update table Statement_Accum_WrongBalance_UAT
-- Mark IsFixed =1
 1. Diff_From IS NULL
 2. Total_Amt Recal 061 = 62
*/
--UPDATE dbo.Statement_Accum_WrongBalance_UAT WITH(ROWLOCK, UPDLOCK)
--SET IsFixed = 1 
--WHERE Diff_From IS NULL

--; with source_062 AS
--(
--	select * from DB06.bodb_report.dbo.Statement_Accum_WrongBalance_UAT with(nolock)
--)
--Update s_061 WITH(ROWLOCK, UPDLOCK)
--SET   s_061.IsFixed =1
--FROM   dbo.Statement_Accum_WrongBalance_UAT s_061 
--INNER JOIN source_062 s_062 ON s_061.CustID = s_062.CustID AND s_061.Diff_from = s_062.Diff_From AND s_061.TotalAmt_Recal = s_062.TotalAmt_Recal

-- Fix Statement with IsFixed =1
--DECLARE @CustIDs VARCHAR(MAX), @SQL  VARCHAR(MAX)

--SELECT @CustIDs = STRING_AGG (CAST(custID AS VARCHAR(MAX)), ',')
--FROM  dbo.Statement_Accum_WrongBalance_UAT WITH(NOLOCK)
--WHERE  IsFixed = 1 AND  Diff_From IS NOT NULL

--SELECT @SQL = ' SELECT custid, accdate, totalamt, transtype, transdesc
--						FROM OPENQUERY (DB06, '' SELECT custid, accdate, totalamt, transtype, transdesc
--													FROM bodb_report.dbo.tmp_Statement_UAT lc WITH(NOLOCK)
--													WHERE lc.CustID IN (SELECT value FROM STRING_SPLIT('''''+@CustIDs+''''','''',''''))
--												''
--						)
--				'
--INSERT INTO tmp_Statement_UAT(custid, accdate, totalamt, transtype, transdesc)
--EXEC( @SQL)


-- Insert more tmp_Statement_UAT (cross check with bettrans_bk DB061)
GO
CREATE TABLE #CustID (CustID INT, RoleID TINYINT)
DECLARE @Diff_From_Tab TABLE (ID INT identity(1,1), Start_Regen DATETIME, End_Regen DATETIME, Diff_From DATETIME)

INSERT @Diff_From_Tab (Diff_From, Start_Regen, End_Regen)
SELECT	Diff_From, DATEADD(DAY, -7, Diff_From),   DATEADD(DAY, -1, Diff_From)
FROM	dbo.Statement_Accum_WrongBalance_UAT WITH(NOLOCK)
WHERE	Diff_From IS NOT NULL AND Diff_From >='2019-01-01' AND IsFixed = 0
GROUP BY Diff_From
ORDER BY Diff_From ASC

DECLARE @Start_Regen DATETIME
DECLARE @End_Regen   DATETIME
DECLARE @Diff_From   DATETIME
DECLARE @i INT = 1

WHILE EXISTS (SELECT TOP 1 1 FROM @Diff_From_Tab WHERE ID = @i)
BEGIN
	TRUNCATE TABLE #CustID

	SELECT @Start_Regen = Start_Regen, 
		   @End_Regen = End_Regen,
		   @Diff_From = Diff_From
	FROM @Diff_From_Tab WHERE  ID = @i

	INSERT INTO #CustID(CustID, RoleID)
	SELECT	CustID, RoleID
	FROM	bodb02.dbo.Customer WITH(NOLOCK)
	WHERE	CustID IN (SELECT x.CustID FROM dbo.Statement_Accum_WrongBalance_UAT x WITH(NOLOCK) WHERE x.Diff_From = @Diff_From and IsFixed =0 )
	ORDER BY RoleID

	IF EXISTS (SELECT TOP 1 1 FROM #CustID WHERE RoleID = 1)
	BEGIN
		; WITH statement_source as
		(
			SELECT CustID, AccDate, TotalAmt, TransType, TransDesc
			FROM dbo.Statement WITH (NOLOCK)
			WHERE CustID IN (SELECT x.CustID FROM #CustID x WHERE x.RoleID = 1)
				AND TransType IN ('BET','COM')
				AND accdate BETWEEN  @Start_Regen AND @End_Regen
		),
		bk_source as
		(
			Select t.custid, t.winlostdate AS Accdate, TotalAmt, TransType, TransDesc
			from (
				SELECT b.winlostdate, t.custid, SUM(t.BET) AS BET, SUM(t.COM) AS COM
				FROM bodb_Archive.dbo.bettrans_bk b WITH (NOLOCK)
					CROSS APPLY (
						SELECT b.custid, b.winlost - b.actual_stake AS BET, b.playercomm AS COM
					) t
				WHERE winlostdate BETWEEN  @Start_Regen AND @End_Regen
				AND b.custid IN (SELECT x.CustID FROM #CustID x WHERE x.RoleID = 1)
				GROUP BY b.winlostdate, t.custid
			) AS t
			cross apply (
				VALUES (t.BET, 'BET', 'Betting')
				,(t.COM, 'COM', 'Commission')
			) as rpt (TotalAmt, TransType, TransDesc)
		)
		INSERT INTO tmp_Statement_UAT(custid, accdate, totalamt, transtype, transdesc)
		SELECT	b.custid, b.accdate, b.totalamt, b.transtype, b.transdesc
		FROM	bk_source b
		LEFT JOIN statement_source s ON b.custid = s.custid AND b.Accdate = s.accdate AND b.TransType = s.transtype
		WHERE b.TotalAmt <> s.totalamt OR s.custid IS NULL

	END

	select @i = @i + 1
END