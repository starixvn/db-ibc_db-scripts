/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
Create: 20221222@Sophia
Task: Joker - Re-generate data due to data patch update epositiontaking [Redmine: #166443] 
DB: DBSUM.bodb_Summary

*/ 
 
 
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
			,TunroverNoDraw		MONEY
			,ExtraWinloss		MONEY
			,ExtraComm 			MONEY
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
			,TunroverNoDraw,
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
			,grosscomm
			,sporttype
			,bettype
			,netTurnover
			,TunroverNoDraw
			,ExtraWinloss		
			,ExtraComm 		
		FROM DBARC.bodb_Archive.dbo.Sum_Winloss_Old_Tmp WITH (NOLOCK) 

	
	------------------------------------------------------------
	DECLARE @WinlostDate SMALLDATETIME

	SELECT DISTINCT WinlostDate INTO #Date from #tmpSum_winloss ORDER BY WinlostDate 
	
	SELECT TOP 1 @WinlostDate = WinlostDate FROM #Date

	WHILE EXISTS (SELECT 1 FROM #Date )
	BEGIN 

		UPDATE s  
		SET 	 s.ExtraWinloss = t.ExtraWinloss
				,s.ExtraComm = t.ExtraComm
		FROM 	dbo.Sum_Winloss_Old s WITH (ROWLOCK)
		INNER JOIN #tmpSum_winloss t
				ON t.winlostdate = s.winlostdate
				AND t.CustID = s.CustID
				AND t.roleid = s.RoleID		
				AND t.sporttype = s.sporttype
				AND t.bettype = s.bettype				
		WHERE s.WinlostDate = @winlostdate	
				AND s.sporttype IN (234) 
				AND (s.ExtraWinloss <> t.ExtraWinloss OR s.ExtraComm <> t.ExtraComm)
				
					   		
		DELETE #Date WHERE WinlostDate = @WinlostDate

		SELECT TOP 1 @WinlostDate = WinlostDate FROM #Date

	END 
	-- End Regen data 
	DROP TABLE #tmpSum_winloss
	DROP TABLE #Date
 
 END 