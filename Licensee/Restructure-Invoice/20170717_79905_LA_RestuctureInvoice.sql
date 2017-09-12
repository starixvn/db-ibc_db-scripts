
USE bodb_licensee
GO

/*
	Created: 20170717@Harper
	Description: Re-structure new Invoice [RedmineID: #76410]
*/

-- Add PartyGroupType: 1_MinFeeGroup, 2_PayerGroup
--ALTER TABLE dbo.LA_PartyGroup ADD PartyGroupType SMALLINT
--GO

-- Add IsPayerGroup: 0_PayerID, 1_PayerGroupID
--ALTER TABLE dbo.LA_InvoiceHeader ADD IsPayerGroup BIT
--GO

-- Add OfficialInvoiceNo = InvoiceSymbol + InvoiceNumber + Status (if void or close)
ALTER TABLE dbo.LA_InvoiceHeader ADD OfficialInvoiceNo NVARCHAR(50)
GO

-- Create LA_InvoiceItemType table
CREATE TABLE [dbo].[LA_InvoiceItemType](
	[InvItemTypeId] [SMALLINT] NOT NULL,
	[InvItemTypeName] [NVARCHAR](100) NULL,
	[SignDB] [SMALLINT] NULL,
	[GroupDB] [VARCHAR](20) NULL,
	[SignSOA] [SMALLINT] NULL,
	[GroupSOA] [VARCHAR](20) NULL,
 CONSTRAINT [PK_LA_InvoiceItemType] PRIMARY KEY CLUSTERED 
(
	[InvItemTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

-- Create LA_InvoiceTypeMapping table
CREATE TABLE [dbo].[LA_InvoiceTypeMapping](
	[InvTypeId] [SMALLINT] NOT NULL,
	[InvItemTypeId] [SMALLINT] NOT NULL,
 CONSTRAINT [PK_LA_InvoiceTypeMapping] PRIMARY KEY CLUSTERED 
(
	[InvTypeId] ASC,
	[InvItemTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

-- Create LA_InvoiceStatement table
CREATE TABLE [dbo].[LA_InvoiceStatement](
	[InvoiceStatementId] [BIGINT] IDENTITY(1,1) NOT NULL,
	[InvoiceHeaderId] [BIGINT] NOT NULL,
	[InvItemTypeId] [SMALLINT] NULL,
	[StatusID] [SMALLINT] NULL,
	[Description] [NVARCHAR](100) NULL,
	[Income] [MONEY] NULL,
	[Expense] [MONEY] NULL,
	[RefNo] [NVARCHAR](50) NULL,
	[RefPartyId] [INT] NULL,
 CONSTRAINT [PK_LA_InvoiceStatement] PRIMARY KEY CLUSTERED 
(
	[InvoiceStatementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO
