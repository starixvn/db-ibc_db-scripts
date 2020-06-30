/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
	Created: 20200618@Malcolm
	Task: the script to create data from 2020-05-01 [Redmine: #135593]
	DB: DBARC.bodb_Archive
*/

/*create physical table*/

CREATE TABLE dbo.Sum_Winloss_Extra_Tmp
(
		WinlostDate			DATETIME,
		CustId				INT,
		ProductId			SMALLINT,
		Bettype				SMALLINT,
		RoleID				INT,
		Recommend			INT,
		MRecommend			INT,
		SRecommend			INT,
		BetCount			INT,
		Turnover			MONEY,
		NetTurnover			MONEY,
		TurnoverNoDraw		MONEY,
		WinLoss				MONEY,
		AgWinLoss			MONEY,
		MAgWinLoss			MONEY,
		SAgWinLoss			MONEY,
		ExtraWinloss		MONEY,
		PlayerComm			MONEY,
		AgComm				MONEY,
		MAgComm				MONEY,
		SAgComm				MONEY,
		ExtraComm			MONEY,
		GrossComm			MONEY
)

DECLARE @WinlostDate SMALLDATETIME = '20200501',@BalanceUpDay SMALLDATETIME

SELECT TOP 1 @BalanceUpDay = winlostdate
FROM bodb02.dbo.bettrans WITH(NOLOCK)
WHERE bettype = 20000 and matchid = 0	and custid = 3

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
		WinlostDate			DATETIME,
		CustId				INT,
		ProductId			SMALLINT,
		Bettype				SMALLINT,
		RoleID				INT,
		Recommend			INT,
		MRecommend			INT,
		SRecommend			INT,
		BetCount			INT,
		Turnover			MONEY,
		NetTurnover			MONEY,
		NetTurnoverAg		MONEY,
		NetTurnoverMAg		MONEY,
		NetTurnoverSAg		MONEY,
		TurnoverNoDraw		MONEY,
		WinLoss				MONEY,
		AgWinLoss			MONEY,
		MAgWinLoss			MONEY,
		SAgWinLoss			MONEY,
		ExtraWinloss		MONEY,
		PlayerComm			MONEY,
		AgComm				MONEY,
		MAgComm				MONEY,
		SAgComm				MONEY,
		ExtraComm			MONEY,
		GrossComm			MONEY,
		GrossCommAg			MONEY,
		GrossCommMAg		MONEY,
		GrossCommSAg		MONEY
	)

CREATE TABLE #Sum_Winloss_Extra_tmp
(
		WinlostDate			DATETIME,
		CustId				INT,
		ProductId			SMALLINT,
		Bettype				SMALLINT,
		RoleID				INT,
		Recommend			INT,
		MRecommend			INT,
		SRecommend			INT,
		BetCount			INT,
		Turnover			MONEY,
		NetTurnover			MONEY,
		TurnoverNoDraw		MONEY,
		WinLoss				MONEY,
		AgWinLoss			MONEY,
		MAgWinLoss			MONEY,
		SAgWinLoss			MONEY,
		ExtraWinloss		MONEY,
		PlayerComm			MONEY,
		AgComm				MONEY,
		MAgComm				MONEY,
		SAgComm				MONEY,
		ExtraComm			MONEY,
		GrossComm			MONEY
)


