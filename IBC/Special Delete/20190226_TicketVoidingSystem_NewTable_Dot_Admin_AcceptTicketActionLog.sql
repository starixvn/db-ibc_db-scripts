USE [bodb02]
GO
/*
	Created: 20190122@Kathy
	DB: DB052/DB053.bodb02
	Task: new table for ticket voiding system [Redmine:#90155]
*/

CREATE TABLE [dbo].[Dot_Admin_AcceptTicketActionLog](
	[matchid] [int] NOT NULL,
	[livelogid] [bigint] NOT NULL,
	[tickettype] [tinyint] NOT NULL,
	[accepttime] [datetime] NOT NULL,
	[maxtransid] [bigint] NOT NULL,
	[mintransid] [bigint] NOT NULL,
	[ticketcount] [int] NOT NULL,
 CONSTRAINT [PK_Dot_Admin_AcceptTicketActionLog] PRIMARY KEY CLUSTERED 
(
	[matchid] ASC,
	[livelogid] ASC,
	[tickettype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]
