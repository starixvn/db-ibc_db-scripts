/*
	Created by: Kathy
    Date:20190322
    Task: Settlement with Tickets Exclusion [Redmine:#106823]
    DB: DBTrans_Bet
   
*/
USE [bodb02]
GO
CREATE TABLE [dbo].[MarkedTransaction](
	[TransId] [bigint] NOT NULL,
	[MatchId] [int] NOT NULL,
	[CustId] [int] NOT NULL,
	[bettype] [smallint] NOT NULL,
	[UserId] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_MarkedTransaction_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_MarkedTransaction_TransId] PRIMARY KEY CLUSTERED 
(
	[TransId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO


