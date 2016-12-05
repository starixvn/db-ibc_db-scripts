/*
	Created: 20161201@Winnie
	Task: Grant permission - [RedmineID: #67772]
	DB: DBPOLICY/bodb02
*/
Use bodb02
Go
GRANT EXECUTE ON [dbo].Acc_Con_FileNameSelByCustID TO BODBDownlineNetView
GRANT EXECUTE ON [dbo].Acc_Con_FileNameSelByCustID TO BODBDownlineNet


GO


Use bodb_CustomerLog
Go
GRANT EXECUTE ON [dbo].NAP_UserLog_SmartPunterIns TO BODBDownlineNetView
GRANT EXECUTE ON [dbo].NAP_UserLog_SmartPunterIns TO BODBDownlineNet


GO



