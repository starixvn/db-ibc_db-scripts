/*<info serverAlias="IRS_DBCTG-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241024@Bobby	
	Task: In-House
	DB: IRS_DBCTG-bodb02
	
	Revisions:
		- 20241024@Bobby: Created [RedmineID: #209191]

	Example:			
*/
USE bodb02;
GO

---#1
---Disable InHouse servcice
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'TransferExtra')
BEGIN
	UPDATE RepInfo WITH(ROWLOCK, UPDLOCK)
	SET active = 0
	WHERE [group] = 3
		AND [name] =  'TransferExtra'
END
GO

--#2
/****** Object:  StoredProcedure [dbo].[Repl_PutTransferExtra]    Script Date: 11/12/2024 2:13:26 PM ******/
DROP PROCEDURE [dbo].[Repl_PutTransferExtra]
GO

--#3
/****** Object:  UserDefinedTableType [dbo].[TVP_ReplTransferExtra]    Script Date: 11/12/2024 2:08:57 PM ******/
DROP TYPE [dbo].[TVP_ReplTransferExtra]
GO

--#4
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
	,[TransDesc] [NVARCHAR](4000) NULL ---> 2000 -> 4000
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

--#5
/****** Object:  StoredProcedure [dbo].[Repl_PutTransferExtra]    Script Date: 11/12/2024 2:13:26 PM ******/
CREATE PROCEDURE [dbo].[Repl_PutTransferExtra]
    @tvp_param TVP_ReplTransferExtra READONLY
AS
/*
	Created: 20241024@Bobby	
	Task: In-House
	DB: IRS_DBCTG-bodb02
	
	Revisions:
		- 20241024@Bobby: SabaWallet Reward Program [RedmineID: #209191]

	Example:			
*/
BEGIN
    SET NOCOUNT ON;
		
    MERGE [dbo].[TransferExtra] [t]
    USING @tvp_param [tvp] 
		ON [t].[TransId] = [tvp].[TransId]
		WHEN MATCHED AND [tvp].[isDeleted] = 0 THEN	
		UPDATE SET
			[t].[CustID] = [tvp].[CustID]
			,[t].[Recommend] = [tvp].[Recommend]
			,[t].[Mrecommend] = [tvp].[Mrecommend]
			,[t].[Srecommend] = [tvp].[Srecommend]
			,[t].[CurrencyID] = [tvp].[CurrencyID]
			,[t].[ActualRate] = [tvp].[ActualRate]
			,[t].[Debit] = [tvp].[Debit]
			,[t].[Credit] = [tvp].[Credit]
			,[t].[Bettype] = [tvp].[Bettype]
			,[t].[TransDate] = [tvp].[TransDate]
			,[t].[WinlostDate] = [tvp].[WinlostDate]
			,[t].[TransDesc] = [tvp].[TransDesc]
			,[t].[RefNo] = [tvp].[RefNo]
			,[t].[IsReversed] = [tvp].[IsReversed]
			,[t].[WalletID] = [tvp].[WalletID]
			,[t].[Creator] = [tvp].[Creator]
			,[t].[SiteDBGroupID] = [tvp].[SiteDBGroupID]
			,[t].[CheckID] = [tvp].[CheckID]
			,[t].[Checktime] = [tvp].[Checktime]
			,[t].[RepUpdateTime] = CASE WHEN [tvp].[RepUpdateTime] > ISNULL([t].[RepUpdateTime],'') THEN [tvp].[RepUpdateTime] ELSE [t].[RepUpdateTime] END
	WHEN MATCHED AND [tvp].[isDeleted] = 1 THEN 
		DELETE	
    WHEN NOT MATCHED AND [tvp].[isDeleted] = 0 THEN
        INSERT ([TransId]
				,[CustID]
				,[Recommend]
				,[Mrecommend]
				,[Srecommend]
				,[CurrencyID]
				,[ActualRate]
				,[Debit]
				,[Credit]
				,[Bettype]
				,[TransDate]
				,[WinlostDate]
				,[TransDesc]
				,[RefNo]
				,[IsReversed]
				,[WalletID]
				,[Creator]
				,[SiteDBGroupID]
				,[CheckID]
				,[Checktime]
				,[RepUpdateTime])
		VALUES ([tvp].[TransId]
				,[tvp].[CustID]
				,[tvp].[Recommend]
				,[tvp].[Mrecommend]
				,[tvp].[Srecommend]
				,[tvp].[CurrencyID]
				,[tvp].[ActualRate]
				,[tvp].[Debit]
				,[tvp].[Credit]
				,[tvp].[Bettype]
				,[tvp].[TransDate]
				,[tvp].[WinlostDate]
				,[tvp].[TransDesc]
				,[tvp].[RefNo]
				,[tvp].[IsReversed]
				,[tvp].[WalletID]
				,[tvp].[Creator]
				,[tvp].[SiteDBGroupID]
				,[tvp].[CheckID]
				,[tvp].[Checktime]
				,[tvp].[RepUpdateTime]
		);
		
END	
GO

GRANT EXECUTE ON [dbo].[Repl_PutTransferExtra] TO [repl_ap] AS [dbo]
GO

--#6
---Enable InHouse servcice
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'TransferExtra')
BEGIN
	UPDATE RepInfo WITH(ROWLOCK, UPDLOCK)
	SET active = 1
	WHERE [group] = 3
		AND [name] =  'TransferExtra'
END
GO