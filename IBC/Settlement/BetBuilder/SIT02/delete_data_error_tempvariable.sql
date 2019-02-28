moi/*
	Created: Vicky
	Task: delete match error TempVariableNumber
	DB: DBTXN/bodb02
	Date: 20190226
	
*/
USE [bodb02]
GO



DELETE TempVariableNumber where keyid= 5 and KeyValue in (28802764.00,28803461.00,28904982.00,28930382.00)

