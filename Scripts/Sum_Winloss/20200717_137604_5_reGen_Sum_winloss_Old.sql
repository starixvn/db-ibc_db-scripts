/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
Create: 20200717@Sophia
Task: ReGen Data for Sum_Winloss_Old - due to wrong netStake [Redmine: #137604] 
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
			,TunroverNoDraw
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
		FROM DBARC.bodb_Archive.dbo.Sum_Winloss_Old_Tmp WITH (NOLOCK) 

	
	------------------------------------------------------------
	DECLARE @WinlostDate SMALLDATETIME

	SELECT DISTINCT WinlostDate INTO #Date from #tmpSum_winloss ORDER BY WinlostDate 
	
	SELECT TOP 1 @WinlostDate = WinlostDate FROM #Date

	WHILE EXISTS (SELECT 1 FROM #Date )
	BEGIN 

		UPDATE s  
		SET 	s.netTurnover = t.netTurnover
				,s.TunroverNoDraw = t.TunroverNoDraw
		FROM 	dbo.Sum_Winloss_Old s WITH (UPDLOCK)
		INNER JOIN #tmpSum_winloss t
				ON t.winlostdate = s.winlostdate
				AND t.CustID = s.CustID
				AND t.roleid = s.RoleID							
		WHERE s.WinlostDate = @winlostdate		
				
					   		
		DELETE #Date WHERE WinlostDate = @WinlostDate

		SELECT TOP 1 @WinlostDate = WinlostDate FROM #Date

	END 
	-- End Regen data 
	DROP TABLE #tmpSum_winloss
	DROP TABLE #Date
 
 END 