/*
	Created: Elodie
	Date: 20161121
	Task: Change NG2 MinPT of Super for ACCYEN889 line
	DB: DBCUST/CustDB
*/
USE CustDB
GO
/*	

	DROP TABLE #MemberPT
	DROP TABLE #AgentPT
	DROP TABLE #MasterPT
	DROP TABLE #SuperPT
	
	select count(1) from #CheckPTResult_Credit	
	SELECT ca.username AS UsernameA, ca.roleid AS roleidA, cb.username AS UsernameB, cb.roleid AS roleidB, cs.* 
	FROM #CheckPTResult_Credit cs
		INNER JOIN CustInfo ca WITH (NOLOCK) ON cs.custidA = ca.custid
		INNER JOIN CustInfo cb WITH (NOLOCK) ON cs.custidB = cb.custid
	ORDER BY ruleid	
	
	DROP TABLE #CheckPTResult_Credit
	GO
*/	
	CREATE TABLE #CheckPTResult_Credit(
		[RuleId] [smallint] NULL,
		[SportType] [smallint] NULL,
		[BetType] [smallint] NULL,
		[CustIdA] [int] NULL,
		[CustIdB] [int] NULL,
		[ValueA] [smallmoney] NULL,
		[ValueB] [smallmoney] NULL,
		[CreatedDate] [datetime] NULL,
		[IsLive] [bit] NULL
	)

	GO

	ALTER TABLE #CheckPTResult_Credit ADD  CONSTRAINT [DF_CheckPTRule_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
	GO

	ALTER TABLE #CheckPTResult_Credit ADD  DEFAULT ((0)) FOR [IsLive]
	
	
	CREATE TABLE #supers (custid int)
	
	INSERT INTO #supers(custid)
	select CustID
	FROM DBAGE.bodb_age.dbo.Acc_CustGroup with (Nolock)
	WHERE GroupName = 'ACCYEN889'
		AND CustID <> 595561 -- SC

	SELECT cs.CustID,ci.recommend,ci.mrecommend,ci.srecommend, cs.SportType,cs.BetType,cs.IsLive,cs.SuperPT,cs.MasterPT,cs.AgentPT,cs.IsAutoMasterPT,cs.AutoMasterPT,cs.IsAutoSuperPT,cs.AutoSuperPT,0 IsGroup
	INTO #MemberPT
	FROM dbo.CustInfo ci
		JOIN dbo.CustPTSetting3rd_Member cs WITH (NOLOCK) ON ci.CustID = cs.CustID
		INNER JOIN dbo.CustProductStatus stt WITH (NOLOCK) ON ci.CustID = stt.CustID
		LEFT JOIN dbo.ProductStatusProfile prf WITH(NOLOCK) ON prf.Sporttype = cs.sporttype
	WHERE ci.srecommend IN (SELECT Custid FROM #supers)
			AND ci.roleid = 1  
			AND ci.Enabled = 1      
			AND ci.Currency NOT IN (20,27,28)     
			AND cs.SportType BETWEEN 213 AND 218
			
	INSERT INTO #MemberPT (CustID, recommend,mrecommend,srecommend,SportType,BetType,IsLive,SuperPT,MasterPT,AgentPT,IsAutoMasterPT,AutoMasterPT,IsAutoSuperPT,AutoSuperPT,IsGroup)
	SELECT ci.CustID,ci.recommend,ci.mrecommend,ci.srecommend, cs.SportType,cs.BetType,cs.IsLive,cs.SuperPT,cs.MasterPT,cs.AgentPT,cs.IsAutoMasterPT,cs.AutoMasterPT,cs.IsAutoSuperPT,cs.AutoSuperPT,1
	FROM dbo.CustInfo ci
		INNER JOIN dbo.CustSettingMode3rd csm WITH (NOLOCK) ON ci.custid = csm.CustID AND csm.IsGrouped = 1
		INNER JOIN dbo.CustPTGroupSetting3rd_Member cs WITH (NOLOCK) ON cs.AgentID = ci.recommend  
		INNER JOIN dbo.CustProductStatus stt WITH (NOLOCK) ON ci.CustID = stt.CustID
		LEFT JOIN dbo.ProductStatusProfile prf WITH(NOLOCK) ON prf.Sporttype = cs.sporttype
	WHERE ci.srecommend IN (SELECT Custid FROM #supers)
			AND ci.roleid = 1  
			AND ci.Enabled = 1      
			AND ci.Currency NOT IN (20,27,28)     
			AND cs.SportType BETWEEN 213 AND 218
			
			
	SELECT cs.CustID,ci.recommend,ci.mrecommend,ci.srecommend, cs.SportType,cs.BetType,cs.IsLive,cs.SuperPT,cs.MasterPT,cs.AgentPT,cs.IsAutoMasterPT,cs.AutoMasterPT,cs.IsAutoSuperPT,cs.AutoSuperPT,cs.MinPT,cs.MaxPT
	INTO #AgentPT
	FROM dbo.CustInfo ci
		JOIN dbo.CustPTSetting3rd_Agent cs WITH (NOLOCK) ON ci.CustID = cs.CustID
		INNER JOIN dbo.CustProductStatus stt WITH (NOLOCK) ON ci.CustID = stt.CustID
		LEFT JOIN dbo.ProductStatusProfile prf WITH(NOLOCK) ON prf.Sporttype = cs.sporttype
	WHERE ci.srecommend IN (SELECT Custid FROM #supers)
			AND ci.roleid = 2  
			AND ci.Enabled = 1      
			AND ci.Currency NOT IN (20,27,28)     
			AND cs.SportType BETWEEN 213 AND 218
			
	SELECT cs.CustID,ci.recommend,ci.mrecommend,ci.srecommend, cs.SportType,cs.BetType,cs.IsLive,cs.SuperPT,cs.MasterPT,cs.AgentPT,cs.IsAutoMasterPT,cs.AutoMasterPT,cs.IsAutoSuperPT,cs.AutoSuperPT,cs.MinPT,cs.MaxPT
	INTO #MasterPT
	FROM dbo.CustInfo ci
		JOIN dbo.CustPTSetting3rd_Agent cs WITH (NOLOCK) ON ci.CustID = cs.CustID
		INNER JOIN dbo.CustProductStatus stt WITH (NOLOCK) ON ci.CustID = stt.CustID
		LEFT JOIN dbo.ProductStatusProfile prf WITH(NOLOCK) ON prf.Sporttype = cs.sporttype
	WHERE ci.srecommend IN (SELECT Custid FROM #supers)
			AND ci.roleid = 3  
			AND ci.Enabled = 1      
			AND ci.Currency NOT IN (20,27,28)     
			AND cs.SportType BETWEEN 213 AND 218
	
	SELECT cs.CustID, cs.SportType,cs.BetType,cs.IsLive,cs.SuperPT,cs.MasterPT,cs.AgentPT,cs.IsAutoMasterPT,cs.AutoMasterPT,cs.IsAutoSuperPT,cs.AutoSuperPT,cs.MinPT,cs.MaxPT
	INTO #SuperPT
	FROM dbo.CustInfo ci
		JOIN dbo.CustPTSetting3rd_Agent cs WITH (NOLOCK) ON ci.CustID = cs.CustID
		INNER JOIN dbo.CustProductStatus stt WITH (NOLOCK) ON ci.CustID = stt.CustID
		LEFT JOIN dbo.ProductStatusProfile prf WITH(NOLOCK) ON prf.Sporttype = cs.sporttype
	WHERE ci.srecommend IN (SELECT Custid FROM #supers)
			AND ci.roleid = 4  
			AND ci.Enabled = 1      
			AND ci.Currency NOT IN (20,27,28)     
			AND cs.SportType BETWEEN 213 AND 218
					
	-- End of DATA PREPARATION				
	DECLARE @RuleId SMALLINT = 0
	-- Starting check PT Rule
	 
	----5. S4 < N4   

	IF @RuleId IN (0,5)  
	BEGIN   
		----PRINT '5. S4 < N4 '
		INSERT INTO #CheckPTResult_Credit (RuleId, BetType, SportType, CustIdA, CustIdB, ValueA, ValueB, IsLive)  
		SELECT 5 as RuleId, cs.BetType, cs.SportType, cs.CustId, cs.CustId, cs.SuperPT, cs.MinPT, cs.IsLive  
		FROM #SuperPT cs  
		WHERE cs.superPT < cs.MinPT

	END  
	
	----10. N4 > S1 + M1 + A1   
	----PRINT '10. N4 > S1 + M1 + A1 '
	IF @RuleId IN (0,10)  
	BEGIN 
		INSERT INTO #CheckPTResult_Credit (RuleId, BetType, SportType, CustIdA, CustIdB, ValueA, ValueB, IsLive)  
		SELECT 10 as RuleId, cs.BetType, cs.SportType, scs.CustId, cs.CustId, scs.MinPT, cs.SuperPT + cs.MasterPT + cs.AgentPT, scs.IsLive  
		FROM #MemberPT cs
			INNER JOIN #SuperPT scs ON scs.CustID = cs.srecommend AND scs.SportType = cs.SportType AND scs.BetType = cs.BetType AND scs.IsLive = cs.IsLive  
		WHERE scs.MinPT > cs.SuperPT + cs.MasterPT + cs.AgentPT
		  
	END  

CREATE TABLE #Cust (custid INT, isfinished bit default(0)) 
DECLARE @custid INT
DECLARE @PT	VARCHAR(MAX)='<ROOT><PT SportType="213" BetType="2501" IsLive="0"/><PT SportType="213" BetType="2512" IsLive="0"/><PT SportType="213" BetType="2513" IsLive="0"/><PT SportType="213" BetType="2514" IsLive="0"/><PT SportType="213" BetType="2539" IsLive="0"/><PT SportType="214" BetType="2541" IsLive="0"/><PT SportType="214" BetType="2579" IsLive="0"/><PT SportType="215" BetType="2581" IsLive="0"/><PT SportType="215" BetType="2619" IsLive="0"/><PT SportType="216" BetType="2621" IsLive="0"/><PT SportType="216" BetType="2659" IsLive="0"/><PT SportType="217" BetType="2661" IsLive="0"/><PT SportType="217" BetType="2662" IsLive="0"/><PT SportType="217" BetType="2663" IsLive="0"/><PT SportType="218" BetType="2681" IsLive="0"/><PT SportType="218" BetType="2682" IsLive="0"/><PT SportType="218" BetType="2683" IsLive="0"/></ROOT>'

INSERT INTO #Cust (custid)
SELECT DISTINCT cs.CustIdA AS custid
FROM #CheckPTResult_Credit cs
	INNER JOIN CustInfo ca WITH (NOLOCK) ON cs.custidA = ca.custid
	INNER JOIN CustInfo cb WITH (NOLOCK) ON cs.custidB = cb.custid	

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_04 
			@SuperID = @custid
			,@RoleID = 4
			,@SportBettypeXML = @PT 
			
	waitfor delay '00:00:0.100'
END


