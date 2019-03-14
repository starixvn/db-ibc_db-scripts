/*
	Created: 20190122@Kathy
	DB: DBLOG.bodb_CustomerLog
	Task: new logid for ticket voiding system [Redmine:#90155]
*/

USE bodb_CustomerLog
GO

INSERT INTO LogAction (ActionID, SPName, ActionNameEN) VALUES (90000, 'TicketVoiding_Request_Insert', 'Insert request')
, (90001, 'TicketVoiding_RequestDetail_Insert', 'Insert request detail')
, (90002, 'TicketVoiding_Request_Update', 'Update request')
, (90003, 'TicketVoiding_RequestDetail_Update', 'Update request detail')
, (90100, 'TicketVoiding_SingleType_Update', 'Void single ticket')
, (90101, 'TicketVoiding_ParlayType_Update', 'Void parlay ticket')
GO
