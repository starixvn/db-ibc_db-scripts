-- DB052.bodb_Licensee
USE [bodb_Licensee]
GO

/*
	Created: 20190705@Percy
	DB: DB052.bodb_Licensee
	Task: Drop un-used tables
*/

-- 25 un-used tables + 4 log tables = 29 tables

-- 39 
sp_rename 'LA_LicenseeRebate', 'DEL_LA_LicenseeRebate'
go

-- 55 
sp_rename 'LicenseeEventLog', 'DEL_LicenseeEventLog'
go

-- 56 
sp_rename 'LicenseeSourcedSetting_DanielBK_AddPK', 'DEL_LicenseeSourcedSetting_DanielBK_AddPK'
go

-- 58 
sp_rename 'Lukas_test', 'DEL_Lukas_test'
go

-- 59 
sp_rename 'OA_FunctionLicensees', 'DEL_OA_FunctionLicensees'
go

-- 60 
sp_rename 'OA_FunctionResellers', 'DEL_OA_FunctionResellers'
go

-- 61 
sp_rename 'OA_Functions', 'DEL_OA_Functions'
go

-- 62 
sp_rename 'OA_GroupFunctions', 'DEL_OA_GroupFunctions'
go

-- 63 
sp_rename 'OA_GroupLicensees', 'DEL_OA_GroupLicensees'
go

-- 64 
sp_rename 'OA_GroupResellers', 'DEL_OA_GroupResellers'
go

-- 65 
sp_rename 'OA_Groups', 'DEL_OA_Groups'
go

-- 66 
sp_rename 'OA_LogAction', 'DEL_OA_LogAction'
go

-- 67 
sp_rename 'OA_LogActionType', 'DEL_OA_LogActionType'
go

-- 68 
sp_rename 'OA_Menus', 'DEL_OA_Menus'
go

-- 69 
sp_rename 'OA_OnUser', 'DEL_OA_OnUser'
go

-- 70 
sp_rename 'OA_UserFunctions', 'DEL_OA_UserFunctions'
go

-- 71 
sp_rename 'OA_UserLicensees', 'DEL_OA_UserLicensees'
go

-- 72 
sp_rename 'OA_UserLog_Login', 'DEL_OA_UserLog_Login'
go

-- 73 
sp_rename 'OA_UserLog_RunSP', 'DEL_OA_UserLog_RunSP'
go

-- 74 
sp_rename 'OA_UserResellers', 'DEL_OA_UserResellers'
go

-- 75 
sp_rename 'OA_Users', 'DEL_OA_Users'
go

-- 78 
sp_rename 'OAS_LogAction', 'DEL_OAS_LogAction'
go

-- 79 
sp_rename 'OAS_LogActionType', 'DEL_OAS_LogActionType'
go

-- 83 
sp_rename 'OAS_UserLog_Login', 'DEL_OAS_UserLog_Login'
go

-- 84 
sp_rename 'OAS_UserLog_RunSP', 'DEL_OAS_UserLog_RunSP'
go

-- 86 
sp_rename 'Party', 'DEL_Party'
go

-- 87 
sp_rename 'ResellerProductCharge', 'DEL_ResellerProductCharge'
go

-- 88 
sp_rename 'ResellerProductChargeByDateRange', 'DEL_ResellerProductChargeByDateRange'
go

-- 89 
sp_rename 'ResellerTransactionRate', 'DEL_ResellerTransactionRate'
go
