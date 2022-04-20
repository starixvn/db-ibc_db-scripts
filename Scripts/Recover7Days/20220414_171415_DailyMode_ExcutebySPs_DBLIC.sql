/*<info serverAlias="DBLIC-bodb_LicenseeReport,DBBAL-bodb_LicenseeReport"></info>*/
/*
	Create: 20220414@Sophia
	Task: re-gen data mode daily manual - run on DB052/DB053 , and DBBAL[Redmine: #171415] 
	DB: DBLIC-bodbLicenseeReport
*/ 
  
 
USE bodb_LicenseeReport
GO 

DECLARE @Winlostdate SMALLDATETIME, @errmsg		VARCHAR(1000) = ''  
SELECT @Winlostdate = '2022-04-07'

DECLARE @GenerateData TINYINT, 
		@result VARCHAR(20),
		@BetTypes VARCHAR(8000)


WHILE @Winlostdate < = '2022-04-10'
BEGIN 

	BEGIN TRY
			SET @errmsg = ''
			EXEC  dbo.Task_PrepareStaging
				   @datefrom = @WinlostDate,
				   @dateto = @WinlostDate, 
				   @ErrorMsg = @errmsg OUTPUT  
			IF @errmsg <> ''
			BEGIN
				SET @errmsg = @errmsg  
				RAISERROR(@errmsg,16,1)
			END
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.02' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY			 

			SET @GenerateData = 0

			EXEC Task_rptBetting_CheckData 
				@WinlostDate	 = @WinlostDate,
				@HasDataMismatch = @GenerateData OUTPUT,
				@BetTypes		 = @BetTypes OUTPUT
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.03' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		IF (@GenerateData <> 0)
		BEGIN 

			BEGIN TRY
				EXEC GEN_rptBetting @date = @WinlostDate, @date2 = @WinlostDate
			END TRY
			BEGIN CATCH
				SET @errmsg = 'step 6.04' + '--' + ERROR_MESSAGE()			
				RAISERROR(@errmsg,16,1)
			END CATCH

			BEGIN TRY
				EXEC GEN_rptBettingByProduct
					@date = @winlostdate,
					@date2 = @winlostdate,
					@DataSource = 'rpt_Betting'
			END TRY
			BEGIN CATCH
				SET @errmsg = 'step 6.05' + '--' + ERROR_MESSAGE()			
				RAISERROR(@errmsg,16,1)
			END CATCH

		END

		BEGIN TRY
			EXEC Task_PostStaging
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.06' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY

			SET @GenerateData = 0

			EXEC Task_rptBettingBySport_CheckData 
				@WinlostDate = @WinlostDate,
				@HasDataMismatch = @GenerateData OUTPUT,
				@IsParlay = @result OUTPUT

		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.07' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		IF @GenerateData <> 0
		BEGIN

			BEGIN TRY
				EXEC GEN_rptBettingBySport14 @Date = @WinlostDate
			END TRY
			BEGIN CATCH
				SET @errmsg = 'step 6.08' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
			END CATCH

		END

		BEGIN TRY
			EXEC Task_DailyRptLicWinloss2 @winlostdate = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.09' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC Task_rptCustomerTurnOver_Bettrans14 @Date = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.10' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY 
			EXEC Task_rptWinlostbyleague_Bettrans14 @Date = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.11' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC Task_rptCustomerMatch_Bettrans14 @Date = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.12' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC GEN_rptBetting_Parlay14
				   @datefrom = @WinlostDate,
				   @dateto = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.13' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = @winlostdate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.14' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC Task_DailySummaryLicPromotion_Bettrans14 @PromoDate = @winlostdate, @IsCheckDataOnly = 0
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.15' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH


	SELECT @Winlostdate = DATEADD (DD, 1, @Winlostdate )		
END 	 