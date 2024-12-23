/*<info serverAlias="DBRepl-ReplDB"></info>*/
/*
	Created: 20241223@Lewis
	DB: DBRepl-ReplDB
	Task: XML OddsFeed - RepInhouse LeagueSetting - Distributor [RedmineID: #215667]
*/

--DBRepl
USE ReplDB
GO

CREATE TABLE [dbo].[LeagueSetting](
	[Leagueid] [int] NOT NULL,
	[Series] [tinyint] NULL,
	[LeagueType] [tinyint] NULL,
	[ParentLeagueID] [int] NULL,
	[ChildLeagueType] [int] NULL,
	[stamp] [datetime] NOT NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_LeagueSetting] PRIMARY KEY CLUSTERED 
(
	[Leagueid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO

ALTER TABLE [dbo].[LeagueSetting] ADD  CONSTRAINT [DF_LeagueSetting_stamp]  DEFAULT (getdate()) FOR [stamp]
GO

CREATE NONCLUSTERED INDEX IX_LeagueSetting_stamp ON dbo.LeagueSetting
(
	stamp ASC
) ON [DATA]
GO 