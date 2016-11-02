/*
	Created: 20161027@Winnie
	Task: Insert log Action - [Redmine: #63736]
	DB: DBLOG/bodb_CustomerLog
*/

USE bodb_CustomerLog
GO

UPDATE LogAction SET SPName='Acc_CustomerSelCheckSmartPunter' WHERE ActionID=31006