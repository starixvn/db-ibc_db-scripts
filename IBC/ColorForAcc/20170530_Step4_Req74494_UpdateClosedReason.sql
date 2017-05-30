
/*
	Created: Winnie	
	Task:  Update ClosedReason on CustLoginInfo,CustLoginInfo_Member
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
		
		WHILE EXISTS (SELECT TOP 1 1 FROM CustLoginInfo c1 WITH(NOLOCK)
											INNER JOIN TempClosedReason T1 WITH(NOLOCK)  ON c1.CustID=t1.CustID WHERE c1.ClosedReason IS NULL)
		BEGIN
			UPDATE TOP (10000)  c
			SET   c.ClosedReason=ISNULL(t.ClosedReason,0)
			FROM CustLoginInfo c WITH(ROWLOCK,UPDLOCK)
			INNER JOIN TempClosedReason t WITH(NOLOCK) ON c.CustID=t.CustID
		END

		WHILE EXISTS (SELECT TOP 1 1 FROM CustLoginInfo_Member c1 WITH(NOLOCK)
											INNER JOIN TempClosedReasonMember T1 WITH(NOLOCK)  ON c1.CustID=t1.CustID WHERE c1.ClosedReason IS NULL)
		BEGIN
			UPDATE TOP (10000)  c
			SET c.ClosedReason=ISNULL(t.ClosedReason,0)
			FROM CustLoginInfo_Member c WITH(ROWLOCK,UPDLOCK)
			INNER JOIN TempClosedReasonMember t WITH(NOLOCK) ON c.CustID=t.CustID
		END

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------

	EXEC dbo.Acc_CustSetting3rd_19 			
			@target = 'REPLICATED'


-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------

	EXEC dbo.Acc_CustSetting3rd_19 		
			@target = 'DBCUST'	
	
