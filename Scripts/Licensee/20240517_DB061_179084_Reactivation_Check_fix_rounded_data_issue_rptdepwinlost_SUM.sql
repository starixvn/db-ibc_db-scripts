/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested=""></info>*/

/*
	Created: 20240514@Evan
	DB: DBRPT-bodb_Report
	Task: Reactivation - Check & fix rounded data issue [Redmine: 179084]
	Run on DB061
*/
USE bodb_Report

SET NOCOUNT ON

DECLARE @fdate SMALLDATETIME = '2022-03-30'
DECLARE @tdate SMALLDATETIME ='2022-04-01'
DECLARE @Msg VARCHAR (500),@rowCount BIGINT

-- List cust diff value, diff date
DROP TABLE IF EXISTS #tmp1
CREATE TABLE #tmp1  ( recommend INT, winlostdate SMALLDATETIME, Diff_Amt MONEY, OpeningBalance_SUM MONEY, OpeningBalance_bk MONEY)
DECLARE @cdate SMALLDATETIME = @fdate

SET @Msg = 'Start Update data from  (2022-03-30 -> 2022-04-01)'
RAISERROR (@Msg , 0, 1) WITH NOWAIT

WHILE (@cdate <= @tdate)
BEGIN

	;WITH cte_rptDepwinlost_SUM
	AS 
	(
		SELECT winlostdate,custid
			 , SUM(OpeningBalance) OpeningBalance
		FROM [rptDepwinlost_SUM] a (nolock)
		WHERE winlostdate  = @cdate
		GROUP BY winlostdate,custid
	), 
	cte_rptDepWinlost_bk 
	AS(
		SELECT  a.recommend,winlostdate
			 , SUM(OpeningBalance) OpeningBalance
		FROM rptDepWinlost_bk(nolock) a
		WHERE winlostdate = @cdate
		GROUP BY a.recommend,winlostdate
	)
	INSERT INTO #tmp1 (recommend,winlostdate,OpeningBalance_SUM,OpeningBalance_bk,Diff_Amt)
	SELECT a.recommend,a.winlostdate,a.OpeningBalance_SUM,a.OpeningBalance_bk,a.Diff_Amt
	FROM 
		(
			SELECT b.recommend,a.winlostdate, a.OpeningBalance AS OpeningBalance_SUM , b.OpeningBalance AS OpeningBalance_bk, (b.OpeningBalance - a.OpeningBalance) AS Diff_Amt
			FROM cte_rptDepwinlost_SUM a
				INNER JOIN cte_rptDepWinlost_bk b ON a.custid=b.recommend AND a.winlostdate=b.winlostdate
			WHERE a.OpeningBalance <> b.OpeningBalance
		) a
	set @cdate = DATEADD (DAY,1,@cdate)
END

--SELECT tmp.winlostdate
--	 , tmp.recommend
--	 , tmp.Diff_Amt
--	 , tmp.OpeningBalance_bk
--	 , b.OpeningBalance + tmp.Diff_Amt as OpeningBalance_Sum_Correct
--FROM rptDepwinlost_SUM b WITH (NOLOCK)
--	INNER JOIN #tmp1 tmp ON tmp.recommend = b.recommend
--		AND tmp.winlostdate = b.winlostdate

UPDATE b
SET  b.ClosingBalance = b.ClosingBalance + tmp.Diff_Amt
	,b.OpeningBalance =  b.OpeningBalance + tmp.Diff_Amt
FROM rptdepwinlost_SUM b WITH(ROWLOCK)
	INNER JOIN #tmp1 tmp ON tmp.recommend = b.recommend AND tmp.winlostdate = b.winlostdate

SELECT @rowCount = @@RowCount

SET @Msg = 'Done Update data from  (2022-03-30 -> 2022-04-01) - Affected row: ' + CAST(@rowCount AS VARCHAR(50))
RAISERROR (@Msg , 0, 1) WITH NOWAIT

-- List cust diff same value
DROP TABLE IF EXISTS #tmp2
CREATE TABLE #tmp2 (
	  recommend INT
	, DiffAmt MONEY
	, DiffDate SMALLDATETIME -- Date of detection diff data
	, Isfinished BIT DEFAULT (0)
)

INSERT INTO #tmp2 (recommend, DiffAmt,DiffDate)
VALUES	(44521398, 10844.00, '2020-12-27 00:00:00'),
		(28762596, -340.00, '2021-01-02 00:00:00'),
		(47655767, 300.00, '2021-03-10 00:00:00'),
		(36351345, -410.00, '2021-05-27 00:00:00'),
		(832127, 3146.00, '2021-07-07 00:00:00'),
		(932285, 500.00, '2021-07-07 00:00:00'),
		(932318, -14600.16, '2021-07-07 00:00:00'),
		(1574128, -2750.00, '2021-07-07 00:00:00'),
		(1574142, -30000.00, '2021-07-07 00:00:00'),
		(1574169, -1698.71, '2021-07-07 00:00:00'),
		(2748136, 7837.00, '2021-07-07 00:00:00'),
		(3167474, 12800.00, '2021-07-07 00:00:00'),
		(3287411, -12630.00, '2021-07-07 00:00:00'),
		(4359497, 2442.05, '2021-07-07 00:00:00'),
		(4833330, 7062.45, '2021-07-07 00:00:00'),
		(8092082, -50.00, '2021-07-07 00:00:00'),
		(10580771, 2886.00, '2021-07-07 00:00:00'),
		(10580780, 8020.00, '2021-07-07 00:00:00'),
		(10580789, -69276.11, '2021-07-07 00:00:00'),
		(10580809, 300.00, '2021-07-07 00:00:00'),
		(11325216, -37.20, '2021-07-07 00:00:00'),
		(11325245, 17000.00, '2021-07-07 00:00:00'),
		(12252985, -12000.04, '2021-07-07 00:00:00'),
		(12254096, 200.32, '2021-07-07 00:00:00'),
		(12613254, -30000.00, '2021-07-07 00:00:00'),
		(12924654, 193.00, '2021-07-07 00:00:00'),
		(13456491, 1468.05, '2021-07-07 00:00:00'),
		(13682921, 33837.00, '2021-07-07 00:00:00'),
		(14649184, 77.00, '2021-07-07 00:00:00'),
		(16379950, -958.00, '2021-07-07 00:00:00'),
		(17126510, -1003.00, '2021-07-07 00:00:00'),
		(17126542, 291.00, '2021-07-07 00:00:00'),
		(17126662, 2661.00, '2021-07-07 00:00:00'),
		(17855477, -414.00, '2021-07-07 00:00:00'),
		(18722193, 436.00, '2021-07-07 00:00:00'),
		(20121329, -7288.27, '2021-07-07 00:00:00'),
		(21475592, -421.00, '2021-07-07 00:00:00'),
		(21536369, 2.00, '2021-07-07 00:00:00'),
		(21975130, -112.00, '2021-07-07 00:00:00'),
		(22773655, -1016.00, '2021-07-07 00:00:00'),
		(23400679, 14581.00, '2021-07-07 00:00:00'),
		(23400766, 140.00, '2021-07-07 00:00:00'),
		(24294794, -469.28, '2021-07-07 00:00:00'),
		(24509707, -45814.73, '2021-07-07 00:00:00'),
		(26130119, 1080.00, '2021-07-07 00:00:00'),
		(26616925, -50.00, '2021-07-07 00:00:00'),
		(26854656, -14029.00, '2021-07-07 00:00:00'),
		(27429152, 437.50, '2021-07-07 00:00:00'),
		(28627546, -2591.00, '2021-07-07 00:00:00'),
		(28680707, -100.00, '2021-07-07 00:00:00'),
		(28762598, -1134.00, '2021-07-07 00:00:00'),
		(28926987, -1051.05, '2021-07-07 00:00:00'),
		(28927039, 5313.14, '2021-07-07 00:00:00'),
		(29315711, 3185.00, '2021-07-07 00:00:00'),
		(29336840, -411.00, '2021-07-07 00:00:00'),
		(29594660, -634.00, '2021-07-07 00:00:00'),
		(29721029, 1575.00, '2021-07-07 00:00:00'),
		(31588875, 300.35, '2021-07-07 00:00:00'),
		(31607891, 42604.00, '2021-07-07 00:00:00'),
		(31719325, -1589.00, '2021-07-07 00:00:00'),
		(32100893, -577.00, '2021-07-07 00:00:00'),
		(32657299, 27933.08, '2021-07-07 00:00:00'),
		(32951619, 11807.47, '2021-07-07 00:00:00'),
		(33257248, 500.00, '2021-07-07 00:00:00'),
		(33663781, -3720.00, '2021-07-07 00:00:00'),
		(33733100, -453.00, '2021-07-07 00:00:00'),
		(34189195, 369.00, '2021-07-07 00:00:00'),
		(34189599, 150.00, '2021-07-07 00:00:00'),
		(34190907, -795.00, '2021-07-07 00:00:00'),
		(35479117, -2527.00, '2021-07-07 00:00:00'),
		(35554779, 121.00, '2021-07-07 00:00:00'),
		(36100453, -399.00, '2021-07-07 00:00:00'),
		(36130225, -10826.00, '2021-07-07 00:00:00'),
		(36236357, 7430.00, '2021-07-07 00:00:00'),
		(36351347, -13500.00, '2021-07-07 00:00:00'),
		(36750404, 1450.22, '2021-07-07 00:00:00'),
		(36976128, -2222.00, '2021-07-07 00:00:00'),
		(37099104, -19.00, '2021-07-07 00:00:00'),
		(37208414, 5935.00, '2021-07-07 00:00:00'),
		(38103529, 2226.00, '2021-07-07 00:00:00'),
		(38321520, 2552.00, '2021-07-07 00:00:00'),
		(38338995, 24502.47, '2021-07-07 00:00:00'),
		(38339092, 6519.57, '2021-07-07 00:00:00'),
		(38469047, 700.00, '2021-07-07 00:00:00'),
		(38583561, 909.28, '2021-07-07 00:00:00'),
		(38729550, -582.00, '2021-07-07 00:00:00'),
		(38729925, 49666.00, '2021-07-07 00:00:00'),
		(38916162, 7534.17, '2021-07-07 00:00:00'),
		(39020202, 4000000.00, '2021-07-07 00:00:00'),
		(39175464, -39.00, '2021-07-07 00:00:00'),
		(39264238, -652.00, '2021-07-07 00:00:00'),
		(39469792, -23542.00, '2021-07-07 00:00:00'),
		(39516598, -109.00, '2021-07-07 00:00:00'),
		(39640836, -6785.60, '2021-07-07 00:00:00'),
		(39744339, 549.40, '2021-07-07 00:00:00'),
		(40053268, 100.00, '2021-07-07 00:00:00'),
		(40144606, -948.00, '2021-07-07 00:00:00'),
		(40193415, 931.00, '2021-07-07 00:00:00'),
		(40282910, -120.00, '2021-07-07 00:00:00'),
		(40483109, -194.87, '2021-07-07 00:00:00'),
		(40515743, 9.00, '2021-07-07 00:00:00'),
		(40586146, -172.00, '2021-07-07 00:00:00'),
		(40695066, -290.18, '2021-07-07 00:00:00'),
		(41252469, 1524.00, '2021-07-07 00:00:00'),
		(41617360, -392.00, '2021-07-07 00:00:00'),
		(42166985, -7269.00, '2021-07-07 00:00:00'),
		(42506122, -614.20, '2021-07-07 00:00:00'),
		(42690192, -1086.00, '2021-07-07 00:00:00'),
		(43049467, 8.00, '2021-07-07 00:00:00'),
		(43054419, 2000.76, '2021-07-07 00:00:00'),
		(43454884, 13657.49, '2021-07-07 00:00:00'),
		(43844054, -1079.00, '2021-07-07 00:00:00'),
		(43844257, 5184.00, '2021-07-07 00:00:00'),
		(44249384, -1000.00, '2021-07-07 00:00:00'),
		(44376670, 15313.00, '2021-07-07 00:00:00'),
		(44521400, -1550.00, '2021-07-07 00:00:00'),
		(44599726, 842.00, '2021-07-07 00:00:00'),
		(44672524, -4.00, '2021-07-07 00:00:00'),
		(44674529, 211.00, '2021-07-07 00:00:00'),
		(45285414, 1173.73, '2021-07-07 00:00:00'),
		(45530891, 251.74, '2021-07-07 00:00:00'),
		(46063414, -245.00, '2021-07-07 00:00:00'),
		(46083722, -2008.00, '2021-07-07 00:00:00'),
		(46496085, -16596.00, '2021-07-07 00:00:00'),
		(46774759, -6081.00, '2021-07-07 00:00:00'),
		(46883703, -102.00, '2021-07-07 00:00:00'),
		(47066391, -104134.00, '2021-07-07 00:00:00'),
		(47178614, -301800.00, '2021-07-07 00:00:00'),
		(47178677, -50.00, '2021-07-07 00:00:00'),
		(47676033, -1200.00, '2021-07-07 00:00:00'),
		(48030209, -500.00, '2021-07-07 00:00:00'),
		(48984451, -1000.00, '2021-07-07 00:00:00'),
		(49149357, -885.00, '2021-07-07 00:00:00'),
		(50340259, -6719.00, '2021-07-07 00:00:00'),
		(51100394, -300.00, '2021-07-07 00:00:00'),
		(51793122, -4.00, '2021-07-07 00:00:00'),
		(6630793, -12.056, '2021-07-24 00:00:00'),
		(836230, -3367.80, '2021-10-01 00:00:00'),
		(860387, 7539.1058, '2021-10-01 00:00:00'),
		(932187, -184.75, '2021-10-01 00:00:00'),
		(932255, -9280.91, '2021-10-01 00:00:00'),
		(10580724, -100.6224, '2022-03-07 00:00:00'),
		(4833644, 220.90, '2022-03-16 00:00:00');

