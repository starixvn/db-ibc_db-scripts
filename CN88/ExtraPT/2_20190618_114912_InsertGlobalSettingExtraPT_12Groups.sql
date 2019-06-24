Use CUSTDB 
GO 

/*
Create : 20190420@Sophia
Task: CN88 - Initial script for ExtraPT - SB and Non Sport [redmine: #114912]
DB: DBCUST.CUSTDB

*/
  

--- Insert global extraPT by Product Acc_GroupExtraPT_Product

	DECLARE @Date DATE
	SELECT @Date = GetDate()

	DECLARE @ErrCode INT, @ErrMsg NVARCHAR(200) 
	
	
	
	--------------- SB 
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 31,  ---- CN88_01     
		@ProductId = 1,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_01'
	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 32,     ---CN88_02 
		@ProductId = 1,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_02'
	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 33,  ---CN88_03 
		@ProductId = 1,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_03'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 34, ---CN88_10 
		@ProductId = 1,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_10'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 35, ---CN88_12
		@ProductId = 1,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_12'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 36,   -- CN88_13
		@ProductId = 1,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_13'
	

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 37,   -- CN88_20
		@ProductId = 1,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_20'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 38,   -- CN88_21
		@ProductId = 1,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_21'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 39,   -- CN88_23
		@ProductId = 1,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_23'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 40,   -- CN88_30
		@ProductId = 1,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_30'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 41,   -- CN88_31
		@ProductId = 1,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_31'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 42,   -- CN88_32
		@ProductId = 1,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_32'	
	
	
	
	----NumberGame 
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 31,  ---- CN88_01     
		@ProductId = 3,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_01'	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 32,     ---CN88_02 
		@ProductId = 3,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_02'
	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 33,  ---CN88_03 
		@ProductId = 3,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_03'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 34, ---CN88_10 
		@ProductId = 3,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_10'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 35, ---CN88_12
		@ProductId = 3,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_12'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 36,   -- CN88_13
		@ProductId = 3,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_13'
	

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 37,   -- CN88_20
		@ProductId = 3,
		@ExtraPT = 0 ,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_20'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 38,   -- CN88_21
		@ProductId = 3,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_21'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 39,   -- CN88_23
		@ProductId = 3,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_23'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 40,   -- CN88_30
		@ProductId = 3,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_30'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 41,   -- CN88_31
		@ProductId = 3,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_31'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 42,   -- CN88_32
		@ProductId = 3,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_32'	
	
	--------5	Virtual Sports
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 31,  ---- CN88_01     
		@ProductId = 5,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_01'	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 32,     ---CN88_02 
		@ProductId = 5,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_02'	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 33,  ---CN88_03 
		@ProductId = 5,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_03'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 34, ---CN88_10 
		@ProductId = 5,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_10'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 35, ---CN88_12
		@ProductId = 5,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_12'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 36,   -- CN88_13
		@ProductId = 5,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_13'
	

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 37,   -- CN88_20
		@ProductId = 5,
		@ExtraPT = 0 ,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_20'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 38,   -- CN88_21
		@ProductId = 5,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_21'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 39,   -- CN88_23
		@ProductId = 5,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_23'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 40,   -- CN88_30
		@ProductId = 5,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_30'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 41,   -- CN88_31
		@ProductId = 5,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_31'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 42,   -- CN88_32
		@ProductId = 5,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_32'	
	
	--------8	Keno
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 31,  ---- CN88_01     
		@ProductId = 8,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_01'	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 32,     ---CN88_02 
		@ProductId = 8,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_02'
	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 33,  ---CN88_03 
		@ProductId = 8,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_03'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 34, ---CN88_10 
		@ProductId = 8,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_10'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 35, ---CN88_12
		@ProductId = 8,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_12'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 36,   -- CN88_13
		@ProductId = 8,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_13'
	

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 37,   -- CN88_20
		@ProductId = 8,
		@ExtraPT = 0 ,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_20'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 38,   -- CN88_21
		@ProductId = 8,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_21'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 39,   -- CN88_23
		@ProductId = 8,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_23'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 40,   -- CN88_30
		@ProductId = 8,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_30'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 41,   -- CN88_31
		@ProductId = 8,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_31'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 42,   -- CN88_32
		@ProductId = 8,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_32'	
	
	--------27	Virtual Sports 2
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 31,  ---- CN88_01     
		@ProductId = 27,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_01'	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 32,     ---CN88_02 
		@ProductId = 27,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_02'
	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 33,  ---CN88_03 
		@ProductId = 27,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_03'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 34, ---CN88_10 
		@ProductId = 27,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_10'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 35, ---CN88_12
		@ProductId = 27,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_12'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 36,   -- CN88_13
		@ProductId = 27,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_13'
	

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 37,   -- CN88_20
		@ProductId = 27,
		@ExtraPT = 0 ,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_20'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 38,   -- CN88_21
		@ProductId = 27,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_21'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 39,   -- CN88_23
		@ProductId = 27,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_23'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 40,   -- CN88_30
		@ProductId = 27,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_30'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 41,   -- CN88_31
		@ProductId = 27,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_31'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 42,   -- CN88_32
		@ProductId = 27,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_32'	
	
	--------28	Lottery
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 31,  ---- CN88_01     
		@ProductId = 28,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_01'	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 32,     ---CN88_02 
		@ProductId = 28,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_02'
	
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 33,  ---CN88_03 
		@ProductId = 28,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_03'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 34, ---CN88_10 
		@ProductId = 28,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_10'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 35, ---CN88_12
		@ProductId = 28,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_12'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 36,   -- CN88_13
		@ProductId = 28,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_13'
	

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 37,   -- CN88_20
		@ProductId = 28,
		@ExtraPT = 0 ,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_20'
	
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 38,   -- CN88_21
		@ProductId = 28,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_21'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 39,   -- CN88_23
		@ProductId = 28,
		@ExtraPT = 0.03,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_23'
	
	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 40,   -- CN88_30
		@ProductId = 28,
		@ExtraPT = 0,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_30'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 41,   -- CN88_31
		@ProductId = 28,
		@ExtraPT = 0.01,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_31'

	EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 10278938  ,   --- starixIT
		@GroupId = 42,   -- CN88_32
		@ProductId = 28,
		@ExtraPT = 0.02,
		@EffectiveDate = @Date,
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg, 'CN88_32'	