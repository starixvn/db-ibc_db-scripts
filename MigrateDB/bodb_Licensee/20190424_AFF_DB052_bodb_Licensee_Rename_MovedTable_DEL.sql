use [bodb_licensee]
go

/*
	Created: 20190424@Percy
	DB: DB052.bodb_Licensee
	Task: Moved tables - Step 1: Rename to DEL_
*/

sp_rename 'Aff_User_CreatorTransfer', 'DEL_Aff_User_CreatorTransfer'
go

sp_rename 'Aff_FunctionInfo', 'DEL_Aff_FunctionInfo'
go

sp_rename 'Aff_GroupInfo', 'DEL_Aff_GroupInfo'
go

sp_rename 'Aff_GroupPolicy', 'DEL_Aff_GroupPolicy'
go

sp_rename 'Aff_LicenseeFunction', 'DEL_Aff_LicenseeFunction'
go

sp_rename 'Aff_LicenseeInfo', 'DEL_Aff_LicenseeInfo'
go

sp_rename 'Aff_LicenseeUser', 'DEL_Aff_LicenseeUser'
go

sp_rename 'Aff_On_User', 'DEL_Aff_On_User'
go

sp_rename 'Aff_UserPolicy', 'DEL_Aff_UserPolicy'
go