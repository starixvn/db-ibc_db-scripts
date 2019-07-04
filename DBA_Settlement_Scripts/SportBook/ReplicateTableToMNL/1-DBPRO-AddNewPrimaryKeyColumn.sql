/*
	Created: 20190704@Kathy
	DB: DBPRO/bodb02
	Task: Add primary column

*/
--DBPRO [dbo].[SettlementSetting]
ALTER TABLE dbo.SettlementSetting ADD Id INT IDENTITY(1,1)
GO
ALTER TABLE dbo.SettlementSetting ADD CONSTRAINT PK_SettlementSetting_Id PRIMARY KEY NONCLUSTERED (Id) ON [DATA]
GO