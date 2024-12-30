/*<info serverAlias="DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241106@Lewis	
	Task: In-House
	DB: DBCustRepl-ReplCustDB
	
	Revisions:
		- 20241106@Lewis: Created [RedmineID: #209319]

	Example:			
*/

--Distributor

-- ======================
-- Acc_DWLList
-- ======================
CREATE TABLE [dbo].[Acc_DWLList](
	[custid] [int] NOT NULL,
	[product] [varchar](50) NOT NULL,
	[seq] [tinyint] NOT NULL,
	[ProductId] [tinyint] NULL,
	[IsDeleted] [bit] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
	[IsDisabled] [bit] NULL,
 CONSTRAINT [PK_Acc_DWLList] PRIMARY KEY CLUSTERED 
(
	[custid] ASC,
	[product] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO

ALTER TABLE [dbo].[Acc_DWLList] ADD  CONSTRAINT [DF_Acc_DWLList_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[Acc_DWLList] ADD  CONSTRAINT [DF_Acc_DWLList_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

ALTER TABLE [dbo].[Acc_DWLList] ADD  CONSTRAINT [DF_Acc_DWLList_IsDisabled]  DEFAULT ((0)) FOR [IsDisabled]
GO

CREATE NONCLUSTERED INDEX [IX_Acc_DWLList_RepUpdateTime] ON [dbo].[Acc_DWLList]
(
	[RepUpdateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
GO


-- ======================
-- Acc_DWLList_xtest
-- ======================
CREATE TABLE [dbo].[Acc_DWLList_xtest](
	[custid] [int] NOT NULL,
	[product] [varchar](50) NOT NULL,
	[seq] [tinyint] NOT NULL,
	[ProductId] [tinyint] NULL,
	[IsDeleted] [bit] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
	[IsDisabled] [bit] NULL,
 CONSTRAINT [PK_Acc_DWLList_xtest] PRIMARY KEY CLUSTERED 
(
	[custid] ASC,
	[product] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO

ALTER TABLE [dbo].[Acc_DWLList_xtest] ADD  CONSTRAINT [DF_Acc_DWLList_xtest_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[Acc_DWLList_xtest] ADD  CONSTRAINT [DF_Acc_DWLList_xtest_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

ALTER TABLE [dbo].[Acc_DWLList_xtest] ADD  CONSTRAINT [DF_Acc_DWLList_xtest_IsDisabled]  DEFAULT ((0)) FOR [IsDisabled]
GO

CREATE NONCLUSTERED INDEX [IX_Acc_DWLList_xtest_RepUpdateTime] ON [dbo].[Acc_DWLList_xtest]
(
	[RepUpdateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
GO

-- ======================
-- Acc_DWLList_ExtraPT
-- ======================
CREATE TABLE [dbo].[Acc_DWLList_ExtraPT](
	[CustId] [int] NOT NULL,
	[GroupId] [int] NULL,
	[GroupName] [varchar](50) NULL,
	[IsDisabled] [bit] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
	[isDeleted] [bit] NULL,
 CONSTRAINT [PK_Acc_DWLList_ExtraPT1] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO

ALTER TABLE [dbo].[Acc_DWLList_ExtraPT] ADD  CONSTRAINT [DF_Acc_DWLList_ExtraPT]  DEFAULT ((0)) FOR [IsDisabled]
GO

ALTER TABLE [dbo].[Acc_DWLList_ExtraPT] ADD  CONSTRAINT [DF_Acc_DWLList_ExtraPT_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
GO

ALTER TABLE [dbo].[Acc_DWLList_ExtraPT] ADD  CONSTRAINT [DF_Acc_DWLList_ExtraPT_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

CREATE NONCLUSTERED INDEX [IX_Acc_DWLList_ExtraPT_RepUpdateTime] ON [dbo].[Acc_DWLList_ExtraPT]
(
	[RepUpdateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
GO


-- ======================
-- Acc_DWLList_ExtraPT_xtest
-- ======================
CREATE TABLE [dbo].[Acc_DWLList_ExtraPT_xtest](
	[CustId] [int] NOT NULL,
	[GroupId] [int] NULL,
	[GroupName] [varchar](50) NULL,
	[IsDisabled] [bit] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
	[isDeleted] [bit] NULL,
 CONSTRAINT [PK_Acc_DWLList_ExtraPT_xtest] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO

ALTER TABLE [dbo].[Acc_DWLList_ExtraPT_xtest] ADD  DEFAULT ((0)) FOR [IsDisabled]
GO

ALTER TABLE [dbo].[Acc_DWLList_ExtraPT_xtest] ADD  CONSTRAINT [DF_Acc_DWLList_ExtraPT_xtest_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
GO

ALTER TABLE [dbo].[Acc_DWLList_ExtraPT_xtest] ADD  CONSTRAINT [DF_Acc_DWLList_ExtraPT_xtest_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

CREATE NONCLUSTERED INDEX [IX_Acc_DWLList_ExtraPT_xtest_RepUpdateTime] ON [dbo].[Acc_DWLList_ExtraPT_xtest]
(
	[RepUpdateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
GO

