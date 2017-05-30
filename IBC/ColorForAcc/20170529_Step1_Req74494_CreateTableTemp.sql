
/*
	Created: Winnie	
	Task:  create 2 tables temp
	DB: DB06/bodb02 AND DBCUST/CUSTDB
	Date: 20170529
*/ 

CREATE TABLE [dbo].[TempClosedReason](
	[CustID] [int] NOT NULL,	
	[ClosedReason] [tinyint] NULL,
	LogID		bigint NULL
 CONSTRAINT [PK_TempClosedReason] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [table_customer]
) ON [table_customer]

GO
CREATE TABLE [dbo].[TempClosedReasonMember](
	[CustID] [int] NOT NULL,	
	[ClosedReason] [tinyint] NULL,
	LogID		bigint NULL
 CONSTRAINT [PK_TempClosedReasonMember] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [table_customer]
) ON [table_customer]

GO

