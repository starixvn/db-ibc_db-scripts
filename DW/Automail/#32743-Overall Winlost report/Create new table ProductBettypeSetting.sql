
USE [bodb_Account]
GO
 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF OBJECT_ID('bodb_Account.dbo.ProductBettypeSetting') IS NOT NULL
BEGIN
	DROP TABLE dbo.ProductBettypeSetting
END

CREATE TABLE [dbo].ProductBettypeSetting (
	[ProductID] [int] NOT NULL
	,[ProductName] [varchar](200) NOT NULL
	,[Bettype] [smallint] NOT NULL
	--,isActive BIT DEFAULT 0
	,excluded BIT DEFAULT 0
	,excluded_BetCount BIT DEFAULT 0
	,excluded_TO BIT DEFAULT 0
	,excluded_WL BIT DEFAULT 0
	,CONSTRAINT [PK_ProductBettypeSetting] PRIMARY KEY CLUSTERED ([ProductID] ASC, [ProductName] ASC, [Bettype] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
	) ON [DATA]
GO

SET ANSI_PADDING OFF
GO