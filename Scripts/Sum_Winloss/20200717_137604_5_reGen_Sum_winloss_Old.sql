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


		MERGE  dbo.sum_winloss_old  AS TARGET
		USING (select * from #tmpSum_winloss) AS SOURCE
			ON		TARGET.winlostdate	= SOURCE.winlostdate
				AND	TARGET.custid		= SOURCE.custid
				AND TARGET.sporttype	= SOURCE.sporttype
				AND TARGET.bettype		= SOURCE.bettype
				
		WHEN MATCHED THEN UPDATE
			SET	TARGET.username			= SOURCE.username
				,TARGET.roleid			= SOURCE.roleid
				,TARGET.recommend		= SOURCE.recommend
				,TARGET.mrecommend		= SOURCE.mrecommend
				,TARGET.srecommend		= SOURCE.srecommend
				,TARGET.turnover		= SOURCE.turnover
				,TARGET.winlost			= SOURCE.winlost
				,TARGET.awinlost		= SOURCE.awinlost
				,TARGET.mwinlost		= SOURCE.mwinlost
				,TARGET.swinlost		= SOURCE.swinlost
				,TARGET.playercomm		= SOURCE.playercomm
				,TARGET.comm			= SOURCE.comm
				,TARGET.acomm			= SOURCE.acomm
				,TARGET.scomm			= SOURCE.scomm
				,TARGET.BetCount		= SOURCE.BetCount
				,TARGET.grosscomm		= SOURCE.grosscomm
				,TARGET.netTurnover		= SOURCE.netTurnover
				,TARGET.TunroverNoDraw	= SOURCE.TunroverNoDraw -- TunroverNoDraw
		WHEN NOT MATCHED BY TARGET THEN INSERT
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
				,TunroverNoDraw -- TunroverNoDraw
			)
			VALUES
			(
				SOURCE.winlostdate
				,SOURCE.username
				,SOURCE.custid
				,SOURCE.roleid
				,SOURCE.recommend
				,SOURCE.mrecommend
				,SOURCE.srecommend
				,SOURCE.turnover
				,SOURCE.winlost
				,SOURCE.awinlost
				,SOURCE.mwinlost
				,SOURCE.swinlost
				,SOURCE.playercomm
				,SOURCE.comm
				,SOURCE.acomm
				,SOURCE.scomm
				,SOURCE.BetCount
				,SOURCE.grosscomm
				,SOURCE.sporttype
				,SOURCE.bettype
				,SOURCE.netTurnover
				,SOURCE.TunroverNoDraw
			)
		WHEN NOT MATCHED BY SOURCE
			--AND TARGET.winlostdate = @winlostdate
			--AND EXISTS (SELECT 1 FROM #tmpSuper ts WHERE TARGET.srecommend = ts.srecommend)
			THEN DELETE;
 
	-- End Regen data 
	DROP TABLE #tmpSum_winloss
 
 END 