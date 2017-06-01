
/*
	Created: Winnie	
	Task:  Update ClosedReason on CustLoginInfoMember
	DB: DBCUST/CustDB, DB06/bodb02
	Date: 20170523
*/ 
ALTER PROCEDURE [dbo].Acc_CustSetting3rd_19	
	@target VARCHAR(20)		
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only

	IF NOT (dbo.f_CheckRepTable('CustLoginInfo') = 1 AND  dbo.f_CheckRepTable('CustLoginInfo_Member') = 1 )
		RETURN	
	DECLARE  @MinCust INT = 0, @MaxCust INT = 0, @CrrCust INT

	SELECT @MinCust =  MIN(Custid) FROM TempClosedReasonMember
	SELECT @MaxCust =  MAX(Custid) FROM TempClosedReasonMember
	WHILE (@MinCust <= @MaxCust)
	BEGIN				
			UPDATE c SET c.ClosedReason= ISNULL(t.ClosedReason,0)
			FROM dbo.CustLoginInfo_Member c WITH (ROWLOCK, UPDLOCK)
			INNER JOIN TempClosedReasonMember t WITH(NOLOCK) ON c.CustID=t.CustID				
			WHERE  t.CustID BETWEEN @MinCust AND @CrrCust

			SELECT TOP 10000 @CrrCust = Custid  
			FROM TempClosedReason WHERE CustID>@MinCust

			SELECT @MinCust=@CrrCust+1		
			
		WAITFOR DELAY '00:00:00.300'
	END		

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
------------------------------------------------------------------------------------
			
	EXEC Acc_CustSetting3rd_19 @target = 'REPLICATED'


-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------			
	EXEC Acc_CustSetting3rd_19 @target = 'DBCUST'
