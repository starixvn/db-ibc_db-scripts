USE bodb_Licensee
GO

/*
	Created: 20190703@Percy
	DB: DBCUST.bodb_Licensee
	Task: New table - Initialize data
*/

INSERT INTO [dbo].[LA_InvoiceItemType]([SignDB],[GroupDB],[SignSOA],[GroupSOA],[InvItemTypeName],[InvItemTypeId])
SELECT [SignDB],[GroupDB],[SignSOA],[GroupSOA],[InvItemTypeName],[InvItemTypeId] FROM DB052.bodb_Licensee.dbo.[LA_InvoiceItemType] WITH (NOLOCK)
GO