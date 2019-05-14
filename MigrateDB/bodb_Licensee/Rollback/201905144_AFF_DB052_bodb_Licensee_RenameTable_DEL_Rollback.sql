use [bodb_licensee]
go

/*
	Created: 20190514@Percy
	DB: DB052.bodb_Licensee
	Task: Rollback - Un-use tables - Step 1: Rename to DEL_
*/

sp_rename 'DEL_Aff_User_CreatorTransfer', 'Aff_User_CreatorTransfer'
go