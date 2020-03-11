USE CUSTDB
GO 

/*
Create: 20200311@Sophia
Task: Create ExtraPT group for CN88_01.. CN88_55 [Redmind: 129665]
DB: DBCUST.CustDB

*/

DECLARE @EffectiveDate DATETIME = '2020-03-23'
,@EndDate DATETIME= '9999-12-31'
,@UserId INT = 10278938 -- -StarixIT  


DECLARE @P7 INT
DECLARE @P8 NVARCHAR(200)

----------------CN88_04

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 46, 
@ProductId = 1, 
@ExtraPT = 0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 46, 
@ProductId = 3, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 46, 
@ProductId = 5, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 46, 
@ProductId = 8, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 46, 
@ProductId = 27, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 46, 
@ProductId = 28, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

----------------CN88_14

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 47, 
@ProductId = 1, 
@ExtraPT = 0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 47, 
@ProductId = 3, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 47, 
@ProductId = 5, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 47, 
@ProductId = 8, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 47, 
@ProductId = 27, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 47, 
@ProductId = 28, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
  
    
----------------CN88_24
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 48, 
@ProductId = 1, 
@ExtraPT = 0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 48, 
@ProductId = 3, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 48, 
@ProductId = 5, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 48, 
@ProductId = 8, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 48, 
@ProductId = 27, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 48, 
@ProductId = 28, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
 
----------------CN88_34
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 49, 
@ProductId = 1, 
@ExtraPT = 0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 49, 
@ProductId = 3, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 49, 
@ProductId = 5, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 49, 
@ProductId = 8, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 49, 
@ProductId = 27, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 49, 
@ProductId = 28, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


----------------CN88_40
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 50, 
@ProductId = 1, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 50, 
@ProductId = 3, 
@ExtraPT = 0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 50, 
@ProductId = 5, 
@ExtraPT = 0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 50, 
@ProductId = 8, 
@ExtraPT = 0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 50, 
@ProductId = 27, 
@ExtraPT = 0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 50, 
@ProductId = 28, 
@ExtraPT = 0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


----------------CN88_41
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 51, 
@ProductId = 1, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 51, 
@ProductId = 3, 
@ExtraPT = 0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 51, 
@ProductId = 5, 
@ExtraPT =  0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 51, 
@ProductId = 8, 
@ExtraPT =  0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 51, 
@ProductId = 27, 
@ExtraPT =  0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 51, 
@ProductId = 28, 
@ExtraPT =  0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
  

----------------CN88_42
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 52, 
@ProductId = 1, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 52, 
@ProductId = 3, 
@ExtraPT = 0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 52, 
@ProductId = 5, 
@ExtraPT =  0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 52, 
@ProductId = 8, 
@ExtraPT =  0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 52, 
@ProductId = 27, 
@ExtraPT =  0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 52, 
@ProductId = 28, 
@ExtraPT =  0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


----------------CN88_43
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 53, 
@ProductId = 1, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 53, 
@ProductId = 3, 
@ExtraPT = 0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 53, 
@ProductId = 5, 
@ExtraPT =  0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 53, 
@ProductId = 8, 
@ExtraPT =  0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 53, 
@ProductId = 27, 
@ExtraPT =  0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 53, 
@ProductId = 28, 
@ExtraPT =  0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
  

  
----------------CN88_44
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 54, 
@ProductId = 1, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 54, 
@ProductId = 3, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 54, 
@ProductId = 5, 
@ExtraPT =  0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 54, 
@ProductId = 8, 
@ExtraPT =  0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 54, 
@ProductId = 27, 
@ExtraPT =  0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 54, 
@ProductId = 28, 
@ExtraPT =  0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
  

  
----------------CN88_45
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 55, 
@ProductId = 1, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 55, 
@ProductId = 3, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 55, 
@ProductId = 5, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 55, 
@ProductId = 8, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 55, 
@ProductId = 27, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 55, 
@ProductId = 28, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
 
