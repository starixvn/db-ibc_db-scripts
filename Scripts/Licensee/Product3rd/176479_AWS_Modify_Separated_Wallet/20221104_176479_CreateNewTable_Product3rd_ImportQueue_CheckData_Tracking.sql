/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20221104@Sol
	DB: DBLIC-bodb_LicenseeReport
	Task: Create new table Product3rd_ImportQueue_CheckData_Tracking in DB05x - [RedmineID: #176479]
*/

USE bodb_LicenseeReport

GO

CREATE TABLE [dbo].Product3rd_ImportQueue_CheckData_Tracking(
	[QueueID] [bigint] NOT NULL,
	[FinishedTime] [smalldatetime] NULL,
	CONSTRAINT [PK_Product3rd_ImportQueue_CheckData_Tracking] PRIMARY KEY CLUSTERED 
	(
		[QueueID] ASC
	)
)
GO