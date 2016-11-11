/*
	Created: 20161028@Elodie
	DB: DBCUST/CustDB
	Task: Offer 789y real currency (16/11/2016)
*/

USE CustDB
GO

GO
UPDATE dbo.ProductStatusSiteCurrency
SET IsHidden = 0
WHERE SportType = 213 AND Currency <> 20