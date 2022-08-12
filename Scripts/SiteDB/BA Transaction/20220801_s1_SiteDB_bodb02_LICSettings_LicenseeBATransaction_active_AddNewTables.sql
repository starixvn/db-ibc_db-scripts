/*<info serverAlias="DBSID-bodb02"></info>*/
USE [bodb02]
GO
/*
	Created: 20220801@Evan
	DB: DBSID-bodb02
	Task: Add new tables LICSettings,LicenseeBATransaction_active [RedmineID: #175297]
*/

--LICSettings
CREATE TABLE [dbo].[LICSettings](
	[VID] [int] IDENTITY(1,1) NOT NULL,
	[VName] [varchar](20) NULL,
	[VValue] [varchar](200) NULL,
	[VValue2] [varchar](200) NULL,
	CONSTRAINT [PK_BASettings] PRIMARY KEY CLUSTERED 
(
	[VID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
)  ON [DATA]
	
	
--LicenseeBATransaction_active
CREATE TABLE [dbo].[LicenseeBATransaction_active](
	[TransID] [bigint] NOT NULL,
	[TransDate] [datetime] NULL,
	[CustId] [int] NULL,
	[Recommend] [int] NULL,
	[Srecommend] [int] NULL
) ON [DATA]

CREATE UNIQUE CLUSTERED INDEX [CIX_LicenseeBATransaction_active] ON [dbo].[LicenseeBATransaction_active]
(
	[TransID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)  ON [DATA]

CREATE NONCLUSTERED INDEX [IX_Recommend] ON [dbo].[LicenseeBATransaction_active]
(
	[Recommend] ASC
)
INCLUDE([TransID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)  ON [DATA]

CREATE NONCLUSTERED INDEX [IX_Srecommend] ON [dbo].[LicenseeBATransaction_active]
(
	[Srecommend] ASC
)
INCLUDE([TransID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)  ON [DATA]
GO