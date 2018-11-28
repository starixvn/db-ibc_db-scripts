USE [bodb02]
GO

/*
	Created: 20181120@Percy
	DB: DB052
	Task: Migrate DB053 to DB052
	Remark: Create TVP_SportBettypeMatrix
*/

CREATE TYPE [dbo].[TVP_SportBettypeMatrix] AS TABLE(
	[ProductID] [tinyint] NULL,
	[Bettype] [smallint] NULL,
	[EventType] [tinyint] NULL,
	[SubProduct] [varchar](500) NULL
)
GO