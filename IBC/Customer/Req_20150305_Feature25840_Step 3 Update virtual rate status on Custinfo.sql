 /*
	Created: Johnson
	Date: 2015-03-05
	Task: Virtual Rate - Separate setting into sport types and bet types
	DB: DBTXN/CustDB
	
	Steps:
		RUN AT UM: Update virtual rate status on custinfo
			if VirtualMultiplier = 1 update VirtualMultiplier= 0--disabled
			else update VirtualMultiplier= 1
*/  

 -- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.CustDB ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@target		VARCHAR(20)='',
	@srecommend INT
AS
BEGIN	 
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
		
		
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('CustInfo') AND type = 'U'
		) <> 1
	RETURN
	 
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
	SET VirtualMultiplier = CASE WHEN VirtualMultiplier = 1 THEN 0 ELSE 1 END
	WHERE srecommend = @srecommend
		AND custid <= @maxcustid
		AND ci.custid <> 1176092 --member01 : testing account
		AND ci.recommend <> 14228863 --STAFFTWPG
	
END
GO

-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----) -----
--------------------------------------------------------------------------------------
 

CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where roleid = 4	


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend			
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT

INSERT INTO #supers(custid)
SELECT custid
FROM custInfo ci with(nolock) 
where roleid = 4	


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend			
			,@target =  'DBTRANS'
END			
GO		

-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-----------------------------------------------------------------------------------
