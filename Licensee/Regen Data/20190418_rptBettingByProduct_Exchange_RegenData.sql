/*
	Created: 20190418@Percy
	DB: DBLIC.bodb_LicenseeReport
	Task: Regen data manually for Exchange [RedmineID: #111937]
*/

DECLARE @WinlostDate SMALLDATETIME = '2019-04-07'
EXEC dbo.GEN_rptBettingByProduct @date = @WinlostDate, @date2 = @WinlostDate, @DataSource = 'SeparatedProduct' , @SeparatedProductID = 31
GO