 /*<info serverAlias="DB053-bodb_LicenseeReport" ></info>*/
USE bodb_LicenseeReport
GO
/*
    Created: 20200826@Sophia
	Task: Manual run job recover bet 7days on standby server [Redmine:#140403]
	DB: DB053-bodb_LicenseeReport

*/

DECLARE @errorCode INT,@errmsg VARCHAR(MAX) ,
			@result INT,
			@BetTypes VARCHAR(8000)


----DB053
EXEC bodb_LicenseeReport.dbo.Task_PrepareStaging
				   @datefrom =	'2020-08-17 00:00:00.000',	 @dateto = 	'2020-08-17 00:00:00.000',	 @ErrorMsg = @errmsg		OUTPUT
				   
EXEC bodb_LicenseeReport.dbo.Task_rptBetting_CheckData 
				@WinlostDate	 =	'2020-08-17 00:00:00.000',	@HasDataMismatch = 	@errorCode	OUTPUT,	@BetTypes		 =	@BetTypes	 OUTPUT
				
EXEC bodb_LicenseeReport.dbo.Task_PostStaging

EXEC bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
				   @date = 	'2020-08-17 00:00:00.000',	@date2 = 	'2020-08-17 00:00:00.000',	@DataSource = 'rpt_Betting' 


EXEC bodb_LicenseeReport.dbo.Task_rptBettingBySport_CheckData 
				@WinlostDate = 	'2020-08-17 00:00:00.000',	@HasDataMismatch = 	@errorCode	OUTPUT,
				@IsParlay = 	@result	OUTPUT

EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = 	'2020-08-17 00:00:00.000'


EXEC bodb_LicenseeReport.dbo.Task_rptCustomerTurnOver_Bettrans14 @Date =	'2020-08-17 00:00:00.000'


EXEC bodb_LicenseeReport.dbo.Task_rptWinlostbyleague_Bettrans14 @Date = 	'2020-08-17 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_rptCustomerMatch_Bettrans14 @Date = 	'2020-08-17 00:00:00.000'


EXEC bodb_LicenseeReport.dbo.GEN_rptBetting_Parlay14
				   @datefrom = 	'2020-08-17 00:00:00.000',	@dateto = 	'2020-08-17 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = 	'2020-08-17 00:00:00.000'


EXEC bodb_LicenseeReport.dbo.Task_DailySummaryLicPromotion_Bettrans14 @PromoDate =	'2020-08-17 00:00:00.000',	@IsCheckDataOnly = 0



EXEC bodb_LicenseeReport.dbo.Task_PrepareStaging
				   @datefrom =	'2020-08-18 00:00:00.000',	 @dateto = 	'2020-08-18 00:00:00.000',	 @ErrorMsg =@errmsg		OUTPUT

EXEC bodb_LicenseeReport.dbo.Task_rptBetting_CheckData 
				@WinlostDate	 =	'2020-08-18 00:00:00.000',	@HasDataMismatch = 	@errorCode	OUTPUT,	@BetTypes		 =	@BetTypes	 OUTPUT

EXEC bodb_LicenseeReport.dbo.Task_PostStaging

EXEC bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
				   @date = 	'2020-08-18 00:00:00.000',	@date2 = 	'2020-08-18 00:00:00.000',	@DataSource = 'rpt_Betting' 

EXEC bodb_LicenseeReport.dbo.Task_rptBettingBySport_CheckData 
				@WinlostDate = 	'2020-08-18 00:00:00.000',	@HasDataMismatch = 	@errorCode	OUTPUT,
				@IsParlay = 	@result	OUTPUT

EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = 	'2020-08-18 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_rptCustomerTurnOver_Bettrans14 @Date =	'2020-08-18 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_rptWinlostbyleague_Bettrans14 @Date = 	'2020-08-18 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_rptCustomerMatch_Bettrans14 @Date = 	'2020-08-18 00:00:00.000'


EXEC bodb_LicenseeReport.dbo.GEN_rptBetting_Parlay14
				   @datefrom = 	'2020-08-18 00:00:00.000',	@dateto = 	'2020-08-18 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = 	'2020-08-18 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_DailySummaryLicPromotion_Bettrans14 @PromoDate =	'2020-08-18 00:00:00.000',	@IsCheckDataOnly = 0
 

EXEC bodb_LicenseeReport.dbo.Task_PrepareStaging
				   @datefrom =	'2020-08-19 00:00:00.000',	 @dateto = 	'2020-08-19 00:00:00.000',	 @ErrorMsg = @errmsg		OUTPUT

EXEC bodb_LicenseeReport.dbo.Task_rptBetting_CheckData 
				@WinlostDate	 =	'2020-08-19 00:00:00.000',	@HasDataMismatch = 	@errorCode	OUTPUT,	@BetTypes		 =	@BetTypes	 OUTPUT

EXEC bodb_LicenseeReport.dbo.Task_PostStaging

EXEC bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
				   @date = 	'2020-08-19 00:00:00.000',	@date2 = 	'2020-08-19 00:00:00.000',	@DataSource = 'rpt_Betting' 

EXEC bodb_LicenseeReport.dbo.Task_rptBettingBySport_CheckData 
				@WinlostDate = 	'2020-08-19 00:00:00.000',	@HasDataMismatch = 	@errorCode	OUTPUT,
				@IsParlay = 	@BetTypes	OUTPUT

EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinloss2 @winlostdate = 	'2020-08-19 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_rptCustomerTurnOver_Bettrans14 @Date =	'2020-08-19 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_rptWinlostbyleague_Bettrans14 @Date = 	'2020-08-19 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.Task_rptCustomerMatch_Bettrans14 @Date = 	'2020-08-19 00:00:00.000'

EXEC bodb_LicenseeReport.dbo.GEN_rptBetting_Parlay14
				   @datefrom = 	'2020-08-19 00:00:00.000',	@dateto = 	'2020-08-19 00:00:00.000'
				   
EXEC bodb_LicenseeReport.dbo.Task_DailyRptLicWinlossGMT_Bettrans14 @FromDate = 	'2020-08-19 00:00:00.000'	   
				   
				   
EXEC bodb_LicenseeReport.dbo.Task_DailySummaryLicPromotion_Bettrans14 @PromoDate =	'2020-08-19 00:00:00.000',	@IsCheckDataOnly = 0			   



















