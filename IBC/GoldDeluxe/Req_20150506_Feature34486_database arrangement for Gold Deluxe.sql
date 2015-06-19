 USE CustDB
GO
alter table custinfo add HideGoldDeluxe bit CONSTRAINT DF_custinfo_HideGoldDeluxe DEFAULT(1) null 
GO
alter table custinfo add DisableGoldDeluxe bit CONSTRAINT DF_custinfo_DisableGoldDeluxe default(1)  null
GO

----------------
USE bodb_CustomerLog
GO

alter table [dbo].[CustInfo_history] add HideGoldDeluxe bit CONSTRAINT DF_custinfo_history_HideGoldDeluxe default(1) null


alter table [CustInfo_history] add DisableGoldDeluxe bit CONSTRAINT DF_custinfo_history_DisableGoldDeluxe default(1) null

GO

USE bodb_customer
GO

alter table [dbo].[custInfo_old] add HideGoldDeluxe bit CONSTRAINT DF_custinfo_history_HideGoldDeluxe default(1) null


alter table [dbo].[custInfo_old] add DisableGoldDeluxe bit CONSTRAINT DF_custinfo_history_DisableGoldDeluxe default(1) null




