USE bodb02
GO 

/*
Create: 20191219@Sophia
Task: Update Epositiontaking [Redmind: #122071]
DB: DBTXN.bodb02
*/

	DECLARE @Winlostdate SMALLDATETIME 

	CREATE TABLE #Date (ID INT IDENTITY (1,1), Winlostdate SMALLDATETIME)

	DECLARE @MoveBetsDay SMALLDATETIME 
	SELECT 	@MoveBetsDay = max(eventdate) 
	FROM    match14 WITH(NOLOCK)
 

	INSERT INTO #Date(Winlostdate)	
	SELECT DISTINCT WINLOSTDATE
	FROM Bettrans WITH (NOLOCK) 
	WHERE ISNULL(epositiontaking ,0) = 0
	AND Winlostdate > @MoveBetsDay
	AND bettype < 19001  

	 
	
	DECLARE @SportBettype TABLE(ProductID INT, Bettype INT,SubProduct VARCHAR(500), RefTable SMALLINT)
	INSERT INTO @SportBettype
	SELECT DISTINCT ProductID, Bettype, SubProduct, RefTable  FROM bodb02.dbo.f_SportBettypeMatrix_Sel (0, 0, 0, 2, '', '', 1)

	DELETE @SportBettype WHERE ProductId NOT IN (SELECT DISTINCT ProductID FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting WITH(NOLOCK))
 
	CREATE TABLE  #T (epositiontaking MONEY , ExtraPT MONEY, transID BIGINT, Reftable Smallint)
 
	DECLARE @RowId INT = 1, @i INT  =1, @MaxRowID INT 

	SELECT @MaxRowID = MAX(ID) FROM #Date

	WHILE @RowId < @MaxRowID
	BEGIN 

		SELECT @Winlostdate = Winlostdate
		FROM #Date 
		WHERE ID = @RowId
	 
		---------------------------------Select data -------------------------
		----Non sportsbook	
		BEGIN 
			;WITH wl AS (
					SELECT   b.srecommend , s.ProductID, 0 AS Sporttype, '' AS SubProduct, b.Bettype, b.winlostdate, b.TransID, b.EPositiontaking
					FROM bettrans b WITH(NOLOCK)
					INNER JOIN  @SportBettype s
						ON s.BetType = b.bettype
					WHERE b.winlostdate =  @Winlostdate
						AND s.ProductID <> 1  				
						AND b.bettype < 19001
						AND ISNULL(epositiontaking,0) = 0 
					
					)
			,   ept AS (
						SELECT s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
						FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting s WITH (NOLOCK)
						WHERE @winlostdate BETWEEN s.FromDate AND s.ToDate	 
							  AND s.ProductID <> 1
						GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype 
						)		

			INSERT INTO #T
			SELECT epositiontaking, s.ExtraPT, TransID, 0
			FROM wl w
			INNER JOIN ept s WITH (NOLOCK)
					ON w.srecommend = s.SuperId
					AND w.ProductId = s.ProductId
					AND w.SubProduct = s.SubProduct
					AND w.Sporttype = s.Sporttype  
			WHERE EPositiontaking <> ExtraPT	
		
		END


		----- SportBook 
		BEGIN  	
			;WITH wl AS (
					SELECT	b.srecommend, 1 AS ProductID, 
							CASE WHEN ISNULL(m.matchid, 0) <> 0 THEN m.Sporttype ELSE 0 END AS Sporttype, 
							CASE WHEN s.SubProduct IN ('MG-SuperLive', 'BT-Sold','BT-Bought','BT-Comm','BT-Winloss','Bet Builder') THEN s.SubProduct ELSE '' END AS SubProduct,					
							b.winlostdate, b.TransID  , b.epositiontaking
					FROM bettrans b WITH (NOLOCK)
					INNER JOIN  @SportBettype s
						ON s.BetType = b.bettype
					LEFT JOIN bodb02.dbo.match m WITH(NOLOCK)
						ON m.matchid = b.matchid AND m.eventdate = b.winlostdate AND m.sporttype = 44 -- MuayThai
					WHERE  b.winlostdate =  @Winlostdate			
						AND b.bettype < 19001
						AND s.productID = 1 
						AND ISNULL(epositiontaking,0) = 0 
									 
					)
				,   ept AS (
						SELECT s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
						FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting s WITH (NOLOCK)
						WHERE @Winlostdate BETWEEN s.FromDate AND s.ToDate	 
							  AND s.ProductID = 1
						GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype
						)		 
							   
			INSERT INTO #T
			SELECT epositiontaking, s.ExtraPT, TransID, 0
			FROM wl w
			INNER JOIN ept s WITH (NOLOCK)
					ON w.srecommend = s.SuperId
					AND w.ProductId = s.ProductId
					AND w.SubProduct = s.SubProduct
					AND w.Sporttype = s.Sporttype  
			WHERE EPositiontaking <> ExtraPT
		END


		----- translog 

		BEGIN 
			;WITH wl AS (
					SELECT   b.srecommend , s.ProductID, 0 AS Sporttype, '' AS SubProduct, b.gameID, b.winlostdate, b.translogid, b.epositiontaking
					FROM translog b WITH(NOLOCK)
					INNER JOIN  @SportBettype s
						ON b.gameID = s.bettype
					WHERE b.winlostdate =  @Winlostdate
						AND s.ProductID <> 1  									
						AND ISNULL(epositiontaking,0) = 0 
						AND s.RefTable = 3
					
					)
			,   ept AS (
						SELECT s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
						FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting s WITH (NOLOCK)
						WHERE @Winlostdate BETWEEN s.FromDate AND s.ToDate	 
							  AND s.ProductID <> 1
						GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype 
						)

			INSERT INTO #T
			SELECT epositiontaking, s.ExtraPT, translogid  as translogid ,3 as Reftable
			FROM wl w
			INNER JOIN ept s WITH (NOLOCK)
					ON w.srecommend = s.SuperId
					AND w.ProductId = s.ProductId
					AND w.SubProduct = s.SubProduct
					AND w.Sporttype = s.Sporttype  
			WHERE EPositiontaking <> ExtraPT
		
		END


	----- BettransRNG 

		BEGIN 
			;WITH wl AS (
					SELECT   b.srecommend , s.ProductID, 0 AS Sporttype, '' AS SubProduct, b.gameID, b.winlostdate, b.TransID, epositiontaking
					FROM BettransRNG b WITH(NOLOCK)
					INNER JOIN  @SportBettype s
						ON b.gameID = s.bettype
					WHERE b.winlostdate =  @Winlostdate
						AND s.ProductID <> 1  									
						AND ISNULL(epositiontaking,0) = 0 
						AND s.RefTable = 1
					
					)
			,   ept AS (
						SELECT s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
						FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting s WITH (NOLOCK)
						WHERE @Winlostdate BETWEEN s.FromDate AND s.ToDate	 
							  AND s.ProductID <> 1
						GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype 
						)
			INSERT INTO #T
			SELECT epositiontaking, s.ExtraPT, TransID  as translogid ,1 as Reftable
			FROM wl w
			INNER JOIN ept s WITH (NOLOCK)
					ON w.srecommend = s.SuperId
					AND w.ProductId = s.ProductId
					AND w.SubProduct = s.SubProduct
					AND w.Sporttype = s.Sporttype  
			WHERE EPositiontaking <> ExtraPT
				
		END
	
	
	----- BettransLC


		BEGIN 
			;WITH wl AS (
					SELECT  b.srecommend , s.ProductID, 0 AS Sporttype, '' AS SubProduct, b.gameID, b.winlostdate, b.TransID, epositiontaking
					FROM BettransLC b WITH(NOLOCK)
					INNER JOIN  @SportBettype s
						ON b.gameID = s.bettype
					WHERE b.winlostdate =  @Winlostdate
						AND s.ProductID <> 1  									
						AND ISNULL(epositiontaking,0) = 0 
						AND s.RefTable = 2
					
					)
			,   ept AS (
						SELECT s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
						FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting s WITH (NOLOCK)
						WHERE @Winlostdate BETWEEN s.FromDate AND s.ToDate	 
							  AND s.ProductID <> 1
						GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype 
						)
			INSERT INTO #T
			SELECT epositiontaking, s.ExtraPT, TransID  as translogid ,2 as Reftable
			FROM wl w
			INNER JOIN ept s WITH (NOLOCK)
					ON w.srecommend = s.SuperId
					AND w.ProductId = s.ProductId
					AND w.SubProduct = s.SubProduct
					AND w.Sporttype = s.Sporttype  
			WHERE EPositiontaking <> ExtraPT

		 
		END

		--------------------------------Update table --------------------

		SELECT @i = 1 
	 
		----Bettrans
		WHILE @i <> 0 
		BEGIN  
			UPDATE TOP (1000) B
			SET B.epositiontaking = E.ExtraPT
			FROM Bettrans B WITH (ROWLOCK)
			INNER JOIN #T E ON E.TransID = B.TransID
			WHERE B.epositiontaking <> E.ExtraPT
			AND E.Reftable = 0 
		
			SELECT @i = @@ROWCOUNT
			WAITFOR DELAY '00:00:03'
		END 

		
	 
		--- translog
		SELECT @i = 1 

		WHILE @i <> 0 
		BEGIN  
			UPDATE TOP (1000) B
			SET B.epositiontaking = E.ExtraPT
			FROM Translog B WITH (ROWLOCK)
			INNER JOIN #T E ON E.TransID = B.translogid
			WHERE B.epositiontaking <> E.ExtraPT
			AND E.Reftable = 3 
		
			SELECT @i = @@ROWCOUNT
			WAITFOR DELAY '00:00:03'
		END 


		--- bettransRNG
		SELECT @i = 1 

		WHILE @i <> 0 
		BEGIN  
			UPDATE TOP (1000) B
			SET B.epositiontaking = E.ExtraPT
			FROM bettransRNG B WITH (ROWLOCK)
			INNER JOIN #T E ON E.TransID = B.TransID
			WHERE B.epositiontaking <> E.ExtraPT
			AND E.Reftable = 1 
		
			SELECT @i = @@ROWCOUNT
			WAITFOR DELAY '00:00:03'
		END 

	
		--- bettransLC
		SELECT @i = 1 

		WHILE @i <> 0 
		BEGIN  
			UPDATE TOP (1000) B
			SET B.epositiontaking = E.ExtraPT
			FROM bettransLC B WITH (ROWLOCK)
			INNER JOIN #T E ON E.TransID = B.TransID
			WHERE B.epositiontaking <> E.ExtraPT
			AND E.Reftable = 1 
		
			SELECT @i = @@ROWCOUNT
			WAITFOR DELAY '00:00:03'
		END 

	TRUNCATE TABLE #T

	SELECT @RowId = @RowId + 1 
	END 
	
	DROP TABLE #DATE
	