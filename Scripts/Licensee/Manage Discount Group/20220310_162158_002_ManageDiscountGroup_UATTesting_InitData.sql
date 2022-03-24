/*<info serverAlias="DBLIC-bodb_Licensee"></info>*/
/*
	Created: 20220310@Percy
	DB: DBLIC-bodb_Licensee
	Task: New discount tables for UAT testing
		- Initialize data
*/
USE [bodb_licensee]
GO

INSERT INTO dbo.LA_DiscountGroupAssignment_UAT (DiscountGroupId,PartyID,Remark,IsApplyDiscount,IsSpecialTreatment)
SELECT DiscountGroupId,PartyID,Remark,IsApplyDiscount,IsSpecialTreatment
FROM dbo.LA_DiscountGroupAssignment WITH (NOLOCK)
GO

INSERT INTO dbo.LA_DiscountGroupCurrency_UAT (DiscountGroupId,PartyID,CurrencyId,CalculationType)
SELECT DiscountGroupId,PartyID,CurrencyId,CalculationType
FROM dbo.LA_DiscountGroupCurrency WITH (NOLOCK)
GO

SET IDENTITY_INSERT dbo.LA_DiscountGroupDetail_UAT ON
INSERT INTO dbo.LA_DiscountGroupDetail_UAT (DiscountGroupDetailId,DiscountGroupId,FromAmount,ToAmount,Rate)
SELECT DiscountGroupDetailId,DiscountGroupId,FromAmount,ToAmount,Rate
FROM dbo.LA_DiscountGroupDetail WITH (NOLOCK)
SET IDENTITY_INSERT dbo.LA_DiscountGroupDetail_UAT OFF
GO

SET IDENTITY_INSERT dbo.LA_DiscountGroupHeader_UAT ON
INSERT INTO dbo.LA_DiscountGroupHeader_UAT (DiscountGroupId,DiscountGroupName,DiscountGroupType,CurrencyId,FromDate,ToDate,Priority,Remark,ModifiedDate)
SELECT DiscountGroupId,DiscountGroupName,DiscountGroupType,CurrencyId,FromDate,ToDate,Priority,Remark,ModifiedDate
FROM dbo.LA_DiscountGroupHeader WITH (NOLOCK)
SET IDENTITY_INSERT dbo.LA_DiscountGroupHeader_UAT OFF
GO

INSERT INTO dbo.LA_DiscountGroupProduct_UAT (DiscountGroupId,ProductId,CalculationType)
SELECT DiscountGroupId,ProductId,CalculationType
FROM dbo.LA_DiscountGroupProduct WITH (NOLOCK)
GO