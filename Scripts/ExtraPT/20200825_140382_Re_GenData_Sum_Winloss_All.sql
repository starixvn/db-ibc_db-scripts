/*<info serverAlias="DBTXN-bodb02" step="2"></info>*/
/*
	Create: 20200825@Sol
	DB : DBTXN-bodb02
	Task: re-generate data for sum_winloss [redmine: #140382]
*/

USE bodb02;

GO

CREATE TABLE #tblRunningSuperIds (SuperId INT PRIMARY KEY)
CREATE TABLE #tblSuperIdsTemp (SuperId INT PRIMARY KEY)

--- param to run
DECLARE @tblSuperIdsToBeExcluded TABLE (SuperId INT)
DECLARE @WinlostDate DATE , @FromDate DATE, @Todate DATE
DECLARE @strSuperIds VARCHAR(MAX) = ''

SELECT
	@FromDate = '20200816'
   ,@Todate = '20200821'

--- run from 2020-08-15 to current movebet date
SELECT @WinlostDate = @FromDate

WHILE (@WinlostDate <= @Todate)
BEGIN

	--- reset temp table
	DELETE FROM #tblSuperIdsTemp
	DELETE FROM @tblSuperIdsToBeExcluded
	
	
	--- get list excluded super
	INSERT INTO @tblSuperIdsToBeExcluded(SuperId)
	SELECT DISTINCT st.SuperId
	FROM CustDB.dbo.Acc_GroupExtraPT2Setting st WITH (NOLOCK)
	WHERE @WinlostDate BETWEEN st.FromDate AND st.ToDate

	--- list super to run
	INSERT INTO #tblSuperIdsTemp
	SELECT DISTINCT b.SuperId
	FROM CustDB.dbo.Acc_GroupExtraPTSetting b WITH(NOLOCK) 
	WHERE
		@WinlostDate BETWEEN b.FromDate AND b.ToDate
		AND b.GroupName NOT IN ('ACCYEN789', 'ACCYEN889', 'ACCUT', 'ACCUUS', 'ACCTEST')
		AND NOT EXISTS (
						SELECT 1 FROM @tblSuperIdsToBeExcluded t WHERE t.SuperId = b.SuperId
					)

	--- run sp to generate data
	WHILE 1 = 1
	BEGIN
		
		--- clear data from temp table
		DELETE FROM #tblRunningSuperIds
		SELECT @strSuperIds = ''

		DELETE TOP (500) FROM #tblSuperIdsTemp
		OUTPUT DELETED.SuperId INTO #tblRunningSuperIds

		IF @@ROWCOUNT = 0 BREAK

		--- create string superids
		SELECT @strSuperIds = @strSuperIds + CAST(SuperId AS VARCHAR(20)) + ','
		FROM #tblRunningSuperIds

		--- generate data
		--#####################################################################################
		
		DECLARE @CustIds VARCHAR(MAX) = ''
		SELECT @CustIds = @strSuperIds

		select @WinlostDate, @CustIds

		--/*

		BEGIN
			-- Get Bet Types
			DECLARE @ProductIds VARCHAR(MAX)
			SELECT  @ProductIds = COALESCE(@ProductIds + ',', '') + CONVERT(VARCHAR(10), ProductId) FROM dbo.Products WITH (NOLOCK)

			CREATE TABLE #Bettypes (ProductId INT, SportTypeRef SMALLINT, BettypeRef SMALLINT, Bettype SMALLINT)
			INSERT INTO #Bettypes (ProductId, SportTypeRef, BettypeRef, Bettype)
			SELECT f.ProductID, f.SportType AS SportTypeRef, f.BetType AS BettypeRef, s.BetType
			FROM dbo.f_SumWinloss_ConditionSel(@ProductIds) f
				CROSS APPLY (
					SELECT DISTINCT s.BetType FROM dbo.SportBettypeMatrix s WITH (NOLOCK)
					WHERE f.ProductID = s.ProductID
						AND (f.ProductID <> 6 OR f.SportType = s.SportType)
				) AS s
			-- End Get Bet Types

			-- Get Customer Info
			BEGIN
				-- Super
				CREATE TABLE #tmpSuper (srecommend INT)
				INSERT INTO #tmpSuper (srecommend)
				SELECT DISTINCT c.srecommend
				FROM CustDB.dbo.Customer c WITH (NOLOCK)
					CROSS APPLY (
						SELECT val FROM bodb02.dbo.strSplit(@CustIds, ',') f WHERE c.custid = f.val
					) AS tmp

				-- Member
				CREATE TABLE #tmpCust (custid INT, username NVARCHAR(50), recommend INT, mrecommend INT, srecommend INT)
				INSERT INTO #tmpCust (custid, username, recommend, mrecommend, srecommend)
				SELECT c.custid, c.username, c.recommend, c.mrecommend, c.srecommend
				FROM CustDB.dbo.Customer c WITH (NOLOCK)
					INNER JOIN #tmpSuper s ON c.srecommend = s.srecommend
				WHERE c.roleid = 1
			END
			-- End Get Customer Info

			---- get extra PT from table setting
			CREATE TABLE #__SuperExtraPT(productId INT, bettypePT INT, SuperId INT, ExtraPT MONEY)
			CREATE CLUSTERED INDEX CIX_#__SuperExtraPT ON #__SuperExtraPT(SuperId, bettypePT)
	
			;WITH rs AS 
			(
				SELECT DISTINCT b.bettype , b.srecommend
				FROM bettrans14 b WITH(NOLOCK) 
					INNER JOIN #tmpSuper s
						ON s.srecommend = b.srecommend
				WHERE 
					b.winlostdate = @winlostdate
					AND b.statusID IN (111,112,113)
					AND b.bettype <= 19000
			)
			INSERT INTO #__SuperExtraPT (productId, bettypePT, SuperId, ExtraPT)
			SELECT tbl.ProductID, b.bettype , b.srecommend , T.ExtraPT
			FROM rs b 
				CROSS APPLY 
				(
					SELECT
						tbl.ProductID
					FROM f_SportBettypeMatrix_Sel(0, 0, b.bettype, 2, '', '', 0) tbl
					WHERE b.bettype = tbl.bettype
				) tbl
				OUTER APPLY 
				(
					SELECT expt2.SuperId, expt2.ExtraPT
					FROM CustDB.dbo.Acc_GroupExtraPT2Setting expt2 WITH (NOLOCK)
					WHERE @winlostdate BETWEEN expt2.FromDate AND expt2.ToDate
							AND tbl.ProductID = expt2.ProductID
							AND b.srecommend = expt2.SuperId 
							AND ISNULL(expt2.SubProduct,'') = ''
							AND expt2.Sporttype = 0
				) t

			-- Get Data From bettrans14
			BEGIN
				CREATE TABLE #tmpBettrans
				(
					winlostdate			DATETIME
					,username			NVARCHAR(50)
					,custid				INT
					,roleid				INT
					,recommend			INT
					,mrecommend			INT
					,srecommend			INT
					,turnover			MONEY
					,winlost			MONEY
					,awinlost			MONEY
					,mwinlost			MONEY
					,swinlost			MONEY
					,playercomm			MONEY
					,comm				MONEY
					,acomm				MONEY
					,scomm				MONEY
					,BetCount			INT
					,member_grosscomm	MONEY
					,agent_grosscomm	MONEY
					,master_grosscomm	MONEY
					,super_grosscomm	MONEY
					,sporttype			SMALLINT
					,bettype			SMALLINT
					,member_netTurnover	MONEY
					,agent_netTurnover	MONEY
					,master_netTurnover	MONEY
					,super_netTurnover	MONEY
					,TurnoverNoDraw		MONEY
					,ExtraWinloss		MONEY NULL
					,ExtraComm			MONEY NULL
				)
				INSERT INTO #tmpBettrans
				(
					winlostdate
					,username
					,custid
					,roleid
					,recommend
					,mrecommend
					,srecommend
					,turnover
					,winlost
					,awinlost
					,mwinlost
					,swinlost
					,playercomm
					,comm
					,acomm
					,scomm
					,BetCount
					,member_grosscomm
					,agent_grosscomm
					,master_grosscomm
					,super_grosscomm
					,sporttype
					,bettype
					,member_netTurnover
					,agent_netTurnover
					,master_netTurnover
					,super_netTurnover
					,TurnoverNoDraw
					,ExtraWinloss
					,ExtraComm
				)
				SELECT
					b.winlostdate
					,c.username
					,b.custid
					,1 AS roleid
					,c.recommend
					,c.mrecommend
					,c.srecommend
					,SUM(ABS(b.stake)) AS turnover
					,SUM(b.winlost - b.actual_stake) AS winlost
					,SUM(b.awinlost) AS awinlost
					,SUM(b.mwinlost) AS mwinlost
					,SUM(b.swinlost) AS swinlost
					,SUM(b.playercomm) AS playercomm
					,SUM(b.comm) AS comm
					,SUM(b.acomm) AS acomm
					,SUM(b.scomm) AS scomm
					,SUM(CASE	WHEN b.bettype = 500 THEN 0
								ELSE 1 END) AS BetCount
					,SUM(CASE	WHEN b.apositiontaking = 1 THEN 0
								ELSE ISNULL(b.comm / (1 - b.apositiontaking), 0) END) AS member_grosscomm
					,SUM(CASE	WHEN b.apositiontaking + b.mpositiontaking = 1 THEN 0
								ELSE ISNULL(b.acomm / (1 - b.apositiontaking - b.mpositiontaking), 0) END) AS agent_grosscomm
					,SUM(CASE	WHEN b.tpositiontaking = 1 THEN 0
								ELSE ISNULL(b.scomm / (1 - b.tpositiontaking), 0) END) AS master_grosscomm
					,SUM(CASE	WHEN b.tpositiontaking = 1 THEN 0
								ELSE ISNULL(b.scomm / (1 - b.tpositiontaking), 0) END) AS super_grosscomm
					,bt.sporttypeRef AS sporttype
					,bt.bettypeRef AS bettype
					,0 AS member_netTurnover
					,SUM(ABS(b.stake) * b.apositiontaking) AS agent_netTurnover
					,SUM(ABS(b.stake) * b.mpositiontaking) AS master_netTurnover
					,SUM(ABS(b.stake) * b.spositiontaking) AS super_netTurnover
					,SUM(CASE
							WHEN bt.ProductId = 1 AND b.statusID IN (112, 113) AND b.modds IN (-0.25, 0.25) THEN ABS(b.stake) / 2 -- SportsBook
							WHEN bt.ProductId = 1 AND b.statusID = 111 THEN 0 -- SportsBook
							WHEN bt.ProductID IN (21, 39, 45, 46, 47, 52)  THEN b.oddsspread -- Allbet, SA Gaming, SexyGaming, IBCBet Live Casino, BBIN, ION
							ELSE ABS(b.stake) END) AS TurnoverNoDraw
					,-1 * SUM(ISNULL(b.ExtraWinloss, 0)) AS ExtraWinloss
					,-1 * SUM(ISNULL(b.ExtraComm, 0)) AS ExtraComm
				FROM #tmpCust c
					CROSS APPLY (
						SELECT
							winlostdate
							,b.custid
							,b.stake
							,b.actual_stake
							,b.winlost
							,b.awinlost
							,b.mwinlost
							,b.swinlost
							,b.playercomm
							,b.comm
							,b.acomm
							,b.scomm
							,b.oddsspread
							,b.apositiontaking
							,b.mpositiontaking
							,b.spositiontaking
							,b.tpositiontaking
							,b.bettype
							,b.modds
							,b.statusID
							,CASE
								-- Jackpot
								WHEN b.bettype IN (2198, 2398, 2998, 4297) THEN
									CASE WHEN b.tpositiontaking = 1 THEN 0 ELSE ISNULL(b.betid/CONVERT(DECIMAL(19,8), 100000000), 0) END
								WHEN b.bettype IN (2199, 2399, 2999, 4298) THEN 0
								ELSE CASE WHEN b.tpositiontaking = 1 THEN 0 ELSE b.winlost - b.actual_stake END
							END
							* CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT
									ELSE ISNULL(b.epositiontaking, 0)
								END 
							AS ExtraWinloss,
							CASE 
								/*IBCBet Live Casino*/
								WHEN b.bettype BETWEEN 3201 AND 3299 THEN b.scomm
								WHEN b.bettype IN (2198, 2398, 2998, 2199, 2399, 2999, 4297, 4298) THEN 0
								ELSE 
									CASE 
										WHEN b.tpositiontaking = 1 THEN 0 
										ELSE b.scomm / (1 - b.tpositiontaking)
									END * CASE WHEN tbl.ExtraPT IS NOT NULL THEN tbl.ExtraPT ELSE ISNULL(b.epositiontaking, 0) END 
							END
							AS ExtraComm
						FROM dbo.bettrans14 b WITH (NOLOCK)
							INNER JOIN #__SuperExtraPT tbl 
								ON b.srecommend = tbl.SuperId
									AND b.bettype = tbl.bettypePT
						WHERE b.winlostdate = @WinlostDate
							AND c.custid = b.custid
							AND b.statusID IN (111,112,113)
					) AS b
					INNER JOIN #Bettypes bt ON b.bettype = bt.bettype
				GROUP BY
					b.winlostdate
					,c.username
					,b.custid
					,c.recommend
					,c.mrecommend
					,c.srecommend
					,bt.sporttypeRef
					,bt.bettypeRef
			END
			-- End Get Data From bettrans14

			DROP TABLE #tmpCust
			DROP TABLE #Bettypes

			-- Sum up Data by Level
			BEGIN
				CREATE TABLE #tmpSum_winloss
				(
					winlostdate			DATETIME
					,username			NVARCHAR(50)
					,custid				INT
					,roleid				INT
					,recommend			INT
					,mrecommend			INT
					,srecommend			INT
					,turnover			MONEY
					,winlost			MONEY
					,awinlost			MONEY
					,mwinlost			MONEY
					,swinlost			MONEY
					,playercomm			MONEY
					,comm				MONEY
					,acomm				MONEY
					,scomm				MONEY
					,BetCount			INT
					,grosscomm			MONEY
					,sporttype			SMALLINT
					,bettype			SMALLINT
					,netTurnover		MONEY
					,TurnoverNoDraw		MONEY
					,ExtraWinloss		MONEY NULL
					,ExtraComm			MONEY NULL
				)

				-- Member
				INSERT INTO #tmpSum_winloss
				(
					winlostdate
					,username
					,custid
					,roleid
					,recommend
					,mrecommend
					,srecommend
					,turnover
					,winlost
					,awinlost
					,mwinlost
					,swinlost
					,playercomm
					,comm
					,acomm
					,scomm
					,BetCount
					,grosscomm
					,sporttype
					,bettype
					,netTurnover
					,TurnoverNoDraw
					,ExtraWinloss
					,ExtraComm
				)
				SELECT
					winlostdate
					,username
					,custid
					,roleid
					,recommend
					,mrecommend
					,srecommend
					,turnover
					,winlost
					,awinlost
					,mwinlost
					,swinlost
					,playercomm
					,comm
					,acomm
					,scomm
					,BetCount
					,member_grosscomm
					,sporttype
					,bettype
					,member_netTurnover
					,TurnoverNoDraw
					,ExtraWinloss
					,ExtraComm
				FROM #tmpBettrans

				-- Agent
				;WITH CTE_Agent AS
				(
					SELECT
						winlostdate
						,recommend
						,mrecommend
						,srecommend
						,SUM(turnover) AS turnover
						,SUM(winlost) AS winlost
						,SUM(awinlost) AS awinlost
						,SUM(mwinlost) AS mwinlost
						,SUM(swinlost) AS swinlost
						,SUM(playercomm) AS playercomm
						,SUM(comm) AS comm
						,SUM(acomm) AS acomm
						,SUM(scomm) AS scomm
						,SUM(BetCount) AS BetCount
						,SUM(agent_grosscomm) AS grosscomm
						,sporttype
						,bettype
						,SUM(agent_netTurnover) AS netTurnover
						,SUM(TurnoverNoDraw) AS TurnoverNoDraw
						,SUM(ExtraWinloss) AS ExtraWinloss
						,SUM(ExtraComm) AS ExtraComm
					FROM #tmpBettrans
					GROUP BY
						winlostdate
						,recommend
						,mrecommend
						,srecommend
						,sporttype
						,bettype
				)
				INSERT INTO #tmpSum_winloss
				(
					winlostdate
					,username
					,custid
					,roleid
					,recommend
					,mrecommend
					,srecommend
					,turnover
					,winlost
					,awinlost
					,mwinlost
					,swinlost
					,playercomm
					,comm
					,acomm
					,scomm
					,BetCount
					,grosscomm
					,sporttype
					,bettype
					,netTurnover
					,TurnoverNoDraw
					,ExtraWinloss
					,ExtraComm
				)
				SELECT
					winlostdate
					,username
					,recommend AS custid
					,2 AS roleid
					,recommend
					,mrecommend
					,srecommend
					,turnover
					,winlost
					,awinlost
					,mwinlost
					,swinlost
					,playercomm
					,comm
					,acomm
					,scomm
					,BetCount
					,grosscomm
					,sporttype
					,bettype
					,netTurnover
					,TurnoverNoDraw
					,ExtraWinloss
					,ExtraComm
				FROM CTE_Agent a
					CROSS APPLY (
						SELECT username FROM CustDB.dbo.Customer c WITH (NOLOCK) WHERE a.recommend = c.custid
					) AS c

				-- Master
				;WITH CTE_Master AS
				(
					SELECT
						winlostdate
						,mrecommend
						,srecommend
						,SUM(turnover) AS turnover
						,SUM(winlost) AS winlost
						,SUM(awinlost) AS awinlost
						,SUM(mwinlost) AS mwinlost
						,SUM(swinlost) AS swinlost
						,SUM(playercomm) AS playercomm
						,SUM(comm) AS comm
						,SUM(acomm) AS acomm
						,SUM(scomm) AS scomm
						,SUM(BetCount) AS BetCount
						,SUM(master_grosscomm) AS grosscomm
						,sporttype
						,bettype
						,SUM(master_netTurnover) AS netTurnover
						,SUM(TurnoverNoDraw) AS TurnoverNoDraw
						,SUM(ExtraWinloss) AS ExtraWinloss
						,SUM(ExtraComm) AS ExtraComm
					FROM #tmpBettrans
					GROUP BY
						winlostdate
						,mrecommend
						,srecommend
						,sporttype
						,bettype
				)
				INSERT INTO #tmpSum_winloss
				(
					winlostdate
					,username
					,custid
					,roleid
					,recommend
					,mrecommend
					,srecommend
					,turnover
					,winlost
					,awinlost
					,mwinlost
					,swinlost
					,playercomm
					,comm
					,acomm
					,scomm
					,BetCount
					,grosscomm
					,sporttype
					,bettype
					,netTurnover
					,TurnoverNoDraw
					,ExtraWinloss
					,ExtraComm
				)
				SELECT
					winlostdate
					,username
					,mrecommend AS custid
					,3 AS roleid
					,0 AS recommend
					,mrecommend
					,srecommend
					,turnover
					,winlost
					,awinlost
					,mwinlost
					,swinlost
					,playercomm
					,comm
					,acomm
					,scomm
					,BetCount
					,grosscomm
					,sporttype
					,bettype
					,netTurnover
					,TurnoverNoDraw
					,ExtraWinloss
					,ExtraComm
				FROM CTE_Master m
					CROSS APPLY (
						SELECT username FROM CustDB.dbo.Customer c WITH (NOLOCK) WHERE m.mrecommend = c.custid
					) AS c

				-- Super
				;WITH CTE_Super AS
				(
					SELECT
						winlostdate
						,srecommend
						,SUM(turnover) AS turnover
						,SUM(winlost) AS winlost
						,SUM(awinlost) AS awinlost
						,SUM(mwinlost) AS mwinlost
						,SUM(swinlost) AS swinlost
						,SUM(playercomm) AS playercomm
						,SUM(comm) AS comm
						,SUM(acomm) AS acomm
						,SUM(scomm) AS scomm
						,SUM(BetCount) AS BetCount
						,SUM(super_grosscomm) AS grosscomm
						,sporttype
						,bettype
						,SUM(super_netTurnover) AS netTurnover
						,SUM(TurnoverNoDraw) AS TurnoverNoDraw
						,SUM(ExtraWinloss) AS ExtraWinloss
						,SUM(ExtraComm) AS ExtraComm
					FROM #tmpBettrans
					GROUP BY
						winlostdate
						,srecommend
						,sporttype
						,bettype
				)
				INSERT INTO #tmpSum_winloss
				(
					winlostdate
					,username
					,custid
					,roleid
					,recommend
					,mrecommend
					,srecommend
					,turnover
					,winlost
					,awinlost
					,mwinlost
					,swinlost
					,playercomm
					,comm
					,acomm
					,scomm
					,BetCount
					,grosscomm
					,sporttype
					,bettype
					,netTurnover
					,TurnoverNoDraw
					,ExtraWinloss
					,ExtraComm
				)
				SELECT
					winlostdate
					,username
					,srecommend AS custid
					,4 AS roleid
					,0 AS recommend
					,0 AS mrecommend
					,srecommend
					,turnover
					,winlost
					,awinlost
					,mwinlost
					,swinlost
					,playercomm
					,comm
					,acomm
					,scomm
					,BetCount
					,grosscomm
					,sporttype
					,bettype
					,netTurnover
					,TurnoverNoDraw
					,ExtraWinloss
					,ExtraComm
				FROM CTE_Super s
					CROSS APPLY (
						SELECT username FROM CustDB.dbo.Customer c WITH (NOLOCK) WHERE s.srecommend = c.custid
					) AS c

				DROP TABLE #tmpBettrans
			END
			-- End Sum up Data by Level

			-- Regen data
			BEGIN
				
				UPDATE tar WITH(ROWLOCK)
					SET ExtraWinloss = source.ExtraWinloss
						,ExtraComm = source.ExtraComm
				FROM sum_winloss tar
					INNER JOIN #tmpSum_winloss AS source
						ON tar.winlostdate	= source.winlostdate
						AND	tar.custid		= source.custid
						AND tar.sporttype	= source.sporttype
						AND tar.bettype		= source.bettype
				
			END
			-- End Regen data

			DROP TABLE #tmpSuper
			DROP TABLE #tmpSum_winloss
			DROP TABLE #__SuperExtraPT

		END

		--*/

		--#####################################################################################
		WAITFOR DELAY '00:00:00:500'

	END

	SELECT 'DONE: ' + CAST(@WinlostDate AS VARCHAR(20))
	--- get next date
	SELECT @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END

DROP TABLE #tblRunningSuperIds
DROP TABLE #tblSuperIdsTemp

GO