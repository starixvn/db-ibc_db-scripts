/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DBCUST/NAP_UserControl
*/
USE NAP_UserControl 
GO

CREATE TABLE [dbo].[accCustomer](
	[custid] [int] NOT NULL,
	[PageAccess] [nvarchar](500) NULL,
	[createdate] [datetime] NULL,
	[creator] [int] NULL,
	[GroupID] [int] NULL,
 CONSTRAINT [PK_accCustomer] PRIMARY KEY CLUSTERED 
(
	[custid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

ALTER TABLE [dbo].[accCustomer] ADD  CONSTRAINT [DF_accCustomer_createdate]  DEFAULT (getdate()) FOR [createdate]
GO
CREATE TABLE [dbo].[Acc_Menu](
	[MenuId] [int] IDENTITY(1,1) NOT NULL,
	[Menu] [varchar](50) NULL,
	[ParentId] [int] NULL,
	[FuncName] [varchar](50) NULL,
	[Url] [varchar](100) NULL,
	[Target] [varchar](50) NULL,
	[IsHide] [bit] NULL,
	[ORDER] [int] NULL,
	[System] [varchar](50) NULL,
 CONSTRAINT [PK_Acc_Menu] PRIMARY KEY CLUSTERED 
(
	[MenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

ALTER TABLE [dbo].[Acc_Menu] ADD  CONSTRAINT [DF_Acc_Menu_IsHide]  DEFAULT ((0)) FOR [IsHide]
GO

CREATE TABLE [dbo].[Acc_MemberPolicy](
	[CustID] [int] NOT NULL,
	[FuncID] [int] NOT NULL,
	[Policy] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[ModifyDate] [datetime] NOT NULL,
	[Creator] [int] NULL,
 CONSTRAINT [PK_Acc_MemberPolicy] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[FuncID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

ALTER TABLE [dbo].[Acc_MemberPolicy] ADD  CONSTRAINT [DF_Acc_MemberPolicy_ModifyDate]  DEFAULT (getdate()) FOR [ModifyDate]
GO

CREATE TABLE [dbo].[Acc_GroupPolicy](
	[GroupID] [int] NOT NULL,
	[FuncID] [int] NOT NULL,
	[Policy] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[ModifyDate] [datetime] NULL,
	[Creator] [int] NULL,
 CONSTRAINT [PK_Acc_GroupPolicy] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC,
	[FuncID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

ALTER TABLE [dbo].[Acc_GroupPolicy] ADD  CONSTRAINT [DF_Acc_GroupPolicy_Policy]  DEFAULT ((0)) FOR [Policy]
GO

ALTER TABLE [dbo].[Acc_GroupPolicy] ADD  CONSTRAINT [DF_Acc_GroupPolicy_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO

ALTER TABLE [dbo].[Acc_GroupPolicy] ADD  CONSTRAINT [DF_Acc_GroupPolicy_ModifyDate]  DEFAULT (getdate()) FOR [ModifyDate]
GO

CREATE TABLE [dbo].[Acc_GroupInfo](
	[GroupID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[GroupDesc] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NULL,
	[ModifyDate] [datetime] NULL,
	[DisplayOrder] [tinyint] NULL,
	[Creator] [int] NULL,
	[System] [varchar](50) NULL,
 CONSTRAINT [PK_Acc_GroupInfo] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

ALTER TABLE [dbo].[Acc_GroupInfo] ADD  CONSTRAINT [DF_Acc_GroupInfo_GroupName]  DEFAULT ('') FOR [GroupName]
GO

ALTER TABLE [dbo].[Acc_GroupInfo] ADD  CONSTRAINT [DF_Acc_GroupInfo_GroupDesc]  DEFAULT ('') FOR [GroupDesc]
GO

ALTER TABLE [dbo].[Acc_GroupInfo] ADD  CONSTRAINT [DF_Acc_GroupInfo_ModifyDate]  DEFAULT (getdate()) FOR [ModifyDate]
GO

ALTER TABLE [dbo].[Acc_GroupInfo] ADD  CONSTRAINT [DF_Acc_GroupInfo_DisplayOrder]  DEFAULT ((5)) FOR [DisplayOrder]
GO

ALTER TABLE [dbo].[Acc_GroupInfo] ADD  CONSTRAINT [DF_Acc_GroupInfo_System]  DEFAULT ('ACCOUNTING') FOR [System]
GO

CREATE TABLE [dbo].[Acc_FunctionInfo](
	[FuncID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FuncName] [nvarchar](50) NULL,
	[FuncNote] [nvarchar](2000) NULL,
	[FuncDesc] [nvarchar](50) NULL,
	[FuncRender] [tinyint] NULL,
	[CreateDate] [datetime] NOT NULL,
	[ModifyDate] [datetime] NOT NULL,
	[DisplayOrder] [tinyint] NULL,
	[Creator] [int] NULL,
	[ParentID] [int] NULL,
	[Filenames] [varchar](max) NULL,
	[System] [varchar](50) NULL,
 CONSTRAINT [PK_Acc_FunctionInfo] PRIMARY KEY CLUSTERED 
(
	[FuncID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table] TEXTIMAGE_ON [NAP_UserControl_table]

GO
ALTER TABLE [dbo].[Acc_FunctionInfo] ADD  CONSTRAINT [DF_Acc_Funct_ModifyDate]  DEFAULT (getdate()) FOR [ModifyDate]
GO
ALTER TABLE [dbo].[Acc_FunctionInfo] ADD  CONSTRAINT [DF_Acc_Funct_DisplayOrder]  DEFAULT ((7)) FOR [DisplayOrder]
GO




