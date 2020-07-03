 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
USE [bodb_LicenseeReport]
GO

/*
Create : 20200703@Sophia:
Regen data GD Repull data 12bet on 20200613  [rednime: #136971]
DB: DBLIC.bodb_LicenseeReport
*/
 
EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = '20200613' 

EXEC dbo.GEN_rptBettingByProduct @date = '20200613', @date2 = '20200613', @DataSource = 'SeparatedProduct' , @SeparatedProductID = 11  