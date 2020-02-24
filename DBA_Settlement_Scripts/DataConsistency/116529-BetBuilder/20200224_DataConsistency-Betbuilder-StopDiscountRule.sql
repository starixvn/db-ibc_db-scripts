/*
	Created: 20200224@Helen
	Task: Stop checking rule discount for bet builder - https://nexdev.net/issues/129060 
	DB: DBCONSISTENCY/bodb_Consistency
*/
USE bodb_Consistency
GO
UPDATE s 
	SET IsEnable = 0
FROM DBA_Schedules s WITH (ROWLOCK)
WHERE s.TaskId = 48

GO
	