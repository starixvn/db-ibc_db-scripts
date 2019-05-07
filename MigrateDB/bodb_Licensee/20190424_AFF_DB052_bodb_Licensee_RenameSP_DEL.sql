/*
	Created: 20190424@Percy
	Task: Un-use SPs - Step 1: Rename to DEL_
*/

-- DB052.bodb_Licensee
sp_rename 'Aff_InternalLogin', 'DEL_Aff_InternalLogin'
go
sp_rename 'Aff_SyncInternalUser', 'DEL_Aff_SyncInternalUser'
go
sp_rename 'Aff_UserLogout', 'DEL_Aff_UserLogout'
go

-- DBAFF.Affiliate_XXX
sp_rename 'AffAdmin_CheckPermissionCurrency', 'DEL_AffAdmin_CheckPermissionCurrency'
go
sp_rename 'AffAdmin_CommGroupSelListCurrent', 'DEL_AffAdmin_CommGroupSelListCurrent'
go
sp_rename 'AffAdmin_Con_CheckPermission', 'DEL_AffAdmin_Con_CheckPermission'
go
sp_rename 'AffAdmin_IsITAdminAccount', 'DEL_AffAdmin_IsITAdminAccount'
go
sp_rename 'AffAdmin_PermissionOnAffiliate', 'DEL_AffAdmin_PermissionOnAffiliate'
go
sp_rename 'Aff_User_AffiliateInternalLogin', 'DEL_Aff_User_AffiliateInternalLogin'
go
sp_rename 'Aff_User_OnUserSelNetSessionID', 'DEL_Aff_User_OnUserSelNetSessionID'
go