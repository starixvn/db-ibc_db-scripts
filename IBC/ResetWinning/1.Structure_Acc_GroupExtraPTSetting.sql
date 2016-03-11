USE [bodb_ACC]
GO

/****** Object:  Table [dbo].[Acc_GroupExtraPTSetting]    Script Date: 3/9/2016 11:11:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Acc_GroupExtraPTSetting](
	[SuperId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[ProductId] [tinyint] NOT NULL,
	[Sporttype] [smallint] NOT NULL,
	[SubProduct] [varchar](500) NOT NULL,
	[ExtraPT] [decimal](9, 8) NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
 CONSTRAINT [PK_Acc_GroupExtraPTSetting] PRIMARY KEY NONCLUSTERED 
(
	[SuperId] ASC,
	[GroupId] ASC,
	[ProductId] ASC,
	[Sporttype] ASC,
	[SubProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Acc_GroupExtraPTSetting] ADD CONSTRAINT DF_Acc_GroupExtraPTSetting_Sporttype  DEFAULT ((0)) FOR [Sporttype]
GO

ALTER TABLE [dbo].[Acc_GroupExtraPTSetting] ADD CONSTRAINT DF_Acc_GroupExtraPTSetting_SubProduct  DEFAULT ('') FOR [SubProduct]
GO
 

/****** Object:  Index [CIX_Acc_GroupExtraPTSetting_SuperId]    Script Date: 3/9/2016 12:35:12 PM ******/
CREATE CLUSTERED INDEX [CIX_Acc_GroupExtraPTSetting_SuperId] ON [dbo].[Acc_GroupExtraPTSetting]
(
	[SuperId] ASC,
	[ProductId] ASC,
	[SubProduct] ASC,
	[Sporttype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO



------------------------
USE [bodb_ACC]
GO

/****** Object:  Table [dbo].[Acc_DWLList_ExtraPT]    Script Date: 3/4/2016 3:37:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Acc_DWLList_ExtraPT](
	[CustId] [int] NOT NULL,
	[GroupId] [int] NULL,
	[GroupName] [varchar](50) NULL,
	
 CONSTRAINT [PK_Acc_DWLList_ExtraPT] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

SET ANSI_PADDING OFF
GO


-----------------------

USE [bodb_ACC]
GO

/****** Object:  Table [dbo].[Acc_DWLList_ExtraPT_xtest]    Script Date: 3/4/2016 3:37:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Acc_DWLList_ExtraPT_xtest](
	[CustId] [int] NOT NULL,
	[GroupId] [int] NULL,
	[GroupName] [varchar](50) NULL,
 CONSTRAINT [PK_Acc_DWLList_ExtraPT_xtest] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

SET ANSI_PADDING OFF
GO
