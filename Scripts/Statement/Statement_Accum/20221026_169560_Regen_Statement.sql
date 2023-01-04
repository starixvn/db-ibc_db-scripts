/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20221026@Danny
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement [RedmineID: #169560]
*/
USE bodb_Report
SET NOCOUNT ON
-- 839 rows
SELECT    x.custID, x.AccDate, x.totalAmt, x.TransType, x.TransDesc 
INTO #tmp
FROM tmp_Statement_UAT x with(nolock)
LEFT JOIN Statement u ON x.CustID = u.CustID and x.AccDate = u.accdate AND x.transtype = u.transtype
WHERE u.custid IS NULL

INSERT INTO dbo.Statement (custID, AccDate, totalAmt, TransType, TransDesc)
SELECT custID, AccDate, totalAmt, TransType, TransDesc
FROM #tmp

UPDATE t WITH(ROWLOCK, UPDLOCK)
SET t.IsFixed = 1
FROM Statement_Accum_WrongBalance_UAT t 
INNER JOIN #tmp u ON t.custid = u.custid 

DROP TABLE #tmp

/*
-- 3115 cust fixed
ALTER TABLE Statement_Accum_WrongBalance_UAT ADD IsFixed BIT DEFAULT 0

UPDATE Statement_Accum_WrongBalance_UAT WITH(ROWLOCK, UPDLOCK)
SET IsFixed = 1
WHERE Diff_From IS NULL

; WITH u AS
(
	select custid,accdate,totalamt,transtype 
	from tmp_Statement_UAT with(nolock)
	WHERE TotalAmt_Old <> totalAmt
)

UPDATE t WITH(ROWLOCK, UPDLOCK)
SET t.totalamt = u.totalamt
FROM Statement t 
INNER JOIN u ON t.custid = u.custid AND t.accdate = u.accdate AND t.transtype = u.transtype

; WITH u AS
(
	select custid,accdate,totalamt,transtype 
	from tmp_Statement_UAT with(nolock)
	WHERE TotalAmt_Old <> totalAmt
)
UPDATE t WITH(ROWLOCK, UPDLOCK)
SET t.IsFixed = 1
FROM Statement_Accum_WrongBalance_UAT t 
INNER JOIN u ON t.custid = u.custid 
*/

/* -- Old

ALTER TABLE tmp_Statement_UAT add totalamt_Old MONEY

CREATE TABLE #CustID (CustID INT, RoleID TINYINT)
--CREATE TABLE tmp_Statement_UAT(
--		[custid] [int] NULL,
--		[accdate] [datetime] NULL,
--		[totalamt] [money] NULL,
--		[transtype] [nvarchar](50) NULL,
--		[transdesc] [nvarchar](300) NULL
--)
--CREATE CLUSTERED INDEX cix_#tmp_Statement ON tmp_Statement_UAT(custid, [accdate])


DECLARE @Diff_From_Tab TABLE (ID INT identity(1,1), Start_Regen DATETIME, End_Regen DATETIME, Diff_From DATETIME)

INSERT @Diff_From_Tab (Diff_From, Start_Regen, End_Regen)
SELECT	Diff_From, DATEADD(DAY, -7, Diff_From),   DATEADD(DAY, -1, Diff_From)
FROM	dbo.Statement_Accum_WrongBalance_UAT WITH(NOLOCK)
WHERE	Diff_From IS NOT NULL AND Diff_From <> '2022-07-15'
GROUP BY Diff_From
HAVING count(1) >= 20
ORDER BY Diff_From ASC


-- Regen by CustID and DiffFrom 
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
	WHERE	CustID IN (SELECT x.CustID FROM dbo.Statement_Accum_WrongBalance_UAT x WITH(NOLOCK) WHERE x.Diff_From = @Diff_From)
	ORDER BY RoleID

	IF EXISTS (SELECT TOP 1 1 FROM #CustID WHERE RoleID = 1)
	BEGIN
		INSERT INTO tmp_Statement_UAT(custid, accdate, totalamt, transtype, transdesc)
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
			HAVING SUM(t.BET) <> 0
				OR SUM(t.COM) <> 0
		) AS t
		cross apply (
			VALUES (t.BET, 'BET', 'Betting')
			,(t.COM, 'COM', 'Commission')
		) as rpt (TotalAmt, TransType, TransDesc)
		where rpt.TotalAmt <> 0
		ORDER BY t.winlostdate, t.custid

	END


	--IF EXISTS (SELECT TOP 1 1 FROM #CustID WHERE RoleID = 2)
	--BEGIN

	--	; WITH t AS
	--	(
	--		select recommend,winlostdate accdate,sum(awinlost) POS, sum(comm-playercomm) COMM
	--		from bodb_archive.dbo.bettrans_bk  with (nolock)
	--		where bettype between 1 and 19999 and winlostdate BETWEEN @Start_Regen AND @End_Regen
	--				AND recommend IN (SELECT x.CustID FROM #CustID x WHERE x.RoleID = 2)
	--		group by winlostdate,recommend
	--	)
	--	INSERT INTO tmp_Statement_UAT(custid, accdate, totalamt, transtype, transdesc)
	--	SELECT recommend, accdate, POS, 'POS' transtype, 'Position' transdesc
	--	FROM t t1
	--	WHERE t1.POS <> 0
	--	UNION ALL
	--	SELECT recommend, accdate, COMM, 'COM' transtype, 'Commission' transdesc
	--	FROM t t2
	--	WHERE t2.COMM <> 0
	--END

	--IF EXISTS (SELECT TOP 1 1 FROM #CustID WHERE RoleID = 3)
	--BEGIN

	--	; WITH t AS
	--	(
	--		select mrecommend,winlostdate accdate,sum(mwinlost) POS, sum(acomm-comm) COMM
	--		from bodb_archive.dbo.bettrans_bk  with (nolock)
	--		where bettype between 1 and 19999 and winlostdate BETWEEN @Start_Regen AND @End_Regen
	--				AND mrecommend IN (SELECT x.CustID FROM #CustID x WHERE x.RoleID = 3)
	--		group by winlostdate,mrecommend
	--	)
	--	INSERT INTO tmp_Statement_UAT(custid, accdate, totalamt, transtype, transdesc)
	--	SELECT mrecommend, accdate, POS, 'POS' transtype, 'Position' transdesc
	--	FROM t t1
	--	WHERE t1.POS <> 0
	--	UNION ALL
	--	SELECT mrecommend, accdate, COMM, 'COM' transtype, 'Commission' transdesc
	--	FROM t t2
	--	WHERE t2.COMM <> 0
	--END
	--IF EXISTS (SELECT TOP 1 1 FROM #CustID WHERE RoleID = 4)
	--BEGIN

	--	; WITH t AS
	--	(
	--		select srecommend,winlostdate accdate,sum(swinlost) POS, sum(scomm-acomm) COMM
	--		from bodb_archive.dbo.bettrans_bk  with (nolock)
	--		where bettype between 1 and 19999 and winlostdate BETWEEN @Start_Regen AND @End_Regen
	--				AND srecommend IN (SELECT x.CustID FROM #CustID x WHERE x.RoleID = 4)
	--		group by winlostdate,srecommend
	--	)
	--	INSERT INTO tmp_Statement_UAT(custid, accdate, totalamt, transtype, transdesc)
	--	SELECT srecommend, accdate, POS, 'POS' transtype, 'Position' transdesc
	--	FROM t t1
	--	WHERE t1.POS <> 0
	--	UNION ALL
	--	SELECT srecommend, accdate, COMM, 'COM' transtype, 'Commission' transdesc
	--	FROM t t2
	--	WHERE t2.COMM <> 0
	--END

	SELECT @i = @i + 1

	WAITFOR DELAY '00:00:01'
END



UPDATE t with(rowlock)
SET t.totalamt_Old = u.totalamt
FROM tmp_Statement_UAT t
INNER JOIN Statement u with(nolock) ON t.Custid = u.Custid AND t.AccDate = u.AccDate AND t.Transtype = u.Transtype

*/



