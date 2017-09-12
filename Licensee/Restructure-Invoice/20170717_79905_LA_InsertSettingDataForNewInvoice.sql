USE bodb_licensee
GO

/*
	Create: 20170717@Harper
	Description: Insert setting for new invoice [RedmineID: #76410]
*/

-- Insert defaul data for InvoiceItemType
INSERT INTO LA_InvoiceItemType (InvItemTypeId, InvItemTypeName, SignDB, GroupDB, SignSOA, GroupSOA)
VALUES (1, 'Software & Data Licensing & Data Transmission Fees', 1, 'Income', 1, 'Amount'),
		(2, 'Setup Fee', 1, 'Income', 1, 'Amount'),
		(3, 'Advance billing for minimum fees for 4th, 5th & 6th month billing', 1, 'Income', 1, 'Combine with 2'),
		(4, 'Less: Discount', -1, 'Expense', -1, 'Combine with 1'),
		(5, 'Deduct advanced minimum fees', -1, 'Expense', 1, 'Payment'),
		(6, 'Rebate on Access Fees', -1, 'Expense', -1, 'Amount'),
		(7, 'Return of advanced minimum fees', 1, 'Income', 1, 'Amount'),
		(8, 'Rack Hosting Fee', 1, 'Income', 1, 'Amount'),
		(9, 'Monthly Service Fee', 1, 'Income', 1, 'Amount'),
		(10, 'Software Data Fee Waive Extended', 1, 'Income', -1, 'Payment'),
		(11, 'Debit for Data Fee', 1, 'Income', 1, 'Amount'),
		(12, 'Credit for Data Fee', 1, 'Expense', 1, 'Payment'),
		(13, 'Debit for Rebate', 1, 'Income', 1, 'Payment'),
		(14, 'Credit for Rebate', 1, 'Expense', -1, 'Amount'),
		(15, 'Payment made with licensees', 1, 'Expense', 1, 'Payment'),
		(16, 'Payment made with rebate resellers', -1, 'Income', 1, 'Payment'),
		(17, 'Software Data Fee (others)', 1, 'Income', 1, 'Combine with 1'),
		(18, 'Setup Fee (others)', 1, 'Income', 1, 'Combine with 2'),
		(19, 'Hosting Fee (others)', 1, 'Income', 1, 'Combine with 8'),
		(20, 'Rebate (others)', -1, 'Expense', -1, 'Combine with 6')
GO

-- Insert 2 new Invoice Types
--INSERT INTO dbo.LA_InvoiceType ( InvTypeName )
--VALUES  ( 'Official Receipt'),
--		('Payment Voucher'),
--		('Debit Note (for return AMF)')
--GO

-- Insert mapping between Invoice Types and InvoiceItem Types
DECLARE @SetupFee SMALLINT, @SofwareFee SMALLINT, @HostFee SMALLINT, @Rebate SMALLINT, 
@Credit SMALLINT, @Debit SMALLINT, @OR SMALLINT, @PV SMALLINT, @DBReturnAMF SMALLINT

SELECT @SetupFee = InvTypeId FROM dbo.LA_InvoiceType WHERE InvTypeName = 'Setup Fees'
SELECT @SofwareFee = InvTypeId FROM dbo.LA_InvoiceType WHERE InvTypeName = 'Software Data & Licensing Fees'
SELECT @HostFee = InvTypeId FROM dbo.LA_InvoiceType WHERE InvTypeName = 'Hosting Fees'
SELECT @Rebate = InvTypeId FROM dbo.LA_InvoiceType WHERE InvTypeName = 'Rebate'
SELECT @Credit = InvTypeId FROM dbo.LA_InvoiceType WHERE InvTypeName = 'Credit Note'
SELECT @Debit = InvTypeId FROM dbo.LA_InvoiceType WHERE InvTypeName = 'Debit Note'
--SELECT @OR = InvTypeId FROM dbo.LA_InvoiceType WHERE InvTypeName = 'Official Receipt'
--SELECT @PV = InvTypeId FROM dbo.LA_InvoiceType WHERE InvTypeName = 'Payment Voucher'
--SELECT @DBReturnAMF = InvTypeId FROM dbo.LA_InvoiceType WHERE InvTypeName = 'Debit Note (for return AMF)'

INSERT INTO dbo.LA_InvoiceTypeMapping ( InvTypeId,  InvItemTypeId)
VALUES  (@SetupFee, 2), (@SetupFee, 3),(@SetupFee, 18),
		(@SofwareFee, 1), (@SofwareFee, 4), (@SofwareFee, 5), (@SofwareFee, 17),
		(@HostFee, 8),(@HostFee, 9),(@HostFee, 19),
		(@Rebate, 6), (@Rebate, 20),
		(@Credit, 10), (@Credit, 12), (@Credit, 14),
		(@Debit, 7), (@Debit, 11), (@Debit, 13)--,
		--(@OR, 15), (@OR, 16),
		--(@PV, 16),
		--(@DBReturnAMF, 7), (@DBReturnAMF, 10)