SET @Msg = 'Start Insert data from  (2022-03-30 -> 2022-04-01)'
RAISERROR (@Msg , 0, 1) WITH NOWAIT

-- Insert data from  '2022-03-30' -> '2022-04-01'
INSERT INTO dbo.rptDepwinlost_SUM (
		winlostdate
		,custid
		,currency
		,recommend
		,srecommend	
		,OpeningBalance
		,Deposit
		,Withdrawal
		,Aff2MemTransfer
		,Bonus
		,Adjustment
		,Turnover
		,Outstanding
		,Winloss
		,ClosingBalance
		,actualrate
		,Transfer3rd
		,DrawGame
		,Turnover_BA
		,Comm_BA
		,AmountDueTo_BA
		,playercomm
		,Transfer3rdOthers
		,Promotion
		,RawDrawGame
		,RawTurnover
	)
	SELECT
		a.winlostdate
		,a.recommend --custid
		,a.currency
		,a.recommend
		,a.srecommend	
		,SUM(ISNULL(a.OpeningBalance,0))
		,SUM(ISNULL(a.Deposit,0))
		,SUM(ISNULL(a.Withdrawal,0))
		,SUM(ISNULL(a.Aff2MemTransfer,0))
		,SUM(ISNULL(a.Bonus,0))
		,SUM(ISNULL(a.Adjustment,0))
		,SUM(ISNULL(a.Turnover,0))
		,SUM(ISNULL(a.Outstanding,0))
		,SUM(ISNULL(a.Winloss,0))
		,SUM(ISNULL(a.ClosingBalance,0))
		,SUM(ISNULL(a.actualrate,0))
		,SUM(ISNULL(a.Transfer3rd,0))
		,SUM(ISNULL(a.DrawGame,0))
		,SUM(ISNULL(a.Turnover_BA,0))
		,SUM(ISNULL(a.Comm_BA,0))
		,SUM(ISNULL(a.AmountDueTo_BA,0))
		,SUM(ISNULL(a.playercomm,0))
		,SUM(ISNULL(a.Transfer3rdOthers,0))
		,SUM(ISNULL(a.Promotion,0))
		,SUM(ISNULL(a.RawDrawGame,0))
		,SUM(ISNULL(a.RawTurnover,0))
	FROM dbo.rptDepWinlost_bk a WITH(NOLOCK)
		LEFT JOIN rptDepwinlost_SUM b ON b.custid = a.recommend AND a.winlostdate = b.winlostdate 
	WHERE a.winlostdate BETWEEN @fdate AND @tdate
		AND a.recommend IN (SELECT recommend FROM #tmp2)
		AND b.custid IS NULL
	GROUP BY a.winlostdate, a.recommend, a.currency, a.srecommend
	ORDER BY a.winlostdate

SELECT @rowCount = @@RowCount
SET @Msg = 'Done Insert data from  (2022-03-30 -> 2022-04-01) - Affected row: ' + CAST(@rowCount AS VARCHAR(50))
RAISERROR (@Msg , 0, 1) WITH NOWAIT


DECLARE @Recommend INT, @Winlostdate SMALLDATETIME,  @diffamt MONEY
SET @cdate = '2022-03-30'

SET @Msg = 'Start update data before 2022-03-30' 
RAISERROR (@Msg , 0, 1) WITH NOWAIT

WHILE EXISTS (SELECT 1 FROM #tmp2 WHERE Isfinished = 0 )
BEGIN
  
	SELECT TOP 1 @Recommend= Recommend, @Winlostdate = DiffDate, @diffamt = diffamt FROM #tmp2 WHERE Isfinished = 0

	UPDATE b
	SET  b.ClosingBalance = b.ClosingBalance + @diffamt
		,b.OpeningBalance = b.OpeningBalance + @DiffAmt
	FROM rptdepwinlost_SUM b WITH(ROWLOCK)
	WHERE b.recommend = @Recommend AND b.winlostdate >= @Winlostdate AND b.winlostdate < @cdate
    
	--SELECT b.ClosingBalance + @diffamt ClosingBalance,b.OpeningBalance + @DiffAmt OpeningBalance
	--FROM rptdepwinlost_SUM b WITH(ROWLOCK)
	--WHERE b.recommend = @Recommend AND b.winlostdate >= @Winlostdate AND b.winlostdate < @cdate
    
    SELECT @rowCount = @@RowCount

	UPDATE #tmp2 set Isfinished = 1 where @Recommend= Recommend AND @Winlostdate = DiffDate
    SET @Msg = 'DONE - Recommend: ' +  CAST(@Recommend AS VARCHAR(50)) + ' - Affected row: ' + CAST(@rowCount AS VARCHAR(50))

	WAITFOR DELAY '00:00:00.280'
    RAISERROR (@Msg , 0, 1) WITH NOWAIT
END

SET @Msg = 'Done update data before 2022-03-30' 
RAISERROR (@Msg , 0, 1) WITH NOWAIT

GO
--DROP TABLE IF EXISTS #tmp1
--DROP TABLE IF EXISTS #tmp2
