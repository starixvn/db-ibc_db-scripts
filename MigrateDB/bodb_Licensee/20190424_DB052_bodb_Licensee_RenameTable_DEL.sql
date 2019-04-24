use [bodb_licensee]
go

/*
	Created: 20190424@Percy
	DB: DB052.bodb_Licensee
	Task: Un-use tables - Step 1: Rename to DEL_
*/

sp_rename 'Aff_LicenseeInfo', 'DEL_Aff_LicenseeInfo'
go
sp_rename 'Aff_User_CreatorTransfer', 'DEL_Aff_User_CreatorTransfer'
go