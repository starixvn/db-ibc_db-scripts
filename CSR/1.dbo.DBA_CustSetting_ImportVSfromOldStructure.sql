CREATE PROCEDURE dbo.DBA_CustSetting_ImportVSfromOldStructure
	@isDeleteData BIT = 1
AS
BEGIN
	CREATE TABLE #AgentCustID(recommend INT, CustID INT)
	IF (SELECT COUNT(1)  
       FROM sys.objects  
      WHERE NAME IN (	'custInfo',
						'CustSetting3rd',
						'custOverride3rd',
						'CustPTSetting3rd_Agent',
						'CustPTSetting3rd_Member',
						'CustBetSetting3rd_Agent',
						'CustBetSetting3rd_Member',
						'CustProductStatus')  
        AND type = 'U'  
       ) <> 8  
	RETURN 
  
	DECLARE @maxcustid INT, @i INT =0, @step INT = 100000
	SELECT @maxcustid = MAX(custid) FROM dbo.CustSetting3rd WITH(NOLOCK)
	
	CREATE TABLE #tmp(sporttype smallint,bettype smallint)
	INSERT INTO #tmp
	VALUES
	(180	,1201)
	
	
	IF @isDeletedata = 1
	BEGIN
		DELETE FROM dbo.CustPTSetting3rd_Agent
		DELETE FROM dbo.CustPTSetting3rd_Member
		DELETE FROM dbo.CustBetSetting3rd_Agent
		DELETE FROM dbo.CustBetSetting3rd_Member
		DELETE FROM dbo.CustProductStatus
	END
	

	WHILE (@i< = @maxcustid)
	BEGIN
		/*****************************POSITION TAKING**************************/
		--AGENT LEVEL
		--Dead ball - Virtual Sport
		INSERT INTO dbo.CustPTSetting3rd_Agent
		SELECT 
		cs.custid,cs.sporttype,cs.bettype,0,
		cs.spositiontaking*100,cs.mpositiontaking*100,cs.apositiontaking*100,
		cs.isautompositiontaking,cs.autompositiontaking*100,
		cs.isautopositiontaking,cs.autopositiontaking*100,
		co.minpositiontaking*100,co.maxpositiontaking*100
		FROM dbo.CustSetting3rd cs WITH(NOLOCK) 
		JOIN dbo.custOverride3rd co WITH(NOLOCK) on cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype
		JOIN dbo.custInfo ci ON ci.custid = cs.custid
		WHERE ci.roleid IN (2,3,4) AND cs .custid between @i + 1 and @i + @step 
		AND cs.bettype BETWEEN 1201 AND 1299
		
			

		--MEMBER LEVEL
		--PT Value
		--Dead ball - Virtual Sport
		INSERT INTO dbo.CustPTSetting3rd_Member
			([custid]
		  ,[sporttype]
		  ,[bettype]
		  ,[islive]
		  ,[superPT]
		  ,[masterPT]
		  ,[agentPT]
		  ,[IsAutoMasterPT]
		  ,[AutoMasterPT]
		  ,[IsAutoSuperPT]
		  ,[AutoSuperPT])
		SELECT 
		cs.custid,
		cs.sporttype,
		cs.bettype,
		0,
		cs.spositiontaking*100,
		cs.mpositiontaking*100,
		cs.apositiontaking*100,
		cs.isautompositiontaking,
		cs.autompositiontaking*100,
		cs.isautopositiontaking,
		cs.autopositiontaking*100
		FROM dbo.custSetting3rd cs
		INNER JOIN custInfo ci ON cs.CustID = ci.custid
		WHERE cs .custid BETWEEN @i + 1 AND @i + @step 
		AND cs.bettype BETWEEN 1201 AND 1299 AND ci.roleid = 1
		
		
		/*****************************BET LIMIT SETTING**************************/	 
		--AGENT LEVEL - Virtual Sport
		INSERT INTO dbo.CustBetSetting3rd_Agent
		SELECT cs.custid,cs.sporttype,cs.bettype,cs.minbet,cs.maxbet,
			CASE
				WHEN
				 (cs.sporttype = 180 AND cs.bettype = 1201) THEN ci.maxpermatch180
				WHEN
				 (cs.sporttype = 186 AND cs.bettype = 1220) THEN ci.maxpermatch186
				WHEN
				 (cs.sporttype = 181 AND cs.bettype = 1231) THEN ci.maxpermatch181
				WHEN
				 (cs.sporttype = 182 AND cs.bettype = 1231) THEN ci.maxpermatch182
				WHEN
				 (cs.sporttype = 183 AND cs.bettype = 1231) THEN ci.maxpermatch183
				WHEN
				 (cs.sporttype = 184 AND cs.bettype = 1231) THEN ci.maxpermatch184
				WHEN
				 (cs.sporttype = 185 AND cs.bettype = 1231) THEN ci.maxpermatch185
			END AS maxpermatch
		 FROM dbo.CustSetting3rd cs 
		 JOIN dbo.custInfo ci ON  ci.custid = cs.custid
		 WHERE cs.custid BETWEEN @i + 1 AND @i + @step AND ci.roleid IN (2,3,4)
		 AND (
		 (cs.sporttype = 180 AND cs.bettype = 1201)
		 OR
		 (cs.sporttype = 186 AND cs.bettype = 1220)
		 OR
		 (cs.sporttype = 181 AND cs.bettype = 1231)
		 OR
		 (cs.sporttype = 182 AND cs.bettype = 1231)
		  OR
		 (cs.sporttype = 183 AND cs.bettype = 1231)
		  OR
		 (cs.sporttype = 184 AND cs.bettype = 1231)
		  OR
		 (cs.sporttype = 185 AND cs.bettype = 1231)
		 )
	  
		--MEMBER LEVEL -- Virtual Sport
		INSERT INTO dbo.CustBetSetting3rd_Member
		SELECT cs.custid,cs.sporttype,cs.bettype,cs.minbet,cs.maxbet,
			CASE
				WHEN
				 (cs.sporttype = 180 AND cs.bettype = 1201) THEN ci.maxpermatch180
				WHEN
				 (cs.sporttype = 186 AND cs.bettype = 1220) THEN ci.maxpermatch186
				WHEN
				 (cs.sporttype = 181 AND cs.bettype = 1231) THEN ci.maxpermatch181
				WHEN
				 (cs.sporttype = 182 AND cs.bettype = 1231) THEN ci.maxpermatch182
				WHEN
				 (cs.sporttype = 183 AND cs.bettype = 1231) THEN ci.maxpermatch183
				WHEN
				 (cs.sporttype = 184 AND cs.bettype = 1231) THEN ci.maxpermatch184
				WHEN
				 (cs.sporttype = 185 AND cs.bettype = 1231) THEN ci.maxpermatch185
			END AS maxpermatch
		 FROM dbo.CustSetting3rd cs 
		 JOIN dbo.custInfo ci ON  ci.custid = cs.custid
		 WHERE cs.custid BETWEEN @i + 1 AND @i + @step AND ci.roleid = 1
		 AND (
		 (cs.sporttype = 180 AND cs.bettype = 1201)
		 OR
		 (cs.sporttype = 186 AND cs.bettype = 1220)
		 OR
		 (cs.sporttype = 181 AND cs.bettype = 1231)
		 OR
		 (cs.sporttype = 182 AND cs.bettype = 1231)
		  OR
		 (cs.sporttype = 183 AND cs.bettype = 1231)
		  OR
		 (cs.sporttype = 184 AND cs.bettype = 1231)
		  OR
		 (cs.sporttype = 185 AND cs.bettype = 1231)
		 )
		
		/*INSERT CUSTPRODUCTSTATUS TABLE*/
		INSERT INTO [dbo].[CustProductStatus]
           ([custid]
           ,[sporttype]
           ,[bettype]
           ,[isdisabled]
           ,[IsHidden]
           ,[issync])
		SELECT ci.custid,t.sporttype,t.bettype,ci.DisableVirtualSports,ci.HideVirtualSports,NULL
		FROM dbo.custInfo ci
		cross join #tmp t
		WHERE ci.custid BETWEEN @i + 1 AND @i + @step
		ORDER BY custid
		
		INSERT INTO #AgentCustID
		SELECT ci.recommend, MAX(ci.custid) custid
		FROM CustPTSetting3rd_Member mpt WITH(NOLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON  ci.custid = mpt.custid
		WHERE mpt.custid BETWEEN @i + 1 AND @i + @step
		GROUP BY ci.recommend
	
		/*INERT PT GROUP SETTING*/
		INSERT INTO [dbo].[CustPTGroupSetting3rd_Member]
           ([AgentID]
           ,[SportType]
           ,[BetType]
           ,[IsLive]
           ,[SuperPT]
           ,[MasterPT]
           ,[AgentPT]
           ,[IsAutoMasterPT]
           ,[AutoMasterPT]
           ,[IsAutoSuperPT]
           ,[AutoSuperPT])
		SELECT acid.recommend
			  ,mpt.[sporttype]
			  ,mpt.[bettype]
			  ,mpt.[islive]
			  ,mpt.[superPT]
			  ,mpt.[masterPT]
			  ,mpt.[agentPT]
			  ,mpt.[IsAutoMasterPT]
			  ,mpt.[AutoMasterPT]
			  ,mpt.[IsAutoSuperPT]
			  ,mpt.[AutoSuperPT]
		FROM CustPTSetting3rd_Member mpt WITH(NOLOCK)
		INNER JOIN #AgentCustID acid ON mpt.CustID = acid.custid
		LEFT JOIN dbo.CustPTGroupSetting3rd_Member gpt WITH(NOLOCK)
					ON gpt.AgentID = acid.recommend 
						AND gpt.sporttype = mpt.sporttype
						AND gpt.bettype = mpt.bettype
						AND gpt.islive = mpt.islive
		WHERE gpt.superPT IS NULL
	
		TRUNCATE TABLE #AgentCustID	
	
	
		print @i
		
		SET @i = @i + @step
	END
		
	DROP TABLE #tmp
	DROP TABLE #AgentCustID
END