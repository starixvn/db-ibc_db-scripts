/*
	Created: Johnson
	Date: 2015-08-31
	Task: Copy stake level from LCS to GD
	DB: DBTP/DB054. bodb02	
*/  


 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
		
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
		AND dbo.f_CheckRepTable('CustGameType') = 1
		AND dbo.f_CheckRepTable('tmpCustGameType') = 1
		AND dbo.f_CheckRepTable('tmpStakeLevel') = 1
	   )
	  RETURN

	DECLARE @StakeLevelList_1701 VARCHAR(50)= ''
			,@StakeLevelList_1702 VARCHAR(50)= ''
			,@StakeLevelList_1701_new VARCHAR(50)= ''
			,@StakeLevelList_1702_new VARCHAR(50)= ''
			,@currency INT
			,@custid INT
			,@uplineID INT
			,@roleid INT
			,@syncLiveCasino BIT
	
	CREATE TABLE #tmpCust (custid INT, syncLiveCasino BIT, roleid INT, UplineID INT)
	
	SELECT @currency = currency 
	FROM custinfo WITH(NOLOCK) 
	WHERE custid = @srecommend 
	
	INSERT INTO #tmpCust(custid,syncLiveCasino,roleid,UplineID)
	SELECT custid, syncLiveCasino, roleid, 
		CASE WHEN roleid = 3 THEN srecommend
			WHEN roleid = 2 THEN mrecommend
			WHEN roleid = 1 THEN recommend  ELSE 0 END
	FROM custinfo ci WITH(NOLOCK) 
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		
	WHILE (1=1)
	BEGIN
		SELECT TOP (1) @custid = custid
			,@roleid = roleid
			,@syncLiveCasino = syncLiveCasino
			,@UplineID = uplineID
		FROM #tmpCust		
		ORDER BY roleid DESC
		
		IF @@ROWCOUNT = 0
			BREAK;
		
		SELECT @StakeLevelList_1701_new = ''
			,@StakeLevelList_1702_new = ''
			,@StakeLevelList_1701 = ''
			,@StakeLevelList_1702 = ''
		
		IF @syncLiveCasino = 1
		BEGIN
			--get stakelevel from LiveCasino
			SELECT @StakeLevelList_1701 = StakeLevelList
			FROM dbo.tmpCustGameType s with(Nolock) 
			WHERE custid = @custid
				AND GameTypeID = 108
				
			SELECT @StakeLevelList_1702 = StakeLevelList
			FROM dbo.tmpCustGameType s with(Nolock) 
			WHERE custid = @custid
				AND GameTypeID = 109	
			
			SELECT @StakeLevelList_1701_new = @StakeLevelList_1701_new + CONVERT(VARCHAR(10),StakeLevelID2) + ','
			FROM (
			SELECT StakeLevelID2
			FROM dbo.tmpStakeLevel WITH(NOLOCK) 
			WHERE stakeLevelID IN (SELECT val FROM strSplit(@StakeLevelList_1701,','))
			)t 
						
			IF @StakeLevelList_1701_new <> ''
			BEGIN
				SELECT @StakeLevelList_1701_new = left(@StakeLevelList_1701_new,len(@StakeLevelList_1701_new) - 1)
			END
			ELSE
			BEGIN
				--apply lowest stake level
				IF @roleid = 4
				BEGIN
					--copy from global setting
					SELECT TOP 1 @StakeLevelList_1701_new = @StakeLevelList_1701_new + CONVERT(VARCHAR(10),StakeLevelID2) + ','
					FROM dbo.tmpStakeLevel WITH(NOLOCK) 
					WHERE ExchangeID = @currency 
						AND GameTypeID = 1701
					ORDER BY MinStake , MaxStake ASC
				END
				ELSE 
				BEGIN
					--copy from uplines
					SELECT @StakeLevelList_1701 = StakeLevelList
					FROM CustGameType WITH(NOLOCK)--GD table 
					WHERE custid = @uplineID
						AND GameTypeID = 1701
					
					--get lowest stake level from upline to apply for customer
					SELECT TOP (1) @StakeLevelList_1701_new = CONVERT(varchar(10),StakeLevelID2)
					FROM dbo.tmpStakeLevel WITH(NOLOCK) 		
					WHERE StakeLevelID IN (SELECT val FROM strSplit(@StakeLevelList_1701,','))
					ORDER BY MinStake, MaxStake ASC
				END
			END
			
			SELECT @StakeLevelList_1702_new = @StakeLevelList_1702_new + CONVERT(VARCHAR(10),StakeLevelID2) + ','
			FROM (
			SELECT StakeLevelID2
			FROM dbo.tmpStakeLevel WITH(NOLOCK) 
			WHERE stakeLevelID IN (SELECT val FROM strSplit(@StakeLevelList_1702,','))
			)t 
			
			
			IF @StakeLevelList_1702_new <> ''
			BEGIN
				SELECT @StakeLevelList_1702_new = left(@StakeLevelList_1702_new,len(@StakeLevelList_1702_new) - 1)
			END
			ELSE 
			BEGIN
			--apply lowest stake level
				IF @roleid = 4
				BEGIN
					--copy from global setting
					SELECT TOP (1) @StakeLevelList_1702_new = @StakeLevelList_1702_new + CONVERT(VARCHAR(10),StakeLevelID2) + ','
					FROM dbo.tmpStakeLevel WITH(NOLOCK) 
					WHERE ExchangeID = @currency 
						AND GameTypeID = 1702
					ORDER BY MinStake , MaxStake ASC
				END
				ELSE 
				BEGIN
					--copy from uplines
					SELECT @StakeLevelList_1702 = StakeLevelList
					FROM CustGameType WITH(NOLOCK)--GD table 
					WHERE custid = @uplineID
						AND GameTypeID = 1702
					
					--get lowest stake level from upline to apply for customer
					SELECT TOP (1) @StakeLevelList_1702_new = CONVERT(varchar(10),StakeLevelID2)
					FROM dbo.tmpStakeLevel WITH(NOLOCK) 		
					WHERE StakeLevelID IN (SELECT val FROM strSplit(@StakeLevelList_1702,','))
					ORDER BY MinStake, MaxStake ASC
				END
			END
			
			INSERT INTO CustGameType(custid,GameTypeID,StakeLevelList)
			SELECT @custid, 1701,@StakeLevelList_1701_new
			UNION 
			SELECT @custid, 1702,@StakeLevelList_1702_new
		END	
		ELSE--Un-sync LCS
		BEGIN
				INSERT INTO CustGameType(custid,GameTypeID,StakeLevelList)
				SELECT @custid, 1701,''
				UNION 
				SELECT @custid, 1702,''
		END	
		DELETE #tmpCust WHERE custid = @custid
	END	
	
	DROP TABLE #tmpCust
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
SELECT custid
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 	
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))


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
SELECT custid
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 	
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))

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
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
 				