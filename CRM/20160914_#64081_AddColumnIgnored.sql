/*
	Created: Winnie
	Date: 2016-09-14
	Task: Include 'Ignored Accounts' RedmineID: #64081
	DB: DBCRM/bodb_CRM
*/ 
USE bodb_CRM
GO

ALTER TABLE crmCustomer
ADD  Ignored BIT
GO
ALTER TABLE [dbo].crmCustomer ADD  CONSTRAINT [DF_crmCustomer_Ignored]  DEFAULT (0) FOR Ignored
GO
ALTER TABLE crmCustomer
ADD  Checker NVARCHAR(50)
GO
