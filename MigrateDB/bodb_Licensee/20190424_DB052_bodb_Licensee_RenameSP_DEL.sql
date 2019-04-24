use [bodb_licensee]
go

/*
	Created: 20190424@Percy
	DB: DB052.bodb_Licensee
	Task: Un-use SPs - Step 1: Rename to DEL_
*/

sp_rename 'Aff_InternalLogin', 'DEL_Aff_InternalLogin'
go
sp_rename 'Aff_SyncInternalUser', 'DEL_Aff_SyncInternalUser'
go
sp_rename 'Aff_UserLogout', 'DEL_Aff_UserLogout'
go
sp_rename 'AffAdmin_AdminUser_UpdateGroup', 'DEL_AffAdmin_AdminUser_UpdateGroup'
go
sp_rename 'AffAdmin_GroupInfo_Delete', 'DEL_AffAdmin_GroupInfo_Delete'
go
sp_rename 'AffAdmin_GroupInfo_Insert', 'DEL_AffAdmin_GroupInfo_Insert'
go
sp_rename 'AffAdmin_GroupInfo_Update', 'DEL_AffAdmin_GroupInfo_Update'
go
sp_rename 'AffAdmin_GroupPolicy_Delete', 'DEL_AffAdmin_GroupPolicy_Delete'
go
sp_rename 'AffAdmin_GroupPolicy_Insert', 'DEL_AffAdmin_GroupPolicy_Insert'
go
sp_rename 'AffAdmin_GroupPolicy_Update', 'DEL_AffAdmin_GroupPolicy_Update'
go
sp_rename 'AffAdmin_UserPolicy_Insert', 'DEL_AffAdmin_UserPolicy_Insert'
go
sp_rename 'AffAdmin_UserPolicy_Update', 'DEL_AffAdmin_UserPolicy_Update'
go