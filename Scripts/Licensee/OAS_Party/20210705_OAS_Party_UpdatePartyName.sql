/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210705@Percy
	DB: DBCUST-bodb_Licensee
	Task: Remove space in Party Name
	https://nexdev.net/issues/158018
*/
USE bodb_Licensee
GO

UPDATE dbo.OAS_Party WITH (ROWLOCK)
SET PartyName = 'Hecbet'
WHERE PartyName = 'Hecbet '


UPDATE dbo.OAS_Party WITH (ROWLOCK)
SET PartyName = 'AsianBet'
WHERE PartyName = 'AsianBet '