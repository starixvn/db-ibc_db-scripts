/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
	Created: 20200618@Malcolm
	Task: the script to create data from 2020-05-01 [Redmine: #135593]
	DB: DBARC.bodb_Archive
*/
DECLARE @WinlostDate datetime = '20200501'

CREATE TABLE #Bettype(TypeId INT, ProductId INT)


INSERT INTO #Bettype
(
	TypeId, ProductId
)
SELECT DISTINCT BetType, ProductId
FROM bodb02.dbo.SportBettypeMatrix m WITH(NOLOCK)
WHERE m.ProductID = 46

CREATE TABLE #Sum_Winloss_Extra 
	(
		WinlostDate		DATETIME,
		CustId			INT,
		ProductId		SMALLINT,
		Bettype			SMALLINT,
		RoleID			INT,
		Recommend		INT,
		MRecommend		INT,
		SRecommend		INT,
		BetCount		INT,
		Turnover		MONEY,
		NetTurnover		MONEY,
		TunroverNoDraw	MONEY,
		WinLoss			MONEY,
		AgWinLoss		MONEY,
		MAgWinLoss		MONEY,
		SAgWinLoss		MONEY,
		ExtraWinloss	MONEY,
		PlayerComm		MONEY,
		AgComm			MONEY,
		MAgComm			MONEY,
		SAgComm			MONEY,
		ExtraComm		MONEY,
		GrossComm		MONEY
	)

BEGIN
		INSERT INTO #Sum_Winloss_Extra
		(
			WinlostDate,
			CustId,
			ProductId,
			Bettype,
			RoleID,
			Recommend,
			MRecommend,
			SRecommend,
			BetCount,
			Turnover,
			NetTurnover,
			TunroverNoDraw,
			WinLoss,
			AgWinLoss,		
			MAgWinLoss,
			SAgWinLoss,
			ExtraWinloss,
			PlayerComm,
			AgComm,
			MAgComm,
			SAgComm,
			ExtraComm,
			GrossComm
		)
		SELECT
			WinlostDate, 
			custid,
			b.ProductId,
			CASE WHEN bt.bettype IN (71, 72) THEN bt.bettype ELSE  0 END Bettype,
			1,
		    recommend,
		    mrecommend,
			srecommend,
			COUNT(1) BetCount,
			SUM(ABS(bt.stake)) TurnOver,
			0 AS NetTurnOver,
			SUM( CASE	WHEN bt.StatusID IN (112,113) AND bt.MOdds IN (-0.25, 0.25) 
							---- Sportsbook
							AND (bt.Bettype < 999 OR bt.bettype BETWEEN 1301 AND 1399 OR bt.bettype BETWEEN 9001 AND 9399)
							AND bt.Bettype NOT IN (71,72)
							AND bt.Bettype NOT BETWEEN 81 AND 120			
							THEN ABS(stake)/2
						WHEN bt.StatusID = 111  
							AND (
								---- Sportsbook
									(bt.Bettype < 999 OR bt.bettype BETWEEN 1301 AND 1399 OR bt.bettype BETWEEN 9001 AND 9399)
									AND bt.Bettype NOT IN (71,72)
									AND bt.Bettype NOT BETWEEN 81 AND 120
							)
							THEN 0
						WHEN   bt.Bettype BETWEEN 2401 AND 2499   -- Allbet
							OR bt.Bettype BETWEEN 3001 AND 3099   -- SA Gaming
							OR bt.Bettype BETWEEN 3101 AND 3199   -- Sexy Gaming
							OR bt.Bettype BETWEEN 3300 AND 3399   -- BBIN	
							OR bt.Bettype BETWEEN 3201 AND 3299   -- IBCBet Live Casino
							OR bt.Bettype BETWEEN 5601 AND 5699   -- ION 	 
							THEN bt.oddsspread
						ELSE ABS(bt.stake) 
					END) AS TurnoverNoDrawm,
			SUM(winlost-actual_stake) Winlost,
			SUM(awinlost) AgWinLoss,
			SUM(mwinlost) MAgWinLoss,
			SUM(swinlost) SAgWinLoss,
			SUM((winlost - actual_stake) * epositiontaking) ExtraWinloss,
			SUM(playercomm)  PlayerComm,
			SUM(comm) - SUM(playercomm) AgComm,
			SUM(acomm) - SUM(comm) MAgComm,
			SUM(scomm) - SUM(acomm) SAgComm,
			-SUM(scomm) ExtraComm,
			SUM(CASE WHEN apositiontaking = 1 THEN 0 ELSE ISNULL(comm/(1-apositiontaking),0) END) GrossComm			
		FROM dbo.bettrans_bk bt WITH(NOLOCK)
			INNER JOIN #Bettype b ON bt.bettype = b.TypeId
		WHERE bt.winlostdate  >= @WinlostDate 
			AND bt.statusID NOT IN (0,1,102,101,103)
			AND bt.bettype < 19000
		GROUP BY winlostdate ,custid, recommend, mrecommend, srecommend, b.ProductId,
				CASE WHEN bettype IN (71, 72) THEN bettype ELSE 0 END
	END
	-- for agent, roleid = 2
	BEGIN
		INSERT INTO #Sum_Winloss_Extra
		(
			WinlostDate,
			CustId,
			ProductId,
			Bettype,
			RoleID,
			Recommend,
			MRecommend,
			SRecommend,
			BetCount,
			Turnover,
			NetTurnover,
			TunroverNoDraw,
			WinLoss,
			AgWinLoss,		
			MAgWinLoss,
			SAgWinLoss,
			ExtraWinloss,
			PlayerComm,
			AgComm,
			MAgComm,
			SAgComm,
			ExtraComm,
			GrossComm
		)
		SELECT 
			WinlostDate,
			Recommend,
			ProductId,
			Bettype,
			2 AS RoleId,
			Recommend,
			MRecommend,
			SRecommend,
			SUM(BetCount),
			SUM(Turnover),
			SUM(NetTurnover),
			SUM(TunroverNoDraw),
			SUM(WinLoss),
			SUM(AgWinLoss),		
			SUM(MAgWinLoss),
			SUM(SAgWinLoss),
			SUM(ExtraWinloss),
			SUM(PlayerComm),
			SUM(AgComm),
			SUM(MAgComm),
			SUM(SAgComm),
			SUM(ExtraComm),
			SUM(GrossComm)
		FROM #Sum_Winloss_Extra
		GROUP BY WinlostDate,Recommend,MRecommend,SRecommend,ProductId,Bettype
	END

	-- for master, roleId = 3
	BEGIN
		INSERT INTO #Sum_Winloss_Extra
		(
			WinlostDate,
			CustId,
			ProductId,
			Bettype,
			RoleID,
			Recommend,
			MRecommend,
			SRecommend,
			BetCount,
			Turnover,
			NetTurnover,
			TunroverNoDraw,
			WinLoss,
			AgWinLoss,		
			MAgWinLoss,
			SAgWinLoss,
			ExtraWinloss,
			PlayerComm,
			AgComm,
			MAgComm,
			SAgComm,
			ExtraComm,
			GrossComm
		)
		SELECT 
			WinlostDate,
			Mrecommend,
			ProductId,
			Bettype,
			3 AS RoleId,
			0 AS Recommend,
			MRecommend,
			SRecommend,
			SUM(BetCount),
			SUM(Turnover),
			SUM(NetTurnover),
			SUM(TunroverNoDraw),
			SUM(WinLoss),
			SUM(AgWinLoss),		
			SUM(MAgWinLoss),
			SUM(SAgWinLoss),
			SUM(ExtraWinloss),
			SUM(PlayerComm),
			SUM(AgComm),
			SUM(MAgComm),
			SUM(SAgComm),
			SUM(ExtraComm),
			SUM(GrossComm)
		FROM #Sum_Winloss_Extra
		GROUP BY WinlostDate,MRecommend,SRecommend,ProductId,Bettype
	END
	-- for super, roleId = 4
	BEGIN
		INSERT INTO #Sum_Winloss_Extra
		(
			WinlostDate,
			CustId,
			ProductId,
			Bettype,
			RoleID,
			Recommend,
			MRecommend,
			SRecommend,
			BetCount,
			Turnover,
			NetTurnover,
			TunroverNoDraw,
			WinLoss,
			AgWinLoss,		
			MAgWinLoss,
			SAgWinLoss,
			ExtraWinloss,
			PlayerComm,
			AgComm,
			MAgComm,
			SAgComm,
			ExtraComm,
			GrossComm
		)
		SELECT 
			WinlostDate,
			SRecommend AS CustId,
			ProductId,
			Bettype,
			4 AS RoleId,
			0 AS Recommend,
			0 AS MRecommend,
			SRecommend,
			SUM(BetCount),
			SUM(Turnover),
			SUM(NetTurnover),
			SUM(TunroverNoDraw),
			SUM(WinLoss),
			SUM(AgWinLoss),		
			SUM(MAgWinLoss),
			SUM(SAgWinLoss),
			SUM(ExtraWinloss),
			SUM(PlayerComm),
			SUM(AgComm),
			SUM(MAgComm),
			SUM(SAgComm),
			SUM(ExtraComm),
			SUM(GrossComm)
		FROM #Sum_Winloss_Extra
		GROUP BY WinlostDate,SRecommend,ProductId,Bettype
	END

INSERT INTO DBSUM.bodb_Summary.dbo.Sum_winloss_extra
		(
			WinlostDate,
			CustId,
			ProductId,
			Bettype,
			RoleID,
			Recommend,
			MRecommend,
			SRecommend,
			BetCount,
			Turnover,
			NetTurnover,
			TunroverNoDraw,
			WinLoss,
			AgWinLoss,		
			MAgWinLoss,
			SAgWinLoss,
			ExtraWinloss,
			PlayerComm,
			AgComm,
			MAgComm,
			SAgComm,
			ExtraComm,
			GrossComm
		)
SELECT		WinlostDate,
			CustId,
			ProductId,
			Bettype,
			RoleID,
			Recommend,
			MRecommend,
			SRecommend,
			BetCount,
			Turnover,
			NetTurnover,
			TunroverNoDraw,
			WinLoss,
			AgWinLoss,		
			MAgWinLoss,
			SAgWinLoss,
			ExtraWinloss,
			PlayerComm,
			AgComm,
			MAgComm,
			SAgComm,
			ExtraComm,
			GrossComm
FROM #Sum_Winloss_Extra

DROP TABLE #Bettype, #Sum_Winloss_Extra