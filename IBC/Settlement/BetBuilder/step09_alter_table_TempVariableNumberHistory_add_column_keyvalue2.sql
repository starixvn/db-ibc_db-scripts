/*
	Created: Vicky
	Task: add column KeyValue2 for table TempVariableNumberHistory
	DB: DBTXN/bodb02
	Date: 20190115
	
*/
USE [bodb02]
GO


ALTER TABLE dbo.TempVariableNumberHistory ADD
	KeyValue2 VARCHAR(20) NOT NULL CONSTRAINT DF_TempVariableNumberHistory_KeyValue2 DEFAULT '0'
	
GO
