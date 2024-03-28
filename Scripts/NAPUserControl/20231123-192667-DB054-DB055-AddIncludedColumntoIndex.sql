/*<info serverAlias="DBCUST-NAP_UserControl" isFunction="0" isNested=""></info>*/
/*
	Created: 20240328@Kos
	DB: DBCUST.NAP_UserControl
	Task: Add new index to table NAP_OnUser [Redmine: #203053]
*/

USE NAP_UserControl

CREATE NONCLUSTERED INDEX [IX_user_site] ON [dbo].[NAP_OnUser]
(
	[UserId] ASC,
	[SiteId] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
