/*<info serverAlias="IRS_DBCTG-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241024@Bobby	
	Task: In-House
	DB: IRS_DBCTG-bodb02
	
	Revisions:
		- 20241024@Bobby: Created [RedmineID: #209191]

	Example:			
*/
CREATE TYPE [dbo].[TVP_ReplTransferExtra] AS TABLE (
	[TransId] [BIGINT] NOT NULL
	,[CustID] [INT] NULL
	,[Recommend] [INT] NULL
	,[Mrecommend] [INT] NULL
	,[Srecommend] [INT] NULL
	,[CurrencyID] [INT] NULL
	,[ActualRate] [FLOAT] NULL
	,[Debit] [MONEY] NULL
	,[Credit] [MONEY] NULL
	,[Bettype] [SMALLINT] NULL
	,[TransDate] [DATETIME] NULL
	,[WinlostDate] [SMALLDATETIME] NULL
	,[TransDesc] [NVARCHAR](2000) NULL
	,[RefNo] [BIGINT] NULL
	,[IsReversed] [BIT] NULL
	,[WalletID] [TINYINT] NULL
	,[Creator] [INT] NULL
	,[SiteDBGroupID] [SMALLINT] NULL
	,[CheckID] [INT] NULL
	,[Checktime] [DATETIME] NULL
	,[RepUpdateTime] [DATETIME2](7) NOT NULL
	,[isDeleted] [BIT]
	,[_FetchedTime] [DATETIME2](7)
)
GO
GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplTransferExtra] TO [repl_ap] AS [dbo]
GO
/***************************************************************************/




