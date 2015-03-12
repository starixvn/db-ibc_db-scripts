  /*
	Created: Julien
	Date: 2014-03-12
	Task: Sync Live Casino for some 12bet lines
	DB: DBTXN/CustDB
 */


--Step 1: update SyncLCS for SMA
UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET SyncLiveCasino = 1
where custid in (791081,791087,791088,3575140,860379,1015419,1015420,1015422,1015423,3575260,836212,836214,836215,860383,3575202,1015427,1015429,1015430)

--STEP 2: DEPLOY THIS SP @ DBTRANS.CustDB -----
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@target VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only

	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo') AND type = 'U'
		) <> 1 RETURN 
	
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET SyncLiveCasino = 1
	where recommend in (791088,836215,860379,860383,1015422,1015423,1015430,3575140,3575202,3575260)		
		and roleid = 1	 
   
END
GO

-- STEP 3: RUN THIS SCRIPT with @target = 'REPLICATED' -----
EXEC dbo.Acc_ExecRep_Cust_09 @target = 'REPLICATED'	

GO

-- STEP 4: RUN THIS SCRIPT with @target = 'DBTRANS'
EXEC dbo.Acc_ExecRep_Cust_09 @target = 'DBTRANS'	

GO