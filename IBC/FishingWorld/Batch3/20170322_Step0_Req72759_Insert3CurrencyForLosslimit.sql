/*
	Created: Winnie
	Task: Insert LossLimit_GlobalSetting for 3 currencies (MKK,KHR,YNG) RedmineID:#72759
	DB: DBCUST/CustDB
	Date: 20170313
*/ 

USE [CustDB]
GO

INSERT INTO [dbo].[LossLimit_GlobalSetting]
           ([ProductId]
           ,[ExchangeId]
           ,[MinLossLimit]
           ,[DefaultLossLimit])
select 24,70,100,28900
UNION
select 24,71,400,87700
UNION
select 24,72,100000,100000
GO


