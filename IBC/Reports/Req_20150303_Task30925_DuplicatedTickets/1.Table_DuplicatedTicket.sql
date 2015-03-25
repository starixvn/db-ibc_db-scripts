USE [bodb_report]
GO

/****** Object:  Table [dbo].[DuplicatedTicket]    Script Date: 3/4/2015 4:46:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DuplicatedTicket](
	[TransId] [bigint] NOT NULL,
	[TransDate] [datetime] NULL,
	[WinlostDate] [datetime] NULL,
 CONSTRAINT [PK_DuplicatedTicket] PRIMARY KEY CLUSTERED 
(
	[TransId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

 
/****** Object:  Index [IX_TransDate]    Script Date: 3/4/2015 4:46:26 PM ******/
CREATE NONCLUSTERED INDEX [IX_TransDate] ON [dbo].[DuplicatedTicket]
(
	[TransDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO


