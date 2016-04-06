USE bodb_Staging
GO

ALTER TABLE dbo.mcCustLiveCasinoDaily ADD Actual_Stake MONEY NULL
GO

ALTER TABLE dbo.mcCustLiveCasinoDaily ADD Actual_StakeRefund MONEY NULL
GO

ALTER TABLE dbo.mcCustCasinoHourly ADD Actual_Stake MONEY NULL
GO

ALTER TABLE dbo.mcCustCasinoHourly ADD Actual_StakeRefund MONEY NULL
GO


USE bodb_Account
GO

ALTER TABLE dbo.mcCustLiveCasinoDaily ADD Actual_Stake MONEY NULL
GO

ALTER TABLE dbo.mcCustLiveCasinoDaily ADD Actual_StakeRefund MONEY NULL
GO


ALTER TABLE dbo.mcCustCasinoHourly ADD Actual_Stake MONEY NULL
GO

ALTER TABLE dbo.mcCustCasinoHourly ADD Actual_StakeRefund MONEY NULL
GO
