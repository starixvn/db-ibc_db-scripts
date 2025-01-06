/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB"></info>*/
/*
	Created by: Lewis@20250106
	Task: Rep Inhouse exchange [Redmine:#215883] 
	DB:	IRS_DBTP-bodb02,DBCustRepl-ReplCustDB
*/

CREATE TABLE [dbo].[exchange](
	[currency] [nvarchar](50) NOT NULL,
	[stakerate] [float] NULL,
	[actualrate] [float] NOT NULL,
	[commaxpayout] [float] NULL,
	[creator] [nvarchar](50) NOT NULL,
	[minbet] [float] NULL,
	[minbetlive] [float] NULL,
	[AUDRate] [float] NULL,
	[ZARRate] [float] NULL,
	[GBPRate] [float] NULL,
	[EURORate] [float] NULL,
	[US$Rate] [float] NULL,
	[Code] [varchar](12) NULL,
	[Description] [varchar](100) NULL,
	[MultipliedBy] [decimal](19, 8) NULL,
	[ExVirtualRate] [float] NULL,
	[IsActive] [bit] NOT NULL,
	[OfferSite] [tinyint] NOT NULL,
	[ExchangeId] [int] NOT NULL,
	[RepUpdateTime] [datetime2](7) NULL,
	[CurrencyType] [tinyint] NOT NULL,
	[CreditGroupID] [tinyint] NULL,
	[LicenseeGroupID] [tinyint] NULL,
 CONSTRAINT [PK_ExchangeId] PRIMARY KEY CLUSTERED 
(
	[ExchangeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO

ALTER TABLE [dbo].[exchange] ADD  CONSTRAINT [DF_Exchange_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[exchange] ADD  CONSTRAINT [DF_Exchange_OfferSite]  DEFAULT ((0)) FOR [OfferSite]
GO

ALTER TABLE [dbo].[exchange] ADD  CONSTRAINT [DF_exchange_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

ALTER TABLE [dbo].[exchange] ADD  CONSTRAINT [DF_Exchange_CurrencyType]  DEFAULT ((0)) FOR [CurrencyType]
GO

CREATE NONCLUSTERED INDEX [IX_exchange_RepUpdateTime] ON [dbo].[exchange]([RepUpdateTime] ASC) ON [DATA]

