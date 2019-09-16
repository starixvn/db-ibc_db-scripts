/*
	Created: 20190916@Helen
	Task:DBTRANS/bodb02 & DB061/bodb_xxx
*/

CREATE TABLE [dbo].[CS_SettlementCommand](
	[id] [bigint] IDENTITY(1,1) NOT NULL
	, [matchid] [int] NULL
	, [sqlcommand] [varchar](max) NULL
	, [createddate] [datetime] NULL
	, [isCalculating]  TINYINT
	, [executedate] DATETIME
	, [duration] INT
	, [tstamp] [timestamp] NOT NULL
) ON [DATA]

GO

