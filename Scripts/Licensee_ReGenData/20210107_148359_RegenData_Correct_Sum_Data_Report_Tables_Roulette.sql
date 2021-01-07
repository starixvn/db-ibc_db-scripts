 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Create : 20210107@Sol 
	Regen data for rptBetting - [Redmine: #148359] 
	DB: DBLIC.bodb_LicenseeReport
*/

USE [bodb_LicenseeReport]

GO

DECLARE 
	@errmsg	VARCHAR(1000)
	,@GenerateData INT
	,@BetTypes VARCHAR(8000)
	,@result VARCHAR(1000)

DECLARE @WinlostDate SMALLDATETIME
DECLARE @startDate SMALLDATETIME = '2021-01-01'
DECLARE @endDate SMALLDATETIME = '2021-01-02'

SET @WinlostDate = @startDate

WHILE (@WinlostDate <= @endDate)
BEGIN
	
	BEGIN TRY			
		EXEC DBACC.bodb02.dbo.Task_rptWinLost_UpdateTable @winlostdate = @WinlostDate
	END TRY
	BEGIN CATCH
		SET @errmsg = 'step 6.01' + '--' + ERROR_MESSAGE()			
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

		EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptBetting_CheckData 
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
			EXEC DBLIC.bodb_LicenseeReport.dbo.GEN_rptBetting @date = @WinlostDate, @date2 = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.04' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC DBLIC.bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
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
		EXEC DBLIC.bodb_LicenseeReport.dbo.Task_PostStaging
	END TRY
	BEGIN CATCH
		SET @errmsg = 'step 6.06' + '--' + ERROR_MESSAGE()			
		RAISERROR(@errmsg,16,1)
	END CATCH

	BEGIN TRY

		SET @GenerateData = 0

		EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptBettingBySport_CheckData 
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
			EXEC DBLIC.bodb_LicenseeReport.dbo.GEN_rptBettingBySport14 @Date = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.08' + '--' + ERROR_MESSAGE()			
		RAISERROR(@errmsg,16,1)
		END CATCH

	END

	BEGIN TRY
		EXEC DBLIC.bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = @WinlostDate
	END TRY
	BEGIN CATCH
		SET @errmsg = 'step 6.09' + '--' + ERROR_MESSAGE()			
		RAISERROR(@errmsg,16,1)
	END CATCH

	BEGIN TRY
		EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptCustomerTurnOver_Bettrans14 @Date = @WinlostDate
	END TRY
	BEGIN CATCH
		SET @errmsg = 'step 6.10' + '--' + ERROR_MESSAGE()			
		RAISERROR(@errmsg,16,1)
	END CATCH

	BEGIN TRY 
		EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptWinlostbyleague_Bettrans14 @Date = @WinlostDate
	END TRY
	BEGIN CATCH
		SET @errmsg = 'step 6.11' + '--' + ERROR_MESSAGE()			
		RAISERROR(@errmsg,16,1)
	END CATCH

	BEGIN TRY
		EXEC DBLIC.bodb_LicenseeReport.dbo.Task_rptCustomerMatch_Bettrans14 @Date = @WinlostDate
	END TRY
	BEGIN CATCH
		SET @errmsg = 'step 6.12' + '--' + ERROR_MESSAGE()			
		RAISERROR(@errmsg,16,1)
	END CATCH

	BEGIN TRY
		EXEC DBLIC.bodb_LicenseeReport.dbo.GEN_rptBetting_Parlay14
				@datefrom = @WinlostDate,
				@dateto = @WinlostDate
	END TRY
	BEGIN CATCH
		SET @errmsg = 'step 6.13' + '--' + ERROR_MESSAGE()			
		RAISERROR(@errmsg,16,1)
	END CATCH

	BEGIN TRY
		EXEC DBLIC.bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = @winlostdate
	END TRY
	BEGIN CATCH
		SET @errmsg = 'step 6.14' + '--' + ERROR_MESSAGE()			
		RAISERROR(@errmsg,16,1)
	END CATCH

	BEGIN TRY
		EXEC DBLIC.bodb_LicenseeReport.dbo.Task_DailySummaryLicPromotion_Bettrans14 @PromoDate = @winlostdate, @IsCheckDataOnly = 0
	END TRY
	BEGIN CATCH
		SET @errmsg = 'step 6.15' + '--' + ERROR_MESSAGE()			
		RAISERROR(@errmsg,16,1)
	END CATCH

	-- update status of step 6 in dbtxn
	UPDATE DBTXN.bodb02.dbo.TicketVoiding_RoutineTasks
		SET Status = 2,
			remark = '148359-support to void tickets manually'
	WHERE ExecuteType = 2 AND StepNo = 6
		AND CreatedDate < GETDATE()
		AND status = 0

	-- to next date
	SET @WinlostDate = DATEADD(DAY, 1, @WinlostDate)

END