/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250107@Lewis	
	Task: In-House
	DB: DBCUST-CustDB
	
	Revisions:
		- 20250107@Lewis: Created [RedmineID: #215883]

	Example:			
*/

--------ExchangeDaily_Crypto_Del_InHouse--------
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'ExchangeDaily_Crypto_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[ExchangeDaily_Crypto_Del_InHouse]
	(
		[ExchangeDate] [SMALLDATETIME] NOT NULL
		,[ExchangeId] [INT] NOT NULL
		,[RepUpdateTime] [DATETIME2](7) NULL
		) ON [DATA]

	ALTER TABLE [dbo].[ExchangeDaily_Crypto_Del_InHouse] ADD CONSTRAINT [DF_ExchangeDaily_Crypto_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME()) FOR [RepUpdateTime]

	CREATE CLUSTERED INDEX [CIX_ExchangeDaily_Crypto_Del_InHouse_RepUpdateTime] ON [dbo].[ExchangeDaily_Crypto_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table ExchangeDaily_Crypto_Del_InHouse exists!!!'
END
GO


--------ExchangeDailyOanda_Del_InHouse--------
IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'ExchangeDailyOanda_Del_InHouse')
BEGIN
	CREATE TABLE [dbo].[ExchangeDailyOanda_Del_InHouse]
	(
		[ExchangeDate] [SMALLDATETIME] NOT NULL
		,[ExchangeId] [INT] NOT NULL
		,[RepUpdateTime] [DATETIME2](7) NULL
		) ON [DATA]

	ALTER TABLE [dbo].[ExchangeDailyOanda_Del_InHouse] ADD CONSTRAINT [DF_ExchangeDailyOanda_Del_InHouse_RepUpdateTime] DEFAULT (SYSDATETIME()) FOR [RepUpdateTime]

	CREATE CLUSTERED INDEX [CIX_ExchangeDailyOanda_Del_InHouse_RepUpdateTime] ON [dbo].[ExchangeDailyOanda_Del_InHouse]([RepUpdateTime] ASC) ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table ExchangeDailyOanda_Del_InHouse exists!!!'
END
GO




