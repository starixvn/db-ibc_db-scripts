USE bodb_LicenseeReport
GO

--======================tblKPI_Stats
CREATE TABLE [dbo].[tblKPI_Stats](
	[StatID] [int] NOT NULL,
	[StatName] [varchar](100) NULL,
 CONSTRAINT [PK_tbl_KPIStat] PRIMARY KEY CLUSTERED 
(
	[StatID] ASC
) ON [KPI_Data]
) ON [KPI_Data]

GO

--======================tblKPI_Budgets
CREATE TABLE [dbo].[tblKPI_Budgets](
	[Date] [smalldatetime] NOT NULL,
	[GroupID] [int] NOT NULL,
	[StatID] [int] NOT NULL,
	[BudgetAmount] [float] NULL,
 CONSTRAINT [PK_tblKPI_Budgets] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[GroupID] ASC,
	[StatID] ASC
) ON [KPI_Data]
) ON [KPI_Data]
GO

--======================rptKPI_Transfer
CREATE TABLE [dbo].[rptKPI_Transfer](
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[TransferInCount] [int] NULL,
	[FirstTransferInAmt] [money] NULL,
	[FirstTransferInCount] [int] NULL,
	[TransferOutCount] [int] NULL,
 CONSTRAINT [PK_rptKPI_Transfer] PRIMARY KEY CLUSTERED 
(
	[rptDate] ASC,
	[SiteID] ASC,
	[CurrencyID] ASC
) ON [KPI_Data]
) ON [KPI_Data]
GO

--======================rptKPI_MTD_Cross
CREATE TABLE [dbo].[rptKPI_MTD_Cross](
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[StatID] [int] NOT NULL,
	[MonthToDate] [float] NULL,
 CONSTRAINT [PK_rptKPI_MTD_Cross] PRIMARY KEY CLUSTERED 
(
	[rptDate] ASC,
	[SiteID] ASC,
	[CurrencyID] ASC,
	[StatID] ASC
) ON [KPI_Data]
) ON [KPI_Data]
GO

--======================rptKPI_MTD_BA_Cross
CREATE TABLE [dbo].[rptKPI_MTD_BA_Cross](
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[StatID] [int] NOT NULL,
	[MonthToDate] [float] NULL,
 CONSTRAINT [PK_rptKPI_MTD_BA_Cross] PRIMARY KEY CLUSTERED 
(
	[rptDate] ASC,
	[SiteID] ASC,
	[CurrencyID] ASC,
	[StatID] ASC
) ON [KPI_Data]
) ON [KPI_Data]
GO

----======================rptKPI_Account_BA
CREATE TABLE [dbo].[rptKPI_Account_BA](
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[Hour] [tinyint] NOT NULL,
	[UniqueBettorCount] [int] NULL,
	[PeakBettorCount] [int] NULL,
 CONSTRAINT [PK_rptKPI_Account_BA] PRIMARY KEY CLUSTERED 
(
	[rptDate] ASC,
	[SiteID] ASC,
	[Hour] ASC
) ON [KPI_Data]
) ON [KPI_Data]
GO

----======================rptKPI_Account
CREATE TABLE [dbo].[rptKPI_Account](
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[Hour] [tinyint] NOT NULL,
	[UniqueBettorCount] [int] NULL,
	[PeakBettorCount] [int] NULL,
 CONSTRAINT [PK_rptKPI_Account] PRIMARY KEY CLUSTERED 
(
	[rptDate] ASC,
	[SiteID] ASC,
	[Hour] ASC
) ON [KPI_Data]
) ON [KPI_Data]
GO
