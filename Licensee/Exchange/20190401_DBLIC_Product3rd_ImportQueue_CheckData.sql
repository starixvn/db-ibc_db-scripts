USE [bodb_PlaytechCS]
GO

/*
	Created: 20190401@Percy
	DB: DBLIC.bodb_3rdProduct
	Task: New table for checking 3rd data
*/

CREATE TABLE [dbo].[Product3rd_ImportQueue_CheckData](
	[QueueID] [bigint] IDENTITY(1,1) NOT NULL,
	[CheckInTime] [smalldatetime] NULL,
	[FinishedTime] [smalldatetime] NULL,
	[LicenseeName] [varchar](50) NULL,
	[ProductID] [int] NULL,
	[XmlData] [xml] NULL,
	[Winlostdate] [date] NULL,
	[LogDesc] [varchar](2000) NULL,
	CONSTRAINT [PK_Product3rd_ImportQueue_CheckData] PRIMARY KEY CLUSTERED 
	(
		[QueueID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PlaytechCS_Table]
) ON [PlaytechCS_Table] TEXTIMAGE_ON [PlaytechCS_Table]
GO