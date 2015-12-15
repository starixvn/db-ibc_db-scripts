--DBPRO
USE [bodb02]
CREATE TABLE [dbo].[EventInfo3rd14](
 [ID] [int] NOT NULL,
 [ArenaID] [int] NOT NULL,
 [FightNo] [int] NOT NULL,
 [EventDate] [smalldatetime] NOT NULL,
 [HomeOwner] [nvarchar](256) NULL,
 [AwayOwner] [nvarchar](256) NULL,
 CONSTRAINT [PK_EventInfo3rd14] PRIMARY KEY NONCLUSTERED 
(
 [ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Event14_index]
) ON [Event14_table]

GO


USE [bodb02]
--/ Object:  Index [IX_ArenaFightNo]    Script Date: 12/15/2015 03:06:30 /
CREATE UNIQUE CLUSTERED INDEX [IX_ArenaFightNo] ON [dbo].[EventInfo3rd14] 
(
 [ArenaID] ASC,
 [FightNo] ASC,
 [EventDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Event14_table]
GO
