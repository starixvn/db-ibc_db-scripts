/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/

/*
	Created: 20220519@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Exclude GOF from mix parlay
*/

--
ALTER TABLE [dbo].[rmSumWinloss] ADD  liveindicator SMALLINT
ALTER TABLE [dbo].[rmSumWinloss_Old] ADD liveindicator SMALLINT


-- Regen data
BEGIN
	DECLARE @MBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
	INSERT INTO @MBU (BalanceUpDay, MoveBetsDay)
	EXEC bodb02.dbo.Age_SelBalanceUpDay

	DECLARE @BalanceUpDay SMALLDATETIME, @MoveBetsDay SMALLDATETIME
	SELECT  @BalanceUpDay = BalanceUpDay, @MoveBetsDay = MoveBetsDay FROM @MBU
	

	-- Regen data rmSumWinloss
	DECLARE @FromDate SMALLDATETIME,
			@ToDate	  SMALLDATETIME
	SELECT @ToDate = @MoveBetsDay, @FromDate = @BalanceUpDay

	WHILE @FromDate <= @ToDate
	BEGIN
		SELECT('Running_' + CAST(@FromDate AS VARCHAR(20)))
		DELETE dbo.rmSumWinloss WITH(ROWLOCK, UPDLOCK) WHERE winlostdate = @FromDate

		INSERT INTO dbo.rmSumWinloss
		(
			winlostdate,custid,sporttype,statusID,combo,username,currency,stake,winlost
			,company_stake,company_winlost,actualrate,odds,betcount,recommend,parlaytype
			,scomm,Extra_comm,Extra_stake,Extra_winlost,
			mrecommend,srecommend,awinlost,mwinlost,swinlost,actual_stake,playercomm,comm,acomm,liveindicator
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
			SUM(acomm) as acomm,
			CASE WHEN b.bettype = 29 THEN b.livehomescore ELSE b.liveindicator END liveindicator
		FROM dbo.rmBettrans_old b WITH (NOLOCK)
		WHERE b.winlostdate = @FromDate
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
			b.srecommend,
			CASE WHEN b.bettype = 29 THEN b.livehomescore ELSE b.liveindicator END;

		SELECT @FromDate = DATEADD(DAY,1,@FromDate)
	END



	-- Regen rmSumWinloss_Old
	DECLARE @FromDate_Old SMALLDATETIME,
			@ToDate_Old	  SMALLDATETIME

	SELECT @FromDate_Old = MIN(winlostdate) FROM rmBettrans_Old WITH(NOLOCK)
	SELECT @ToDate_Old = DATEADD(DAY, -1, @BalanceUpDay)

	WHILE @FromDate_Old <= @ToDate_Old
	BEGIN
		SELECT('Running_' + CAST(@FromDate_Old AS VARCHAR(20)))
		DELETE dbo.rmSumWinloss_Old WITH(ROWLOCK, UPDLOCK) WHERE winlostdate = @FromDate_Old

		INSERT INTO dbo.rmSumWinloss_Old
		(
			winlostdate,custid,sporttype,statusID,combo,username,currency,stake,winlost
			,company_stake,company_winlost,actualrate,odds,betcount,recommend,parlaytype
			,scomm,Extra_comm,Extra_stake,Extra_winlost,
			mrecommend,srecommend,awinlost,mwinlost,swinlost,actual_stake,playercomm,comm,acomm,liveindicator
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
			SUM(acomm) as acomm,
			CASE WHEN b.bettype = 29 THEN b.livehomescore ELSE b.liveindicator END liveindicator
		FROM dbo.rmBettrans_old b WITH (NOLOCK)
		WHERE b.winlostdate = @FromDate_Old
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
			b.srecommend,
			CASE WHEN b.bettype = 29 THEN b.livehomescore ELSE b.liveindicator END;

		SELECT @FromDate_Old = DATEADD(DAY,1,@FromDate_Old)
	END
END