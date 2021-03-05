/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/

/*
	Created: 20210219@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Incoporate betBuilder basketball

*/

USE bodb_RMS ;  

SET NOCOUNT ON



-- Update data range bettrans_bk
BEGIN


	CREATE TABLE #match_bk (matchid INT, sporttype SMALLINT)

	INSERT INTO #match_bk (matchid, sporttype)
	select matchid, sporttype
	from DBARC.bodb_Archive.dbo.macth_bk bk WITH(NOLOCK)
	where eventdate = '2021-02-25' and sporttype in (1,2)

	UPDATE t WITH(ROWLOCK)
	SET t.transid2 = bk.sporttype
	FROM rmBettrans_Old t 
	INNER JOIN 	#match_bk bk ON bk.matchid = t.matchid 
	WHERE t.winlostdate = '2021-02-25' and t.bettype = 38

	DROP TABLE #match_bk

	DELETE  dbo.rmSumWinloss_Old WITH(ROWLOCK) WHERE winlostdate = '2021-02-25'
	INSERT INTO rmSumWinloss_Old
		(
			winlostdate,custid,sporttype,statusID,combo,username,currency,stake,winlost
			,company_stake,company_winlost,actualrate,odds,betcount,recommend,parlaytype
			,scomm,Extra_comm,Extra_stake,Extra_winlost,
			mrecommend,srecommend,awinlost,mwinlost,swinlost,actual_stake,playercomm,comm,acomm
		)
		SELECT
			b.winlostdate
			,b.custid
			,b.transid2 AS sporttype
			,b.statusID
			,CASE WHEN b.bettype = 29 AND b.betcheck IS NULL THEN LEN(b.betteam) ELSE b.hdp2 END AS combo
			,b.username
			,b.currency
			,SUM(b.stake) AS stake
			,SUM(b.winlost) AS winlost
			,SUM(b.stake * (1 - b.tpositiontaking)) AS company_stake
			,SUM(-(b.winlost - b.stake) * (1 - b.tpositiontaking)) AS company_winlost
			,b.actualrate
			,SUM(b.modds) AS odds
			,COUNT(1) AS betcount
			,b.recommend
			,CASE
				WHEN b.bettype = 29 AND b.betteam = N'1' AND b.oddsspread = 1 THEN 6 --GOF
				WHEN b.bettype = 29 AND b.betteam = N'1' THEN 2
				WHEN b.bettype = 29 AND b.betteam <> N'1' THEN 3
				WHEN b.bettype = 38 THEN 4
				WHEN b.bettype = 376 THEN 5
				ELSE 0 END AS ParlayType
			,SUM(b.scomm) AS scomm
			,SUM(b.scomm * CONVERT(DECIMAL(9,8), b.epositiontaking) / (1 - b.tpositiontaking)) AS Extra_comm
			,SUM(b.stake * CONVERT(DECIMAL(9,8), b.epositiontaking)) AS Extra_stake
			,SUM(-(b.winlost - b.stake) * CONVERT(DECIMAL(9,8), b.epositiontaking)) AS Extra_winlost,
			b.mrecommend,
			b.srecommend,
			SUM(awinlost) as awinlost,
			SUM(mwinlost) as mwinlost,
			SUM(swinlost) as swinlost,
			SUM(actual_stake) as actual_stake,
			SUM(playercomm) as playercomm,
			SUM(comm) as comm,
			SUM(acomm) as acomm
		FROM dbo.rmBettrans_old b WITH (NOLOCK)
		WHERE b.winlostdate = '2021-02-25'
			AND b.statusID IN (111, 112, 113)
		GROUP BY
			b.winlostdate
			,b.custid
			,b.transid2
			,b.statusID
			,CASE WHEN b.bettype = 29 AND b.betcheck IS NULL THEN LEN(b.betteam) ELSE b.hdp2 END
			,b.username
			,b.currency
			,b.actualrate
			,b.recommend
			,CASE
				WHEN b.bettype = 29 AND b.betteam = N'1' AND b.oddsspread = 1 THEN 6 --GOF
				WHEN b.bettype = 29 AND b.betteam = N'1' THEN 2
				WHEN b.bettype = 29 AND b.betteam <> N'1' THEN 3
				WHEN b.bettype = 38 THEN 4
				WHEN b.bettype = 376 THEN 5
				ELSE 0 END,
			b.mrecommend,
			b.srecommend;

END

-- Update data range bettrans14 
DECLARE @fdate smalldatetime = '2021-02-26'
DECLARE @tdate smalldatetime = '2021-02-28'
--SELECT @tdate = MAX(winlostdate) FROM rmSumWinloss WITH(NOLOCK)
DECLARE @__fdate smalldatetime
DECLARE @__tdate smalldatetime

select @__fdate = @fdate, @__tdate = @tdate

WHILE  @__fdate <= @__tdate
BEGIN
	
	UPDATE b WITH (ROWLOCK)
	SET b.transid2 = m.sporttype
	FROM dbo.rmBettrans_Old b
	INNER JOIN bodb02.dbo.match14 m WITH (NOLOCK) ON b.matchid = m.matchid
	WHERE b.winlostdate = @__fdate  AND b.bettype =38

	EXEC dbo.Task_RMS_MBU_CheckSumData_rmSumWinloss @__fdate
	SELECT @__fdate = DATEADD(DAY,1, @__fdate)
	WAITFOR DELAY '00:00:00.280'
END
