/*
	Created: Elodie
	Task: Offer for UUS currency
	DB: DBCUST/CustDB
	Date: 20160317
*/ 
INSERT INTO [dbo].[ProductStatusSiteCurrency]
           ([SportType]
           ,[BetType]
           ,[Currency]
           ,[SiteID]
           ,[IsHidden]
           ,[IsDisabled])
SELECT 211,2401,[exchangeid],0,1,1
FROM [CustDB].[dbo].[exchange]
WHERE  exchangeid <> 20


--DELETE ProductStatusSiteCurrency WHERE SportType = 211