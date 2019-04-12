Use CUSTDB 
GO 

/*
Create : 20190410@Sophia
Task: CN88 - UAT - initial script for ExtraPT  [redmine: #111696]
DB: DBCUST.CUSTDB

*/
  

--- Insert global extraPT by Product Acc_GroupExtraPT_Product

	DECLARE @Date DATE
	SELECT @Date = GetDate()



	DECLARE @ErrCode INT, @ErrMsg NVARCHAR(200)  
	  
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 15552859  ,   --- starix26
		@GroupId = 28,
		@ProductId = 1,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, '28'
	 	 
 
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 15552859  ,   --- starix26
		@GroupId = 29,
		@ProductId = 1,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, '29'	
	 
	 
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 15552859  ,   --- starix26
		@GroupId = 30,
		@ProductId = 1,
		@ExtraPT = 0.00,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, '30'	