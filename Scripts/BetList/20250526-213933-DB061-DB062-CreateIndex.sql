/*<info serverAlias="DBARC-bodb_Archive" isFunction="0" isNested=""></info>*/
/*
	Created: 20250526@Kos
	DB: DBARC.bodb_Archive
	Task: Create index IX_recommend [Redmine: #213933]
*/

USE [bodb_Archive]
GO

CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[bettrans_bk]
(
	[recommend] ASC,
	[winlostdate] ASC
)
INCLUDE([bettype]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
GO
