/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Creator:	20220221@Percy
	Task:		MPA - Change data type of TpBetRecord - [Redmine: #167823]
	Database:	DBN88.bodb_N88

*/

ALTER TABLE dbo.TpBetRecord
	ALTER COLUMN Stake DECIMAL(20,4) NULL

ALTER TABLE dbo.TpBetRecord
	ALTER COLUMN WinlostAmount DECIMAL(20,4) NULL

ALTER TABLE dbo.TpBetRecord
	ALTER COLUMN ValidBet DECIMAL(20,4) NULL