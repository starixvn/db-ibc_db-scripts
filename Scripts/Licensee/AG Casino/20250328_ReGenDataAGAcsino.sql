/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20250328@Sophia
	DB:  DBLIC-bodb_LicenseeReport
	Task: ReGenData [RedmineID: #222219]
*/
 

DECLARE  @winlostdate SMALLDATETIME

SELECT @winlostdate = '20250301'

WHILE @winlostdate <= '20250328'
BEGIN 

		EXEC bodb_3rdProduct.dbo.Task_DOT_AGCasino_DailySummary @winlostdate = @winlostdate 

		EXEC dbo.GEN_rptBettingByProduct @date = @WinlostDate, @date2 = @WinlostDate, @DataSource = 'SeparatedProduct' , @SeparatedProductID = 10 
 
		SELECT @winlostdate = DATEADD(Day, 1, @winlostdate )
		
END


