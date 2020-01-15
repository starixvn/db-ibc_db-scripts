USE [bodb_Consistency]
GO
 
CREATE PROCEDURE [dbo].[DBA_Consistency_ExtraPTChecking]	
	@Winlostdate	SMALLDATETIME	= NULL
	,@tablename		VARCHAR(50)		= NULL
	,@ErrCode		INT				= 0		OUTPUT
	,@ErrMsg		VARCHAR(MAX)	= ''	OUTPUT 
	,@SampleData	VARCHAR(MAX)	= ''	OUTPUT
AS
BEGIN 
	DECLARE @transId VARCHAR(MAX) = ''

	IF @Winlostdate = NULL 	
		SELECT @Winlostdate  =  CONVERT (DATE, GETDATE()) 
	
	CREATE TABLE #Acc_GroupExtraPTSetting (
									[SuperId] [int] NOT NULL,
									[GroupId] [int] NOT NULL,
									[GroupName] [varchar](50) NOT NULL,
									[ProductId] [tinyint] NOT NULL,
									[Sporttype] [smallint] NOT NULL,
									[SubProduct] [varchar](500) NOT NULL,
									[ExtraPT] [decimal](9, 8) NOT NULL,
									[FromDate] [datetime] NOT NULL,
									[ToDate] [datetime] NOT NULL,
									[UplineId] [int] NULL
										)
	INSERT INTO #Acc_GroupExtraPTSetting (SuperId,
										GroupId,
										GroupName,
										ProductId,
										Sporttype,
										SubProduct,
										ExtraPT,
										FromDate,
										ToDate,
										UplineId)
	SELECT 								SuperId,
										GroupId,
										GroupName,
										ProductId,
										Sporttype,
										SubProduct,
										ExtraPT,
										FromDate,
										ToDate,
										UplineId
	FROM bodb02.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)
	
	ALTER TABLE [dbo].[#Acc_GroupExtraPTSetting]
	ADD  CONSTRAINT [PK_Acc_GroupExtraPTSetting_New] PRIMARY KEY CLUSTERED 
	(
		[SuperId] ASC,
		[ProductId] ASC,
		[Sporttype] ASC,
		[SubProduct] ASC,
		[ToDate] ASC,
		[GroupId] ASC
	) 
	
	
	CREATE TABLE  #SportBettype (ProductID INT, Bettype INT,SubProduct VARCHAR(500), RefTable SMALLINT)
	INSERT INTO #SportBettype
	SELECT DISTINCT ProductID, Bettype, SubProduct, RefTable  FROM bodb02.dbo.f_SportBettypeMatrix_Sel (0, 0, 0, 2, '', '', 1)

	DELETE #SportBettype WHERE ProductId NOT IN (SELECT DISTINCT ProductID FROM #Acc_GroupExtraPTSetting WITH(NOLOCK))	
	
 
	CREATE TABLE  #T (epositiontaking smallmoney , ExtraPT [decimal](9, 8), transID BIGINT, Reftable Smallint, RuleID Smallint)
 
	DECLARE @i INT = 1 
	 
		---------------------------------Select data -------------------------
		----- SportBook & non sport in bettrans table
		IF @tablename = 'bettrans' OR @tablename = NULL
		BEGIN  	
			;WITH wl AS (
					SELECT	b.srecommend, 1 AS ProductID, 
							CASE WHEN ISNULL(m.matchid, 0) <> 0 THEN m.Sporttype ELSE 0 END AS Sporttype, 
							CASE WHEN s.SubProduct IN ('MG-SuperLive', 'BT-Sold','BT-Bought','BT-Comm','BT-Winloss','Bet Builder') THEN s.SubProduct ELSE '' END AS SubProduct,	
							CAST(b.TransDate AS DATE) as TransDate, 
							b.winlostdate, b.TransID, b.epositiontaking, b.tpositiontaking
					FROM bodb02.dbo.bettrans b WITH (NOLOCK)
					INNER JOIN  #SportBettype s
						ON s.BetType = b.bettype
					LEFT JOIN bodb02.dbo.match m WITH(NOLOCK)
						ON m.matchid = b.matchid AND m.eventdate = b.winlostdate AND m.sporttype = 44 -- MuayThai
					WHERE  b.winlostdate = @Winlostdate			
						AND b.bettype < 19001						 
					)	   
					
			INSERT INTO #T (epositiontaking, ExtraPT, TransID, Reftable, RuleID)		
			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 0 as RefTable, 1 as RuleID  
			FROM wl w
			WHERE w.Epositiontaking IS NULL
			
			UNION ALL			
			SELECT epositiontaking,  SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 0 as Reftable, 2 AS RuleID
			FROM wl w
			LEFT JOIN  (
						SELECT s.SuperId, s.Fromdate, s.Todate, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
						FROM #Acc_GroupExtraPTSetting s WITH (NOLOCK)			
						GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, s.Fromdate, s.Todate
						) s
					ON	w.TransDate BETWEEN s.FromDate AND s.ToDate	
							AND w.srecommend = s.SuperId
							AND w.ProductId = s.ProductId
							AND w.SubProduct = s.SubProduct
							AND w.Sporttype = s.Sporttype 
			GROUP BY epositiontaking, TransID
			HAVING w.Epositiontaking <> SUM(ISNULL(s.ExtraPT,0))	
						
			UNION ALL			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 0 as RefTable, 3 as RuleID
			FROM wl w
			WHERE  EXISTS (SELECT 1 FROM bodb02.dbo.f_GetHeadlineNoPT() f WHERE f.SuperID = w.Srecommend)
				  AND w.Epositiontaking <> 0
			
			UNION ALL 			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 0 as RefTable, 4 as RuleID
			FROM wl w
			WHERE EXISTS (SELECT 1 FROM bodb02.dbo.f_GetHeadlineNoPT() f WHERE f.SuperID = w.Srecommend)
				  AND w.tpositiontaking <> 0.92
				  
			
			-----------RuleID = 1
				  
			SELECT @transId = ''
			SELECT TOP (10) @transId = @transId + ',' + CAST(transId AS VARCHAR)
			FROM   #T 
			WHERE  Reftable = 0 AND RuleID = 1 	
			
			IF @transId <> ''
			BEGIN
				SELECT	@transId = SUBSTRING(@transId, 2, LEN(@transId) - 1)
						,@ErrCode = 101
						,@ErrMsg = 'Epositiontaking IS NULL' 
						,@SampleData = @tablename + '.TransId in (' + @transId + ')'
			END
			
			-----------RuleID = 2
			SELECT @transId = ''
			SELECT TOP (10) @transId = @transId + ',' + CAST(transId AS VARCHAR)
			FROM   #T 
			WHERE  Reftable = 0 AND RuleID = 2	
			
			IF @transId <> ''
			BEGIN
				SELECT	@transId = SUBSTRING(@transId, 2, LEN(@transId) - 1)
						,@ErrCode = 102
						,@ErrMsg = 'Wrong Epositiontaking vs ExtraPT' 
						,@SampleData = @tablename + '.TransId in (' + @transId + ')'
			END
			
			-----------RuleID = 3
			SELECT @transId = ''
			SELECT TOP (10) @transId = @transId + ',' + CAST(transId AS VARCHAR)
			FROM   #T 
			WHERE  Reftable = 0 AND RuleID = 3
			
			IF @transId <> ''
			BEGIN
				SELECT	@transId = SUBSTRING(@transId, 2, LEN(@transId) - 1)
						,@ErrCode = 103
						,@ErrMsg = 'Epositiontaking has value under headline XP%' 
						,@SampleData = @tablename + '.TransId in (' + @transId + ')'
			END
	
			-----------RuleID = 4
			SELECT @transId = ''
			SELECT TOP (10) @transId = @transId + ',' + CAST(transId AS VARCHAR)
			FROM   #T 
			WHERE  Reftable = 0 AND RuleID = 4
			
			IF @transId <> ''
			BEGIN
				SELECT	@transId = SUBSTRING(@transId, 2, LEN(@transId) - 1)
						,@ErrCode = 104
						,@ErrMsg = 'TPositiontaking <> 92% under headline XP%' 
						,@SampleData = @tablename + '.TransId in (' + @transId + ')'
			END
				  
		END


		----- translog 
		IF @tablename = 'translog' OR @tablename = NULL
		BEGIN 
			;WITH wl AS (
					SELECT  b.srecommend, s.ProductID, 0 AS Sporttype, '' AS SubProduct, b.gameID, 
							CAST(b.TransDate AS DATE) as TransDate, b.winlostdate, b.translogid, b.epositiontaking, b.tpositiontaking
					FROM bodb02.dbo.translog b WITH(NOLOCK)
					INNER JOIN  #SportBettype s
						ON b.gameID = s.bettype
					WHERE b.winlostdate =  @Winlostdate		
						AND s.RefTable = 3					
					)			

			INSERT INTO #T (epositiontaking, ExtraPT, TransID, Reftable, RuleID)
			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, translogid, 3 as RefTable, 1 as RuleID  
			FROM wl w
			WHERE w.Epositiontaking IS NULL
			
			UNION ALL 			
			SELECT epositiontaking,  SUM(ISNULL(s.ExtraPT,0)) as ExtraPT , translogid , 3 as Reftable, 2 as RuleID
			FROM wl w
			LEFT JOIN (SELECT s.SuperId,  s.Fromdate, s.Todate, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
						FROM #Acc_GroupExtraPTSetting s WITH (NOLOCK)
						WHERE s.ProductID <> 1
						GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, s.Fromdate, s.Todate
						) s
					ON	w.TransDate BETWEEN s.FromDate AND s.ToDate	
							AND w.srecommend = s.SuperId
							AND w.ProductId = s.ProductId
							AND w.SubProduct = s.SubProduct
							AND w.Sporttype = s.Sporttype 
			GROUP BY epositiontaking, translogid
			HAVING w.Epositiontaking <> SUM(ISNULL(s.ExtraPT,0)) 			
						
			UNION ALL			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, translogid, 3 as RefTable, 3 as RuleID
			FROM wl w
			WHERE  EXISTS (SELECT 1 FROM bodb02.dbo.f_GetHeadlineNoPT() f WHERE f.SuperID = w.Srecommend)
				  AND w.Epositiontaking <> 0
			
			UNION ALL 			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, translogid, 3 as RefTable, 4 as RuleID
			FROM wl w
			WHERE EXISTS (SELECT 1 FROM bodb02.dbo.f_GetHeadlineNoPT() f WHERE f.SuperID = w.Srecommend)
				  AND w.tpositiontaking <> 0.92
				  
		
		END


	----- BettransRNG 
		IF @tablename = 'BettransRNG' OR @tablename = NULL
		BEGIN 
			;WITH wl AS (
					SELECT  b.srecommend, s.ProductID, 0 AS Sporttype, '' AS SubProduct, b.gameID, CAST(b.TransDate AS DATE) as TransDate, b.winlostdate, b.TransID, epositiontaking
					FROM bodb02.dbo.BettransRNG b WITH(NOLOCK)
					INNER JOIN  #SportBettype s
						ON b.gameID = s.bettype
					WHERE b.winlostdate =  @Winlostdate
						AND s.ProductID <> 1  					
						AND s.RefTable = 1					
					)
			INSERT INTO #T (epositiontaking, ExtraPT, TransID, Reftable, RuleID)
			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 1 as RefTable, 1 as RuleID  
			FROM wl w
			WHERE w.Epositiontaking IS NULL
			
			UNION ALL			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID , 1 as Reftable, 2 as RuleID  
			FROM wl w
			LEFT JOIN (SELECT s.SuperId, s.Fromdate, s.Todate, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
						FROM #Acc_GroupExtraPTSetting s WITH (NOLOCK)
						WHERE s.ProductID <> 1
						GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, s.Fromdate, s.Todate 
					  ) s
					ON	w.TransDate BETWEEN s.FromDate AND s.ToDate	
							AND w.srecommend = s.SuperId
							AND w.ProductId = s.ProductId
							AND w.SubProduct = s.SubProduct
							AND w.Sporttype = s.Sporttype 
			GROUP BY epositiontaking, TransID
			HAVING w.Epositiontaking <> SUM(ISNULL(s.ExtraPT,0))
			
			UNION ALL			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 1 as RefTable, 3 as RuleID
			FROM wl w
			WHERE  EXISTS (SELECT 1 FROM bodb02.dbo.f_GetHeadlineNoPT() f WHERE f.SuperID = w.Srecommend)
				  AND w.Epositiontaking <> 0
			
			UNION ALL 			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 1 as RefTable, 4 as RuleID
			FROM wl w
			WHERE EXISTS (SELECT 1 FROM bodb02.dbo.f_GetHeadlineNoPT() f WHERE f.SuperID = w.Srecommend)
				  AND w.tpositiontaking <> 0.92
				  
		END
	
	
	----- BettransLC
		IF @tablename = 'BettransLC' OR @tablename = NULL
		BEGIN 
			;WITH wl AS (
					SELECT  b.srecommend , s.ProductID, 0 AS Sporttype, '' AS SubProduct, b.gameID, CAST(b.TransDate AS DATE) as TransDate, b.winlostdate, b.TransID, epositiontaking
					FROM bodb02.dbo.BettransLC b WITH(NOLOCK)
					INNER JOIN  #SportBettype s
						ON b.gameID = s.bettype
					WHERE b.winlostdate =  @Winlostdate
						AND s.ProductID <> 1  				
						AND s.RefTable = 2					
					)
			INSERT INTO #T (epositiontaking, ExtraPT, TransID, Reftable, RuleID)
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 2 as RefTable, 1 as RuleID  
			FROM wl w
			WHERE w.Epositiontaking IS NULL
			
			UNION ALL			
			SELECT epositiontaking,  SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 2 as Reftable, 2 as RuleID  
			FROM wl w
			LEFT JOIN 	(SELECT s.SuperId, s.Fromdate, s.Todate, s.ProductId, s.SubProduct, s.Sporttype, SUM (s.ExtraPT) AS ExtraPT
						FROM #Acc_GroupExtraPTSetting s WITH (NOLOCK)
						WHERE  s.ProductID <> 1
						GROUP BY s.SuperId, s.ProductId, s.SubProduct, s.Sporttype, s.Fromdate, s.Todate 
						) s 
					ON	w.TransDate BETWEEN s.FromDate AND s.ToDate	
							AND w.srecommend = s.SuperId
							AND w.ProductId = s.ProductId
							AND w.SubProduct = s.SubProduct
							AND w.Sporttype = s.Sporttype 
			GROUP BY epositiontaking, TransID
			HAVING w.Epositiontaking <> SUM(ISNULL(s.ExtraPT,0)) 
			
			UNION ALL			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 2 as RefTable, 3 as RuleID
			FROM wl w
			WHERE  EXISTS (SELECT 1 FROM bodb02.dbo.f_GetHeadlineNoPT() f WHERE f.SuperID = w.Srecommend)
				  AND w.Epositiontaking <> 0
			
			UNION ALL 			
			SELECT epositiontaking, SUM(ISNULL(s.ExtraPT,0)) as ExtraPT, TransID, 2 as RefTable, 4 as RuleID
			FROM wl w
			WHERE EXISTS (SELECT 1 FROM bodb02.dbo.f_GetHeadlineNoPT() f WHERE f.SuperID = w.Srecommend)
				  AND w.tpositiontaking <> 0.92
		 
		END		
		
	
	
	
 		
--- Bettrans 		
	Select b.epositiontaking ,t.ExtraPT, b.bettype,  * from Bettrans b INNER JOIn #T T  ON T.TransID = b.TransID  WHERE b.epositiontaking <> t.ExtraPT  AND B.bettype IN (Select BEttype from #SportBettype where Reftable = 0  )


--- BettransRNG 
	Select b.epositiontaking  ,t.ExtraPT,b.gameID,   * from BettransRNG b INNER JOIn #T T  ON T.TransID = b.TransID WHERE b.epositiontaking <> t.ExtraPT  AND B.gameID IN (Select BEttype from #SportBettype where Reftable = 1  )

	
---BettransLC
	Select b.epositiontaking , t.ExtraPT, b.gameID,  * from BettransLC b INNER JOIn #T T  ON T.TransID = b.TransID WHERE b.epositiontaking <> t.ExtraPT	  AND B.gameID IN (Select BEttype from #SportBettype where Reftable = 2 )
	 	
---TransLog
	Select b.epositiontaking , t.ExtraPT,b.gameID,   * from TransLog b INNER JOIn #T T  ON T.TransID = b.translogid WHERE b.epositiontaking <> t.ExtraPT   AND B.gameID IN (Select BEttype from #SportBettype where Reftable = 3  )

	DROP TABLE #Acc_GroupExtraPTSetting 	
END 
GO 