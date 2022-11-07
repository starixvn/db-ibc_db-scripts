/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20221104@Sol
	DB: DBLIC-bodb_LicenseeReport
	Task: Create new table Product3rd_ImportQueue_Tracking in DB05x - [RedmineID: #176479]
*/

USE bodb_LicenseeReport

GO

CREATE TABLE [dbo].Product3rd_ImportQueue_Tracking(
	[QueueID] [bigint] NOT NULL,
	[FinishedTime] [smalldatetime] NULL,
	[isSummarized] [bit] NULL,
	CONSTRAINT [PK_Product3rd_ImportQueue_Tracking] PRIMARY KEY CLUSTERED 
	(
		[QueueID] ASC
	)
) 
GO

ALTER TABLE [dbo].Product3rd_ImportQueue_Tracking ADD  CONSTRAINT [DF_Product3rd_ImportQueue_Tracking_isSummarized]  DEFAULT ((0)) FOR [isSummarized]
GO