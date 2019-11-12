/*
	Task: - Update status of 'pending' members in Dep_Customer_Archived_Config to 'waiting'
	Redmine: #107171
	Creator: Dominic@20190116
	Run at: CustDB@DBCUST
*/
USE CustDB
GO


--Update status of 'pending' members in Dep_Customer_Archived_Config to 'waiting'
--61786 affected rows
WHILE (1=1)
BEGIN
	UPDATE TOP (5000) [dbo].[Dep_Customer_Archived] WITH(ROWLOCK)
	Set status='waiting'
	WHERE status='pending'

	IF @@ROWCOUNT < 5000
		BREAK

	WAITFOR DELAY '00:00:01'
END