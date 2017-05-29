
/*
	Created: Winnie	
	Task:  get max logID
	DB: DBLOG/bodbCustomerLog
	Date: 20170529
*/ 

SELECT MAX (logid) FROM UserLog_RunSP WITH(NOLOCK)