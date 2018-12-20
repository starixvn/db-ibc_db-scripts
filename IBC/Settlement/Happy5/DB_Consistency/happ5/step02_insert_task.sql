/*
	Created: Vicky
	Task: insert task for Happy5
	DB: DBTP/bodb_Consistency
	Date: 20181019
*/
USE [bodb_Consistency]
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------
SET IDENTITY_INSERT DBA_Tasks ON

INSERT INTO DBA_Tasks (TaskId, RuleId, Command)
VALUES
	--PT
	 (19,2,'EXEC dbo.DBA_Consistency_PTChecking_NotDelegateMatchId @ProductId = 164, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	 
	 --stake
	,(20,3,'EXEC dbo.DBA_Consistency_StakeChecking_NotDelegateMatchId @ProductId = 164, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--IP
	,(21,4,'EXEC dbo.DBA_Consistency_IPChecking_NotDelegateMatchId @ProductId = 164, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--Check all yesterday tickets must be settled
	,(22,5,'EXEC dbo.DBA_Consistency_StatusChecking_NotDelegateMatchId @ProductId = 164, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--check betteam
	,(23,15,'EXEC dbo.DBA_Consistency_SpecificRulesChecking_NotDelegateMatchId @ProductId = 164, @Rule = ''betteam'' , @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--check comm, discount
	,(24,16,'EXEC dbo.DBA_Consistency_SpecificRulesChecking_NotDelegateMatchId @ProductId = 164, @Rule = ''no_discount_comm'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
SET IDENTITY_INSERT DBA_Tasks OFF