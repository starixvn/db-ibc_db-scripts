/*
	Created: Winnie
	Date: 2017-05-03
	Task: Delete existing colossus settings for deposit customers
	DB: DBCUST/CustDB
*/ 


 
ALTER PROCEDURE [dbo].Acc_CustSetting3rd_19
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbcust only
	
	IF dbo.f_CheckRepTable('Dep_AgentCommRate') = 0 RETURN
	IF dbo.f_CheckRepTable('Dep_CustCommRate') = 0 RETURN			
	DELETE cg
	FROM Dep_AgentCommRate cg WITH(UPDLOCK,ROWLOCK)	
	INNER JOIN custInfo c WITH(NOLOCK) ON cg.CustID=c.custid	
	WHERE SportType = 204 AND srecommend IN (SELECT custid FROM Dep_CustSuper cs WITH(NOLOCK)							
															WHERE cs.site IN ('Sun988'))
						
	DELETE cg
	FROM Dep_CustCommRate cg WITH(UPDLOCK,ROWLOCK)		
	INNER JOIN custInfo c WITH(NOLOCK) ON cg.CustID=c.custid	
	WHERE SportType = 204 AND srecommend IN (SELECT custid FROM Dep_CustSuper cs WITH(NOLOCK)							
															WHERE cs.site IN ('Sun988'))
	
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
EXEC dbo.Acc_CustSetting3rd_19 @target = 'REPLICATED'


-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
EXEC dbo.Acc_CustSetting3rd_19 @target = 'DBCUST'




