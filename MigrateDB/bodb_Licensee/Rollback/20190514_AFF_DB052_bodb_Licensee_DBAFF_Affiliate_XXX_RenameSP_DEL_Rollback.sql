/*
	Created: 20190514@Percy
	Task: Rollback - Un-use SPs - Step 1: Rename to DEL_
*/

-- DB052.bodb_Licensee
sp_rename 'DEL_Aff_InternalLogin', 'Aff_InternalLogin'
go
sp_rename 'DEL_Aff_SyncInternalUser', 'Aff_SyncInternalUser'
go
sp_rename 'DEL_Aff_UserLogout', 'Aff_UserLogout'
go

-- DBAFF.Affiliate_XXX
sp_rename 'DEL_AffAdmin_CheckPermissionCurrency', 'AffAdmin_CheckPermissionCurrency'
go
sp_rename 'DEL_AffAdmin_CommGroupSelListCurrent', 'AffAdmin_CommGroupSelListCurrent'
go
sp_rename 'DEL_AffAdmin_Con_CheckPermission', 'AffAdmin_Con_CheckPermission'
go
sp_rename 'DEL_AffAdmin_IsITAdminAccount', 'AffAdmin_IsITAdminAccount'
go
sp_rename 'DEL_AffAdmin_PermissionOnAffiliate', 'AffAdmin_PermissionOnAffiliate'
go
sp_rename 'DEL_Aff_User_AffiliateInternalLogin', 'Aff_User_AffiliateInternalLogin'
go
sp_rename 'DEL_Aff_User_OnUserSelNetSessionID', 'Aff_User_OnUserSelNetSessionID'
go
sp_rename 'DEL_Aff_Con_CheckPermission', 'Aff_Con_CheckPermission'
go
