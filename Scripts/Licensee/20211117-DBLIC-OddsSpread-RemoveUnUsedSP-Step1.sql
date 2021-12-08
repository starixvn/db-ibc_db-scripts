/*<info serverAlias="DBLIC-bodb_licensee"></info>*/
/*
	Created: 20211117@Percy
	DB: DBLIC-bodb_licensee
	Task: Drop un-used SP
	https://nexdev.net/issues/164411
	Step 1: Rename SP
*/
USE bodb_Licensee
GO

sp_rename 'LA_PartyListOddsSpreadSel', 'DEL_LA_PartyListOddsSpreadSel'