WHILE  @WinlostDate <= @BalanceUpDay
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
			NetTurnoverAg,
			NetTurnoverMAg,
			NetTurnoverSAg,
			TurnoverNoDraw,
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
			GrossComm,
			GrossCommAg,
			GrossCommMAg,
			GrossCommSAg
		)
		SELECT
			@WinlostDate, 
			custid,
			b.ProductId,
			0 AS Bettype,
			1,
		    recommend,
		    mrecommend,
			srecommend,
			COUNT(1) BetCount,
			SUM(ABS(bt.stake)) Turnover,
			0 AS NetTurnover,
			SUM(ABS(stake * apositiontaking)) AS NetTurnoverAg,
			sum(ABS(stake * mpositiontaking)) AS NetTurnoverMAg,
			SUM(ABS(stake * spositiontaking)) AS NetTurnoverSAg,
			SUM(CASE WHEN b.ProductId = 46 THEN bt.oddsspread ELSE 0 END) AS TurnoverNoDraw,
			SUM(winlost-actual_stake) Winlost,
			SUM(awinlost) AgWinLoss,
			SUM(mwinlost) MAgWinLoss,
			SUM(swinlost) SAgWinLoss,
			-SUM((winlost - actual_stake) * epositiontaking) ExtraWinloss,
			SUM(playercomm)  PlayerComm,
			SUM(comm) - SUM(playercomm) AgComm,
			SUM(acomm) - SUM(comm) MAgComm,
			SUM(scomm) - SUM(acomm) SAgComm,
			-SUM(scomm) ExtraComm,
			SUM(CASE WHEN apositiontaking = 1 THEN 0 ELSE comm/(1-apositiontaking) END) AS GrossComm,
			SUM(CASE WHEN (apositiontaking+mpositiontaking) = 1 THEN 0 ELSE acomm/(1-apositiontaking-mpositiontaking) END) AS GrossCommAg,
			SUM(CASE WHEN tpositiontaking = 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommMAg,
			SUM(CASE WHEN tpositiontaking = 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommSAg	
		FROM dbo.bettrans_bk bt WITH(NOLOCK)
			INNER JOIN #Bettype b ON bt.bettype = b.TypeId
		WHERE bt.winlostdate  = @WinlostDate 
			AND bt.statusID NOT IN (102,101,103)
		GROUP BY winlostdate ,custid, recommend, mrecommend, srecommend, b.ProductId

		SET @WinlostDate = DATEADD(DAY,1,@WinlostDate)	
END
	-- for agent, roleid = 2
	
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
	TurnoverNoDraw,
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
	SUM(NetTurnoverAg),
	SUM(TurnoverNoDraw),
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
	SUM(GrossCommAg)
FROM #Sum_Winloss_Extra
WHERE RoleId = 1 
GROUP BY WinlostDate,Recommend,MRecommend,SRecommend,ProductId,Bettype
	
-- for master, roleId = 3
	
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
	TurnoverNoDraw,
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
	SUM(NetTurnoverMAg),
	SUM(TurnoverNoDraw),
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
	SUM(GrossCommMAg)
FROM #Sum_Winloss_Extra
WHERE RoleID = 1
GROUP BY WinlostDate,MRecommend,SRecommend,ProductId,Bettype
	
	-- for super, roleId = 4
	
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
	TurnoverNoDraw,
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
	SUM(NetTurnoverSAg),
	SUM(TurnoverNoDraw),
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
	SUM(GrossCommSAg)
FROM #Sum_Winloss_Extra
WHERE RoleID = 1 
GROUP BY WinlostDate,SRecommend,ProductId,Bettype
		
WHILE 1 = 1
BEGIN
	DELETE #Sum_Winloss_Extra_tmp

	DELETE TOP(2000) FROM #Sum_Winloss_Extra
	OUTPUT	deleted.WinlostDate,
			deleted.CustId,
			deleted.ProductId,
			deleted.Bettype,
			deleted.RoleID,
			deleted.Recommend,
			deleted.MRecommend,
			deleted.SRecommend,
			deleted.BetCount,
			deleted.Turnover,
			deleted.NetTurnover,
			deleted.TurnoverNoDraw,
			deleted.WinLoss,
			deleted.AgWinLoss,		
			deleted.MAgWinLoss,
			deleted.SAgWinLoss,
			deleted.ExtraWinloss,
			deleted.PlayerComm,
			deleted.AgComm,
			deleted.MAgComm,
			deleted.SAgComm,
			deleted.ExtraComm,
			deleted.GrossComm
	INTO #Sum_Winloss_Extra_tmp
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
		TurnoverNoDraw,
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

	IF  @@ROWCOUNT = 0
		BREAK

	INSERT INTO dbo.Sum_Winloss_Extra_Tmp
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
			TurnoverNoDraw,
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
	SELECT	WinlostDate,
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
			TurnoverNoDraw,
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
	FROM #Sum_Winloss_Extra_tmp

END

DROP TABLE #Bettype, #Sum_Winloss_Extra,#Sum_Winloss_Extra_tmp