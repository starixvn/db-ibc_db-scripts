/*
	Created: Winnie
	Date: 2016-09-13
	Task: Insert colossus settings for credit customers
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------

ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	--@srecommend INT	
	--,
	@target VARCHAR(30)
	--,@maxcustid INT
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
			AND dbo.f_CheckRepTable('AgentCommRate') = 1
			AND dbo.f_CheckRepTable('CustCommRate') = 1
			)
		RETURN		
		
	DELETE b
	FROM custInfo a WITH(NOLOCK) 
	INNER JOIN AgentCommRate b WITH(NOLOCK) ON a.custid=b.custid
	WHERE Sporttype=204 --AND a.srecommend = @srecommend AND  a.custid <= @maxcustid AND Enabled=1
	
			
	DELETE b
	FROM custInfo a WITH(NOLOCK) 
	INNER JOIN CustCommRate b WITH(NOLOCK) ON a.custid=b.custid
	WHERE Sporttype=204 --AND a.srecommend = @srecommend AND  a.custid <= @maxcustid AND Enabled=1
		
	
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
--------------------------------------------------------------------------------------




	EXEC dbo.[Acc_CustSetting3rd_19] --@srecommend = @srecommend
			--,@maxcustid = @max_custid
			--,
			@target = 'REPLICATED'
	
	WAITFOR DELAY '00:00:00.280'			
	
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------

	EXEC dbo.[Acc_CustSetting3rd_19] 
			
			@target = 'DBCUST'
	
			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------

