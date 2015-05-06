 USE CustDB
GO
alter table custinfo add HideGoldDeluxe bit null
GO
alter table custinfo add DisableGoldDeluxe bit null
GO

----------------
USE bodb_CustomerLog
GO

alter table [dbo].[CustInfo_history] add HideGoldDeluxe bit null


alter table [CustInfo_history] add DisableGoldDeluxe bit null

GO

USE bodb_customer
GO

alter table [dbo].[custInfo_old] add HideGoldDeluxe bit null


alter table [dbo].[custInfo_old] add DisableGoldDeluxe bit null




