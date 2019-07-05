-- DB052
use bodb_CustomerLog
go

/*
	Created: 20190705@Percy
	DB: DB052.bodb_CustomerLog
	Task: Clean data on DB052.bodb_CustomerLog
*/

-- 3 LA_ tables + 4 OAS_ tables = 7 tables

delete dbo.LA_LogAction with (rowlock, updlock)
go

delete dbo.LA_LogActionType with (rowlock, updlock)
go

delete dbo.LA_UserLog_RunSP with (rowlock, updlock)
go

delete dbo.OAS_LogAction with (rowlock, updlock)
go

delete dbo.OAS_LogActionType with (rowlock, updlock)
go

delete dbo.OAS_UserLog_RunSP with (rowlock, updlock)
go

delete dbo.OAS_UserLog_Login with (rowlock, updlock)
go