USE bodb_report
GO 

/*
Create : 20190524@Sophia
Task: regen data OpeningTotalBalance for rptStatement_OLD, rptStatement [redmine: #109293]
DB: DBRPT.bodb_report
*/

	
	DECLARE @WinlostDate DATE = '2019-03-30', @BalanceUpDay DATE, @MoveBetsday DATE

	DECLARE @Date AS TABLE (BalanceUpDay DATE, MoveBetsday DATE)
	INSERT INTO @Date 
	EXEC bodb02.dbo.Age_SelBalanceUpDay 

	SELECT @BalanceUpDay = BalanceUpDay, @MoveBetsday = MoveBetsday
	FROM @Date


---- 1. Gen rptStatement_old

	WHILE @WinlostDate < @BalanceUpDay
	BEGIN 		
			IF OBJECT_ID('tempdb..#tmpOpeningTotalBalance') IS NOT NULL
			BEGIN
				DROP TABLE #tmpOpeningTotalBalance
			END

			CREATE TABLE #tmpOpeningTotalBalance (
				Custid INT
				,OpeningBalance MONEY
				,OpeningTotalBalance MONEY
				)


			------------Calc OpeningTotalBalance----------
			--- Member
			INSERT INTO #tmpOpeningTotalBalance (CustID, OpeningBalance, OpeningTotalBalance)
			SELECT	s.CustID, s.OpeningBalance,	s.OpeningBalance
			FROM 	dbo.rptStatement_old s WITH (NOLOCK)
			INNER JOIN bodb02.dbo.CustInfo c WITH (NOLOCK) 
					ON c.CustID = s.CustID
			WHERE   s.WinlostDate = @WinlostDate 
					AND c.RoleID = 1
			
			--- Agent	
			INSERT INTO #tmpOpeningTotalBalance (CustID, OpeningBalance, OpeningTotalBalance)	
			SELECT  s.CustID, s.OpeningBalance, s.OpeningBalance + d.DownlineCash 
			FROM 	dbo.rptStatement_old s WITH (NOLOCK)
				INNER JOIN ( 
							SELECT	c.recommend, SUM (s.OpeningTotalBalance) as DownlineCash
							FROM 	#tmpOpeningTotalBalance s WITH (NOLOCK)
							INNER JOIN bodb02.dbo.CustInfo c WITH (NOLOCK) 
									ON c.CustID = s.CustID
							WHERE c.RoleID = 1
							GROUP BY c.recommend
							) d
				ON s.CustID = d.recommend
			WHERE   s.WinlostDate = @WinlostDate
	
			-- Master		 
			INSERT INTO #tmpOpeningTotalBalance (CustID, OpeningBalance, OpeningTotalBalance)	
			SELECT  s.CustID, s.OpeningBalance, s.OpeningBalance + d.DownlineCash
			FROM 	dbo.rptStatement_old s WITH (NOLOCK)
				INNER JOIN ( 
							SELECT	c.mrecommend, SUM (s.OpeningTotalBalance) as DownlineCash
							FROM 	#tmpOpeningTotalBalance s WITH (NOLOCK)
							INNER JOIN bodb02.dbo.CustInfo c WITH (NOLOCK) 
									ON c.CustID = s.CustID
							WHERE c.RoleID = 2
							GROUP BY c.mrecommend
							) d
				ON s.CustID = d.mrecommend
			WHERE   s.WinlostDate = @WinlostDate
			
			-- Super		 
			INSERT INTO #tmpOpeningTotalBalance (CustID, OpeningBalance, OpeningTotalBalance)	
			SELECT  s.CustID, s.OpeningBalance, s.OpeningBalance + d.DownlineCash
			FROM 	dbo.rptStatement_old s WITH (NOLOCK)
				INNER JOIN ( 
							SELECT	c.srecommend, SUM (s.OpeningTotalBalance) as DownlineCash
							FROM 	#tmpOpeningTotalBalance s WITH (NOLOCK)
							INNER JOIN bodb02.dbo.CustInfo c WITH (NOLOCK) 
									ON c.CustID = s.CustID
							WHERE c.RoleID = 3
							GROUP BY c.srecommend
							) d
				ON s.CustID = d.srecommend
			WHERE   s.WinlostDate = @WinlostDate
		
			---------------- Correct Opening Total Balance --------------------
			IF EXISTS (
				SELECT 1
				FROM #tmpOpeningTotalBalance SOURCE
					FULL OUTER JOIN dbo.rptStatement_OLD TARGET WITH (NOLOCK) 
						ON SOURCE.CustId = TARGET.CustId 
						and TARGET.WinlostDate = @WinlostDate 
				WHERE	
						TARGET.WinlostDate = @WinlostDate 
						AND (SOURCE.CustId IS NULL
						OR TARGET.CustId IS NULL				
						OR TARGET.OpeningBalance 	  <> SOURCE.OpeningBalance				
						OR TARGET.OpeningTotalBalance <> SOURCE.OpeningTotalBalance	)	
			)
				BEGIN
 
  
				BEGIN
					MERGE dbo.rptStatement_OLD AS TARGET
					USING #tmpOpeningTotalBalance AS SOURCE
							ON	TARGET.CustId		= SOURCE.CustId 
							AND TARGET.WinlostDate	= @WinlostDate					
					WHEN MATCHED THEN
					UPDATE SET
						TARGET.OpeningTotalBalance = SOURCE.OpeningTotalBalance	
					;
				END
			END

		PRINT 'Done ' + CONVERT(VARCHAR(10),@winlostdate) 
		
		SELECT @WinlostDate  =  DATEADD(DD, 1 , @WinlostDate)
	 END 


---2. Gen for rptStatement 
	SELECT @winlostdate = @BalanceUpDay

	WHILE @winlostdate <= @MoveBetsday
	BEGIN 
		
		EXEC Task_DailyRptStatement_CheckData @winlostdate = @winlostdate, @isCheckDataOnly = 0  
		
		PRINT 'Done ' + CONVERT(VARCHAR(10),@winlostdate) 		
		SELECT @WinlostDate  =  DATEADD(DD, 1 , @WinlostDate)
	END