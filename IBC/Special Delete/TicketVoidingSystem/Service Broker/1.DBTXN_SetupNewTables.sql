/*
	Created:20190128@Kathy
	DB: DBTXN/master, DBTXN/bodb_CustomerLog
	Task: Ticket Voiding System - Setup service broker on DBTXN [Redmine:#90155]
*/

-- Add new file/filegroup for service broker
USE [master]
GO
ALTER DATABASE bodb_CustomerLog ADD FILEGROUP [ServiceBroker]
GO
ALTER DATABASE bodb_CustomerLog ADD FILE ( NAME = N'serviceBroker_01'
--, FILENAME = N'D:\IBC_DB\bodb_CustomerLog\serviceBroker\serviceBroker_01.ndf' -- Local Dev
--, FILENAME = N'D:\DB233\IBC_DB\ServiceBroker\serviceBroker_01.ndf' -- Local Test
--, FILENAME = N'G:\IBC_DB\bodb_CustomerLog\serviceBroker_01.ndf' -- Production
, SIZE = 2048KB , FILEGROWTH = 32768KB ) TO FILEGROUP [ServiceBroker]
GO
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

USE bodb_CustomerLog
GO
CREATE SCHEMA [sb] AUTHORIZATION [dbo]
GO

-- TABLE [sb].[ConfigurationReference]
CREATE TABLE [sb].[ConfigurationReference](
	[FunctionName] varchar(50),
	[MaxReceiveMsg] [int] ,
	[MaxReceiveTimeOut] [int] 
	
) ON [ServiceBroker]
GO

CREATE CLUSTERED INDEX [CIX_ConfigurationReference] ON [sb].[ConfigurationReference] 
(
	[FunctionName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [ServiceBroker]
GO

GO
ALTER TABLE [sb].[ConfigurationReference] ADD  CONSTRAINT [DF_ConfigurationReference_MaxReceiveMsg]  DEFAULT (1) FOR [MaxReceiveMsg]
GO
ALTER TABLE [sb].[ConfigurationReference] ADD  CONSTRAINT [DF_ConfigurationReference_MaxReceiveTimeOut]  DEFAULT (1) FOR [MaxReceiveTimeOut]
GO
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- TABLE [sb].[ConfigurationReferenceDetail]
CREATE TABLE [sb].[ConfigurationReferenceDetail](
	[FunctionName] varchar(50),
	[ContractName] varchar(200),
	[MessageType] varchar(200),
	[MinConversation] [int],
	[MaxConversation] [int]
	
) ON [ServiceBroker]
GO

CREATE CLUSTERED INDEX [CIX_ConfigurationReferenceDetail] ON [sb].[ConfigurationReferenceDetail] 
(
	FunctionName ,ContractName
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [ServiceBroker]
GO

ALTER TABLE [sb].[ConfigurationReferenceDetail] ADD  CONSTRAINT [DF_ConfigurationReferenceDetail_MinConversation]  DEFAULT (5) FOR [MinConversation]
GO
ALTER TABLE [sb].[ConfigurationReferenceDetail] ADD  CONSTRAINT [DF_ConfigurationReferenceDetail_MaxConversation]  DEFAULT (20) FOR [MaxConversation]
GO
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-- TABLE [sb].[ConversationManagement]
CREATE TABLE [Sb].[ConversationManagement](
	[FunctionName] varchar(50), 
	[ContractName] varchar(100),
	[ConversationHandle] Uniqueidentifier null,
	[ConversationNo] int null ,
	[CreatedDate] datetime null,
	[IsValid] BIT null
) ON [ServiceBroker]

CREATE CLUSTERED INDEX inx_ConversationManagement ON sb.ConversationManagement(FunctionName,ContractName, ConversationNo) ON [ServiceBroker]
GO
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


-- TABLE [sb].[ConversationCount]
CREATE TABLE sb.ConversationCount
(
	FunctionName VARCHAR(100),
	ContractName VARCHAR(200),
	Cnt INT
)  ON [ServiceBroker]

CREATE CLUSTERED INDEX inx_ConversationCount ON sb.ConversationCount(FunctionName,ContractName)  ON [ServiceBroker]
GO
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




