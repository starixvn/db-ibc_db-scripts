/*<info serverAlias="DBPTCS-bodb_PlaytechCS"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBPTCS-bodb_PlaytechCS
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

USE bodb_PlaytechCS
GO

DROP INDEX [IX_Recommend] ON [dbo].[bettrans_AGCasino]
GO

ALTER TABLE [bettrans_AGCasino] ALTER COLUMN [Currency] SMALLINT
GO

CREATE NONCLUSTERED INDEX [IX_Recommend] ON [dbo].[bettrans_AGCasino]
(
	[recommend] ASC
)
INCLUDE([Winlostdate],[StatusID],[Currency]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PlaytechCS_Data]
