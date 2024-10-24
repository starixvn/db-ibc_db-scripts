/*<info serverAlias="IRS_DBAGE-bodb02,IRS_DBACC-bodb02,IRS_DBTP-bodb02,DBRepl-ReplDB,DBCTG-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20240917@Lewis	
	Task: In-House
	DB: IRS_DBAGE-bodb02,IRS_DBACC-bodb02,IRS_DBTP-bodb02,DBRepl-ReplDB,DBCTG-bodb02
	
	Revisions:
		- 20240917@Lewis: Created [RedmineID: #208503]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplSabaWalletTicket] AS TABLE (
	[TransId] [BIGINT] NOT NULL
	,[CustID] [INT] NULL
	,[Recommend] [INT] NULL
	,[Mrecommend] [INT] NULL
	,[Srecommend] [INT] NULL
	,[CurrencyID] [INT] NULL
	,[ActualRate] [FLOAT] NULL
	,[Amount] [MONEY] NULL
	,[TransDate] [DATETIME] NULL
	,[WinlostDate] [SMALLDATETIME] NULL
	,[WalletId] [TINYINT] NULL
	,[StatusId] [TINYINT] NULL
	,[TransDesc] [NVARCHAR](2000) NULL
	,[ProgramId] [SMALLINT] NULL
	,[PaymentStatus] [TINYINT] NULL
	,[APaymentDate] [DATE] NULL
	,[MPaymentDate] [DATE] NULL
	,[SPaymentDate] [DATE] NULL
	,[HPaymentDate] [DATE] NULL
	,[IsComplaint] [BIT] NULL
	,[Creator] [INT] NULL
	,[SiteDBGroupId] [SMALLINT] NULL
	,[IsReversed] [BIT] NULL
	,[RefNo] [BIGINT] NULL
	,[SId] [SMALLINT] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplSabaWalletTicket] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/