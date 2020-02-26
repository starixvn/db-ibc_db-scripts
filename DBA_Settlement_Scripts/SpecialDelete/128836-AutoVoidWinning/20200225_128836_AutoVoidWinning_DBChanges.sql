/*
	Created: 20200225@Helen
	Task: https://nexdev.net/issues/128836
	DB: DBTRANS/bodb02
	
	MarkType:
		+ 0: mark by mark/unmark
		+ 1: mark by add abnormal request (auto)
		+ 2: mark by auto voiding winning system
	
	RequestType:
		+ 1: Create by add new request
		+ 2: create by auto
		
*/
USE bodb02
GO
ALTER TABLE MarkedTransaction ADD MarkType TINYINT
GO
ALTER TABLE TicketVoiding_RequestDetail ADD RequestType TINYINT
GO
ALTER TABLE TicketVoiding_RequestDetail ADD  CONSTRAINT [DF_TicketVoiding_RequestDetail_RequestType]  DEFAULT (0) FOR [RequestType]
GO
ALTER TABLE TicketVoiding_AutoVoidRequest_Queue ADD sporttype SMALLINT
GO