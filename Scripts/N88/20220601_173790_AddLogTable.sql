/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220601@Percy
	DB: DBN88-bodb_N88
	Task: Job - Archive data for TpBetRecord - New table log
	https://nexdev.net/issues/173790
*/

USE bodb_N88
GO

CREATE TABLE dbo.JobLog
(
	LogId			INT NOT NULL IDENTITY(1, 1)
	,DataSource		VARCHAR(128)
	,OldData		VARCHAR(MAX)
	,NewData		VARCHAR(MAX)
	,WinlostDate	DATETIME
	,CheckInTime	DATETIME CONSTRAINT DF_JobLog_CheckInTime DEFAULT (CURRENT_TIMESTAMP)
	,IsSendMail		BIT CONSTRAINT DF_JobLog_IsSendMail DEFAULT (0)
	,CONSTRAINT PK_JobLog PRIMARY KEY NONCLUSTERED (LogId)
) ON ReportData
GO