USE [bodb_Report]
GO

ALTER PROCEDURE [dbo].[DBA_RptStatement]
	@Winlostdate	SMALLDATETIME,
	@statementDate	SMALLDATETIME,
	@Custid			INT,
	@recommend		INT,
	@mrecommend		INT,
	@srecommend		INT,
	@BalanceUpDay	SMALLDATETIME
AS

/*
	Created by Percy
	Date: 2017-06-28
	DB: DBTXN.bodb02
	Task: Insert into rpt Statement

	Revisions:
		- 20170628@Percy: Create new

	Param's Explanation:
*/

BEGIN

	SET NOCOUNT ON

	DECLARE @rptStatementTable TABLE(
		Custid				INT
		,OpeningBalance		MONEY	NULL
		,VoidAmt			MONEY	NULL
		,Turnover			MONEY	NULL
		,netTurnover		MONEY	NULL
		,TransferAmt		MONEY	NULL
		,Winlost			MONEY	NULL
		,Comm				MONEY	NULL
		,ClosingBalance		MONEY	NULL
		,BetCount			INT		DEFAULT 0
		,TransCount			INT		DEFAULT 0
	)

		-- get sum data from Bettrans into rptStatement
		-- Member
		INSERT INTO @rptStatementTable(
			Custid
			,Turnover
			,netTurnover
			,Winlost
			,Comm
			,BetCount
		)
		SELECT
			@custid
			,SUM(CASE WHEN statusID NOT IN(103) 
				  THEN CASE WHEN liveawayscore = 0 AND bettype IN(33,43) THEN ABS(stake)/2 ELSE ABS(stake) END 
				  ELSE 0 END) AS Turnover
			,0 AS netTurnover
			,SUM(winlost - actual_stake) AS winlost
			,SUM(playercomm) AS comm
			,COUNT(CASE WHEN Bettype = 500 THEN NULL ELSE transid END) AS betcount
		FROM
			DBTXN.bodb02.dbo.Bettrans WITH(NOLOCK)
		WHERE
			winlostdate = @Winlostdate
			AND statusID NOT IN (0,1,102,101) -- 'running','waiting','VOID','REJECT'
			AND bettype <= 19999
			AND ruben = 1
			AND custid = @Custid
			
		-- Agent
		INSERT INTO @rptStatementTable(
			Custid
			,Turnover
			,netTurnover
			,Winlost
			,Comm
			,BetCount
		)
		SELECT
			@recommend
			,SUM(CASE WHEN statusID NOT IN(103) 
				  THEN CASE WHEN liveawayscore = 0 AND bettype IN(33,43) THEN ABS(stake)/2 ELSE ABS(stake) END
				  ELSE 0 END) AS Turnover
			,SUM(CASE WHEN statusID NOT IN(103) 
				  THEN CASE WHEN liveawayscore = 0 AND bettype IN(33,43) THEN ABS(stake*apositiontaking)/2 ELSE ABS(stake*apositiontaking) END 
				  ELSE 0 END) AS netTurnover
			,SUM(awinlost) AS winlost
			,SUM(comm - playercomm) AS comm
			,COUNT(CASE WHEN Bettype = 500 THEN NULL ELSE transid END) AS betcount
		FROM
			DBTXN.bodb02.dbo.Bettrans WITH(NOLOCK)
		WHERE
			winlostdate = @Winlostdate
			AND statusID NOT IN (0,1,102,101) -- 'running','waiting','VOID','REJECT'
			AND bettype <= 19999
			AND ruben = 1
			AND custid = @Custid
		
		-- Master
		INSERT INTO @rptStatementTable(
			Custid
			,Turnover
			,netTurnover
			,Winlost
			,Comm
			,BetCount
		)
		SELECT
			@mrecommend
			,SUM(CASE WHEN statusID NOT IN(103) 
				  THEN CASE WHEN liveawayscore = 0 AND bettype IN(33,43) THEN ABS(stake)/2 ELSE ABS(stake) END 
				  ELSE 0 END) AS Turnover
			,SUM(CASE WHEN statusID NOT IN(103) 
				  THEN CASE WHEN liveawayscore = 0 AND bettype IN(33,43) THEN ABS(stake*mpositiontaking)/2 ELSE ABS(stake*mpositiontaking) END 
				  ELSE 0 END) AS netTurnover
			,SUM(mwinlost) AS winlost
			,SUM(acomm - comm) AS comm
			,COUNT(CASE WHEN Bettype = 500 THEN NULL ELSE transid END) AS betcount
		FROM
			DBTXN.bodb02.dbo.Bettrans WITH(NOLOCK)
		WHERE
			winlostdate = @Winlostdate
			AND statusID NOT IN (0,1,102,101) -- 'running','waiting','VOID','REJECT'
			AND bettype <= 19999
			AND ruben = 1
			AND custid = @Custid
		
		-- Super
		INSERT INTO @rptStatementTable(
			Custid
			,Turnover
			,netTurnover
			,Winlost
			,Comm
			,BetCount
		)
		SELECT
			@srecommend
			,SUM(CASE WHEN statusID NOT IN(103) 
				  THEN CASE WHEN liveawayscore = 0 AND bettype IN(33,43) THEN ABS(stake)/2 ELSE ABS(stake) END
				  ELSE 0 END) AS Turnover
			,SUM(CASE WHEN statusID NOT IN(103) 
				  THEN CASE WHEN liveawayscore = 0 AND bettype IN(33,43) THEN ABS(stake*spositiontaking)/2 ELSE ABS(stake*spositiontaking) END 
				  ELSE 0 END) AS netTurnover
			,SUM(swinlost) AS winlost
			,SUM(scomm - acomm) AS comm
			,COUNT(CASE WHEN Bettype = 500 THEN NULL ELSE transid END) AS betcount
		FROM
			DBTXN.bodb02.dbo.Bettrans WITH(NOLOCK)
		WHERE
			winlostdate = @Winlostdate
			AND statusID NOT IN (0,1,102,101) -- 'running','waiting','VOID','REJECT'
			AND bettype <= 19999
			AND ruben = 1
			AND custid = @Custid
			
		-- Opening Balance for rptStatement
		IF (@statementDate = @BalanceUpDay)
		BEGIN
			--get Opening Balance with bettype = 20000 from bettrans
			INSERT INTO @rptStatementTable(
				Custid
				,OpeningBalance
			)
			SELECT
				custid
				,SUM(winlost - actual_stake) AS OpeningBalance
			FROM 
				DBTXN.bodb02.dbo.bettrans WITH(NOLOCK)
			WHERE 
				winlostdate = @statementDate
				AND bettype = 20000
				AND srecommend = @srecommend
			GROUP BY custid
			
		END
		ELSE -- winlostdate > CurrentBU_Date
		BEGIN
			-- Opening Balance for Member
			INSERT INTO @rptStatementTable(
				custid
				,OpeningBalance
			)
			SELECT
				custid
				,SUM(winlost - actual_stake + playercomm) AS OpeningBalance
			FROM
				DBTXN.bodb02.dbo.bettrans WITH(NOLOCK)
			WHERE
				ruben = 1
				AND winlostdate >= @BalanceUpDay 
				AND winlostdate < @Winlostdate 
				AND	custid <> recommend
				AND custid <> mrecommend
				AND custid <> srecommend
				AND custid = @Custid
			GROUP BY custid
			
			-- Opening Balance for Agent
			INSERT INTO @rptStatementTable(
				custid
				,OpeningBalance
			)
			SELECT	
				recommend
				,SUM(CASE WHEN custid = recommend THEN winlost - actual_stake ELSE awinlost + comm - playercomm END) AS OpeningBalance
			FROM
				DBTXN.bodb02.dbo.bettrans WITH(NOLOCK)
			WHERE
				ruben = 1 
				AND winlostdate >= @BalanceUpDay 
				AND winlostdate < @Winlostdate 
				AND recommend = @recommend
			GROUP BY recommend

			-- Opening Balance for Master
			INSERT INTO @rptStatementTable(
				custid
				,OpeningBalance
			)
			SELECT
				mrecommend
				,SUM(CASE WHEN custid = mrecommend THEN winlost - actual_stake ELSE mwinlost + acomm - comm END) AS OpeningBalance
			FROM
				DBTXN.bodb02.dbo.bettrans WITH(NOLOCK)
			WHERE
				ruben = 1 
				AND winlostdate >= @BalanceUpDay 
				AND winlostdate < @Winlostdate 
				AND mrecommend = @mrecommend
			GROUP BY mrecommend

			-- Opening Balance for Super
			INSERT INTO @rptStatementTable(
				custid
				,OpeningBalance
			)
			SELECT
				srecommend
				,SUM(CASE WHEN custid = srecommend THEN winlost - actual_stake ELSE swinlost + scomm - acomm END) AS OpeningBalance
			FROM
				DBTXN.bodb02.dbo.bettrans WITH(NOLOCK)
			WHERE
				ruben = 1 
				AND winlostdate >= @BalanceUpDay 
				AND winlostdate < @Winlostdate
				AND srecommend = @srecommend
			GROUP BY srecommend
		END			
		
		
		-- UPDATE data rptStatement
		IF EXISTS(SELECT TOP 1 * FROM rptStatement WITH(NOLOCK) WHERE winlostdate = @statementDate AND custid IN (@Custid, @recommend, @mrecommend, @srecommend))
		BEGIN
			DELETE dbo.rptStatement WITH (ROWLOCK, UPDLOCK) WHERE  winlostdate = @statementDate AND custid IN (@Custid, @recommend, @mrecommend, @srecommend)
		END

		-- INSERT INTO rptStatement
		INSERT INTO dbo.rptStatement(
			Winlostdate
			,Custid
			,OpeningBalance
			,VoidAmt
			,Turnover
			,NetTurnover
			,TransferAmt
			,Winlost
			,Comm
			,ClosingBalance
		)
		SELECT 
			@statementDate
			,tmp.Custid
			,SUM(ISNULL(tmp.Openingbalance, 0)) AS [OpeningBalance]
			,SUM(tmp.Voidamt) AS [VoidAmt]
			,SUM(CASE WHEN tmp.BetCount > 0 THEN tmp.Turnover ELSE NULL END) AS [Turnover]
			,SUM(CASE WHEN tmp.BetCount > 0 THEN tmp.Netturnover ELSE NULL END) AS [NetTurnover]
			,SUM(tmp.Transferamt) AS [TransferAmt]
			,SUM(CASE WHEN tmp.BetCount > 0 THEN tmp.Winlost ELSE NULL END) AS [Winlost]
			,SUM(CASE WHEN tmp.BetCount > 0 THEN tmp.Comm ELSE NULL END) AS [Comm]
			,SUM(ISNULL(tmp.Openingbalance, 0) + ISNULL(tmp.[Winlost], 0) + ISNULL(tmp.[Comm], 0) + ISNULL(tmp.[TransferAmt], 0)) AS ClosingBalance
		FROM 
			@rptStatementTable tmp
		GROUP BY 
			tmp.Custid
		HAVING
			DATEPART(DW,@statementDate)=7
			OR
			(SUM(tmp.BetCount) 
			+ SUM(tmp.TransCount)) <> 0				
END
