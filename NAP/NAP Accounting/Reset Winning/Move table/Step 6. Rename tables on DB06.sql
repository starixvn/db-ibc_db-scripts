USE [bodb_ACC]
GO

/*
	Created by Percy
	Date: 2017-09-25
	DB: DBACC.bodb_ACC
	Task: Extra PT Setting - Rename tables
*/

sp_rename 'Acc_GroupExtraPTSetting', 'Acc_GroupExtraPTSetting_Delete'
go
sp_rename 'Acc_GroupExtraPT_Product', 'Acc_GroupExtraPTSetting_Delete'