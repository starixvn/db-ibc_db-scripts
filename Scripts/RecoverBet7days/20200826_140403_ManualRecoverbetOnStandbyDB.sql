 /*<info serverAlias="DBTXN-bodb02" ></info>*/
USE bodb02
GO
/*
    Created: 20200826@Sophia
	Task: Manual run job recover bet 7days on standby server [Redmine:#140403]
	DB: DBTXN-bodb02

*/

BEGIN
 SET NOCOUNT ON
 
  DECLARE  @custIDs		VARCHAR(MAX) = '', 
	 @winlostdate	DATETIME ,
	 @stepNo		TINYINT = 2   --- input param step =   2 , 4, 6

DECLARE @inputList TABLE (custid INT, winlostdate DATETIME, isDone BIT)

DECLARE @errorCode INT,@errmsg VARCHAR(MAX) ,
			@result INT,
			@BetTypes VARCHAR(8000)

;WITH rs
		AS (
			SELECT *
				,cast(affectedList AS XML) AS xmldata
			FROM TicketVoiding_RoutineTasks WITH(NOLOCK)
			WHERE stepno = @stepNo AND status = 2
			)
		INSERT INTO @inputList(custid,winlostdate,isDone)
		SELECT t.c.value('@c', 'INT') AS CustId
			,t.c.value('@w', 'SMALLDATETIME') AS WinlostDate
			, 0 AS isDone 
		FROM rs
		CROSS APPLY xmldata.nodes('root/r') AS t(c)


	 
---step 2 & 4
WHILE EXISTS (SELECT 1 FROM @inputList WHERE isDone = 0)
BEGIN
	--- run by winlostdate & list of custid
	SELECT TOP(1) @winlostdate=winlostdate, 
					@custIDs=STUFF( ( SELECT ',' + CAST(custid AS VARCHAR(20))
									FROM @inputList s 
									WHERE s.winlostdate = t.winlostdate
									FOR XML PATH ('')),1,1,'')
	FROM @inputList t 
	WHERE isDone = 0
	GROUP BY winlostdate 
			
   IF @stepNo = 2
	BEGIN
		SET @errmsg = 'step 2.1'
		EXEC DB052.bodb_summary.dbo.Task_CS_SumWinloss_14
			   @WinlostDate = @WinlostDate,
			   @CustIds = @CustIds
		SET @errmsg = 'step 2.2'
		EXEC DB052.bodb_summary.dbo.Task_CS_SumCancelled_14
				@WinlostDate = @WinlostDate,
				@CustIds = @CustIds
	END
 
	IF @stepNo = 4
	BEGIN
		EXEC DB06.bodb_report.dbo.Task_rptStatement_14
				@WinlostDate = @WinlostDate,
				@CustIds = @CustIds
		
	END

	UPDATE @inputList
	SET isDone = 1
	WHERE winlostdate = @winlostdate 
 
END
---------------------------------------------------------------------------------
---- Step 6  -- those kind of execution only need input @winlostdate 

WHILE EXISTS (SELECT 1 FROM @inputList WHERE isDone = 0)
BEGIN
	SELECT TOP 1 @winlostdate = winlostdate
	FROM @inputList
	WHERE isDone = 0
	GROUP BY winlostdate 
	ORDER BY winlostdate

	IF @stepNo = 6
	BEGIN
		BEGIN TRY			
			EXEC DB06.bodb02.dbo.Task_rptWinLost_UpdateTable @winlostdate = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.1' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH 

		BEGIN TRY
			SET @errmsg = ''
			EXEC DB053.bodb_LicenseeReport.dbo.Task_PrepareStaging
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

		BEGIN TRY			 
			EXEC DB053.bodb_LicenseeReport.dbo.Task_rptBetting_CheckData 
				@WinlostDate	 = @WinlostDate,
				@HasDataMismatch = @errorCode OUTPUT,
				@BetTypes		 = @BetTypes OUTPUT
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.3' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC DB053.bodb_LicenseeReport.dbo.Task_PostStaging
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.4' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC DB053.bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
				   @date = @winlostdate,
				   @date2 = @winlostdate,
				   @DataSource = 'rpt_Betting'
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.5' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH 


		BEGIN TRY
			EXEC DB053.bodb_LicenseeReport.dbo.Task_rptBettingBySport_CheckData 
				@WinlostDate = @WinlostDate,
				@HasDataMismatch = @errorCode OUTPUT,
				@IsParlay = @result OUTPUT
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.6' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC DB053.bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.7' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC DB053.bodb_LicenseeReport.dbo.Task_rptCustomerTurnOver_Bettrans14 @Date = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.8' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY 
			EXEC DB053.bodb_LicenseeReport.dbo.Task_rptWinlostbyleague_Bettrans14 @Date = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.9' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC DB053.bodb_LicenseeReport.dbo.Task_rptCustomerMatch_Bettrans14 @Date = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.91' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC DB053.bodb_LicenseeReport.dbo.GEN_rptBetting_Parlay14
				   @datefrom = @WinlostDate,
				   @dateto = @WinlostDate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.92' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC DB053.bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = @winlostdate
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.93' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH

		BEGIN TRY
			EXEC DB053.bodb_LicenseeReport.dbo.Task_DailySummaryLicPromotion_Bettrans14 @PromoDate = @winlostdate, @IsCheckDataOnly = 0
		END TRY
		BEGIN CATCH
			SET @errmsg = 'step 6.94' + '--' + ERROR_MESSAGE()			
			RAISERROR(@errmsg,16,1)
		END CATCH
	END
	
	
	UPDATE @inputList
	SET isDone = 1
	WHERE winlostdate = @winlostdate

END

	
	
END
GO
 