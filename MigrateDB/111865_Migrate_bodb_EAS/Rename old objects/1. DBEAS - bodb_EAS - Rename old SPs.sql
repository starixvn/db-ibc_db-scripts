USE bodb_EAS
GO

EXEC sp_rename 'EAS_Rpt_WinLossDaily_Ag', 'Delete_EAS_Rpt_WinLossDaily_Ag', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDaily_Ag14', 'Delete_EAS_Rpt_WinLossDaily_Ag14', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDaily_Com', 'Delete_EAS_Rpt_WinLossDaily_Com', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDaily_Com14', 'Delete_EAS_Rpt_WinLossDaily_Com14', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDaily_MAg', 'Delete_EAS_Rpt_WinLossDaily_MAg', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDaily_MAg14', 'Delete_EAS_Rpt_WinLossDaily_MAg14', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDaily_SAg', 'Delete_EAS_Rpt_WinLossDaily_SAg', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDaily_SAg14', 'Delete_EAS_Rpt_WinLossDaily_SAg14', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDaily_SortingOrder', 'Delete_EAS_Rpt_WinLossDaily_SortingOrder', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDetail_Com', 'Delete_EAS_Rpt_WinLossDetail_Com', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDetail_SAg', 'Delete_EAS_Rpt_WinLossDetail_SAg', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDetail_MAg', 'Delete_EAS_Rpt_WinLossDetail_MAg', 'OBJECT'
GO
EXEC sp_rename 'EAS_Rpt_WinLossDetail_Ag', 'Delete_EAS_Rpt_WinLossDetail_Ag', 'OBJECT'
GO
EXEC sp_rename 'EAS_CustomerUpdUserSearch', 'Delete_EAS_CustomerUpdUserSearch', 'OBJECT'
GO
EXEC sp_rename 'EAS_CustomerSelUserInfo', 'Delete_EAS_CustomerSelUserInfo', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupInfoDel', 'Delete_EAS_GroupInfoDel', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupInfoIns', 'Delete_EAS_GroupInfoIns', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupInfoSel', 'Delete_EAS_GroupInfoSel', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupInfoSelAllGroup', 'Delete_EAS_GroupInfoSelAllGroup', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupInfoSelByGroupID', 'Delete_EAS_GroupInfoSelByGroupID', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupInfoSelExternalGroup', 'Delete_EAS_GroupInfoSelExternalGroup', 'OBJECT'
GO
EXEC sp_rename 'DBA_GrantPermissions', 'Delete_DBA_GrantPermissions', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupInfoUpd', 'Delete_EAS_GroupInfoUpd', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupPolicySel', 'Delete_EAS_GroupPolicySel', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupPolicyUpd', 'Delete_EAS_GroupPolicyUpd', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserCheckPermission', 'Delete_EAS_UserCheckPermission', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupConfigurationSel', 'Delete_EAS_GroupConfigurationSel', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserCheckPermission_All', 'Delete_EAS_UserCheckPermission_All', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupConfigurationUpd', 'Delete_EAS_GroupConfigurationUpd', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserInfoAddExistingUser', 'Delete_EAS_UserInfoAddExistingUser', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupPolicySelByFuncID', 'Delete_EAS_GroupPolicySelByFuncID', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserInfoSel', 'Delete_EAS_UserInfoSel', 'OBJECT'
GO
EXEC sp_rename 'EAS_GroupPolicyUpdMultiple', 'Delete_EAS_GroupPolicyUpdMultiple', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserInfoSelByUserID', 'Delete_EAS_UserInfoSelByUserID', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserPolicySelByFuncID', 'Delete_EAS_UserPolicySelByFuncID', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserInfoUpdStatus', 'Delete_EAS_UserInfoUpdStatus', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserPolicyUpdMultiple', 'Delete_EAS_UserPolicyUpdMultiple', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserInfoUpdUserGroup', 'Delete_EAS_UserInfoUpdUserGroup', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserPolicySel', 'Delete_EAS_UserPolicySel', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserPolicyUpd', 'Delete_EAS_UserPolicyUpd', 'OBJECT'
GO
EXEC sp_rename 'EAS_FunctionIns', 'Delete_EAS_FunctionIns', 'OBJECT'
GO
EXEC sp_rename 'EAS_FunctionSel', 'Delete_EAS_FunctionSel', 'OBJECT'
GO
EXEC sp_rename 'EAS_FunctionSelEdit', 'Delete_EAS_FunctionSelEdit', 'OBJECT'
GO
EXEC sp_rename 'EAS_FunctionUpd', 'Delete_EAS_FunctionUpd', 'OBJECT'
GO
EXEC sp_rename 'EAS_FuncUpdStatus', 'Delete_EAS_FuncUpdStatus', 'OBJECT'
GO
EXEC sp_rename 'EAS_MenuDel', 'Delete_EAS_MenuDel', 'OBJECT'
GO
EXEC sp_rename 'EAS_MenuIns', 'Delete_EAS_MenuIns', 'OBJECT'
GO
EXEC sp_rename 'EAS_MenuSel', 'Delete_EAS_MenuSel', 'OBJECT'
GO
EXEC sp_rename 'EAS_MenuSelByUserID', 'Delete_EAS_MenuSelByUserID', 'OBJECT'
GO
EXEC sp_rename 'EAS_MenuUpd', 'Delete_EAS_MenuUpd', 'OBJECT'
GO
EXEC sp_rename 'EAS_MenuUpdStatus', 'Delete_EAS_MenuUpdStatus', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserCheckIn', 'Delete_EAS_UserCheckIn', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserLogout', 'Delete_EAS_UserLogout', 'OBJECT'
GO
EXEC sp_rename 'EAS_UserRecheckIn', 'Delete_EAS_UserRecheckIn', 'OBJECT'
GO
EXEC sp_rename 'Task_EAS_ClearLogin', 'Delete_Task_EAS_ClearLogin', 'OBJECT'
GO
EXEC sp_rename 'Acc_ExternalGroupSel', 'Delete_Acc_ExternalGroupSel', 'OBJECT'
GO
EXEC sp_rename 'Task_EAS_ClearLogin_Loop', 'Delete_Task_EAS_ClearLogin_Loop', 'OBJECT'
GO
EXEC sp_rename 'Task_STDBY_SYNC_EAS', 'Delete_Task_STDBY_SYNC_EAS', 'OBJECT'
GO