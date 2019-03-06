/*
	Created: Vicky
	Task: add column KeyValue2 for table TempVariableNumber
	DB: DBTXN/bodb02
	Date: 20190115
	
*/
USE [bodb02]
GO


SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

ALTER TABLE dbo.TempVariableNumber ADD
	KeyValue2 VARCHAR(20) NOT NULL CONSTRAINT DF_TempVariableNumber_KeyValue2 DEFAULT '0'
GO
ALTER TABLE dbo.TempVariableNumber
	DROP CONSTRAINT PK_TempVariableNumber
GO
ALTER TABLE dbo.TempVariableNumber ADD CONSTRAINT
	PK_TempVariableNumber PRIMARY KEY CLUSTERED 
	(
	KeyID,
	KeyValue,
	KeyValue2
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
