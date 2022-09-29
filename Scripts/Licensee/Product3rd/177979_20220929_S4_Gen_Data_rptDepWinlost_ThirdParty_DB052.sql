/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20220919@Sol
	DB: DBLIC-bodb_3rdProduct
	Task: insert data into rptDepWinlost_ThirdParty - [Redmine: #177979]
*/

--## RUN IN DB052 ONLY ##--

USE bodb_3rdProduct

GO 

DECLARE @winlostdate DATETIME

SELECT @winlostdate = min(h.WinlostDate)
FROM bodb_3rdProduct.dbo.Product3rd_SummarizedDateHistory h WITH (NOLOCK)
WHERE h.ProductID = 31 AND h.SumToThirdPartyDate IS NULL

---exec sp to gen data, will get all rows in Product3rd_SummarizedDateHistory with SumToThirdPartyDate IS NULL to run
EXEC bodb_3rdProduct.[dbo].[Task_DOT_Exchange_DailySummary]
	@winlostdate = @winlostdate	
	,@IsManual = 1 -- to bypass condition checking of @Mindate
	,@GenForDataWarehouse = 0

GO