USE [bodb02]
GO

/****** Object:  Table [dbo].[SMP_Selection]    Script Date: 02/14/2019 02:45:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SMP_Selection](
	[SelectionType] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SelectionName] [varchar](200) NOT NULL,
	[ResourceCh] [nvarchar](200) NULL,
	[ResourceCs] [nvarchar](200) NULL,
	[ResourceSc2] [nvarchar](200) NULL,
	[ResourceJp] [nvarchar](200) NULL,
	[ResourceTh] [nvarchar](200) NULL,
	[ResourceKo] [nvarchar](200) NULL,
	[ResourceEs] [nvarchar](200) NULL,
	[ResourceVn] [nvarchar](200) NULL,
	[ResourceId] [nvarchar](200) NULL,
	[ResourceFr] [nvarchar](200) NULL,
	[ResourceRu] [nvarchar](200) NULL,
	[ResourcePt] [nvarchar](200) NULL,
	[ResourceDe] [nvarchar](200) NULL,
	[ResourceIt] [nvarchar](200) NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_SMP_Selection] PRIMARY KEY CLUSTERED 
(
	[SelectionType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_table]
) ON [SMP_table]

GO

SET ANSI_PADDING OFF
GO


