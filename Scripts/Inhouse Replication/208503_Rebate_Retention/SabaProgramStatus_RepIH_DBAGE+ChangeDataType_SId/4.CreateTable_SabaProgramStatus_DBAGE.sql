/*<info serverAlias="IRS_DBAGE-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: IRS_DBAGE-bodb02
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/
CREATE TABLE [dbo].[SabaProgramStatus](
	[SId] [int] NOT NULL IDENTITY(1,1),
	[ProgramId] [smallint] NOT NULL,
	[SiteDBGroupId] [smallint] NOT NULL,
	[StatusId] [tinyint] NULL,
	[IsNotified] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
		
CONSTRAINT [PK_SabaProgramStatus_SId_SiteDBGroupId] PRIMARY KEY CLUSTERED(
	SId, SiteDBGroupId
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Transfer_Index]
) 
ON [Transfer_Table]
GO

ALTER TABLE [dbo].[SabaProgramStatus] ADD CONSTRAINT [DF_SabaProgramStatus_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[SabaProgramStatus] ADD CONSTRAINT [DF_SabaProgramStatus_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

CREATE NONCLUSTERED INDEX [IX_SabaProgramStatus_IsNotified_ProgramId] ON [dbo].[SabaProgramStatus]
(
	[IsNotified],[ProgramId]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Transfer_Index]
GO