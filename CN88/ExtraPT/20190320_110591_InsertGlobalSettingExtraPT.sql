

use CUSTDB
/*

DB: DBCUST.CUSTDB
Create: 20190320@Sophia
Task: CN88 - UAT - initial script for ExtraPT 
*/


--- 3. Insert global extraPT by Product Acc_GroupExtraPT_Product

	  DECLARE @ErrCode INT, @ErrMsg NVARCHAR(200)  

	  EXEC Acc_GroupExtraPT_GroupByProduct_Ins
		@UserId = 3,
		@GroupId = 27,
		@ProductId = 1,
		@ExtraPT = 0.03,
		@EffectiveDate = '2019-03-20',
		@EndDate = NULL,
		@ErrCode = @ErrCode OUTPUT ,
		@ErrMsg = @ErrMsg OUTPUT

		SELECT @ErrCode, @ErrMsg



		---SELECT *  From Acc_GroupExtraPT_Product where groupID= 27
