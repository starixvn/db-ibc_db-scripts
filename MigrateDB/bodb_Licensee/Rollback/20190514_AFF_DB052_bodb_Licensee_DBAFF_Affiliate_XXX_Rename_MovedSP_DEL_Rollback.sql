/*
	Created: 20190514@Percy
	Task: Rollback - Moved SPs - Step 1: Rename to DEL_
*/

-- DB052.bodb_Licensee
sp_rename 'DEL_Aff_UserLogin', 'Aff_UserLogin'
go
sp_rename 'DEL_AffAdmin_AdminUser_UpdateGroup', 'AffAdmin_AdminUser_UpdateGroup'
go
sp_rename 'DEL_AffAdmin_CheckIn', 'AffAdmin_CheckIn'
go
sp_rename 'DEL_AffAdmin_GroupInfo_Delete', 'AffAdmin_GroupInfo_Delete'
go
sp_rename 'DEL_AffAdmin_GroupInfo_Insert', 'AffAdmin_GroupInfo_Insert'
go
sp_rename 'DEL_AffAdmin_GroupInfo_Update', 'AffAdmin_GroupInfo_Update'
go
sp_rename 'DEL_AffAdmin_GroupPolicy_Delete', 'AffAdmin_GroupPolicy_Delete'
go
sp_rename 'DEL_AffAdmin_GroupPolicy_Insert', 'AffAdmin_GroupPolicy_Insert'
go
sp_rename 'DEL_AffAdmin_GroupPolicy_Update', 'AffAdmin_GroupPolicy_Update'
go
sp_rename 'DEL_AffAdmin_ReCheckIn', 'AffAdmin_ReCheckIn'
go
sp_rename 'DEL_AffAdmin_UserInfoSelByUserName', 'AffAdmin_UserInfoSelByUserName'
go
sp_rename 'DEL_AffAdmin_UserPolicy_Insert', 'AffAdmin_UserPolicy_Insert'
go
sp_rename 'DEL_AffAdmin_UserPolicy_Update', 'AffAdmin_UserPolicy_Update'
go

-- DBAFF.Affiliate_XXX
sp_rename 'DEL_AffAdmin_ITAdminUser_Insert', 'AffAdmin_ITAdminUser_Insert'
go
sp_rename 'DEL_AffAdmin_ITAdminUser_Update', 'AffAdmin_ITAdminUser_Update'
go
sp_rename 'DEL_AffAdmin_f_AdminUserInfo_Select', 'AffAdmin_f_AdminUserInfo_Select'
go
sp_rename 'DEL_AffAdmin_f_GetITGroupID', 'AffAdmin_f_GetITGroupID'
go
sp_rename 'DEL_AffAdmin_f_OnUser_Select', 'AffAdmin_f_OnUser_Select'
go
sp_rename 'DEL_AffAdmin_f_UserPolicy_Select', 'AffAdmin_f_UserPolicy_Select'
go
sp_rename 'DEL_AffAdmin_f_GroupPolicy_Select', 'AffAdmin_f_GroupPolicy_Select'
go
sp_rename 'DEL_AffAdmin_f_FunctionInfo_Select', 'AffAdmin_f_FunctionInfo_Select'
go
sp_rename 'DEL_AffAdmin_f_GroupInfo_Select', 'AffAdmin_f_GroupInfo_Select'
go
sp_rename 'DEL_AffAdmin_f_IsITAdmin', 'AffAdmin_f_IsITAdmin'
go
sp_rename 'DEL_AffAdmin_UserCurrency_Delete', 'AffAdmin_UserCurrency_Delete'
go
sp_rename 'DEL_AffAdmin_UserCurrency_Insert', 'AffAdmin_UserCurrency_Insert'
go
sp_rename 'DEL_AffAdmin_Con_AdminPolicySelByCustID', 'AffAdmin_Con_AdminPolicySelByCustID'
go
sp_rename 'DEL_AffAdmin_Con_Batch_PolicySel', 'AffAdmin_Con_Batch_PolicySel'
go
sp_rename 'DEL_AffAdmin_Con_GroupInfoSel', 'AffAdmin_Con_GroupInfoSel'
go
sp_rename 'DEL_AffAdmin_Con_GroupPolicyUpd', 'AffAdmin_Con_GroupPolicyUpd'
go
sp_rename 'DEL_AffAdmin_Con_PolicySelByCustID', 'AffAdmin_Con_PolicySelByCustID'
go
sp_rename 'DEL_AffAdmin_Con_PolicyUpd', 'AffAdmin_Con_PolicyUpd'
go
sp_rename 'DEL_AffAdmin_Con_SelByGroupID', 'AffAdmin_Con_SelByGroupID'
go
