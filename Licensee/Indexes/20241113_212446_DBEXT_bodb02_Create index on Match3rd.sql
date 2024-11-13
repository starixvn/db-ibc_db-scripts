/*<info serverAlias="DBEXT-bodb02"></info>*/
/*
	Created: 20241113@Kelvin
	DB: DBEXT-bodb02
	Task: LAP - Integrate Betby (VS6) [RedmineID: #212446]
*/

USE bodb02
GO

CREATE NONCLUSTERED INDEX [IX_EventDate] ON [dbo].[Match3rd]
(
	[EventDate] ASC
)
INCLUDE([SportType],[League3rdId],[EventStatus]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Event3rd_table]
