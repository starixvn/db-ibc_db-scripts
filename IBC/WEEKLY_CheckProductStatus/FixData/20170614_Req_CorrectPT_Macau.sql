/*
	Created: 20170614@Helen
	Task: Correct PT Macau
	DB:DBCUST/CUSTDB
	Execution Date:
*/
USE CUSTDB
GO
UPDATE CS
	SET MasterPT = 70
FROM dbo.CustPTSetting3rd_Member CS WITH (ROWLOCK,UPDLOCK)
WHERE CS.CustID = 22293220 AND CS.SportType = 212
GO

