/*
	Created:20180411@Helen
	Task: https://nexdev.net/issues/90154
	DB:DBPRO/bodb02 
	
*/
USE bodb02
GO
CREATE NONCLUSTERED INDEX [IX_Matchid_ResultID] ON [dbo].[ResultDetail3rd] 
(
	[MatchID] ASC,
	[ResourceId] ASC
)
GO