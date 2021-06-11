/*<info serverAlias="DBEXT-bodb02" ></info>*/

/*
	Created: 20210122@Malcolm
	DB: DBEXT-bodb02
	Task:rename column [RedmineId : #147470]
*/
TRUNCATE TABLE TicketAmendment_Event
TRUNCATE TABLE TicketAmendment_Detail

ALTER TABLE TicketAmendment_Event
DROP CONSTRAINT DF__TicketAme__Creat__0D7E5A9E;

ALTER TABLE TicketAmendment_Event
DROP COLUMN CreatedDate;

ALTER TABLE TicketAmendment_Event
ADD SubmitDate DATETIME;

ALTER TABLE TicketAmendment_Detail
ADD Seq INT;

CREATE NONCLUSTERED INDEX IX_TicketEventId_Seq ON TicketAmendment_Detail(TicketEventId ASC,Seq ASC);

CREATE NONCLUSTERED INDEX IX_TicketEventId_SubmitDate ON TicketAmendment_Event(TicketEventId ASC,SubmitDate ASC);