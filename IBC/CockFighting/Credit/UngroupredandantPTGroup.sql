/*
	Created: Dominic
	Date: 2015-12-15
	Task: #49344 - Ungroup PT of members that do not belong to the following super 
			WW
			EC
			S863R
			POR
			S359BH
			TVA96
			TVFA
			KPH
			KP25
			supertest4
			K2K
			supertestgr01
			supertestlive1
			SupertestAuto90
			supertestlive3
			SupertestCAJpro
*/  
-- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE Acc_DynamicCustSetting3rd_09
	@target VARCHAR(30)
AS
BEGIN  
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustSetting') = 1
	   AND dbo.f_CheckRepTable('custOverride') = 1 
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustSettingMode3rd') = 1
	   AND dbo.f_CheckRepTable('CustPTGroupSetting3rd_Member') = 1
	   )
	  RETURN
	  
	CREATE TABLE #tmp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		Recommend INT
	)

	INSERT #tmp(CustID,	Recommend)
	select ci.custid,ci.recommend
	from custInfo ci with(nolock)
	inner join CustPTGroupSetting3rd_Member gcs with(nolock) on ci.recommend = gcs.AgentID and gcs.SportType = 44 and gcs.BetType = 1 and gcs.IsLive=0
	inner join CustSettingMode3rd m with(nolock) on m.CustID = ci.custid
	where ci.roleid=1 and ci.srecommend not in
	(
		13869621,
		5340162,
		12262401,
		12141653,
		4138910,
		6379932,
		16112208,
		12141529,
		1539339,
		720475
		--UUS
		,17287861
		,18879367
		,14373244
		,18362423
		,18479460
		,18289591
	) and m.IsGrouped = 1

	INSERT INTO [dbo].[CustPTSetting3rd_Member]
			   ([CustID]
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
	SELECT t.custid
		  ,[SportType]
		  ,[BetType]
		  ,[IsLive]
		  ,[SuperPT]
		  ,[MasterPT]
		  ,[AgentPT]
		  ,[IsAutoMasterPT]
		  ,[AutoMasterPT]
		  ,[IsAutoSuperPT]
		  ,[AutoSuperPT]
	FROM #tmp t with(nolock)
	inner join [dbo].[CustPTGroupSetting3rd_Member] cs with(nolock)
		on t.recommend = cs.AgentID

	UPDATE CustSettingMode3rd
	SET IsGrouped = 0
	WHERE CustID IN (Select CustID FROM #tmp)

END

-- BEGIN STEP 3: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
	
EXEC dbo.Acc_DynamicCustSetting3rd_09 @target = 'REPLICATED'

-- BEGIN STEP 4: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
EXEC dbo.Acc_DynamicCustSetting3rd_09 @target = 'DBCUST'