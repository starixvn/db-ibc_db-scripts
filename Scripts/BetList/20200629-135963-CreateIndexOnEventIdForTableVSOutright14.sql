/*<info serverAlias="DBAGE-bodb02"></info>*/
/*
	Created: 20200629@Kos
	DB: DBAGE.bodb02
	Task: Create index IX_EventId on table VSOutright14 [Redmine: #135963]
*/

CREATE NONCLUSTERED INDEX [IX_EventId] ON [dbo].[VSOutright14]
(
	[EventId] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [Event_index]
GO