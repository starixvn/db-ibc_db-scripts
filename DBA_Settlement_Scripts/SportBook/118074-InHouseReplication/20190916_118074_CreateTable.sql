/*
	Created: 20190916@Helen
	Task:DBTRANS/bodb02 & DB8CN/CN88
*/

USE [bodb02]
GO

CREATE TABLE [dbo].[CS_SettlementCommand](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[matchid] [int] NULL,
	[sqlcommand] [varchar](max) NULL,
	[createddate] [datetime] NULL CONSTRAINT [DF_CS_SettlementCommand_CreatedDate]  DEFAULT (getdate()),
	[isCalculating] [tinyint] NULL CONSTRAINT [DF_CS_SettlementCommand_isCalculating]  DEFAULT ((0)),
	[executedate] [datetime] NULL,
	[duration] [int] NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_CS_SettlementCommand_Id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)) ON [DATA] 

GO

CREATE NONCLUSTERED INDEX [IX_CS_SettlementCommand_CreatedDate] ON [dbo].[CS_SettlementCommand]
(
	[createddate] ASC
) ON [DATA]


