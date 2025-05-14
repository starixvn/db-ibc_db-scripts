/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20250514@Kelvin
	DB: DBCUST-CustDB
	Task : Insert currency test 256 (RedmineID: #222339)
*/

USE [CustDB]
GO

INSERT INTO [dbo].[exchange]
           ([currency]
           ,[stakerate]
           ,[actualrate]
           ,[commaxpayout]
           ,[creator]
           ,[minbet]
           ,[minbetlive]
           ,[AUDRate]
           ,[ZARRate]
           ,[GBPRate]
           ,[EURORate]
           ,[US$Rate]
           ,[Code]
           ,[Description]
           ,[MultipliedBy]
           ,[ExVirtualRate]
           ,[IsActive]
           ,[OfferSite]
           ,[ExchangeId]
           ,[RepUpdateTime]
           ,[CurrencyType]
           ,[CreditGroupID]
           ,[LicenseeGroupID])
     SELECT
           'UUS256' as [currency]
           ,[stakerate]
           ,[actualrate]
           ,[commaxpayout]
           ,[creator]
           ,[minbet]
           ,[minbetlive]
           ,[AUDRate]
           ,[ZARRate]
           ,[GBPRate]
           ,[EURORate]
           ,[US$Rate]
           ,'UUS' as [Code]
           ,[Description]
           ,[MultipliedBy]
           ,[ExVirtualRate]
           ,[IsActive]
           ,[OfferSite]
           ,256 as [ExchangeId]
           ,dbo.f_GetDateTime2() as [RepUpdateTime]
           ,[CurrencyType]
           ,[CreditGroupID]
           ,[LicenseeGroupID]
	FROM [exchange](NOLOCK)
	WHERE ExchangeId = 20
GO


DECLARE @date DATETIME = CONVERT(DATETIME, CONVERT(NVARCHAR(20), GETDATE(), 101))

INSERT INTO ExchangeDailyOanda (
			ExchangeId
			, ExchangeDate
			, Code
			, MYR
			, USD
			, EUR
			, CNY
			, IDR
			, AUD
			, CHF
			, GBP
			, SGD
			, THB
			, VND
			, KRW
			, JPY
			, HKD
			, TWD
			, PHP
			, BDT
			, INR
			, TRY
			, NPR
			, MXN
			, NGN
			, BRL
			, PKR
			, RepUpdateTime
		)
SELECT
			256 AS ExchangeId
			, @date AS ExchangeDate
			, 'UUS' AS Code
			, MYR
			, USD
			, EUR
			, CNY
			, IDR
			, AUD
			, CHF
			, GBP
			, SGD
			, THB
			, VND
			, KRW
			, JPY
			, HKD
			, TWD
			, PHP
			, BDT
			, INR
			, TRY
			, NPR
			, MXN
			, NGN
			, BRL
			, PKR
			, dbo.f_GetDateTime2() AS RepUpdateTime
FROM ExchangeDailyOanda (NOLOCK)
WHERE ExchangeId = 20 AND ExchangeDate = @date