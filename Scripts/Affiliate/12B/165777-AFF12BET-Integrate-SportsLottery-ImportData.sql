/*<info serverAlias="DBAFF12BET-Affiliate_12BET"></info>*/
/*
	Created: 20211207@Percy
	DB: DBAFF12BET-Affiliate_12BET
	Task: Manually import Sports Lottery data from 01 Jan 2022 to 12 Jan 2022
*/
USE Affiliate_12BET
GO

-- 35 row(s) affected
INSERT INTO dbo.rptMemberDaily (
	WinlostDate,AffId,IBCCustId,ProductId,Deposit,Withdrawal,Bonus
	,Adjustment,Turnover,Winloss,Currency,ExRate,AffExRate,AWinloss,AComm
)
SELECT
	r.WinlostDate,mi.AffId,mi.IBCCustId,33 AS ProductId,0 AS Deposit,0 AS Withdrawal,0 AS Bonus
	,0 AS Adjustment,SUM(Turnover),SUM(Winlost),mi.Currency,e.ActualRate,e.ActualRate2,0 AS AWinloss,0 AS AComm
FROM bodb_LicenseeReport.dbo.rptLicWinloss2 r WITH (NOLOCK)
	INNER JOIN dbo.MemberInfo mi WITH (NOLOCK) ON r.custid = mi.IBCCustId
	CROSS APPLY dbo.Aff_f_ExchangeRateById_Sel(mi.currency, r.WinlostDate) e
WHERE WinlostDate BETWEEN '2022-01-01' AND '2022-01-12'
	AND StatusId IN (111, 112, 113, 114, 115)
	AND SportType = 169 AND BetType = 0 -- Sports Lottery
	AND NOT EXISTS (
		SELECT 1 FROM dbo.MemberRemoval mr WITH (NOLOCK)
		WHERE mr.RemovedDate < '2022-02-01'
			AND mr.IBCCustId = mi.IBCCustId
		)
GROUP BY r.WinlostDate,mi.AffId,mi.IBCCustId,mi.Currency,e.ActualRate,e.ActualRate2
