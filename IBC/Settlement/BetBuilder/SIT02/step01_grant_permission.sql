/*
	Created: 20190130@Vicky
	Task : GRANT permission
	DB:  SIT02DBTXN/bodb02
*/
USE bodb02
GO
GRANT EXECUTE ON [dbo].[NAP_Admin_Settlement_BetBuilder_Push] TO [Dot_Intg]
GO
GRANT EXECUTE ON [dbo].[NAP_Admin_Settlement_BetBuilder] TO [Dot_Intg]
GO
GRANT EXECUTE ON [dbo].[NAP_Admin_Settlement_AutoWriteLog] TO [Dot_Intg]
GO
GRANT EXECUTE ON [dbo].[NAP_Set_NotificationIns] TO [Dot_Intg]
GO