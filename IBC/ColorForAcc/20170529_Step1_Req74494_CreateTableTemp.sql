
/*
	Created: Winnie	
	Task:  create 2 tables temp
	DB: DBCUST/CUSTDB AND DB052/bodb02
	Date: 20170719
*/ 

CREATE TABLE [dbo].[TempClosedReason](
	[CustID] [int] NOT NULL,	
	[ClosedReason] [tinyint] NULL,
	LogDate		DATETIME NULL,	
 CONSTRAINT [PK_TempClosedReason] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [table_customer]
) ON [table_customer]

GO
CREATE TABLE [dbo].[TempClosedReasonMember](
	[CustID] [int] NOT NULL,	
	[ClosedReason] [tinyint] NULL,
	LogDate		DATETIME NULL,
 CONSTRAINT [PK_TempClosedReasonMember] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [table_customer]
) ON [table_customer]

GO

