/*<info serverAlias="DBxxx-bodb02" executers="" viewers="" isFunction="0"></info>*/
/*
	Task: 
	Created by: 20210607@Louisa

	Step 1: Delete dbo.BetParlayDetail + dbo.BetParlayResult belong @matchid
	Step 2: Coppy data from DBTXN.bodb02.dbo.bettrans to correct bettrans
	Step 3: Generate data again for dbo.BetParlayDetail + dbo.BetParlayResult

*/

USE bodb02
GO


/*--------------------------------------------------------------------------
	STEP 1: Delete dbo.BetParlayDetail + dbo.BetParlayResult
*/--------------------------------------------------------------------------

	DECLARE @MatchId INT ---Please Input MatchId

	IF OBJECT_ID('tempdb..#Refno_list') IS NOT NULL
		DROP TABLE #Refno_list

	SELECT bm.refno
	INTO #Refno_list
	FROM dbo.bettransm bm WITH(ROWLOCK)
	WHERE bm.matchid = @matchid
		AND NOT EXISTS (SELECT 1 FROM bettransm WITH(NOLOCK) WHERE refno = bm.refno AND statusID IN(1,101))

	DELETE pd
	FROM BetParlayDetail pd
	WHERE EXISTS (SELECT 1 FROM #Refno_list R1 WITH (NOLOCK) WHERE pd.Refno = R1.Refno)

	DELETE pdr
	FROM BetParlayResult pdr
	WHERE EXISTS (SELECT 1 FROM #Refno_list R1 WITH (NOLOCK) WHERE pdr.Refno = R1.Refno)

GO

/*--------------------------------------------------------------------------
	STEP 2: Copy data FROM DBTXN to correct bettrans
*/--------------------------------------------------------------------------

	IF OBJECT_ID('tempdb..#temp_bettrans_29') IS NOT NULL
	DROP TABLE #temp_bettrans_29

	IF OBJECT_ID('tempdb..#bettrans_DBTXN') IS NOT NULL
		DROP TABLE #bettrans_DBTXN

	SELECT transid
	INTO #temp_bettrans_29
	FROM bettrans b WITH(NOLOCK)
	WHERE b.matchid = 29
		AND b.statusID NOT IN (101,102) 
		AND refno IN (SELECT refno FROM #Refno_list)

	SELECT b.transid			 
		   , b.SettlementTime
		   , b.StatusID
		   , b.[status] 		 
		   , b.winlostdate	 
		   , b.actual_stake	 
		   , b.betdaqid 		 
		   , b.ruben			 
		   , b.WinLost		 
		   , b.aWinLost		 
		   , b.mWinLost		 
		   , b.sWinLost		 
		   , b.PlayerComm	 
		   , b.Comm			 
		   , b.aComm			 
		   , b.sComm
	INTO #bettrans_DBTXN
	FROM DBTXN.bodb02.dbo.bettrans b WITH (NOLOCK)
	INNER JOIN #temp_bettrans_29 s ON b.transid = s.transid

	UPDATE b
	SET SettlementTime =  CASE 
							WHEN s.statusID <> 0 AND (b.winlost <> s.winlost OR b.statusID <> s.statusID) THEN s.SettlementTime 
							ELSE b.SettlementTime 
							END
	,statusID		= s.statusID
	,[status]		= s.[status]
	,winlostdate	= s.winlostdate 
	,actual_stake	= s.actual_stake
	,betdaqid		= s.betdaqid							
	,ruben			= s.ruben
	,winlost		= s.winlost
	,awinlost		= s.awinlost
	,mwinlost		= s.mwinlost
	,swinlost		= s.swinlost
	,playercomm		= s.playercomm
	,comm			= s.comm
	,acomm			= s.acomm
	,scomm			= s.scomm
	FROM bettrans b WITH (ROWLOCK)	
		INNER JOIN #bettrans_DBTXN s
			ON b.transid = s.transid

GO

/*--------------------------------------------------------------------------
	STEP 3: Generate data for dbo.BetParlayDetail + dbo.BetParlayResult
*/--------------------------------------------------------------------------
	DECLARE @MatchId INT --Plase input matchid
			, @matchdate SMALLDATETIME

	SELECT @matchdate = m.eventdate FROM dbo.match m WITH(NOLOCK) WHERE m.matchid = @MatchId

	IF OBJECT_ID('tempdb..#temp_bettrans') IS NOT NULL
		DROP TABLE #temp_bettrans


	CREATE TABLE #temp_bettrans  (
			transid				BIGINT NOT NULL
			,refno				BIGINT
			,stake				MONEY NOT NULL
			,bitmapR			INT NOT NULL -- bitmap to identify which parlay set is choosen
			,winlostdate		SMALLDATETIME NOT NULL
			,apositiontaking	SMALLMONEY
			,mpositiontaking	SMALLMONEY
			,spositiontaking	SMALLMONEY
			,playerdiscount		DECIMAL(9, 8)
			,discount			DECIMAL(9, 8)
			,adiscount			DECIMAL(9, 8)
			,sdiscount			DECIMAL(9, 8)
			,comstatus			NVARCHAR(20)
			,inserted			BIT -- row has been inserted into betParlayResult/betParlayDetail
			,eventdate			SMALLDATETIME 
			,selection_cnt		TINYINT NOT NULL ---- number of selections (bettransM count)
			,oddsspread			MONEY
			,actual_stake		MONEY
		)
	
	SELECT	bt.transid, bt.refno, bt.stake
			,CASE 
				WHEN bt.betcheck IS NOT NULL THEN CAST(bt.hdp2 AS TINYINT) -- Combo Parlay - New format	
				ELSE CAST(LEN(bt.betteam) AS TINYINT)  -- Old format
				END AS selection_cnt
			,CASE 
				WHEN bt.betcheck IS NOT NULL THEN CAST(bt.betteam AS INT) -- Combo Parlay	- New format	
				ELSE CAST(bt.hdp2/2 AS INT)  -- Old format
				END AS bitmapR
			,bt.winlostdate, bt.apositiontaking, bt.mpositiontaking, bt.spositiontaking
			, bt.playerdiscount, bt.discount, bt.adiscount, bt.sdiscount, bt.comstatus, 0 AS inserted
			,ISNULL(bt.oddsspread, 0) AS oddsspread
			,bt.actual_stake
		FROM	dbo.bettrans bt WITH(NOLOCK)
			INNER JOIN	#temp_bettrans_29 tmp ON bt.transid = tmp.transid

		;WITH cteDuplicateTransId
		AS(
			SELECT	transid
					,refno
					,stake
					,bitmapR
					,winlostdate
					,selection_cnt
					,ROW_NUMBER() OVER(PARTITION BY transid ORDER BY transid) as rn
			FROM	#temp_bettrans
		)
		DELETE 
		FROM	cteDuplicateTransId
		WHERE	rn > 1

		CREATE UNIQUE CLUSTERED INDEX CIX_tempBettrans_refno ON #temp_bettrans (refno)

		UPDATE t
			SET inserted = 1
		FROM #temp_bettrans t
		WHERE EXISTS (SELECT TOP 1 1 FROM dbo.BetParlayResult r WITH (NOLOCK) WHERE t.refno = r.refno)

		;WITH _source AS (
			SELECT bm.refno, bm.transid, bm.winlostdate, bm.statuswinlost, bm.statusid, bm.matchid
				,bm.bettype, bm.odds, bm.betteam, bm.hdp1, bm.hdp2, bm.livehomescore
				,bm.liveawayscore, bm.liveindicator, bm.betcheck, b.selection_cnt, b.bitmapR, bm.stake as SetStake, bm.transdesc
				,RN = ROW_NUMBER() OVER (PARTITION BY bm.refno ORDER BY bm.mainmatch) --RN			
			FROM #temp_bettrans b
				CROSS APPLY
					(
						SELECT	bm.refno, bm.transid, bm.winlostdate, bm.statuswinlost, bm.statusID, bm.matchid
							,bm.bettype, bm.odds, bm.betteam, bm.hdp1, bm.hdp2, bm.livehomescore
							,bm.liveawayscore, bm.liveindicator, bm.betcheck, bm.stake, bm.transdesc
							,CASE WHEN ISNULL(m.ChildMatchType,0) = 200 AND m.ParentID IS NOT NULL AND m.sporttype = 50 THEN m.ParentID ELSE bm.matchid END AS mainmatch
						FROM	dbo.bettransm bm WITH(ROWLOCK)	
							INNER JOIN dbo.match m WITH (NOLOCK)
								ON	bm.matchid = m.matchid
						WHERE	bm.refno = b.refno
								AND m.sporttype BETWEEN 1 AND 99
									
						UNION
						SELECT	bm14.refno, bm14.transid, bm14.winlostdate, bm14.statuswinlost, bm14.statusID, bm14.matchid
							,bm14.bettype, bm14.odds, bm14.betteam, bm14.hdp1, bm14.hdp2, bm14.livehomescore
							,bm14.liveawayscore, bm14.liveindicator, bm14.betcheck, bm14.stake, bm14.transdesc
							,CASE WHEN ISNULL(m14.ChildMatchType,0) = 200 AND m14.ParentID IS NOT NULL AND m14.sporttype = 50 THEN m14.ParentID ELSE bm14.matchid END AS mainmatch
						FROM	dbo.bettransm14 bm14 WITH(ROWLOCK)			
							INNER JOIN dbo.match14 m14 WITH(NOLOCK)
								ON bm14.matchid = m14.matchid
						WHERE	bm14.refno = b.refno
								AND m14.sporttype BETWEEN 1 AND 99
								
						UNION
						SELECT	bmbk.refno, bmbk.transid, bmbk.winlostdate, bmbk.statuswinlost, bmbk.statusID, bmbk.matchid
							,bmbk.bettype, bmbk.odds, bmbk.betteam, bmbk.hdp1, bmbk.hdp2, bmbk.livehomescore
							,bmbk.liveawayscore, bmbk.liveindicator, bmbk.betcheck, bmbk.stake, bmbk.transdesc
							,CASE WHEN ISNULL(mbk.ChildMatchType,0) = 200 AND mbk.ParentID IS NOT NULL AND mbk.sporttype = 50 THEN mbk.ParentID ELSE bmbk.matchid END AS mainmatch
						FROM	DBARC.bodb_Archive.dbo.Bettransm bmbk WITH(ROWLOCK)			
							INNER JOIN DBARC.bodb_Archive.dbo.match_BK mbk WITH(NOLOCK)
								ON bmbk.matchid = mbk.matchid
						WHERE	bmbk.refno = b.refno
								AND mbk.sporttype BETWEEN 1 AND 99										
					) bm
			WHERE	b.inserted = 0 
			),
			ParlayStake AS (SELECT refno, RN, SetStake FROM _source)

			INSERT INTO dbo.BetParlayDetail (
			RefNo, Serial, transid, winlostdate, statuswinlost, statusid
			,matchid, bettype, stake, odds, betteam, hdp1
			,hdp2, livehomescore, liveawayscore, liveindicator, betcheck, transdesc
		)
		SELECT p.RefNo, rc.Serial, transid, winlostdate, statuswinlost, statusid
			,matchid, bettype, ps.SetStake, odds, betteam, hdp1
			,hdp2, livehomescore, liveawayscore, liveindicator, betcheck, transdesc
		FROM _source p
			INNER JOIN dbo.RefCombinationSet rcs WITH (NOLOCK) ON p.selection_cnt = rcs.N AND (p.bitmapR & rcs.bitmapR) > 0 -- Pick Set by BitmapR (get R)
			INNER JOIN dbo.RefCombination rc WITH (NOLOCK) ON rcs.N = rc.N AND rcs.R = rc.R AND p.RN = rc.seq -- Pick subticket details (R & seq)
			INNER JOIN ParlayStake ps ON ps.refno = p.refno AND ps.RN = rc.R

		INSERT INTO dbo.BetParlayResult (
			RefNo, Serial, transid, winlostdate, statusid, Stake
			,Odds, mOdds, winlost, awinlost, mwinlost, swinlost
			,playercomm, comm, acomm, scomm
		)
		SELECT DISTINCT b.RefNo, r.Serial, 0, b.winlostdate, 0, r.stake
			,0, 0, 0, 0, 0, 0
			,0, 0, 0, 0
		FROM #temp_bettrans b
			INNER JOIN dbo.BetParlayDetail r WITH (NOLOCK) ON b.refno = r.refno
		WHERE b.inserted = 0 -- only insert the row not yet insert to that table

		;WITH s AS (
		SELECT pd.refno, MAX(m.eventdate) AS EventDate
		FROM dbo.BetParlayDetail pd WITH (NOLOCK)			
			INNER JOIN #temp_bettrans t ON pd.refno = t.refno
			INNER JOIN dbo.match m WITH (NOLOCK)
				ON m.matchid = pd.matchid
		GROUP BY pd.refno
	)
	UPDATE #temp_bettrans
		SET eventdate = s.eventdate
	FROM s
	WHERE #temp_bettrans.refno = s.refno 

	DECLARE @statusID TINYINT, @modds MONEY
	DECLARE @commWinRate MONEY, @commLostRate MONEY
	
	;WITH p AS (
		SELECT pd.refno as refno
			,pd.serial
			,b.eventdate
			,SUM(CASE WHEN pd.statusID IN (121, 103) THEN 0 ELSE 1 END) as NoRefund
			,SUM(CASE WHEN pd.statuswinlost = 4	AND pd.statusID <> 102 THEN 1 ELSE 0 END) as loseCnt
			,SUM(CASE WHEN pd.statusID IN (0, 1) THEN 1 ELSE 0 END) as runningCnt
			,MAX(pd.winlostdate) as matchdate_max
			,CAST(dbo.PRODUCT(pd.odds) AS MONEY) AS odds
			,CAST(dbo.PRODUCT(
				CASE WHEN pd.statusid = 102 THEN 1
					ELSE
						CASE pd.statuswinlost
							WHEN 0 THEN 1 -- draw
							WHEN 1 THEN 1+((pd.odds-1)/2) -- half won
							WHEN 2 THEN pd.odds -- won
							WHEN 3 THEN 0.5 -- half lose
							WHEN 4 THEN 0.000000000001 -- lose
							ELSE 1 -- VOID/REJECT
						END
				END
				) AS MONEY) AS modds
		FROM dbo.BetParlayDetail pd WITH (NOLOCK)
			INNER JOIN #temp_bettrans b ON pd.refno = b.refno
		GROUP BY pd.refno, pd.serial, b.eventdate
	)

	UPDATE pr			
	SET @statusID = statusID = CASE
					WHEN p.loseCnt > 0    THEN 113 -- Lose
					WHEN p.runningCnt > 0 THEN 0   -- running
					WHEN p.NoRefund = 0   THEN 103 -- Refund
					WHEN p.modds < 1      THEN 113 -- Lose
					WHEN p.modds = 1      THEN 111 -- Draw
					ELSE 112 -- Won
				END
		,winlostdate = CASE
				WHEN @statusId = 0 THEN p.eventdate
				WHEN @statusID IN (103, 111, 112) THEN p.matchdate_max
				WHEN @statusID = 113              THEN @matchdate
				ELSE @matchdate
			END
		,odds = p.odds
		,@modds = pr.modds = CASE 
			WHEN p.loseCnt > 0 THEN 0
			WHEN @statusID = 0 THEN 0
			ELSE p.modds
			END
		,@commWinRate = CASE b.comstatus -- 0 : pay normal, both win/lost -- 1 : pay 'double' ONLY on lost
			WHEN '0' THEN 1
			WHEN '1' THEN 0
			ELSE 1
			END
		,@commLostRate = CASE b.comstatus
			WHEN '0' THEN 1
			WHEN '1' THEN 2
			ELSE 1
			END
		,winlost = CASE 
			WHEN loseCnt > 0   THEN 0
			WHEN @statusID = 0 THEN 0
			WHEN  b.oddsspread = 1	THEN	CASE 
											WHEN @modds > 1 THEN @modds * pr.stake + (b.actual_stake - pr.stake)
											WHEN @modds < 1 THEN @modds * b.actual_stake
											ELSE b.actual_stake
											END
			ELSE ISNULL(PR.stake * @modds,0)
			END
		,awinlost = CASE 
			WHEN @statusID = 113 AND loseCnt > 0 THEN	CASE 
														WHEN b.oddsspread  = 1 THEN b.actual_stake 
																				ELSE PR.stake
																				END	* apositiontaking

			WHEN @statusID = 112		         THEN - PR.stake * (@modds - 1) * apositiontaking

			WHEN  @statusID = 113				THEN	CASE
														WHEN  b.oddsspread  = 1 THEN - b.actual_stake *(@modds - 1)
																				ELSE - PR.stake * (@modds - 1)
																				END * apositiontaking
			ELSE 0
			END
		,mwinlost = CASE 
			WHEN @statusID = 113 AND loseCnt > 0 THEN	CASE 
														WHEN b.oddsspread  = 1 THEN b.actual_stake 
																				ELSE PR.stake
																				END	* mpositiontaking

			WHEN @statusID = 112		         THEN	- PR.stake * (@modds - 1) * mpositiontaking

			WHEN  @statusID = 113				THEN	CASE
														WHEN  b.oddsspread  = 1 THEN - b.actual_stake *(@modds - 1)
																				ELSE - PR.stake * (@modds - 1)
																				END * mpositiontaking
			ELSE 0
			END
		,swinlost = CASE 
			WHEN @statusID = 113 AND loseCnt > 0 THEN	CASE 
														WHEN b.oddsspread  = 1 THEN b.actual_stake 
																				ELSE PR.stake
																				END	* spositiontaking

			WHEN @statusID = 112		         THEN	- PR.stake * (@modds - 1) * spositiontaking

			WHEN  @statusID = 113				THEN	CASE
														WHEN  b.oddsspread  = 1 THEN - b.actual_stake *(@modds - 1)
																				ELSE - PR.stake * (@modds - 1)
																				END * spositiontaking
			ELSE 0
			END
		,playercomm = CASE @statusID
			WHEN 112 THEN @commWinRate  * PR.stake * playerdiscount
			WHEN 113 THEN @commLostRate * PR.stake * playerdiscount
			ELSE 0
			END
		,comm = CASE @statusID
			WHEN 112 THEN @commWinRate  * PR.stake * discount * (1 - apositiontaking)
			WHEN 113 THEN @commLostRate * PR.stake * discount * (1 - apositiontaking)
			ELSE 0
			END
		,acomm = CASE @statusID
			WHEN 112 THEN @commWinRate  * PR.stake * adiscount * (1 - apositiontaking - mpositiontaking)
			WHEN 113 THEN @commLostRate * PR.stake * adiscount * (1 - apositiontaking - mpositiontaking)
			ELSE 0
			END
		,scomm = CASE @statusID
			WHEN 112 THEN @commWinRate  * PR.stake * sdiscount * (1 - apositiontaking - mpositiontaking - spositiontaking)
			WHEN 113 THEN @commLostRate * PR.stake * sdiscount * (1 - apositiontaking - mpositiontaking - spositiontaking)
			ELSE 0
			END
	FROM dbo.BetParlayResult pr
		INNER JOIN #temp_bettrans b ON pr.refno = b.refno 
		INNER JOIN p ON pr.refno = p.refno AND pr.serial = p.serial
	WHERE
		pr.statusID <>
		CASE
			WHEN p.loseCnt > 0    THEN 113 -- Lose
			WHEN p.runningCnt > 0 THEN 0   -- running
			WHEN p.NoRefund = 0   THEN 103 -- Refund
			WHEN p.modds < 1      THEN 113 -- Lose
			WHEN p.modds = 1      THEN 111 -- Draw
			ELSE 112 -- Won
		END
		OR pr.winlost <>
		CASE 
			WHEN p.loseCnt > 0 OR p.runningCnt > 0 THEN 0 
			ELSE pr.stake * p.modds
		END
GO

/*--------------------------------------------------------------------------
	STEP 4: COUNT DATA ON DBxxx AND DBTXN TO COMPARE AGAIN
*/--------------------------------------------------------------------------

	/*	BETTRANS	*/
	SELECT  COUNT(b.transid) AS cnt, b.statusID
	-- count(1)
	FROM bettrans b  WITH(NOLOCK)
	WHERE b.matchid = 29
		AND b.statusID NOT IN (101,102) 
		AND refno IN (SELECT refno FROM #Refno_list)
	GROUP BY b.statusID

	/*	BetParlayDetail	*/
	SELECT  COUNT(pd.rID) AS cnt, pd.matchid, pd.statusid
	---- count(1)
	FROM BetParlayDetail pd WITH(NOLOCK)
	WHERE EXISTS (SELECT 1 FROM #Refno_list R1 WITH (NOLOCK) WHERE pd.Refno = R1.Refno)
	GROUP BY matchid, statusid

	/*	BetParlayResult	*/
	SELECT  COUNT(r.rID) AS cnt, r.statusid
	---- count(1)
	FROM BetParlayResult r with(nolock)
	WHERE EXISTS (SELECT 1 FROM #Refno_list R1 WITH (NOLOCK) WHERE r.Refno = R1.Refno)  
	GROUP BY r.statusid

/*--------------------------------------------------------------------------
	STEP 5 (OPTIONAL): 
	INSERT MISSING DATA DIRECTLY
*/--------------------------------------------------------------------------

	--IF OBJECT_ID('tempdb..#tmpBetParlayDetail') IS NOT NULL
	--	DROP TABLE #tmpBetParlayDetail

	--IF OBJECT_ID('tempdb..#tmpBetParlayResult') IS NOT NULL
	--	DROP TABLE #tmpBetParlayResult

	--CREATE TABLE #tmpBetParlayDetail (
	--	 RefNo			 	BIGINT
	--	,Serial				INT
	--	,transid			BIGINT
	--	,winlostdate		SMALLDATETIME
	--	,statuswinlost		TINYINT
	--	,statusid			TINYINT
	--	,matchid			INT
	--	,bettype			SMALLINT
	--	,stake				MONEY
	--	,odds				SMALLMONEY
	--	,betteam			NVARCHAR(20)
	--	,hdp1				SMALLMONEY
	--	,hdp2				SMALLMONEY
	--	,livehomescore		SMALLINT
	--	,liveawayscore		SMALLINT
	--	,liveindicator		BIT
	--	,betcheck			NVARCHAR(100)
	--	,transdesc			NVARCHAR(4000)
	--	,IsInserted			BIT DEFAULT(0)
	--)
	--INSERT INTO #tmpBetParlayDetail
	--SELECT	 RefNo		
	--		,Serial		
	--		,transid	
	--		,winlostdate
	--		,statuswinlost
	--		,statusid	
	--		,matchid	
	--		,bettype		
	--		,stake	
	--		,odds	
	--		,betteam		
	--		,hdp1	
	--		,hdp2		
	--		,livehomescore
	--		,liveawayscore
	--		,liveindicator
	--		,betcheck
	--		,transdesc
	--FROM  DBTXN.bodb02.dbo.BetParlayDetail pd WITH(NOLOCK)
	--WHERE EXISTS (SELECT 1 FROM #Refno_list R1 WITH (NOLOCK) WHERE pd.Refno = R1.Refno)
	
	--UPDATE tmp
	--	SET IsInserted = 1
	--FROM #tmpBetParlayDetail tmp
	--WHERE EXISTS (SELECT TOP 1 1 FROM dbo.BetParlayDetail pd WITH (NOLOCK) WHERE pd.refno = tmp.refno AND pd.transdesc = tmp.transid)

	--CREATE TABLE #tmpBetParlayResult (
	--	 RefNo			BIGINT
	--	,Serial			INT
	--	,transid		BIGINT
	--	,winlostdate	SMALLDATETIME
	--	,statusid		TINYINT
	--	,stake			MONEY
	--	,Odds			MONEY
	--	,mOdds			MONEY
	--	,winlost		MONEY
	--	,awinlost		MONEY
	--	,mwinlost		MONEY
	--	,swinlost		MONEY
	--	,playercomm		MONEY
	--	,comm			MONEY
	--	,acomm			MONEY
	--	,scomm			MONEY
	--	,IsInserted		BIT DEFAULT(0)
	--)
	--INSERT INTO #tmpBetParlayResult
	--SELECT	 RefNo			
	--		,Serial		
	--		,transid	
	--		,winlostdate
	--		,statusid  		
	--		,stake	
	--		,Odds			
	--		,mOdds			
	--		,winlost
	--		,awinlost
	--		,mwinlost
	--		,swinlost
	--		,playercomm		
	--		,comm	
	--		,acomm	
	--		,scomm
	--FROM  DBTXN.bodb02.dbo.BetParlayResult r WITH(NOLOCK)
	--WHERE EXISTS (SELECT 1 FROM #Refno_list R1 WITH (NOLOCK) WHERE r.Refno = R1.Refno) 

	--UPDATE tmp
	--	SET IsInserted = 1
	--FROM #tmpBetParlayResult tmp
	--WHERE EXISTS (SELECT TOP 1 1 FROM dbo.BetParlayResult r WITH (NOLOCK) WHERE tmp.refno = r.refno)

	--INSERT INTO dbo.BetParlayDetail (
	--	 RefNo			 	
	--	,Serial				
	--	,transid			
	--	,winlostdate		
	--	,statuswinlost		
	--	,statusid			
	--	,matchid			
	--	,bettype			
	--	,stake				
	--	,odds				
	--	,betteam			
	--	,hdp1				
	--	,hdp2				
	--	,livehomescore		
	--	,liveawayscore		
	--	,liveindicator		
	--	,betcheck			
	--	,transdesc			
	--)
	--SELECT tmpd.RefNo			
	--	,tmpd.Serial				
	--	,tmpd.transid			
	--	,tmpd.winlostdate		
	--	,tmpd.statuswinlost		
	--	,tmpd.statusid			
	--	,tmpd.matchid			
	--	,tmpd.bettype			
	--	,tmpd.stake				
	--	,tmpd.odds				
	--	,tmpd.betteam			
	--	,tmpd.hdp1				
	--	,tmpd.hdp2				
	--	,tmpd.livehomescore		
	--	,tmpd.liveawayscore		
	--	,tmpd.liveindicator		
	--	,tmpd.betcheck			
	--	,tmpd.transdesc			
	--FROM #tmpBetParlayDetail tmpd
	--WHERE tmpd.IsInserted = 1

	--INSERT INTO dbo.BetParlayResult (
	--	 RefNo			
	--	,Serial		
	--	,transid	
	--	,winlostdate
	--	,statusid  		
	--	,stake	
	--	,Odds			
	--	,mOdds			
	--	,winlost
	--	,awinlost
	--	,mwinlost
	--	,swinlost
	--	,playercomm		
	--	,comm	
	--	,acomm	
	--	,scomm
	--)
	--SELECT	 tmpr.RefNo			
	--		,tmpr.Serial		
	--		,tmpr.transid	
	--		,tmpr.winlostdate
	--		,tmpr.statusid  		
	--		,tmpr.stake	
	--		,tmpr.Odds			
	--		,tmpr.mOdds			
	--		,tmpr.winlost
	--		,tmpr.awinlost
	--		,tmpr.mwinlost
	--		,tmpr.swinlost
	--		,tmpr.playercomm		
	--		,tmpr.comm	
	--		,tmpr.acomm	
	--		,tmpr.scomm
	--FROM #tmpBetParlayResult tmpr
	--WHERE tmpr.IsInserted = 1

GO