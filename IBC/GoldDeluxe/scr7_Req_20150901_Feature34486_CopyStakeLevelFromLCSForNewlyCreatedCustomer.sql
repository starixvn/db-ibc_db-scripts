/*
	Created: Johnson
	Date: 2015-09-01
	Task: copy stake level for newly created customers
	DB: DBCust.CustDB
*/ 

--step 0: backup & copy stake level setting from LCS DB to DBTP for newly customers

CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 	
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
GO

--step 1: copy settings for newly created customers
CREATE TABLE #tmpCust (custid INT, roleid INT, syncLiveCasino BIT, uplineID INT)

DECLARE @StakeLevelList_1701 VARCHAR(50)= ''
		,@StakeLevelList_1702 VARCHAR(50)= ''
		,@StakeLevelList_1701_new VARCHAR(50)= ''
		,@StakeLevelList_1702_new VARCHAR(50)= ''
		,@currency INT
		,@custid INT
		,@uplineID INT
		,@roleid INT
		,@syncLiveCasino BIT
		,@max_custid INT
		,@max_custid2 INT

SELECT @max_custid = xx
		,@max_custid2 = yy	

INSERT INTO #tmpCust(custid, roleid, syncLiveCasino, uplineID)
SELECT DISTINCT ci.custid, roleid, syncLiveCasino,
		CASE WHEN roleid = 3 THEN srecommend
			WHEN roleid = 2 THEN mrecommend
			WHEN roleid = 1 THEN recommend  ELSE 0 END
FROM custinfo ci WITH(NOLOCK)
	LEFT JOIN custgameType cg WITH(NOLOCK) ON ci.custid = cg.custid
											AND cg.GameTypeID IN (1701,1702)
WHERE srecommend IN (select custid FROM #Supers)
	AND ci.custid > @max_custid
	AND ci.custid <= @max_custid2
	AND cg.custid IS NULL


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
		SELECT t.custid, t.GameTypeID, t.StakeLevel
		FROM(
			SELECT @custid as custid , 1701 as GameTypeID ,@StakeLevelList_1701_new as StakeLevel
			UNION 
			SELECT @custid, 1702,@StakeLevelList_1702_new
		)t
		LEFT JOIN custGameType cg WITH(NOLOCK) ON t.custid = cg.custid AND t.GameTypeID =cg.GameTypeID
		WHERE cg.custid IS NULL
	END	
	ELSE--Un-sync LCS
	BEGIN
			INSERT INTO CustGameType(custid,GameTypeID,StakeLevelList)
			SELECT t.custid, t.GameTypeID, t.StakeLevel
			FROM(
				SELECT @custid as custid , 1701 as GameTypeID ,'' as StakeLevel
				UNION 
				SELECT @custid, 1702,''
			)t
			LEFT JOIN custGameType cg WITH(NOLOCK) ON t.custid = cg.custid AND t.GameTypeID =cg.GameTypeID
			WHERE cg.custid IS NULL
	END	
	
	DELETE #tmpCust WHERE custid = @custid
END	


