USE [Affiliate_12BET]
GO

/*
	Created: 20181001@Percy
	DB: DBAFF12BET.Affiliate_12BET
	Task: Initiliaze member data of Sep 2018 [RedmineID: #102399]
*/

DECLARE @FromDate SMALLDATETIME = '2018-07-01', @ToDate SMALLDATETIME = '2018-07-31'

CREATE TABLE #rptMemberDaily
(
	WinlostDate	SMALLDATETIME,
	AffId		INT,
	IBCCustId	INT,
	ProductId	INT,
	Deposit		MONEY,
	Withdrawal	MONEY,
	Bonus		MONEY,
	Adjustment	MONEY,
	Turnover	MONEY,
	Winloss		MONEY,
	Currency	INT,
	ExRate		FLOAT,
	AffExRate	FLOAT
)

INSERT INTO #rptMemberDaily
(
	WinlostDate,
	AffId,
	IBCCustId,
	ProductId,
	Deposit,
	Withdrawal,
	Bonus,
	Adjustment,
	Turnover,
	Winloss,
	Currency,
	ExRate,
	AffExRate
)
SELECT
	WinlostDate,
	AffId,
	IBCCustId,
	Sporttype AS ProductId,
	0 AS Deposit,
	0 AS Withdrawal,
	0 AS Bonus,
	0 AS Adjustment,
	Turnover,
	Winlost AS Winloss,
	Currency,
	MemberExRate AS ExRate,
	AffExRate
FROM dbo.MemberDaily WITH (NOLOCK)
WHERE Winlostdate BETWEEN @FromDate AND @ToDate
	AND (Turnover <> 0 OR Winlost <> 0)

INSERT INTO #rptMemberDaily
(
	WinlostDate,
	AffId,
	IBCCustId,
	ProductId,
	Deposit,
	Withdrawal,
	Bonus,
	Adjustment,
	Turnover,
	Winloss,
	Currency,
	ExRate,
	AffExRate
)
SELECT
	WinlostDate,
	AffId,
	IBCCustId,
	CASE Sporttype WHEN 1 THEN -1 WHEN 3 THEN -3 END AS ProductId,
	Deposit,
	Withdrawal,
	Bonus,
	Adjustment,
	0 AS Turnover,
	0 AS Winloss,
	Currency,
	MemberExRate AS ExRate,
	AffExRate
FROM dbo.MemberDaily WITH (NOLOCK)
WHERE Winlostdate BETWEEN @FromDate AND @ToDate
	AND (Deposit <> 0 OR Withdrawal <> 0 OR Bonus <> 0 OR Adjustment <> 0)

-- Regen data
;
MERGE dbo.rptMemberDaily AS TARGET
USING #rptMemberDaily AS SOURCE
	ON		TARGET.WinlostDate	= SOURCE.WinlostDate
		AND TARGET.AffId		= SOURCE.AffId
		AND TARGET.IBCCustId	= SOURCE.IBCCustId
		AND TARGET.ProductId	= SOURCE.ProductId
WHEN MATCHED THEN UPDATE
	SET		TARGET.Deposit		= SOURCE.Deposit,
			TARGET.Withdrawal	= SOURCE.Withdrawal,
			TARGET.Bonus		= SOURCE.Bonus,
			TARGET.Adjustment	= SOURCE.Adjustment,
			TARGET.Turnover		= SOURCE.Turnover,
			TARGET.Winloss		= SOURCE.Winloss,
			TARGET.Currency		= SOURCE.Currency,
			TARGET.ExRate		= SOURCE.ExRate,
			TARGET.AffExRate	= SOURCE.AffExRate
WHEN NOT MATCHED BY TARGET THEN INSERT
	(
		WinlostDate,AffId,IBCCustId,ProductId,
		Deposit,Withdrawal,Bonus,Adjustment,
		Turnover,Winloss,Currency,ExRate,AffExRate
	)
	VALUES
	(
		SOURCE.WinlostDate,SOURCE.AffId,SOURCE.IBCCustId,SOURCE.ProductId,
		SOURCE.Deposit,SOURCE.Withdrawal,SOURCE.Bonus,SOURCE.Adjustment,
		SOURCE.Turnover,SOURCE.Winloss,SOURCE.Currency,SOURCE.ExRate,SOURCE.AffExRate
	);

DROP TABLE #rptMemberDaily