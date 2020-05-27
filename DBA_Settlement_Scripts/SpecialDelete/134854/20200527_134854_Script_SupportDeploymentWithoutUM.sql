/* 
	Created:20200527@Helen
    Task: 
    DB: dbtrans/bodb02 - https://nexdev.net/issues/134854
	
	Revisions:
		- 20200527@Helen: support deploy without UM - [Redmine:134854]
*/
DECLARE @Delay VARCHAR(100) = ''
SET @Delay = dbo.f_Job_SetWaitforDelay () 
WAITFOR DELAY @Delay