USE bodb02
GO 

/*
Create: 20191219@Sophia
Task: Update Epositiontaking [Redmind: #122071]
DB: DBTXN.bodb02
*/

	DECLARE @Winlostdate SMALLDATETIME = '2019-12-25' 
	 
	
	DECLARE @SportBettype TABLE(ProductID INT, Bettype INT,SubProduct VARCHAR(500))
	INSERT INTO @SportBettype
	SELECT ProductID, Bettype, SubProduct FROM bodb02.dbo.f_SportBettypeMatrix_Sel (0, 0, 0, 2, '', '', 1)

	DELETE @SportBettype WHERE ProductId NOT IN (SELECT DISTINCT ProductID FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting WITH(NOLOCK))
 
 
	DECLARE @i INT = 1 
	 
	----Non sportsbook
	WHILE @i <> 0 
	BEGIN 
		;WITH wl AS (
				SELECT  TOP (1000) b.srecommend , s.ProductID, 0 AS Sporttype, '' AS SubProduct, b.Bettype, b.winlostdate, b.TransID
				FROM bettrans b WITH(NOLOCK)
				INNER JOIN  @SportBettype s
					ON s.BetType = b.bettype
				WHERE b.winlostdate >=  @Winlostdate
					AND s.ProductID <> 1  				
					AND b.bettype < 19001
					AND epositiontaking IS NULL 
				)
		,   ept AS (
					SELECT s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
					FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting s WITH (NOLOCK)
					WHERE @Winlostdate BETWEEN s.FromDate AND s.ToDate	 
						  AND s.ProductID <> 1
					GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype 
					)
		UPDATE B
		SET epositiontaking = E.ExtraPT
		FROM Bettrans B WITH (ROWLOCK)
		INNER JOIN  (
								SELECT w.ProductID, w.Sporttype, w.SubProduct, s.ExtraPT as ExtraPT ,  w.TransID as  TransID 
								FROM wl w
								INNER JOIN ept s WITH (NOLOCK)
										ON w.srecommend = s.SuperId
										AND w.ProductId = s.ProductId
										AND w.SubProduct = s.SubProduct
										AND w.Sporttype = s.Sporttype  
								) E ON E.TransID = B.TransID 
		SELECT @i = @@ROWCOUNT
		WAIT FOR DELAY ''
	END




	----- SportBook 
	SELECT @i = 1

	WHILE @i <> 0 
	BEGIN  	
		;WITH wl AS (
				SELECT	TOP (1000) b.srecommend, 1 AS ProductID, 
						CASE WHEN ISNULL(m.matchid, 0) <> 0 THEN m.Sporttype ELSE 0 END AS Sporttype, 
						CASE WHEN s.SubProduct IN ('MG-SuperLive', 'BT-Sold','BT-Bought','BT-Comm','BT-Winloss','Bet Builder') THEN s.SubProduct ELSE '' END AS SubProduct,					
						b.winlostdate, b.TransID  
				FROM bettrans b WITH (NOLOCK)
				INNER JOIN  @SportBettype s
					ON s.BetType = b.bettype
				LEFT JOIN bodb02.dbo.match m WITH(NOLOCK)
					ON m.matchid = b.matchid AND m.eventdate = b.winlostdate AND m.sporttype = 44 -- MuayThai
				WHERE  b.winlostdate >=  @Winlostdate			
					AND b.bettype < 19001
					AND s.productID = 1 
					AND epositiontaking IS NULL 
				 
				)
			,   ept AS (
					SELECT s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
					FROM DBCUST.CUSTDB.dbo.Acc_GroupExtraPTSetting s WITH (NOLOCK)
					WHERE @Winlostdate BETWEEN s.FromDate AND s.ToDate	 
						  AND s.ProductID = 1
					GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype
					)		 
		UPDATE B
		SET epositiontaking = E.ExtraPT
		FROM Bettrans B WITH (ROWLOCK)
		INNER JOIN  (
								SELECT w.ProductID, w.Sporttype, w.SubProduct, s.ExtraPT  as ExtraPT, w.TransID as  TransID 
								FROM wl w
								INNER JOIN ept s WITH (NOLOCK)
										ON w.srecommend = s.SuperId
										AND w.ProductId = s.ProductId
										AND w.SubProduct = s.SubProduct
										AND w.Sporttype = s.Sporttype  
								) E ON E.TransID = B.TransID 

		SELECT @i = @@ROWCOUNT
	END