----------------CN88_05
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 56, 
@ProductId = 1, 
@ExtraPT = 0.0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 56, 
@ProductId = 3, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 56, 
@ProductId = 5, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 56, 
@ProductId = 8, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 56, 
@ProductId = 27, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 56, 
@ProductId = 28, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
  
  
----------------CN88_15
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 57, 
@ProductId = 1, 
@ExtraPT = 0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 57, 
@ProductId = 3, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 57, 
@ProductId = 5, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 57, 
@ProductId = 8, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 57, 
@ProductId = 27, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 57, 
@ProductId = 28, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


----------------CN88_25
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 58, 
@ProductId = 1, 
@ExtraPT = 0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 58, 
@ProductId = 3, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 58, 
@ProductId = 5, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 58, 
@ProductId = 8, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 58, 
@ProductId = 27, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 58, 
@ProductId = 28, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


----------------CN88_35
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 59, 
@ProductId = 1, 
@ExtraPT = 0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 59, 
@ProductId = 3, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 59, 
@ProductId = 5, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 59, 
@ProductId = 8, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 59, 
@ProductId = 27, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 59, 
@ProductId = 28, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

----------------CN88_45
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 60, 
@ProductId = 1, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 60, 
@ProductId = 3, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 60, 
@ProductId = 5, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 60, 
@ProductId = 8, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 60, 
@ProductId = 27, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 60, 
@ProductId = 28, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


----------------CN88_50
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 61, 
@ProductId = 1, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 61, 
@ProductId = 3, 
@ExtraPT = 0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 61, 
@ProductId = 5, 
@ExtraPT =  0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 61, 
@ProductId = 8, 
@ExtraPT =  0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 61, 
@ProductId = 27, 
@ExtraPT =  0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 61, 
@ProductId = 28, 
@ExtraPT =  0,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 



----------------CN88_51
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 62, 
@ProductId = 1, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 62, 
@ProductId = 3, 
@ExtraPT = 0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 62, 
@ProductId = 5, 
@ExtraPT =  0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 62, 
@ProductId = 8, 
@ExtraPT =  0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 62, 
@ProductId = 27, 
@ExtraPT =  0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 62, 
@ProductId = 28, 
@ExtraPT =  0.1,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


----------------CN88_52
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 63, 
@ProductId = 1, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 63, 
@ProductId = 3, 
@ExtraPT = 0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 63, 
@ProductId = 5, 
@ExtraPT =  0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 63, 
@ProductId = 8, 
@ExtraPT =  0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 63, 
@ProductId = 27, 
@ExtraPT =  0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 63, 
@ProductId = 28, 
@ExtraPT =  0.2,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


----------------CN88_53
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 64, 
@ProductId = 1, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 64, 
@ProductId = 3, 
@ExtraPT = 0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 64, 
@ProductId = 5, 
@ExtraPT =  0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 64, 
@ProductId = 8, 
@ExtraPT =  0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 64, 
@ProductId = 27, 
@ExtraPT =  0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 64, 
@ProductId = 28, 
@ExtraPT =  0.3,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 



----------------CN88_54
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 65, 
@ProductId = 1, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 65, 
@ProductId = 3, 
@ExtraPT = 0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 65, 
@ProductId = 5, 
@ExtraPT =  0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 65, 
@ProductId = 8, 
@ExtraPT =  0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 65, 
@ProductId = 27, 
@ExtraPT =  0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 65, 
@ProductId = 28, 
@ExtraPT =  0.4,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


----------------CN88_55
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 66, 
@ProductId = 1, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 66, 
@ProductId = 3, 
@ExtraPT = 0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 


EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 66, 
@ProductId = 5, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
 
EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 66, 
@ProductId = 8, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 66, 
@ProductId = 27, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 

EXEC Acc_GroupExtraPT_GroupByProduct_Ins 
@UserId = @UserId, 
@GroupId = 66, 
@ProductId = 28, 
@ExtraPT =  0.5,
@EffectiveDate = @EffectiveDate,
@EndDate = @EndDate, 
@ErrCode = @p7 OUTPUT,
@ErrMsg = @p8 OUTPUT
SELECT  @p7, @p8 
