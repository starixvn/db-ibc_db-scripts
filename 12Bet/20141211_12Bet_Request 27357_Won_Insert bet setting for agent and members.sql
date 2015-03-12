/*
	Created: Susan
	Date: 2014-12-11
	Site: 12Bet 
	Currency: Won
	Task: insert settings for agent 12BETWON02 (14551801) , 12BETWON04 (14554801) from 12BETWON02 and upline under agent 12BETWON02 from 12967981
	DB: DBTXN/CustDB
*/ 
-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@recommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType') AND type = 'U' ) <> 2
		RETURN

------insert setting for  agent  12BETWON02 (14551801),   12BETWON04 (14554801) -copy from agent 12BETWON01: 18 rows effected

insert INTO [CustGameType](custid
     , [GameTypeID]
     ,[StakeLevelList]
     ,[MaxPerGameType]
     ,[MinBet]
     ,[MaxBet]
     ,[IsDisabled])
  SELECT @recommend as custid 
     , [GameTypeID]
     ,[StakeLevelList]
     ,[MaxPerGameType]
     ,[MinBet]
     ,[MaxBet]
     ,[IsDisabled]
    FROM [CustGameType] cg WITH(NOLOCK)
 where cg.CustID =6006340  --12BETWON01
 
 --- coppy setting for member under agent 12BETWON02 (14551801) base on 12BETWON01001 :  3483 rows effected
   insert INTO [CustGameType](custid
     , [GameTypeID]
     ,[StakeLevelList]
     ,[MaxPerGameType]
     ,[MinBet]
     ,[MaxBet]
     ,[IsDisabled])
 SELECT ci.custid
     , [GameTypeID]
     ,[StakeLevelList]
     ,[MaxPerGameType]
     ,[MinBet]
     ,[MaxBet]
     ,[IsDisabled]
    FROM [CustGameType] cg WITH(NOLOCK),
   custInfo ci WITH(NOLOCK) 
 where ci.recommend =@recommend --agent 12BETWON02
  and ci.roleid = 1
  and cg.custid =12967981-- member 12BETWON01001

End
GO

-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------	


-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #agents (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @recommend INT, @site varchar (50), @currency int 
SELECT   @site='12Bet',
		 @currency=45,
		 @max_custid= xxx ---input maxcustid

INSERT INTO #agents(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE srecommend  IN (select custid from Dep_CustSuper with(nolock) 
										where site=@site and currency=@currency)
						and mrecommend not in (select custid from custInfo with(nolock) where username like '%Acc%')
	 AND roleid=2
	 AND CUSTID <> 6006340
	 AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #agents
	SET isfinished = 1
		,@recommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @recommend = @recommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
	
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #agents		
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #agents (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @recommend INT, @site varchar (50), @currency int 

SELECT   @site='12Bet',
		 @currency=45,
		 @max_custid= xxx ---input maxcustid

INSERT INTO #agents(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE srecommend  IN (select custid from Dep_CustSuper with(nolock) 
										where site=@site and currency=@currency)
						and mrecommend not in (select custid from custInfo with(nolock) where username like '%Acc%')
	and roleid=2
	and custid<>6006340
	AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #agents
	SET isfinished = 1
		,@recommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @recommend = @recommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
	
	WAITFOR DELAY '00:00:00.280'			
END		

DROP TABLE #agents		
GO		


-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------