
/*
	Created: Winnie	
	Task:  Update ClosedReason on CustLoginInfo_Member
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
	DECLARE  @CurrRow INT = 1	, @RowPerBatch INT = 10000, @RowCount INT = 0, @ErrMsg VARCHAR(50)

		SELECT @RowCount = @@rowcount

			WHILE (@CurrRow <= @RowCount)
			BEGIN				
					UPDATE c SET c.ClosedReason= ISNULL(t.ClosedReason,0)
					FROM dbo.CustLoginInfo c WITH (ROWLOCK, UPDLOCK)
					INNER JOIN TempClosedReason t WITH(NOLOCK) ON c.CustID=t.CustID				
					WHERE t.RowNo BETWEEN @CurrRow AND (@CurrRow + @RowPerBatch - 1)

					IF (@@ERROR <> 0)
					BEGIN
						SELECT @ErrMsg = 'Could not update'
						RETURN
					END				

				SELECT @CurrRow = @CurrRow + @RowPerBatch

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
