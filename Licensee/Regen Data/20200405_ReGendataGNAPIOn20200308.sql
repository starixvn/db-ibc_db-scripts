USE [bodb_LicenseeReport]
GO

/*
Create : 20200405 @Sophia
Task: reGen data of GD - API on 20200307 to 20200309

*/



EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = '2020-03-07' 

EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = '2020-03-08' 

EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = '2020-03-09' 

EXEC dbo.GEN_rptBettingByProduct @date = '2020-03-07', @date2 = '2020-03-09', @DataSource = 'SeparatedProduct' , @SeparatedProductID = 11 
				 