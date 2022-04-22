/*<info serverAlias="DBCUST-bodb_Licensee" executers="bodbAdminNet" isFunction="0" isNested="0"></info>*/
/*
	Created: 20220418@Percy
	DB: DBCUST-bodb_Licensee
	Task: Insert new invoice item type for Credit Note for Setup Fee & AMF [RedmineID: #164139]
*/

USE bodb_Licensee
GO

INSERT INTO dbo.LA_InvoiceItemType (InvItemTypeId, InvItemTypeName, SignDB, GroupDB, SignSOA, GroupSOA)
VALUES
	(45, 'Credit for Setup Fee', 1, 'Expense', -1, 'Amount'),
	(46, 'Credit for advanced minimum fees', 1, 'Expense', -1, 'Amount')
GO

INSERT INTO dbo.LA_InvoiceTypeMapping (InvTypeId, InvItemTypeId)
VALUES (4, 45), (4, 46)
GO