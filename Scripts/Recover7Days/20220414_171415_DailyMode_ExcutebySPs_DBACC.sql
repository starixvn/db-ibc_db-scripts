/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Create: 20220414@Sophia
	Task: Run manualy SP on DB061/DB062  [Redmine: #171415] 
	DB: DBACC.bodb02 
*/ 
 
USE bodb02;

DECLARE @Winlostdate SMALLDATETIME, @errmsg		VARCHAR(1000) = ''  
SELECT @Winlostdate = '2022-04-07'

WHILE @Winlostdate < = '2022-04-10'
BEGIN 
	
--  @stepNo = 5: Run on 1 server DB061 		
		SET @errmsg = 'step 5.1'
		EXEC Acc_ResetWinning_SelByDate14
			   @Winlostdate = @Winlostdate,
			   @Mode = 1 

		SET @errmsg = 'step 5.2'
		EXEC  Task_ResetWinning_ExtraPT14
			  @FromDate= @WinlostDate,
			  @ToDate = @WinlostDate,
			  @Mode = 1


	 
--  @stepNo = 6.1: Run both server DB061/DB062	 	
		BEGIN TRY			
			EXEC bodb02.dbo.Task_rptWinLost_UpdateTable @winlostdate = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.01' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH 

	SELECT @Winlostdate = DATEADD (DD, 1, @Winlostdate )		
END 	 