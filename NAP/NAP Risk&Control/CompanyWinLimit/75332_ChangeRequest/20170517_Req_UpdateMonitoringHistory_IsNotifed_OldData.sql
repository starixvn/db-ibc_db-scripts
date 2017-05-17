/*
	Create: 20170517@Helen
	Task : NAP Risk & Control - Phase 3 [Redmine: 75332]
	DB: DBCUST/CustDB
*/
USE CustDB
GO
UPDATE CGMH
	SET IsNotified = 1
FROM WinLimit_CustGameMonitoring_History  CGMH WITH (ROWLOCK,UPDLOCK)
	

	
