/*
	Created: 20190424@Percy
	Task: Moved SPs - Step 1: Rename to DEL_
*/

-- DB052.bodb_Licensee
sp_rename 'Aff_UserLogin', 'DEL_Aff_UserLogin'
go
sp_rename 'AffAdmin_AdminUser_UpdateGroup', 'DEL_AffAdmin_AdminUser_UpdateGroup'
go
sp_rename 'AffAdmin_CheckIn', 'DEL_AffAdmin_CheckIn'
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
sp_rename 'AffAdmin_ReCheckIn', 'DEL_AffAdmin_ReCheckIn'
go
sp_rename 'AffAdmin_UserInfoSelByUserName', 'DEL_AffAdmin_UserInfoSelByUserName'
go
sp_rename 'AffAdmin_UserPolicy_Insert', 'DEL_AffAdmin_UserPolicy_Insert'
go
sp_rename 'AffAdmin_UserPolicy_Update', 'DEL_AffAdmin_UserPolicy_Update'
go

-- DBAFF.Affiliate_XXX
sp_rename 'AffAdmin_ITAdminUser_Insert', 'DEL_AffAdmin_ITAdminUser_Insert'
go
sp_rename 'AffAdmin_ITAdminUser_Update', 'DEL_AffAdmin_ITAdminUser_Update'
go
sp_rename 'AffAdmin_f_AdminUserInfo_Select', 'DEL_AffAdmin_f_AdminUserInfo_Select'
go
sp_rename 'AffAdmin_f_GetITGroupID', 'DEL_AffAdmin_f_GetITGroupID'
go
sp_rename 'AffAdmin_f_OnUser_Select', 'DEL_AffAdmin_f_OnUser_Select'
go
sp_rename 'AffAdmin_f_UserPolicy_Select', 'DEL_AffAdmin_f_UserPolicy_Select'
go
sp_rename 'AffAdmin_f_GroupPolicy_Select', 'DEL_AffAdmin_f_GroupPolicy_Select'
go
sp_rename 'AffAdmin_f_FunctionInfo_Select', 'DEL_AffAdmin_f_FunctionInfo_Select'
go
sp_rename 'AffAdmin_f_GroupInfo_Select', 'DEL_AffAdmin_f_GroupInfo_Select'
go
sp_rename 'AffAdmin_f_IsITAdmin', 'DEL_AffAdmin_f_IsITAdmin'
go
sp_rename 'AffAdmin_UserCurrency_Delete', 'DEL_AffAdmin_UserCurrency_Delete'
go
sp_rename 'AffAdmin_UserCurrency_Insert', 'DEL_AffAdmin_UserCurrency_Insert'
go
sp_rename 'AffAdmin_Con_AdminPolicySelByCustID', 'DEL_AffAdmin_Con_AdminPolicySelByCustID'
go
sp_rename 'AffAdmin_Con_Batch_PolicySel', 'DEL_AffAdmin_Con_Batch_PolicySel'
go
sp_rename 'AffAdmin_Con_GroupInfoSel', 'DEL_AffAdmin_Con_GroupInfoSel'
go
sp_rename 'AffAdmin_Con_GroupPolicyUpd', 'DEL_AffAdmin_Con_GroupPolicyUpd'
go
sp_rename 'AffAdmin_Con_PolicySelByCustID', 'DEL_AffAdmin_Con_PolicySelByCustID'
go
sp_rename 'AffAdmin_Con_PolicyUpd', 'DEL_AffAdmin_Con_PolicyUpd'
go
sp_rename 'AffAdmin_Con_SelByGroupID', 'DEL_AffAdmin_Con_SelByGroupID'
go