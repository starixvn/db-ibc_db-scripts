 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Create : 20210105@Sol 
	Regen data for rptBetting - [Redmine: #148257] 
	DB: DBLIC.bodb_LicenseeReport
*/

USE [bodb_LicenseeReport]

GO

DECLARE 
	@errmsg	VARCHAR(1000)
	,@errorCode INT
	,@BetTypes VARCHAR(8000)
	,@result INT

DECLARE @WinlostDate VARCHAR(1000) = '2020-12-26'

BEGIN TRY			
	EXEC DBACC.bodb02.dbo.Task_rptWinLost_UpdateTable @winlostdate = @WinlostDate
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.1' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH 

BEGIN TRY
	SET @errmsg = ''
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_PrepareStaging
			@datefrom = @WinlostDate,
			@dateto = @WinlostDate, 
			@ErrorMsg = @errmsg OUTPUT  
	IF @errmsg <> ''
	BEGIN
		SET @errmsg = 'step 6.2--' +  @errmsg  
		RAISERROR(@errmsg,16,1)
	END
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.2' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

-- check and correct
BEGIN TRY			 
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptBetting_CheckData 
		@WinlostDate	 = @WinlostDate,
		@HasDataMismatch = @errorCode OUTPUT,
		@BetTypes		 = @BetTypes OUTPUT

	IF @errorCode <> 0
	BEGIN 
		EXEC dbo.GEN_rptBetting @date = @WinlostDate, @date2 = @WinlostDate
	END

	-----2.3.b. Correct data of Rpt_BettingByProduct table because of rpt_betting , rpt_betting_BA has been corrected 
	IF @errorCode <> 0
	BEGIN 
		EXEC dbo.GEN_rptBettingByProduct @date = @WinlostDate, @date2 = @WinlostDate, @DataSource = 'rpt_betting' , @SeparatedProductID = 0   
	END
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.3' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

BEGIN TRY
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_PostStaging
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.4' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

BEGIN TRY
	EXEC DBLIC.bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
			@date = @winlostdate,
			@date2 = @winlostdate,
			@DataSource = 'rpt_Betting'
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.5' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH 

--check and correct
BEGIN TRY
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptBettingBySport_CheckData 
		@WinlostDate = @WinlostDate,
		@HasDataMismatch = @errorCode OUTPUT,
		@IsParlay = @result OUTPUT

	IF @errorCode <> 0
	BEGIN
		EXEC dbo.GEN_rptBettingBySport14 @Date = @WinlostDate
	END

END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.6' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

BEGIN TRY
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = @WinlostDate
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.7' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

BEGIN TRY
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptCustomerTurnOver_Bettrans14 @Date = @WinlostDate
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.8' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

BEGIN TRY 
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptWinlostbyleague_Bettrans14 @Date = @WinlostDate
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.9' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

BEGIN TRY
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptCustomerMatch_Bettrans14 @Date = @WinlostDate
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.91' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

BEGIN TRY
	EXEC DBLIC.bodb_LicenseeReport.dbo.GEN_rptBetting_Parlay14
			@datefrom = @WinlostDate,
			@dateto = @WinlostDate
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.92' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

BEGIN TRY
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = @winlostdate
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.93' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH

BEGIN TRY
	EXEC DBLIC.bodb_LicenseeReport.dbo.Task_DailySummaryLicPromotion_Bettrans14 @PromoDate = @winlostdate, @IsCheckDataOnly = 0
END TRY
BEGIN CATCH
	SET @errmsg = 'step 6.94' + '--' + ERROR_MESSAGE()			
	RAISERROR(@errmsg,16,1)
END CATCH
	 
GO