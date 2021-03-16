/*<info serverAlias="DBTXN-bodb02" ></info>*/

/*
	Created: 20210122@Malcolm
	DB: DBTXN-bodb02
	Task: Create new table [RedmineId : #147470]
*/

CREATE TABLE dbo.TicketAmendment_Event
(
	TicketEventId	INT	IDENTITY(1, 1) 
	,ProductId		TINYINT
	,MatchId		INT
	,MatchCode		NVARCHAR(100)
	,EventType		TINYINT
	,EventDate		SMALLDATETIME
	,ActualResult	NVARCHAR(MAX)
	,WrongResult	NVARCHAR(MAX)
	,CreatedDate	DATETIME DEFAULT(GETDATE())
	,Status			NVARCHAR(20)
	,Type			TINYINT
)

CREATE TABLE dbo.TicketAmendment_Detail 
(
	TicketId		INT IDENTITY(1, 1)
	,CustId			INT
	,RefNo			BIGINT
	,TicketEventId	INT
	,RefTable		TINYINT
	,Bettype		SMALLINT
)

ALTER TABLE dbo.TicketAmendment_Event ADD CONSTRAINT PK_TicketAmendment_Event  PRIMARY KEY CLUSTERED (TicketEventId ASC);

ALTER TABLE dbo.TicketAmendment_Detail ADD CONSTRAINT PK_TicketAmendment_Detail  PRIMARY KEY CLUSTERED (TicketId ASC);

CREATE NONCLUSTERED INDEX IX_CustId_RefNo ON TicketAmendment_Detail(CustId ASC,RefNo ASC, TicketEventId ASC);
