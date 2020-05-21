/*
	Created: 20200521@Max
	Task: [TVS] Apply new policy into Void Abnormal Bet rules [Redmine: #133705]
	DB: DBTRANS/bodb02
		
*/
USE bodb02
GO
ALTER TABLE TicketVoiding_AutoUnmarkSetting ADD betid BIGINT
GO
