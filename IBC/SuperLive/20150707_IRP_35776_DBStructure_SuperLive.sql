USE CustDB
GO
alter table custinfo add DisableSuperLive bit CONSTRAINT DF_custinfo_DisableSuperLive default(0)  null
GO
 
----------------
USE bodb_CustomerLog
GO
alter table [CustInfo_history] add DisableSuperLive bit CONSTRAINT DF_custinfo_history_DisableSuperLive default(0) null 
GO
 
----------------
USE bodb_customer
GO
alter table [dbo].[custInfo_old] add DisableSuperLive bit CONSTRAINT DF_custinfo_old_DisableSuperLive default(0) null