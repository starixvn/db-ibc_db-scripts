/*
	Created by: Elodie
	Date: 2016-09-15
	Task: Add owner name for group headline - [Redmine: #63349]
	DB: DBCUST/CustDB
*/
USE [CustDB]
GO

ALTER TABLE dbo.CustGroupHeadline ADD OwnerName NVARCHAR(200) NULL
GO

ALTER TABLE dbo.CustGroupHeadline DROP COLUMN OwnerID