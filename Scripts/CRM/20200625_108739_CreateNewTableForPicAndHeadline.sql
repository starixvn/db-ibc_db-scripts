/*<info serverAlias="DBCRM-bodb_CRM"></info>*/

/*
	Created by: Malcolm
	Date: 20200625
	Task: Create new table to manage PIC  [#RedmindId: 108739]
	DB: DBCRM-bodb_CRM
*/

USE bodb_CRM
GO


CREATE TABLE crmPIC (
	PicID		INT	IDENTITY (1,1) NOT NULL,
	Username	NVARCHAR(200) NOT NULL,
	Role	    INT,
	Language    VARCHAR(200),
	Country     INT,
	Remark		NVARCHAR(1000),
	IsActive	BIT,
	CONSTRAINT PK_CRM_PIC PRIMARY KEY CLUSTERED (PicID) ON [DATA]
) ON [DATA]

CREATE TABLE crmPICCommunication(
	PicID INT NOT NULL,
	CommunicationID INT NOT NULL,
	CommunicationValue NVARCHAR(200)
	CONSTRAINT PK_CRM_PICCommunication PRIMARY KEY CLUSTERED (PicID, CommunicationID) ON [DATA]
) ON [DATA]



CREATE TABLE crmPicManagement(
	PicID  INT NOT NULL,
	CustID INT NOT NULL,
	CONSTRAINT PK_CRM_PicManagement PRIMARY KEY CLUSTERED (PicID, CustID) ON [DATA]
) ON [DATA]

CREATE TABLE crmPICHeadline(
	PicID INT NOT NULL,
	HeadlineID  INT NOT NULL
	CONSTRAINT PK_CRM_PICHeadline PRIMARY KEY CLUSTERED (PicID, HeadlineID) ON [DATA]
) ON [DATA]


CREATE TABLE dbo.crmUserLog_RunSP(
	LogID		BIGINT IDENTITY (1,1) NOT NULL,
	LogDate		DATETIME NOT NULL,
	UserID		INT NOT NULL,
	ActionID	INT NOT NULL,
	IP			VARCHAR(20),
	NewValues	XML,
	OldValues	XML,
	CONSTRAINT PK_crmUserLog_RunSP PRIMARY KEY NONCLUSTERED(LogID) ON [userlog]
) ON [userlog]

CREATE CLUSTERED INDEX CIX_LogDare_ActionID ON dbo.crmUserLog_RunSP(LogDate, ActionID) ON [userlog]

