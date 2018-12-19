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
	 (19,2,'EXEC dbo.DBA_Consistency_PTChecking @ProductId = 164, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	 
	 --stake
	,(20,3,'EXEC dbo.DBA_Consistency_StakeChecking @ProductId = 163, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--IP
	,(21,4,'EXEC dbo.DBA_Consistency_IPChecking @ProductId = 163, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--Check all yesterday tickets must be settled
	,(22,5,'EXEC dbo.DBA_Consistency_StatusChecking @ProductId = 163, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--check betteam
	,(23,15,'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 163, @Rule = ''betteam'' , @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	--check comm, discount
	,(24,16,'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 163, @Rule = ''discount_comm'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
	
	