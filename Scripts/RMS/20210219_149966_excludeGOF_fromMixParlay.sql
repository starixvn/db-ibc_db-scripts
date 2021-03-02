/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/

/*
	Created: 20210219@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Exclude GOF from mix parlay
*/

USE bodb_RMS ;  

SET NOCOUNT ON

	DECLARE @fdate smalldatetime = '2021-01-26'
	DECLARE @tdate smalldatetime

	CREATE TABLE #rmSumWinloss_Old(
				[winlostdate] [smalldatetime] NOT NULL,
				[custid] [int] NOT NULL,
				[sporttype] [smallint] NULL,
				[statusid] [tinyint] NOT NULL,
				[combo] [tinyint] NOT NULL,
				[username] [varchar](30) NOT NULL,
				[currency] [tinyint] NULL,
				[stake] [money] NULL,
				[winlost] [money] NULL,
				[company_stake] [money] NULL,
				[company_winlost] [money] NULL,
				[actualrate] [float] NULL,
				[odds] [smallmoney] NULL,
				[betcount] [int] NULL,
				[recommend] [int] NULL,
				[parlaytype] [tinyint] NULL,
				[scomm] [money] NULL,
				[Extra_comm] [money] NULL,
				[Extra_stake] [money] NULL,
				[Extra_winlost] [money] NULL,
				[mrecommend] [int] NULL,
				[srecommend] [int] NULL,
				[awinlost] [money] NULL,
				[mwinlost] [money] NULL,
				[swinlost] [money] NULL,
				[actual_stake] [money] NULL,
				[playercomm] [money] NULL,
				[comm] [money] NULL,
				[acomm] [money] NULL
			)


	SELECT @tdate = MAX(winlostdate) FROM rmSumWinloss_Old WITH(NOLOCK)

	DECLARE @__fdate smalldatetime
	DECLARE @__tdate smalldatetime


	select @__fdate = @fdate, @__tdate = @tdate

	WHILE  @__fdate <= @__tdate
	BEGIN
		--EXEC dbo.Task_RMS_MBU_CheckSumData_rmSumWinloss @__fdate
		DELETE  dbo.rmSumWinloss_Old WITH(ROWLOCK) WHERE winlostdate = @__fdate

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
		WHERE b.winlostdate = @__fdate
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

		SELECT @__fdate = DATEADD(DAY,1, @__fdate)
	END

	DROP TABLE #rmSumWinloss_Old



	SELECT   @fdate = MIN(winlostdate), @tdate = MAX(winlostdate) FROM rmSumWinloss WITH(NOLOCK)

	select @__fdate = @fdate, @__tdate = @tdate

	WHILE  @__fdate <= @__tdate
	BEGIN
		EXEC dbo.Task_RMS_MBU_CheckSumData_rmSumWinloss @__fdate
		SELECT @__fdate = DATEADD(DAY,1, @__fdate)
	END


GO  



