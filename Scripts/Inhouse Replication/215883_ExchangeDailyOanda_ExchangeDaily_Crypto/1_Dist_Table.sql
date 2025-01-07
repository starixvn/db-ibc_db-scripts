/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250107@Lewis
	Task: In-House
	DB: IRS_DBTP-bodb02,DBCustRepl-ReplCustDB
	
	Revisions:
		- 20250107@Lewis: Created [RedmineID: #215883]

	Example:			
*/

--------ExchangeDaily_Crypto--------

IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'ExchangeDaily_Crypto')
BEGIN
	CREATE TABLE [dbo].[ExchangeDaily_Crypto]
	(
		[ExchangeDate] [SMALLDATETIME] NOT NULL
		,[ExchangeId] [INT] NOT NULL
		,[USDT] [FLOAT] NULL
		,[RepUpdateTime] [DATETIME2](7) NULL
		,[isDeleted] [BIT] NULL
		,CONSTRAINT [PK_ExchangeDaily_Crypto] PRIMARY KEY CLUSTERED ([ExchangeDate],[ExchangeId]) ON [DATA]
	) ON [DATA]

	ALTER TABLE [dbo].[ExchangeDaily_Crypto] ADD CONSTRAINT [DF_ExchangeDaily_Crypto_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
	
	ALTER TABLE [dbo].[ExchangeDaily_Crypto] ADD CONSTRAINT [DF_ExchangeDaily_Crypto_RepUpdateTime]  DEFAULT (SYSDATETIME()) FOR [RepUpdateTime]
	
	CREATE NONCLUSTERED INDEX [IX_ExchangeDaily_Crypto_RepUpdateTime] ON [dbo].[ExchangeDaily_Crypto] 
	(
	  [RepUpdateTime] ASC
	)ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table ExchangeDaily_Crypto exists!!!'
END
GO


--------ExchangeDailyOanda--------

IF NOT EXISTS (SELECT * FROM sys.OBJECTS WHERE NAME = 'ExchangeDailyOanda')
BEGIN
	CREATE TABLE [dbo].[ExchangeDailyOanda]
	(
		[ExchangeDate] [SMALLDATETIME] NOT NULL
		,[ExchangeId] [INT] NOT NULL
		,[Code] [VARCHAR](12) NULL
		,[MYR] [FLOAT] NULL
		,[USD] [FLOAT] NULL
		,[EUR] [FLOAT] NULL
		,[CNY] [FLOAT] NULL
		,[IDR] [FLOAT] NULL
		,[AUD] [FLOAT] NULL
		,[CHF] [FLOAT] NULL
		,[GBP] [FLOAT] NULL
		,[SGD] [FLOAT] NULL
		,[THB] [FLOAT] NULL
		,[VND] [FLOAT] NULL
		,[ActualRate] [FLOAT] NULL
		,[KRW] [FLOAT] NULL
		,[JPY] [FLOAT] NULL
		,[HKD] [FLOAT] NULL
		,[TWD] [FLOAT] NULL
		,[PHP] [FLOAT] NULL
		,[BDT] [FLOAT] NULL
		,[INR] [FLOAT] NULL
		,[TRY] [FLOAT] NULL
		,[NPR] [FLOAT] NULL
		,[MXN] [FLOAT] NULL
		,[NGN] [FLOAT] NULL
		,[BRL] [FLOAT] NULL
		,[RepUpdateTime] [DATETIME2](7) NULL
		,[isDeleted] [BIT] NULL
		,CONSTRAINT [PK_ExchangeDailyOanda] PRIMARY KEY CLUSTERED ([ExchangeDate],[ExchangeId]) ON [DATA]
	) ON [DATA]

	ALTER TABLE [dbo].[ExchangeDailyOanda] ADD CONSTRAINT [DF_ExchangeDailyOanda_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
	
	ALTER TABLE [dbo].[ExchangeDailyOanda] ADD CONSTRAINT [DF_ExchangeDailyOanda_RepUpdateTime]  DEFAULT (SYSDATETIME()) FOR [RepUpdateTime]
	
	CREATE NONCLUSTERED INDEX [IX_ExchangeDailyOanda_RepUpdateTime] ON [dbo].[ExchangeDailyOanda] 
	(
	  [RepUpdateTime] ASC
	)ON [DATA]
END
ELSE 
BEGIN
	SELECT 'Table ExchangeDailyOanda exists!!!'
END
GO


