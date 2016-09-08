
/*
 Created: 20160905Winnie
 Task : ColossusBet
 DB: DBCUST/CUSTDB DB06/bodb02
*/
--USE [CustDB]
--GO

/****** Object:  Table [dbo].[Dep_AgentCommRate]    Script Date: 08/25/2016 03:53:48 ******/

/****** Object:  Table [dbo].[Dep_AgentCommRate]    Script Date: 08/25/2016 03:53:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Dep_AgentCommRate](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[CommRate] [decimal](9, 8) NULL,
 CONSTRAINT [PK_Dep_AgentCommRate] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustSetting3rd_table]
) ON [Dep_CustSetting3rd_table]

GO

/****** Object:  Table [dbo].[Dep_CustCommRate]    Script Date: 08/25/2016 03:53:28 ******/

/****** Object:  Table [dbo].[Dep_CustCommRate]    Script Date: 08/25/2016 03:53:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Dep_CustCommRate](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[sdiscount] [decimal](9, 8) NULL,
	[adiscount] [decimal](9, 8) NULL,
	[discount] [decimal](9, 8) NULL,
	[playerdiscount] [decimal](9, 8) NULL,
 CONSTRAINT [PK_Dep_CustCommRate] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustSetting3rd_table]
) ON [Dep_CustSetting3rd_table]

GO