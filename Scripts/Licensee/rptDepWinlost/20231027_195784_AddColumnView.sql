/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20231027@Evan
	DB: DBRPT-bodb_Report
	Task: Add column RawDrawGame, RawTurnOver [Redmine: #195784]
		- Step 2: Alter view
*/


USE bodb_Report
GO

ALTER VIEW [dbo].[rptDepWinlost]
AS
	SELECT m.winlostdate
		 , m.custid
		 , m.currency
		 , m.OpeningBalance
		 , ISNULL(t.Deposit, 0) Deposit
		 , ISNULL(t.Withdrawal, 0) Withdrawal
		 , ISNULL(t.Aff2MemTransfer, 0) Aff2MemTransfer
		 , ISNULL(t.Bonus, 0) Bonus
		 , ISNULL(t.Adjustment, 0) Adjustment
		 , ISNULL(Turnover, 0) Turnover
		 , ISNULL(t.Outstanding, 0) Outstanding
		 , ISNULL(t.Winloss, 0) Winloss
		 , (
		   m.OpeningBalance + ISNULL(t.Deposit, 0) + ISNULL(t.Aff2MemTransfer, 0) - ISNULL(t.Withdrawal, 0)
		   + ISNULL(t.Bonus, 0) + ISNULL(t.Adjustment, 0) - ISNULL(t.Outstanding, 0) + ISNULL(t.Winloss, 0)
		   + ISNULL(t.playercomm, 0) + ISNULL(t.Transfer3rd, 0) + ISNULL(t.Transfer3rdOthers, 0) - ISNULL(t.Comm_Bettrade_Full, 0)
		   + ISNULL(t.Promotion, 0)
		   + ISNULL(b.Bonus, 0) + ISNULL(b.Adjustment, 0)) ClosingBalance
		 , m.recommend
		 , m.mrecommend
		 , m.srecommend
		 , m.actualrate
		 , ISNULL(t.Transfer3rd, 0) Transfer3rd
		 , ISNULL(t.DrawGame, 0) DrawGame
		 , ISNULL(t.Turnover_BA, 0) Turnover_BA
		 , ISNULL(t.Comm_BA, 0) Comm_BA
		 , ISNULL(t.AmountDueTo_BA, 0) AmountDueTo_BA
		 , ISNULL(t.playercomm, 0) playercomm
		 , ISNULL(t.Transfer3rdOthers, 0) Transfer3rdOthers
		 , ISNULL(t.Comm_BetTrade, 0) Comm_BetTrade
		 , ISNULL(t.AmountDueTo_BetTrade, 0) AmountDueTo_BetTrade
		 , ISNULL(b.Bonus, 0) BonusWallet
		 , ISNULL(b.Adjustment, 0) AdjBonusWallet
		 , ISNULL(t.Promotion, 0) AS Promotion
		 , ISNULL(t.RawDrawGame, 0) AS RawDrawGame
		 , ISNULL(t.RawTurnOver, 0) AS RawTurnOver
	FROM dbo.rptDepWinlost_Main m WITH (NOLOCK)
		LEFT JOIN dbo.rptDepWinlost_Trans t WITH (NOLOCK) ON m.custid = t.custid
			AND m.winlostdate = t.winlostdate
			AND t.Sporttype = -1
			AND t.PartnerID = -1
		LEFT JOIN dbo.rptDepWinlost_BonusWallet b WITH (NOLOCK) ON m.custid = b.custid
			AND m.winlostdate = b.winlostdate -- New Bonus Wallet  

GO

ALTER VIEW [dbo].[rptDepWinlostByProduct]
AS
	SELECT t.Winlostdate
		 , t.CustID
		 , t.SportType
		 , t.Turnover
		 , t.DrawGame AS drawTO
		 , t.Winloss AS winlost
		 , t.playercomm
		 , t.BetCount
		 , t.OutStanding
		 , m.currency
		 , t.RawDrawGame 
		 , t.RawTurnOver 
	FROM rptDepWinlost_Trans t WITH (NOLOCK)
		INNER JOIN rptDepWinlost_Main m WITH (NOLOCK) ON t.CustID = m.CustID
			AND t.Winlostdate = m.Winlostdate
	WHERE t.SportType != -1
		AND t.PartnerID = -1

GO