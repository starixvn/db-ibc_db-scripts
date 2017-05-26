/*
	Created: 20170526@Kathy
	DB: DBPRO/bodb02
	Task: Turn ON fastmarket for all league [Redmine:#77267]
*/

UPDATE dbo.League WITH (ROWLOCK, UPDLOCK)
 SET AutoSetting = ISNULL(AutoSetting,0) | 4
WHERE sporttype = 1

GO
