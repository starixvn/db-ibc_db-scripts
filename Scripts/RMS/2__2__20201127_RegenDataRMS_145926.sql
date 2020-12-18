/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
/*
	Created: 20201102@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - PRMS - Generate data rmBettrans_UAT 
	-- Regen data rmBettrans_UAT Winlostdate >
*/
BEGIN
	CREATE TABLE #rmBettrans_Old
	(
			transid				bigint primary key
			,custid				int
			,transdate			datetime
			,oddsid				int
			,hdp1				smallmoney
			,hdp2				smallmoney
			,odds				smallmoney
			,stake				money
			,status				nvarchar(10)
			,winlost			money
			,awinlost			money
			,mwinlost			money
			,playercomm			money
			,comm				money
			,acomm				money
			,apositiontaking	smallmoney
			,mpositiontaking	smallmoney
			,tpositiontaking	smallmoney
			,playerdiscount		decimal(9,8)
			,discount			decimal(9,8)
			,adiscount			decimal(9,8)
			,livehomescore		smallint
			,liveawayscore		smallint
			,liveindicator		bit
			,betteam			nvarchar(10)
			,creator			int
			,refno				bigint
			,comstatus			nvarchar(20)
			,winlostdate		smalldatetime
			,betfrom			nvarchar(1)
			,betcheck			nvarchar(50)
			,checktime			datetime
			,oddsspread			smallmoney
			,actualrate			float
			,matchid			int
			,recommend			int
			,mrecommend			int
			,ruben				tinyint
			,betid				bigint
			,statuswinlost		tinyint
			,modds				smallmoney
			,bettype			smallint
			,betdaqid			bigint
			,actual_stake		money
			,currency			tinyint
			,ip					nvarchar(15)
			,transdesc			nvarchar(1000)
			,sdiscount			decimal(9,8)
			,scomm				money
			,spositiontaking	smallmoney
			,swinlost			money
			,srecommend			int
			,Username			nvarchar(50)
			,CurrencyName		nvarchar(50)
			,virtualrate		float
			,oddstype			tinyint
			,statusID			tinyint
			,currency2			tinyint
			,balance			money
			,SecAcceptFlag		bit
			,transid2			bigint
			,combo				int
			,odds2				money
			,TotalBet			int
			,epositiontaking	smallmoney
	)

	CREATE TABLE #__tmpByBatch
	(
			transid				bigint
			,custid				int
			,transdate			datetime
			,oddsid				int
			,hdp1				smallmoney
			,hdp2				smallmoney
			,odds				smallmoney
			,stake				money
			,status				nvarchar(10)
			,winlost			money
			,awinlost			money
			,mwinlost			money
			,playercomm			money
			,comm				money
			,acomm				money
			,apositiontaking	smallmoney
			,mpositiontaking	smallmoney
			,tpositiontaking	smallmoney
			,playerdiscount		decimal(9,8)
			,discount			decimal(9,8)
			,adiscount			decimal(9,8)
			,livehomescore		smallint
			,liveawayscore		smallint
			,liveindicator		bit
			,betteam			nvarchar(10)
			,creator			int
			,refno				bigint
			,comstatus			nvarchar(20)
			,winlostdate		smalldatetime
			,betfrom			nvarchar(1)
			,betcheck			nvarchar(50)
			,checktime			datetime
			,oddsspread			smallmoney
			,actualrate			float
			,matchid			int
			,recommend			int
			,mrecommend			int
			,ruben				tinyint
			,betid				bigint
			,statuswinlost		tinyint
			,modds				smallmoney
			,bettype			smallint
			,betdaqid			bigint
			,actual_stake		money
			,currency			tinyint
			,ip					nvarchar(15)
			,transdesc			nvarchar(1000)
			,sdiscount			decimal(9,8)
			,scomm				money
			,spositiontaking	smallmoney
			,swinlost			money
			,srecommend			int
			,Username			nvarchar(50)
			,CurrencyName		nvarchar(50)
			,virtualrate		float
			,oddstype			tinyint
			,statusID			tinyint
			,currency2			tinyint
			,balance			money
			,SecAcceptFlag		bit
			,transid2			bigint
			,combo				int
			,odds2				money
			,TotalBet			int
			,epositiontaking	smallmoney
	)

	CREATE INDEX IX_bettype ON #__tmpByBatch (bettype, refno) INCLUDE (transid, stake, betteam, hdp2)

	DECLARE @fromdate SMALLDATETIME, 
			@todate SMALLDATETIME, 
			@isBreak BIT = 0
	DECLARE @ErrMsg VARCHAR(2000) = ''


	SET  @fromdate ='2020-15-11'
	select @todate = MAX(winlostdate)  FROM DBARC.bodb_archive.dbo.bettrans_bk b WITH (NOLOCK)

	WHILE 1 = 1
	BEGIN
		SET @ErrMsg = 'Current date = ' + CONVERT(VARCHAR(10), @fromdate, 120)
		RAISERROR (@ErrMsg, 1, 0) WITH NOWAIT


		IF @fromdate >= @todate -- Current BU Date
		BEGIN
			SET @isBreak = 1
		END

		TRUNCATE TABLE #rmBettrans_Old
	
		INSERT INTO #rmBettrans_Old
		(
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
			,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore
			,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid
			,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc
			,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,currency2
			,balance,SecAcceptFlag,epositiontaking,transid2,combo,odds2,TotalBet
		)
		SELECT
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
			,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,CASE WHEN bettype IN (38, 376) THEN 1 ELSE liveawayscore END
			,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid
			,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc
			,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,currency2
			,balance,SecAcceptFlag,epositiontaking,CASE WHEN bettype IN (38, 376) THEN 1 ELSE 0 END,hdp2,odds,1
		FROM DBARC.bodb_archive.dbo.bettrans_bk b WITH (NOLOCK)
		CROSS APPLY (
			SELECT TOP 1 c.username, e.currency AS CurrencyName
			FROM bodb02.dbo.Customer c WITH (NOLOCK)
				INNER JOIN bodb02.dbo.exchange e WITH (NOLOCK) ON c.currency = e.exchangeid
			WHERE b.custid = c.custid
		) c
		WHERE b.winlostdate = @fromdate 
			AND bettype IN (29, 38, 376)

		WHILE 1=1
		BEGIN
			TRUNCATE TABLE #__tmpByBatch

			DELETE TOP (5000) FROM #rmBettrans_Old
			OUTPUT DELETED.*
			INTO #__tmpByBatch

			-- transid2 (sporttype)
			UPDATE b
			SET b.transid2 = s.sporttype
			FROM #__tmpByBatch b
				CROSS APPLY (
							SELECT CASE
										-------------------------------
										WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) NOT IN (1,2) THEN MIN(sporttype)
										------------------------------- 
										WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 1 AND SUM(DISTINCT Saba) = 0 THEN -3 
										WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 1 AND SUM(DISTINCT Saba) > 0 THEN -4
										WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 1 AND SUM(DISTINCT Saba) < 0 THEN  1
										------------------------------
										WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 2 AND SUM(DISTINCT Saba) = 0 THEN -1
										WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 2 AND SUM(DISTINCT Saba) > 0 THEN -5
										WHEN COUNT(DISTINCT sporttype) = 1 AND MIN(sporttype) = 2 AND SUM(DISTINCT Saba) < 0 THEN  2

										------------------------------
										WHEN COUNT(DISTINCT sporttype) <> 1 AND MIN(sporttype) = 1 THEN -3
										ELSE -1 END AS sporttype 
							FROM
							(
								SELECT m.sporttype, CASE WHEN  l.LeagueGroupID IN (42, 74) THEN 1 ELSE -1 END Saba
								FROM DBARC.bodb_archive.dbo.bettransm bm WITH (NOLOCK) 
									INNER JOIN DBARC.bodb_archive.dbo.match_bk m WITH (NOLOCK) ON bm.matchid = m.matchid
									INNER JOIN bodb02.dbo.League l WITH(NOLOCK) ON m.leagueid = l.leagueid
								WHERE bm.refno = b.refno and b.bettype = 29

								UNION ALL
								SELECT m.sporttype, CASE WHEN  l.LeagueGroupID IN (42, 74) THEN 1 ELSE -1 END Saba
								FROM bodb02.dbo.bettransm14 bm WITH (NOLOCK)
									INNER JOIN bodb02.dbo.match14 m WITH (NOLOCK) ON bm.matchid = m.matchid
									INNER JOIN bodb02.dbo.League l WITH(NOLOCK) ON m.leagueid = l.leagueid
								WHERE bm.refno = b.refno  and b.bettype = 29
							) s
				) s
			WHERE b.bettype = 29
				AND b.transid2 = 0

			-- TotalBet
			UPDATE b
			SET b.TotalBet = t.TotalBet
			FROM #__tmpByBatch b
				CROSS APPLY (
					SELECT SUM(rcs.cnt) AS TotalBet
					FROM bodb02.dbo.RefCombinationSet rcs WITH (NOLOCK)
					WHERE rcs.N = b.hdp2
						AND (b.betteam & rcs.bitmapR) > 0
				) t
			WHERE b.bettype = 29

			-- odds2
			CREATE TABLE #tmp (transid BIGINT, stake MONEY, N TINYINT, bitmapR INT, odds SMALLMONEY, SetStake MONEY, RN TINYINT)
			CREATE CLUSTERED INDEX CIX_transid ON #tmp (transid)

			INSERT INTO #tmp (transid, stake, N, bitmapR, odds, SetStake, RN)
			SELECT b.transid, b.stake, b.hdp2, b.betteam, bm.odds, bm.stake AS SetStake
				,ROW_NUMBER() OVER(PARTITION BY b.transid ORDER BY bm.matchid) AS RN
			FROM #__tmpByBatch b
				CROSS APPLY (
					SELECT bm.odds, bm.stake, bm.matchid
					FROM bodb02.dbo.bettransm14 bm WITH (NOLOCK)
					WHERE bm.refno = b.refno
					
					UNION ALL
					SELECT bm.odds, bm.stake, bm.matchid
					FROM DBARC.bodb_archive.dbo.bettransm bm WITH (NOLOCK)
					WHERE bm.refno = b.refno
				) bm
			WHERE b.bettype = 29

			;WITH CTE_ParlayStake AS
			(
				SELECT transid, RN, SetStake FROM #tmp
			)
			,CTE_odds AS
			(
				SELECT transid, CASE WHEN stake = 0 THEN 0 ELSE SUM(odds * SetStake) / stake END AS odds2
				FROM (
					SELECT t.transid, t.stake, ps.SetStake, EXP(SUM(LOG(t.odds))) AS odds
					FROM #tmp t
						INNER JOIN bodb02.dbo.RefCombinationSet rcs WITH (NOLOCK) ON t.N = rcs.N AND (t.bitmapR & rcs.bitmapR) > 0
						INNER JOIN bodb02.dbo.RefCombination rc WITH (NOLOCK) ON rcs.N = rc.N AND rcs.R = rc.R AND t.RN = rc.Seq
						INNER JOIN CTE_ParlayStake ps ON t.transid = ps.transid AND rc.R = ps.RN
					GROUP BY t.transid, t.stake, ps.SetStake, rc.Serial
				) r
				GROUP BY transid, stake
			)
			UPDATE b
			SET b.odds2 = o.odds2
			FROM #__tmpByBatch b
				INNER JOIN CTE_odds o ON b.transid = o.transid
			WHERE b.bettype = 29

			DROP TABLE #tmp

			INSERT INTO dbo.rmBettrans_Old_UAT
			(
				transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
				,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore
				,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid
				,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc
				,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,currency2
				,balance,SecAcceptFlag,epositiontaking,transid2,combo,odds2,TotalBet
			)
			SELECT
				transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm
				,apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore
				,liveindicator,betteam,creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid
				,recommend,mrecommend,ruben,betid,statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc
				,sdiscount,scomm,spositiontaking,swinlost,srecommend,Username,CurrencyName,virtualrate,oddstype,statusID,currency2
				,balance,SecAcceptFlag,epositiontaking,transid2,combo,odds2,TotalBet
			FROM #__tmpByBatch

			IF @@ROWCOUNT < 5000
				BREAK
		END

		SELECT @fromdate = DATEADD(DAY, 1, @fromdate)

		IF @isBreak = 1
			BREAK
	END

	DROP TABLE #rmBettrans_Old
	DROP TABLE #__tmpByBatch
END
