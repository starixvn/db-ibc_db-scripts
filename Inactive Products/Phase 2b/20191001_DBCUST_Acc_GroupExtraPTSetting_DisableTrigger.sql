use CustDB
go

/*
	Created: 20191001@Percy
	DB: DBCUST.CustDB
	Task: Remove inactive products - Disable trigger on Acc_GroupExtraPTSetting
*/

alter table [dbo].[Acc_GroupExtraPTSetting] disable trigger [Acc_GroupExtraPTSetting_INSERT]
go

alter table [dbo].[Acc_GroupExtraPTSetting] disable trigger [Acc_GroupExtraPTSetting_UPDATE]
go

alter table [dbo].[Acc_GroupExtraPTSetting] disable trigger [Acc_GroupExtraPTSetting_DELETE]
go