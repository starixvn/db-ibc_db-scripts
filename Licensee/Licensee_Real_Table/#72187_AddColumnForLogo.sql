USE [bodb_licensee]
GO
/*
	Created By:		20170228@Bruce
	Description:	#72187_LA/ OWA - Save image resources into database
	DBLIC/bodb_licensee
*/
ALTER TABLE [dbo].[LA_BillerInfo] ADD [Logo] [varbinary](max)
ALTER TABLE [dbo].[LA_BillerInfo] ADD [LogoHeight] [int]
ALTER TABLE [dbo].[LA_BillerInfo] ADD [LogoWidth] [int]
GO