/*
	Created: Elodie
	Date: 20160420
	Task: prepare data for tmpCustGameKind
	DB: DBCUST/06/TP/MNL.bodb02	
*/ 
--step 0: prepare structure for tmpCustGameKind on DBCUST
USE [CustDB]
GO

/****** Object:  Table [dbo].[tmpCustGameKind]    Script Date: 9/24/2015 4:52:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tmpCustGameKind](
	[CustID] [int] NOT NULL,
	[SPositionTaking] [smallmoney] NULL,
	[MPositionTaking] [smallmoney] NULL,
	[APositionTaking] [smallmoney] NULL,
	[IsAutoPositionTaking] [bit] NULL,
	[AutoPositionTaking] [smallmoney] NULL,
	[MaxPositionTaking] [smallmoney] NULL,
	[MinPositionTaking] [smallmoney] NULL,
	[SMAgentRollingRate] [decimal](9, 8) NULL,
	[MAgentRollingRate] [decimal](9, 8) NULL,
	[AgentRollingRate] [decimal](9, 8) NULL,
	[MemberRollingRate] [decimal](9, 8) NULL,
	[IsAutoMPositionTaking] [bit] NULL,
	[AutoMPositionTaking] [smallmoney] NULL,
 CONSTRAINT [PK_tmpCustGameKind] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustGameType_table]
) ON [CustGameType_table]

GO
GO

SET ANSI_PADDING OFF
GO
-----------------INSERT SYNC-ED Customers----------------------------------

USE [CustDB]
GO
INSERT INTO [dbo].[tmpCustGameKind] ([CustID]
           ,[SPositionTaking]
           ,[MPositionTaking]
           ,[APositionTaking]
           ,[IsAutoPositionTaking]
           ,[AutoPositionTaking]
           ,[MaxPositionTaking]
           ,[MinPositionTaking]
           ,[SMAgentRollingRate]
           ,[MAgentRollingRate]
           ,[AgentRollingRate]
           ,[MemberRollingRate]
           ,[IsAutoMPositionTaking]
           ,[AutoMPositionTaking])
SELECT	c.IBCCustID,
		ISNULL(SPositionTaking,0), 
		ISNULL(MPositionTaking, 
		ISNULL(APositionTaking, 
		ISNULL(IsAutoPositionTaking, 
		ISNULL(AutoPositionTaking, 
		ISNULL(MaxPositionTaking, 
		MinPositionTaking,
		SMAgentRollingRate, 
		MAgentRollingRate, 
		AgentRollingRate, 
		MemberRollingRate,
		ISNULL(IsAutoMPositionTaking, 
		ISNULL(AutoMPositionTaking 
FROM DBBingoAdmin.CasinoAdmin.dbo.CustGameKind cs WITH(NOLOCK) 
	INNER JOIN DBBingoAdmin.CasinoAdmin.dbo.customer c WITH (NOLOCK) ON cs.CustID = c.CustID
WHERE cs.GameKind = 9 
