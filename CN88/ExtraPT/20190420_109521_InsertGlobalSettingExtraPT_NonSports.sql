Use CUSTDB 
GO 

/*
Create : 20190420@Sophia
Task: CN88 - Initial script for ExtraPT - NON Sports  [redmine: #109521]
DB: DBCUST.CUSTDB

*/
  

--- Insert global extraPT by Product Acc_GroupExtraPT_Product

	DECLARE @Date DATE
	SELECT @Date = GetDate()

	DECLARE @ErrCode INT, @ErrMsg NVARCHAR(200)  
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 15552859  ,   --- starix26
		@GroupId = 27,
		@ProductId = 3,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, '27'
	
	
	  
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 15552859  ,   --- starix26
		@GroupId = 28,
		@ProductId = 3,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, '28'
	 	 
 
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 15552859  ,   --- starix26
		@GroupId = 29,
		@ProductId = 3,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, '29'	
	 
	 
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 15552859  ,   --- starix26
		@GroupId = 30,
		@ProductId = 3,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, '30'	