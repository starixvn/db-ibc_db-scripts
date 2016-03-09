/*
	Created by Dominic@20160309
	Description: Add a new table to support controling default product status by site and by currency #53604
*/
USE [CustDB]

CREATE TABLE [dbo].[ProductStatusSiteCurrency](
	[SportType] [smallint] NOT NULL,
	[BetType] [int] NOT NULL,
	[Currency] [int] NOT NULL,
	[SiteID] [int] NOT NULL,
	[IsHidden] [bit] NOT NULL,
	[IsDisabled] [bit] NOT NULL,
 CONSTRAINT [PK_ProductStatusSiteCurrency] PRIMARY KEY CLUSTERED 
(
	[SportType] ASC,
	[BetType] ASC,
	[Currency] ASC,
	[SiteID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [ProductSettingDetail_table]
) ON [ProductSettingDetail_table]



