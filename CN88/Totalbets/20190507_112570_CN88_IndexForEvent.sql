USE [bodb02]
GO
/*
Create: 20190506@Sophia
Task: CN88 - Started [redmine: 109521]
DB: DB052/DB053/DB042 - bodb02
*
/

-------------New index for Match ---------------

/****** Object:  Index [IX_GlobalShowTime]    Script Date: 5/3/2019 5:24:25 AM ******/
CREATE NONCLUSTERED INDEX [IX_GlobalShowTime] ON [dbo].[match]
(
	[GlobalShowTime] ASC
)
INCLUDE ( 	[matchid],
	[EventDate],
	[leagueid],
	[homeid],
	[awayid],
	[eventstatus],
	[livehomescore],
	[liveawayscore],
	[hthomescore],
	[htawayscore],
	[sporttype],
	[IsNeutral],
	[ShowTimeDT]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DAT3]
GO



-------------CS_SportBettypeMatrix----------
 

/****** Object:  Index [PK_CS_SportBettypeMatrix]    Script Date: 5/6/2019 4:10:08 AM ******/
ALTER TABLE [dbo].[CS_SportBettypeMatrix] DROP CONSTRAINT [PK_CS_SportBettypeMatrix]
GO

/****** Object:  Index [PK_CS_SportBettypeMatrix]    Script Date: 5/6/2019 4:10:08 AM ******/
ALTER TABLE [dbo].[CS_SportBettypeMatrix] ADD  CONSTRAINT [PK_CS_SportBettypeMatrix] PRIMARY KEY NONCLUSTERED 
(
	[SportType] ASC,
	[Bettype] ASC,
	[IsLive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO


 
 /****** Object:  Index [CIX_ProductID]   Script Date: 5/6/2019 4:10:58 AM ******/
CREATE CLUSTERED INDEX [CIX_ProductID] ON [dbo].[CS_SportBettypeMatrix]
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

