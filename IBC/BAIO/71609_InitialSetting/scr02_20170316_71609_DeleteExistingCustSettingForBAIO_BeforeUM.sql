
/*
	Created: Helen
	Date: 20170316 - https://nexdev.net/issues/71609
	Task: Delete existing CustSetting 
	DB: DBCust/CustDB
*/
 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbcust only
	
	IF dbo.f_CheckRepTable('CustSetting') = 0 RETURN
	IF dbo.f_CheckRepTable('custoverride') = 0 RETURN
			
	DELETE cg
	FROM CustSetting cg WITH(UPDLOCK,ROWLOCK)		
	WHERE SportType = 2 AND bettype = 9999
	
	DELETE cg
	FROM custoverride cg WITH(UPDLOCK,ROWLOCK)		
	WHERE SportType = 2 AND bettype = 9999

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

