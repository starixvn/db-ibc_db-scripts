-- DBLIC (DB052, DB053, DB054)

/*
	Created: 20190705@Percy
	DB: DBLIC (DB052, DB053, DB054)
	Task: Re-gen sum data due to re-pull API's data	#116437
*/

DECLARE @FromDate SMALLDATETIME, @ToDate SMALLDATETIME
SELECT  @FromDate = '2019-06-20', @ToDate = '2019-06-30'

DECLARE @WinlostDate SMALLDATETIME
SELECT  @WinlostDate = @FromDate

WHILE @WinlostDate <= @ToDate
BEGIN
	EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = @winlostdate, @IsManual = 1

	
	SELECT @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END
GO


DECLARE @FromDate SMALLDATETIME, @ToDate SMALLDATETIME
SELECT  @FromDate = '2019-06-20', @ToDate = '2019-06-30'

EXEC bodb_LicenseeReport.dbo.GEN_rptBettingByProduct
		@date = @FromDate, @date2 = @ToDate
		,@DataSource = 'SeparatedProduct'
		,@SeparatedProductID = 11 -- GD