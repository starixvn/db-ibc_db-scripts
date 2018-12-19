/*
	Created: Vicky
	Task: insert task for Happy5
	DB: DBTXN/bodb02
	Date: 20181019
*/
USE [bodb_Consistency]
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBA_Tasks (TaskId, RuleId, Command)
VALUES
	--PT
	 (25,2,'EXEC dbo.DBA_Consistency_PTChecking @ProductId = 161, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	 
	 --stake
	,(26,3,'EXEC dbo.DBA_Consistency_StakeChecking @ProductId = 161, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--IP
	,(27,4,'EXEC dbo.DBA_Consistency_IPChecking @ProductId = 161, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--Check all yesterday tickets must be settled
	,(28,5,'EXEC dbo.DBA_Consistency_StatusChecking @ProductId = 161, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--check betteam
	,(29,15,'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 161, @Rule = \'betteam\' , @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--check comm, discount
	,(30,16,'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 161, @Rule = \'discount_comm\', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')