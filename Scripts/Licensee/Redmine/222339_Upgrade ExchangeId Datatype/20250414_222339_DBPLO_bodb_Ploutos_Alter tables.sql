/*<info serverAlias="DBPLO-bodb_Ploutos"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBPLO-bodb_Ploutos
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

USE bodb_Ploutos
GO

ALTER TABLE BetTicket_Staging ALTER COLUMN CurrencyID SMALLINT