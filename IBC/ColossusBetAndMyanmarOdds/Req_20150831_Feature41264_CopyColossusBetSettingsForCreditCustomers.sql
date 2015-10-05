
/*
Created: Helen
Date: 2015-08-31
Task: Copy Colossus Bet settings for credit customers - [Redmine: #41264]
DB: DBTXN/CustDB
*/

-- FOR TESTING ONLY
/*
EXEC [Acc_ExecRep_Cust_09] @srecommend = 18762145, @maxcustid = 30000000

CREATE NONCLUSTERED INDEX [inx_srecommend_temp]
ON [dbo].[custInfo]([srecommend],[custid])
INCLUDE ([roleid],[mrecommend],[recommend])

*/

-- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.CustDB ------
GO
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
(
	@srecommend INT	
	, @maxcustid INT = 0
	, @target VARCHAR(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only

	IF (SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo')) <> 1
		RETURN

	IF NOT EXISTS (SELECT 1 FROM CustInfo WITH (NOLOCK) WHERE custid = @srecommend )
		RETURN

	IF (SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('AgentCommRate','CustCommRate') AND type = 'U' ) <> 2
		RETURN

	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET DisableColossusBet = 0,
		HideColossusBet = 0
	WHERE custid = @srecommend
		AND custid <= @maxcustid
		
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET DisableColossusBet = 0,
		HideColossusBet = 0
	WHERE srecommend = @srecommend
		AND custid <= @maxcustid

	IF NOT EXISTS (SELECT 1 FROM dbo.AgentCommRate WITH (NOLOCK) WHERE CustId = @srecommend)
	BEGIN
		INSERT INTO dbo.AgentCommRate WITH (ROWLOCK) (CustID,SportType,BetType,CommRate) 
		SELECT @srecommend,204,18001,0
		UNION ALL 
		SELECT @srecommend,204,18002,0
	END
	IF @@ERROR <> 0
	BEGIN
		-- ROLLBACK MANUALLY
		DELETE AgentCommRate WITH (ROWLOCK) WHERE custId  = @srecommend
		--SELECT @ErrCode=116
		RETURN
	END
	
	CREATE TABLE #tmpCust (custid INT, roleid INT, UplineID INT,srecommend INT,mrecommend INT,recommend INT,Row_Index INT)
	
	INSERT INTO #tmpCust(Custid,Roleid,UplineID,srecommend,mrecommend,recommend,Row_Index)
	SELECT  custid
			, roleid
			, CASE 
					WHEN roleid = 3 THEN srecommend
					WHEN roleid = 2 THEN mrecommend
					WHEN roleid = 1 THEN recommend  
					ELSE 0 
			  END AS UplineID
			, srecommend
			, mrecommend
			, recommend
			, ROW_NUMBER() OVER (ORDER BY ci.roleid DESC,ci.CustID) AS Row_Index	
	FROM custinfo ci WITH(NOLOCK) 
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
	
	DECLARE @minRow INT = 1
	DECLARE @maxRow INT = 0

	DECLARE   @custid INT
			, @srecommend_tmp INT
			, @mrecommend_tmp INT
			, @recommend_tmp INT
			, @uplineID INT
			, @roleid INT

	CREATE INDEX inx_Row_Index ON #tmpCust(Row_Index)

	SET @maxRow = (SELECT MAX(Row_Index) FROM #tmpCust)

	WHILE @minRow <= @maxRow
	BEGIN
		SELECT @custid = custid
			, @roleid = roleid
			, @UplineID = uplineID
			, @srecommend_tmp = srecommend
			, @mrecommend_tmp = mrecommend
			, @recommend_tmp = recommend
		FROM #tmpCust		
		WHERE Row_Index = @minRow
		
		IF @roleid IN (2,3)
		BEGIN
			IF EXISTS (SELECT 1 FROM AgentCommRate WITH (NOLOCK) WHERE CustID = @UplineID AND SportType = 204)
			BEGIN
				INSERT INTO dbo.AgentCommRate WITH (ROWLOCK)(CustID,SportType,BetType,CommRate) 
				SELECT @custid,204,18001,0
				UNION ALL 
				SELECT @custid,204,18002,0
			END	
			
			IF @@ERROR <> 0
			BEGIN
				-- ROLLBACK MANUALLY
				DELETE AgentCommRate WITH (ROWLOCK) WHERE custId  = @custid
				--SELECT @ErrCode=116
				RETURN
			END

		END
		IF @roleid = 1
		BEGIN
			
			SELECT @CustID AS CustID,AC.SportType,AC.BetType,AC.CommRate,CI.roleid 
			INTO #CustCommRate_temp
			FROM AgentCommRate ac WITH (ROWLOCK)
				JOIN custInfo ci WITH (ROWLOCK) ON ac.CustID = ci.custid
			WHERE ac.CustID IN (@srecommend_tmp,@mrecommend_tmp,@recommend_tmp)
			
			INSERT INTO CustCommRate (CustID,SportType,BetType,sdiscount,adiscount,discount,playerdiscount)
			SELECT CustID,SportType,BetType,T.[4],T.[3],T.[2],0
			FROM #CustCommRate_temp
			PIVOT(
				SUM(CommRate)
				FOR roleID IN ([2],[3],[4])
			) AS T
			
			IF @@ERROR <> 0
			BEGIN
				-- ROLLBACK MANUALLY
				DELETE CustCommRate WITH (ROWLOCK) WHERE custId  = @custid
				--SELECT @ErrCode=116
				RETURN	
			END
			
			DROP TABLE #CustCommRate_temp	
			
		END
		
		SET @minRow = @minRow + 1	
	END
			      	
	DROP TABLE #tmpCust	
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------

CREATE TABLE #supers (custid INT, isfinished BIT DEFAULT(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = 100 --XX

INSERT INTO #supers(custid)
SELECT custid
FROM CustInfo CI WITH(NOLOCK)
WHERE roleid = 4 
	AND currency = 20 
	AND NOT EXISTS (SELECT 1 FROM Dep_CustSuper CS WITH(NOLOCK) WHERE CS.custid = CI.custid)
	--AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
END	
DROP TABLE #supers		
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished BIT DEFAULT(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = 100 --XX

INSERT INTO #supers(custid)
SELECT custid
FROM CustInfo CI WITH(NOLOCK)
WHERE roleid = 4 
	AND currency = 20 
	AND NOT EXISTS (SELECT 1 FROM Dep_CustSuper CS WITH(NOLOCK) WHERE CS.custid = CI.custid)
	--AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
END	

DROP TABLE #supers		
		
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-----------------------------------------------------------------------------------
