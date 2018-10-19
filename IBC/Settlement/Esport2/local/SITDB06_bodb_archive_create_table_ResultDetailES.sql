USE [bodb02]
GO
---------Table:ResultDetailES
CREATE TABLE [dbo].ResultDetailES(
	[MatchID] [int] NOT NULL,
	[ResourceID] [varchar](20) NOT NULL,
	[HomeValue] [varchar](50) NULL,
	[AwayValue] [varchar](50) NULL,
	[ResultStatusID] [tinyint] NULL,
	[SettlementStatusID] [tinyint] NULL,
	[CreateBy] [int] NULL,
	[CreateDate] [smalldatetime] NULL,
	[LastModifyBy] [int] NULL,
	[LastModifyDate] [smalldatetime] NULL,
	[OtherInfo] [varchar](50) NULL,
	[tstamp] timestamp NOT NULL,
 CONSTRAINT [PK_ResultDetailES] PRIMARY KEY CLUSTERED 
(
	[MatchID] ASC,
	[ResourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Event_table]
) ON [Event_table]
GO
---------Table:ResultDetailES14 
CREATE TABLE [dbo].ResultDetailES14(
	[MatchID] [int] NOT NULL,
	[ResourceID] [varchar](20) NOT NULL,
	[HomeValue] [varchar](50) NULL,
	[AwayValue] [varchar](50) NULL,
	[ResultStatusID] [tinyint] NULL,
	[SettlementStatusID] [tinyint] NULL,
	[CreateBy] [int] NULL,
	[CreateDate] [smalldatetime] NULL,
	[LastModifyBy] [int] NULL,
	[LastModifyDate] [smalldatetime] NULL,
	[OtherInfo] [varchar](50) NULL,
 CONSTRAINT [PK_ResultDetailES14] PRIMARY KEY CLUSTERED 
(
	[MatchID] ASC,
	[ResourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Event14_table]
) ON [Event14_table]
GO

----------------------@SITDB06.bodb_archive
---------Table:ResultDetailES_bk 
use bodb_archive
go

CREATE TABLE [dbo].ResultDetailES_bk(
	[MatchID] [int] NOT NULL,
	[ResourceID] [varchar](20) NOT NULL,
	[HomeValue] [varchar](50) NULL,
	[AwayValue] [varchar](50) NULL,
	[ResultStatusID] [tinyint] NULL,
	[SettlementStatusID] [tinyint] NULL,
	[CreateBy] [int] NULL,
	[CreateDate] [smalldatetime] NULL,
	[LastModifyBy] [int] NULL,
	[LastModifyDate] [smalldatetime] NULL,
	[OtherInfo] [varchar](50) NULL,
CONSTRAINT [PK_ResultDetailES_bk] PRIMARY KEY CLUSTERED 
(
	[MatchID] ASC,
	[ResourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Event]
) ON [Event]
GO
-------------------------------------------------------------------