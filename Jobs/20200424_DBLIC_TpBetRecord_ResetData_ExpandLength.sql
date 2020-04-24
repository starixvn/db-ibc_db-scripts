USE bodb_3rdProduct
GO

/*
	Created: 20200424@Percy
	DB: DBLIC.bodb_3rdProduct
	Task:
		- Expand TransId's length
		- Reset data
*/

TRUNCATE TABLE dbo.TpBetRecord
GO

ALTER TABLE dbo.TpBetRecord
	DROP CONSTRAINT [PK_TpBetRecord]

ALTER TABLE dbo.TpBetRecord
	ALTER COLUMN TransId VARCHAR(50) NOT NULL

ALTER TABLE dbo.TpBetRecord
	ADD CONSTRAINT [PK_TpBetRecord] PRIMARY KEY CLUSTERED (TpId, TransId, GameType)
GO

UPDATE bodb_PlaytechCS.dbo.Product3rd_ImportQueue WITH (ROWLOCK)
SET FinishedTime = NULL
WHERE ProductId = 0