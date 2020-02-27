/*
	Created: 20200227@Max
	Task: Confirm Auto Unmark Group By User [Redmine: #129219]
	DB: DBTRANS/bodb02
		
*/
USE bodb02
GO
ALTER TABLE TicketVoiding_AutoUnmarkSetting ADD MarkedBy INT
GO
