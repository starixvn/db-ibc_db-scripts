 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
USE [bodb_LicenseeReport]
GO

/*
Create : 20200603@Sophia:
Regen data GD Repull data 12bet  [rednime: #135296]
DB: DBLIC.bodb_LicenseeReport
*/

EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = '20200510' 

EXEC bodb_PlaytechCS.dbo.Task_DOT_GoldDeluxe_DailySummary @winlostdate = '20200512' 

EXEC dbo.GEN_rptBettingByProduct @date = '20200510', @date2 = '20200512' , @DataSource = 'SeparatedProduct' , @SeparatedProductID = 11 