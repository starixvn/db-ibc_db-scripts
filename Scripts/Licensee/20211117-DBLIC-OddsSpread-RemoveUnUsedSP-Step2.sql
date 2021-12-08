/*<info serverAlias="DBLIC-bodb_licensee"></info>*/
/*
	Created: 20211117@Percy
	DB: DBLIC-bodb_licensee
	Task: Drop un-used SP
	https://nexdev.net/issues/164411
	Step 2: Drop SP
*/
USE bodb_Licensee
GO

DROP PROCEDURE dbo.DEL_LA_PartyListOddsSpreadSel
GO

-- for KBT (PRO) environment
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'LA_PartyListOddsSpreadSel_UAT1')
	DROP PROCEDURE dbo.LA_PartyListOddsSpreadSel_UAT1
GO