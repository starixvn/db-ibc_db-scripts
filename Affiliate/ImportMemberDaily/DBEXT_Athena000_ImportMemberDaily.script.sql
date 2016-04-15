USE Affiliate_Athena000
GO

declare
	@Xml 			XML
	,@Prefix 		VARCHAR(100)
	,@Date 			SMALLDATETIME
	,@ProductIDs 	VARCHAR(100) 	= NULL

BEGIN
	SET NOCOUNT ON

	SELECT @date		= '20160414'
		, @Xml			= '<root><trans username="afftest14"></trans></root>'	 
		, @Prefix		= 'Athena000$'
		, @ProductIDs	= '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20'
	SELECT @Date	= dateadd(dd, datediff(dd, 0, @DATE), 0)

	CREATE TABLE #LicenseeCust (
		custID 			INT
		,currency 		INT
		,username 		VARCHAR(100)
		,srecommend 	INT
		,mrecommend 	INT
		,recommend 		INT
	)
	-- Do filtering product 
	CREATE TABLE #ProductBettype (
		ProductId 		TINYINT
		, Bettype		SMALLINT
	)
	
	CREATE TABLE #ProductSporttype (
		ProductId 		TINYINT
		, Sporttype 	SMALLINT
	)
	
	DECLARE @ProductFilter TABLE (ProductId TINYINT)
	INSERT INTO @ProductFilter ( ProductId )
	SELECT CAST(val AS TINYINT) AS ProductId 
	FROM [dbo].[strSplit_Key](@ProductIDs, ',')
	
	-- insert product & bettype mapping
	INSERT INTO #ProductBettype (
		ProductId
		, Bettype
	)
	SELECT DISTINCT p.ProductId
		, bt.Bettype
	FROM bodb02.dbo.SportBettypeMatrix bt WITH(NOLOCK)
		INNER JOIN @ProductFilter p
		ON bt.ProductId = p.ProductId
	WHERE bt.IsTest 	= 0
		AND bt.Enabled 	= 1
	
	-- insert product & Sporttype mapping
	INSERT INTO #ProductSporttype (
		ProductId
		, Sporttype
	)
	SELECT DISTINCT p.ProductId
		, bt.Sporttype
	FROM bodb02.dbo.SportBettypeMatrix bt WITH(NOLOCK)
		INNER JOIN @ProductFilter p
		ON bt.ProductId = p.ProductId
	WHERE bt.IsTest 	= 0
		AND bt.Enabled 	= 1
	
	DECLARE @CutDate DATETIME
		,@MaxDate DATETIME
		
	SELECT @CutDate = min(winlostdate)
		,@MaxDate = MAX(Winlostdate)
	FROM bodb_licensee.dbo.rptLicWinloss2 WITH (NOLOCK)

	CREATE TABLE #tmpRpt (
		Winlostdate SMALLDATETIME
		,CustID INT
		,Username NVARCHAR(50)
		,ProductID INT
		,Turnover MONEY
		,Outstanding MONEY
		,Winloss MONEY
		,DrawGame MONEY
		,PlayerComm MONEY
		,BetCount INT
		,TurnoverNoDraw MONEY
		,BetCountNoDraw INT
		,ProgressiveShare MONEY DEFAULT(0)
		,ProgressiveWin MONEY DEFAULT(0)
	)

	CREATE TABLE #TempTrans(UserName VARCHAR(30))

	INSERT INTO #TempTrans (UserName) --Convert xml to table
	SELECT [Table].[Column].value('./@username', 'varchar(30)') AS UserName
	FROM @Xml.nodes('//root/trans') AS [Table]([Column])

	INSERT INTO #LicenseeCust
	SELECT c.CustID
		,c.Currency
		,t.UserName
		,c.srecommend
		,c.mrecommend
		,c.recommend
	FROM bodb02.dbo.customer c WITH (NOLOCK)
		INNER JOIN #TempTrans AS t ON @Prefix + t.username = c.username2
		--INNER JOIN #TempTrans AS t ON t.username = c.username
	WHERE c.roleid = 1
	
	select * from #LicenseeCust

	IF @Date > @MaxDate
	BEGIN
		INSERT INTO #tmpRpt (
			Winlostdate
			,CustID
			,Username
			,ProductID
			,Turnover
			,Outstanding
			,Winloss
			,DrawGame
			,PlayerComm
			,BetCount
			,TurnoverNoDraw
			,BetCountNoDraw
			)
		SELECT @Date
			,b.custid
			,c.username
			,bt.ProductId
			,-- undefined productid
			SUM(b.stake) AS Turnover
			,--Turnover  
			SUM(CASE 
					WHEN ruben = 0 THEN actual_stake
					ELSE 0
					END) AS Outstanding  
			,--Outstanding  
			SUM(CASE 
					WHEN ruben = 1 THEN b.winlost - b.actual_stake
					ELSE 0
					END) AS WinLoss
			,--Winloss      
			SUM(CASE 
					WHEN statusID = 111 THEN stake
					ELSE 0
					END) AS DrawGame
			,-- Draw game TO
			SUM(CASE 
					WHEN ruben = 1 THEN b.playercomm
					ELSE 0
					END) AS PlayerComm
			,--Playercomm      
			COUNT(1) AS BetCount
			,--betcount
			SUM(stake * CASE 
					WHEN statusID = 111 THEN 0
					WHEN (
							b.statusID = 112
							OR b.statusID = 113
							)
						AND ABS(modds) = 0.25
						AND b.bettype IN (1, 3, 7, 8, 17, 18)
						AND (
							b.bettype < 31
							OR (
								b.bettype BETWEEN 121
									AND 999
								)
							) THEN 0.5 -- sportsbook rules
					WHEN (
							b.statusID = 112
							OR b.statusID = 113
							)
						AND b.liveawayscore = 0
						AND b.bettype IN (33, 43) THEN 0.5 -- Racing rules
					ELSE 1
					END) AS TurnoverNoDraw
			,-- Turnover No Draw
			SUM(CASE 
					WHEN b.statusID = 111 THEN 0
					ELSE 1
					END) AS BetCountNoDraw
					
		FROM bodb02.dbo.bettrans b WITH (NOLOCK, INDEX (IX_recommend_transid))
			INNER JOIN #LicenseeCust c WITH (NOLOCK) 
			ON b.custid 			= c.custid
			AND b.recommend 	= c.recommend
			INNER JOIN #ProductBettype bt
			ON b.bettype 			= bt.bettype
			
		WHERE b.winlostdate = @date
			AND b.StatusID NOT IN (101, 102, 103, 121, 1)--status not in ('VOID', 'REJECT', 'REFUND','DONE', 'waiting' )
			
		GROUP BY b.custid
			,c.username
			,bt.ProductId
	END
	ELSE IF @Date >= @CutDate
	BEGIN
		INSERT INTO #tmpRpt (
			Winlostdate
			,CustID
			,Username
			,ProductID
			,Turnover
			,Outstanding
			,Winloss
			,DrawGame
			,PlayerComm
			,BetCount
			,TurnoverNoDraw
			,BetCountNoDraw
			)
		SELECT b.winlostdate
			,b.CustID
			,c.username
			,bt.ProductId
			,sum(b.turnover)
			,0 AS Outstanding
			,sum(b.winlost)
			,sum(CASE 
					WHEN statusID = 111 THEN turnover
					ELSE 0
					END)
			,sum(b.playercomm)
			,sum(b.BetCount)
			,SUM(CASE 
					WHEN (
							b.statusID = 112
							OR b.statusID = 113
							) THEN turnover
					WHEN (
							b.statusID = 114
							OR b.statusID = 115
							) THEN turnover / 2
					ELSE 0
					END)
			,SUM(CASE 
					WHEN b.statusID = 111 THEN 0
					ELSE BetCount
					END) -- Betcount No Draw
		FROM bodb_licensee.dbo.rptLicWinloss2 b WITH (NOLOCK)
			INNER JOIN #LicenseeCust c WITH (NOLOCK) 
			ON b.custid 			= c.custid
				AND b.recommend 	= c.recommend
				AND b.srecommend 	= c.srecommend
			INNER JOIN #ProductSporttype bt
			----ON b.Sporttype			= bt.Sporttype
			ON CASE WHEN b.Sporttype = 0 THEN 1 -- Sportbook
					ELSE b.Sporttype 
				END = bt.Sporttype
			
		WHERE b.winlostdate = @Date
			AND b.BetCount 	> 0
			AND b.roleid 	= 1
			AND StatusID NOT IN (101, 102, 103, 121, 1)
		GROUP BY b.winlostdate
			,b.CustID
			,c.username
			,bt.ProductId
	END
	ELSE IF @Date < @CutDate
	BEGIN
		INSERT INTO #tmpRpt (
			Winlostdate
			,CustID
			,Username
			,ProductID
			,Turnover
			,Outstanding
			,Winloss
			,DrawGame
			,PlayerComm
			,BetCount
			,TurnoverNoDraw
			,BetCountNoDraw
			)
		SELECT b.winlostdate
			,b.CustID
			,c.username
			,bt.ProductId
			,SUM(b.turnover)
			,0 AS Outstanding
			,SUM(b.winlost)
			,SUM(CASE 
					WHEN statusID = 111 THEN turnover
					ELSE 0
					END)
			,SUM(b.playercomm)
			,SUM(b.BetCount)
			,SUM(CASE 
					WHEN (
							b.statusID = 112
							OR b.statusID = 113
							) THEN turnover
					WHEN (
							b.statusID = 114
							OR b.statusID = 115
							) THEN turnover / 2
					ELSE 0
					END)
			,SUM(CASE 
					WHEN b.statusID = 111 THEN 0
					ELSE BetCount
					END) -- Betcount No Draw
		FROM bodb_licensee.dbo.rptLicWinloss_old b WITH (NOLOCK)
			INNER JOIN #LicenseeCust c WITH (NOLOCK) 
				ON b.custid 		= c.custid
				AND b.recommend 	= c.recommend
				AND b.srecommend 	= c.srecommend
			INNER JOIN #ProductSporttype bt
			--ON b.Sporttype			= bt.Sporttype
			ON CASE WHEN b.Sporttype = 0 THEN 1 -- Sportbook
					ELSE b.Sporttype 
				END = bt.Sporttype
			
		WHERE b.winlostdate = @Date
			AND b.BetCount 	> 0
			AND b.roleid 	= 1
			AND StatusID NOT IN (101, 102, 103, 121, 1)
			
		GROUP BY b.winlostdate
			,b.CustID
			,c.username
			,bt.ProductId
	END
		
	--Final rersult OUTPUT
	SELECT username
		,winlostdate
		,productid
		,turnover
		,outstanding
		,winloss
		,drawgame
		,betcount
		,playercomm
		,turnovernodraw
		,betcountnodraw
		,progressiveshare
		,progressivewin
	FROM #tmpRpt trans WITH (NOLOCK)
	--for xml auto

	DROP TABLE #TempTrans	
	DROP TABLE #ProductBettype
	DROP TABLE #ProductSporttype
	DROP TABLE #tmpRpt
	DROP TABLE #LicenseeCust
END
GO
