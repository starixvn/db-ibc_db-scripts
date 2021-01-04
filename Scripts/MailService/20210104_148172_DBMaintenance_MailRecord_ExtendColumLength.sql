/*<info serverAlias="DBMA-bodb_Maintenance"></info>*/
/*
	Created: 20210104@Kos
	DB: DBMA-bodb_Maintenance
	Task: Extend length of column MailCc and MailBcc in table MailRecord [RedmineID: #148172]
*/

USE bodb_Maintenance
GO

ALTER TABLE dbo.Mail_Record
ALTER COLUMN MailCc NVARCHAR(2000);

ALTER TABLE dbo.Mail_Record
ALTER COLUMN MailBcc NVARCHAR(2000);

GO