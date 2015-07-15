 /*
	Created: Johnson
	Task: copy pt & comm for Gold Deluxe from Live Casino
	DB: DBTXN/CustDB
	Date: 20150618
*/ 
 ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
	,@hideGoldDeluxe BIT
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo')) <> 1
		RETURN
		
	--update status for Gold Deluxe
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET DisableGoldDeluxe = @hideGoldDeluxe,
		HideGoldDeluxe = @hideGoldDeluxe
	WHERE srecommend = @srecommend
		AND custid <= @maxcustid
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('CustSettingGame') AND type = 'U' ) <> 1
		RETURN
		
	INSERT INTO [dbo].[CustSettingGame]
           ([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[autopositiontaking]
           ,[isautopositiontaking]
           ,[autompositiontaking]
           ,[isautompositiontaking])
	SELECT cs.[CustID]
           ,1701 as [Bettype]
           ,255 as [Sporttype]
           ,CASE WHEN SyncLiveCasino = 1 THEN [apositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [mpositiontaking] ELSE 0 END 
           ,CASE WHEN SyncLiveCasino = 1 THEN [spositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [playerdiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [discount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [adiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [sdiscount] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [autopositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [isautopositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [autompositiontaking] ELSE 0 END
           ,CASE WHEN SyncLiveCasino = 1 THEN [isautompositiontaking] ELSE 0 END
	FROM  CustSettingGame cs WITH(NOLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cs.sporttype = 162
		AND cs.bettype = 1101  
	       
	
	INSERT INTO [dbo].[CustOverrideGame]
           ([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[minpositiontaking])
	SELECT cs.[CustID]
           ,1701 as [Bettype]
           ,255 as [Sporttype]
           ,CASE WHEN SyncLiveCasino = 1 THEN [minpositiontaking] ELSE 0 END          
    FROM  CustOverrideGame cs WITH(NOLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cs.sporttype = 162
		AND cs.bettype = 1101  
	
	DECLARE @apos SMALLMONEY,
			@mpos SMALLMONEY
	
	UPDATE cs
	SET @apos = CASE WHEN apositiontaking > 0.93 THEN 0.93 ELSE apositiontaking END,
		apositiontaking = @apos,
		@mpos = CASE WHEN @apos + mpositiontaking > 0.93 THEN 0.93- @apos ELSE mpositiontaking END,
		mpositiontaking = @mpos,
		spositiontaking = CASE WHEN @apos + @mpos + spositiontaking > 0.93 THEN 0.93 - @mpos -@apos ELSE spositiontaking END
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.roleid = 1
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND spositiontaking + mpositiontaking + apositiontaking > 0.93
		
	UPDATE cs
	SET @apos = CASE WHEN apositiontaking > 0.93 THEN 0.93 ELSE apositiontaking END,
		apositiontaking = @apos,
		mpositiontaking = CASE WHEN @apos + mpositiontaking > 0.93 THEN 0.93- @apos ELSE mpositiontaking END		
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.roleid = 2
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND mpositiontaking + apositiontaking > 0.93	
	
	UPDATE cs
	SET @mpos = CASE WHEN mpositiontaking > 0.93 THEN 0.93 ELSE mpositiontaking END,
		mpositiontaking = @mpos,
		spositiontaking = CASE WHEN spositiontaking + @mpos > 0.93 THEN 0.93 - @mpos ELSE spositiontaking END 		
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.roleid = 3
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND mpositiontaking + spositiontaking > 0.93	
		
	UPDATE cs
	SET spositiontaking = CASE WHEN spositiontaking > 0.93 THEN 0.93 ELSE spositiontaking END 		
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.custid = @srecommend		
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND spositiontaking > 0.93	
		
END
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	



---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, hideGoldDeluxe BIT, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT, @hideGoldDeluxe BIT

SELECT @max_custid = xx

INSERT INTO #supers(custid, hideGoldDeluxe)
SELECT custid, CASE WHEN SyncLiveCasino = 1 THEN 0 ELSE 1 END
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 
	AND currency = 20 
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid		
		,@hideGoldDeluxe = hideGoldDeluxe		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			,@hideGoldDeluxe = @hideGoldDeluxe
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------
 
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, hideGoldDeluxe bit, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT,@hideGoldDeluxe BIT

SELECT @max_custid = xx

INSERT INTO #supers(custid,hideGoldDeluxe)
SELECT custid, CASE WHEN SyncLiveCasino = 1 THEN 0 ELSE 1 END
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 
	AND currency = 20 
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid
		,@hideGoldDeluxe = hideGoldDeluxe			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
			,@hideGoldDeluxe = @hideGoldDeluxe
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-----------------------------------------------------------------------------------
 				