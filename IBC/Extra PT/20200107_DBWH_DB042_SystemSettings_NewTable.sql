USE bodb02
GO

/*
	Created: 20200107@Percy
	Task: Create local system setting table
	DB: DB042-bodb02, DBWH-bodb02
*/

CREATE TABLE dbo.SystemSettings
(
	VID		INT	IDENTITY (1, 1) NOT NULL
	,VName	VARCHAR(50)	NULL
	,VValue	VARCHAR(200) NULL
	,CONSTRAINT [PK_SystemSettings] PRIMARY KEY CLUSTERED
	(
		VID ASC 
	) ON [DATA]
) ON [DATA]
GO