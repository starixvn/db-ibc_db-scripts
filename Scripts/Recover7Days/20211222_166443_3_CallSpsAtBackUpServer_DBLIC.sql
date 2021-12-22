/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/

/*
Create: 20221220@Sophia
Task: Call SPs Regen Data at back up servers DBLIC [Redmine: #166443] 
DB: DBLIC-bodb_LicenseeReport

*/  

---@stepNo = 6.2
 ---DB052 -- DBLIC	 
 USE bodb_LicenseeReport 
 GO	
 
 
 DECLARE   
	 @AffectedList	VARCHAR(MAX) = '<root><r c="33655935" w="2021-12-15T00:00:00"/><r c="53634893" w="2021-12-15T00:00:00"/><r c="56475760" w="2021-12-14T00:00:00"/><r c="56475760" w="2021-12-15T00:00:00"/><r c="58703902" w="2021-12-15T00:00:00"/></root>'
	, @errmsg		VARCHAR(1000) = ''   
	,@BetTypes		VARCHAR(1000) = ''   
	,@GenerateData  BIT= 0
	,@result	BIT = 0
  
	DECLARE @inputList TABLE (custid INT, winlostdate DATETIME, isDone BIT)
	-- parse @affectedList to get list of winlostdate or custid
	-- in case of group execution combine the affected list & remove duplicate value
	-- loop for each custid/winlostdate
	DECLARE @XmlData XML,
			@winlostdate DATETIME,
			@custID INT,
			@custIDs VARCHAR(MAX) = ''

	IF @AffectedList IS NOT NULL --- most of case run instantly tasks
	BEGIN 
		SET @XmlData  = @AffectedList

		INSERT INTO @inputList(custid,winlostdate,isDone)
		SELECT	t.c.value('@c', 'INT')			AS CustId,
				t.c.value('@w', 'SMALLDATETIME')	AS WinlostDate,
				0 AS isDone
		FROM @XmlData.nodes('root/r') AS t(c)
		OPTION (OPTIMIZE FOR (@XmlData = NULL))
	END
	 
	 
	BEGIN
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
			
			
			---begin Loop 				
				BEGIN TRY
					SET @errmsg = ''
					EXEC bodb_LicenseeReport.dbo.Task_PrepareStaging
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

					EXEC bodb_LicenseeReport.dbo.Task_rptBetting_CheckData 
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
						EXEC bodb_LicenseeReport.dbo.GEN_rptBetting @date = @WinlostDate, @date2 = @WinlostDate
					END TRY
					BEGIN CATCH
						SET @errmsg = 'step 6.04' + '--' + ERROR_MESSAGE()			
						RAISERROR(@errmsg,16,1)
					END CATCH

					BEGIN TRY
						EXEC bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
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
					EXEC bodb_LicenseeReport.dbo.Task_PostStaging
				END TRY
				BEGIN CATCH
					SET @errmsg = 'step 6.06' + '--' + ERROR_MESSAGE()			
					RAISERROR(@errmsg,16,1)
				END CATCH


				BEGIN TRY

					SET @GenerateData = 0

					EXEC bodb_LicenseeReport.dbo.Task_rptBettingBySport_CheckData 
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
						EXEC bodb_LicenseeReport.dbo.GEN_rptBettingBySport14 @Date = @WinlostDate
					END TRY
					BEGIN CATCH
						SET @errmsg = 'step 6.08' + '--' + ERROR_MESSAGE()			
					RAISERROR(@errmsg,16,1)
					END CATCH

				END

				BEGIN TRY
					EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = @WinlostDate
				END TRY
				BEGIN CATCH
					SET @errmsg = 'step 6.09' + '--' + ERROR_MESSAGE()			
					RAISERROR(@errmsg,16,1)
				END CATCH

				BEGIN TRY
					EXEC bodb_LicenseeReport.dbo.Task_rptCustomerTurnOver_Bettrans14 @Date = @WinlostDate
				END TRY
				BEGIN CATCH
					SET @errmsg = 'step 6.10' + '--' + ERROR_MESSAGE()			
					RAISERROR(@errmsg,16,1)
				END CATCH

				BEGIN TRY 
					EXEC bodb_LicenseeReport.dbo.Task_rptWinlostbyleague_Bettrans14 @Date = @WinlostDate
				END TRY
				BEGIN CATCH
					SET @errmsg = 'step 6.11' + '--' + ERROR_MESSAGE()			
					RAISERROR(@errmsg,16,1)
				END CATCH

				BEGIN TRY
					EXEC bodb_LicenseeReport.dbo.Task_rptCustomerMatch_Bettrans14 @Date = @WinlostDate
				END TRY
				BEGIN CATCH
					SET @errmsg = 'step 6.12' + '--' + ERROR_MESSAGE()			
					RAISERROR(@errmsg,16,1)
				END CATCH

				BEGIN TRY
					EXEC bodb_LicenseeReport.dbo.GEN_rptBetting_Parlay14
						   @datefrom = @WinlostDate,
						   @dateto = @WinlostDate
				END TRY
				BEGIN CATCH
					SET @errmsg = 'step 6.13' + '--' + ERROR_MESSAGE()			
					RAISERROR(@errmsg,16,1)
				END CATCH

				BEGIN TRY
					EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = @winlostdate
				END TRY
				BEGIN CATCH
					SET @errmsg = 'step 6.14' + '--' + ERROR_MESSAGE()			
					RAISERROR(@errmsg,16,1)
				END CATCH

				BEGIN TRY
					EXEC bodb_LicenseeReport.dbo.Task_DailySummaryLicPromotion_Bettrans14 @PromoDate = @winlostdate, @IsCheckDataOnly = 0
				END TRY
				BEGIN CATCH
					SET @errmsg = 'step 6.15' + '--' + ERROR_MESSAGE()			
					RAISERROR(@errmsg,16,1)
				END CATCH
		 
			---End loop


			UPDATE @inputList
			SET isDone = 1
			WHERE winlostdate = @winlostdate 
		END  
 END