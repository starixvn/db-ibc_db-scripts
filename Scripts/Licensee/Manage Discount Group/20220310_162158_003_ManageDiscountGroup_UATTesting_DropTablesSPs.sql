/*<info serverAlias="DBLIC-bodb_Licensee"></info>*/
/*
	Created: 20220310@Percy
	DB: DBLIC-bodb_Licensee
	Task: New discount tables for UAT testing
		- Drop tables & SPs after testing
*/
USE bodb_Licensee
GO

DROP TABLE dbo.LA_DiscountGroupAssignment_UAT
DROP TABLE dbo.LA_DiscountGroupCurrency_UAT
DROP TABLE dbo.LA_DiscountGroupDetail_UAT
DROP TABLE dbo.LA_DiscountGroupHeader_UAT
DROP TABLE dbo.LA_DiscountGroupProduct_UAT

DROP PROCEDURE dbo.LA_DiscountSettingInfoSel_xpre
DROP PROCEDURE dbo.LA_DiscountByGrossWinIns_xpre
DROP PROCEDURE dbo.LA_DiscountByGrossWinUpd_xpre
DROP PROCEDURE dbo.LA_DiscountDel_xpre
DROP PROCEDURE dbo.LA_DiscountedCurrencySel_xpre
DROP PROCEDURE dbo.LA_DiscountGet_xpre
DROP PROCEDURE dbo.LA_DiscountGroupCurrencySel_xpre
DROP PROCEDURE dbo.LA_DiscountIns_xpre
DROP PROCEDURE dbo.LA_DiscountUpd_xpre
DROP PROCEDURE dbo.LA_Discount_AvailablePartyListSel_xpre
DROP PROCEDURE dbo.LA_Discount_PartyHasBillingSel_xpre
DROP PROCEDURE dbo.LA_LicenseeDiscountSel_xpre