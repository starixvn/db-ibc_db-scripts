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
	DECLARE @syncLiveCasino_super BIT, @exchangeID INT, @stakeLevelList_super VARCHAR(100)

	SELECT @exchangeID = currency, @syncLiveCasino_super = syncLiveCasino FROM dbo.custinfo WITH(NOLOCK) WHERE custid = @srecommend
	
	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(162, 1101, 211	, 2401, 7), --StakeLevel
	(162, 1101, 211	, 2402, 7) --StakeLevel

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
	SELECT custid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid = 1  AND Enabled = 1 AND custid <= @maxcustid
	
	INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino)
	SELECT custid, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND Enabled = 1 AND custid <= @maxcustid 

	IF @syncLiveCasino_super = 0
	BEGIN -- not sync yet, just put empty stakelevellist		
		--SMA Level
		INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)		
		SELECT custid, SportType, BetType, StakeLevelList
		FROM #SMATemp ci 
			CROSS APPLY (SELECT tSportType, tBetType, '' FROM #DestinationSportBetType) b(SportType, BetType, StakeLevelList)

		--Member Level
		INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)		
		SELECT custid, SportType, BetType, StakeLevelList
		FROM #MemberTemp ci 
			CROSS APPLY (SELECT tSportType, tBetType, '' FROM #DestinationSportBetType) b(SportType, BetType, StakeLevelList)
		RETURN
	END

	SELECT @stakeLevelList_super = stakeLevelList		
	FROM dbo.tmpCustGameType WITH(NOLOCK)
	WHERE custid = @srecommend
	
	--If don't have stake level for this line yet, get the lowest stakelevel from currency
	IF ISNULL(@stakeLevelList_super,'') = ''
	BEGIN
		INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)		
		SELECT custid, GameTypeID, CASE WHEN SyncLiveCasino = 1 THEN CAST(StakeLevelList AS VARCHAR(100)) ELSE '' END
		FROM custinfo c WITH(NOLOCK) 
			CROSS APPLY (
				SELECT GameTypeID, stakelevelid2 as StakeLevelList
				FROM (
					SELECT gametypeid, stakelevelid2, rn = row_number() OVER (PARTITION BY gametypeid ORDER BY minstake, maxstake ASC)
					FROM tmpStakeLevel
					WHERE exchangeid = @exchangeID
						AND (
								(GameTypeID =1701 AND ISNULL(@stakeLevelList1701_super,'') = '')
								OR 
								(GameTypeID =1702 AND ISNULL(@stakeLevelList1702_super,'') = '')
							)
					) s1
				WHERE rn = 1
			) s2
		WHERE c.srecommend = @srecommend AND c.custid <= @maxcustid
			AND enabled = 1
	END
	
	IF ISNULL(@stakeLevelList1701_super,'') = '' AND  ISNULL(@stakeLevelList1702_super,'') = ''	
		RETURN--already done for whole line
	
	-- get new stakelevellist
	IF ISNULL(@stakeLevelList1701_super,'') <> ''
		SET @stakeLevelList1701_super = STUFF((
				SELECT ',' + cast(StakeLevelID2 as varchar(10))
				FROM dbo.tmpStakeLevel WITH(NOLOCK)
				WHERE StakeLevelID IN (
						SELECT Split.a.value('.', 'int')
						FROM (SELECT CAST('<v>' + REPLACE(@stakeLevelList1701_super, ',', '</v><v>') + '</v>' AS XML) AS _xml) AS a
							CROSS APPLY _xml.nodes('/v') AS Split(a)
				)
				ORDER BY MinStake, MaxStake ASC
				FOR XML PATH('')
			), 1,1,'')
	
	IF ISNULL(@stakeLevelList1702_super,'') <> ''	
		SET @stakeLevelList1702_super = STUFF((
				SELECT ',' + cast(StakeLevelID2 as varchar(10))
				FROM dbo.tmpStakeLevel WITH(NOLOCK)
				WHERE StakeLevelID IN (
						SELECT Split.a.value('.', 'int')
						FROM (SELECT CAST('<v>' + REPLACE(@stakeLevelList1702_super, ',', '</v><v>') + '</v>' AS XML) AS _xml) AS a
							CROSS APPLY _xml.nodes('/v') AS Split(a)
				)
				ORDER BY MinStake, MaxStake ASC
				FOR XML PATH('')
			), 1,1,'')

	-- master and agent
	CREATE TABLE #SyncedDownlines (custid int, syncLiveCasino bit, gametypeID smallint, stakeLevelList varchar(100), uplineID int, roleid tinyint)
	CREATE TABLE #UnSyncDownlines (custid int, gametypeID smallint)
	
	create clustered index CIX_SyncedDownlines on #SyncedDownlines (roleid, custid)
	
	INSERT INTO #SyncedDownlines (custid, syncLiveCasino, GameTypeID, roleid, uplineID)
	SELECT custid, syncLiveCasino, GameTypeID, roleID, 
		CASE roleID 
			WHEN 3 THEN srecommend 
			WHEN 2 THEN mrecommend
			ELSE recommend 
		END --uplineID
	FROM dbo.custinfo WITH(NOLOCK)
		CROSS APPLY (VALUES(1701),(1702)) b(GameTypeID)
	WHERE srecommend = @srecommend
		AND roleid < 4		
		AND custid < @maxcustid
		AND syncLiveCasino = 1
		AND enabled = 1
		AND (
				(gametypeid = 1701 AND ISNULL(@stakeLevelList1701_super,'') <> '')
				OR
				(gametypeid = 1702 AND ISNULL(@stakeLevelList1702_super,'') <> '')
			)

	INSERT INTO #UnSyncDownlines (custid,gameTypeID)
	SELECT custid, gametypeID
	FROM dbo.custinfo WITH(NOLOCK)
		CROSS APPLY (VALUES(1701),(1702)) b(GameTypeID)
	WHERE srecommend = @srecommend
		AND roleid < 4		
		AND custid < @maxcustid
		AND syncLiveCasino = 0
		AND enabled = 1
		AND (
				(gametypeid = 1701 AND ISNULL(@stakeLevelList1701_super,'') <> '')
				OR
				(gametypeid = 1702 AND ISNULL(@stakeLevelList1702_super,'') <> '')
			)

	-- maybe need to create index for table #SyncedDownlines here
	 	
	-- get stakelevellist for synced customers
	;WITH s AS (
		SELECT a2.custid, a2.GameTypeID, sl.stakeLevelID2 as stakeLevelID, MinStake, MaxStake
		FROM (
				SELECT a1.custid, a1.GameTypeID, Split.a.value('.', 'int') AS stakelevelID
				FROM (
						SELECT b.custid, b.GameTypeID, CAST('<v>' + REPLACE(a.stakelevellist, ',', '</v><v>') + '</v>' AS XML) AS _xml
						FROM dbo.tmpCustGameType a WITH(NOLOCK)
							INNER JOIN #SyncedDownlines b ON a.custid = b.custid AND a.GameTypeID = b.gametypeID
						
					) AS a1
					CROSS APPLY _xml.nodes('/v') AS Split(a)
			) a2
			INNER JOIN dbo.tmpStakeLevel sl ON a2.stakelevelID = sl.stakelevelID		
	)
	UPDATE #SyncedDownlines
	SET stakelevellist = data.StakeLevelList
	FROM (
			SELECT b.custid, b.GameTypeID as GameTypeID, STUFF(
						(SELECT ',' + CONVERT(VARCHAR(10),a.StakeLevelID)
						FROM  s a                
						WHERE a.GameTypeID = b.GameTypeID AND a.custid = b.custid		
						ORDER BY MinStake, MaxStake ASC				
						FOR XML PATH (''))
						, 1, 1, '')  AS StakeLevelList
			FROM s b WITH(NOLOCK)
			GROUP BY b.custid, b.GameTypeID
		) data
	WHERE #SyncedDownlines.custid = data.custid AND #SyncedDownlines.gameTypeID = data.gameTypeID
	option (maxdop 4)
	
	-- copy lowest stakelevel from upline for those don't have setting yet
	-- master: copy from super
	UPDATE #SyncedDownlines
	SET StakeLevelList = CASE 
							WHEN gametypeID = 1701 THEN SUBSTRING(@stakeLevelList1701_super+',', 0, CHARINDEX(',', @stakeLevelList1701_super+',', 0)) 
							WHEN gametypeID = 1702 THEN SUBSTRING(@stakeLevelList1702_super+',', 0, CHARINDEX(',', @stakeLevelList1702_super+',', 0)) 
							ELSE ''
						END
	WHERE roleid = 3 AND ISNULL(StakeLevelList,'')= ''

	-- agent: copy from master
	UPDATE Ag
	SET StakeLevelList = SUBSTRING(mag.stakeLevelList+',', 0, CHARINDEX(',', mag.stakeLevelList+',', 0)) 
	FROM #SyncedDownlines Ag
		INNER JOIN #SyncedDownlines MAg ON Ag.uplineID = MAG.custid AnD ag.gametypeID = mag.gametypeID
	WHERE ag.roleid = 2 AND ISNULL(ag.stakeLevelList,'') = ''

	-- member: copy from agent
	UPDATE p
	SET StakeLevelList = SUBSTRING(ag.stakeLevelList+',', 0, CHARINDEX(',', ag.stakeLevelList+',', 0)) 
	FROM #SyncedDownlines p
		INNER JOIN #SyncedDownlines Ag ON p.uplineID = Ag.custid AnD p.gametypeID = ag.gametypeID
	WHERE p.roleid = 1 AND ISNULL(p.stakeLevelList,'') = ''

	-- all done, start insert
	INSERT INTO CustGameType(custid, GameTypeID, StakeLevelList)
	SELECT @srecommend, 1701, @stakeLevelList1701_super WHERE ISNULL(@stakeLevelList1701_super,'') <> ''
	UNION ALL
	SELECT @srecommend, 1702, @stakeLevelList1702_super WHERE ISNULL(@stakeLevelList1702_super,'') <> ''
	
	UNION ALL
	SELECT custid, gametypeid, ISNULL(stakeLevelList,'')
	FROM #SyncedDownlines

	UNION ALL
	SELECT custid, gametypeid,'' StakeLevelList
	FROM #UnSyncDownlines		
		
	
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
	INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
	INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4 	
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 0
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	and s.islicensee = 0


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
	
	waitfor delay '00:00:0.280'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------
 


---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
	INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
	INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4 	
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 0
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	and s.islicensee = 0

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTCUST'
	
	waitfor delay '00:00:0.280'
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------