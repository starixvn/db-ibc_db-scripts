/*<info serverAlias="DBTXN-bodb02"></info>*/
USE bodb02

/*
	Created: 20230530@Evan
	DB: DBTXN-bodb02
	Task: Drop un-used SP [Redmine: #173554]
*/
GO

EXEC sp_rename 'Acc_CheckProcessingData', 'DEL_Acc_CheckProcessingData'

EXEC sp_rename 'Acc_ShowNotificationWhenProcessingData', 'DEL_Acc_ShowNotificationWhenProcessingData'