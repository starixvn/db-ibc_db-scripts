
/*
	Created: Winnie	
	Task:  get max logDate
	DB: DBLOG/bodbCustomerLog
	Date: 20170529
*/ 

SELECT MAX (logdate) FROM UserLog_RunSP WITH(NOLOCK)