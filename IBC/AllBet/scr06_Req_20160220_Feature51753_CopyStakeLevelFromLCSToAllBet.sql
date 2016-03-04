/*
	Created: Elodie
	Date: 20160302
	Task: Copy stake level from LCS to AllBet
	DB: DBCUST/CustDB
*/  
 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('CustGameType') = 0 RETURN
	IF dbo.f_CheckRepTable('tmpCustGameType') = 0 RETURN
	IF dbo.f_CheckRepTable('tmpStakeLevel') = 0 RETURN
	IF dbo.f_CheckRepTable('CustStakeLevel_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustStakeLevel_Member') = 0 RETURN

	-----------------
	DECLARE @syncLiveCasino_super BIT, @exchangeID INT, @stakeLevelList2401_super VARCHAR(100)

	SELECT @exchangeID = currency, @syncLiveCasino_super = syncLiveCasino FROM dbo.custinfo WITH(NOLOCK) WHERE custid = @srecommend
	
	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		SyncLiveCasino BIT,
	)

	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		roleid TINYINT,
		SyncLiveCasino BIT,
	)
	
	INSERT INTO #MemberTemp (CustID, SyncLiveCasino)
	SELECT custid, SyncLiveCasino
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid = 1  AND Enabled = 1 AND custid <= @maxcustid
	
	INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino)
	SELECT custid, roleid, SyncLiveCasino
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND Enabled = 1 AND custid <= @maxcustid 

	--Bettype 2402: Lowest VIP Bet limit
	DECLARE @StakeLevelList_2402 VARCHAR(100)
	SELECT TOP 1 @StakeLevelList_2402 =  StakeLevelID 
	FROM dbo.StakeLevel WITH(NOLOCK) 
	WHERE ExchangeId = @exchangeID AND GameTypeID = 2402 
	ORDER BY MinStake, MaxStake

	INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)	
	SELECT CustID, 211, 2402, @StakeLevelList_2402
	FROM #SMATemp 

	INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)	
	SELECT CustID, 211, 2402, @StakeLevelList_2402
	FROM #MemberTemp

	--Bettype 2402: Done

	--Bettype 2401: Copy setting from LC
	IF @syncLiveCasino_super = 0
	BEGIN -- not sync yet, just put empty stakelevellist		
		--SMA Level
		INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)		
		SELECT custid, 211, 2401, ''
		FROM #SMATemp ci 

		--Member Level
		INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)		
		SELECT custid, 211, 2401, ''
		FROM #MemberTemp ci 
		
		RETURN
	END

	SELECT @stakeLevelList2401_super = stakeLevelList		
	FROM dbo.tmpCustGameType WITH(NOLOCK)
	WHERE custid = @srecommend
	
	--If don't have stake level for this line yet, just put empty stakelevellist
	IF ISNULL(@stakeLevelList2401_super,'') = ''
	BEGIN
		--SMA Level
		INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)		
		SELECT custid, 211, 2401, ''
		FROM #SMATemp ci 

		--Member Level
		INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)		
		SELECT custid, 211, 2401, ''
		FROM #MemberTemp ci 
		
		RETURN
	END
		
	IF ISNULL(@stakeLevelList2401_super,'') <> ''
	BEGIN
		SET @stakeLevelList2401_super = STUFF(( -- get new stakelevellist
				SELECT ',' + cast(StakeLevelID2 as varchar(10))
				FROM dbo.tmpStakeLevel WITH(NOLOCK)
				WHERE StakeLevelID IN (
						SELECT Split.a.value('.', 'int')
						FROM (SELECT CAST('<v>' + REPLACE(@stakeLevelList2401_super, ',', '</v><v>') + '</v>' AS XML) AS _xml) AS a
							CROSS APPLY _xml.nodes('/v') AS Split(a)
				)
				ORDER BY MinStake, MaxStake ASC
				FOR XML PATH('')
			), 1,1,'')
	
		-- master, agent and member
		CREATE TABLE #SyncedDownlines (custid int, syncLiveCasino bit, stakeLevelList varchar(100), uplineID int, roleid tinyint)
		CREATE TABLE #UnSyncDownlines (custid int, roleid tinyint)
	
		create clustered index CIX_SyncedDownlines on #SyncedDownlines (roleid, custid)
	
		INSERT INTO #SyncedDownlines (custid, syncLiveCasino, roleid)
		SELECT custid, 1, roleID
		FROM (SELECT custid, roleid FROM #SMATemp WHERE SyncLiveCasino = 1 UNION ALL SELECT custid, 1 FROM #MemberTemp WHERE SyncLiveCasino = 1) a
		WHERE roleid < 4		
			
		INSERT INTO #UnSyncDownlines (custid, roleid)
		SELECT custid, roleid
		FROM (SELECT custid, roleid FROM #SMATemp WHERE SyncLiveCasino = 0 UNION ALL SELECT custid, 1 FROM #MemberTemp WHERE SyncLiveCasino = 0) a
		WHERE roleid < 4		

	-- maybe need to create index for table #SyncedDownlines here
	 	
	-- get stakelevellist for synced customers
	;WITH s AS (
		SELECT a2.custid, sl.stakeLevelID2 as stakeLevelID, MinStake, MaxStake
		FROM (
				SELECT a1.custid, Split.a.value('.', 'int') AS stakelevelID
				FROM (
						SELECT b.custid, CAST('<v>' + REPLACE(a.stakelevellist, ',', '</v><v>') + '</v>' AS XML) AS _xml
						FROM dbo.tmpCustGameType a WITH(NOLOCK)
							INNER JOIN #SyncedDownlines b ON a.custid = b.custid
						
					) AS a1
					CROSS APPLY _xml.nodes('/v') AS Split(a)
			) a2
			INNER JOIN dbo.tmpStakeLevel sl ON a2.stakelevelID = sl.stakelevelID		
	)
	UPDATE #SyncedDownlines
	SET stakelevellist = data.StakeLevelList
	FROM (
			SELECT b.custid, STUFF(
						(SELECT ',' + CONVERT(VARCHAR(10),a.StakeLevelID)
						FROM  s a                
						WHERE a.custid = b.custid		
						ORDER BY MinStake, MaxStake ASC				
						FOR XML PATH (''))
						, 1, 1, '')  AS StakeLevelList
			FROM s b WITH(NOLOCK)
			GROUP BY b.custid
		) data
	WHERE #SyncedDownlines.custid = data.custid
	option (maxdop 4)
		
	UPDATE #SyncedDownlines
	SET StakeLevelList = ''
	WHERE StakeLevelList IS NULL

	-- all done, start insert
	INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)
	SELECT @srecommend, 211, 2401, @stakeLevelList2401_super 
	
	UNION ALL
	SELECT custid, 211, 2401, ISNULL(stakeLevelList,'')
	FROM #SyncedDownlines 
	WHERE roleid <> 1

	UNION ALL
	SELECT custid, 211, 2401, '' AS stakeLevelList
	FROM #UnSyncDownlines	
	WHERE roleid <> 1	

	INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)
	SELECT custid, 211, 2401, ISNULL(stakeLevelList,'')
	FROM #SyncedDownlines 
	WHERE roleid = 1

	UNION ALL
	SELECT custid, 211, 2401, '' AS stakeLevelList
	FROM #UnSyncDownlines	
	WHERE roleid = 1	
		
	DROP TABLE #UnSyncDownlines
	DROP TABLE #SyncedDownlines
	DROP TABLE #SMATemp
	DROP TABLE #MemberTemp
END

GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx


INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid <= @max_custid
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid <= @max_custid 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END