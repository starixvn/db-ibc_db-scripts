/*
	Created: 20200108@Sol
	Task : Add new column IsHold to SettlementPerformanceLog table [Redmine:#104631]
	DB: DBTXN/bodb02
	
	Revision:
		- 20200108@Sol: Add new column IsHold - [Redmine: #104631]
*/

USE bodb02;

GO

ALTER TABLE SettlementPerformanceLog ADD IsHold BIT

GO