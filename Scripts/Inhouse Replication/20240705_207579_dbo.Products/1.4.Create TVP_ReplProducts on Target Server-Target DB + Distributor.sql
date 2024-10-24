/*<info serverAlias="DBCustRepl-ReplCustDB,DBCUST-CustDB"></info>*/
/*
	Created: 20240705@Lewis
	DB: 
		+ DBCustRepl-ReplCustDB
		+ DBTXN-bodb02 (not yet)
		+ IRS_DBAGE-bodb02 (not yet)
		+ IRS_DBACC-bodb02 (not yet)
		+ IRS_DBBOF-bodb02 (not yet)
		+ IRS_DBTP-bodb02 (not yet)
		+ IRS_DBADM-bodb02 (not yet)
		+ IRS_DBBAH-bodb02 (not yet)
		+ IRS_DBPROUAT-bodb02 (not yet)
		+ DBCUST-CustDB
	Task: InHouse Replication - Create TVP_ReplProducts on Target + Distributor	
*/

CREATE TYPE [dbo].[TVP_ReplProducts] AS TABLE(
	[ProductID] [tinyint] NOT NULL,
	[ProductName] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[ProductPrefix] [varchar](10) NULL,
	[Enabled] [bit] NULL,
	[ProductNameCh] [nvarchar](50) NULL,
	[ProductNameCs] [nvarchar](50) NULL,
	[ProductNameJp] [nvarchar](50) NULL,
	[ProductNameIt] [nvarchar](50) NULL,
	[ProductNameTh] [nvarchar](50) NULL,
	[ProductNameKo] [nvarchar](50) NULL,
	[ProductNameES] [nvarchar](50) NULL,
	[ProductNameVN] [nvarchar](50) NULL,
	[ProductNameEL] [nvarchar](50) NULL,
	[ProductNameRU] [nvarchar](50) NULL,
	[ProductNameID] [nvarchar](50) NULL,
	[BalanceType] [tinyint] NULL,
	[SubProductBalanceType] [varchar](512) NULL,
	[GroupType] [tinyint] NULL,
	[CasinoType] [tinyint] NULL,
	[IsOfferPlayForFun] [bit] NULL,
	[EndOfSupportDate] [date] NULL,
	[VendorID] [smallint] NULL,
	[OrderNo] [int] NULL,
	[Environment] [tinyint] NOT NULL,
	[RepUpdateTime] [datetime2](7) NULL,
	[_FetchedTime] [datetime2](7) NULL
)
GO

GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplProducts] TO [repl_ap] AS [dbo]
GO