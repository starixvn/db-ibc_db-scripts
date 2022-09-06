/*<info serverAlias="DBTXN-CustDB,DBTXN-LogDB"></info>*/
/*
	Created: 20220906@Sol
	DB: DBTXN-CustDB,DBTXN-LogDB
	Task: grant permisson to Dot_Evolution - [RedmineID: #175297]
*/

Use CustDB

GO

--- revoke redundant permission
REVOKE SELECT ON SiteDBConfig TO Dot_Evolution
REVOKE SELECT ON [site] TO Dot_Evolution

GO

--- add new permission
GRANT SELECT ON custinfo TO Dot_Evolution
GRANT SELECT ON exchange TO Dot_Evolution
GRANT SELECT ON Customer TO Dot_Evolution

GO

---- new login and permission on LogDB - sp = WriteLog_UserLog
USE [LogDB]

GO

CREATE USER Dot_Evolution FOR LOGIN Dot_Evolution

GO

GRANT INSERT ON userlog_T0 TO Dot_Evolution
GRANT INSERT ON userlog_T1 TO Dot_Evolution
GRANT INSERT ON userlog_T2 TO Dot_Evolution
GRANT INSERT ON userlog_T3 TO Dot_Evolution

GO