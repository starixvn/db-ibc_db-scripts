SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Single_Calculate_Queue_3rd](
	[keyid] [int] IDENTITY(1,1) NOT NULL,
	[matchid] [int] NOT NULL,
	[matchcode] [nvarchar](50) NULL,
	[IsCalculating] [int] NULL,
	[LeagueID] [int] NULL,
	[SportType] [int] NULL,
	[AdminId] [int] NULL,
	[IP] [varchar](15) NULL,
	[Starttime] [datetime] NULL,
	[Action] [varchar](20) NULL,
	[sqlCommand] [nvarchar](max) NULL,
	[TryCount] [int] NULL,
	[execTime] [datetime] NULL,
	[duration] [int] NULL
) ON [Event_table]

GO



ALTER TABLE [dbo].[Single_Calculate_Queue_3rd] ADD  CONSTRAINT [DF_Single_Calculate_Queue_3rd_Starttime]  DEFAULT (getdate()) FOR [Starttime]
GO

ALTER TABLE [dbo].[Single_Calculate_Queue_3rd] ADD  CONSTRAINT [DF_Single_Calculate_Queue_3rd_TryCount]  DEFAULT ((0)) FOR [TryCount]
GO

SET ANSI_PADDING OFF
GO
