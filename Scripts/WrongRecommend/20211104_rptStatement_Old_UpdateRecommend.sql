/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20211104@Percy
	DB: DBRPT-bodb_Report
	Task: Manually correct recommend
*/
USE bodb_Report
GO

DELETE dbo.rptStatement_Old WITH (ROWLOCK, UPDLOCK)
WHERE WinlostDate BETWEEN '2021-10-27' AND '2021-10-28'
	AND CustId IN (56713984, 56713996, 56948071, 56948082) -- recommend

INSERT INTO dbo.rptStatement_Old
(
	WinlostDate,Custid,OpeningBalance,VoidAmt,Turnover,NetTurnover,TransferAmt
	,Winlost,Comm,ClosingBalance,GrandPrize,OpeningTotalBalance
)
SELECT
	WinlostDate,Custid,OpeningBalance,VoidAmt,Turnover,NetTurnover,TransferAmt
	,Winlost,Comm,ClosingBalance,GrandPrize,OpeningTotalBalance
FROM dbo.rptStatement WITH (NOLOCK)
WHERE WinlostDate BETWEEN '2021-10-27' AND '2021-10-28'
	AND CustId IN (56713984, 56713996, 56948071, 56948082) -- recommend