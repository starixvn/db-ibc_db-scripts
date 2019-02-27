/*
	Created: 20190227@Percy
	DB: DBCUST.CustDB
	Task: Add new column CreditUpdatedDate into custInfo table
*/

USE [CustDB]
GO

ALTER TABLE dbo.custInfo
	ADD CreditUpdatedDate SMALLDATETIME NULL