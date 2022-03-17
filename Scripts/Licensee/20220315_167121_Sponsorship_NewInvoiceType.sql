/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20220315@Percy
	DB: DBCUST-bodb_Licensee
	Task: LA - Invoice - Add new invoice type: Sponsorship
*/
USE bodb_Licensee
GO

INSERT INTO dbo.LA_InvoiceItemType (InvItemTypeId, InvItemTypeName, SignDB, GroupDB, SignSOA, GroupSOA)
VALUES (44, 'Sponsorship', -1, 'Expense', -1, 'Combine with 1')
GO