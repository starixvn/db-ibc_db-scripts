/*
	Created: 20190704@Kathy
	DB: DBTXN/bodb02
	Task: Add primary column

*/
--[dbo].[TicketVoiding_MessageTemplateSetting]
ALTER TABLE dbo.TicketVoiding_MessageTemplateSetting ADD Id INT IDENTITY(1,1)
GO
ALTER TABLE dbo.TicketVoiding_MessageTemplateSetting ADD CONSTRAINT PK_TicketVoiding_MessageTemplateSetting_Id PRIMARY KEY NONCLUSTERED (Id) ON [DATA]
GO

--[dbo].[TicketVoiding_OperatorInfo]
ALTER TABLE dbo.TicketVoiding_OperatorInfo ADD Id INT IDENTITY(1,1)
GO
ALTER TABLE dbo.TicketVoiding_OperatorInfo ADD CONSTRAINT PK_TicketVoiding_OperatorInfo_Id PRIMARY KEY NONCLUSTERED (Id) ON [DATA]
GO

--[dbo].[TicketVoiding_ReasonTemplate]
ALTER TABLE dbo.TicketVoiding_ReasonTemplate ADD Id INT IDENTITY(1,1)
GO
ALTER TABLE dbo.TicketVoiding_ReasonTemplate ADD CONSTRAINT PK_TicketVoiding_ReasonTemplate_Id PRIMARY KEY NONCLUSTERED (Id) ON [DATA]
GO

--[dbo].[TicketVoiding_RequestDetail] --> id
ALTER TABLE dbo.TicketVoiding_RequestDetail ADD CONSTRAINT PK_TicketVoiding_RequestDetail_Id PRIMARY KEY NONCLUSTERED (Id) ON [DATA]
GO

--[dbo].[TicketVoiding_VoidedTransaction]
ALTER TABLE dbo.TicketVoiding_VoidedTransaction ADD Id INT IDENTITY(1,1)
GO
ALTER TABLE dbo.TicketVoiding_VoidedTransaction ADD CONSTRAINT PK_TicketVoiding_VoidedTransaction_Id PRIMARY KEY NONCLUSTERED (Id) ON [DATA]
GO

--[dbo].[SettlementSpecialBettypeProfile]
ALTER TABLE dbo.SettlementSpecialBettypeProfile ADD Id INT IDENTITY(1,1)
GO
ALTER TABLE dbo.SettlementSpecialBettypeProfile ADD CONSTRAINT PK_SettlementSpecialBettypeProfile_Id PRIMARY KEY NONCLUSTERED (Id) ON [DATA]
GO
