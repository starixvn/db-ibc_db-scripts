/*<info serverAlias="DBPRO-bodb02" isFunction="0" isNested=""></info>*/
/*
    Created: 20200618@Sol
    Task: 
        Add table VSRaceInfo14 into replication [Redmine: #135963]
        Run on DBPRO.bodb02 and replicated server as well
    DB: DBPRO-bodb02
*/
CREATE TABLE [dbo].[VSRaceInfo14](
	[EventID] [int] NOT NULL,
	[EventTime] [datetime] NOT NULL,
	[LeagueID] [int] NOT NULL,
	[PayOut] [tinyint] NULL,
	[EachWay] [tinyint] NULL,
	[CourseName] [varchar](100) NULL,
	[TrackType] [varchar](10) NULL,
	[Distance] [varchar](10) NULL,
	[Racers] [tinyint] NULL,
	[ForeCastPayout] [money] NULL,
	[TriCastPayout] [money] NULL,
	[CreateDate] [smalldatetime] NOT NULL,
	[Calculate] [bit] NOT NULL,
	[SportType] [tinyint] NOT NULL,
	[ChangeTime] [datetime] NULL,
	[EventStatus] [nvarchar](50) NULL,
	[BetStatus] [varchar](10) NULL,
 CONSTRAINT [PK_VSRaceInfo14] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
) ON [Event_table]
) ON [Event_table]
GO