/*
	Created: 20200312@Max
	Task: Support Quarter X, Y, Z on Auto Unmark Page [Redmine: #130205]
	DB: DBTRANS/bodb02
		
*/
USE bodb02
GO
ALTER TABLE TicketVoiding_AutoUnmarkSetting ADD betid BIGINT
GO
