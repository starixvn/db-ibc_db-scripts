/*
	Created: 20190318@Helen
	Database: DBCUST.CUSTDB
	Original: 
	
	Revisions:
		- 20191126@Helen: Archive TO Control - copy [Redimine:98467]
 */
USE CUSTDB
GO
CREATE NONCLUSTERED INDEX ix_TOControl_Setting_matchid ON TOControl_Setting (matchid)