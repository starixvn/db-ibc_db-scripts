/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240627@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange Product - Remove data in June
		- Step 2: regen data rptDepWinlost_ThirdParty, rpt_BettingByProduct
*/
USE bodb_3rdProduct
GO
SET NOCOUNT ON

declare  @FromDate date  = '2024-06-01',
		 @ToDate   date  = dateadd(d, -1, getdate()),	
		 @winlostdate date
		
set @winlostdate = @FromDate

while @winlostdate <= @ToDate
begin
	print cast(@winlostdate as varchar(20))

	-- regen table rptDepWinlost_ThirdParty
	exec bodb_3rdproduct.dbo.Task_DOT_Exchange_DailySummary 
		@winlostdate = @winlostdate,
		@IsManual = 1 -- to bypass condition checking of @Mindate
		

	-- regen table rpt_BettingByProduct
	exec bodb_LicenseeReport.dbo.GEN_rptBettingByProduct @date = @winlostdate
													   , @date2 = @winlostdate
													   , @DataSource = 'SeparatedProduct'
													   , @SeparatedProductID = 31
													   , @ProductCodes = 'BX'
													   , @IsManual = 1	

	set @winlostdate = DATEADD(D,1,@winlostdate)
end
