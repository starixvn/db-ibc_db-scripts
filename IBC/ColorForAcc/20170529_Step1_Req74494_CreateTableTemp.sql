
/*
	Created: Winnie	
	Task:  get max logID
	DB: DB06/bodb02 AND DBCUST/CUSTDB
	Date: 20170529
*/ 

CREATE TABLE [dbo].[TempClosedReason](
	[CustID] [int] NOT NULL,	
	[ClosedReason] [tinyint] NULL,
 CONSTRAINT [PK_TempClosedReason] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [table_customer]
) ON [table_customer]

GO

SET ANSI_PADDING OFF
GO


