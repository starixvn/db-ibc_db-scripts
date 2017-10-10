/*
	Created: 20170915@Helen
	Task: SMA Turnover Control - Enhancement requests from phase 2 [RedmineID:75557]
	DB: DBCUST/CUSTDB
*/

USE CustDB
GO
CREATE TABLE dbo.EmailNotification
(
	ID INT IDENTITY (1,1)
	, NotificationInfo VARCHAR(MAX)
	, CreatedDate DATETIME
	, ActionID INT
	, IsNotifiedbyTOControl TINYINT
	, IsNotifiedbyLossMonitoring TINYINT
	, CONSTRAINT [PK_EmailNotification] PRIMARY KEY ([ID] ASC) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[EmailNotification] ADD CONSTRAINT [DF_EmailNotification_IsNotifiedbyTOControl] DEFAULT ((0)) FOR [IsNotifiedbyTOControl]

GO

ALTER TABLE [dbo].[EmailNotification] ADD CONSTRAINT [DF_EmailNotification_IsNotifiedbyLossMonitoring] DEFAULT ((0)) FOR [IsNotifiedbyLossMonitoring]

GO

CREATE NONCLUSTERED INDEX inx_CreatedDate_ActionID ON dbo.EmailNotification 
(
	CreatedDate
	, ActionID
)
INCLUDE (NotificationInfo,IsNotifiedbyTOControl,IsNotifiedbyLossMonitoring)

GO

