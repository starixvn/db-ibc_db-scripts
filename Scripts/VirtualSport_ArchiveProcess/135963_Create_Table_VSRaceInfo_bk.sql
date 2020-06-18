/*<info serverAlias="DBARC-bodb_archive" isFunction="0" isNested=""></info>*/
/*
    Created: 20200618@Sol
    Task: 
        Add table VSRaceInfo_bk into replication [Redmine: #135963]
        Run on DBARC.bodb_archive and replicated server as well
    DB: DBARC-bodb_archive
*/
CREATE TABLE [dbo].[VSRaceInfo_bk](
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
 CONSTRAINT [PK_VSRaceInfo_bk] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
) WITH (DATA_COMPRESSION = PAGE) ON [EVENT]
) ON [EVENT]
GO