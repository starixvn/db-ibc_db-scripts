USE bodb_Licensee
GO

/*
	Created: 20191025@Percy
	DB: DB042.bodb_Licensee
	Task: Add new tables LicenseeBAHistory, LicenseeBAConfig and LICSettings
*/

-- Note: create filegroup BA_DATA if need


-- LicenseeBAHistory
CREATE TABLE [dbo].[LicenseeBAHistory](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LicenseeID] [int] NOT NULL,
	[CustID] [int] NOT NULL,
	[OnDate] [datetime] NOT NULL,
	[OffDate] [datetime] NULL,
	[OnBy] [int] NOT NULL,
	[OffBy] [int] NULL,
	[GroupComm] [decimal](9, 8) NOT NULL,
	[1x2Comm] [decimal](9, 8) NOT NULL,
	[OtherComm] [decimal](9, 8) NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[Ugroup] [varchar](3) NULL,
 CONSTRAINT [PK_LicenseeBAHistory] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [BA_DATA]

GO




-- LicenseeBAConfig
CREATE TABLE [dbo].[LicenseeBAConfig](
	[LicenseeID] [int] NOT NULL,
	[1x2Comm] [decimal](9, 8) NOT NULL,
	[OtherComm] [decimal](9, 8) NOT NULL,
	[EnableBA] [bit] NOT NULL,
	[ModifyBy] [int] NOT NULL,
	[ModifyDate] [datetime] NOT NULL,
	[groupa] [decimal](9, 8) NOT NULL,
	[groupb] [decimal](9, 8) NOT NULL,
	[groupc] [decimal](9, 8) NOT NULL,
	[groupd] [decimal](9, 8) NOT NULL,
 CONSTRAINT [PK_LicenseeBAConfig] PRIMARY KEY CLUSTERED 
(
	[LicenseeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BA_DATA]
) ON [BA_DATA]

GO



-- LICSettings
CREATE TABLE [dbo].[LICSettings](
	[VID] [int] IDENTITY(1,1) NOT NULL,
	[VName] [varchar](20) NULL,
	[VValue] [varchar](200) NULL,
	[VValue2] [varchar](200) NULL,
 CONSTRAINT [PK_ABSettings] PRIMARY KEY CLUSTERED 
(
	[VID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO